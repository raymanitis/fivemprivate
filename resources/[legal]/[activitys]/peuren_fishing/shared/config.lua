Config = {} --Don't touch this

Config.FishingRods = { --Don't touch this
    ["basicfishingrod"] = { -- Item Name
        maxDistance = 10.0, -- Max distance of the line
        maxWeight = 5000, -- Max Weight of the fish the player can fish out with this rod.
    },
    ["advancedfishingrod"] = { -- Item Name
        maxDistance = 20.0, -- Max distance of the line
        maxWeight = 10000, -- Max Weight of the fish the player can fish out with this rod.
    },
    ["profishingrod"] = { -- Item Name
        maxDistance = 30.0, -- Max distance of the line
        maxWeight = 20000, -- Max Weight of the fish the player can fish out with this rod.
    },
}

Config.FishingRodProp = "prop_fishing_rod_01" -- The prop used for the fishing rod.

Config.Baits = { --Don't touch this
    ["none"] = { --Rewards if the player fishes without any bait
        timeToWait = {min = 10000, max = 20000},
        rewards = { --[[
            {type = "item", item = "itemToGive", amount = {min = minAmount, max = maxAmount}, chance = chanceOfTheReward}, -- Give an item
            {type = "fish", item = "fishItemToGive", amount = {min = minFishWeight, max = maxFishWeight}, chance = chanceOfTheReward}, -- Give a fish
            {type = "money", account = "accountToGiveMoney", amount = {min = minAmount, max = maxAmount}, chance = chanceOfTheReward}, -- Give money to a specific account ('cash', 'bank')
        ]]
            {type = "money", account = "cash", amount = {min = 5, max = 10}, chance = 50}, 
            {type = "item", item = "glass_bottle", amount = {min = 1, max = 2}, chance = 10},
            {type = "item", item = "rubber", amount = {min = 1, max = 2}, chance = 10},
            {type = "item", item = "plastic", amount = {min = 1, max = 2}, chance = 30},
        }
    },
    ['basicbait'] = {
        timeToWait = {min = 5000, max = 15000},
        rewards = {
            {type = "fish", item = "sparling", amount = {min = 1000, max = 2000}, chance = 20},
            {type = "fish", item = "pike", amount = {min = 1000, max = 2000}, chance = 20},
            {type = "fish", item = "catfish", amount = {min = 1000, max = 2000}, chance = 20},
            {type = "fish", item = "bream", amount = {min = 1000, max = 2000}, chance = 20},
            {type = "fish", item = "eal", amount = {min = 1000, max = 2000}, chance = 10},
            {type = "fish", item = "cod", amount = {min = 1000, max = 2000}, chance = 10},
        }
    },
    ['probait'] = {
        timeToWait = {min = 10000, max = 25000},
        rewards = {
            {type = "fish", item = "redfish", amount = {min = 100, max = 500}, chance = 25},
            {type = "fish", item = "largemouthbass", amount = {min = 100, max = 500}, chance = 25},
            {type = "fish", item = "gayfish", amount = {min = 100, max = 500}, chance = 25},
            {type = "fish", item = "salmon", amount = {min = 100, max = 500}, chance = 25},
        }
    },
}

Config.Skill = { --Don't touch this
    Levels = { --Don't touch this
        [1] = { --Level Number (Don't change the first levels number)
            minXP = 0, -- Required XP for the level (Don't change the first levels required XP)
            maxWeight = 5000, -- Max weight of the fish that a player can handle. If the fish is heavier he might lose the rod.
            loseRodChance = 30, -- Chance of the player losing the rod if the fish is heavier than he can handle.
            minigame = { -- Difficulty of the minigame
                breakLine = 50,
            }
        },
        [2] = { --Level Number
            minXP = 50, -- Required XP for the level
            maxWeight = 10000, -- Max weight of the fish that a player can handle. If the fish is heavier he might lose the rod.
            loseRodChance = 40, -- Chance of the player losing the rod if the fish is heavier than he can handle.
            minigame = { -- Difficulty of the minigame
                breakLine = 30,
            }
        },
    },
    Gain = { -- The amount of XP given after a succesfully catching a fish
        min = 5,
        max = 10
    },
    Loss = { -- The amount of XP removed after failing to catch the fish
        min = 2, 
        max = 3,
    }
}

Config.Shops = { --Don't touch this
    ["supplystore"] = {  --The Shops ID 
        Blip = { --Blip Configuration for the shop. Set this to false to disable the blip for a certain shop
            title = "Fishing Shop", -- Title of the sprite
            sprite = 356, --Sprite of the blip. https://docs.fivem.net/docs/game-references/blips/#blips
            color = 43, --Color of the blip https://docs.fivem.net/docs/game-references/blips/#blip-colors
            size = 1.0,  --Size of the  blip
            pos = vector3(727.05, 4169.28, 41.71)--Blip position
        },
        Currency = {--Currency that is used to pay/purchase things at the shop
            account = 'cash',-- Supported types: black_money, bank, cash
            accountItem = {
                enabled = false,--Is currency to pay/purchase an item?
                itemName = 'markedbills'--The currency item that is used to pay/purchase things in the shop
            }
        },
        Ped = {
            model = 's_m_m_ammucountry',--Ped model, model names can be found @ https://docs.fivem.net/docs/game-references/ped-models/
            pos = vector3(727.05, 4169.28, 39.69),--Ped position
            heading = 7.56,--Ped heading
            animation = {--This controls the peds animation, if you don't want this, make it to: animation = false
                --Supported anim data format:
                    -- anim = ''
                    -- dict = ''
                    -- scenario = ''
                --Examples:
                    -- anim = 'missexile3'
                    -- dict = 'ex03_dingy_search_case_base_michael'
                scenario = 'WORLD_HUMAN_SMOKING'
            }
        },
        Market = {
            SaleAge = 86400, --In seconds. How long sales affect the item prices.
            MarketCycle = 600,--In seconds. How frequently item prices are updated.
            PriceChangeFactor = 0.5, --Intesnity of the price fluctuations.
        },
        Buy = { --Items that can be bought at this shop
            -- {name = "item spawn name", price = item price },
            { name = "basicfishingrod", price = 1000 },
            { name = "advancedfishingrod", price = 2000 },
            { name = "profishingrod", price = 3000 },
        },
        Sell = { --Fish that can  be sold in this shop
            -- {name = "fish item spawn name", min = min kg price, max = max kg price },
            -- Final price is calculated with this formula totalAmount = floor(fishWeight (in grams) * (currentPrice / 1000)), so for example if the fish weighs 500g and the current salmon price is 300 the player will receive 150
            { name = "sparling", min = 60, max = 90 },
            { name = "pike", min = 60, max = 90 },
            { name = "catfish", min = 70, max = 100 },
            { name = "bream", min = 50, max = 70 },
            { name = "eal", min = 80, max = 120 },
            { name = "cod", min = 100, max = 140 },
            { name = "redfish", min = 100, max = 130 },
            { name = "largemouthbass", min = 100, max = 150 },
            { name = "gayfish", min = 120, max = 180 },
            { name = "salmon", min = 150, max = 210 },
        }
    }
}

Config.RewardProps = {
    ["salmon"] = {
        model = "A_C_Fish",
        variation = 2
    },
    ["catfish"] = {
        model = "A_C_Fish",
        variation = 2
    },
    ["redfish"] = {
        model = "A_C_Fish",
        variation = 2
    },
    ["largemouthbass"] = {
        model = "A_C_Fish",
        variation = 2
    },
    ["pike"] = {
        model = "A_C_Fish",
        variation = 2
    },
    ["bream"] = {
        model = "A_C_Fish",
        variation = 2
    },
    ["eal"] = {
        model = "A_C_Fish",
        variation = 2
    },
    ["cod"] = {
        model = "A_C_Fish",
        variation = 2
    },
    ["sparling"] = {
        model = "A_C_Fish",
        variation = 2
    },
    ["money"] = {
        model = "prop_ld_wallet_pickup",
    },
    ["item"] = {
        model = "hei_prop_heist_binbag",
    }
}

Config.Anims = { -- Don't touch this
    Cast = { "backhand_ts_hi", "forehand_ts_hi", "backhand_ts_lo", "forehand_ts_lo" } -- A random animation is selected from this list and played when casting the line.
}