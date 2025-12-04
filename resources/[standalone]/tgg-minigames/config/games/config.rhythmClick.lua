Config = Config or {}

Config.RhythmClick = {
    description = 'Fast rhythm-based skill check - click circles in order before they close!',

    numberOfCircles = 10,     -- Total circles to click
    spawnInterval = 0.7,      -- Seconds between spawning each circle
    perfectClickWindow = 0.4, -- Seconds window at end to click when circle is fully closed
}
