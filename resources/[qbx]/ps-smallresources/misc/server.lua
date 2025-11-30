---@diagnostic disable: undefined-global
local Mod = require 'misc/config'
local ZoneConfig = Mod and Mod.StuckBlockedZones or {}

local webhookUrl = 'https://discord.com/api/webhooks/1399906018124763246/Lyoaa7FxZ_JPxR6NnPxypV_vquCD-Nnm4ok999tIiJFw7Bq-jvQ9QgGa78uN-_nJMJpQ'

local function sendToDiscord(embed)
    if not webhookUrl or webhookUrl == '' then return end
    PerformHttpRequest(webhookUrl, function() end, 'POST', json.encode({ embeds = { embed } }), {
        ['Content-Type'] = 'application/json'
    })
end

RegisterNetEvent('ray-smallres:stuck:log', function(pos)
    local src = source
    if type(pos) ~= 'table' then return end

    local playerName = GetPlayerName(src) or 'Unknown'

    local identifiers = GetPlayerIdentifiers(src)
    local idMap = { license2 = 'N/A', discord = 'N/A', steam = 'N/A' }
    for _, id in ipairs(identifiers) do
        if id:find('license2:') then
            idMap.license2 = id
        elseif id:find('discord:') then
            idMap.discord = id:gsub('discord:', '')
        elseif id:find('steam:') then
            idMap.steam = id
        end
    end

    local x = tonumber(pos.x) or 0.0
    local y = tonumber(pos.y) or 0.0
    local z = tonumber(pos.z) or 0.0

    local description = string.format(
            '**[ID: %d] %s** used `/stuck`.\nCoordinates: `%.2f, %.2f, %.2f`\n\n```asciidoc\n- Discord: %s\n- License2: %s\n- Steam: %s\n```',
            src, playerName, x, y, z, idMap.discord, idMap.license2, idMap.steam
    )

    local embed = {
        title = 'Stuck Command Used',
        description = description,
        color = 3447003,
        timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ', os.time())
    }

    sendToDiscord(embed)
end)

-- Push /stuck zone config to clients
RegisterNetEvent('ray-smallres:stuck:requestZones', function()
    local src = source
    TriggerClientEvent('ray-smallres:stuck:setZones', src, ZoneConfig)
end)

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    TriggerClientEvent('ray-smallres:stuck:setZones', -1, ZoneConfig)
end)

-- update cop counts
local copCount = 0
CreateThread(function()
    local players = exports.qbx_core:GetQBPlayers()
    for _, ply in pairs(players) do
        if ply.PlayerData.job.name == "police" and ply.PlayerData.job.onduty then copCount += 1 end
    end
    TriggerClientEvent("serverData:client:SetCopCount", -1, copCount)
    TriggerEvent("serverData:server:SetCopCount", -1, copCount)
end)
if lib and lib.cron and lib.cron.new then
    lib.cron.new('*/3 * * * *', function()
        local players = exports.qbx_core:GetQBPlayers()
        local localCopCount = 0
        for _, ply in pairs(players) do
            if ply.PlayerData.job.name == "police" and ply.PlayerData.job.onduty then localCopCount += 1 end
        end
        copCount = localCopCount
        TriggerClientEvent("serverData:client:SetCopCount", -1, copCount)
        TriggerEvent("serverData:server:SetCopCount", -1, copCount)
    end)
end


local autoItemsRunning = false
lib.cron.new('*/5 * * * *', function()
    if autoItemsRunning then return end
    local autoItems = MySQL.query.await("SELECT * FROM auto_items")
    if autoItems[1] == nil then return end
    autoItemsRunning = true
    
    for _, v in pairs(autoItems) do 
        local ply = exports.qbx_core:GetPlayerByCitizenId(v.citizenid)
        if ply ~= nil then
            local src = ply.PlayerData.source
            local message = ply.PlayerData.charinfo.firstname .." ".. ply.PlayerData.charinfo.lastname .." (".. v.citizenid .." | ".. ply.PlayerData.name ..") has received auto-items: ```\n"
            for _, item in pairs(json.decode(v.items)) do 
                exports.ox_inventory:AddItem(src, item.item, item.amount)
                message = message .. "\n" .. item.amount .. " x " .. item.item
                Wait(10)
            end
            message = message .."```"
            exports['atleast_logs']:CreateLog({
                category = "items",
                title = "AUTO-ITEMS Received",
                info = message,
                color = "green",
            })
            MySQL.query.await('DELETE FROM auto_items WHERE citizenid = ?', { v.citizenid })
            Wait(1000)
        end
    end
    autoItemsRunning = false
end)