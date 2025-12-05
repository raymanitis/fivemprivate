local utils = require 'modules.utils'

-- Command to open skill tree
RegisterCommand('skilltree', function()
    utils.ShowNUI('UPDATE_VISIBILITY', true)
end, false)

-- Keybind example (uncomment and adjust as needed)
-- RegisterKeyMapping('skilltree', 'Open Skill Tree', 'keyboard', 'K')

--- THIS WOULD BE FROM A FETCH NUI IN THE FRONTEND
RegisterNuiCallback('hideApp', function(data, cb)
    utils.ShowNUI('UPDATE_VISIBILITY', false)
    cb(true)
end)

RegisterNuiCallback('claimSkill', function(data, cb)
    local skillId = data.id
    local tree = data.tree
    
    -- TODO: Add your skill claiming logic here
    -- Example: TriggerServerEvent('rm-skilltree:claimSkill', skillId, tree)
    
    print(string.format('Attempting to claim skill: %s in tree: %s', skillId, tree))
    
    -- Return success/failure
    cb({ success = true })
end)