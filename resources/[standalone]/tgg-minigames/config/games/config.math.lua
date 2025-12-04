Config = Config or {}

Config.Math = {
    description = 'Compare mathematical expressions - calculate and choose if the second is greater, less, or equal to the first',
    numberOfStages = 3,                        -- Total stages to complete
    instantFail = false,                       -- Fail on wrong answer

    timeLimit = 20,                            -- Time per stage in seconds
    expressionsPerRound = 5,                   -- Expressions per round
    allowedOperators = { '+', '-', '*', '/' }, -- Allowed operators for the expressions
    minResult = 2,                             -- Minimum expression result
    maxResult = 25,                            -- Maximum expression result
    maxDifference = 5,                         -- Max difference between expressions
    penaltySeconds = 3,                        -- Time penalty for wrong answer
}
