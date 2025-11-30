local Config = {}

Config.MechanicLocations = {
	['ls customs'] = {
		coords = vector3(-333.1559, -133.1196, 39.0097),
		radius = 10.0,
		price = 3000,
		repairTime = 60000, -- milliseconds
		organization = 'mechanic',
	},
	['coast autos'] = {
		coords = vector3(1138.5298, -782.5292, 58.0970),
		radius = 10.0,
		price = 3000,
		repairTime = 60000, -- milliseconds
		organization = 'coastautos',
	},
	['exotic'] = {
		coords = vector3(554.9554, -198.8796, 54.5642),
		radius = 10.0,
		price = 3000,
		repairTime = 60000, -- milliseconds
		organization = 'exotic',
	},
	['bennys'] = {
		coords = vector3(-222.0539, -1336.1263, 31.3005),
		radius = 5.0,
		price = 3000,
		repairTime = 60000, -- milliseconds
		organization = 'bennys',
	},
	
	-- ['sf customs'] = {
	-- 	coords = vector3(-210.29, -1311.03, 31.29),
	-- 	radius = 10.0,
	-- 	price = 3000,
	-- 	repairTime = 10000, -- milliseconds
	-- 	organization = 'mechanic',
	-- },
}

-- Optional global settings
Config.Settings = {
	keybind = 38, -- E
	useBankFirst = true, -- try bank then cash
	pedModel = 's_m_m_autoshop_02', -- mechanic ped model
	pedOffset = 3.0, -- distance in front of vehicle to spawn ped
	pedZOffset = -1.0, -- vertical offset for ped spawn relative to ground/vehicle front
}

return Config


