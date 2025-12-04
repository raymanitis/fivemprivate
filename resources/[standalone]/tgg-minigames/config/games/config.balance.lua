Config = Config or {}

Config.Balance = {
    description = 'Keep the needle balanced in the green zone using Q and E keys!',

    -- Zone sizes (must add up to 100%)
    greenSize = 35,         -- Size of green (safe) zone as percentage (0-100)
    yellowSize = 35,        -- Size of yellow (warning) zone as percentage (0-100)
    redSize = 30,           -- Size of red (fail) zone as percentage (0-100)
    -- Note: greenSize + yellowSize + redSize must equal 100
    
    driftForce = 35,        -- Drift force intensity (1-30): lower = easier, higher = harder
    pushStrength = 55,      -- Q/E key push strength (10-200): lower = less control, higher = more control
    gameTime = 20,          -- Time in seconds to survive without hitting red zone
}

