local utils = require 'modules.utils'

--- NUI visibility example (already present)
RegisterNuiCallback('hideApp', function(data, cb)
    utils.ShowNUI('UPDATE_VISIBILITY', false)
    cb(true)
end)

---------------------------------------------------------------------
-- Chopshop PED + ox_target + mt_lib dialogue
---------------------------------------------------------------------

local chopshopPed
local hasChopContract = false
local currentContract = nil
local contractCompleted = false

local function loadModel(model)
    if type(model) == 'string' then
        model = joaat(model)
    end

    RequestModel(model)
    local startTime = GetGameTimer()

    while not HasModelLoaded(model) do
        Wait(0)
        if GetGameTimer() - startTime > 5000 then -- 5s timeout
            print('[rm-chopshop] Failed to load PED model, using default a_f_m_bevhills_01')
            model = joaat('a_f_m_bevhills_01')
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            break
        end
    end

    return model
end

local function spawnChopshopPed()
    if chopshopPed or not Config or not Config.ChopshopPed or not Config.ChopshopPed.enabled then
        return
    end

    local cfg = Config.ChopshopPed

    local model = loadModel(cfg.model or 'a_f_m_bevhills_01')

    local coords = cfg.coords or vec4(123.0, -1045.0, 29.2, 180.0)
    local x, y, z, w = coords.x, coords.y, coords.z, coords.w or coords.heading or 0.0

    chopshopPed = CreatePed(4, model, x, y, z - 1.0, w, false, true)

    if not DoesEntityExist(chopshopPed) then
        print('[rm-chopshop] Failed to create chopshop PED')
        return
    end

    SetEntityAsMissionEntity(chopshopPed, true, false)
    FreezeEntityPosition(chopshopPed, true)
    SetEntityInvincible(chopshopPed, true)
    SetBlockingOfNonTemporaryEvents(chopshopPed, true)

    -- Optional idle animation so the ped looks alive
    TaskStartScenarioInPlace(chopshopPed, 'WORLD_HUMAN_STAND_IMPATIENT', 0, true)

    -- ox_target interaction with mt_lib dialogue
    exports.ox_target:addLocalEntity(chopshopPed, {
        {
            label = "Talk to Carlos",
            icon = "fas fa-comments",
            distance = 2.0,
            onSelect = function()
                if currentContract and contractCompleted then
                    -- Completion dialogue
                    exports.mt_lib:showDialogue({
                        ped = chopshopPed,
                        label = 'Carlos Ramirez',
                        speech = "So, you got the job done or what, hermano?",
                        options = {
                            {
                                id = 'finished_yes',
                                label = "Yeah, everything's chopped.",
                                icon = 'check',
                                close = true,
                                action = function()
                                    TriggerServerEvent('rm-chopshop:claimReward')
                                end
                            },
                            {
                                id = 'finished_no',
                                label = "Not yet, still working on it.",
                                icon = 'times',
                                close = true,
                            },
                        }
                    })
                    return
                end

                -- First dialogue: street-style greeting
                exports.mt_lib:showDialogue({
                    ped = chopshopPed,
                    label = 'Carlos Ramirez',
                    speech = "What you doin' around here, amigo? You lookin' for something?",
                    options = {
                        {
                            id = 'money',
                            label = "Yeah, I'm tryin' to make some money",
                            icon = 'dollar-sign',
                            close = false, -- keep the same dialog open
                            action = function()
                                -- Second step: he offers chop work but stays in the same dialog window
                                exports.mt_lib:showDialogue({
                                    ped = chopshopPed,
                                    label = 'Carlos Ramirez',
                                    speech = "Heh, I like that. I got some work with cars… real quiet work. You down to chop some vehicles for me or what?",
                                    options = {
                                        {
                                            id = 'accept',
                                            label = "Yeah, I'm in. Show me what you got.",
                                            icon = 'check',
                                            close = true,
                                            action = function()
                                                TriggerServerEvent('rm-chopshop:startJob')
                                            end
                                        },
                                        {
                                            id = 'decline',
                                            label = "Nah, this sounds too hot for me.",
                                            icon = 'times',
                                            close = true,
                                            action = function()
                                                -- Player declines, nothing happens for now
                                            end
                                        },
                                    }
                                })
                            end
                        },
                        {
                            id = 'just_looking',
                            label = "Relax man, I'm just lookin' around.",
                            icon = 'eye',
                            close = true,
                            action = function()
                                exports.mt_lib:showDialogue({
                                    ped = chopshopPed,
                                    label = 'Carlos Ramirez',
                                    speech = "Aight, then keep it movin', hermano. This spot ain't for tourists.",
                                    options = {
                                        {
                                            id = 'close',
                                            label = "Alright, I'm out of here.",
                                            icon = 'ban',
                                            close = true,
                                        },
                                    }
                                })
                            end
                        },
                        {
                            id = 'leave',
                            label = "Forget it, I don't need anything.",
                            icon = 'ban',
                            close = true,
                        },
                    }
                })
            end
        }
    })
end

CreateThread(function()
    -- Delay slightly to ensure configs & targets are ready
    Wait(1000)
    spawnChopshopPed()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    if chopshopPed and DoesEntityExist(chopshopPed) then
        DeleteEntity(chopshopPed)
        chopshopPed = nil
    end
end)

---------------------------------------------------------------------
-- Chopshop Delivery Zone + Vehicle Chopping
---------------------------------------------------------------------

local function isPointInDeliveryZone(coords)
    if not Config or not Config.ChopshopDeliveryZone or #Config.ChopshopDeliveryZone < 4 then
        return false
    end

    local minX, maxX = 99999.0, -99999.0
    local minY, maxY = 99999.0, -99999.0
    local avgZ = 0.0

    for _, v in ipairs(Config.ChopshopDeliveryZone) do
        if v.x < minX then minX = v.x end
        if v.x > maxX then maxX = v.x end
        if v.y < minY then minY = v.y end
        if v.y > maxY then maxY = v.y end
        avgZ = avgZ + v.z
    end

    avgZ = avgZ / #Config.ChopshopDeliveryZone

    local x, y = coords.x, coords.y

    if x >= minX and x <= maxX and y >= minY and y <= maxY then
        return true, vector3((minX + maxX) / 2.0, (minY + maxY) / 2.0, avgZ)
    end

    return false
end

RegisterNetEvent('rm-chopshop:jobStarted', function(contract)
    hasChopContract = true
    contractCompleted = false
    currentContract = contract
end)

RegisterNetEvent('rm-chopshop:contractUpdated', function(contract)
    currentContract = contract
    contractCompleted = contract.completed or false
end)

RegisterNetEvent('rm-chopshop:jobFinished', function()
    hasChopContract = false
    contractCompleted = false
    currentContract = nil
end)

CreateThread(function()
    local showingText = false

    while true do
        Wait(0)

        if not hasChopContract or not currentContract or contractCompleted then
            if showingText and lib and lib.hideTextUI then
                lib.hideTextUI()
                showingText = false
            end

            goto continue
        end

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        local inZone, center = isPointInDeliveryZone(coords)

        if inZone then
            local veh = GetVehiclePedIsIn(ped, false)

            if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
                if lib and lib.showTextUI then
                    if not showingText then
                        lib.showTextUI('[E] Deliver vehicle', {
                            position = 'left-center'
                        })
                        showingText = true
                    end
                end

                if IsControlJustPressed(0, 38) then -- E
                    local model = GetEntityModel(veh)
                    local modelName = GetDisplayNameFromVehicleModel(model)
                    if modelName then
                        modelName = modelName:lower()
                    end

                    -- quick check client-side to see if this model is part of contract
                    local valid = false
                    if currentContract and currentContract.remaining then
                        for _, required in ipairs(currentContract.remaining) do
                            if required:lower() == modelName then
                                valid = true
                                break
                            end
                        end
                    end

                    if not valid then
                        if lib and lib.notify then
                            lib.notify({
                                title = 'Chopshop',
                                description = 'This vehicle is not part of your contract.',
                                type = 'error'
                            })
                        end
                    else
                        if lib and lib.progressCircle then
                            local result = lib.progressCircle({
                                duration = 180000, -- 3 minutes
                                label = 'Chopping vehicle...',
                                useWhileDead = false,
                                canCancel = false, -- don't allow cancelling with key, only fail on real interrupt
                                disable = {
                                    car = true,
                                    move = true,
                                    combat = true,
                                }
                            })

                            -- Some ox_lib versions return nil on success, false on cancel.
                            -- Treat anything that is NOT false as success to avoid wrong "cancelled" message.
                            if result ~= false then
                                -- Visually damage/remove parts
                                for i = 0, 5 do
                                    SetVehicleDoorBroken(veh, i, true)
                                end

                                for i = 0, 5 do
                                    SetVehicleTyreBurst(veh, i, true, 1000.0)
                                end

                                SetVehicleEngineHealth(veh, 0.0)
                                SetVehicleBodyHealth(veh, 0.0)

                                local netId = NetworkGetNetworkIdFromEntity(veh)

                                -- Let the server delete the vehicle and update contract
                                TriggerServerEvent('rm-chopshop:deliverVehicle', modelName)
                                TriggerServerEvent('rm-chopshop:deleteVehicle', netId)
                            elseif lib and lib.notify then
                                if lib and lib.notify then
                                    lib.notify({
                                        title = 'Chopshop',
                                        description = 'Chopping cancelled.',
                                        type = 'error'
                                    })
                                end
                            end
                        end
                    end
                end
            else
                if showingText and lib and lib.hideTextUI then
                    lib.hideTextUI()
                    showingText = false
                end
            end
        else
            if showingText and lib and lib.hideTextUI then
                lib.hideTextUI()
                showingText = false
            end
        end

        ::continue::
    end
end)