Config = Config or {}

Config.Flappy = {
    description = 'Control your bird through horizontal pipes by tapping space to flap and stay airborne!',
    numberOfStages = 3, -- Total stages to complete
    jumpPower = 0.8,    -- Jump power multiplier
    fallSpeed = 0.025,  -- Fall speed per frame
    scrollSpeed = 0.5,  -- Pipe scroll speed
    openingSize = 120,  -- Opening size between pipes
    pipeSpacing = 350,  -- Distance between pipes
    pipesRequired = 8,  -- Pipes to pass through per stage
}
