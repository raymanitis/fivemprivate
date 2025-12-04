Config = Config or {}

Config.Breaker = {
    description = 'Break all the blocks by bouncing the ball with your paddle! Collect power-ups for special abilities.',
    numberOfStages = 3, -- Total stages to complete

    regularBlockColors = {
        '#ef4444', -- Red
        '#f97316', -- Orange
        '#eab308', -- Yellow
        '#22c55e', -- Green
        '#3b82f6', -- Blue
        '#8b5cf6', -- Purple
        '#ec4899', -- Pink
    },

    blocksPerRow = 6,             -- Blocks per row
    numberOfRows = 3,             -- Number of rows

    explodingBlockPercent = 8,    -- Exploding block spawn chance
    multiBallBlockPercent = 8,    -- Multi-ball block spawn chance
    paddleExpandBlockPercent = 8, -- Paddle expand block spawn chance
    extraLifeBlockPercent = 5,    -- Extra life block spawn chance
    doubleHitBlockPercent = 3,    -- Double hit block spawn chance

    platformSpeed = 6,            -- Paddle movement speed
    ballSpeed = 4,                -- Ball movement speed
    defaultLives = 3,             -- Starting lives

    paddleExpandDuration = 8,     -- Duration of paddle expansion in seconds
    paddleExpandMultiplier = 1.3, -- Paddle size multiplier when expanded
    timeLimit = 180,              -- Time per stage in seconds
}
