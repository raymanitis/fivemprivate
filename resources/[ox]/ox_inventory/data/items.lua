return {

	-- pikis 

	['money'] = {
		label = 'Money',
		rarity = 'rare',
	},

	['black_money'] = {
		label = 'Dirty Money',
		rarity = 'rare',
	},

	['id_card'] = {
		label = 'ID Card',
		weight = 100,
		rarity = 'common',
		description = 'Identity card needed to identify yourself',
	},

	-- licenzes visas

	['driver_license'] = {
		label = 'Driver License',
		weight = 100,
		rarity = 'common',
		description = 'Needed to drive a vehicle',
	},

	['weapon_license'] = {
		label = 'Weapon License',
		weight = 100,
		rarity = 'common',
		description = 'Needed to buy a weapon',
	},

	-- edamais

	['baconburger'] = {
		label = 'Baconburger',
		weight = 1,
		rarity = 'common',
		description = 'A delicious baconburger',
	},

	['bagel'] = {
		label = 'Bagel',
		weight = 1,
		rarity = 'common',
		description = 'A delicious bagel',
	},

	["brownie"] = {
		label = "Brownie",
		weight = 1,
		rarity = 'common',
		description = 'A delicious brownie',
		stack = true,
	},

	-- dzeramais


	["bubbletea"] = {
		label = "Bubbletea",
		weight = 1,
		rarity = 'common',
		description = 'A delicious bubbletea',
		stack = true,
	},


	["coffee_frappuccino"] = {
		label = "Coffee Frappuccino",
		weight = 1,
		rarity = 'common',
		description = 'A delicious coffee frappuccino',
		stack = true,
	},


	["water_bottle"] = {
		label = "Water Bottle",
		weight = 1,
		rarity = 'common',
		description = 'A delicious water bottle',
		stack = true,
	},

	-- alcohol

	["beer"] = {
		label = "Beer",
		weight = 1,
		rarity = 'common',
		description = 'A delicious beer',
		stack = true,
	},

	["vodka"] = {
		label = "Vodka",
		weight = 1,
		rarity = 'common',
		description = 'A delicious vodka',
		stack = true,
	},

	-- elektronika

	['phone'] = {
		label = 'Phone',
		weight = 1,
		rarity = 'common',
		description = 'A phone',
		stack = true,
	},

	["racing_tablet"] = {
		label = "Tablet",
		weight = 500,
		stack = false,
		close = true,
		client = {
		   image = "racing_tablet.png",
		   export = "nx_racing.openTablet"
		}
	 },

	 ['radio'] = {
		label = 'Radar',
		weight = 1,
		rarity = 'common',
		description = 'A radar',
		stack = true,
	},

	["racing_tablet"] = {
		label = "Tablet",
        weight = 500,
        stack = false,
        close = true,
        client = {
           image = "racing_tablet.png",
           export = "nx_racing.openTablet"
        }
    },

	-- fishing prikoli visi

	['basicfishingrod'] = {
		label = 'Basic fishing rod',
		description = "A fishing rod for bigginer fisherman",
		rarity = 'common',
		weight = 250,
		stack = true
	},

	['advancedfishingrod'] = {
		label = 'Advanced fishing rod',
		description = "A fishing rod for advanced fisherman",
		rarity = 'uncommon',
		weight = 350,
		stack = true
	},

	['profishingrod'] = {
		label = 'Proffesional fishing rod',
		description = "A fishing rod for proffesional fisherman",
		rarity = 'rare',
		weight = 450,
		stack = true
	},
	
	['basicbait'] = {
		label = 'Basic fishing bait',
		description = "Fishing bait for bigginer fisherman",
		rarity = 'common',
		weight = 250,
		stack = true
	},

	['probait'] = {
		label = 'Advanced fishing bait',
		description = "Fishing bait for advanced fisherman",
		rarity = 'uncommon',
		weight = 350,
		stack = true
	},

	['salmon'] = {
		label = 'Salmon',
		weight = 0,
		stack = false,
		close = false,
		description = '',
		rarity = 'mythic',
	},

	['catfish'] = {
		label = 'Catfish',
		weight = 0,
		stack = false,
		close = false,
		description = '',
		rarity = 'rare',
	},

	['redfish'] = {
		label = 'Red sea bass',
		weight = 0,
		stack = false,
		close = false,
		description = '',
		rarity = 'epic',
	},

	['largemouthbass'] = {
		label = 'Largemouth bass',
		weight = 0,
		stack = false,
		close = false,
		description = '',
		rarity = 'epic',
	},

	['pike'] = {
		label = 'Pike',
		weight = 0,
		stack = false,
		close = false,
		description = '',
		rarity = 'uncommon',
	},

	['bream'] = {
		label = 'Bream',
		weight = 0,
		stack = false,
		close = false,
		description = '',
		rarity = 'common',
	},

	['eal'] = {
		label = 'Eal',
		weight = 0,
		stack = false,
		close = false,
		description = '',
		rarity = 'rare',
	},

	['cod'] = {
		label = 'Cod',
		weight = 0,
		stack = false,
		close = false,
		description = '',
		rarity = 'epic',
	},

	['sparling'] = {
		label = 'Sparling',
		weight = 0,
		stack = false,
		close = false,
		description = '',
		rarity = 'uncommon',
	},

	-- hacking prikkoli

	['lockpick'] = {
		label = 'Lockpick',
		weight = 150,
		rarity = 'common',
		description = 'Used to lockpick something',
	},

	['advancedlockpick'] = {
		label = 'Advanced Lockpick',
		weight = 300,
		rarity = 'uncommon',
		description = 'More durable than a regular lockpick',
	},

	-- drugs visi itemi

	['ammonia'] = {
		label = 'Ammonia',
		weight = 500,
		stack = true,
		rarity = 'common',
	},
	
	['sodium_benzoate'] = {
		label = 'Sodium benzoate',
		weight = 750,
		stack = true,
		rarity = 'common',
	},
	
	['meth_tray'] = {
		label = 'Meth tray',
		weight = 1000,
		stack = true,
		rarity = 'uncommon',
	},
	
	['meth'] = {
		label = 'Meth',
		weight = 1,
		stack = true,
		rarity = 'rare',
	},
	
	['meth_bag'] = {
		label = 'Meth bag',
		weight = 50,
		stack = true,
		rarity = 'rare',
	},
	
	['plastic_bag'] = {
		label = 'Plastic bag',
		weight = 40,
		stack = true,
		rarity = 'common',
	},
	
	['meth_syringe'] = {
		label = 'Meth syringe',
		weight = 75,
		stack = true,
		rarity = 'rare',
	},
	
	-- Cocaine related items
	['coke_seed'] = {
		label = 'Cocaine seed',
		weight = 10,
		stack = true,
		rarity = 'uncommon',
	},
	
	['coke_leaf'] = {
		label = 'Cocaine leaf',
		weight = 50,
		stack = true,
		rarity = 'uncommon',
	},
	
	['coke_paste'] = {
		label = 'Cocaine paste',
		weight = 150,
		stack = true,
		rarity = 'rare',
	},
	
	['coke'] = {
		label = 'Cocaine',
		weight = 1,
		stack = true,
		rarity = 'rare',
	},
	
	['coke_bag'] = {
		label = 'Cocaine bag',
		weight = 50,
		stack = true,
		rarity = 'rare',
	},
	
	['coke_brick'] = {
		label = 'Cocaine brick',
		weight = 200,
		stack = true,
		rarity = 'epic',
	},
	
	['coke_doll'] = {
		label = 'Cocaine doll',
		weight = 500,
		stack = true,
		rarity = 'mythic',
	},
	
	-- Weed related items
	['weed_seed'] = {
		label = 'Weed seed',
		weight = 5,
		stack = true,
		rarity = 'uncommon',
	},
	
	['weed_pot'] = {
		label = 'Flower Pot',
		weight = 500,
		stack = true,
		rarity = 'uncommon',
	},
	
	['trowel'] = {
		label = 'Trowel',
		weight = 150,
		stack = true,
		rarity = 'uncommon',
	},
	
	['weed_bud'] = {
		label = 'Weed bud',
		weight = 25,
		stack = true,
		rarity = 'rare',
	},
	
	['clean_weed_bud'] = {
		label = 'Clean weed bud',
		weight = 20,
		stack = true,
		rarity = 'rare',
	},
	
	['cookie_dough'] = {
		label = 'Cookie dough',
		weight = 200,
		stack = true,
		rarity = 'epic',
	},
	
	['weed_cookie'] = {
		label = 'Weed cookie',
		weight = 50,
		stack = true,
		rarity = 'epic',
	},
	
	['weed_bag'] = {
		label = 'Weed bag',
		weight = 50,
		stack = true,
		rarity = 'rare',
	},
	
	['weed_joint'] = {
		label = 'Weed joint',
		weight = 15,
		stack = true,
		rarity = 'rare',
	},
	
	['weed_papers'] = {
		label = 'Weed papers',
		weight = 5,
		stack = true,
		rarity = 'common',
	},
	
	-- Heroin related items
	['poppy_seeds'] = {
		label = 'Poppy seeds',
		weight = 5,
		stack = true,
		rarity = 'uncommon',
	},
	
	['poppy_plant'] = {
		label = 'Poppy plant',
		weight = 100,
		stack = true,
		rarity = 'uncommon',
	},
	
	['opium'] = {
		label = 'Opium',
		weight = 1,
		stack = true,
		rarity = 'rare',
	},
	
	['heroin'] = {
		label = 'Heroin',
		weight = 1,
		stack = true,
		rarity = 'rare',
	},
	
	['heroin_bag'] = {
		label = 'Heroin bag',
		weight = 50,
		stack = true,
		rarity = 'rare',
	},
	
	['heroin_syringe'] = {
		label = 'Heroin syringe',
		weight = 75,
		stack = true,
		rarity = 'rare',
	},
	
	['syringe'] = {
		label = 'Syringe',
		weight = 25,
		stack = true,
		rarity = 'common',
	},
	
	-- LSD related items
	['ergot_fungus'] = {
		label = 'Ergot fungus',
		weight = 50,
		stack = true,
		rarity = 'uncommon',
	},
	
	['generic_leaf'] = {
		label = 'Leaf',
		weight = 20,
		stack = true,
		rarity = 'uncommon',
	},
	
	['lsd_liquid'] = {
		label = 'LSD liquid',
		weight = 25,
		stack = true,
		rarity = 'rare',
	},
	
	['lsd'] = {
		label = 'LSD',
		weight = 1,
		stack = true,
		rarity = 'rare',
	},
	
	['art_papers'] = {
		label = 'Art papers',
		weight = 5,
		stack = true,
		rarity = 'common',
	},
	
	-- Ecstasy related items
	['safrole_oil'] = {
		label = 'Safrole oil',
		weight = 300,
		stack = true,
		rarity = 'rare',
	},
	
	['ecstasy_crystals'] = {
		label = 'Ecstasy crystals',
		weight = 1,
		stack = true,
		rarity = 'rare',
	},
	
	['ecstasy_pill'] = {
		label = 'Ecstasy pill',
		weight = 15,
		stack = true,
		rarity = 'rare',
	},
	
	-- Mushroom related items
	['mushrooms'] = {
		label = 'Mushrooms',
		weight = 1,
		stack = true,
		rarity = 'rare',
	},
	
	['mushroom_powder'] = {
		label = 'Mushroom powder',
		weight = 1,
		stack = true,
		rarity = 'rare',
	},
	
	['chocolate_chips'] = {
		label = 'Chocolate chips',
		weight = 30,
		stack = true,
		rarity = 'uncommon',
	},
	
	['mushroom_chocolate'] = {
		label = 'Mushroom chocolate',
		weight = 45,
		stack = true,
		rarity = 'rare',
	},
	
	-- Ketamine related items
	['anesthetic'] = {
		label = 'anesthetic',
		weight = 200,
		stack = true,
		rarity = 'uncommon',
	},
	
	['ketamine'] = {
		label = 'Ketamine',
		weight = 1,
		stack = true,
		rarity = 'rare',
	},
	
	['ketamine_bag'] = {
		label = 'Ketamine bag',
		weight = 50,
		stack = true,
		rarity = 'rare',
	},
	
	-- Crack related items
	['baking_soda'] = {
		label = 'Baking soda',
		weight = 100,
		stack = true,
		rarity = 'common',
	},
	
	['crack'] = {
		label = 'Crack',
		weight = 1,
		stack = true,
		rarity = 'rare',
	},
	
	['crack_bag'] = {
		label = 'Crack bag',
		weight = 50,
		stack = true,
		rarity = 'rare',
	},
	
	['crack_pipe'] = {
		label = 'Crack pipe',
		weight = 150,
		stack = true,
		rarity = 'rare',
	},
	
	['crack_syringe'] = {
		label = 'Crack syringe',
		weight = 75,
		stack = true,
		rarity = 'rare',
	},
	
	['pipe'] = {
		label = 'Pipe',
		weight = 100,
		stack = true,
		rarity = 'common',
	},
	
	-- Fentanyl related items
	['npp_chemical'] = {
		label = 'NPP chemical',
		weight = 300,
		stack = true,
		rarity = 'uncommon',
	},
	
	['aniline_solution'] = {
		label = 'Aniline solution',
		weight = 250,
		stack = true,
		rarity = 'uncommon',
	},
	
	['fentanyl'] = {
		label = 'Fentanyl',
		weight = 1,
		stack = true,
		rarity = 'epic',
	},
	
	['fentanyl_bag'] = {
		label = 'Fentanyl bag',
		weight = 25,
		stack = true,
		rarity = 'epic',
	},
	
	['meth_table'] = {
		label = 'Meth table',
		weight = 2250,
		stack = false,
		rarity = 'epic',
	},
	
	['coke_table'] = {
		label = 'Coke table',
		weight = 2250,
		stack = false,
		rarity = 'epic',
	},
	
	['weed_table'] = {
		label = 'Weed table',
		weight = 2250,
		stack = false,
		rarity = 'epic',
	},
	
	['chem_table'] = {
		label = 'Chemistry table',
		weight = 2250,
		stack = false,
		rarity = 'epic',
	},
	
	['burner_phone'] = {
		label = 'Burner phone',
		weight = 200,
		stack = true,
		rarity = 'common',
	},
	
	['light1'] = {
		label = 'Portable Lamp',
		weight = 2000,
		stack = true,
		rarity = 'uncommon',
	},
	
	['light2'] = {
		label = 'Portable Lamp',
		weight = 2000,
		stack = true,
		rarity = 'uncommon',
	},
	
	['fertilizer'] = {
		label = 'Fertilizer',
		weight = 250,
		stack = true,
		rarity = 'common',
	},
	
	['water_can'] = {
		label = 'Watering can',
		weight = 250,
		stack = true,
		rarity = 'common',
	},

	
}