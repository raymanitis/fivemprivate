local ROLE_CACHE, DiscordDetector, InDiscordDetector, PermTracker, permThrottle = {}, {}, {}, {}, {}
local roleList = Config.roleList

local function sendDbug(msg, eventLocation)
    lib.print.debug("(" .. eventLocation .. ") " .. msg)
end
local function convertRolesToMap(roleIds)
    local roleMap = {}
    for i = 1, #roleIds do
        roleMap[tostring(roleIds[i])] = true
    end
    return roleMap
end
local function sendMsg(src, msg)
    TriggerClientEvent('chat:addMessage', src, {
        args = {
            "SYSTEM",
            msg
        }
    })
end
local function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end
    return identifiers
end
local function RegisterPermissions(src, eventLocation)
    local discord = ExtractIdentifiers(src).discord:gsub("discord:", "")
    if discord then
        local playerName = GetPlayerName(src) or "Unknown"
        sendDbug("Player " .. playerName .. " had their Discord identifier found...", eventLocation)
        ClearCache(discord)
        PermTracker[discord] = nil

        local permAdd = "add_principal identifier.discord:" .. discord .. " "
        local roleIDs = GetDiscordRoles(src)
        if not (roleIDs == false) then
            local ROLE_MAP = convertRolesToMap(roleIDs)
            sendDbug("Player " .. playerName .. " had a valid roleIDs... Length: " .. tostring(#roleIDs), eventLocation)
            for i = 1, #roleList do
                local discordRoleId = nil
                if (ROLE_CACHE[roleList[i][1]] ~= nil) then
                    discordRoleId = ROLE_CACHE[roleList[i][1]]
                else
                    discordRoleId = FetchRoleID(roleList[i][1])
                    if (discordRoleId ~= nil) then
                        ROLE_CACHE[roleList[i][1]] = discordRoleId
                    end
                end
                sendDbug("Checking to add permission: " .. roleList[i][2] .. " => Player " .. playerName .. " has role " .. tostring(discordRoleId) .. " and it was compared against " .. roleList[i][1], eventLocation)
                if ROLE_MAP[tostring(discordRoleId)] ~= nil then
                    lib.print.info("(" .. eventLocation .. ") Added " .. playerName .. " to role group " .. roleList[i][2])
                    ExecuteCommand(permAdd .. roleList[i][2])
                    if PermTracker[discord] ~= nil then
                        local list = PermTracker[discord]
                        table.insert(list, roleList[i][2])
                        PermTracker[discord] = list
                    else
                        local list = {}
                        table.insert(list, roleList[i][2])
                        PermTracker[discord] = list
                    end
                end
            end
            sendDbug("Player " .. playerName .. " has been granted their permissions...", eventLocation)
            return true
        else
            sendDbug(playerName .. " has not gotten permissions because we could not find their roles...", eventLocation)
            return false
        end
    end
    return false
end

CreateThread(function()
    while true do
        for discord, _ in pairs(permThrottle) do
            permThrottle[discord] = (permThrottle[discord] - 1)
            if (permThrottle[discord] <= 0) then permThrottle[discord] = nil end
        end
        Wait(1000)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local identifiers = ExtractIdentifiers(src)
    local discord = identifiers.discord:gsub("discord:", "")
    local license = identifiers.license
    if PermTracker[discord] ~= nil then
        local list = PermTracker[discord]
        for i = 1, #list do
            local permGroup = list[i]
            ExecuteCommand('remove_principal identifier.discord:' .. discord .. " " .. permGroup)
            lib.print.info("(playerDropped) Removed " .. GetPlayerName(src) .. " from role group " .. permGroup)
        end
        PermTracker[discord] = nil
    end
    DiscordDetector[license] = nil
end)

if (Config.Allow_Refresh_Command) then
    RegisterCommand('refreshPerms', function(src, args, rawCommand)
        local discordIdentifier = ExtractIdentifiers(src).discord
        if (discordIdentifier ~= nil) then
            local discord = discordIdentifier:gsub("discord:", "")
            if (permThrottle[discord] == nil) then
                permThrottle[discord] = Config.Refresh_Throttle
                sendMsg(src, "Your permissions have been refreshed ^2successfully^3...")
                RegisterPermissions(src, 'refreshPerms')
            else
                local currentThrottle = permThrottle[discord]
                sendMsg(src, "^1ERR: You cannot refresh your permissions since you are on a cooldown. You can refresh in ^3" .. currentThrottle .. " ^1seconds...")
            end
        else
            sendMsg(src, "^1ERR: Your discord identifier was not found...")
        end
    end)
end

local card = '{"type":"AdaptiveCard","$schema":"http://adaptivecards.io/schemas/adaptive-card.json","version":"1.2","body":[{"type":"Container","items":[{"type":"TextBlock","text":"Welcome to ' .. Config.Server_Name .. '","wrap":true,"fontType":"Default","size":"ExtraLarge","weight":"Bolder","color":"Light"},{"type":"TextBlock","text":"You were not detected in our Discord!","wrap":true,"size":"Large","weight":"Bolder","color":"Light"},{"type":"TextBlock","text":"Please join below, then press play! Have fun!","wrap":true,"color":"Light","size":"Medium"},{"type":"ColumnSet","height":"stretch","minHeight":"100px","bleed":true,"horizontalAlignment":"Center","selectAction":{"type":"Action.OpenUrl"},"columns":[{"type":"Column","width":"stretch","items":[{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Discord","url":"' .. Config.Discord_Link .. '","style":"positive"}]}]},{"type":"Column","width":"stretch","items":[{"type":"ActionSet","actions":[{"type":"Action.Submit","title":"Play","style":"positive","id":"played"}]}]},{"type":"Column","width":"stretch","items":[{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Website","style":"positive","url":"' .. Config.Website_Link .. '"}]}]}]}],"style":"default","bleed":true,"height":"stretch","isVisible":true}]}'
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()
    local src = source
    local identifiers = ExtractIdentifiers(src)
    local license = identifiers.license
    local discord = identifiers.discord:gsub("discord: ", " ")
    if discord then
        if (not RegisterPermissions(src, 'playerConnecting')) then
            if InDiscordDetector[license] == nil then
                InDiscordDetector[license] = true
                local clicked = false
                while not clicked do
                    deferrals.presentCard(card, function(data, rawData)
                        if (data.submitId == 'played') then
                            clicked = true
                            deferrals.done()
                        end
                    end)
                    Wait((1000 * 13))
                end
                return
            end
        end
    else
        if DiscordDetector[license] == nil then
            DiscordDetector[license] = true
            lib.print.info('Discord was not found for player ' .. GetPlayerName(src) .. " ...")
            local clicked = false
            while not clicked do
                deferrals.presentCard(card,
                        function(data, rawData)
                            if (data.submitId == 'played') then
                                clicked = true
                                deferrals.done()
                            end
                        end)
                Wait((1000 * 13))
            end
            return
        end
    end
    deferrals.done()
end)