Config = {}

Config.Debug = false -- Enable to show debug info in console

-- "qb" or "qbox"
Config.Framework = "qbox"

-- "cdn-fuel", "ox_fuel" or "native"
Config.Fuel = "ox_fuel"

-- "kph" or "mph"
Config.SpeedMeasurement = "kph"

-- "true" or "false" to show minimap on foot
Config.MinimapShowOnFoot = false

-- "true" or "false" to show compass on foot
Config.ShowCompassOnFoot = false


Config.TopRightHud = {
    id_show = true, -- true/false to enable or disable that
    time = {
        enable = true,
        ingame_time = false, -- if false uses real life time
    },
    logo = {
        enable = true,
        logopng = "https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/reallogo.png",
    }
}

return Config


