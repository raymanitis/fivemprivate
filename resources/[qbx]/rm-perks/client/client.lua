local utils = require 'modules.utils'

--- THIS WOULD BE FROM A FETCH NUI IN THE FRONTEND
RegisterNuiCallback('hideApp', function(data, cb)
    utils.ShowNUI('UPDATE_VISIBILITY', false)
    SetNuiFocus(false, false)
    cb('ok')
end)

--- NUI Callback: Get specializations data
RegisterNuiCallback('getSpecializations', function(data, cb)
    TriggerServerEvent('rm-perks:server:getSpecializations')
    cb('ok')
end)

--- NUI Callback: Select specialization
RegisterNuiCallback('selectSpecialization', function(data, cb)
    TriggerServerEvent('rm-perks:server:selectSpecialization', data.specializationId)
    cb('ok')
end)

--- Server event: Receive specialization data
RegisterNetEvent('rm-perks:client:receiveSpecializations', function(specData)
    utils.SendReactMessage('SET_SPECIALIZATION_DATA', specData)
end)

--- Server event: Receive selection result
RegisterNetEvent('rm-perks:client:selectionResult', function(result)
    utils.SendReactMessage('SELECTION_RESULT', result)
end)

--- Event to open the perks UI
RegisterNetEvent('rm-perks:client:openUI', function()
    utils.ShowNUI('UPDATE_VISIBILITY', true)
    SetNuiFocus(true, true)
    -- Request specialization data when opening
    TriggerServerEvent('rm-perks:server:getSpecializations')
end)

--- Command to open UI
RegisterCommand('specialization', function()
    TriggerEvent('rm-perks:client:openUI')
end, false)

RegisterCommand('specmenu', function()
    TriggerEvent('rm-perks:client:openUI')
end, false)