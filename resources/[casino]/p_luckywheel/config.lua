Config = {}

---@param Config.AdminGroups: table<string, boolean> List of admin groups that have access to the rewards management
Config.AdminGroups = {
    ['owner'] = true,
    ['admin'] = true,
    ['best'] = true
}

---@class Config.Creator
---@field enabled boolean Whether the creator is enabled or not
---@field creatorCommand string Command to open the wheel creator
---@field deleteCommand string Command to delete a wheel
---@field manageCommand string Command to manage existing wheels
Config.Creator = {
    enabled = true,
    creatorCommand = 'createWheel',
    manageCommand = 'manageWheels',
}

---@class Config.Wheel
Config.Wheel = {
    requiredItems = {
        ['casino_chips'] = {
            amount = 100,
            remove = true
        },
        -- ['money'] = {
        --     amount = 500,
        --     remove = true
        -- }
    },
    cooldownPerWheel = 60, -- minutes [for player, not everyone]
    cooldownGlobal = 0, -- minutes [for player, not everyone]
    canSpinServer = function(playerId) -- custom function to check if the player can spin the wheel [you can implement job check/item check etc]
        -- this function is SERVER SIDE!
        return true
    end,
    canSpinClient = function() -- custom function to check if the player can spin the wheel [you can implement job check/item check etc]
        -- this function is CLIENT SIDE!
        return true
    end,
}