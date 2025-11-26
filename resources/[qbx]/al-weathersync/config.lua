Config = {}
Config.DynamicWeather = true -- Set this to false if you don't want the weather to change automatically every 10 minutes.

-- On server start
Config.StartWeather = 'EXTRASUNNY' -- Default weather                       default: 'EXTRASUNNY'
Config.BaseTime = 12 -- Time                                             default: 8
Config.TimeOffset = 0 -- Time offset                                      default: 0
Config.FreezeTime = false -- freeze time                                  default: false
Config.Blackout = false -- Set blackout                                 default: false
Config.BlackoutVehicle = false -- Set blackout affects vehicles                default: false
Config.NewWeatherTimer = 25 -- Time (in minutes) between each weather change   default: 10
Config.Disabled = false -- Set weather disabled                         default: false

Config.AvailableWeatherTypes = { -- DON'T TOUCH EXCEPT IF YOU KNOW WHAT YOU ARE DOING
    'EXTRASUNNY',
    'CLEAR',
    'NEUTRAL',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'CLOUDS',
    'CLEARING',
    'RAIN',
    'THUNDER',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
    'HALLOWEEN'
}
Config.WeatherNames = {
    { label = "Extra Sunny", value = "EXTRASUNNY" },
    { label = "Clear", value = "CLEAR" },
    { label = "Neutral", value = "NEUTRAL" },
    { label = "Smog", value = "SMOG" },
    { label = "Foggy", value = "FOGGY" },
    { label = "Overcast", value = "OVERCAST" },
    { label = "Clouds", value = "CLOUDS" },
    { label = "Clearing", value = "CLEARING" },
    { label = "Rain", value = "RAIN" },
    { label = "Thunder", value = "THUNDER" },
    { label = "Snow", value = "SNOW" },
    { label = "Blizzard", value = "BLIZZARD" },
    { label = "Snowlight", value = "SNOWLIGHT" },
    { label = "Xmas", value = "XMAS" },
    { label = "Halloween", value = "HALLOWEEN" }
}