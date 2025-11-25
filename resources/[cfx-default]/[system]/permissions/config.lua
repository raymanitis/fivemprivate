Config = {
    Server_Name = "SERVER",
    Discord_Link = 'https://discord.gg/',
    Website_Link = '',
    Allow_Refresh_Command = true, -- Allow usage of /refreshPerms command
    Refresh_Throttle = 600, -- 10 minute refresh throttle

    Guild_ID = '', -- Set to the ID of your guild (or your Primary guild if using Multiguild)
    Bot_Token = '',
    CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
    CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
    roleList = {
        --{778070857964716033, "group.member"},
        -- {1237810363177897986, "group.mod"}, -- Moderator
        -- {1435305527436509345, "group.admin"}, -- Jr. Admin
        -- {1237810420312707199, "group.admin"}, -- Admin
        -- {1283410711699263528, "group.dev"}, -- Dev
        -- {1435228380193755146, "group.owner"}, -- Līdzīpaš.
        -- {1237810473315864636, "group.owner"}, -- Īpaš.
    },
}