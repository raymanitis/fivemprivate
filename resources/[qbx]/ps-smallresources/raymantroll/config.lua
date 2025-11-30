Config = {}

Config.Debug = false

-- Command names
Config.commandEnable = 'trollvis'
Config.commandDisable = 'trollvisoff'

-- Thread tick interval on clients that conceal entities (ms)
Config.concealTickInterval = 500

-- ox_lib group restriction for the commands (matches your example usage)
Config.restrictedGroup = 'group.admin'

-- Cache settings (ms)
Config.cacheSettings = {
    playerIdMapCacheTimeout = 1000, -- cache GetPlayerFromServerId
    playerPedCacheTimeout = 1000,   -- cache GetPlayerPed
}

-- Voice integration (optional)
-- Voice settings removed; voice behavior remains unchanged

return Config