Config = Config or {}

Config.AimIt = {
    description = 'Aim at the targets before they disappear!',
    numberOfStages = 2,    -- Total stages to complete
    instantFail = true,    -- Fail on missed target
    targetsCount = 8,      -- Targets per stage
    targetSize = 85,       -- Target diameter in pixels
    stageTimer = 6,        -- Time per stage in seconds
    penaltySeconds = 0.25, -- Penalty time per miss
}
