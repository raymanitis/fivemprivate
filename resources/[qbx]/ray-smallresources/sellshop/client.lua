local Config = require 'sellshop/config'
local ox_inventory = exports.ox_inventory

-- Track current shop session
local currentShopIndex = nil

local function calculateTotalValue(items)
    local totalValue = 0
    local itemList = {}
    
    for _, item in ipairs(items) do
        local isWeapon = item.name:sub(1, 7) == "weapon_"
        local itemCount
        
        if isWeapon then
            -- Try multiple approaches for weapon detection
            local weaponCount = 0
            
            -- Method 1: Try count search
            local countResult = exports.ox_inventory:Search('count', item.name)
            if type(countResult) == 'number' then
                weaponCount = countResult
            elseif type(countResult) == 'table' then
                weaponCount = #countResult
            end
            
            -- Method 2: Try weapons search
            local weapons = exports.ox_inventory:Search('count', item.name)
            local weaponSearchCount = weapons
            
            -- Method 3: Try without 'weapon_' prefix
            local shortName = item.name:gsub('weapon_', '')
            local shortCountResult = exports.ox_inventory:Search('count', shortName)
            local shortCount = 0
            if type(shortCountResult) == 'number' then
                shortCount = shortCountResult
            elseif type(shortCountResult) == 'table' then
                shortCount = #shortCountResult
            end
            
            -- Method 4: Try uppercase version
            local upperCountResult = exports.ox_inventory:Search('count', item.name:upper())
            local upperCount = 0
            if type(upperCountResult) == 'number' then
                upperCount = upperCountResult
            elseif type(upperCountResult) == 'table' then
                upperCount = #upperCountResult
            end
            
            itemCount = math.max(weaponCount, weaponSearchCount, shortCount, upperCount)
            
            -- Only add to itemList if we have items
            if itemCount and itemCount > 0 then
                local itemTotal = itemCount * item.price
                totalValue = totalValue + itemTotal
                table.insert(itemList, {
                    name = item.name,
                    count = itemCount,
                    price = item.price,
                    total = itemTotal
                })
            end
        else
            itemCount = exports.ox_inventory:Search('count', item.name) or 0
            if itemCount and itemCount > 0 then
                local itemTotal = itemCount * item.price
                totalValue = totalValue + itemTotal
                table.insert(itemList, {
                    name = item.name,
                    count = itemCount,
                    price = item.price,
                    total = itemTotal
                })
            end
        end
    end
    
    return totalValue, itemList
end

local function openSellAllConfirmation(items)
    local totalValue, itemList = calculateTotalValue(items)
    
    if totalValue == 0 then
        lib.notify({
            title = 'No Items',
            description = 'You don\'t have any items to sell.',
            type = 'error',
        })
        return
    end

    local itemText = ''
    for i, item in ipairs(itemList) do
        if i > 1 then
            itemText = itemText .. ' | '
        end
        itemText = itemText .. string.format('%s (%dx) : $%d', item.name, item.count, item.total)
    end

    local alert = lib.alertDialog({
        header = 'Sell All Items',
        content = string.format('Are you sure you want to sell all items?\n\n%s\n\nTotal: $%d', itemText, totalValue),
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Sell All',
            cancel = 'Cancel'
        }
    })

    if alert == 'confirm' then
        lib.callback('atleast-sellshop:sellAllItems', false, function(success, message)
            if success then
                lib.notify({
                    title = 'Transaction Successful',
                    description = message,
                    type = 'success',
                })
            else
                lib.notify({
                    title = 'Transaction Failed',
                    description = message,
                    type = 'error',
                })
            end
        end, items, currentShopIndex)
    end
end

local function openSellMenu(items)
    local menu = {}
    local globalItems = exports.ox_inventory:Items()

    table.insert(menu, {
        title = "Sell All Items",
        description = "Sell all items you have in your inventory",
        icon = "fas fa-coins",
        onSelect = function()
            openSellAllConfirmation(items)
        end,
    })

    for _, item in ipairs(items) do
        local isWeapon = item.name:sub(1, 7) == "weapon_"
        local itemCount
        local itemLabel = item.label or item.name
        
        -- Debug logging
        print(('[SellShop] Processing item: %s, isWeapon: %s'):format(item.name, tostring(isWeapon)))
        
        if isWeapon then
            -- Try multiple approaches for weapon detection
            local weaponCount = 0
            
            -- Method 1: Try count search
            local countResult = exports.ox_inventory:Search('count', item.name)
            if type(countResult) == 'number' then
                weaponCount = countResult
            elseif type(countResult) == 'table' then
                weaponCount = #countResult
            end
            
            -- Method 2: Try weapons search
            local weapons = exports.ox_inventory:Search('weapons', item.name) or {}
            local weaponSearchCount = #weapons
            
            -- Method 3: Try without 'weapon_' prefix
            local shortName = item.name:gsub('weapon_', '')
            local shortCountResult = exports.ox_inventory:Search('count', shortName)
            local shortCount = 0
            if type(shortCountResult) == 'number' then
                shortCount = shortCountResult
            elseif type(shortCountResult) == 'table' then
                shortCount = #shortCountResult
            end
            
            -- Method 4: Try uppercase version
            local upperCountResult = exports.ox_inventory:Search('count', item.name:upper())
            local upperCount = 0
            if type(upperCountResult) == 'number' then
                upperCount = upperCountResult
            elseif type(upperCountResult) == 'table' then
                upperCount = #upperCountResult
            end
            
            itemCount = math.max(weaponCount, weaponSearchCount, shortCount, upperCount)
            
            print(('[SellShop] Weapon %s - Count: %d, Weapon search: %d, Short name: %d, Upper: %d, Final: %d'):format(item.name, weaponCount, weaponSearchCount, shortCount, upperCount, itemCount))
            print(('[SellShop] Count result type: %s, Weapons array: %s'):format(type(countResult), json.encode(weapons)))
            
            -- For weapons, use the label from config since they're not in globalItems
            table.insert(menu, {
                title = itemLabel .. " ($" .. item.price .. " each)",
                description = "You have " .. itemCount .. " " .. itemLabel,
                icon = "nui://ox_inventory/web/images/" .. item.name .. ".png",
                onSelect = function()
                    if itemCount > 0 then
                        local input = lib.inputDialog("Sell " .. itemLabel, {
                            {
                                type = "slider",
                                label = "Quantity to sell",
                                min = 1,
                                max = itemCount,
                            },
                        })

                        if input and tonumber(input[1]) > 0 then
                            local quantityToSell = tonumber(input[1])
                            
                            -- Double-check the quantity is valid
                            if quantityToSell > itemCount then
                                lib.notify({
                                    title = 'Invalid Quantity',
                                    description = 'You don\'t have enough ' .. itemLabel .. ' to sell.',
                                    type = 'error',
                                })
                                return
                            end

                            lib.callback('atleast-sellshop:processTransaction', false, function(success, message)
                                if success then
                                    lib.notify({
                                        title = 'Transaction Successful',
                                        description = message,
                                        type = 'success',
                                    })
                                else
                                    lib.notify({
                                        title = 'Transaction Failed',
                                        description = message,
                                        type = 'error',
                                    })
                                end
                            end, item.name, quantityToSell, item.price, currentShopIndex)
                        else
                            lib.notify({
                                title = 'Invalid Input',
                                description = 'Please select a valid quantity.',
                                type = 'error',
                            })
                        end
                    else
                        lib.notify({
                            title = 'No Items',
                            description = 'You don\'t have any ' .. itemLabel .. ' to sell.',
                            type = 'error',
                        })
                    end
                end,
            })
        else
            local itemData = globalItems[item.name]
            if itemData == nil then
                print(item.name .. " was a nil value, not adding to list.")
                -- skip this item, do not return
            else
                itemCount = exports.ox_inventory:Search('count', item.name) or 0
                print(('[SellShop] Regular item %s found: %d in inventory'):format(item.name, itemCount))
                table.insert(menu, {
                    title = itemData.label .. " ($" .. item.price .. " each)",
                    description = "You have " .. itemCount .. " " .. itemData.label,
                    icon = "nui://ox_inventory/web/images/" .. item.name .. ".png",
                    onSelect = function()
                        if itemCount > 0 then
                            local input = lib.inputDialog("Sell " .. itemData.label, {
                                {
                                    type = "slider",
                                    label = "Quantity to sell",
                                    min = 1,
                                    max = itemCount,
                                },
                            })

                            if input and tonumber(input[1]) > 0 then
                                local quantityToSell = tonumber(input[1])

                                lib.callback('atleast-sellshop:processTransaction', false, function(success, message)
                                    if success then
                                        lib.notify({
                                            title = 'Transaction Successful',
                                            description = message,
                                            type = 'success',
                                        })
                                    else
                                        lib.notify({
                                            title = 'Transaction Failed',
                                            description = message,
                                            type = 'error',
                                        })
                                    end
                                end, item.name, quantityToSell, item.price, currentShopIndex)
                            else
                                lib.notify({
                                    title = 'Invalid Input',
                                    description = 'Please select a valid quantity.',
                                    type = 'error',
                                })
                            end
                        else
                            lib.notify({
                                title = 'No Items',
                                description = 'You don\'t have any ' .. itemData.label .. ' to sell.',
                                type = 'error',
                            })
                        end
                    end,
                })
            end
        end
    end

    lib.registerContext({
        id = "sell_menu",
        title = "Sell Items",
        options = menu,
    })

    lib.showContext("sell_menu")
end

local function handleDialogOption(option)
    if option.items then
        openSellMenu(option.items)
    end
end

local function openShopDialogue(shop, ped, shopIndex)
    -- Start a new session with the server
    TriggerServerEvent('atleast-sellshop:startSession', shopIndex)
    currentShopIndex = shopIndex
    
    local options = {}

    for _, option in ipairs(shop.dialog.options) do
        table.insert(options, {
            id = option.id,
            label = option.label,
            icon = option.icon,
            close = option.close,
            action = function()
                handleDialogOption(option)
            end,
        })
    end

    exports.mt_lib:showDialogue({
        ped = ped,
        label = shop.dialog.title,
        speech = shop.dialog.greeting,
        options = options,
    })
end

CreateThread(function()
    for shopIndex, shop in pairs(Config.Shops) do
        local pedModel = GetHashKey(shop.npcModel)

        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(500)
        end

        local ped = CreatePed(4, pedModel, shop.coords.x, shop.coords.y, shop.coords.z - 1, shop.coords.w, false, true)

        if DoesEntityExist(ped) then
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_IMPATIENT', 0, true)

            -- Passive behavior to prevent aggression
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetPedCanRagdoll(ped, false)
            SetPedConfigFlag(ped, 287, true) -- Disable being scared
            SetPedConfigFlag(ped, 209, true) -- Prevent attacks on hit
            SetPedConfigFlag(ped, 208, true) -- Prevent fight back

            exports.ox_target:addLocalEntity(ped, {
                {
                    label = 'Talk to ' .. shop.dialog.title,
                    icon = 'fas fa-comments',
                    distance = 2.0,
                    onSelect = function()
                        openShopDialogue(shop, ped, shopIndex)
                    end,
                },
            })

            -- Blip logic
            if shop.blip and shop.blip.enabled then
                local blip = AddBlipForCoord(shop.coords.x, shop.coords.y, shop.coords.z)
                SetBlipSprite(blip, shop.blip.sprite)
                SetBlipColour(blip, shop.blip.color)
                SetBlipScale(blip, shop.blip.scale)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(shop.blip.name)
                EndTextCommandSetBlipName(blip)
            end
        else
            print('Failed to create ped for shop "' .. shop.dialog.title .. '". Check model and coordinates.')
        end

        SetModelAsNoLongerNeeded(pedModel)
    end
end)

-- Clear session when player dies or respawns
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        currentShopIndex = nil
    end
end)

-- Clear session when player dies
AddEventHandler('gameEventTriggered', function(name, data)
    if name == 'CEventNetworkEntityDamage' then
        local victim = data[1]
        local attacker = data[2]
        local isDead = data[4]
        local isPlayer = data[5]
        
        if isPlayer and isDead and victim == PlayerPedId() then
            currentShopIndex = nil
        end
    end
end)
