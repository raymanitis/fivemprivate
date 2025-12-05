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
            label = "Talk to Carlos",
            icon = "fas fa-comments",
            onSelect = function()
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
                                                -- Here you will later start the chop mission
                                                -- For now, it's just dialogue.
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