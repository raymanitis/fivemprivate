Config = Config or {}

Config.AMess = {
    description = 'Untangle the mess by dragging dots to eliminate line crossings',
    numberOfStages = 3,   -- Total stages to complete

    numberOfDots = 8,     -- Number of dots in puzzle
    minCrossingLines = 4, -- Minimum line crossings to reach
    timeLimit = 60,       -- Time per stage in seconds
}
