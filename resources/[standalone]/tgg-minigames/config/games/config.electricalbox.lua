Config = Config or {}

Config.ElectricalBox = {
    description = 'Fix the electrical system by finding the correct breaker switch combination!',
    numberOfStages = 3,      -- Total stages to complete

    timePerStage = 20,       -- Time per stage in seconds
    simonSequenceLength = 3, -- Simon Says sequence length
    toleranceMa = 5,         -- Tolerance in milliamps

    puzzleTypes = {
        math = true,    -- Enable math puzzles
        simon = true,   -- Enable Simon Says puzzles
        current = true, -- Enable current flow puzzles
    },

    operators = {
        multiply = true, -- Enable multiplication operator
        division = true, -- Enable division operator
    },
}
