Config = Config or {}

Config.DestroyLinks = {
    description = 'Destroy blocks from the bottom of the tower by matching the mark directions!',
    numberOfStages = 3,  -- Total stages to complete
    instantFail = false, -- Fail on wrong selection

    timeLimit = 8,       -- Time per stage in seconds
    targetBlocks = 30,   -- Blocks to destroy per stage
    penaltySeconds = 1,  -- Time penalty for wrong selection
}
