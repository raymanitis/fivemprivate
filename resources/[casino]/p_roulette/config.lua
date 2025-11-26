Config = {}

Config.Language = 'en' -- pl / en 

Config.Interactions = 'ox_target' -- ox_target / standalone
Config.Framework = 'ESX'
Config.RouletteStart = 25

Config.Tables = {
    {
        spawnTable = true,
        coords = vector3(1001.53, 56.479, 68.433),
        rotation = 102.133,
        minBet = 10,
        maxBet = 1000 
    },
    {
        spawnTable = true,
        coords = vector3(997.595, 55.573, 68.433),
        rotation = 280.612,
        minBet = 10,
        maxBet = 1000
    },
}

Config.Chairs = {
    ['Chair_Base_01'] = 1,
    ['Chair_Base_02'] = 2,
    ['Chair_Base_03'] = 3,
    ['Chair_Base_04'] = 4
}

Config.Numbers = {
    [1] = '00', [2] = '27', [3] = '10',
    [4] = '25', [5] = '29', [6] = '12',
    [7] = '8', [8] = '19', [9] = '31',
    [10] = '18', [11] = '6', [12] = '21',
    [13] = '33', [14] = '16', [15] = '4',
    [16] = '23', [17] = '35', [18] = '14',
    [19] = '2', [20] = '0', [21] = '28',
    [22] = '9', [23] = '26', [24] = '30',
    [25] = '11', [26] = '7', [27] = '20',
    [28] = '32', [29] = '17', [30] = '5',
    [31] = '22', [32] = '34', [33] = '15',
    [34] = '3', [35] = '24', [36] = '36',
    [37] = '13', [38] = '1'
}

Config.RouletteNumbers = {
    ['red'] = {
        ['1'] = true, ['3'] = true, ['5'] = true,
        ['7'] = true, ['9'] = true, ['12'] = true,
        ['14'] = true, ['16'] = true, ['18'] = true,
        ['19'] = true, ['21'] = true, ['23'] = true,
        ['25'] = true, ['27'] = true, ['30'] = true,
        ['32'] = true,['34'] = true, ['36'] = true
    },
    ['black'] = {
        ['2'] = true, ['4'] = true, ['6'] = true,
        ['8'] = true, ['10'] = true, ['11'] = true,
        ['13'] = true, ['15'] = true, ['17'] = true,
        ['20'] = true, ['22'] = true, ['24'] = true,
        ['26'] = true, ['28'] = true, ['29'] = true,
        ['31'] = true, ['33'] = true, ['35'] = true
    },
    ['even'] = {
        ['2'] = true, ['4'] = true, ['6'] = true,
        ['8'] = true, ['10'] = true, ['12'] = true,
        ['14'] = true, ['16'] = true, ['18'] = true,
        ['20'] = true, ['22'] = true, ['24'] = true,
        ['26'] = true, ['28'] = true, ['30'] = true,
        ['32'] = true, ['34'] = true, ['36'] = true
    },
    ['odd'] = {
        ['1'] = true, ['3'] = true, ['5'] = true,
        ['7'] = true, ['9'] = true, ['11'] = true,
        ['13'] = true, ['15'] = true, ['17'] = true,
        ['19'] = true, ['21'] = true, ['23'] = true,
        ['25'] = true, ['27'] = true, ['29'] = true,
        ['31'] = true, ['33'] = true, ['35'] = true
    },
    ['18'] = {
        ['1'] = true, ['2'] = true, ['3'] = true,
        ['4'] = true, ['5'] = true, ['6'] = true,
        ['7'] = true, ['8'] = true, ['9'] = true,
        ['10'] = true, ['11'] = true, ['12'] = true,
        ['13'] = true, ['14'] = true, ['15'] = true,
        ['16'] = true, ['17'] = true, ['18'] = true
    },
    ['36'] = {
        ['19'] = true, ['20'] = true, ['21'] = true,
        ['22'] = true, ['23'] = true, ['24'] = true,
        ['25'] = true, ['26'] = true, ['27'] = true,
        ['28'] = true, ['29'] = true, ['30'] = true,
        ['31'] = true, ['32'] = true, ['33'] = true,
        ['34'] = true, ['35'] = true, ['36'] = true
    },
    ['12'] = {
        ['1'] = true, ['2'] = true, ['3'] = true,
        ['4'] = true, ['5'] = true, ['6'] = true,
        ['7'] = true, ['8'] = true, ['9'] = true,
        ['10'] = true, ['11'] = true, ['12'] = true
    },
    ['24'] = {
        ['13'] = true, ['14'] = true, ['15'] = true,
        ['16'] = true, ['17'] = true, ['18'] = true,
        ['19'] = true, ['20'] = true, ['21'] = true,
        ['22'] = true, ['23'] = true, ['24'] = true
    },
    ['36'] = {
        ['25'] = true, ['26'] = true, ['27'] = true,
        ['28'] = true, ['29'] = true, ['30'] = true,
        ['31'] = true, ['32'] = true, ['33'] = true,
        ['34'] = true, ['35'] = true, ['36'] = true
    },
    ['1'] = {
        ['1'] = true, ['4'] = true, ['7'] = true,
        ['10'] = true, ['13'] = true, ['16'] = true,
        ['19'] = true, ['22'] = true, ['25'] = true,
        ['28'] = true, ['31'] = true, ['34'] = true
    },
    ['2'] = {
        ['2'] = true, ['5'] = true, ['8'] = true,
        ['11'] = true, ['14'] = true, ['17'] = true,
        ['20'] = true, ['23'] = true, ['26'] = true,
        ['29'] = true, ['32'] = true, ['35'] = true
    },
    ['3'] = {
        ['3'] = true, ['6'] = true, ['9'] = true, 
        ['12'] = true, ['15'] = true, ['18'] = true,
        ['21'] = true, ['24'] = true, ['27'] = true,
        ['30'] = true, ['33'] = true, ['36'] = true
    }
}