local sharedConfig = require 'config.shared'

---@type table<string, number>
local checkInPeds = {}

---@param ped number
---@param scenario? string
local function setPedScenario(ped, scenario)
    if not scenario then return end
    TaskStartScenarioInPlace(ped, scenario, 0, true)
end

---@param hospitalName string
---@param pedData table
local function createCheckInPed(hospitalName, pedData)
    local model = type(pedData.model) == 'string' and GetHashKey(pedData.model) or pedData.model
    lib.requestModel(model, 5000)
    
    local ped = CreatePed(4, model, pedData.coords.x, pedData.coords.y, pedData.coords.z, pedData.coords.w, false, true)
    
    SetEntityAsMissionEntity(ped, true, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 17, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    
    setPedScenario(ped, pedData.scenario)
    
    checkInPeds[hospitalName] = ped
    
    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'hospital_checkin_' .. hospitalName,
            icon = 'fas fa-clipboard',
            label = locale('text.check_in'),
            distance = 2.5,
            onSelect = function()
                TriggerEvent('qbx_ambulancejob:client:checkIn', hospitalName)
            end,
        }
    })
end

---@param hospitalName string
local function removeCheckInPed(hospitalName)
    local ped = checkInPeds[hospitalName]
    if not ped or not DoesEntityExist(ped) then return end
    
    exports.ox_target:removeLocalEntity(ped)
    DeleteEntity(ped)
    checkInPeds[hospitalName] = nil
end

CreateThread(function()
    for hospitalName, hospital in pairs(sharedConfig.locations.hospitals) do
        if hospital.checkInPed then
            createCheckInPed(hospitalName, hospital.checkInPed)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if cache.resource ~= resourceName then return end
    for hospitalName, _ in pairs(checkInPeds) do
        removeCheckInPed(hospitalName)
    end
end)

