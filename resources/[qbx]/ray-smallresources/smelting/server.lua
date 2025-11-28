local Config = require 'smelting/config'
local ServerConfig = require 'smelting/server_config'

local players = {}

-- Helper function to remove items
local function RemoveItem(source, item, count)
    return exports.ox_inventory:RemoveItem(source, item, count)
end

-- Helper function to add items
local function AddItem(source, item, count)
    return exports.ox_inventory:AddItem(source, item, count)
end

-- Custom Logging System
local function SendWebhook(webhookUrl, title, description, color, fields)
    if not webhookUrl or webhookUrl == "" then return end
    
    local embed = {
        {
            ["title"] = title,
            ["description"] = description,
            ["type"] = "rich",
            ["color"] = color,
            ["fields"] = fields or {},
            ["footer"] = {
                ["text"] = "Smelting System • " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }
    
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({
        username = "Smelting System",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

local function LogSmelting(source, ingot, count, location, requiredItems)
    if not ServerConfig.Logging.enabled or not ServerConfig.Logging.logSmelting then return end
    
    local playerName = GetPlayerName(source)
    local playerIdentifiers = GetPlayerIdentifiers(source)
    local steamId = "N/A"
    local license = "N/A"
    
    for _, identifier in pairs(playerIdentifiers) do
        if string.match(identifier, "steam:") then
            steamId = identifier
        elseif string.match(identifier, "license:") then
            license = identifier
        end
    end
    
    local fields = {
        {
            ["name"] = "Player",
            ["value"] = playerName .. " (" .. source .. ")",
            ["inline"] = true
        },
        {
            ["name"] = "Steam ID",
            ["value"] = steamId,
            ["inline"] = true
        },
        {
            ["name"] = "License",
            ["value"] = license,
            ["inline"] = true
        },
        {
            ["name"] = "Location",
            ["value"] = string.format("%.2f, %.2f, %.2f", location.coords.x, location.coords.y, location.coords.z),
            ["inline"] = false
        },
        {
            ["name"] = "Required Items",
            ["value"] = table.concat(requiredItems, ", "),
            ["inline"] = false
        },
        {
            ["name"] = "Result",
            ["value"] = string.format("%s x%d", ingot.result.item, ingot.result.count * count),
            ["inline"] = false
        }
    }
    
    SendWebhook(
        ServerConfig.Webhooks.smelting,
        "🔥 Smelting Activity",
        string.format("**%s** smelted **%dx %s**", playerName, count, ingot.label),
        ServerConfig.Logging.embedColor.smelting,
        fields
    )
end

local function LogAntiCheat(source, reason, location, playerCoords, distance)
    if not ServerConfig.Logging.enabled or not ServerConfig.Logging.logAntiCheat then return end
    
    local playerName = GetPlayerName(source)
    local playerIdentifiers = GetPlayerIdentifiers(source)
    local steamId = "N/A"
    local license = "N/A"
    
    for _, identifier in pairs(playerIdentifiers) do
        if string.match(identifier, "steam:") then
            steamId = identifier
        elseif string.match(identifier, "license:") then
            license = identifier
        end
    end
    
    local fields = {
        {
            ["name"] = "Player",
            ["value"] = playerName .. " (" .. source .. ")",
            ["inline"] = true
        },
        {
            ["name"] = "Steam ID",
            ["value"] = steamId,
            ["inline"] = true
        },
        {
            ["name"] = "License",
            ["value"] = license,
            ["inline"] = true
        },
        {
            ["name"] = "Reason",
            ["value"] = reason,
            ["inline"] = false
        },
        {
            ["name"] = "Expected Location",
            ["value"] = string.format("%.2f, %.2f, %.2f", location.coords.x, location.coords.y, location.coords.z),
            ["inline"] = false
        },
        {
            ["name"] = "Player Location",
            ["value"] = string.format("%.2f, %.2f, %.2f", playerCoords.x, playerCoords.y, playerCoords.z),
            ["inline"] = false
        },
        {
            ["name"] = "Distance",
            ["value"] = string.format("%.2f units (Max: %.2f)", distance, location.radius + 1.0),
            ["inline"] = false
        }
    }
    
    SendWebhook(
        ServerConfig.Webhooks.anticheat,
        "⚠️ Possible Cheating Detected",
        string.format("**%s** attempted smelting from invalid distance", playerName),
        ServerConfig.Logging.embedColor.anticheat,
        fields
    )
end

RegisterNetEvent('smelting:start', function(ingotId, count, locationKey)
    local src = source
    if not ingotId or not count or count <= 0 or not locationKey then
        return
    end

    local ingot = Config.SmeltingItems[ingotId]
    local location = Config.SmeltLocations[locationKey]
    if not ingot or not location then
        return
    end

    local coords = GetEntityCoords(GetPlayerPed(src))
    local distance = #(coords - location.coords)
    local maxDistance = location.radius + 1.0
    
    if distance > maxDistance then
        -- Log possible cheating attempt
        LogAntiCheat(src, "Distance check failed during smelting attempt", location, coords, distance)
        
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = "You are too far from the smelting area."
        })
        return
    end

    -- Item Check
    for _, req in pairs(ingot.required) do
        if exports.ox_inventory:Search(src, "count", req.item) < req.count * count then
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'error',
                description = "Missing items."
            })
            return
        end
    end

    -- Weight check before starting - Fixed the logic here
    if not exports.ox_inventory:CanCarryAmount(src, ingot.result.item, ingot.result.count * count) then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = "You cannot carry that much."
        })
        return
    end

    -- Cooldown check
    local cooldown = ingot.cooldown or 3
    players[src] = players[src] or {
        cooldown = 0
    }
    if os.time() < (players[src].cooldown + cooldown) then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = "You're doing that too fast!"
        })
        return
    end

    local ply = exports.qbx_core:GetPlayer(src)

    -- Remove items
    for _, req in pairs(ingot.required) do
        local removed = RemoveItem(src, req.item, req.count * count)
        if not removed then
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'error',
                description = "Failed to remove items."
            })
            return
        end
    end

    -- Add result
    local added = ply.Functions.AddItem(ingot.result.item, ingot.result.count * count)
    if not added then
        -- If adding failed, try to give back the removed items
        for _, req in pairs(ingot.required) do
            AddItem(src, req.item, req.count * count)
        end
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = "Failed to add smelted items."
        })
        return
    end

    players[src].cooldown = os.time()

    TriggerClientEvent('ox_lib:notify', src, {
        type = 'success',
        description = ("Smelted %dx %s."):format(count, ingot.result.item)
    })

    -- Prepare logging data
    local requiredItemsText = {}
    for _, req in ipairs(ingot.required) do
        table.insert(requiredItemsText, ("%s x%d"):format(req.item, req.count * count))
    end

    -- Log successful smelting
    LogSmelting(src, ingot, count, location, requiredItemsText)
end)
