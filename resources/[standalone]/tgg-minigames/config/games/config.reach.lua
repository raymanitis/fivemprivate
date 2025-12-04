Config = Config or {}

Config.Reach = {
    description = 'Navigate through a maze with limited visibility',
    numberOfStages = 3,               -- Total stages to complete
    instantFail = false,              -- Fail on wrong answer

    gridSize = 15,                    -- Grid size
    circleRadius = 10,                -- Player circle radius
    revealRadius = 3.5,               -- Visibility reveal radius
    timeLimit = 60,                   -- Time per stage in seconds
    penaltySeconds = 4,               -- Time penalty for touching a wall

    multipleStartEndPositions = true, -- Allow multiple start/end positions (true - uses the 4 corners, false - uses the top-left and bottom-right corners)
}
