Config = {}

Config.Language = 'en' -- pl / en
Config.Framework = 'ESX' -- ESX / QB
Config.Debug = false -- prints in console

Config.StartTime = 20 -- dealer will start game after 20 seconds when player bet
Config.DecideTime = 20 -- time to decide when watching our cards
Config.CardsCamera = true -- show camera on player cards on reveal

Config.TableModels = {
    [`h4_prop_casino_3cardpoker_01a`] = true,
    [`h4_prop_casino_3cardpoker_01b`] = true,
    [`h4_prop_casino_3cardpoker_01c`] = true,
    [`h4_prop_casino_3cardpoker_01e`] = true,
    [`vw_prop_casino_3cardpoker_01b`] = true,
    [`vw_prop_casino_3cardpoker_01`] = true
}

Config.TableChairs = {
    ['Chair_Base_01'] = 1,
    ['Chair_Base_02'] = 2,
    ['Chair_Base_03'] = 3,
    ['Chair_Base_04'] = 4
}

Config.IncreaseAmounts = function(currentAmount)
    if currentAmount < 500 then
        return 50
    elseif currentAmount >= 500 and currentAmount < 2000 then
        return 100
    elseif currentAmount >= 2000 and currentAmount < 5000 then
        return 200
    elseif currentAmount >= 5000 and currentAmount < 10000 then
        return 500
    elseif currentAmount >= 10000 then
        return 1000
    else
        return 50
    end
end

Config.Tables = {
    {
        coords = vector3(996.17, 51.69, 68.45),
        rotation = 318.91,
        maxBet = 2500,
        minBet = 50
    },
    {
        coords = vector3(1000.66, 50.88, 68.45),
        rotation = 6.7330,
        maxBet = 2500,
        minBet = 50
    },
    {
        coords = vector3(984.970, 66.640, 69.250),
        rotation = 3.3900,
        maxBet = 2500,
        minBet = 50
    },
    {
        coords = vector3(998.440, 60.990, 68.450),
        rotation = 191.770,
        maxBet = 2500,
        minBet = 50
    },
    {
        coords = vector3(994.890, 58.290, 68.450),
        rotation = 237.130,
        maxBet = 2500,
        minBet = 50
    },
    {
        coords = vector3(988.45, 64.38, 69.25),
        rotation = 278.52,
        maxBet = 2500,
        minBet = 50
    },
    {
        coords = vector3(991.56, 40.10, 69.25),
        rotation = 200.84,
        maxBet = 2500,
        minBet = 50
    },
    {
        coords = vector3(993.20, 43.70, 69.25),
        rotation = 279.25,
        maxBet = 2500,
        minBet = 50
    }
}

Config.Cards = {
    [1] = 'vw_prop_vw_club_char_a_a', [2] = 'vw_prop_vw_club_char_02a', [3] = 'vw_prop_vw_club_char_03a',
    [4] = 'vw_prop_vw_club_char_04a', [5] = 'vw_prop_vw_club_char_05a', [6] = 'vw_prop_vw_club_char_06a',
    [7] = 'vw_prop_vw_club_char_07a', [8] = 'vw_prop_vw_club_char_08a', [9] = 'vw_prop_vw_club_char_09a',
    [10] = 'vw_prop_vw_club_char_10a', [11] = 'vw_prop_vw_club_char_j_a', [12] = 'vw_prop_vw_club_char_q_a',
    [13] = 'vw_prop_vw_club_char_k_a', [14] = 'vw_prop_vw_dia_char_a_a', [15] = 'vw_prop_vw_dia_char_02a',
    [16] = 'vw_prop_vw_dia_char_03a', [17] = 'vw_prop_vw_dia_char_04a', [18] = 'vw_prop_vw_dia_char_05a',
    [19] = 'vw_prop_vw_dia_char_06a',
    [20] = 'vw_prop_vw_dia_char_07a',
    [21] = 'vw_prop_vw_dia_char_08a',
    [22] = 'vw_prop_vw_dia_char_09a',
    [23] = 'vw_prop_vw_dia_char_10a',
    [24] = 'vw_prop_vw_dia_char_j_a',
    [25] = 'vw_prop_vw_dia_char_q_a',
    [26] = 'vw_prop_vw_dia_char_k_a',
    [27] = 'vw_prop_vw_hrt_char_a_a',
    [28] = 'vw_prop_vw_hrt_char_02a',
    [29] = 'vw_prop_vw_hrt_char_03a',
    [30] = 'vw_prop_vw_hrt_char_04a',
    [31] = 'vw_prop_vw_hrt_char_05a',
    [32] = 'vw_prop_vw_hrt_char_06a',
    [33] = 'vw_prop_vw_hrt_char_07a',
    [34] = 'vw_prop_vw_hrt_char_08a',
    [35] = 'vw_prop_vw_hrt_char_09a',
    [36] = 'vw_prop_vw_hrt_char_10a',
    [37] = 'vw_prop_vw_hrt_char_j_a',
    [38] = 'vw_prop_vw_hrt_char_q_a',
    [39] = 'vw_prop_vw_hrt_char_k_a',
    [40] = 'vw_prop_vw_spd_char_a_a',
    [41] = 'vw_prop_vw_spd_char_02a',
    [42] = 'vw_prop_vw_spd_char_03a',
    [43] = 'vw_prop_vw_spd_char_04a',
    [44] = 'vw_prop_vw_spd_char_05a',
    [45] = 'vw_prop_vw_spd_char_06a',
    [46] = 'vw_prop_vw_spd_char_07a',
    [47] = 'vw_prop_vw_spd_char_08a',
    [48] = 'vw_prop_vw_spd_char_09a',
    [49] = 'vw_prop_vw_spd_char_10a',
    [50] = 'vw_prop_vw_spd_char_j_a',
    [51] = 'vw_prop_vw_spd_char_q_a',
    [52] = 'vw_prop_vw_spd_char_k_a'
}