return {
    -- Inventory Management Features
    InventoryManagement = {
        enableAddFromInventory = true,  -- Show "Add from Inventory" button in stock management
        enableWithdrawFromStock = true,  -- Show "Withdraw from Stock" button in stock management
        requireStockToAddProduct = true  -- If true, items with 0 stock will NOT appear in the Add Product modal (prevents adding non-orderable items as products until they're in stock)
    },

    -- Stock Capacity
    -- Maximum total stock capacity across all items in the shop
    -- Set to 0 or nil for unlimited capacity, this will disable the upgrade also.
    StockCapacity = 5000,  -- Total items that can be stored across all products

    -- Product Slots
    -- Maximum number of different products that can be sold in the shop
    -- Set to 0 or nil for unlimited product slots and it will disable the upgrade also.
    ProductSlots = 5,  -- Maximum number of different products

    -- Employee Slots
    -- Maximum number of employees that can be hired for the shop
    -- Set to 0 or nil for unlimited employee slots and it will disable the upgrade also.
    EmployeeSlots = 3,  -- Maximum number of employees

    -- Network/Franchise System Configuration
    NetworkSystem = { -- PLEASE KEEP THIS AS FALSE, ITS STILL A WORK IN PROGRESS AND DOESNT REALLY DO ANYTHING AT THE MOMENT!
        enabled = false,  -- Set to false to completely disable network/franchise system
        requireUpgrade = true,  -- If true, shops must purchase the network_program upgrade to use it
                                -- If false and enabled = true, network is always available to all shops
    },

    -- Settings Menu Configuration
    -- Control which settings are available in the management menu
    -- Each category can be enabled/disabled entirely by setting enabled = false
    -- Individual settings within enabled categories can also be disabled
    SettingsOptions = {
        -- General Settings Category
        general = {
            enabled = true,      -- Set to false to hide entire General Settings block
            shopName = true,     -- Allow changing shop name
            blipEnabled = true,  -- Allow toggling map blip
            blipColor = true,    -- Allow changing blip color
            blipSprite = true,   -- Allow changing blip sprite
        },

        -- Opening Hours Category
        openingHours = {
            enabled = true,      -- Set to false to hide entire Opening Hours block
            configure = true,    -- Allow configuring opening hours
        },
    },

    -- Available jobs for product restrictions
    Jobs = {
        { value = 'police', label = 'Police Department' },
        { value = 'ambulance', label = 'Emergency Medical Services' },
        { value = 'mechanic', label = 'Mechanic' },
        { value = 'taxi', label = 'Taxi Driver' },
        { value = 'realestate', label = 'Real Estate' },
        { value = 'cardealer', label = 'Car Dealer' },
        { value = 'lawyer', label = 'Lawyer' },
        { value = 'reporter', label = 'Reporter' },
        { value = 'trucker', label = 'Trucker' },
        { value = 'garbage', label = 'Garbage Collector' },
        { value = 'vineyard', label = 'Vineyard Worker' },
        { value = 'fisherman', label = 'Fisherman' },
        { value = 'miner', label = 'Miner' },
        { value = 'lumberjack', label = 'Lumberjack' },
        { value = 'unemployed', label = 'Unemployed' }
    },

    -- Available gangs for product restrictions
    Gangs = {
        { value = 'ballas', label = 'Ballas' },
        { value = 'vagos', label = 'Vagos' },
        { value = 'families', label = 'Families' },
        { value = 'marabunta', label = 'Marabunta Grande' },
        { value = 'bloods', label = 'Bloods' },
        { value = 'crips', label = 'Crips' },
        { value = 'lostmc', label = 'Lost MC' },
        { value = 'cartel', label = 'Cartel' },
        { value = 'triads', label = 'Triads' },
        { value = 'mafia', label = 'Mafia' }
    },

    -- Shop Upgrades Configuration
    -- NOTE: Upgrades build on top of Config.StockCapacity, Management.ProductSlots, and Management.EmployeeSlots (above)
    Upgrades = {
        stock_capacity = {
            enabled = true,
            name = 'Max Stock Capacity',
            description = 'Increase the maximum overall stock capacity for your shop. This determines the total amount of items you can store across all products.',
            icon = 'box',
            levels = {
                -- Each level specifies its cost and the capacity increase it provides
                -- These increases are added to Config.StockCapacity
                { level = 1, cost = 10000, capacityIncrease = 100 },   -- Level 1: $10k for +100 capacity
                { level = 2, cost = 15000, capacityIncrease = 150 },   -- Level 2: $15k for +150 capacity
                { level = 3, cost = 20000, capacityIncrease = 200 },   -- Level 3: $20k for +200 capacity
                { level = 4, cost = 30000, capacityIncrease = 250 },   -- Level 4: $30k for +250 capacity
                { level = 5, cost = 45000, capacityIncrease = 300 },   -- Level 5: $45k for +300 capacity
                { level = 6, cost = 65000, capacityIncrease = 400 },   -- Level 6: $65k for +400 capacity
                { level = 7, cost = 90000, capacityIncrease = 500 },   -- Level 7: $90k for +500 capacity
                { level = 8, cost = 120000, capacityIncrease = 650 },  -- Level 8: $120k for +650 capacity
                { level = 9, cost = 155000, capacityIncrease = 800 },  -- Level 9: $155k for +800 capacity
                { level = 10, cost = 200000, capacityIncrease = 1000 } -- Level 10: $200k for +1000 capacity
            }
        },
        reputation = {
            enabled = true,
            name = 'Reputation',
            description = 'Build your shop reputation to unlock better supplier pricing. Higher reputation grants bigger discounts on stock orders and increases profit margin.',
            icon = 'star',
            levels = {
                -- Each level provides a percentage discount on stock orders
                { level = 1, cost = 100000, discountPercent = 5 },   -- Level 1: $100k for 5% discount
                { level = 2, cost = 200000, discountPercent = 5 },   -- Level 2: $200k for 5% discount (10% total)
                { level = 3, cost = 400000, discountPercent = 5 },   -- Level 3: $400k for 5% discount (15% total)
                { level = 4, cost = 600000, discountPercent = 10 },  -- Level 4: $600k for 10% discount (25% total)
                { level = 5, cost = 1000000, discountPercent = 5 }   -- Level 5: $1m for 5% discount (30% total)
            }
        },
        express_logistics = {
            enabled = true,
            name = 'Express Logistics',
            description = 'Upgrade your delivery fleet to reduce stock order delivery times. Faster deliveries mean quicker restocking and less downtime and more profit!',
            icon = 'truck',
            levels = {
                -- Each level provides a percentage reduction in delivery time
                { level = 1, cost = 150000, speedPercent = 10 },  -- Level 1: $150k for 10% faster deliveries
                { level = 2, cost = 250000, speedPercent = 10 },  -- Level 2: $250k for 10% faster (20% total)
                { level = 3, cost = 450000, speedPercent = 10 },  -- Level 3: $450k for 10% faster (30% total)
                { level = 4, cost = 750000, speedPercent = 15 },  -- Level 4: $750k for 15% faster (45% total)
                { level = 5, cost = 1250000, speedPercent = 5 }   -- Level 5: $1.25m for 5% faster (50% total - half the time!)
            }
        },
        product_slots = {
            enabled = true,
            name = 'Product Slots',
            description = 'Expand your product catalog by increasing the number of different items you can sell. More variety attracts more customers!',
            icon = 'grid',
            levels = {
                -- Each level adds more product slots
                { level = 1, cost = 15000, slotsIncrease = 2 },   -- Level 1: $15k for +2 slots
                { level = 2, cost = 25000, slotsIncrease = 3 },   -- Level 2: $25k for +3 slots
                { level = 3, cost = 40000, slotsIncrease = 3 },   -- Level 3: $40k for +3 slots
                { level = 4, cost = 60000, slotsIncrease = 4 },   -- Level 4: $60k for +4 slots
                { level = 5, cost = 85000, slotsIncrease = 5 },   -- Level 5: $85k for +5 slots
                { level = 6, cost = 120000, slotsIncrease = 5 },  -- Level 6: $120k for +5 slots
                { level = 7, cost = 165000, slotsIncrease = 6 },  -- Level 7: $165k for +6 slots
                { level = 8, cost = 220000, slotsIncrease = 7 },  -- Level 8: $220k for +7 slots
                { level = 9, cost = 285000, slotsIncrease = 8 },  -- Level 9: $285k for +8 slots
                { level = 10, cost = 360000, slotsIncrease = 10 } -- Level 10: $360k for +10 slots (total +53 slots)
            }
        },
        employee_slots = {
            enabled = true,
            name = 'Employee Slots',
            description = 'Expand your team by increasing the number of employees you can hire. More staff means better shop management and operations!',
            icon = 'users',
            levels = {
                -- Each level adds more employee slots
                { level = 1, cost = 75000, slotsIncrease = 2 },   -- Level 1: $75k for +2 slots
                { level = 2, cost = 112500, slotsIncrease = 2 },  -- Level 2: $112.5k for +2 slots
                { level = 3, cost = 168750, slotsIncrease = 3 },  -- Level 3: $168.75k for +3 slots
                { level = 4, cost = 253125, slotsIncrease = 3 },  -- Level 4: $253.125k for +3 slots
                { level = 5, cost = 379687, slotsIncrease = 5 }   -- Level 5: $379.687k for +5 slots (total +15 slots)
            }
        },
        loyalty_program = {
            -- Note: This upgrade only appears if Config.LoyaltySystem.requireUpgrade = true
            -- If requireUpgrade = false, loyalty is automatically available without needing to purchase this
            name = 'Loyalty Program',
            description = 'Unlock a customer loyalty rewards system! Customers earn points with purchases and can redeem them for rewards, encouraging repeat business.',
            icon = 'award',
            levels = {
                -- Single unlock upgrade
                { level = 1, cost = 100000 }  -- $100k one-time unlock
            }
        }
    },

    -- Starting Stock Configuration
    -- Define whether shops should receive starting stock when purchased and how much
    StartingStock = {
        ['247store'] = {
            enabled = true,
            amount = 100
        },
        ['liquorstore'] = {
            enabled = true,
            amount = 150
        },
        ['hardware'] = {
            enabled = true,
            amount = 75
        },
        ['pharmacy'] = {
            enabled = true,
            amount = 200
        },
        ['gunstore'] = {
            enabled = true,
            amount = 50
        }
    },

    -- Stock Delivery Configuration
    -- Controls how long it takes for stock orders to be delivered
    StockDelivery = {
        -- Base delivery time in seconds (applies to all orders regardless of size)
        baseTime = 60,  -- 1 minute base time

        -- Additional time per item ordered (in seconds)
        -- Total delivery time = baseTime + (totalItems * timePerItem)
        timePerItem = 0.5,  -- seconds per item

        -- Minimum delivery time in seconds (orders can't be faster than this)
        minTime = 60,  -- 1 minute minimum

        -- Maximum delivery time in seconds (orders can't be slower than this)
        maxTime = 3600,  -- 30 minutes maximum
    },

    -- Employee Permissions
    -- Owners automatically have all permissions (PLEASE DO NOT TOUCH THIS!)
    Permissions = {
        -- Inventory & Product Management
        'viewProducts',         -- View products in inventory
        'addProduct',           -- Add new products
        'editProduct',          -- Edit existing products
        'deleteProduct',        -- Delete products
        'managePricing',        -- Change product prices and create sales

        -- Stock Management
        'viewStock',            -- View stock levels and inventory
        'addFromInventory',     -- Add items from player inventory to stock
        'withdrawFromStock',    -- Withdraw items from stock to player inventory
        'orderStock',           -- Order stock (add to basket)
        'viewActiveOrders',     -- View active stock orders
        'viewStockHistory',     -- View stock order history

        -- Financial Management
        'viewFinances',         -- View financial data and analytics
        'viewTransactionHistory', -- View transaction history
        'depositMoney',         -- Deposit money to society account
        'withdrawMoney',        -- Withdraw money from society account

        -- Coupon Management
        'viewCoupons',          -- View discount coupons
        'createCoupon',         -- Create new discount coupons
        'editCoupon',           -- Edit existing discount coupons
        'deleteCoupon',         -- Delete discount coupons
        'viewCouponAnalytics',  -- View coupon usage statistics and analytics

        -- Sales Management
        'viewSales',            -- View sales promotions
        'createSale',           -- Create new sales promotions
        'editSale',             -- Edit existing sales promotions
        'deleteSale',           -- Delete sales promotions
        'viewSalesAnalytics',   -- View sales usage statistics and analytics

        'viewProductAnalytics', -- View product sales analytics and reports

        -- Customer Management
        'viewCustomers',        -- View customer data and basic info
        'banCustomer',          -- Ban customers from the shop
        'unbanCustomer',        -- Unban customers from the shop
        'viewBanList',          -- View list of banned customers
        'viewCustomerAnalytics',-- View advanced customer analytics

        -- Employee & Access Management
        'viewEmployees',        -- View employee list and their permissions
        'addEmployees',         -- Add/hire new employees
        'manageEmployees',      -- Change employee permissions
        'removeEmployees',      -- Remove/fire employees from the shop
        'changeEmployeePicture',-- Change employee profile pictures
        'viewEmployeeActivity', -- View employee activity history
        'viewEmployeeLog',      -- View employee log/notes

        -- Loyalty Management
        'viewLoyalty',          -- View loyalty program and customer data
        'changeLoyaltySettings',-- Change loyalty general settings
        'changeTierThresholds', -- Change loyalty tier point thresholds
        'addRewards',           -- Add new loyalty rewards
        'editReward',           -- Edit existing loyalty rewards
        'deleteReward',         -- Delete loyalty rewards
        'viewLoyaltyStats',     -- View loyalty usage statistics

        -- Shop Settings & Configuration
        'viewSettings',         -- View shop settings
        'changeStoreName',      -- Change store name
        'toggleBlip',           -- Toggle blip visibility
        'changeBlipSettings',   -- Change blip icon, color, and display settings
        'changeOpeningHours',   -- Change shop opening hours
        'manageNetwork',        -- Manage networked shops (if multi-shop owner)
        'sellShop',             -- Sell the shop to another player

        -- Upgrade Management
        'viewUpgrades',         -- View available shop upgrades
        'buyUpgrades',          -- Purchase shop upgrades

        -- Transaction & Customer Interaction
        'processSales',         -- Process customer purchases (cashier role)
        'refundTransactions',   -- Issue refunds to customers
        'viewReports',          -- View detailed business reports
    },

    -- Owned Shop Empty Stock Behavior
    -- Controls what happens when an owned shop has no custom products listed
    --
    -- IfNoProductsShowDefault:
    --   true  = Owned shops with no custom products will show default items for that shop type
    --           (using Config.UnownedShopStock for stock levels), for all intents and purposes, it is a default shop if no actual products were added by the owner. (to avoid shops being non-functional due to trolls or whatever :))
    --   false = Owned shops with no custom products will show an empty state message
    --           (owner must configure products before customers can shop...)
    IfNoProductsShowDefault = false,

    -- Stock Display Configuration
    -- Controls visibility of non-orderable items with zero stock in the management stock tab
    --
    -- ShowZeroStockNonOrderableItems:
    --   true  = Items with canOrder=false AND stock=0 WILL appear in stock ordering tab
    --           (useful for seeing all whitelist items even if they can't be ordered and have no stock)
    --   false = Items with canOrder=false AND stock=0 will NOT appear in stock ordering tab
    --           (cleaner interface, only shows orderable items or items with existing stock)
    --
    -- Note: Items with canOrder=true OR stock>0 ALWAYS show regardless of this setting
    ShowZeroStockNonOrderableItems = false,

    -- Product Whitelist
    -- Define what items each shop type is allowed to sell, with ordering options
    -- Each item has: canOrder (boolean), orderPrice (number)
    -- canOrder: If false, item won't appear in orderable items but can be added from inventory to stock/products
    -- orderPrice: The price to order this item from suppliers
    ProductWhitelist = {
        ['247store'] = {
            -- Food & Drinks
            { item = 'water', canOrder = true, orderPrice = 2 },
            { item = 'sandwich', canOrder = true, orderPrice = 3 },
            { item = 'coffee', canOrder = true, orderPrice = 4 },
            { item = 'burger', canOrder = true, orderPrice = 5 },
            { item = 'cola', canOrder = true, orderPrice = 3 },
            { item = 'sprunk', canOrder = true, orderPrice = 3 },
            { item = 'tosti', canOrder = true, orderPrice = 4 },
            { item = 'twerks_candy', canOrder = true, orderPrice = 2 },
            -- Medical
            -- { item = 'bandage', canOrder = true, orderPrice = 5 },
            { item = 'painkillers', canOrder = true, orderPrice = 8 },
            { item = 'firstaid', canOrder = true, orderPrice = 30 },
            -- Tools & Items
            { item = 'phone', canOrder = true, orderPrice = 100 },
            { item = 'radio', canOrder = true, orderPrice = 50 },
            { item = 'lighter', canOrder = true, orderPrice = 2 },
            { item = 'weapon_flashlight', canOrder = true, orderPrice = 20 },
            { item = 'repairkit', canOrder = true, orderPrice = 25 },
            { item = 'lockpick', canOrder = true, orderPrice = 15 },
            -- Misc
            { item = 'cigarette', canOrder = true, orderPrice = 3 },
            { item = 'rolling_paper', canOrder = true, orderPrice = 1 },
            { item = 'scratchcard', canOrder = true, orderPrice = 5 },
            { item = 'id_card', canOrder = true, orderPrice = 50 },
            { item = 'driver_license', canOrder = true, orderPrice = 75 },
            { item = 'whiskey', canOrder = true, orderPrice = 10 },
            { item = 'diving_gear_1', canOrder = true, orderPrice = 10 },
        },
        ['liquorstore'] = {
            -- Alcohol
            { item = 'water', canOrder = true, orderPrice = 2 },
            { item = 'beer', canOrder = true, orderPrice = 4 },
            { item = 'vodka', canOrder = true, orderPrice = 8 },
            { item = 'whiskey', canOrder = true, orderPrice = 10 },
            { item = 'wine', canOrder = true, orderPrice = 9 },
            { item = 'tequila', canOrder = true, orderPrice = 8 },
            { item = 'champagne', canOrder = true, orderPrice = 15 },
            { item = 'rum', canOrder = true, orderPrice = 8 },
            -- Snacks (limited)
            { item = 'chips', canOrder = true, orderPrice = 2 },
            { item = 'chocolate', canOrder = true, orderPrice = 3 },
            { item = 'peanuts', canOrder = true, orderPrice = 2 },
        },
        ['hardware'] = {
            -- Tools & Lockpicking
            { item = 'lockpick', canOrder = true, orderPrice = 15 },
            { item = 'advancedlockpick', canOrder = true, orderPrice = 50 },
            { item = 'screwdriverset', canOrder = true, orderPrice = 25 },
            { item = 'drill', canOrder = true, orderPrice = 50 },
            { item = 'powersaw', canOrder = true, orderPrice = 100 },
            { item = 'welding_torch', canOrder = true, orderPrice = 75 },
            -- Repair & Maintenance
            { item = 'repairkit', canOrder = true, orderPrice = 25 },
            { item = 'advancedrepairkit', canOrder = true, orderPrice = 75 },
            { item = 'cleaningkit', canOrder = true, orderPrice = 20 },
            { item = 'electronickit', canOrder = true, orderPrice = 50 },
            -- Materials & Supplies
            { item = 'metalscrap', canOrder = true, orderPrice = 5 },
            { item = 'plastic', canOrder = true, orderPrice = 3 },
            { item = 'copper', canOrder = true, orderPrice = 8 },
            { item = 'iron', canOrder = true, orderPrice = 10 },
            { item = 'aluminium', canOrder = true, orderPrice = 12 },
            { item = 'glass', canOrder = true, orderPrice = 2 },
            { item = 'rubber', canOrder = true, orderPrice = 3 },
            { item = 'wood', canOrder = true, orderPrice = 2 },
            { item = 'wood_planks', canOrder = true, orderPrice = 5 },
            { item = 'md_nails', canOrder = true, orderPrice = 1 },
            { item = 'md_screw', canOrder = true, orderPrice = 1 },
            -- Electronics & Communication
            { item = 'radio', canOrder = true, orderPrice = 50 },
            { item = 'radiocell', canOrder = true, orderPrice = 5 },
            { item = 'binoculars', canOrder = true, orderPrice = 35 },
            -- Miscellaneous
            { item = 'lighter', canOrder = true, orderPrice = 2 },
            { item = 'bandage', canOrder = true, orderPrice = 5 },
        },
        ['pharmacy'] = {
            -- Medical Supplies
            { item = 'bandage', canOrder = true, orderPrice = 5 },
            { item = 'painkillers', canOrder = true, orderPrice = 8 },
            { item = 'firstaid', canOrder = true, orderPrice = 15 },
            { item = 'medicalbag', canOrder = true, orderPrice = 50 },
            { item = 'vicodin', canOrder = true, orderPrice = 12 },
            { item = 'morphine', canOrder = true, orderPrice = 20 },
            { item = 'antibiotics', canOrder = true, orderPrice = 10 },
            { item = 'gauze', canOrder = true, orderPrice = 3 },
            { item = 'icepack', canOrder = true, orderPrice = 4 },
            { item = 'heatpack', canOrder = true, orderPrice = 4 },
        },
        ['gunstore'] = {
            -- Pistols
            { item = 'WEAPON_PISTOL', canOrder = true, orderPrice = 2500 },
            { item = 'WEAPON_COMBATPISTOL', canOrder = true, orderPrice = 3250 },
            { item = 'WEAPON_APPISTOL', canOrder = true, orderPrice = 3000 },
            { item = 'WEAPON_PISTOL50', canOrder = true, orderPrice = 4250 },
            { item = 'WEAPON_SNSPISTOL', canOrder = true, orderPrice = 1750 },
            { item = 'WEAPON_HEAVYPISTOL', canOrder = true, orderPrice = 3500 },
            { item = 'WEAPON_VINTAGEPISTOL', canOrder = true, orderPrice = 2250 },
            { item = 'WEAPON_CERAMICPISTOL', canOrder = true, orderPrice = 4500 },
            { item = 'WEAPON_PISTOLXM3', canOrder = true, orderPrice = 2750 },

            -- SMGs
            { item = 'WEAPON_MICROSMG', canOrder = true, orderPrice = 6000 },
            { item = 'WEAPON_SMG', canOrder = true, orderPrice = 7000 },
            { item = 'WEAPON_MINISMG', canOrder = true, orderPrice = 5500 },

            -- Shotguns
            { item = 'WEAPON_PUMPSHOTGUN', canOrder = true, orderPrice = 4500 },
            { item = 'WEAPON_SAWNOFFSHOTGUN', canOrder = true, orderPrice = 3750 },
            { item = 'WEAPON_DBSHOTGUN', canOrder = true, orderPrice = 5000 },

            -- Ammunition
            { item = 'ammo-9', canOrder = true, orderPrice = 12 },
            { item = 'ammo-45', canOrder = true, orderPrice = 15 },
            { item = 'ammo-50', canOrder = true, orderPrice = 25 },
            { item = 'ammo-shotgun', canOrder = true, orderPrice = 20 },
            { item = 'ammo-22', canOrder = true, orderPrice = 8 },
            { item = 'ammo-38', canOrder = true, orderPrice = 10 },

            -- Attachments
            { item = 'at_flashlight', canOrder = true, orderPrice = 75 },
            { item = 'at_suppressor_light', canOrder = true, orderPrice = 400 },
            { item = 'at_grip', canOrder = true, orderPrice = 125 },
            { item = 'at_scope_small', canOrder = true, orderPrice = 200 },
            { item = 'at_scope_holo', canOrder = true, orderPrice = 250 },
            { item = 'at_clip_extended_pistol', canOrder = true, orderPrice = 150 },
            { item = 'at_clip_extended_smg', canOrder = true, orderPrice = 175 },
            { item = 'at_clip_extended_shotgun', canOrder = true, orderPrice = 200 },
        }
    },
}
