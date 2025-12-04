Config = Config or {}

Config.Numbers = {
    description = 'Click the numbers in ascending order (1, 2, 3, etc.) as fast as you can!',
    numberOfStages = 3, -- Total stages to complete
    instantFail = true, -- Fail on wrong number

    gridSize = 4,       -- Grid size
    timePerStage = 30,  -- Time per stage in seconds
    scrambleCount = 3,  -- Grid scrambles during stage
    penaltySeconds = 3, -- Time penalty for wrong clicks
}
