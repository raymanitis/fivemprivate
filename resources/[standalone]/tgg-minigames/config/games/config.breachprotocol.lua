Config = Config or {}

Config.BreachProtocol = {
    description = 'Navigate through network security matrices by finding the correct hex sequences. Alternate between row and column selections to breach the protocol.',
    numberOfStages = 3,  -- Total stages to complete
    instantFail = false, -- Fail on wrong code

    matrixSize = 5,      -- Matrix grid size
    sequenceLength = 4,  -- Symbols to select per round
    timeLimit = 60,      -- Time per stage in seconds
    penaltySeconds = 2,  -- Time penalty for wrong code

    guideLines = 2,      -- 1 = Horizontal, 2 = Vertical, 3 = Both

    hexCodes = {         -- Available hex codes for the matrix
        '1C', '7A', '55', 'BD', 'E9', 'FF',
        '1C', '7A', '55', 'BD', 'E9', 'FF',
        '7A', '55', 'BD', 'E9',
        '1C', '7A', '55', 'BD',
    },
}
