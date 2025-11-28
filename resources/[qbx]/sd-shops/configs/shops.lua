return { -- Shop locations and configuration
    -- You can add an "illegal" parammeter to any shop, and that shop will then exclusively use dirty money. See the bottom of this list for an example of an illegal shop.
    ['247store_1'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        location = vector3(25.7, -1347.3, 29.49), -- Blip location
        blip = {
            sprite = 52, -- set to 0 to disable the blip
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vec3(24.5, -1345.78, 29.5),
            heading = 269.19,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(24.95, -1347.29, 29.61),
                vector3(24.95, -1344.95, 29.61)
            }
        },
        items = { -- THIS ITEM TABLE IS ONLY USED IF Config.BaseProducts.enabled is set to false. Read more about what it does in the main config file.
            -- Food & Drinks
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            -- Medical
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            -- Tools & Items
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(29.37, -1338.72, 29.33),
            price = 50000
        }
    },

    ['247store_2'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        location = vector3(-3038.71, 585.9, 7.9),
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(-3040.09, 584.1, 7.91),
            heading = 17.55,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-3041.36, 584.27, 8.02),
                vector3(-3039.13, 584.98, 8.02)
            }
        },
        items = {
            { item = 'water', price = 999 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(-3048.62, 586.65, 7.74),
            price = 50000
        }
    },

    ['247store_3'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        location = vector3(-3241.47, 1001.14, 12.83),
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(-3243.79, 1000.12, 12.83),
            heading = 353.16,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-3242.25, 1000.46, 12.95),
                vector3(-3244.57, 1000.66, 12.95)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(-3250.36, 1005.76, 12.67),
            price = 50000
        }
    },

    ['247store_4'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        location = vector3(1728.66, 6414.16, 35.03),
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(1728.49, 6416.57, 35.04),
            heading = 244.71,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1729.33, 6417.12, 35.15),
                vector3(1728.29, 6415.03, 35.15)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(1736.11, 6420.65, 34.87),
            price = 45000
        }
    },

    ['247store_5'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        location = vector3(1697.99, 4924.4, 42.06),
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(1697.14, 4923.35, 42.06),
            heading = 323.42,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1698.31, 4923.37, 42.18),
                vector3(1696.64, 4924.54, 42.18)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(1707.12, 4921.53, 41.88),
            price = 45000
        }
    },

    ['247store_6'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        location = vector3(1961.48, 3739.96, 32.34),
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(1959.31, 3741.39, 32.34),
            heading = 298.67,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1960.49, 3740.27, 32.46),
                vector3(1959.32, 3742.29, 32.46)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(1960.16, 3749.94, 32.18),
            price = 40000
        }
    },

    ['247store_7'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        location = vector3(547.79, 2671.79, 42.15),
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(549.27, 2669.7, 42.16),
            heading = 99.59,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(548.60, 2671.26, 42.27),
                vector3(548.90, 2668.94, 42.27)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(545.18, 2662.20, 41.99),
            price = 45000
        }
    },

    ['247store_8'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        location = vector3(2679.25, 3280.12, 55.24),
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(2676.59, 3280.18, 55.24),
            heading = 331.52,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(2678.25, 3279.83, 55.36),
                vector3(2676.21, 3280.97, 55.36)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(2673.03, 3287.98, 55.08),
            price = 45000
        }
    },

    ['247store_9'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        location = vector3(2557.94, 382.05, 108.62),
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(2555.7, 380.88, 108.62),
            heading = 358.01,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(2557.21, 381.29, 108.74),
                vector3(2554.88, 381.39, 108.74)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(2548.88, 386.18, 108.46),
            price = 55000
        }
    },

    ['247store_10'] = {
        name = '24/7 Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = '247store',
        location = vector3(373.55, 325.56, 103.56),
        blip = {
            sprite = 52,
            color = 2,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'mp_m_shopkeep_01',
            coords = vector3(372.97, 327.88, 103.57),
            heading = 256.84,
            scenario = 'WORLD_HUMAN_STAND_MOBILE'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(373.3, 325.2, 103.56),
                vector3(373.8, 325.8, 103.56)
            }
        },
        items = {
            { item = 'water', price = 5 },
            { item = 'sandwich', price = 8 },
            { item = 'coffee', price = 6 },
            { item = 'burger', price = 12 },
            { item = 'cola', price = 4 },
            { item = 'sprunk', price = 4 },
            { item = 'bandage', price = 15 },
            { item = 'painkillers', price = 10 },
            { item = 'phone', price = 350 },
            { item = 'radio', price = 250 },
            { item = 'lighter', price = 2 },
            { item = 'weapon_flashlight', price = 20 },
            { item = 'repairkit', price = 50 },
        },
        ownership = {
            enabled = true,
            coords = vector3(379.49, 333.46, 103.40),
            price = 60000
        }
    },

    ['liquorstore_1'] = {
        name = 'Liquor Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'liquorstore',
        location = vector3(1135.808, -982.281, 46.415),
        blip = {
            sprite = 93,
            color = 69,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_m_eastsa_02',
            coords = vector3(1134.19, -981.83, 46.42),
            heading = 277.28,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1134.81, -982.36, 46.52)
            }
        },
        items = {
            { item = 'water', price = 10 },
            { item = 'beer', price = 15 },
            { item = 'vodka', price = 45 },
            { item = 'whiskey', price = 60 },
            { item = 'wine', price = 35 },
        },
        ownership = {
            enabled = true,
            coords = vector3(1127.09, -979.76, 45.71),
            price = 70000
        }
    },

    ['liquorstore_2'] = {
        name = 'Liquor Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'liquorstore',
        location = vector3(-1222.915, -906.983, 12.326),
        blip = {
            sprite = 93,
            color = 69,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_m_eastsa_02',
            coords = vector3(-1222.62, -908.67, 12.33),
            heading = 32.92,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-1222.33, -907.82, 12.43)
            }
        },
        items = {
            { item = 'water', price = 10 },
            { item = 'beer', price = 15 },
            { item = 'vodka', price = 45 },
            { item = 'whiskey', price = 60 },
            { item = 'wine', price = 35 },
        },
        ownership = {
            enabled = true,
            coords = vector3(-1221.28, -915.89, 11.46),
            price = 65000
        }
    },

    ['liquorstore_3'] = {
        name = 'Liquor Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'liquorstore',
        location = vector3(-1487.553, -379.107, 40.163),
        blip = {
            sprite = 93,
            color = 69,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_m_eastsa_02',
            coords = vector3(-1485.74, -378.62, 40.16),
            heading = 133.91,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-1486.67, -378.46, 40.27)
            }
        },
        items = {
            { item = 'water', price = 10 },
            { item = 'beer', price = 15 },
            { item = 'vodka', price = 45 },
            { item = 'whiskey', price = 60 },
            { item = 'wine', price = 35 },
        },
        ownership = {
            enabled = true,
            coords = vector3(-1478.98, -375.91, 39.29),
            price = 65000
        }
    },

    ['liquorstore_4'] = {
        name = 'Liquor Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'liquorstore',
        location = vector3(-2968.243, 390.910, 15.043),
        blip = {
            sprite = 93,
            color = 69,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_m_eastsa_02',
            coords = vector3(-2966.51, 390.05, 15.04),
            heading = 86.38,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-2967.03, 390.90, 15.15)
            }
        },
        items = {
            { item = 'water', price = 10 },
            { item = 'beer', price = 15 },
            { item = 'vodka', price = 45 },
            { item = 'whiskey', price = 60 },
            { item = 'wine', price = 35 },
        },
        ownership = {
            enabled = true,
            coords = vector3(-2960.03, 386.82, 14.20),
            price = 55000
        }
    },

    ['liquorstore_5'] = {
        name = 'Liquor Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'liquorstore',
        location = vector3(1166.024, 2708.930, 38.157),
        blip = {
            sprite = 93,
            color = 69,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 'a_m_m_eastsa_02',
            coords = vector3(1166.73, 2710.79, 38.16),
            heading = 180.66,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1165.96, 2710.20, 38.26)
            }
        },
        items = {
            { item = 'water', price = 10 },
            { item = 'beer', price = 15 },
            { item = 'vodka', price = 45 },
            { item = 'whiskey', price = 60 },
            { item = 'wine', price = 35 },
        },
        ownership = {
            enabled = true,
            coords = vector3(1169.59, 2717.43, 37.32),
            price = 50000
        }
    },

    ['hardware_1'] = {
        name = 'Hardware Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'hardware',
        location = vector3(2747.52, 3472.83, 55.67),
        blip = {
            sprite = 402,
            color = 47,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_m_cntrybar_01',
            coords = vector3(2747.52, 3472.83, 55.67),
            heading = 247.24,
        },
        registers = {
            enabled = false,
            coords = {}
        },
        items = {
            { item = 'lockpick', price = 50 },
            { item = 'repairkit', price = 75 },
            { item = 'radio', price = 120 },
            { item = 'flashlight', price = 25 },
            { item = 'rope', price = 30 },
        },
        ownership = {
            enabled = false,
            coords = vector3(2748.5, 3471.5, 55.67),
            price = 80000
        }
    },

    ['hardware_2'] = {
        name = 'Hardware Store',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'hardware',
        location = vector3(46.72, -1749.67, 29.63),
        blip = {
            sprite = 402,
            color = 47,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_m_cntrybar_01',
            coords = vector3(46.72, -1749.67, 29.63),
            heading = 50.47,
        },
        registers = {
            enabled = false,
            coords = {
                vector3(45.0, -1749.5, 29.6)
            }
        },
        items = {
            { item = 'lockpick', price = 50 },
            { item = 'repairkit', price = 75 },
            { item = 'radio', price = 120 },
            { item = 'flashlight', price = 25 },
            { item = 'rope', price = 30 },
        },
        ownership = {
            enabled = false,
            coords = vector3(45.0, -1749.5, 29.6),
            price = 50000
        }
    },

    -- Gun Stores / Ammu-Nation
    ['gunstore_1'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        location = vector3(-660.93, -934.10, 21.95),
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(-661.72, -933.49, 21.83),
            heading = 174.39,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-660.93, -934.10, 21.95)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(-660.93, -934.10, 21.95),
            price = 0
        }
    },

    ['gunstore_2'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        location = vector3(808.86, -2158.51, 29.74),
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(809.74, -2159.03, 29.62),
            heading = 357.41,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(808.86, -2158.51, 29.74)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(808.86, -2158.51, 29.74),
            price = 0
        }
    },

    ['gunstore_3'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        location = vector3(1693.57, 3761.60, 34.82),
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(1692.47, 3761.27, 34.71),
            heading = 225.21,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(1693.57, 3761.60, 34.82)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(1693.57, 3761.60, 34.82),
            price = 0
        }
    },

    ['gunstore_4'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        location = vector3(-330.29, 6085.55, 31.57),
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(-331.33, 6085.29, 31.45),
            heading = 222.96,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-330.29, 6085.55, 31.57)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(-330.29, 6085.55, 31.57),
            price = 0
        }
    },

    ['gunstore_5'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        location = vector3(252.86, -51.63, 70.06),
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(253.62, -51.09, 69.94),
            heading = 66.9,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(252.86, -51.63, 70.06)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(252.86, -51.63, 70.06),
            price = 0
        }
    },

    ['gunstore_6'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        location = vector3(23.69, -1106.46, 29.92),
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(23.06, -1105.67, 29.8),
            heading = 153.96,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(23.69, -1106.46, 29.92)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(23.69, -1106.46, 29.92),
            price = 0
        }
    },

    ['gunstore_7'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        location = vector3(2566.59, 293.13, 108.85),
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(2567.52, 292.54, 108.73),
            heading = 355.88,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(2566.59, 293.13, 108.85)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(2566.59, 293.13, 108.85),
            price = 0
        }
    },

    ['gunstore_8'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        location = vector3(-1117.61, 2700.26, 18.67),
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(-1118.67, 2700.15, 18.55),
            heading = 218.73,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(-1117.61, 2700.26, 18.67)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(-1117.61, 2700.26, 18.67),
            price = 0
        }
    },

    ['gunstore_9'] = {
        name = 'Ammu-Nation',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'gunstore',
        location = vector3(841.06, -1034.76, 28.31),
        blip = {
            sprite = 110,
            color = 1,
            scale = 0.7,
            display = 4
        },
        ped = {
            enabled = true,
            model = 's_m_y_ammucity_01',
            coords = vector3(841.94, -1035.33, 28.19),
            heading = 359.29,
            scenario = 'WORLD_HUMAN_CLIPBOARD'
        },
        registers = {
            enabled = true,
            coords = {
                vector3(841.06, -1034.76, 28.31)
            }
        },
        items = {
            -- Pistols (require weapon license)
            { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
            { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

            -- Ammunition (no license required)
            { item = 'ammo-9', price = 25 },

            -- Attachments (no license required)
            { item = 'at_flashlight', price = 150 },
            { item = 'at_suppressor_light', price = 800 },
            { item = 'at_clip_extended_pistol', price = 300 },
        },
        ownership = {
            enabled = false,
            coords = vector3(841.06, -1034.76, 28.31),
            price = 0
        }
    },

    -- EXAMPLE ILLEGAL SHOP
    -- When 'illegal = true', the shop will ONLY accept black_money as payment
    -- For ox_inventory: uses 'black_money' item (IT WILL TRY TO USE OX FIRST, SINCE MOST PEOPLE USE OX, IF NOT FALLS BACK TO FRAMEWORK SPECIFIC STUFF)
    -- For QBCore: uses 'markedbills' item with 'worth' metadata
    -- For ESX: uses 'black_money' account
    -- To comment out the below shop, remove the --[[ directly below and the closing ]] at the end of the illegal_dealer_1 table.
    --[[['illegal_dealer_1'] = {
        name = 'Black Market Dealer',
        subtitle = 'Open 24/7 - Fast Service',
        shopType = 'blackmarket',
        location = vector3(839.48, 2176.82, 52.29), -- Set your location
        illegal = true, -- THIS FLAG FORCES BLACK_MONEY ONLY
        blip = {
            sprite = 0,
            color = 0,
            scale = 0.0,
            display = 0
        },
        ped = {
            enabled = true,
            model = 'g_m_m_chicold_01',
            coords = vector3(839.48, 2176.82, 52.29), -- Set your ped coords
            heading = 154.0,
            scenario = 'WORLD_HUMAN_DRUG_DEALER'
        },
        registers = {
            enabled = false,
            coords = {}
        },
        items = {
            { item = 'lockpick', price = 500 },
            { item = 'weapon_pistol', price = 15000 },
            -- Add your illegal items here
        },
        -- Ownable illegal shops are essentially the same as normal shopss ownership, only difference is that the society is handeled in dirty money and not in regular cash/bank.
        ownership = {
            enabled = false,
            coords = vector3(0.0, 0.0, 0.0),
            price = 0
        }
    }, 
    ]]
}
