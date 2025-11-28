local Config = {}

-- Class-based defaults (used when no weapon-specific override exists)
-- recoil: seconds to apply vertical kick per shot
-- shake: camera shake amplitude while firing
Config.classes = {
	PISTOL = { recoil = 0.93, shake = 0.012},
	SMG    = { recoil = 0.089, shake = 0.0120},
	RIFLE  = { recoil = 0.099, shake = 0.0098},
}

-- Weapon-specific overrides (by weapon name). If present, overrides class settings
-- Add entries like below; keys must be weapon spawn names (uppercase)
-- Example entries included; tweak as desired
Config.weapons = {
	-- WEAPON_COMPACTRIFLE = { recoil = 0.05, shake = 0.05 },
	-- WEAPON_PISTOL = { recoil = 0.14, shake = 0.08 },
}

-- Fallback for any other weapon types
Config.default = { recoil = 0.087, shake = 0.0090}

return Config
