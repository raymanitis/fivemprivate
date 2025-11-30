local Config = {}

-- target resource (only one of these can be true)
-------------------------------------------------------
Config.qbtarget = false
Config.oxtarget = true
-------------------------------------------------------

-- Minimum police presence required to allow purchases
Config.RequiredCops = 10 -- Set to 0 to disable the police requirement
Config.PoliceJobs = {
	police = true,
}
Config.RequirePoliceOnDuty = true -- Require officers to be on duty when counting

Config.pedmodel = 'a_m_m_prolhost_01' -- ped model hash

Config.scenario = 'WORLD_HUMAN_CLIPBOARD' -- scenario for ped to play, false to disable

Config.locations = {
	['bus_location'] = {
		ped = true, -- if false uses boxzone (below)

		coords = vector4(273.1253, 12.2717, 79.3041, 246.4484),
		
		-------- boxzone (only used if ped is false) --------
		length = 1.5,
		width = 1.5,
		minZ = 77.3,
		maxZ = 79.3,
		debug = false,
		-----------------------------------------------------
		
		vehicles = {
			['stockade'] = {     -- bus model name
				price = 50000,        -- price in black money
				image = 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/images/bus.png',      -- image for menu, false for no image
			},
		},

		vehiclespawncoords = vector4(274.8373, 6.8219, 79.2459, 240.6332), -- where vehicle spawns when purchased

	},

	-- add as many locations as you'd like with any type of bus vehicle follow same format as above
}

return Config
