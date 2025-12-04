Config = Config or {}

Config.TowerOfHanoi = {
    description = 'Move all disks to the rightmost tower. Only move one disk at a time. Cannot place larger disk on smaller disk.',
    numberOfStages = 3, -- Total stages to complete
    numberOfDisks = 3,  -- Disks to move
    timePerStage = 120, -- Time per stage in seconds
}
