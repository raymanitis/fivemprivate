local Config = require 'sellshop/config'
local ox_inventory = exports.ox_inventory

-- Security tracking
local playerSessions = {}
local playerCooldowns = {}
local playerTransactionCounts = {}
local lastTransactionTime = {}

-- Use security config from config file
local SECURITY_CONFIG = Config.Security

local function handleCheater(playerId, reason)
    if SECURITY_CONFIG.ENABLE_DISCORD_LOGGING then
        sendToDiscord(
                "Suspicious Activity Detected",
                ("**Player:** %s (%d)\n**Reason:** %s\n**Action:** Warning sent (no ban)"):format(GetPlayerName(playerId), playerId, reason),
                16776960 -- Yellow color for warnings
        )
    end

    -- REMOVED: No more automatic banning
    -- if SECURITY_CONFIG.ENABLE_EXPLOIT_BANNING then
    -- exports.qbx_core:ExploitBan(playerId, reason)
    -- end
end

local function isPlayerNearShop(playerId, shopIndex)
    local playerPed = GetPlayerPed(playerId)
    if not playerPed or playerPed == 0 then return false end

    local playerCoords = GetEntityCoords(playerPed)
    local shopCoords = Config.Shops[shopIndex].coords

    local distance = #(playerCoords - vector3(shopCoords.x, shopCoords.y, shopCoords.z))
    return distance <= SECURITY_CONFIG.MAX_DISTANCE
end

local function checkCooldown(playerId)
    local currentTime = GetGameTimer()
    local lastTime = lastTransactionTime[playerId] or 0

    if currentTime - lastTime < SECURITY_CONFIG.COOLDOWN_TIME then
        return false, "Please wait before making another transaction."
    end

    return true
end

local function checkRateLimit(playerId)
    local currentTime = GetGameTimer()
    local minuteAgo = currentTime - 60000

    -- Clean old transactions
    if not playerTransactionCounts[playerId] then
        playerTransactionCounts[playerId] = {}
    end

    for i = #playerTransactionCounts[playerId], 1, -1 do
        if playerTransactionCounts[playerId][i] < minuteAgo then
            table.remove(playerTransactionCounts[playerId], i)
        end
    end

    -- Check if player has exceeded rate limit
    if #playerTransactionCounts[playerId] >= SECURITY_CONFIG.MAX_TRANSACTIONS_PER_MINUTE then
        return false, "Too many transactions. Please wait a moment."
    end

    return true
end

local function validateSession(playerId, shopIndex)
    local session = playerSessions[playerId]
    if not session then
        return false, "Invalid session. Please open the shop menu again."
    end

    if session.shopIndex ~= shopIndex then
        return false, "Session mismatch. Please open the shop menu again."
    end

    local currentTime = GetGameTimer()
    if currentTime - session.startTime > SECURITY_CONFIG.SESSION_TIMEOUT then
        playerSessions[playerId] = nil
        return false, "Session expired. Please open the shop menu again."
    end

    return true
end

local function validateTransaction(playerId, itemName, quantity, price, shopIndex)
    -- Basic validation
    if not itemName or not quantity or not price or not shopIndex then
        return false, "Invalid transaction parameters."
    end

    if quantity <= 0 or quantity > SECURITY_CONFIG.MAX_QUANTITY_PER_TRANSACTION then
        return false, "Invalid quantity."
    end

    if price <= 0 then
        return false, "Invalid price."
    end

    local totalValue = quantity * price
    if totalValue > SECURITY_CONFIG.MAX_VALUE_PER_TRANSACTION then
        return false, "Transaction value too high."
    end

    -- Check if it's a weapon
    local isWeapon = itemName:sub(1, 7) == "weapon_"

    -- Debug logging
    print(('[SellShop] Validating transaction - Player: %s, Item: %s, IsWeapon: %s, Shop: %s'):format(playerId, itemName, tostring(isWeapon), tostring(shopIndex)))

    if isWeapon then
        -- For weapons, just validate against the shop config (don't check ox_inventory items)
        local validItem, expectedPrice = false, nil
        local shop = Config.Shops[shopIndex]

        if not shop then
            print(('[SellShop] Invalid shop index: %s'):format(shopIndex))
            return false, "Invalid shop."
        end

        -- Debug: Print all items in the shop
        print(('[SellShop] Shop %s items:'):format(shopIndex))
        for _, option in ipairs(shop.dialog.options) do
            if option.items then
                for _, item in ipairs(option.items) do
                    print(('  - %s (price: %s)'):format(item.name, tostring(item.price)))
                    if item.name == itemName then
                        validItem = true
                        expectedPrice = item.price
                        print(('[SellShop] Found matching item: %s, expected price: %s'):format(item.name, tostring(expectedPrice)))
                        break
                    end
                end
            end
        end

        if not validItem then
            print(('[SellShop] Player %s tried to sell unlisted weapon: %s'):format(playerId, tostring(itemName)))
            return false, 'Invalid weapon.'
        end

        if price ~= expectedPrice then
            print(('[SellShop] Player %s weapon price mismatch: sent %s, expected %s for %s'):format(playerId, tostring(price), tostring(expectedPrice), tostring(itemName)))
            return false, 'Transaction failed (price mismatch).'
        end
    else
        -- For regular items, validate against Config.Shops
        local validItem, expectedPrice = false, nil
        local shop = Config.Shops[shopIndex]

        if not shop then
            return false, "Invalid shop."
        end

        for _, option in ipairs(shop.dialog.options) do
            if option.items then
                for _, item in ipairs(option.items) do
                    if item.name == itemName then
                        validItem = true
                        expectedPrice = item.price
                        break
                    end
                end
            end
        end

        if not validItem then
            print(('[SellShop] Player %s tried to sell unlisted item: %s'):format(playerId, tostring(itemName)))
            return false, 'Invalid item.'
        end

        if price ~= expectedPrice then
            print(('[SellShop] Player %s price mismatch: sent %s, expected %s for %s'):format(playerId, tostring(price), tostring(expectedPrice), tostring(itemName)))
            return false, 'Transaction failed (price mismatch).'
        end
    end

    print(('[SellShop] Validation successful for %s'):format(itemName))
    return true
end

-- Event to start a shop session
RegisterNetEvent('atleast-sellshop:startSession', function(shopIndex)
    local playerId = source

    if not shopIndex or not Config.Shops[shopIndex] then
        print(('[SellShop] Player %s tried to access invalid shop index: %s'):format(playerId, tostring(shopIndex)))
        return
    end

    if not isPlayerNearShop(playerId, shopIndex) then
        print(('[SellShop] Player %s not near shop %s'):format(playerId, tostring(shopIndex)))
        return
    end

    playerSessions[playerId] = {
        shopIndex = shopIndex,
        startTime = GetGameTimer()
    }
end)

lib.callback.register('atleast-sellshop:processTransaction', function(source, itemName, quantity, price, shopIndex)
    local playerId = source
    local totalPrice = quantity * price

    -- Security checks
    local cooldownOk, cooldownMsg = checkCooldown(playerId)
    if not cooldownOk then
        return false, cooldownMsg
    end

    local rateOk, rateMsg = checkRateLimit(playerId)
    if not rateOk then
        return false, rateMsg
    end

    local sessionOk, sessionMsg = validateSession(playerId, shopIndex)
    if not sessionOk then
        return false, sessionMsg
    end

    local validationOk, validationMsg = validateTransaction(playerId, itemName, quantity, price, shopIndex)
    if not validationOk then
        return false, validationMsg
    end

    if not isPlayerNearShop(playerId, shopIndex) then
        print(('[SellShop] Player %s not near shop during transaction'):format(playerId))
        return false, 'You must be near the shop to sell items.'
    end

    -- Weapon-aware inventory check and removal
    local isWeapon = itemName:sub(1, 7) == "weapon_"
    local hasEnough = false

    if isWeapon then
        -- Attempt removal iteratively across possible representations
        local lowerName = itemName:lower()
        local shortLower = lowerName:gsub('weapon_', '')
        local remaining = quantity

        print(('[SellShop] Weapon sale request: %s x%d'):format(itemName, quantity))

        local function removeOneWeapon()
            -- Try weapons list first
            local allWeapons = ox_inventory:Search(playerId, 'weapons') or {}
            print(('[SellShop] Weapons in inventory: %d'):format(#allWeapons))
            for _, entry in ipairs(allWeapons) do
                local entryNameLower = tostring(entry.name or ''):lower()
                print(('[SellShop]   Found weapon entry name=%s slot=%s'):format(tostring(entry.name), tostring(entry.slot)))
                if entryNameLower == lowerName or entryNameLower == shortLower then
                    -- Remove using configured item name with slot specificity (ox expects lowercase item id)
                    local removed = ox_inventory:RemoveItem(playerId, lowerName, 1, nil, entry.slot)
                    print(('[SellShop]   Removing weapon by slot: name=%s slot=%s result=%s'):format(tostring(entry.name), tostring(entry.slot), json.encode(removed)))
                    if removed and (type(removed) ~= 'table' or #removed > 0) then
                        return true
                    end
                end
            end

            -- Try as normal item names: prefer exact lower, then short lower
            local variants = { lowerName, shortLower }
            for _, variant in ipairs(variants) do
                local removed = ox_inventory:RemoveItem(playerId, variant, 1)
                print(('[SellShop]   Removing as normal item: name=%s result=%s'):format(tostring(variant), json.encode(removed)))
                if removed and (type(removed) ~= 'table' or #removed > 0) then
                    return true
                end
            end

            return false
        end

        local removedCount = 0
        while remaining > 0 do
            if not removeOneWeapon() then
                break
            end
            remaining = remaining - 1
            removedCount = removedCount + 1
        end

        print(('[SellShop] Weapon removal summary: requested=%d removed=%d'):format(quantity, removedCount))

        if removedCount < quantity then
            return false, ("You don't have enough %s !"):format(itemName)
        end
    else
        local currentCount = ox_inventory:Search(playerId, 'count', itemName) or 0
        hasEnough = currentCount >= quantity
        if not hasEnough then
            return false, ("You don't have enough %s !"):format(itemName)
        end

        local removedItems = ox_inventory:RemoveItem(playerId, itemName, quantity)
        if not removedItems or (type(removedItems) == "table" and #removedItems == 0) then
            print(('[SellShop] Item removal failed for player %s, item: %s'):format(playerId, itemName))
            return false, 'Transaction failed.'
        end
    end

    -- Get money type from shop config
    local shop = Config.Shops[shopIndex]
    local moneyType = shop.moneyType or 'cash' -- Default to cash if not specified
    ox_inventory:AddItem(playerId, moneyType, totalPrice)

    -- Update security tracking
    lastTransactionTime[playerId] = GetGameTimer()
    table.insert(playerTransactionCounts[playerId], GetGameTimer())

    -- Log
    if SECURITY_CONFIG.ENABLE_DISCORD_LOGGING then
        sendToDiscord(
                "Item Sold",
                ("**Player:** %s (%d)\n**Item:** %s\n**Quantity:** %d\n**Total Price:** $%d\n**Shop:** %s"):format(
                        GetPlayerName(playerId), playerId, itemName, quantity, totalPrice, Config.Shops[shopIndex].dialog.title
                ),
                65280 -- green
        )
    end

    local moneyTypeText = shop.moneyType or 'cash'
    return true, ('You sold %d %s(s) for $%d (%s)'):format(quantity, itemName, totalPrice, moneyTypeText)
end)

lib.callback.register('atleast-sellshop:sellAllItems', function(source, items, shopIndex)
    local playerId = source
    local totalValue = 0
    local soldItems = {}
    local validItems = {}

    -- Security checks
    local cooldownOk, cooldownMsg = checkCooldown(playerId)
    if not cooldownOk then
        return false, cooldownMsg
    end

    local rateOk, rateMsg = checkRateLimit(playerId)
    if not rateOk then
        return false, rateMsg
    end

    local sessionOk, sessionMsg = validateSession(playerId, shopIndex)
    if not sessionOk then
        return false, sessionMsg
    end

    if not isPlayerNearShop(playerId, shopIndex) then
        print(('[SellShop] Player %s not near shop during bulk transaction'):format(playerId))
        return false, 'You must be near the shop to sell items.'
    end

    -- Validate all items first
    local shop = Config.Shops[shopIndex]
    if not shop then
        return false, "Invalid shop."
    end

    for _, option in ipairs(shop.dialog.options) do
        if option.items then
            for _, item in ipairs(option.items) do
                validItems[item.name] = item.price
            end
        end
    end

    -- Process each item
    for _, item in ipairs(items) do
        if validItems[item.name] then
            local isWeapon = item.name:sub(1, 7) == "weapon_"
            if isWeapon then
                -- Count matching weapons and also consider normal item variants
                local allWeapons = ox_inventory:Search(playerId, 'weapons') or {}
                local lowerName = item.name:lower()
                local upperName = item.name:upper()
                local shortLower = lowerName:gsub('weapon_', '')
                local shortUpper = upperName:gsub('WEAPON_', '')

                local matchCount = 0
                for _, entry in ipairs(allWeapons) do
                    local entryNameLower = tostring(entry.name or ''):lower()
                    if entryNameLower == lowerName or entryNameLower == upperName:lower() or entryNameLower == shortLower or entryNameLower == shortUpper:lower() then
                        matchCount = matchCount + 1
                    end
                end

                -- Also include normal items matching variants
                local nameVariants = { item.name, lowerName, upperName, shortLower, shortUpper }
                local normalCount = 0
                for _, variant in ipairs(nameVariants) do
                    local c = ox_inventory:Search(playerId, 'count', variant) or 0
                    if type(c) == 'table' then c = #c end
                    normalCount = normalCount + (tonumber(c) or 0)
                end

                local totalCount = math.max(matchCount, normalCount)
                if totalCount > 0 then
                    local itemTotal = totalCount * item.price
                    totalValue = totalValue + itemTotal
                    table.insert(soldItems, {
                        name = item.name,
                        count = totalCount,
                        price = item.price,
                        total = itemTotal,
                        isWeapon = true
                    })
                end
            else
                local currentCount = ox_inventory:Search(playerId, 'count', item.name) or 0
                if currentCount > 0 then
                    local itemTotal = currentCount * item.price
                    totalValue = totalValue + itemTotal
                    table.insert(soldItems, {
                        name = item.name,
                        count = currentCount,
                        price = item.price,
                        total = itemTotal,
                        isWeapon = false
                    })
                end
            end
        end
    end

    if totalValue == 0 then
        return false, 'No valid items to sell.'
    end

    if totalValue > SECURITY_CONFIG.MAX_VALUE_PER_TRANSACTION then
        return false, 'Transaction value too high.'
    end

    -- Remove all items and add money
    for _, item in ipairs(soldItems) do
        if item.isWeapon then
            -- Iteratively remove each unit via slot or normal item fallback
            local lowerName = item.name:lower()
            local shortLower = lowerName:gsub('weapon_', '')
            local remaining = item.count

            local function removeOneWeapon()
                local allWeapons = ox_inventory:Search(playerId, 'weapons') or {}
                for _, entry in ipairs(allWeapons) do
                    local entryNameLower = tostring(entry.name or ''):lower()
                    if entryNameLower == lowerName or entryNameLower == shortLower then
                        -- Remove using configured item name with slot specificity (ox expects lowercase item id)
                        local removed = ox_inventory:RemoveItem(playerId, lowerName, 1, nil, entry.slot)
                        if removed and (type(removed) ~= 'table' or #removed > 0) then
                            return true
                        end
                    end
                end
                local variants = { lowerName, shortLower }
                for _, variant in ipairs(variants) do
                    local removed = ox_inventory:RemoveItem(playerId, variant, 1)
                    if removed and (type(removed) ~= 'table' or #removed > 0) then
                        return true
                    end
                end
                return false
            end

            while remaining > 0 do
                if not removeOneWeapon() then
                    return false, 'Could not remove weapon from inventory. Please try again or contact staff.'
                end
                remaining = remaining - 1
            end
        else
            local removedItems = ox_inventory:RemoveItem(playerId, item.name, item.count)
            if not removedItems or (type(removedItems) == "table" and #removedItems == 0) then
                print(('[SellShop] Item removal failed during sell all for player %s, item: %s'):format(playerId, item.name))
                return false, 'Transaction failed.'
            end
        end
    end

    -- Get money type from shop config
    local shop = Config.Shops[shopIndex]
    local moneyType = shop.moneyType or 'cash' -- Default to cash if not specified
    ox_inventory:AddItem(playerId, moneyType, totalValue)

    -- Update security tracking
    lastTransactionTime[playerId] = GetGameTimer()
    playerTransactionCounts[playerId] = playerTransactionCounts[playerId] or {}
    table.insert(playerTransactionCounts[playerId], GetGameTimer())

    -- Log the transaction
    if SECURITY_CONFIG.ENABLE_DISCORD_LOGGING then
        local itemList = ''
        for _, item in ipairs(soldItems) do
            itemList = itemList .. string.format('%s x%d ($%d), ', item.name, item.count, item.total)
        end

        sendToDiscord(
                "Bulk Items Sold",
                ("**Player:** %s (%d)\n**Items:** %s\n**Total Price:** $%d\n**Shop:** %s"):format(
                        GetPlayerName(playerId), playerId, itemList:sub(1, -3), totalValue, shop.dialog.title
                ),
                65280 -- green
        )
    end

    local moneyTypeText = shop.moneyType or 'cash'
    return true, ('You sold all items for $%d (%s)'):format(totalValue, moneyTypeText)
end)

-- Clean up sessions when player disconnects
AddEventHandler('playerDropped', function()
    local playerId = source
    playerSessions[playerId] = nil
    playerCooldowns[playerId] = nil
    playerTransactionCounts[playerId] = nil
    lastTransactionTime[playerId] = nil
end)

-- Periodic cleanup of old data
CreateThread(function()
    while true do
        Wait(300000) -- Every 5 minutes

        local currentTime = GetGameTimer()

        -- Clean up old sessions
        for playerId, session in pairs(playerSessions) do
            if currentTime - session.startTime > SECURITY_CONFIG.SESSION_TIMEOUT then
                playerSessions[playerId] = nil
            end
        end

        -- Clean up old transaction counts
        for playerId, transactions in pairs(playerTransactionCounts) do
            for i = #transactions, 1, -1 do
                if transactions[i] < currentTime - 60000 then
                    table.remove(transactions, i)
                end
            end
        end
    end
end)

function sendToDiscord(title, description, color)
    local embed = { {
                        ["title"] = title,
                        ["description"] = description,
                        ["color"] = color or 16777215,
                        ["footer"] = {
                            ["text"] = os.date("%Y-%m-%d %H:%M:%S")
                        }
                    } }

    PerformHttpRequest('https://discord.com/api/webhooks/1401741142059384853/ZFj-2K3YOWx4A8fUr2cGUSWsuCqzGzUSm33NwyrwRMRHMCDlRKXUMtDVqnI9fomnag3P',
            function(err, text, headers) end,
            'POST',
            json.encode({ username = 'Shop Logs', embeds = embed }),
            { ['Content-Type'] = 'application/json' }
    )
end
