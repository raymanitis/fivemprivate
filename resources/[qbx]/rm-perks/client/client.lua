local utils = require 'modules.utils'

--- THIS WOULD BE FROM A FETCH NUI IN THE FRONTEND
RegisterNuiCallback('hideApp', function(data, cb)
    utils.ShowNUI('UPDATE_VISIBILITY', false)
    SetNuiFocus(false, false)
    cb(true)
end)

--- Event to open the perks UI
RegisterNetEvent('rm-perks:client:openUI', function()
    utils.ShowNUI('UPDATE_VISIBILITY', true)
    SetNuiFocus(true, true)
end)

--- Command to open UI
RegisterCommand('specialization', function()
    TriggerEvent('rm-perks:client:openUI')
end, false)

RegisterCommand('specmenu', function()
    TriggerEvent('rm-perks:client:openUI')
end, false)