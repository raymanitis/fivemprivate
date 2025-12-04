Config = Config or {}

Config.Slider = {
    description = 'Click the correct numbers as they pass through the center point!',

    numberOfNumbers = 10, -- Total numbers to click in sequence
    pointWidth = 6,       -- Width of the center point as percentage (affects difficulty)
    scrollSpeed = 4,      -- Speed of scrolling numbers (percentage per second)
    numberSpacing = 5,    -- Space between numbers as percentage
    minimalMode = false,  -- Hide container background and border
}
