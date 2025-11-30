local Config = {}

-- Security Configuration
Config.Security = {
    MAX_DISTANCE = 3.0, -- Maximum distance from shop NPC
    COOLDOWN_TIME = 2000, -- 2 seconds between transactions
    MAX_TRANSACTIONS_PER_MINUTE = 9999999,
    SESSION_TIMEOUT = 300000, -- 5 minutes session timeout
    MAX_QUANTITY_PER_TRANSACTION = 1000, -- Maximum items per transaction
    MAX_VALUE_PER_TRANSACTION = 100000000, -- Maximum value per transaction
    ENABLE_DISCORD_LOGGING = true, -- Enable/disable Discord logging
    ENABLE_EXPLOIT_BANNING = true, -- Enable/disable automatic banning for exploits
}

Config.Shops = {
    {
        npcModel = 's_m_y_shop_mask',
        coords = vector4(182.4445, -1319.3136, 29.3162, 239.9444), -- Vector4 includes heading
        dialog = {
            title = "Pawnshop",
            greeting = "Hey there! What do you want to do?",
            options = {
                {
                    id = 'sell_fruits',
                    label = "Sell Goods",
                    icon = 'fas fa-apple-alt',
                    close = true,
                    items = {
                        { name = 'diamond_ring',           label = 'Diamond Ring',           price = 70 },
                        { name = 'rolex',                  label = 'Rolex',                  price = 95 },
                        { name = 'card_4090',              label = 'Card 4090',              price = 1000 },
                        { name = 'card_4080',              label = 'Card 4080',              price = 900 },
                        { name = '10kgoldchain',           label = '10k Gold Chain',         price = 100 },
                        { name = 'goldchain',              label = 'Gold Chain',             price = 60 },

                        -- Adjusted (Low-cost) items
                        { name = 'diamond',                label = 'Diamond',                price = 160 },
                        { name = 'ruby',                   label = 'Ruby',                   price = 300 },
                        { name = 'danburite',              label = 'Danburite',              price = 100 },
                        { name = 'painting',               label = 'Painting',               price = 95 }, -- was 83
                        { name = 'silver_coin',            label = 'Silver Coin',            price = 50 }, -- was 40
                        { name = 'gold_coin',              label = 'Gold Coin',              price = 60 }, -- was 45
                        { name = 'charlotte_ring',         label = 'Charlotte Ring',         price = 55 }, -- was 50
                        { name = 'simbolos_chain',         label = 'Simbolos Chain',         price = 60 }, -- was 50
                        { name = 'action_figure',          label = 'Action Figure',          price = 50 }, -- was 40
                        { name = 'nominos_ring',           label = 'Nominos Ring',           price = 65 },
                        { name = 'boss_chain',             label = 'Boss Chain',             price = 70 },
                        { name = 'branded_cigarette',      label = 'Branded Cigarette',      price = 6 }, -- was 5
                        { name = 'branded_cigarette_box',  label = 'Branded Cigarette Box',  price = 13 }, -- was 12
                        { name = 'ninja_figure',           label = 'Ninja Figure',           price = 50 }, -- was 40
                        { name = 'ancient_egypt_artifact', label = 'Ancient Egypt Artifact', price = 100 },
                        { name = 'television',             label = 'Television',             price = 80 },
                        { name = 'music_player',           label = 'Music Player',           price = 70 },
                        { name = 'microwave',              label = 'Microwave',              price = 60 },
                        { name = 'computer',               label = 'Computer',               price = 105 },
                        { name = 'coffee_machine',         label = 'Coffee Machine',         price = 35 }, -- was 20

                        { name = 'advanced_drill',         label = 'Advanced Drill',         price = 250 }, -- was 20
                        { name = 'drill',                  label = 'Drill',         price = 100 }, -- was 20
                        { name = 'goldbar',              label = 'Gold Bar',               price = 2000 }, -- was 100
                        { name = 'gold_necklace', label = 'Gold Necklace', price = 500 }, -- was 500

                        { name = 'pmonkey', label = 'Monkey statue', price = 10000 },
                        { name = 'pbottle', label = 'ottle', price = 2000 },
                        { name = 'pnecklace', label = 'Necklace', price = 3000 },
                        { name = 'panther', label = 'Panther statue', price = 15000 },
                        { name = 'pinkdiamond', label = 'Pink diamond', price = 8000 },

                        -- diving sudi

                        { name = 'ls_old_boot', label = 'Old Boot', price = 45 },
                        { name = 'ls_wood_plank', label = 'Wood Plank', price = 40 },
                        { name = 'ls_rusted_padlock', label = 'Rusted Padlock', price = 43 },
                        { name = 'ls_rusted_key', label = 'Rusted Key', price = 42 },
                        { name = 'ls_rusted_gear', label = 'Rusted Gear', price = 35 },
                        { name = 'ls_seashell', label = 'Seashell', price = 65 },
                        { name = 'ls_seaweed', label = 'Seaweed', price = 70 },
                        { name = 'ls_rusted_muffler', label = 'Rusted Muffler', price = 69 },
                        { name = 'ls_broken_cd', label = 'Broken Cd', price = 68 },
                        { name = 'ls_diving_goggles', label = 'Diving Goggles', price = 50 },
                        { name = 'ls_fishing_net', label = 'Fishing Net', price = 100 },
                        { name = 'ls_old_camera', label = 'Old Camera', price = 95 },
                        { name = 'ls_military_helmet', label = 'Military Helmet', price = 105 },
                        { name = 'ls_old_compass', label = 'Old Compass', price = 125 },
                        { name = 'ls_old_watch', label = 'Old Watch', price = 95 },
                        { name = 'ls_conch_shell', label = 'Conch Shell', price = 89 },


                    }

                },
                {
                    id = 'close',
                    label = "Never mind",
                    icon = 'fas fa-ban',
                    close = true,
                },
            },
        },
        blip = {
            enabled = true,    -- Enable/disable blip for this shop
            sprite = 52,       -- Blip sprite ID
            color = 1,         -- Blip color ID
            scale = 0.8,       -- Blip size/scale
            name = "Pawnshop", -- Blip text
        },
        moneyType = 'cash',    -- Type of money given: 'cash', 'bank', 'crypto', 'black_money'
    },

    {
        npcModel = 's_m_y_shop_mask',
        coords = vector4(-1687.0125, -1072.1692, 13.1522, 47.5309), -- Vector4 includes heading
        dialog = {
            title = "Fish Vendor",
            greeting = "Fresh catch! What do you want to do?",
            options = {
                {
                    id = 'sell_fish',
                    label = "Sell Fish",
                    icon = 'fas fa-fish',
                    close = true,
                    items = {
                         { name = 'tuna', label = 'Tuna', price = 100 },
                         { name = 'salmon', label = 'Salmon', price = 50 },
                         { name = 'anchovy', label = 'Anchovy', price = 30 },
                         { name = 'trout', label = 'Trout', price = 60 },
                     },
                },
                {
                    id = 'close',
                    label = "Never mind",
                    icon = 'fas fa-ban',
                    close = true,
                },
            },
        },
        blip = {
            enabled = true,       -- Enable/disable blip for this shop
            sprite = 356,         -- Fish icon blip
            color = 3,            -- Blip color ID
            scale = 0.8,          -- Blip size/scale
            name = "Fish Vendor", -- Blip text
        },
        moneyType = 'cash',       -- Type of money given: 'cash', 'bank', 'crypto', 'black_money'
    },
    {
        npcModel = 's_m_y_shop_mask',                             -- Miner-looking ped model (you can change)
        coords = vector4(1043.9930, -2158.1101, 31.5847, 265.6923), -- Example mining area, change if needed
        dialog = {
            title = "Mining Vendor",
            greeting = "Hey there, prospector! What do you want to do?",
            options = {
                {
                    id = 'sell_ores',
                    label = "Sell Ores",
                    icon = 'fas fa-ban',
                    close = true,
                    items = {
                        { name = 'ls_copper_ingot', label = 'Copper Ingot', price = 10 },
                        { name = 'ls_iron_ingot',   label = 'Iron Ingot',   price = 15 },
                        { name = 'ls_silver_ingot', label = 'Silver Ingot', price = 30 },
                        { name = 'ls_gold_ingot',   label = 'Gold Ingot',   price = 90 },
                        { name = 'gunpowder',       label = 'Gunpowder',    price = 5 },
                    },
                },
                {
                    id = 'close',
                    label = "Never mind",
                    icon = 'fas fa-ban',
                    close = true,
                },
            },
        },
        blip = {
            enabled = true,
            sprite = 617, -- Pickaxe blip
            color = 81,   -- Gold color
            scale = 0.8,
            name = "Mining Vendor",
        },
        moneyType = 'cash',    -- Type of money given: 'cash', 'bank', 'crypto', 'black_money'
    },
    {
        npcModel = 's_m_m_dockwork_01',                             -- Miner-looking ped model (you can change)
        coords = vector4(5010.9575, -5757.0986, 28.8987, 30.0753), -- Example mining area, change if needed
        dialog = {
            title = "Weapon Vendor",
            greeting = "Hey there, prospector! What do you want to do?",
            options = {
                {
                    id = 'sell_guns',
                    label = "Sell Guns",
                    icon = 'fas fa-ban',
                    close = true,
                    items = {
                        { name = 'weapon_assaultrifle', label = 'Assault Rifle',     price = 125000 },
                        { name = 'weapon_bullpuprifle', label = 'Bullpup Rifle',     price = 125000 },
                        { name = 'weapon_advancedrifle',label = 'Aug A3',            price = 125000 },
                        { name = 'weapon_carbinerifle',label =  'Carbine Rifle',     price = 125000 },
                        { name = 'weapon_compactrifle',label =  'Draco',             price = 125000 },
                        { name = 'weapon_grenade',      label = 'Grenade',           price = 25000 },
                        { name = 'weapon_machinepistol',label = 'Machine Pistol',    price = 25000 },
                        { name = 'weapon_appistol',     label = 'AP Pistol',         price = 25000 },
                        { name = 'weapon_ceramicpistol',label = 'Ceramic Pistol',    price = 15000 },
                        { name = 'weapon_revolver',     label = 'Revolver',          price = 20000 },
                        { name = 'weapon_snspistol',    label = 'SNS Pistol',        price = 10000 },
                        { name = 'weapon_tecpistol',    label = 'TEC Pistol',        price = 25000 },
                        { name = 'weapon_microsmg',     label = 'Micro SMG',         price = 25000 },
                        { name = 'weapon_marksmanrifle',label = 'Marksman Rifle',    price = 150000 },
                        { name = 'weapon_heavysniper',  label = 'Barrett M82 .50cal',price = 150000 },
                        { name = 'weapon_tacticalrifle',label = '[PD]Tactical Rifle',price = 125000 },
                        { name = 'weapon_heavypistol',  label = '[PD]Heavy Pistol',  price = 20000 },
                        { name = 'weapon_combatpdw',    label = '[PD]MPX',           price = 35000 },
                        { name = 'weapon_gusenberg',    label = 'Gusenberg',         price = 35000 },
                        { name = 'weapon_combatpistol', label = 'Combat Pistol',     price = 15000 },
                        { name = 'weapon_dbshotgun',    label = 'DB Shotgun',        price = 25000 },
                        { name = 'weapon_pumpshotgun',  label = '[PD]Pump Shotgun',  price = 30000 },
                        { name = 'weapon_stungun',      label = '[PD]Tazer',         price = 5000 },
                    },
                },
                {
                    id = 'close',
                    label = "Never mind",
                    icon = 'fas fa-ban',
                    close = true,
                },
            },
        },
        blip = {
            enabled = false,
            sprite = 617, -- Pickaxe blip
            color = 81,   -- Gold color
            scale = 0.8,
            name = "Weapon Vendor",
        },
        moneyType = 'black_money',    -- Type of money given: 'cash', 'bank', 'crypto', 'black_money'
    },
}

return Config
