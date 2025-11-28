return {
    -- Locale Configuration
    -- Defines which language file to use from the locales folder
    -- Available: 'en' for English, 'de' for German (Deutsch)
    Locale = 'en',

    -- Enable debug prints and polyzones
    Debug = false,

    -- Ped spawn distance (distance at which peds will spawn/despawn)
    PedSpawnDistance = 50.0,

    -- Interaction distance
    InteractionDistance = 2.0,

    -- Society Payment System Configuration
    -- Allows players to purchase items using their job society funds
    SocietyPayments = {
        enabled = false,  -- Set to false to completely disable society payments in shops

        -- Define which societies/jobs can use society funds and what grade is required
        -- Format: ['society_name'] = { minGrade = 0, label = 'Display Name' }
        allowedSocieties = {
            ['police'] = {
                minGrade = 2,  -- Minimum job grade required to use society funds (sergeant and above)
                label = 'Police Society'
            },
            ['ambulance'] = {
                minGrade = 2,  -- Minimum grade to use EMS funds
                label = 'Ambulance Society'
            },
            ['mechanic'] = {
                minGrade = 1,  -- Mechanics can use society funds from grade 1+
                label = 'Mechanic Society'
            },
            -- Add more societies as needed
            -- ['realestate'] = {
            --     minGrade = 3,
            --     label = 'Real Estate Agency'
            -- },
        }
    },

    -- Unowned Shop Stock Configuration
    -- Controls starting stock levels for shops that don't have an owner
    -- This allows you to configure whether unowned shops have infinite stock or limited, tracked stock
    UnownedShopStock = {
        -- Global settings (can be overridden per shop type below)
        default = {
            infinite = false,        -- If true, unowned shops have infinite stock (999)
            startingStock = 50,     -- If infinite = false, this is the starting stock amount per item
        },

        -- Per-shop-type overrides (optional)
        -- If not specified for a shop type, it will use the default settings above
        -- ['247store'] = {
        --     infinite = true,
        --     startingStock = 50,
        -- },
        -- Example: liquorstore could have different settings
        -- ['liquorstore'] = {
        --     infinite = true,
        --     startingStock = 0,  -- Ignored when infinite = true
        -- },
    },

    -- Coupon system, these are the default coupons that are usable, if shops are ownable, owners can make these freely.
    Coupons = {
        -- ['WELCOME10'] = {
        --     discount = 10, -- 10% off
        --     description = 'Welcome discount'
        -- },
        -- ['SUMMER20'] = {
        --     discount = 20, -- 20% off
        --     description = 'Summer sale'
        -- },
        -- ['VIP25'] = {
        --     discount = 25, -- 25% off
        --     description = 'VIP discount'
        -- },
        -- ['GRANDOPENING'] = {
        --     discount = 15, -- 15% off
        --     description = 'Grand opening special'
        -- }
    },

    -- Loyalty System Configuration
    LoyaltySystem = {
        enabled = true,  -- Set to false to completely disable loyalty system (This setting also applies to the management menu, i.e. if false, even owned shops can't have loyalty system)
        requireUpgrade = true,  -- If true, shops must purchase the loyalty_program upgrade to use it
                               -- If false and enabled = true, loyalty is always available to all shops
        pointsPerDollar = 1,  -- How many loyalty points earned per dollar spent (by default)
    },

    -- Default Loyalty Rewards (for non-owned shops)
    -- These are the default rewards shown when a shop isn't owned
    DefaultLoyaltyRewards = {
        {
            id = 'default_reward_1',
            name = '5% Off Coupon',
            description = 'Get 5% off your next purchase',
            type = 'coupon',
            cost = 100,
            icon = '🎫',
            discountPercent = 5
        },
        {
            id = 'default_reward_2',
            name = '10% Off Coupon',
            description = 'Get 10% off your next purchase',
            type = 'coupon',
            cost = 250,
            icon = '🎟️',
            discountPercent = 10
        },
        -- {
        --     id = 'default_reward_3',
        --     name = '15% Off Coupon',
        --     description = 'Get 15% off your next purchase',
        --     type = 'coupon',
        --     cost = 500,
        --     icon = '🏷️',
        --     discountPercent = 15
        -- },
        -- {
        --     id = 'default_reward_4',
        --     name = '20% Off Coupon',
        --     description = 'Get 20% off your next purchase',
        --     type = 'coupon',
        --     cost = 1000,
        --     icon = '🏷️',
        --     discountPercent = 20
        -- },
    },

    -- Shop Ownership Limits
    -- Controls how many shops a single player can own
    OwnershipLimits = {
        enabled = true,  -- Set to false to disable ownership limits (unlimited shops)
        maxShops = 1     -- Maximum number of shops one player can own (ignored if enabled = false)
    },

    -- Shop Type Display Configuration
    -- Define the icon and color scheme for each shop type
    -- Icons: Use ANY icon name from https://lucide.dev/icons (use the kebab-case format shown on the site)
    -- Available colors: emerald, purple, orange, red, slate, blue, green, yellow, pink, indigo,
    --                   cyan, teal, lime, amber, rose, fuchsia, violet, sky, gray, zinc, neutral, stone
    ShopTypeDisplay = {
        ['247store'] = {
            icon = 'shopping-cart',
            color = 'emerald'
        },
        ['liquorstore'] = {
            icon = 'wine',
            color = 'purple'
        },
        ['hardware'] = {
            icon = 'wrench',
            color = 'orange'
        },
        ['pharmacy'] = {
            icon = 'heart',
            color = 'red'
        },
        ['gunstore'] = {
            icon = 'crosshair',
            color = 'red'
        }
    },

    -- Global Product Categories
    -- Centralized category definitions used across all shops
    -- Each category defines its title, color, and which shop types use it
    -- Categories can be referenced by their key (e.g., 'food', 'medical') in product definitions
    Categories = {
        colorsEnabled = true, -- Set to false to disable category colors/badges globally

        ['food'] = {
            title = 'Food & Drinks',
            color = 'green',
            types = {'247store', 'liquorstore'}, -- Shop types that use this category (MAKE EMPTY ARRAY IF CATEGORY SHOULD APPLY TO ALL TYPES)
            items = {'water', 'sandwich', 'coffee', 'burger', 'cola', 'sprunk', 'tosti', 'twerks_candy', 'cigarette', 'beer', 'vodka', 'whiskey', 'wine', 'tequila', 'champagne', 'rum'} -- Items belonging to this category
        },
        ['alcohol'] = {
            title = 'Alcohol',
            color = 'orange',
            types = {'liquorstore'},
            items = {'beer', 'vodka', 'whiskey', 'wine', 'tequila', 'champagne', 'rum'}
        },
        ['snacks'] = {
            title = 'Snacks',
            color = 'yellow',
            types = {'liquorstore'},
            items = {'chips', 'chocolate', 'peanuts'}
        },
        ['medical'] = {
            title = 'Medical',
            color = 'red',
            types = {'247store', 'pharmacy'},
            items = {'bandage', 'painkillers', 'firstaid', 'medicalbag', 'vicodin', 'morphine', 'antibiotics'}
        },
        ['tools'] = {
            title = 'Tools',
            color = 'blue',
            types = {'247store', 'hardware'},
            items = {'lighter', 'weapon_flashlight', 'repairkit', 'lockpick', 'rolling_paper', 'scratchcard', 'id_card', 'driver_license', 'advancedlockpick', 'screwdriverset', 'drill', 'powersaw', 'welding_torch', 'advancedrepairkit', 'cleaningkit'}
        },
        ['electronics'] = {
            title = 'Electronics',
            color = 'cyan',
            types = {'247store', 'hardware'},
            items = {'phone', 'radio', 'electronickit', 'radiocell', 'binoculars'}
        },
        ['weapons'] = {
            title = 'Weapons',
            color = 'red',
            types = {'weaponshop', 'gunstore'},
            items = {'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_APPISTOL', 'WEAPON_PISTOL50', 'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_CERAMICPISTOL', 'WEAPON_PISTOLXM3', 'WEAPON_SMG', 'WEAPON_MICROSMG', 'WEAPON_MINISMG', 'WEAPON_PUMPSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN', 'WEAPON_DBSHOTGUN'}
        },
        ['ammo'] = {
            title = 'Ammunition',
            color = 'orange',
            types = {'weaponshop', 'gunstore'},
            items = {'ammo-9', 'ammo-45', 'ammo-50', 'ammo-shotgun', 'ammo-22', 'ammo-38', 'ammo-rifle', 'ammo-rifle2', 'ammo-sniper'}
        },
        ['attachments'] = {
            title = 'Attachments',
            color = 'purple',
            types = {'weaponshop', 'gunstore'},
            items = {'at_flashlight', 'at_suppressor_light', 'at_suppressor_heavy', 'at_grip', 'at_scope_small', 'at_scope_holo', 'at_scope_medium', 'at_clip_extended_pistol', 'at_clip_extended_smg', 'at_clip_extended_shotgun', 'at_clip_extended_rifle'}
        },
        -- ['clothing'] = {
        --     title = 'Clothing',
        --     color = 'pink',
        --     types = {'clothingstore'},
        --     items = {} -- Add clothing items as needed
        -- },
        ['accessories'] = {
            title = 'Accessories',
            color = 'cyan',
            types = {'clothingstore'},
            items = {} -- Add accessory items as needed
        },
        ['automotive'] = {
            title = 'Automotive',
            color = 'gray',
            types = {'hardware'},
            items = {} -- Add automotive items as needed
        },
        ['hardware'] = {
            title = 'Hardware',
            color = 'blue',
            types = {'hardware'},
            items = {} -- Add hardware-specific items as needed
        },
        ['materials'] = {
            title = 'Materials',
            color = 'gray',
            types = {'hardware'},
            items = {'metalscrap', 'plastic', 'copper', 'iron', 'aluminium', 'glass', 'rubber', 'wood', 'wood_planks', 'md_nails', 'md_screw'}
        },
        ['supplies'] = {
            title = 'Supplies',
            color = 'pink',
            types = {'pharmacy'},
            items = {'gauze', 'icepack', 'heatpack'}
        },
    },

        -- Base Products Configuration
    -- When enabled, all shops of a type will use these items and prices
    -- This replaces the individual shop item definitions
    -- When disabled, falls back to using individual shop item definitions from Config.Shops[shopId].items
    -- If a type of store is used in Config.Shops[shopId] that isn't defined here, it'll fall back to using the individual shop item definitions.
    BaseProducts = {
        enabled = true, -- Set to false to use individual shop item definitions instead

        -- 24/7 Store Configuration
        ['247store'] = {
            items = {
                { item = 'water', price = 2 },
                { item = 'coffee', price = 4 },
                { item = 'burger', price = 8 },
                { item = 'cola', price = 3 },
                { item = 'sprunk', price = 3 },
                { item = 'tosti', price = 5 },
                { item = 'bandage', price = 15 },
                { item = 'painkillers', price = 10 },
                { item = 'firstaid', price = 50 },
                { item = 'phone', price = 350 },
                { item = 'radio', price = 250 },
                { item = 'lighter', price = 2 },
                { item = 'weapon_flashlight', price = 20 },
                { item = 'repairkit', price = 50 },
                { item = 'lockpick', price = 25 },
                { item = 'rolling_paper', price = 2 },
                { item = 'id_card', price = 100 },
                { item = 'driver_license', price = 150 }
            }
        },

        -- Liquor Store Configuration
        ['liquorstore'] = {
            items = {
                { item = 'water', price = 2 },
                { item = 'beer', price = 5 },
                { item = 'vodka', price = 15 },
                { item = 'whiskey', price = 20 },
                { item = 'wine', price = 18 },
                { item = 'tequila', price = 22 },
                { item = 'champagne', price = 30 },
                { item = 'rum', price = 16 },
                { item = 'chips', price = 3 },
                { item = 'chocolate', price = 4 },
                { item = 'peanuts', price = 3 }
            }
        },

        -- Hardware Store Configuration
        ['hardware'] = {
            items = {
                { item = 'lockpick', price = 50 },
                { item = 'advancedlockpick', price = 150 },
                { item = 'screwdriverset', price = 75 },
                { item = 'drill', price = 200 },
                { item = 'powersaw', price = 300 },
                { item = 'welding_torch', price = 250 },
                { item = 'repairkit', price = 100 },
                { item = 'advancedrepairkit', price = 200 },
                { item = 'cleaningkit', price = 50 },
                { item = 'electronickit', price = 150 },
                { item = 'metalscrap', price = 10 },
                { item = 'plastic', price = 8 },
                { item = 'copper', price = 15 },
                { item = 'iron', price = 12 },
                { item = 'aluminium', price = 10 },
                { item = 'glass', price = 5 },
                { item = 'rubber', price = 8 },
                { item = 'wood', price = 5 },
                { item = 'wood_planks', price = 10 },
                { item = 'md_nails', price = 2 },
                { item = 'md_screw', price = 2 },
                { item = 'radio', price = 250 },
                { item = 'radiocell', price = 15 },
                { item = 'binoculars', price = 100 },
                { item = 'lighter', price = 2 },
                { item = 'bandage', price = 15 }
            }
        },

        -- Pharmacy Configuration
        ['pharmacy'] = {
            items = {
                { item = 'bandage', price = 15 },
                { item = 'painkillers', price = 10 },
                { item = 'firstaid', price = 50 },
                { item = 'medicalbag', price = 150 },
                { item = 'vicodin', price = 30 },
                { item = 'morphine', price = 50 },
                { item = 'antibiotics', price = 25 },
                { item = 'gauze', price = 8 },
                { item = 'icepack', price = 10 },
                { item = 'heatpack', price = 10 }
            }
        },

        -- Gun Store Configuration
        ['gunstore'] = {
            items = { -- You can remove the license param entirely and then that item won't be locked behind the license requirement.
                -- Pistols (require weapon license)
                { item = 'WEAPON_PISTOL', price = 5000, license = 'weapon' },
                { item = 'WEAPON_COMBATPISTOL', price = 6500, license = 'weapon' },

                -- Ammunition (no license required)
                { item = 'ammo-9', price = 25 },

                -- Attachments (no license required)
                { item = 'at_flashlight', price = 150 },
                { item = 'at_suppressor_light', price = 800 },
                { item = 'at_clip_extended_pistol', price = 300 },
            }
        }
    },
}
