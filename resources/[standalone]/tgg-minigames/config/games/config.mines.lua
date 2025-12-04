Config = Config or {}

Config.Mines = {
    description = 'Remember the mine positions and find them all after they disappear!',
    numberOfStages = 3, -- Total stages to complete

    gridSize = 5,       -- Grid size
    minesCount = 5,     -- Mines to remember
    previewTime = 4,    -- Preview time in seconds
    stageTime = 12,     -- Time to find mines in seconds
    maxFails = 2,       -- Maximum wrong clicks allowed
}
