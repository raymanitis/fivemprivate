local FormattedToken = "Bot " .. Config.Bot_Token
local recent_role_cache = {}
local Caches = {
    RoleList = {}
}

local error_codes_defined = {
    [200] = 'OK - The request was completed successfully..!',
    [204] = 'OK - No Content',
    [400] = "Error - The request was improperly formatted, or the server couldn't understand it..!",
    [401] = 'Error - The Authorization header was missing or invalid..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
    [403] = 'Error - The Authorization token you passed did not have permission to the resource..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
    [404] = "Error - The resource at the location specified doesn't exist.",
    [429] = 'Error - Too many requests, you hit the Discord rate limit. https://discord.com/developers/docs/topics/rate-limits',
    [502] = 'Error - Discord API may be down?...'
}

function GetIdentifier(source, id_type)
    if type(id_type) ~= "string" then return end
    for _, identifier in pairs(GetPlayerIdentifiers(source)) do
        if string.find(identifier, id_type) then
            if id_type == "discord" or id_type == "discord:" then
                return identifier:gsub("discord:", "")
            end
            return identifier
        end
    end
    return nil
end

function GetGuildId(guildName)
    local result = tostring(Config.Guild_ID)
    if guildName and Config.Guilds[guildName] then
        result = tostring(Config.Guilds[guildName])
    end
    return result
end

local function DiscordRequest(method, endpoint, jsondata, reason)
    local data
    PerformHttpRequest(("https://discord.com/api/%s"):format(endpoint), function(errorCode, resultData, resultHeaders)
        data = { data = resultData, code = errorCode, headers = resultHeaders }
    end, method, #jsondata > 0 and jsondata or "", { ["Content-Type"] = "application/json", ["Authorization"] = FormattedToken, ['X-Audit-Log-Reason'] = reason })
    while data == nil do
        Wait(0)
    end

    return data
end
local function DiscordGuildRequest(method, endpoint, jsondata, reason)
    local data
    PerformHttpRequest(("https://discord.com/api/guilds/%s/%s"):format(Config.Guild_ID, endpoint), function(errorCode, resultData, resultHeaders)
        data = { data = resultData, code = errorCode, headers = resultHeaders }
    end, method, #jsondata > 0 and jsondata or "", { ["Content-Type"] = "application/json", ["Authorization"] = FormattedToken, ['X-Audit-Log-Reason'] = reason })
    while data == nil do
        Wait(0)
    end

    return data
end

function GetGuildRoleList(guild)
    local guildId = GetGuildId(guild)
    if (Caches.RoleList[guildId] == nil) then
        local guild = DiscordRequest("GET", "guilds/" .. guildId, {})
        if guild.code == 200 then
            local data = json.decode(guild.data)
            local roles = data.roles
            local roleList = {}
            for i = 1, #roles do
                roleList[roles[i].name] = roles[i].id
            end
            Caches.RoleList[guildId] = roleList
        else
            lib.print.debug("An error occured, please check your config and ensure everything is correct. Error: " .. (guild.data or guild.code))
            Caches.RoleList[guildId] = nil
        end
    end
    return Caches.RoleList[guildId]
end

function FetchRoleID(roleID2Check, guild --[[optional]])
    if type(roleID2Check) == "number" then return roleID2Check end
    if type(roleID2Check) ~= "string" then return nil end

    if type(roleID2Check) == "string" then
        if (tonumber(roleID2Check) ~= nil) then
            return tonumber(roleID2Check)
        end
    end

    if (guild ~= nil) then
        local fetchedRolesList = GetGuildRoleList(guild)
        if fetchedRolesList[roleID2Check] then
            return tonumber(fetchedRolesList[roleID2Check])
        end
    end

    if GetGuildId(guild) ~= tostring(Config.Guild_ID) then
        local mainRolesList = GetGuildRoleList()
        if mainRolesList[roleID2Check] then
            return tonumber(mainRolesList[roleID2Check])
        end
    end
    return nil
end

function ClearCache(discordId)
    if (discordId ~= nil) then
        recent_role_cache[discordId] = {}
    end
end

function GetDiscordRoles(user, guild)
    local discordId = GetIdentifier(user, "discord:")
    local guildId = GetGuildId(guild)

    if discordId then
        return GetUserRolesInGuild(discordId, guildId)
    else
        lib.print.debug("ERROR: Discord was not connected to user's FiveM account...")
        return false
    end
    return false
end

function GetUserRolesInGuild(user, guild)
    if not user then
        lib.print.debug("ERROR: GetUserRolesInGuild requires discord ID")
        return false
    end
    if not guild then
        lib.print.debug("ERROR: GetUserRolesInGuild requires guild ID")
        return false
    end

    if Config.CacheDiscordRoles and recent_role_cache[user] and recent_role_cache[user][guild] then
        return recent_role_cache[user][guild]
    end

    local endpoint = ("guilds/%s/members/%s"):format(guild, user)
    local member = DiscordRequest("GET", endpoint, {})
    if member.code == 200 then
        local data = json.decode(member.data)
        local roles = data.roles
        if Config.CacheDiscordRoles then
            recent_role_cache[user] = recent_role_cache[user] or {}
            recent_role_cache[user][guild] = roles
            SetTimeout(((Config.CacheDiscordRolesTime or 60) * 1000), function()
                recent_role_cache[user][guild] = nil
            end)
        end
        return roles
    else
        lib.print.debug("ERROR: Code 200 was not reached... Returning false. [Member Data NOT FOUND] DETAILS: " .. error_codes_defined[member.code])
        return false
    end
end

function GetDiscordName(user)
    local discordId = GetIdentifier(user, "discord:")
    local nameData = "Unknown"
    if discordId then
        local endpoint = ("members/%s"):format(discordId)
        local member = DiscordGuildRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then
                if data.nick and data.nick ~= '' then
                    nameData = data.nick
                elseif data.user and data.user.global_name and data.user.global_name ~= '' then
                    nameData = data.user.global_name
                elseif data.user and data.user.username then
                    nameData = data.user.username
                end
            end
        else
            lib.print.debug("ERROR: Code 200 was not reached. DETAILS: " .. error_codes_defined[member.code])
        end
    end
    lib.print.info(("(GetDiscordName) Got Discord name for %s: %s"):format(GetPlayerName(user), nameData))
    return nameData
end