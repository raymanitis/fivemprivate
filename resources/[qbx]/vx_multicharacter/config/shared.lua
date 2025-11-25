return {
	--- Whether to disable automatic resource detection, this is used to detect your framework along with your housing/properties systems.
	--- Set to true if you want to manually specify each value.
	disable_auto_detection = true,

	--- The framework to use if auto-detection is disabled
	--- Values: "none", "esx", "qb", "qbox"
	framework = "qbox",

	---- Your housing/properties system.
	---- Supported Values: "nolag", "tk"
	property_system = "none",

	--- First & Last name must be unique, meaning you cannot have the same name as someone else.
	--- Only works/supports ESX.
	unique_names = true,

	--- Whether players can delete their characters
	can_delete = true,

	--- If enabled, a new client side command is added to logout the specified player.
	---- Command Name: `logout`
	can_logout = false,

	--- The language/locale to use for UI text
	--- Value depends on the file names in `locales/`
	locale = "en",

	--- Set to true if you would like the "Welcome, {full_name}" transition/animation to only appear when creating a new character.
	transition_only_when_char_is_new = true,

	--- Configuration for character creation/registration
	registration_options = {
		--- First name validation rules
		first_name = {
			min_length = 2,
			max_length = 26,
		},

		--- Last name validation rules
		last_name = {
			min_length = 2,
			max_length = 26
		},

		--- Character height validation rules (in cm)
		height = {
			min = 120,
			max = 200
		},

		--- Date of birth validation rules
		date_of_birth = {
			min_year = 1960,
			max_year = 2007,
			format = "MM/DD/YYYY"
		},

		--- Spawn points for new characters (randomly selected)
		new_player_spawn_points = {
			vector4(-1037.8724, -2737.7649, 20.1693, 323.6428)
		}
	},

	--- Character selection screen configuration
	select_screen = {
		--- Camera focus point
		focus_area = vector3(-3.1701, 525.0938, 174.7790),

		--- Camera movement smoothing (1-5)
		smoothing_style = 3,

		--- Time it takes for the camera spline path to complete (This auto loops)
		duration = 60000,

		--- Positions & animations where preview characters are displayed.
		character_positions = {
			{
				position = vector4(2.4083, 526.5923, 174.7309, 326.1613),
				animation = {
					male = {
						dictionary = "timetable@ron@ig_3_couch",
						name = "base",
					},
					female = {
						dictionary = "timetable@reunited@ig_10",
						name = "base_amanda",
					}
				}
			},
			{
				position = vector4(1.2472, 527.2247, 174.7513, 328.1584),
				animation = {
					male = {
						dictionary = "timetable@maid@couch@",
						name = "base",
					},
					female = {
						dictionary = "timetable@reunited@ig_10",
						name = "base_amanda",
					}
				}
			},
			{
				position = vector4(0.8769, 528.2563, 174.6284, 250.6918),
				animation = {
					male = {
						dictionary = "timetable@ron@ig_3_couch",
						name = "base",
					},
					female = {
						dictionary = "timetable@reunited@ig_10",
						name = "base_amanda",
					}
				}
			},
			{
				position = vector4(12.4916, 530.4246, 174.6343, 93.7501),
				animation = {
					male = {
						dictionary = "timetable@ron@ig_3_couch",
						name = "base",
					},
					female = {
						dictionary = "timetable@reunited@ig_10",
						name = "base_amanda",
					}
				}
			},
			{
				position = vector4(11.6255, 531.8963, 174.6467, 154.8575),
				animation = {
					male = {
						dictionary = "timetable@ron@ig_3_couch",
						name = "base",
					},
					female = {
						dictionary = "timetable@reunited@ig_10",
						name = "base_amanda",
					}
				}
			},
			{
				position = vector4(10.2370, 528.5761, 174.6283, 12.9930),
				animation = {
					male = {
						dictionary = "timetable@ron@ig_3_couch",
						name = "base",
					},
					female = {
						dictionary = "timetable@reunited@ig_10",
						name = "base_amanda",
					}
				}
			},
		},

		--- Camera movement nodes for character selection screen
		--- coords: Camera position
		--- rotation: Camera rotation angles
		--- unk1: Unknown parameter (Something related to smoothing i think)
		--- transition_type: Camera transition style
		nodes = {
			{ coords = vector3(-3.1541013718, 521.7256469727, 174.5020141602), rotation = vector3(10.0, 0, -50.0),      unk1 = 1, transition_type = 2 },
			{ coords = vector3(2.649593861, 522.5501708984, 176.0020141602),   rotation = vector3(-15.0, 0.0, 5.0),     unk1 = 1, transition_type = 2 },
			{ coords = vector3(5.0455050468, 524.3555908203, 176.000141602),   rotation = vector3(-19.0, 0.0, 31.9999), unk1 = 1, transition_type = 2 },
			{ coords = vector3(6.8211, 527.3848, 175.6281),                    rotation = vector3(-10, 0.0, -50.7767),  unk1 = 1, transition_type = 2 },
			{ coords = vector3(7.0512, 533.7473, 176.1125),                    rotation = vector3(-10, 0.0, 200.7767),  unk1 = 1, transition_type = 2 },
			{ coords = vector3(2.7827, 532.3774, 175.7428),                    rotation = vector3(-10, 0.0, 36.7767),   unk1 = 1, transition_type = 2 },
			{ coords = vector3(0.5040, 533.9426, 175.6423),                    rotation = vector3(-10, 0.0, 135.7767),  unk1 = 1, transition_type = 2 },
			{ coords = vector3(-3.0116, 529.7524, 175.6998),                   rotation = vector3(-10, 0.0, 112.7767),  unk1 = 1, transition_type = 2 },
			{ coords = vector3(-3.1541013718, 521.7256469727, 174.5020141602), rotation = vector3(10.0, 0, -50.0),      unk1 = 1, transition_type = 2 },
		}
	},

	--- Spawn point categories and locations
	spawn_categories = {
		{
			id = "general",
			label = "General",
			points = {
				{ label = "Legion Square",          coords = vector4(162.9621, -1003.2203, 29.3521, 161.5019) },
				{ label = "LSIA",                   coords = vector4(-1037.5991, -2737.8059, 20.1686, 327.9813) },
				{ label = "Ginger St. - Bus Stop",  coords = vector4(-737.6661, -755.2665, 26.5725, 91.2515) },
				{ label = "Jetsam Terminal",        coords = vector4(802.8143, -3015.1846, 6.0207, 169.3611) },
				{ label = "Downtown LS",            coords = vector4(-177.1092, -1152.8405, 23.1139, 3.0684) },
				{ label = "Paleto - Bus Stop",      coords = vector4(-213.8425, 6181.1948, 31.2606, 219.6961) },
				{ label = "Viceroy Medical Center", coords = vector4(-846.4172, -1186.1667, 5.8413, 24.7001) }
			}
		},
		{
			id = "jobs",
			label = "Specialized Jobs",
			points = {
				{ label = "Mission Row Police Department", coords = vector4(391.7412, -995.3414, 29.4167, 265.6129) },
				{ label = "Pillbox Hospital",              coords = vector4(360.6672, -616.1611, 28.8694, 233.7455) },
				{ label = "Sandy Medical Center",          coords = vector4(1841.7822, 3665.8477, 33.7294, 204.6243) },
				{ label = "Paleto Police Department",      coords = vector4(-426.6882, 6028.3560, 31.4899, 294.1753) }
			}
		},
	}
}
