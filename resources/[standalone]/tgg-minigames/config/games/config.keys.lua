Config = Config or {}

Config.Keys = {
    description = 'Press the keys in the correct order from left to right, row by row!',
    numberOfStages = 3, -- Total stages to complete
    instantFail = true, -- Fail on wrong key

    useLetters = true,  -- Enable letter keys
    useNumbers = true,  -- Enable number keys

    timePerStage = 35,  -- Time per stage in seconds
    numberOfKeys = 12,  -- Keys to press per stage
    penaltySeconds = 3, -- Time penalty for mistakes
}
