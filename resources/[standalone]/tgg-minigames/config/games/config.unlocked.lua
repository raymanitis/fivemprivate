Config = Config or {}

Config.Unlocked = {
    description = 'Match colored dots with their corresponding colored lines by rotating the circles',
    numberOfStages = 3,        -- Total stages to complete
    instantFail = false,       -- Fail on wrong answer

    totalCircles = 4,          -- Number of circles
    emptySpacePercentage = 30, -- Empty space percentage
    timerPerStage = 45,        -- Time per stage in seconds
    penaltySeconds = 3,        -- Time penalty for wrong answer
}
