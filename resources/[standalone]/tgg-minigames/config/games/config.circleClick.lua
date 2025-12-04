Config = Config or {}

Config.CircleClick = {
    description = 'Press the shown key when the rotating segment enters the target zone!',

    targetZoneSize = 30,       -- Size of target zone in degrees (e.g., 30 = 30°)
    segmentSpeed = 180,        -- Rotation speed of segment (degrees per second)
    numberOfClicks = 10,       -- Number of successful clicks required to win
    movingTarget = false,      -- Whether the target zone moves (opposite direction of segment)
    changeDirectionChance = 0, -- Chance (0-100) to reverse segment direction after each click
}
