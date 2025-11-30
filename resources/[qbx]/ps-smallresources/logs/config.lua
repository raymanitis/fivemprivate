local Config = {}
Config.fivemDeathHashTable = {
	[GetHashKey('WEAPON_ANIMAL')] = 'Animal',
	[GetHashKey('WEAPON_COUGAR')] = 'Cougar',
	[GetHashKey('WEAPON_ADVANCEDRIFLE')] = 'Advanced Rifle',
	[GetHashKey('WEAPON_APPISTOL')] = 'AP Pistol',
	[GetHashKey('WEAPON_ASSAULTRIFLE')] = 'Assault Rifle',
	[GetHashKey('WEAPON_ASSAULTRIFLE_MK2')] = 'Assault Rifke Mk2',
	[GetHashKey('WEAPON_ASSAULTSHOTGUN')] = 'Assault Shotgun',
	[GetHashKey('WEAPON_ASSAULTSMG')] = 'Assault SMG',
	[GetHashKey('WEAPON_AUTOSHOTGUN')] = 'Sweeper Shotgun',
	[GetHashKey('WEAPON_BULLPUPRIFLE')] = 'Bullpup Rifle',
	[GetHashKey('WEAPON_BULLPUPRIFLE_MK2')] = 'Bullpup Rifle Mk2',
	[GetHashKey('WEAPON_BULLPUPSHOTGUN')] = 'Bullpup Shotgun',
	[GetHashKey('WEAPON_CARBINERIFLE')] = 'Carbine Rifle',
	[GetHashKey('WEAPON_CARBINERIFLE_MK2')] = 'Carbine Rifle Mk2',
	[GetHashKey('WEAPON_COMBATMG')] = 'Combat MG',
	[GetHashKey('WEAPON_COMBATMG_MK2')] = 'Combat MG Mk2',
	[GetHashKey('WEAPON_COMBATPDW')] = 'Combat PDW',
	[GetHashKey('WEAPON_COMBATPISTOL')] = 'Combat Pistol',
	[GetHashKey('WEAPON_COMPACTRIFLE')] = 'Compact Rifle',
	[GetHashKey('WEAPON_DBSHOTGUN')] = 'Double Barrel Shotgun',
	[GetHashKey('WEAPON_DOUBLEACTION')] = 'Double Action Revolver',
	[GetHashKey('WEAPON_GUSENBERG')] = 'Gusenberg Sweeper',
	[GetHashKey('WEAPON_HEAVYPISTOL')] = 'Heavy Pistol',
	[GetHashKey('WEAPON_HEAVYSHOTGUN')] = 'Heavy Shotgun',
	[GetHashKey('WEAPON_HEAVYSNIPER')] = 'Heavy Sniper',
	[GetHashKey('WEAPON_HEAVYSNIPER_MK2')] = 'Heavy Sniper',
	[GetHashKey('WEAPON_MACHINEPISTOL')] = 'Machine Pistol',
	[GetHashKey('WEAPON_MARKSMANPISTOL')] = 'Marksman Pistol',
	[GetHashKey('WEAPON_MARKSMANRIFLE')] = 'Marksman Rifle',
	[GetHashKey('WEAPON_MARKSMANRIFLE_MK2')] = 'Marksman Rifle Mk2',
	[GetHashKey('WEAPON_MG')] = 'MG',
	[GetHashKey('WEAPON_MICROSMG')] = 'Micro SMG',
	[GetHashKey('WEAPON_MINIGUN')] = 'Minigun',
	[GetHashKey('WEAPON_MINISMG')] = 'Mini SMG',
	[GetHashKey('WEAPON_MUSKET')] = 'Musket',
	[GetHashKey('WEAPON_PISTOL')] = 'Pistol',
	[GetHashKey('WEAPON_PISTOL_MK2')] = 'Pistol Mk2',
	[GetHashKey('WEAPON_PISTOL50')] = 'Pistol .50',
	[GetHashKey('WEAPON_PUMPSHOTGUN')] = 'Pump Shotgun',
	[GetHashKey('WEAPON_PUMPSHOTGUN_MK2')] = 'Pump Shotgun Mk2',
	[GetHashKey('WEAPON_RAILGUN')] = 'Railgun',
	[GetHashKey('WEAPON_REVOLVER')] = 'Revolver',
	[GetHashKey('WEAPON_REVOLVER_MK2')] = 'Revolver Mk2',
	[GetHashKey('WEAPON_SAWNOFFSHOTGUN')] = 'Sawed-Off Shotgun',
	[GetHashKey('WEAPON_SMG')] = 'SMG',
	[GetHashKey('WEAPON_SMG_MK2')] = 'SMG Mk2',
	[GetHashKey('WEAPON_SNIPERRIFLE')] = 'Sniper Rifle',
	[GetHashKey('WEAPON_SNSPISTOL')] = 'SNS Pistol',
	[GetHashKey('WEAPON_SNSPISTOL_MK2')] = 'SNS Pistol Mk2',
	[GetHashKey('WEAPON_SPECIALCARBINE')] = 'Special Carbine',
	[GetHashKey('WEAPON_SPECIALCARBINE_MK2')] = 'Special Carbine Mk2',
	[GetHashKey('WEAPON_STINGER')] = 'Stinger',
	[GetHashKey('WEAPON_STUNGUN')] = 'Stungun',
	[GetHashKey('WEAPON_VINTAGEPISTOL')] = 'Vintage Pistol',
	[GetHashKey('VEHICLE_WEAPON_PLAYER_LASER')] = 'Vehicle Lasers',
	[GetHashKey('WEAPON_FIRE')] = 'Fire',
	[GetHashKey('WEAPON_FLARE')] = 'Flare',
	[GetHashKey('WEAPON_FLAREGUN')] = 'Flaregun',
	[GetHashKey('WEAPON_MOLOTOV')] = 'Molotov',
	[GetHashKey('WEAPON_PETROLCAN')] = 'Jerry Can',
	[GetHashKey('WEAPON_HELI_CRASH')] = 'Helicopter Crash',
	[GetHashKey('WEAPON_RAMMED_BY_CAR')] = 'Rammed by Vehicle',
	[GetHashKey('WEAPON_RUN_OVER_BY_CAR')] = 'Ranover by Vehicle',
	[GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET')] = 'Vehicle Space Rocket',
	[GetHashKey('VEHICLE_WEAPON_TANK')] = 'Tank',
	[GetHashKey('WEAPON_AIRSTRIKE_ROCKET')] = 'Airstrike Rocket',
	[GetHashKey('WEAPON_AIR_DEFENCE_GUN')] = 'Air Defence Gun',
	[GetHashKey('WEAPON_COMPACTLAUNCHER')] = 'Compact Launcher',
	[GetHashKey('WEAPON_EXPLOSION')] = 'Explosion',
	[GetHashKey('WEAPON_FIREWORK')] = 'Firework',
	[GetHashKey('WEAPON_GRENADE')] = 'Grenade',
	[GetHashKey('WEAPON_GRENADELAUNCHER')] = 'Grenade Launcher',
	[GetHashKey('WEAPON_HOMINGLAUNCHER')] = 'Homing Launcher',
	[GetHashKey('WEAPON_PASSENGER_ROCKET')] = 'Passenger Rocket',
	[GetHashKey('WEAPON_PIPEBOMB')] = 'Pipe bomb',
	[GetHashKey('WEAPON_PROXMINE')] = 'Proximity Mine',
	[GetHashKey('WEAPON_RPG')] = 'RPG',
	[GetHashKey('WEAPON_STICKYBOMB')] = 'Sticky Bomb',
	[GetHashKey('WEAPON_VEHICLE_ROCKET')] = 'Vehicle Rocket',
	[GetHashKey('WEAPON_BZGAS')] = 'BZ Gas',
	[GetHashKey('WEAPON_FIREEXTINGUISHER')] = 'Fire Extinguisher',
	[GetHashKey('WEAPON_SMOKEGRENADE')] = 'Tear Gas',
	[GetHashKey('WEAPON_BATTLEAXE')] = 'Battle Axe',
	[GetHashKey('WEAPON_BOTTLE')] = 'Bottle',
	[GetHashKey('WEAPON_KNIFE')] = 'Knife',
	[GetHashKey('WEAPON_MACHETE')] = 'Machete',
	[GetHashKey('WEAPON_SWITCHBLADE')] = 'Switch Blade',
	[GetHashKey('OBJECT')] = 'Object',
	[GetHashKey('VEHICLE_WEAPON_ROTORS')] = 'Vehicle Rotors',
	[GetHashKey('WEAPON_BALL')] = 'Ball',
	[GetHashKey('WEAPON_BAT')] = 'Baseball Bat',
	[GetHashKey('WEAPON_CROWBAR')] = 'Crowbar',
	[GetHashKey('WEAPON_FLASHLIGHT')] = 'Flashlight',
	[GetHashKey('WEAPON_GOLFCLUB')] = 'Golfclub',
	[GetHashKey('WEAPON_HAMMER')] = 'Hammer',
	[GetHashKey('WEAPON_HATCHET')] = 'Hatchet',
	[GetHashKey('WEAPON_HIT_BY_WATER_CANNON')] = 'Water Cannon',
	[GetHashKey('WEAPON_KNUCKLE')] = 'Knuckle Duster',
	[GetHashKey('WEAPON_NIGHTSTICK')] = 'Night Stick',
	[GetHashKey('WEAPON_POOLCUE')] = 'Pool Cue',
	[GetHashKey('WEAPON_SNOWBALL')] = 'Snowball',
	[GetHashKey('WEAPON_UNARMED')] = 'Fist',
	[GetHashKey('WEAPON_WRENCH')] = 'Pipe Wrench',
	[GetHashKey('WEAPON_DROWNING')] = 'Drowned',
	[GetHashKey('WEAPON_DROWNING_IN_VEHICLE')] = 'Drowned in Vehicle',
	[GetHashKey('WEAPON_BARBED_WIRE')] = 'Barbed Wire',
	[GetHashKey('WEAPON_BLEEDING')] = 'Bleed',
	[GetHashKey('WEAPON_ELECTRIC_FENCE')] = 'Electric Fence',
	[GetHashKey('WEAPON_EXHAUSTION')] = 'Exhaustion',
	[GetHashKey('WEAPON_FALL')] = 'Falling',
	[GetHashKey('WEAPON_RAYPISTOL')] = 'Up-n-Atomizer',
	[GetHashKey('WEAPON_RAYCARBINE')] = 'Unholy Hellbringer',
	[GetHashKey('WEAPON_RAYMINIGUN')] = 'Widowmaker',
	[GetHashKey('WEAPON_STONE_HATCHET')] = 'Stone Hatchet',
	[GetHashKey('WEAPON_DAGGER')] = "Antique Cavalry Dagger", -- MPHIPSTER
	-- MPHEIST3 DLC (v 1868)
	[GetHashKey('WEAPON_CERAMICPISTOL')] = 'Ceramic Pistol',
	[GetHashKey('WEAPON_NAVYREVOLVER')] = 'Navy Revolver',
	[GetHashKey('WEAPON_HAZARDCAN')] = 'Hazardous Jerry Can',
	-- MPHEIST4 DLC (v 2189)
	[GetHashKey('WEAPON_GADGETPISTOL')] = 'Perico Pistol',
	[GetHashKey('WEAPON_MILITARYRIFLE')] = 'Military Rifle',
	[GetHashKey('WEAPON_COMBATSHOTGUN')] = 'Combat Shotgun',
	-- MPSECURITY DLC (v 2545)
	[GetHashKey('WEAPON_EMPLAUNCHER')] = 'EMP Launcher',
	[GetHashKey('WEAPON_HEAVYRIFLE')] = 'Heavy Rifle',
	[GetHashKey('WEAPON_FERTILIZERCAN')] = 'Fertilizer Can',
	[GetHashKey('WEAPON_STUNGUN_MP')] = 'Stungun MP',
	-- MPSUM2 DLC (V 2699)
	[GetHashKey('WEAPON_TACTICALRIFLE')] = 'Tactical Rifle',
	[GetHashKey('WEAPON_PRECISIONRIFLE')] = 'Precision Rifle',
	-- MPCHRISTMAS3 DLC (V 2802)
	[GetHashKey('WEAPON_PISTOLXM3')] = 'WM 29 Pistol',
	[GetHashKey('WEAPON_CANDYCANE')] = 'Candy Cane',
	[GetHashKey('WEAPON_RAILGUNXM3')] = 'Railgun XM3',
	[GetHashKey('WEAPON_ACIDPACKAGE')] = 'Acid Package',
	-- MP2023_01 DLC (V 2944)
	[GetHashKey('WEAPON_TECPISTOL')] = 'Tactical SMG',
	-- MP2023_02 DLC (V 3095)
	[GetHashKey('WEAPON_BATTLERIFLE')] = 'Battle Rifle',
	[GetHashKey('WEAPON_SNOWLAUNCHER')] = 'Snowball Launcher',
	[GetHashKey('WEAPON_HACKINGDEVICE')] = 'Hacking Device',
	-- MP2024_01 DLC (V 3258)
	[GetHashKey('weapon_stunrod')] = 'The Shocker',
}
Config.LocaleForLogs = {
  ["Suicide"] = "Committed Suicide",
  ["Died"] = "Died",
  ["Murdered"] = "Murdered",
  ["Torched"] = "Torched",
  ["Knifed"] = "Knifed",
  ["Pistoled"] = "Pistoled",
  ["Riddled"] = "Riddled",
  ["Rifled"] = "Rifled",
  ["MachineGunned"] = "Machine Gunned",
  ["Pulverized"] = "Pulverized",
  ["Sniped"] = "Sniped",
  ["Obliterated"] = "Obliterated",
  ["Shredded"] = "Shredded",
  ["Bombed"] = "Bombed",
  ["MowedOver"] = "Mowed over",
  ["Flattened"] = "Flattened",
  ["Killed"] = "Killed"
}
Config.WeaponNames = {
	[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Unarmed',
	[tostring(GetHashKey('GADGET_PARACHUTE'))] = 'Parachute',
	[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
	[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
	[tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
	[tostring(GetHashKey('WEAPON_BAT'))] = 'Baseball Bat',
	[tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar',
	[tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golf Club',
	[tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
	[tostring(GetHashKey('WEAPON_DAGGER'))] = 'Antique Cavalry Dagger',
	[tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
	[tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
	[tostring(GetHashKey('WEAPON_ELECKNUCKLE'))] = 'Electric Knuckle Duster',
	[tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
	[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
	[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
	[tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battleaxe',
	[tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
	[tostring(GetHashKey('WEAPON_PIPEWRENCH'))] = 'Wrench',
	[tostring(GetHashKey('WEAPON_STONE_HATCHET'))] = 'Stone Hatchet',
	[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol',
	[tostring(GetHashKey('WEAPON_PISTOL_MK2'))] = 'Pistol Mk2',
	[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
	[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50	',
	[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
	[tostring(GetHashKey('WEAPON_SNSPISTOL_MK2'))] = 'SNS Pistol Mk2',
	[tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
	[tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
	[tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
	[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Heavy Revolver',
	[tostring(GetHashKey('WEAPON_REVOLVER_MK2'))] = 'Heavy Revolver Mk2',
	[tostring(GetHashKey('WEAPON_DOUBLEACTION'))] = 'Double-Action Revolver',
	[tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol',
	[tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Stun Gun',
	[tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
	[tostring(GetHashKey('WEAPON_RAYPISTOL'))] = 'Up-n-Atomizer',
	[tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
	[tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
	[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
	[tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
	[tostring(GetHashKey('WEAPON_SMG_MK2'))] = 'SMG MK2	',
	[tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
	[tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
	[tostring(GetHashKey('WEAPON_MG'))] = 'MG',
	[tostring(GetHashKey('WEAPON_M4'))] = 'POLICE M4',
	[tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG	',
	[tostring(GetHashKey('WEAPON_COMBATMG_MK2'))] = 'Combat MG Mk2',
	[tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
	[tostring(GetHashKey('WEAPON_RAYCARBINE'))] = 'Unholy Deathbringer',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE_MK2'))] = 'Assault Rifle Mk2',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE_MK2'))] = 'Carbine Rifle Mk2',
	[tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE_MK2'))] = 'Special Carbine Mk2',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE_MK2'))] = 'Bullpup Rifle Mk2',
	[tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle',
	[tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER_MK2'))] = 'Heavy Sniper Mk2',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE_MK2'))] = 'Marksman Rifle Mk2',
	[tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
	[tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
	[tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
  	[tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Pipe Bomb',
	[tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
	[tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
	[tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
	[tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher',
	[tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
	[tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
	[tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
	[tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
	[tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
	[tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
	[tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
	[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
	[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RAYMINIGUN'))] = 'Widowmaker',
	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN_MK2'))] = 'Pump Shotgun Mk2',
	[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-off Shotgun',
	[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
	[tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
	[tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
	[tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
	[tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
	[tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Sweeper Shotgun',
	[tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
	[tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
	[tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
	[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Orbital Canon',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLANE_ROCKET'))] = 'Plane Rocket',
	[tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
	[tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
	[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LAZER'))] = 'Lazer',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_BUZZARD'))] = 'Buzzard',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_HUNTER'))] = 'Hunter',
	[tostring(GetHashKey('VEHICLE_WEAPON_WATER_CANNON'))] = 'Water Cannon',
	[tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
	[tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
	[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
	[tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
	[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
	[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Run over by Car',
	[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
	[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
	[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
	[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
	[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
	[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
	[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
	[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
	[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
	[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
	[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
	[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
	[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar',
}
Config.IsMelee = function(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsTorch = function(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsKnife = function(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsPistol = function(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsSub = function(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsRifle = function(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsLight = function(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsShotgun = function(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsSniper = function(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsHeavy = function(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsMinigun = function(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsBomb = function(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB', 'WEAPON_PIPEBOMB'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsVeh = function(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end
Config.IsVK = function(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for _, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

return Config