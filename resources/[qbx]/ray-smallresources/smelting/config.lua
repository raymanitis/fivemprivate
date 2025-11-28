Config = {}

Config.SmeltLocations = {
    ['smelt1'] = {
        coords = vector3(1087.6827, -2002.1394, 31.4841),
        radius = 2.0,
        label = 'Smelting Area 1',
        icon = 'fa-solid fa-fire',
        category = 'chopping',
        blip = {
            sprite = 648,
            scale = 0.7,
            color = 17,
            name = 'Smelter',
            coords = vector3(1087.6827, -2002.1394, 31.4841)
        }
    },

    -- ['smelt2'] = {
    --     coords = vector3(1200.0, -2100.0, 30.0),
    --     radius = 2.0,
    --     label = 'Smelting Area 2',
    --     icon = 'fa-solid fa-fire',
    --     category = 'metals',
    --     blip = false -- No blip for this location
    -- }
}

Config.SmeltingItems = {
    [1] = {
        label = 'Copper Ingot',
        icon = 'fas fa-fire',
        duration = 1200,
        maxCount = 100,
        required = {
            { item = 'ls_coal_ore', count = 2 },
            { item = 'ls_copper_ore', count = 5 },
        },
        result = {
            item = 'ls_copper_ingot',
            count = 2,
        },
    },
    [2] = {
        label = 'Iron Ingot',
        icon = 'fas fa-fire',
        duration = 1200,
        maxCount = 100,
        required = {
            { item = 'ls_coal_ore', count = 2 },
            { item = 'ls_iron_ore', count = 3 },
        },
        result = {
            item = 'ls_iron_ingot',
            count = 1,
        },
    },
    [3] = {
        label = 'Silver Ingot',
        icon = 'fas fa-fire',
        duration = 1200,
        maxCount = 100,
        required = {
            { item = 'ls_coal_ore', count = 2 },
            { item = 'ls_silver_ore', count = 3 },
        },
        result = {
            item = 'ls_silver_ingot',
            count = 1,
        },
    },
    [4] = {
        label = 'Gold Ingot',
        icon = 'fas fa-fire',
        duration = 1200,
        maxCount = 100,
        required = {
            { item = 'ls_coal_ore', count = 2 },
            { item = 'ls_gold_ore', count = 3 },
        },
        result = {
            item = 'ls_gold_ingot',
            count = 1,
        },
    },
    [5] = {
        label = 'Nails',
        icon = 'fas fa-fire',
        duration = 1200,
        maxCount = 100,
        required = {
            { item = 'ls_coal_ore', count = 1 },
            { item = 'ls_iron_ingot', count = 1 },
        },
        result = {
            item = 'nails',
            count = 3,
        },
    },
    [6] = {
        label = 'Baggy',
        icon = 'fas fa-fire',
        duration = 1200,
        maxCount = 100,
        required = {
            { item = 'ls_coal_ore', count = 1 },
            { item = 'plastic', count = 2 },
        },
        result = {
            item = 'baggy',
            count = 3,
        },
    },
    [7] = {
        label = 'Steel',
        icon = 'fas fa-fire',
        duration = 1200,
        maxCount = 100,
        required = {
            { item = 'ls_coal_ore', count = 2 },
            { item = 'ls_iron_ingot', count = 3 },
            { item = 'ls_copper_ingot', count = 6 },
        },
        result = {
            item = 'steel',
            count = 5,
        },
    },
    [8] = {
        label = 'Sewing Kits',
        icon = 'fas fa-fire',
        duration = 1200,
        maxCount = 100,
        required = {
            { item = 'gsr_cloth', count = 3 },
            { item = 'ls_copper_ingot', count = 1 },
        },
        result = {
            item = 'sewing_kit',
            count = 1,
        },
    },
    [9] = {
        label = 'Tech Parts',
        icon = 'fas fa-fire',
        duration = 1200,
        maxCount = 100,
        required = {
            { item = 'duct_tape', count = 3 },
            { item = 'ls_copper_ingot', count = 2 },
            { item = 'ls_iron_ingot', count = 3 },
            { item = 'ls_gold_ingot', count = 2 },
        },
        result = {
            item = 'tech_parts',
            count = 3,
        },
    },
     [10] = {
         label = 'Coal',
         icon = 'fas fa-fire',
         duration = 5000,
         maxCount = 100,
         required = {
             { item = 'woodenplank', count = 1 },
         },
         result = {
             item = 'ls_coal_ore',
             count = 7,
         },
    --     -- NOTE: Original config adds multiple items, simplified config only supports one result item,
    --     -- so you may want to split complex outputs or adjust your logic accordingly.
     },
    -- [11] = {
    --     label = 'Bonnet',
    --     icon = 'fas fa-fire',
    --     duration = 5000,
    --     maxCount = 100,
    --     required = {
    --         { item = 'bonnet', count = 1 },
    --         { item = 'ls_coal_ore', count = 2 },
    --     },
    --     result = {
    --         item = 'ls_copper_ingot',
    --         count = 30,
    --     },
    -- },
    -- [12] = {
    --     label = 'Door',
    --     icon = 'fas fa-fire',
    --     duration = 5000,
    --     maxCount = 100,
    --     required = {
    --         { item = 'door', count = 1 },
    --         { item = 'ls_coal_ore', count = 2 },
    --     },
    --     result = {
    --         item = 'steel',
    --         count = 10,
    --     },
    -- },
    -- [13] = {
    --     label = 'Engine',
    --     icon = 'fas fa-fire',
    --     duration = 5000,
    --     maxCount = 100,
    --     required = {
    --         { item = 'engine', count = 1 },
    --         { item = 'ls_coal_ore', count = 5 },
    --     },
    --     result = {
    --         item = 'ls_silver_ingot',
    --         count = 15,
    --     },
    -- },
    -- [14] = {
    --     label = 'Wheel',
    --     icon = 'fas fa-fire',
    --     duration = 5000,
    --     maxCount = 100,
    --     required = {
    --         { item = 'wheel', count = 1 },
    --         { item = 'ls_coal_ore', count = 2 },
    --     },
    --     result = {
    --         item = 'plastic',
    --         count = 20,
    --     },
    -- },
}

return Config