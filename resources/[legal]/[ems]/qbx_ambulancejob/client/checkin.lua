local sharedConfig = require 'config.shared'

---@type table<string, number>
local checkInPeds = {}

---@param ped number
---@param scenario? string
local function setPedScenario(ped, scenario)
    if not scenario then return end
    TaskStartScenarioInPlace(ped, scenario, 0, true)
end

---Process the check-in with payment method
---@param hospitalName string
---@param paymentMethod string
local function processCheckIn(hospitalName, paymentMethod)
    local canCheckIn = lib.callback.await('qbx_ambulancejob:server:canCheckIn', false, hospitalName)
    if not canCheckIn then return end

    if lib.progressCircle({
        duration = 2000,
        position = 'bottom',
        label = locale('progress.checking_in'),
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
        },
        anim = {
            clip = 'base',
            dict = 'missheistdockssetup1clipboard@base',
            flag = 16
        },
        prop = {
            {
                model = 'prop_notepad_01',
                bone = 18905,
                pos = vec3(0.1, 0.02, 0.05),
                rot = vec3(10.0, 0.0, 0.0),
            },
            {
                model = 'prop_pencil_01',
                bone = 58866,
                pos = vec3(0.11, -0.02, 0.001),
                rot = vec3(-120.0, 0.0, 0.0)
            }
        }
    })
    then
        local success = lib.callback.await('qbx_ambulancejob:server:checkIn', false, cache.serverId, hospitalName, paymentMethod)
        if not success then
            exports.qbx_core:Notify(locale('error.payment_failed'), 'error')
        end
    else
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
    end
end

---Show dialog with specific options (for updating dialog in place)
---@param ped number
---@param hospitalName string
---@param pedName string
---@param dialogState string 'main' or 'payment'
local function showDialog(ped, hospitalName, pedName, dialogState)
    local cost = sharedConfig.checkInCost
    local options = {}
    
    if dialogState == 'main' then
        -- Main dialog options
        options = {
            {
                id = 'checkin',
                label = locale('text.check') .. ' - $' .. cost,
                icon = 'clipboard',
                close = false,
                action = function()
                    -- Update dialog to show payment options
                    showDialog(ped, hospitalName, pedName, 'payment')
                end
            },
            {
                id = 'close',
                label = locale('text.no') or "I don't need anything",
                icon = 'ban',
                close = true,
            },
        }
        
        exports.mt_lib:showDialogue({
            ped = ped,
            label = pedName,
            speech = 'How can I help you?',
            options = options
        })
    elseif dialogState == 'payment' then
        -- Payment selection options
        options = {
            {
                id = 'cash',
                label = locale('text.pay_cash') .. ' ($' .. cost .. ')',
                icon = 'money-bill-wave',
                close = true,
                action = function()
                    CreateThread(function()
                        -- Check money before processing
                        local hasCash = lib.callback.await('qbx_ambulancejob:server:hasMoneyForCheckIn', false, 'cash')
                        if hasCash then
                            processCheckIn(hospitalName, 'cash')
                        else
                            exports.qbx_core:Notify(locale('error.not_enough_money'), 'error')
                        end
                    end)
                end
            },
            {
                id = 'card',
                label = locale('text.pay_card') .. ' ($' .. cost .. ')',
                icon = 'credit-card',
                close = true,
                action = function()
                    CreateThread(function()
                        -- Check money before processing
                        local hasCard = lib.callback.await('qbx_ambulancejob:server:hasMoneyForCheckIn', false, 'card')
                        if hasCard then
                            processCheckIn(hospitalName, 'card')
                        else
                            exports.qbx_core:Notify(locale('error.not_enough_money'), 'error')
                        end
                    end)
                end
            },
            {
                id = 'back',
                label = 'Back',
                icon = 'arrow-left',
                close = false,
                action = function()
                    -- Go back to main dialog
                    showDialog(ped, hospitalName, pedName, 'main')
                end
            },
        }
        
        exports.mt_lib:showDialogue({
            ped = ped,
            label = pedName,
            speech = locale('text.payment_method') .. '? The cost is $' .. cost .. '.',
            options = options
        })
    end
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
    
    -- Store ped data for later use
    local pedName = pedData.name or 'Hospital Receptionist'
    
    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'hospital_checkin_' .. hospitalName,
            icon = 'fas fa-clipboard',
            label = locale('text.check_in'),
            distance = 2.5,
            onSelect = function()
                showDialog(ped, hospitalName, pedName, 'main')
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

