-- START CREATEITEM/GIVEMONEY --
local playerItemCount = {}
local logBypass = {}
local function resetItemCount(playerId)
    if playerId then
        playerItemCount[playerId] = { count = 0, lastTime = os.time(), items = {} }
    end
end
local function sendToDiscord(webhook, embed)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ embeds = { embed } }), { ['Content-Type'] = 'application/json' })
end
RegisterServerEvent('atleast:log:bypass', function()
    local src = source
    logBypass[src] = true
    SetTimeout(100, function()
        logBypass[src] = nil
    end)
end)
--local hookId = exports.ox_inventory:registerHook('createItem', function(payload)
--    local playerId = payload.inventoryId
--    if logBypass[playerId] then return true end
--    local currentTime = os.time()
--    local itemName = payload.item.name
--    local itemCount = payload.count
--    if playerId then
--        if not playerItemCount[playerId] then
--            resetItemCount(playerId)
--        end
--        local playerData = playerItemCount[playerId]
--        if currentTime - playerData.lastTime >= 1 then
--            resetItemCount(playerId)
--        end
--        playerData.count = playerData.count + itemCount
--        playerData.lastTime = currentTime
--        table.insert(playerData.items, { name = itemName, count = itemCount })
--        if playerData.count > 5 then
--            local playerName = GetPlayerName(playerId)
--            local identifiers = GetPlayerIdentifiers(playerId)
--            local steam
--            for _, id in pairs(identifiers) do
--                if string.match(id, "steam:") then
--                    steam = id
--                    break
--                end
--            end
--            local exactTime = os.date("%Y-%m-%d %H:%M:%S", currentTime)
--            local itemList = ""
--            for _, item in ipairs(playerData.items) do
--                itemList = itemList .. string.format("%s x%d\n", item.name, item.count)
--            end
--            local embed = {
--                title = "Potential Cheating Detected",
--                description = string.format("[ID: %s] %s has triggered an alert.\nSteam: %s\n\n**Items Given:**\n%s",
--                        tonumber(playerId), playerName, steam or "N/A", itemList),
--                color = 15158332,
--                footer = { text = string.format("ATLEAST RP | %s", exactTime) }
--            }
--            sendToDiscord('https://discord.com/api/webhooks/1358247782699237416/wxZaRbkDDLOjH9QjaaZ-PujLL666tJgYkzZn1MBoLlZ0uFLZb5x50F0P8dKXWZ3NmLX_', embed)
--            resetItemCount(playerId)
--        end
--    end
--    return true
--end, {})
RegisterNetEvent('atleast:givemoney', function(amount, reason)
    local src = source
    if logBypass[src] then return end
    if amount >= 10000 then
        local name = GetPlayerName(src)
        local time = os.date("%Y-%m-%d %H:%M:%S", os.time())
        local embed = {
            title = "Large Money Given",
            description = string.format("**%s** (ID: %d) received **$%s**.\nReason: %s", name, src, amount, reason or "N/A"),
            color = 3447003,
            footer = { text = "ATLEAST RP | " .. time }
        }
        sendToDiscord('https://discord.com/api/webhooks/1358247782699237416/wxZaRbkDDLOjH9QjaaZ-PujLL666tJgYkzZn1MBoLlZ0uFLZb5x50F0P8dKXWZ3NmLX_', embed)
    end
end)
-- END CREATEITEM/GIVEMONEY --

-- START SHOP LOGS --
local webhooks = {
    -- PoliceArmory = 'https://discord.com/api/webhooks/1381650620976463995/_sny1m8_AcEP13NX4HRVxpvJR76LNDXuSe5iJ7-5Y5bYntbNJCJqwkHrUVs6QLf4ZKXH',
    -- AmbulanceArmory = 'https://discord.com/api/webhooks/1364989118383394856/eniEgQwoSoR77oydZ81tLyuc3uQD5_2m2subsJO0lT_acsP0dkVpef9Xa7wDo4OHD2ku',
    -- FIBArmory = 'https://discord.com/api/webhooks/1418604591326429355/qN5SwHWQnSbJzzZCR8qPWJA2OEqbZtP09Kg_mjzRPaT3R_j2wzDEYxHoszpKr-Mo21TP',
}
local function sendLogToDiscord(webhook, playerName, identifier, shop, item, amount, total)
    if not webhook then return end
    local message = {
        username = "Shop Logger",
        embeds = { {
                       title = "Shop Purchase Logged",
                       color = 3447003,
                       fields = {
                           { name = "Player", value = playerName, inline = true },
                           { name = "Identifier", value = identifier, inline = true },
                           { name = "Shop", value = shop, inline = true },
                           { name = "Item", value = item, inline = true },
                           { name = "Amount", value = tostring(amount), inline = true },
                           { name = "Total Price", value = "$" .. tostring(total), inline = true },
                       },
                       footer = { text = "Logged by melnais raymans" }
                   } }
    }
    PerformHttpRequest(webhook, function() end, 'POST', json.encode(message), {
        ['Content-Type'] = 'application/json'
    })
end
exports.ox_inventory:registerHook('buyItem', function(payload)
    local src = payload.source
    local shopType = payload.shopType
    local webhook = webhooks[shopType]
    if not webhook then return end
    local name = GetPlayerName(src)
    local identifier = GetPlayerIdentifier(src, 0)
    sendLogToDiscord(webhook, name, identifier, shopType, payload.itemName, payload.count, payload.totalPrice)
end, {
    print = false
})
-- END SHOP LOGS --

-- START ITEM LOGS --
local function SendItemWebhook(data, hook)
    data.category = data.category or "items"
    exports['atleast_logs']:CreateLog(data)
end
local function formatItemMovement(count, itemName, isNegative)
    local sign = isNegative and '-' or '+'
    return string.format('%s%sx %s', sign, math.abs(count), itemName)
end
local ox_inventory = exports.ox_inventory
local activeSessions = {}
AddEventHandler('ox_inventory:openedInventory', function(playerId, inventoryId)
    local sessionKey = playerId .. ':' .. inventoryId
    activeSessions[sessionKey] = {
        playerName = GetPlayerName(playerId) or 'Unknown',
        playerId = playerId,
        inventory = inventoryId,
        itemsTaken = {},
        itemsPlaced = {}
    }
end)
AddEventHandler('ox_inventory:closedInventory', function(playerId, inventoryId)
    local sessionKey = playerId .. ':' .. inventoryId
    local session = activeSessions[sessionKey]
    if session and (#session.itemsTaken > 0 or #session.itemsPlaced > 0) then
        local plyLicense = GetPlayerIdentifierByType(playerId, 'license2')
        local inventoryName = session.inventory
        local itemsTakenText = '{}'
        local itemsPlacedText = '{}'
        if #session.itemsTaken > 0 then
            itemsTakenText = ''
            for _, v in pairs(session.itemsTaken) do
                itemsTakenText = itemsTakenText .. '\n' .. v.text .. ' - ' .. json.encode(v.metadata)
            end
        end
        if #session.itemsPlaced > 0 then
            itemsPlacedText = ''
            for _, v in pairs(session.itemsPlaced) do
                itemsPlacedText = itemsPlacedText .. '\n' .. v.text .. ' - ' .. json.encode(v.metadata)
            end
        end
        local infoMessage = ("%s (ID: %d | `%s`) interacted with `%s`\n```diff\nItems Taken (%s): %s\nItems Placed (%s): %s\n```\n\n"):format(session.playerName, session.playerId, plyLicense, inventoryName, #session.itemsTaken, itemsTakenText, #session.itemsPlaced, itemsPlacedText)
        if tonumber(tostring(inventoryName):sub(1)) then
            infoMessage = ("%s (ID: %d | `%s`) interacted with %s (ID: %d | `%s`)\n```diff\nItems Taken (%s): %s\nItems Placed (%s): %s\n```\n\n"):format(session.playerName, session.playerId, plyLicense, GetPlayerName(inventoryName), inventoryName, GetPlayerIdentifierByType(inventoryName, 'license2'), #session.itemsTaken, itemsTakenText, #session.itemsPlaced, itemsPlacedText)
        end
        if inventoryName ~= nil and not tonumber(inventoryName) then
            if inventoryName:match("^pd_personal:.+") then
                SendItemWebhook({
                    category = 'police_private_stash',
                    title = "Items changed",
                    info = infoMessage,
                    color = "purple",
                })
            elseif inventoryName:match("^tk_policejob_storage_1+_%d+_%d+$") then
                SendItemWebhook({
                    category = 'police_storage_stash',
                    title = "Items changed",
                    info = infoMessage,
                    color = "purple",
                })
            elseif inventoryName:match("^tk_policejob_storage_2+_%d+_%d+$") then
                SendItemWebhook({
                    category = 'fib_storage_stash',
                    title = "Items changed",
                    info = infoMessage,
                    color = "purple",
                })
            end
        end
        SendItemWebhook({
            title = "Items changed",
            info = infoMessage,
            color = "purple",
        })
        activeSessions[sessionKey] = nil
    else
        activeSessions[sessionKey] = nil
    end
end)
ox_inventory:registerHook('swapItems', function(payload)
    local src = payload.source
    local ply = exports.qbx_core:GetPlayer(src)
    if ply.PlayerData.job.name == "police" and ply.PlayerData.job.grade.level >= 3 then
        return true
    else
        return false
    end

end, {
    inventoryFilter = { "^tk_policejob_storage_%d+_%d+_%d+$" },
    typeFilter = {
        stash = true
    }
})
ox_inventory:registerHook('swapItems', function(payload)
    local src = payload.source
    local fromType = payload.fromType
    local toType = payload.toType
    local fromInventory = tostring(payload.fromInventory)
    local toInventory = tostring(payload.toInventory)
    local fromSlot = payload.fromSlot
    local count = payload.count
    local playerName = GetPlayerName(src) or 'Unknown'
    local playerId = src
    local inventoryId
    if fromType ~= 'player' then
        inventoryId = fromInventory
    elseif toType ~= 'player' then
        inventoryId = toInventory
    else
        inventoryId = (tostring(fromInventory) ~= tostring(playerId)) and fromInventory or toInventory
    end
    local sessionKey = playerId .. ':' .. inventoryId
    if not activeSessions[sessionKey] then
        activeSessions[sessionKey] = {
            playerName = playerName,
            playerId = playerId,
            inventory = inventoryId,
            itemsTaken = {},
            itemsPlaced = {}
        }
    end
    if tonumber(fromInventory) == tonumber(toInventory) then return end
    if fromType == 'player' and toType ~= 'player' then
        table.insert(activeSessions[sessionKey].itemsPlaced, { text = formatItemMovement(count, fromSlot.name, false), metadata = fromSlot.metadata })
    elseif fromType ~= 'player' and toType == 'player' then
        table.insert(activeSessions[sessionKey].itemsTaken, { text = formatItemMovement(count, fromSlot.name, true), metadata = fromSlot.metadata })
    elseif fromType == 'player' and toType == 'player' then
        if tonumber(toInventory) ~= tonumber(playerId) then
            table.insert(activeSessions[sessionKey].itemsPlaced, { text = formatItemMovement(count, fromSlot.name, true), metadata = fromSlot.metadata })
        elseif tonumber(toInventory) == tonumber(playerId) then
            table.insert(activeSessions[sessionKey].itemsTaken, { text = formatItemMovement(count, fromSlot.name, false), metadata = fromSlot.metadata })
        end
    end
    return
end, {
    typeFilter = {
        player = true,
        stash = true,
        glovebox = true,
        trunk = true,
        drop = true
    }
})
-- END ITEM LOGS --

-- START DISCONNECT LOGS --
local webhookUrl = "https://discord.com/api/webhooks/1444898347033952319/n8s_wFQt4O-0zW5YzAus5DlHpomU6tVEwZFkA7euk9AUyJWIR40W4McDsJN4MN3WUMhR" -- Replace with your Discord webhook URL
AddEventHandler('playerDropped', function(reason)
    local playerId = source
    local playerName = GetPlayerName(playerId)
    local steamIdentifier = nil
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, id in ipairs(identifiers) do
        if string.sub(id, 1, 6) == "steam:" then
            steamIdentifier = id
            break
        end
    end
    steamIdentifier = steamIdentifier or "Unknown"
    local timestamp = os.date("%d.%m.%Y %H:%M:%S")
    local embedMessage = {
        {
            ["title"] = "Player Disconnected",
            ["description"] = string.format("**[ID: %d] %s** has disconnected.\nReason: %s\nSteam: `%s`",
                    playerId, playerName, reason, steamIdentifier),
            ["color"] = 16711680, -- Red
            ["footer"] = {
                ["text"] = "ATLEAST RP | " .. timestamp,
            },
        }
    }
    PerformHttpRequest(webhookUrl, function(err, text, headers)
    end, 'POST', json.encode({
        username = "Disconnect Logs",
        embeds = embedMessage
    }), { ['Content-Type'] = 'application/json' })
end)
-- END DISCONNECT LOGS --

-- START DEATH LOGS --
RegisterNetEvent("ray-smallres:deathlogs:log", function(killer, message)
    local player = source
    local playersData = { { id = player, role = "Player" } }
    if killer then
        table.insert(playersData, { id = killer, role = "Killer" })
    end
    local lastMessage
    if killer then
        lastMessage = '**[' .. player .. '] ' .. GetPlayerName(player) .. '** died from `' .. message .. '` by ' .. '**[' .. killer .. '] ' .. GetPlayerName(killer) .. '**'
    else
        lastMessage = '**[' .. player .. '] ' .. GetPlayerName(player) .. '** died from `' .. message .. '`'
    end
    exports['logs']:CreateLog({
        category = "deaths",
        title = 'New death',
        color = "red",
        players = playersData,
        info = lastMessage,
        silentSource = true
    })
end)
-- END DEATH LOGS --