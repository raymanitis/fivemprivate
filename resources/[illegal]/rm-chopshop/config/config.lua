Config = Config or {}

--[[ --------------------------------------------------------------------------
    Chopshop Contract / Vehicle Configuration

    - Define contract "classes" and which vehicle models they require.
    - The example below uses Class D with Youga and Speedo.
---------------------------------------------------------------------------]]

Config.ChopshopContracts = {
    -- Worst tier
    D = {
        label = 'Class D',
        -- How many vehicles this class can ask for per mission
        -- (random between minVehicles and maxVehicles, clamped to list size)
        minVehicles = 1,
        maxVehicles = 2,
        vehicles = {
            'youga',
            'speedo',
        }
    },

    -- Mid tier
    C = {
        label = 'Class C',
        minVehicles = 2,
        maxVehicles = 3,
        vehicles = {
            'felon',
            'sultan',
            'buffalo',
        }
    },

    -- High tier
    B = {
        label = 'Class B',
        minVehicles = 2,
        maxVehicles = 3,
        vehicles = {
            'comet2',
            'ninef',
            'elegy',
        }
    },

    -- Best tier
    A = {
        label = 'Class A',
        minVehicles = 2,
        maxVehicles = 3,
        vehicles = {
            'adder',
            'entityxf',
            'italigto',
        }
    },
}


