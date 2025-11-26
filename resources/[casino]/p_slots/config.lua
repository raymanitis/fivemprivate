Config = {}

Config.Debug = false
Config.Language = 'en' -- pl / en
Config.Framework = 'ESX' -- ESX / QB
Config.Interactions = 'ox_target' -- ox_target / standalone (if other, change it in bridge client file)

Config.Slots = {
    [-1932041857] = { -- vw_prop_casino_slot_01a
        sound = 'dlc_vw_casino_slot_machine_ak_npc_sounds',
        reela = `vw_prop_casino_slot_01a_reels`,
        reelb = `vw_prop_casino_slot_01b_reels`,
        missChance = {min = 10, max = 40},
        maxBet = 250
    },
    [-1519644200] = { -- vw_prop_casino_slot_02a
        sound = 'dlc_vw_casino_slot_machine_ir_npc_sounds',
        reela = `vw_prop_casino_slot_02a_reels`,
        reelb = `vw_prop_casino_slot_02b_reels`,
        missChance = {min = 10, max = 40},
        maxBet = 250
    },
    [-430989390] = { -- vw_prop_casino_slot_03a
        sound = 'dlc_vw_casino_slot_machine_rsr_npc_sounds',
        reela = `vw_prop_casino_slot_03a_reels`,
        reelb = `vw_prop_casino_slot_03b_reels`,
        missChance = {min = 10, max = 40},
        maxBet = 250
    },
    [654385216] = { -- vw_prop_casino_slot_04a
        sound = 'dlc_vw_casino_slot_machine_fs_npc_sounds',
        reela = `vw_prop_casino_slot_04a_reels`,
        reelb = `vw_prop_casino_slot_04b_reels`,
        missChance = {min = 10, max = 40},
        maxBet = 250
    },
    [161343630] = { -- vw_prop_casino_slot_05a
        sound = 'dlc_vw_casino_slot_machine_ds_npc_sounds',
        reela = `vw_prop_casino_slot_05a_reels`,
        reelb = `vw_prop_casino_slot_05b_reels`,
        missChance = {min = 10, max = 40},
        maxBet = 250
    },
    [1096374064] = { -- vw_prop_casino_slot_06a
        sound = 'dlc_vw_casino_slot_machine_kd_npc_sounds',
        reela = `vw_prop_casino_slot_06a_reels`,
        reelb = `vw_prop_casino_slot_06b_reels`,
        missChance = {min = 10, max = 40},
        maxBet = 250
    },
    [207578973] = { -- vw_prop_casino_slot_07a
        sound = 'dlc_vw_casino_slot_machine_td_npc_sounds',
        reela = `vw_prop_casino_slot_07a_reels`,
        reelb = `vw_prop_casino_slot_07b_reels`,
        missChance = {min = 10, max = 40},
        maxBet = 250
    },
    [-487222358] = { -- vw_prop_casino_slot_08a
        sound = 'dlc_vw_casino_slot_machine_hz_npc_sounds',
        reela = `vw_prop_casino_slot_08a_reels`,
        reelb = `vw_prop_casino_slot_08b_reels`,
        missChance = {min = 10, max = 40},
        maxBet = 250
    },
}

Config.Rewards = {
    [{0, 0, 0}] = 10.0, --- Sevens
    [{0, 0, 8}] = 10.0, --- Sevens
    [{0, 8, 0}] = 10.0, --- Sevens
    [{8, 0, 0}] = 10.0, --- Sevens
    [{0, 8, 8}] = 10.0, --- Sevens
    [{8, 0, 8}] = 10.0, --- Sevens
    [{8, 8, 0}] = 10.0, --- Sevens
    [{8, 8, 8}] = 10.0, --- Sevens
    [{1, 1, 1}] = 1.5, --- Plums
    [{1, 1, 9}] = 1.5, --- Plums
    [{1, 9, 1}] = 1.5, --- Plums
    [{9, 1, 1}] = 1.5, --- Plums
    [{1, 1, 12}] = 1.5, --- Plums
    [{1, 12, 1}] = 1.5, --- Plums
    [{12, 1, 1}] = 1.5, --- Plums
    [{1, 9, 9}] = 1.5, --- Plums
    [{9, 1, 9}] = 1.5, --- Plums
    [{9, 9, 1}] = 1.5, --- Plums
    [{1, 9, 12}] = 1.5, --- Plums
    [{1, 12, 9}] = 1.5, --- Plums
    [{9, 1, 12}] = 1.5, --- Plums
    [{9, 12, 1}] = 1.5, --- Plums
    [{12, 1, 9}] = 1.5, --- Plums
    [{12, 9, 1}] = 1.5, --- Plums
    [{1, 12, 12}] = 1.5, --- Plums
    [{12, 1, 12}] = 1.5, --- Plums
    [{12, 12, 1}] = 1.5, --- Plums
    [{9, 9, 9}] = 1.5, --- Plums
    [{9, 9, 12}] = 1.5, --- Plums
    [{9, 12, 9}] = 1.5, --- Plums
    [{12, 9, 9}] = 1.5, --- Plums
    [{9, 12, 12}] = 1.5, --- Plums
    [{12, 9, 12}] = 1.5, --- Plums
    [{12, 12, 9}] = 1.5, --- Plums
    [{12, 12, 12}] = 1.5, --- Plums
    [{2, 2, 2}] = 2.5, --- Cherries
    [{2, 2, 6}] = 2.5, --- Cherries
    [{2, 6, 2}] = 2.5, --- Cherries
    [{6, 2, 2}] = 2.5, --- Cherries
    [{2, 2, 14}] = 2.5, --- Cherries
    [{2, 14, 2}] = 2.5, --- Cherries
    [{14, 2, 2}] = 2.5, --- Cherries
    [{2, 6, 6}] = 2.5, --- Cherries
    [{6, 2, 6}] = 2.5, --- Cherries
    [{6, 6, 2}] = 2.5, --- Cherries
    [{2, 6, 14}] = 2.5, --- Cherries
    [{2, 14, 6}] = 2.5, --- Cherries
    [{6, 2, 14}] = 2.5, --- Cherries
    [{6, 14, 2}] = 2.5, --- Cherries
    [{14, 2, 6}] = 2.5, --- Cherries
    [{14, 6, 2}] = 2.5, --- Cherries
    [{2, 14, 14}] = 2.5, --- Cherries
    [{14, 2, 14}] = 2.5, --- Cherries
    [{14, 14, 2}] = 2.5, --- Cherries
    [{6, 6, 6}] = 2.5, --- Cherries
    [{6, 6, 14}] = 2.5, --- Cherries
    [{6, 14, 6}] = 2.5, --- Cherries
    [{14, 6, 6}] = 2.5, --- Cherries
    [{6, 14, 14}] = 2.5, --- Cherries
    [{14, 6, 14}] = 2.5, --- Cherries
    [{14, 14, 6}] = 2.5, --- Cherries
    [{14, 14, 14}] = 2.5, --- Cherries
    [{3, 3, 3}] = 5.0, --- Melons
    [{3, 3, 10}] = 5.0, --- Melons
    [{3, 10, 3}] = 5.0, --- Melons
    [{10, 3, 3}] = 5.0, --- Melons
    [{3, 10, 10}] = 5.0, --- Melons
    [{10, 3, 10}] = 5.0, --- Melons
    [{10, 10, 3}] = 5.0, --- Melons
    [{10, 10, 10}] = 5.0, --- Melons
    [{7, 7, 7}] = 7.5, --- Bells
    [{7, 7, 13}] = 7.5, --- Bells
    [{7, 13, 7}] = 7.5, --- Bells
    [{13, 7, 7}] = 7.5, --- Bells
    [{7, 13, 13}] = 7.5, --- Bells
    [{13, 7, 13}] = 7.5, --- Bells
    [{13, 13, 7}] = 7.5, --- Bells
    [{13, 13, 13}] = 7.5, --- Bells
    [{5, 5, 5}] = 25.0, --- Jackpot
}

Config.SpecialReward = {
    [1] = 1.0,
    [2] = 3.5,
    [3] = 9.0
}