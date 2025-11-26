Config = {}
Config.Debug = false -- Prints some info in F8 and server console, useful to find possible bugs or report something 
Config.AdminGroups = {'group.admin', 'group.god'} -- ACE groups allowed to use Config.AdminCommand
Config.AdminCommand = "admin:items" -- Command used by admins to open the items menu
Config.UsersCommand = "refund" -- Command used by players to retrieve their items, or false to disable the command and use DeliveryCoords (Config.UsersCommand = false)
Config.CodesExpiresIn = 14 -- Codes expire after X days
Config.UseDeliveryCoords = true -- Set to false if you prefer using a command to get items back
Config.DeliveryCoords = {
    {x = 133.1117, y = 96.4205, z = 83.5076}, -- Go Postal Offices @LS
    {x = -421.3944, y = 6136.9971, z = 31.8773}, -- Post Op @Paleto
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end