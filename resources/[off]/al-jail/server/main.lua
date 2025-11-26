local QBCore = exports["qb-core"]:GetCoreObject()
local jailTimes = {}
local webhook = "https://discord.com/api/webhooks/1370131428733616258/mrvdG-dB0_uve4MUfqwibupfzfEVA_ycf1ioTa3Jks4eCzVhf4MCsa31FclsZIjdxwKq"

local function isPlayerJailed(license)
    local result = MySQL.query.await("SELECT `time`, `reason`, `admin_name` FROM `ajail` WHERE `license` = ? LIMIT 1", { license })
    if result[1] ~= nil then
        return result[1].time, result[1].reason, result[1].admin_name
    end
    return 0, nil, nil
end

local function getPlyName(src)
    if src == 0 then
        return "[CONSOLE]"
    end

    return GetPlayerName(src)
end

lib.callback.register("al-jail:isJailed", function(source)
    local plyLicense = GetPlayerIdentifierByType(source, 'license2')
    local jailTime, reason, admin = isPlayerJailed(plyLicense)
    jailTimes[tostring(plyLicense)] = { paused = false, time = jailTime, id = source }
    return jailTime, reason, admin
end)

lib.addCommand('ajail', {
    help = 'Jails the specified player',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
        {
            name = 'time',
            type = 'number',
            help = 'Time for jail (in minutes)',
        },
        {
            name = 'reason',
            help = 'Reason for jail',
            type = "longString",
            optional = true
        },
    },
    restricted = { 'group.admin', 'group.mod' }
}, function(source, args)
    local src = source
    local targetId = args.target

    local ply = exports.qbx_core:GetPlayer(targetId)
    if ply == nil then
        TriggerClientEvent('chat:addMessage', src, "Player is not found!")
        return
    end

    local plyLicense = GetPlayerIdentifierByType(targetId, 'license2')
    if isPlayerJailed(plyLicense) > 0 then
        TriggerClientEvent('chat:addMessage', src, "Player is already jailed!")
        return
    end
    local time = args.time
    local reason = args.reason
    local sourceName = getPlyName(src)
    MySQL.query.await("INSERT INTO `ajail` (license, time, reason, admin_name) VALUES (?, ?, ?, ?)",
            { plyLicense, time, reason, sourceName }
    )
    local jailTime, retReason, admin = isPlayerJailed(plyLicense)
    jailTimes[tostring(plyLicense)] = { paused = false, time = jailTime, id = targetId }
    TriggerClientEvent("al-jail:client:sentToJail", targetId, reason, time, admin)
    Player(targetId).state.inAdminJail = true
    SendToDiscord(nil, nil, "[AJAIL] Player jailed", "`" .. sourceName .. "` jailed `" .. getPlyName(targetId) .. "` for " .. time .. " minutes, for " .. retReason, false, webhook)
end)

lib.addCommand('ajailedit', {
    help = 'Edit the jail time the specified player',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
        {
            name = 'amount',
            help = 'Amount to change to (+15, -15, 15)'
        }
    },
    restricted = { 'group.admin', 'group.mod' }
}, function(source, args)
    local src = source
    local targetId = args.target
    local amount = args.amount

    local Player = exports.qbx_core:GetPlayer(targetId)
    if Player == nil then
        TriggerClientEvent('chat:addMessage', src, "Player is not found!")
        return
    end

    local plyLicense = GetPlayerIdentifierByType(targetId, 'license2')
    if isPlayerJailed(plyLicense) == 0 then
        TriggerClientEvent('chat:addMessage', src, "Player is not jailed!")
        return
    end

    local activeJailTime = MySQL.scalar.await('SELECT time FROM `ajail` WHERE license = ?', { plyLicense })
    if tostring(amount):sub(1, 1) == '+' then
        amount = tonumber(tostring(amount):sub(2))
        activeJailTime = activeJailTime + amount
    elseif tostring(amount):sub(1, 1) == '-' then
        amount = tonumber(tostring(amount):sub(2))
        activeJailTime = activeJailTime - amount
        if activeJailTime <= 0 then
            TriggerClientEvent('chat:addMessage', src, { args = { "Server", "You must use '/aunjail' if you want to unjail someone (edited time would be " .. activeJailTime .. " minutes)!" } })
            return
        end
    else
        if tonumber(amount) then
            amount = tonumber(amount)
            if amount <= 0 then
                TriggerClientEvent('chat:addMessage', src, { args = { "Server", "You must use '/aunjail' if you want to unjail someone (edited time would be " .. amount .. " minutes)!" } })
                return
            end
            activeJailTime = amount
        else
            TriggerClientEvent('chat:addMessage', src, { args = { "Server", "You must input something like +15, -15 or 15!" } })
            return
        end
    end

    jailTimes[plyLicense].time = activeJailTime
    MySQL.query.await("UPDATE `ajail` SET `time` = ? WHERE `license` = ?", { jailTimes[tostring(plyLicense)].time, plyLicense })
    TriggerClientEvent("al-jail:client:updateCounter", targetId, jailTimes[plyLicense].time)

    SendToDiscord(nil, nil, "[AJAIL] Player changed", "`" .. getPlyName(src) .. "` changed `" .. getPlyName(targetId) .. "`'s time to " .. activeJailTime .. " minutes", false, webhook)
end)

lib.addCommand('aunjail', {
    help = 'Unjails the specified player',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
    },
    restricted = { 'group.admin', 'group.mod' }
}, function(source, args)
    local src = source
    local targetId = args.target

    local ply = exports.qbx_core:GetPlayer(targetId)
    if ply == nil then
        TriggerClientEvent('chat:addMessage', src, "Player is not found!")
        return
    end

    local plyLicense = GetPlayerIdentifierByType(targetId, 'license2')
    if isPlayerJailed(plyLicense) == 0 then
        TriggerClientEvent('chat:addMessage', src, "Player is not jailed!")
        return
    end
    MySQL.query.await("DELETE FROM `ajail` WHERE license = ?", { plyLicense })
    if jailTimes[tostring(plyLicense)] ~= nil then
        jailTimes[tostring(plyLicense)] = nil
    end
    TriggerClientEvent("al-jail:client:unjailed", targetId)
    Player(targetId).state.inAdminJail = false
    SendToDiscord(nil, nil, "[AJAIL] Player unjailed", "`" .. getPlyName(src) .. "` unjailed `" .. getPlyName(targetId) .. "`", false, webhook)
end)

CreateThread(function()
    while true do
        if tablelength(jailTimes) == 0 then
            Wait(1500)
        else
            Wait(Config.SecondRemoval)
            for k, v in pairs(jailTimes) do
                if jailTimes[k].paused then
                    Wait(1500)
                    break
                end
                jailTimes[k].time = v.time - 1
                TriggerClientEvent("al-jail:client:updateCounter", v.id, jailTimes[k].time)
                if jailTimes[k].time == 0 then
                    local playerId = v.id
                    TriggerClientEvent("al-jail:client:unjailed", playerId)

                    local plyLicense = GetPlayerIdentifierByType(playerId, 'license2')
                    MySQL.query.await("DELETE FROM `ajail` WHERE license = ?", { plyLicense })
                    jailTimes[k] = nil
                    SendToDiscord(nil, nil, "[AJAIL]", "`[CONSOLE]` Unjailed `" .. getPlyName(playerId) .. "` because the time ran out", false, webhook)
                    break
                end
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local license = GetPlayerIdentifierByType(src, 'license2')
    if jailTimes[tostring(license)] ~= nil then
        -- Save remaining time to database before removing from memory
        MySQL.query.await("UPDATE `ajail` SET `time` = ? WHERE `license` = ?",
                { jailTimes[tostring(license)].time, license }
        )
        jailTimes[tostring(license)] = nil
    end
end)

RegisterServerEvent("al-jails:pausedTimeToggle")
AddEventHandler("al-jails:pausedTimeToggle", function(tog)
    local license = GetPlayerIdentifierByType(source, 'license2')
    jailTimes[license].paused = tog
end)

function SendToDiscord(username, color, title, description, mentionEveryone, webHook)
    local message = {
        username = username ~= nil and username or "Apsargs",
        embeds = {
            {
                ["color"] = color ~= nil and color or 16777215,
                ["title"] = title,
                ["description"] = description,
                ["footer"] = {
                    ["text"] = os.date("%Y-%m-%d %H:%M:%S"),
                },
            }
        }
    }

    if mentionEveryone then
        message.content = "@everyone"
    end

    PerformHttpRequest(webHook, function() end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("al-jail:server:revivePlayer")
AddEventHandler("al-jail:server:revivePlayer", function()
    local Player = QBCore.Functions.GetPlayer(source)

    if not Player.PlayerData.metadata.isdead then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'You are not dead!',
            icon = 'fa-solid fa-ban',
            iconColor = '#8C2425',
        })
        exports['atleast_logs']:CreateLog({
            category = "atleast-ac",
            title = 'Triggered - Revive player',
            action = "Player not dead",
            color = "purple",
            players = {
                { id = source, role = "Player" },
            },
            info = {},
        })
        return
    end

    if not jailTimes[Player.PlayerData.license] then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'You are not jailed!',
            icon = 'fa-solid fa-ban',
            iconColor = '#8C2425',
        })
        exports['atleast_logs']:CreateLog({
            category = "atleast-ac",
            title = 'Triggered - Revive player',
            action = "Player from outside jail",
            color = "purple",
            players = {
                { id = source, role = "Player" },
            },
            info = {},
        })
        return
    end

    -- TriggerClientEvent('al-hospital:client:revive', source, false, true)
    TriggerClientEvent('p_ambulancejob:RevivePlayer', source)
end)