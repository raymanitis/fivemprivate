Config = Config or {}

Config.Locked = {
    description = 'Crack the safe by rotating to precise sections. Move slowly to feel the lock.',
    numberOfStages = 2,        -- Total stages to complete
    instantFail = false,       -- Fail on wrong answer

    timeLimit = 40,            -- Time per stage in seconds
    slowMovementThreshold = 7, -- Threshold for slow movement
    penaltySeconds = 3,        -- Time penalty for wrong answer

    circles = {
        {
            sections = 90,            -- Number of sections per circle #1 (outermost)
            lightShakeTolerance = 10, -- Light shake tolerance (+/- X sections)
            successZoneTolerance = 3, -- Success zone tolerance (+/- X sections)
        },
        {
            sections = 60,            -- Number of sections per circle #2 (middle)
            lightShakeTolerance = 8,  -- Light shake tolerance (+/- X sections)
            successZoneTolerance = 2, -- Success zone tolerance (+/- X sections)
        },
        {
            sections = 36,            -- Number of sections per circle #3 (innermost)
            lightShakeTolerance = 6,  -- Light shake tolerance (+/- X sections)
            successZoneTolerance = 2, -- Success zone tolerance (+/- X sections)
        }
    }
}
