Config = Config or {}

Config.PipePressure = {
    description = 'Rotate pipe segments during the delay countdown, then watch the flow travel from start to end',
    numberOfStages = 3,  -- Total stages to complete

    gridSize = 6,        -- Grid size
    flowSpeed = 80,      -- Flow animation speed
    delayTime = 20,      -- Time before flow starts in seconds
    fluidType = 'water', -- Fluid type (water or gas - changes the color)
}
