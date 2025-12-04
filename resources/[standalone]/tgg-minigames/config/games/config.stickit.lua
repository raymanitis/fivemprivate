Config = Config or {}

Config.StickIt = {
    description = 'Shoot pins into the rotating circle without hitting existing pins. Tap to shoot!',
    numberOfStages = 3,        -- Total stages to complete

    pinsToComplete = 8,        -- Pins to place per stage
    rotationSpeed = 50,        -- Circle rotation speed
    changeRotationChance = 50, -- % chance to change rotation direction
}
