Config = Config or {}

Config.SequenceMemory = {
    description = 'Watch the sequence of highlighted boxes, then click them in the same order. Each round adds more boxes to remember.',
    numberOfStages = 3,   -- Total stages to complete
    maxBoxesPerStage = 6, -- Max boxes to remember
    revealTime = 400,     -- Reveal time per box in ms
    gridSize = 4,         -- Grid size
    timePerStage = 60,    -- Time per stage in seconds
}
