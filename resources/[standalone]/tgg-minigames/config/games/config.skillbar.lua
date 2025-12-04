Config = Config or {}

Config.SkillBar = {
    description = 'Click when the moving segment reaches the target zone!',

    segmentSpeed = 50,   -- Speed of moving segment (percentage per second)
    targetZoneSize = 8,  -- Size of target zone (percentage of bar width)
    hitsRequired = 5,    -- Number of successful hits to complete the game
    minimalMode = false, -- Hide container background and border
}
