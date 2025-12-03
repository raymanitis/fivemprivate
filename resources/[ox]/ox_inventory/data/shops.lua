-- groups virker ikke!!!

return {
	-- ============================================
	-- EXAMPLE: Ped-based Shop (No Target/Marker)
	-- ============================================
	-- This example shows how to create shops using peds that players can interact with
	-- directly by pressing E when nearby. Works without ox_target or markers.
	-- 
	-- To use this, make sure 'inventory:target' is set to 0 in your server.cfg
	-- Example: setr inventory:target 0
	--
	-- All targets will show "Open [shop name]" text
	-- Distance is always 2.0 (default) - same for all targets
	--
	GeneralStore = {
		name = 'General Store', -- Display name (will show as "Open General Store")
		blip = {
			id = 59,
			colour = 69,
			scale = 0.8
		},
		icon = 'fas fa-shopping-basket',
		-- Shop-level ped configuration (applies to ALL targets)
		ped = `mp_m_shopkeep_01`, -- Ped model for all locations
		scenario = 'WORLD_HUMAN_STAND_IMPATIENT', -- Animation for all peds (optional)
		distance = 2.0, -- Interaction distance (default 2.0, optional)
		-- Dialog configuration (optional - shows when clicking ped)
		dialog = {
			name = 'Shopkeeper', -- Ped name shown in dialog
			speech = 'Welcome! How can I help you today?', -- Speech text (optional)
			options = {
				{
					label = 'I want to shop',
					icon = 'fas fa-shopping-basket',
					openShop = true, -- This will open the shop
				},
				{
					label = 'Nevermind',
					icon = 'fas fa-times',
				},
			},
		},
		inventory = {
			{ name = 'bubbletea', price = 50 },
			{ name = 'coffee_frappuccino', price = 50 },
			{ name = 'water_bottle', price = 50 },
			{ name = 'baconburger', price = 50 },
			{ name = 'bagel', price = 50 },
			{ name = 'brownie', price = 50 }
		},
		-- Targets: vec4 format (x, y, z, heading)
		targets = {
			vector4(24.5, -1346.19, 29.5, 266.78),
			vector4(-3039.91, 584.26, 7.91, 16.79),
			vector4(-3243.27, 1000.1, 12.83, 358.73),
			vector4(1728.28, 6416.03, 35.04, 242.45),
			vector4(1697.96, 4923.04, 42.06, 326.61),
			vector4(1959.6, 3740.93, 32.34, 296.84),
			vector4(549.16, 2670.35, 42.16, 92.53),
			vector4(2677.41, 3279.8, 55.24, 334.16),
			vector4(2556.19, 380.89, 108.62, 355.58),
			vector4(372.82, 327.3, 103.57, 255.46),
			vector4(161.21, 6642.32, 31.61, 223.57),
			vector4(-553.02, -583.2, 34.68, 178.34),

			-- LTD Gasoline Locations
			vector4(-47.42, -1758.67, 29.42, 47.26),
			vector4(-706.17, -914.64, 19.22, 88.77),
			vector4(-1819.53, 793.49, 138.09, 131.46),
			vector4(1164.82, -323.66, 69.21, 106.86),
		}
	},

	-- ============================================
	-- EXAMPLE: Job-Restricted Ped Shop
	-- ============================================
	Ammunation = {
		name = 'Ammunation',
		blip = {
			id = 110,
			colour = 1,
			scale = 0.8
		},
		icon = 'fas fa-gun',
		ped = `s_m_y_ammucity_01`, -- Same ped for all locations
		scenario = 'WORLD_HUMAN_CLIPBOARD', -- Same animation for all
		groups = { -- Only players with these jobs can access
			police = 0,
			sheriff = 0
		},
		dialog = {
			name = 'Ammunation Clerk',
			speech = 'Welcome to Ammunation. What can I do for you?',
			options = {
				{
					label = 'Browse Weapons',
					icon = 'fas fa-gun',
					openShop = true,
				},
				{
					label = 'Just looking',
					icon = 'fas fa-eye',
				},
			},
		},
		inventory = {
			{ name = 'ammo-9', price = 5 },
			{ name = 'WEAPON_KNIFE', price = 200 },
			{ name = 'WEAPON_BAT', price = 100 },
			{ name = 'WEAPON_PISTOL', price = 1000, metadata = { registered = true }, license = 'weapon' }
		},
		targets = {
			vector4(813.6984, -2155.2368, 29.6192, 1.0530),
			vector4(-659.0803, -939.4811, 21.8293, 88.2644),
			vector4(-330.72, 6085.81, 31.45, 190.52),
			vector4(247.4480, -51.6151, 69.9411, 335.3570),
			vector4(18.1752, -1107.9011, 29.7972, 162.9033),
			vector4(2564.8474, 298.7363, 108.7325, 267.0392),
			vector4(-1112.5372, 2697.2485, 18.5543, 130.9647),
			vector4(841.31, -1035.28, 28.19, 334.27),
			vector4(-1304.44, -395.68, 36.7, 41.85),
		}
	},

	-- ============================================
	-- EXAMPLE: Simple Single Ped Shop
	-- ============================================
	LiquorStore = {
		name = 'Liquor Store',
		blip = {
			id = 93,
			colour = 69,
			scale = 0.8
		},
		icon = 'fas fa-wine-bottle',
		ped = `mp_m_shopkeep_01`, -- Ped model
		-- No scenario - ped will just stand there
		inventory = {
			{ name = 'vodka', price = 10 },
			{ name = 'beer', price = 5 }
		},
		targets = {
			vector4(-1221.38, -907.89, 12.33, 27.51),
			vector4(-1486.82, -377.48, 40.16, 130.89),
			vector4(-2966.41, 391.62, 15.04, 87.82),
			vector4(1165.15, 2710.78, 38.16, 177.96),
			vector4(1134.3, -983.26, 46.42, 276.3)
		}
	},

	hardware = {
		name = 'Hardware Store',
		blip = {
			id = 93,
			colour = 69,
			scale = 0.8
		},
		icon = 'fas fa-wine-bottle',
		ped = `mp_m_shopkeep_01`, -- Ped model
		-- No scenario - ped will just stand there
		inventory = {
			{ name = 'whiskey', price = 10 },
			{ name = 'beer', price = 5 }
		},
		targets = {
			vector4(46.52, -1749.55, 29.64, 50.82),
			vector4(2745.87, 3468.98, 55.67, 247.08),
			vector4(-421.65, 6135.97, 31.88, 232.98),
			vector4(1167.28, -1347.11, 34.91, 276.86),
		}
	},


	-- ============================================
	-- CONFIGURATION GUIDE:
	-- ============================================
	-- Shop Level:
	--   - name: Shop name (will show as "Open [name]" in UI)
	--   - ped: Ped model hash - same for ALL targets in this shop
	--   - scenario: Optional ped animation - same for ALL targets
	--   - distance: Optional interaction distance (default: 2.0) - same for ALL targets
	--
	-- Target Level (in targets array):
	--   - Use vec4 format: vec4(x, y, z, heading)
	--
	-- Common Ped Models:
	--   Male: `mp_m_shopkeep_01`, `s_m_y_ammucity_01`, `s_m_y_barman_01`
	--   Female: `s_f_y_shop_low`, `s_f_y_bartender_01`, `mp_f_shopkeep_01`
	--
	-- Common Scenarios (optional):
	--   - 'WORLD_HUMAN_STAND_IMPATIENT', 'WORLD_HUMAN_STAND_MOBILE'
	--   - 'WORLD_HUMAN_CLIPBOARD', 'WORLD_HUMAN_SMOKING'
	--   - Leave empty for default standing pose
	-- ============================================

	-- OLD EXAMPLES (commented out):
	-- [OLD] General = {
	-- 	name = '24/7 Supermarket',
	-- 	blip = {
	-- 		id = 59, colour = 69, scale = 0.8
	-- 	}, inventory = {
	-- 		{ name = 'burger', price = 5 },
	-- 		{ name = 'water', price = 1 },
	-- 		{ name = 'toast', price = 5 },
	-- 	}, locations = {
	-- 		vec3(25.7, -1347.3, 29.49),
	-- 		vec3(-3038.71, 585.9, 7.9),
	-- 		vec3(-3241.47, 1001.14, 12.83),
	-- 		vec3(1728.66, 6414.16, 35.03),
	-- 		vec3(1697.99, 4924.4, 42.06),
	-- 		vec3(1961.48, 3739.96, 32.34),
	-- 		vec3(547.79, 2671.79, 42.15),
	-- 		vec3(2679.25, 3280.12, 55.24),
	-- 		vec3(2557.94, 382.05, 108.62),
	-- 		vec3(373.55, 325.56, 103.56),
	-- 	}, targets = {
	-- 		{ loc = vec3(25.06, -1347.32, 29.5), length = 0.7, width = 0.5, heading = 0.0, minZ = 29.5, maxZ = 29.9, distance = 1.5 },
	-- 		{ loc = vec3(-3039.18, 585.13, 7.91), length = 0.6, width = 0.5, heading = 15.0, minZ = 7.91, maxZ = 8.31, distance = 1.5 },
	-- 		{ loc = vec3(-3242.2, 1000.58, 12.83), length = 0.6, width = 0.6, heading = 175.0, minZ = 12.83, maxZ = 13.23, distance = 1.5 },
	-- 		{ loc = vec3(1728.39, 6414.95, 35.04), length = 0.6, width = 0.6, heading = 65.0, minZ = 35.04, maxZ = 35.44, distance = 1.5 },
	-- 		{ loc = vec3(1698.37, 4923.43, 42.06), length = 0.5, width = 0.5, heading = 235.0, minZ = 42.06, maxZ = 42.46, distance = 1.5 },
	-- 		{ loc = vec3(1960.54, 3740.28, 32.34), length = 0.6, width = 0.5, heading = 120.0, minZ = 32.34, maxZ = 32.74, distance = 1.5 },
	-- 		{ loc = vec3(548.5, 2671.25, 42.16), length = 0.6, width = 0.5, heading = 10.0, minZ = 42.16, maxZ = 42.56, distance = 1.5 },
	-- 		{ loc = vec3(2678.29, 3279.94, 55.24), length = 0.6, width = 0.5, heading = 330.0, minZ = 55.24, maxZ = 55.64, distance = 1.5 },
	-- 		{ loc = vec3(2557.19, 381.4, 108.62), length = 0.6, width = 0.5, heading = 0.0, minZ = 108.62, maxZ = 109.02, distance = 1.5 },
	-- 		{ loc = vec3(373.13, 326.29, 103.57), length = 0.6, width = 0.5, heading = 345.0, minZ = 103.57, maxZ = 103.97, distance = 1.5 },
	-- 	}
	-- },

	-- Liquor = {
	-- 	name = 'Liquor Store',
	-- 	blip = {
	-- 		id = 93, colour = 69, scale = 0.8
	-- 	}, inventory = {
	-- 		{ name = 'whiskey', price = 10 },
	-- 	}, locations = {
	-- 		vec3(1135.808, -982.281, 46.415),
	-- 		vec3(-1222.915, -906.983, 12.326),
	-- 		vec3(-1487.553, -379.107, 40.163),
	-- 		vec3(-2968.243, 390.910, 15.043),
	-- 		vec3(1166.024, 2708.930, 38.157),
	-- 		vec3(1392.562, 3604.684, 34.980),
	-- 		vec3(-1393.409, -606.624, 30.319)
	-- 	}, targets = {
	-- 		{ loc = vec3(1134.9, -982.34, 46.41), length = 0.5, width = 0.5, heading = 96.0, minZ = 46.4, maxZ = 46.8, distance = 1.5 },
	-- 		{ loc = vec3(-1222.33, -907.82, 12.43), length = 0.6, width = 0.5, heading = 32.7, minZ = 12.3, maxZ = 12.7, distance = 1.5 },
	-- 		{ loc = vec3(-1486.67, -378.46, 40.26), length = 0.6, width = 0.5, heading = 133.77, minZ = 40.1, maxZ = 40.5, distance = 1.5 },
	-- 		{ loc = vec3(-2967.0, 390.9, 15.14), length = 0.7, width = 0.5, heading = 85.23, minZ = 15.0, maxZ = 15.4, distance = 1.5 },
	-- 		{ loc = vec3(1165.95, 2710.20, 38.26), length = 0.6, width = 0.5, heading = 178.84, minZ = 38.1, maxZ = 38.5, distance = 1.5 },
	-- 		{ loc = vec3(1393.0, 3605.95, 35.11), length = 0.6, width = 0.6, heading = 200.0, minZ = 35.0, maxZ = 35.4, distance = 1.5 }
	-- 	}
	-- },

	-- YouTool = {
	-- 	name = 'YouTool',
	-- 	blip = {
	-- 		id = 402, colour = 69, scale = 0.8
	-- 	}, inventory = {
	-- 		{ name = 'lockpick', price = 10 }
	-- 	}, locations = {
	-- 		vec3(2748.0, 3473.0, 55.67),
	-- 		vec3(342.99, -1298.26, 32.51)
	-- 	}, targets = {
	-- 		{ loc = vec3(2746.8, 3473.13, 55.67), length = 0.6, width = 3.0, heading = 65.0, minZ = 55.0, maxZ = 56.8, distance = 3.0 }
	-- 	}
	-- },

	-- Ammunation = {
	-- 	name = 'Ammunation',
	-- 	blip = {
	-- 		id = 110, colour = 69, scale = 0.8
	-- 	}, inventory = {
	-- 		{ name = 'ammo-9', price = 5, },
	-- 		{ name = 'WEAPON_KNIFE', price = 200 },
	-- 		{ name = 'WEAPON_BAT', price = 100 },
	-- 		{ name = 'WEAPON_PISTOL', price = 1000, metadata = { registered = true }, license = 'weapon' }
	-- 	}, locations = {
	-- 		vec3(-662.180, -934.961, 21.829),
	-- 		vec3(810.25, -2157.60, 29.62),
	-- 		vec3(1693.44, 3760.16, 34.71),
	-- 		vec3(-330.24, 6083.88, 31.45),
	-- 		vec3(252.63, -50.00, 69.94),
	-- 		vec3(22.56, -1109.89, 29.80),
	-- 		vec3(2567.69, 294.38, 108.73),
	-- 		vec3(-1117.58, 2698.61, 18.55),
	-- 		vec3(842.44, -1033.42, 28.19)
	-- 	}, targets = {
	-- 		{ loc = vec3(-660.92, -934.10, 21.94), length = 0.6, width = 0.5, heading = 180.0, minZ = 21.8, maxZ = 22.2, distance = 2.0 },
	-- 		{ loc = vec3(808.86, -2158.50, 29.73), length = 0.6, width = 0.5, heading = 360.0, minZ = 29.6, maxZ = 30.0, distance = 2.0 },
	-- 		{ loc = vec3(1693.57, 3761.60, 34.82), length = 0.6, width = 0.5, heading = 227.39, minZ = 34.7, maxZ = 35.1, distance = 2.0 },
	-- 		{ loc = vec3(-330.29, 6085.54, 31.57), length = 0.6, width = 0.5, heading = 225.0, minZ = 31.4, maxZ = 31.8, distance = 2.0 },
	-- 		{ loc = vec3(252.85, -51.62, 70.0), length = 0.6, width = 0.5, heading = 70.0, minZ = 69.9, maxZ = 70.3, distance = 2.0 },
	-- 		{ loc = vec3(23.68, -1106.46, 29.91), length = 0.6, width = 0.5, heading = 160.0, minZ = 29.8, maxZ = 30.2, distance = 2.0 },
	-- 		{ loc = vec3(2566.59, 293.13, 108.85), length = 0.6, width = 0.5, heading = 360.0, minZ = 108.7, maxZ = 109.1, distance = 2.0 },
	-- 		{ loc = vec3(-1117.61, 2700.26, 18.67), length = 0.6, width = 0.5, heading = 221.82, minZ = 18.5, maxZ = 18.9, distance = 2.0 },
	-- 		{ loc = vec3(841.05, -1034.76, 28.31), length = 0.6, width = 0.5, heading = 360.0, minZ = 28.2, maxZ = 28.6, distance = 2.0 }
	-- 	}
	-- },

	-- VendingMachineDrinks = {
	-- 	name = 'Vending Machine',
	-- 	inventory = {
	-- 		{ name = 'water', price = 10 },
	-- 		{ name = 'cola', price = 10 },
	-- 	},
	-- 	model = {
	-- 		`prop_vend_soda_02`, `prop_vend_fridge01`, `prop_vend_water_01`, `prop_vend_soda_01`
	-- 	}
	-- }
}
