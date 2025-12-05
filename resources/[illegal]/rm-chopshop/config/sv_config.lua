Config = Config or {}

--[[ --------------------------------------------------------------------------
    Chopshop Mission PED Configuration

    - Change `coords` to move the PED.
    - Change `model` to whatever PED you want (can be a hash or model name).
    - If `enabled = false`, the PED won't spawn.
-----------------------------------------------------------------------------]]

Config.ChopshopPed = {
    enabled = true,

    -- Default PED model (replace with your own if you want)
    -- Example Mexican-style ped: csb_ramp_mex
    model = `csb_ramp_mex`,

    -- vec4(x, y, z, heading) - EDIT THIS TO YOUR DESIRED LOCATION
    -- This uses ox_lib's vec4 helper.
    coords = vec4(1187.6022, 2636.1753, 38.4018, 332.8315),
}

--[[ --------------------------------------------------------------------------
    Chopshop Delivery Zone

    - Area where players must deliver vehicles to be chopped.
    - Use 4 points to roughly form a rectangle around the chop area.
    - You can edit these to adjust the zone.
----------------------------------------------------------------------------]]

Config.ChopshopDeliveryZone = {
    vec3(1172.1931, 2636.3149, 37.7961),
    vec3(1172.2069, 2644.2385, 37.7904),
    vec3(1178.4030, 2644.1069, 37.7903),
    vec3(1178.1561, 2636.0872, 37.7538),
}

--[[ --------------------------------------------------------------------------
    Chopshop Rewards

    - Configure what players receive when finishing a contract.
    - Rewards can be different per contract class (A, B, C, D, etc.).
    - Each reward can have:
        - min / max (amount range)
        - chance (0-100) for roll chance
    - Money payout is just an example; you must hook it to your core.
----------------------------------------------------------------------------]]

Config.ChopshopRewards = {
    -- Worst tier - Class D
    D = {
        items = {
            -- Example item rewards (uncomment / edit as you like)
            {
                name = 'black_money',
                min = 2000,
                max = 4000,
                chance = 100, -- always
            },
            {
                name = 'lockpick',
                min = 1,
                max = 2,
                chance = 50, -- 50% chance
            },
        },

        -- Optional money reward for this class
        money = {
            -- min = 3000,
            -- max = 5000,
            -- chance = 100, -- 100% chance
            -- account = 'cash', -- or 'bank', 'black_money', etc. (depends on your core)
        },
    },

    -- Mid tier - Class C
    C = {
        items = {
            {
                name = 'black_money',
                min = 4000,
                max = 7000,
                chance = 100,
            },
            {
                name = 'advancedlockpick',
                min = 1,
                max = 1,
                chance = 40,
            },
        },
        money = {
            -- min = 6000,
            -- max = 9000,
            -- chance = 100,
            -- account = 'cash',
        },
    },

    -- High tier - Class B
    B = {
        items = {
            -- {
            --     name = 'black_money',
            --     min = 8000,
            --     max = 12000,
            --     chance = 100,
            -- },
            -- {
            --     name = 'c4',
            --     min = 1,
            --     max = 1,
            --     chance = 25,
            -- },
        },
        money = {
            -- min = 12000,
            -- max = 18000,
            -- chance = 100,
            -- account = 'cash',
        },
    },

    -- Best tier - Class A
    A = {
        items = {
            -- {
            --     name = 'black_money',
            --     min = 15000,
            --     max = 25000,
            --     chance = 100,
            -- },
            -- {
            --     name = 'goldbar',
            --     min = 1,
            --     max = 2,
            --     chance = 30,
            -- },
        },
        money = {
            -- min = 25000,
            -- max = 40000,
            -- chance = 100,
            -- account = 'cash',
        },
    },
}

--[[ --------------------------------------------------------------------------
    Chopshop XP / Level Settings

    - startXP: how much XP players have when they first start using the chopshop
    - classes: per-class XP configuration
        - requiredXP: how much XP you need to unlock that class
        - minXP / maxXP: how much XP you gain per completed contract of that class
----------------------------------------------------------------------------]]

Config.ChopshopXP = {
    startXP = 0,

    classes = {
        D = {
            requiredXP = 0,   -- always available
            minXP = 5,
            maxXP = 10,
        },
        C = {
            requiredXP = 50,  -- needs 50+ XP to get C contracts
            minXP = 8,
            maxXP = 15,
        },
        B = {
            requiredXP = 150, -- needs 150+ XP to get B contracts
            minXP = 12,
            maxXP = 20,
        },
        A = {
            requiredXP = 300, -- needs 300+ XP to get A contracts
            minXP = 18,
            maxXP = 30,
        },
    }
}


