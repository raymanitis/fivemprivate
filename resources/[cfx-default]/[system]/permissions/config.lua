Config = {
    Server_Name = "SERVER",
    Discord_Link = 'https://discord.gg/ZyJayZebYx',
    Website_Link = '',
    Allow_Refresh_Command = true, -- Allow usage of /refreshPerms command
    Refresh_Throttle = 600, -- 10 minute refresh throttle

    Guild_ID = '1444121670867484885', -- Set to the ID of your guild (or your Primary guild if using Multiguild)
    Bot_Token = '',
    CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
    CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
    roleList = {
        {778070857964716033, "group.member"},
        {1444122083054325930, "group.mod"}, -- Moderator
        {1444122123827281981, "group.admin"}, -- Admin
        {1444122180924473384, "group.dev"}, -- Dev
        {1444122210959622245, "group.owner"}, -- Īpaš.
    },
}