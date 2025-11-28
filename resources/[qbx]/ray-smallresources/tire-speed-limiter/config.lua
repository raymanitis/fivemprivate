Config = {}

Config.Debug = false

-- Speed limits based on number of damaged tires
Config.speedLimits = {
    [0] = nil,  -- No damage - no limit
    [1] = nil,  -- 1 tire - no limit
    [2] = 100,  -- 2 tires - 100 km/h max
    [3] = 60,   -- 3 tires - 60 km/h max
    [4] = 40,   -- 4 tires - 40 km/h max
}

-- Cache settings for optimization
Config.cacheSettings = {
    updateInterval = 500, -- Check tire damage every 500ms
    tireDamageCacheTimeout = 500, -- Cache tire damage for 500ms
    vehicleSpeedCacheTimeout = 200, -- Cache vehicle speed for 200ms
}

return Config
