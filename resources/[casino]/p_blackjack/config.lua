Config = {}

Config.Language = 'en' -- pl / en
Config.Framework = 'QB' -- ESX / QB
Config.BetsTime = 30 -- 30 seconds

Config.Tables = {
    {
		coords = vector4(1004.090, 53.110, 68.45, 55.3000),
		highStakes = false
	},
	{
		coords = vector4(1002.360, 60.520, 68.45, 142.5300),
		highStakes = false
	},
}

Config.CustomTables = { -- you can set custom tables, table prop and ped will spawn
    {
        coords = vector4(892.1842, 13.0579, 77.8943, 62.3079),
        highStakes = false,
        color = 1, -- 0 Green, 1 Red, 2 Blue, 3 Purple
    },
}