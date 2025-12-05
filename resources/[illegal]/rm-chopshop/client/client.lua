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
            label = "Falar com a Maria",
            icon = "fas fa-refresh",
            onSelect = function()
                exports.mt_lib:showDialogue({
                    ped = chopshopPed,
                    label = 'Maria Fernanda',
                    speech = 'How can I help sweety?',
                    options = {
                        {
                            id = 'sell',
                            label = 'I want to sell fruits',
                            icon = 'apple-alt',
                            close = true,
                            action = function()
                                -- TODO: Start your chopshop / sell mission logic here
                            end
                        },
                        {
                            id = 'buy',
                            label = 'I want to buy seeds',
                            icon = 'seedling',
                            close = true,
                            action = function()
                                -- TODO: Alternative mission / shop logic here
                            end
                        },
                        {
                            id = 'close',
                            label = "I don't need anything",
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