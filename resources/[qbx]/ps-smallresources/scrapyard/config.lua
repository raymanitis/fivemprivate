Config = {}

Config.Debug = false -- Debug mode

Config.ScrapPlaces = {
    pedmodel = "s_m_m_dockwork_01",
    coords = vec4(-1151.0123, -2035.1465, 13.1605, 136.2760),
    blip = {
        name = "Scrap Yard",
        coords = vec3(-1151.0123, -2035.1465, 13.1605),
        sprite = 801,
        color = 31,
        scale = 1,
    },
}

Config.ItemCarrying = {
    {
        prop = 'imp_prop_impexp_bonnet_05a',
        boneIndex = 28422,
        anim = "idle",
        animDict = "anim@heists@box_carry@",
        disableSprint = true,
        disableJump = true,
        disableFight = true,
        offsets = { 0.0, -0.1, 1.5, -80.0, 0.0, 0.0 }
    },

    {
        prop = 'imp_prop_impexp_car_door_02a',
        boneIndex = 28422,
        anim = "idle",
        animDict = "anim@heists@box_carry@",
        disableSprint = true,
        disableJump = true,
        disableFight = true,
        offsets = { -0.5, -0.15, 0.25, 0.0, 0.0, 90.0 }
    },

    {
        prop = 'imp_prop_impexp_trunk_01a',
        boneIndex = 28422,
        anim = "idle",
        animDict = "anim@heists@box_carry@",
        disableSprint = true,
        disableJump = true,
        disableFight = true,
        offsets = { 0.0, 0.0, 0.55, 90.0, 0.0, -180.0 }
    },

    {
        prop = 'prop_wheel_01',
        boneIndex = 28422,
        anim = "idle",
        animDict = "anim@heists@box_carry@",
        disableSprint = true,
        disableJump = true,
        disableFight = true,
        offsets = { 0.0, -0.1, 0.10, 0.0, 0.0, 0.0 }
    },

    {
        prop = 'imp_prop_impexp_engine_part_01a',
        boneIndex = 28422,
        anim = "idle",
        animDict = "anim@heists@box_carry@",
        disableSprint = true,
        disableJump = true,
        disableFight = true,
        offsets = { 0.0, -0.1, -0.15, 0.0, 0.0, -180.0 }
    },
}

Config.Rewards = {
    -- Each entry: item name, min/max amount, chance in percent
    { item = "ls_iron_ingot", min = 4, max = 8, chance = 50 },
    { item = "ls_silver_ingot", min = 3, max = 4, chance = 50 },
    { item = "ls_gold_ingot", min = 2, max = 3, chance = 3 },
    { item = "ls_copper_ingot", min = 3, max = 6, chance = 50 },
    { item = "gluemechanic", min = 1, max = 2, chance = 40 },
    { item = "steel", min = 3, max = 6, chance = 20 },
    { item = "spring", min = 2, max = 6, chance = 5 },
    { item = "highqualitymetal", min = 1, max = 3, chance = 5 },
    { item = "copper_wire", min = 2, max = 5, chance = 20 },
    { item = "tape_electrical", min = 1, max = 3, chance = 20 },
    { item = "circuit_board", min = 1, max = 1, chance = 5 },
}

Config.CooldownLootPlaces = 120 -- Cooldown in seconds

Config.LootPlaces = {
    vec3(-1161.4401, -2047.3673, 14.2135),
    vec3(-1177.5199, -2041.2014, 14.1763),
    vec3(-1173.4983, -2055.1848, 14.1243),
    vec3(-1177.5835, -2069.9817, 14.5898),
    vec3(-1182.5304, -2058.9348, 14.6494),
    vec3(-1179.6987, -2047.2699, 14.0980),
    vec3(-1165.0997, -2036.5885, 13.1391)
}

-- Client-side UX durations and target sizes
Config.SearchDuration = 7000 -- ms
Config.DeliverDuration = 5000 -- ms
Config.TargetRadius = 0.6
Config.CarryExpireSeconds = 180 -- token validity window

return Config