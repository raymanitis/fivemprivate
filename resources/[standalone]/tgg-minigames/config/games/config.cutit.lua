Config = Config or {}

Config.CutIt = {
    description = 'Find and cut the marked electrical cables using special tools!',
    numberOfStages = 3,       -- Total stages to complete

    numberOfCables = 10,      -- Total cables
    cablesToCut = 3,          -- Cables to cut per stage
    cablesToCutVariation = 1, -- Variation in the number of cables to cut (+/- X)
    revealAreaSize = 60,      -- Size of reveal area
    timePerStage = 45,        -- Time per stage in seconds
    maxRevealSpeed = 300,     -- Maximum reveal speed
}
