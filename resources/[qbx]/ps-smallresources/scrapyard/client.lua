local Config = require 'scrapyard/config'

local carryingScrap = false
local carriedPropEntity = nil
local currentLootSpotIndex = nil
local currentCarryData = nil

local function debugPrint(...)
    if Config.Debug then
        print('[scrapyard]', ...)
    end
end

local function loadModel(model)
    local modelHash = type(model) == 'string' and joaat(model) or model
    if not IsModelValid(modelHash) then return nil end
    lib.requestModel(modelHash, 5000)
    return modelHash
end

local function playCarryAnim(ped, carryData)
    local dict = (carryData and carryData.animDict) or 'anim@heists@box_carry@'
    local clip = (carryData and carryData.anim) or 'idle'
    lib.requestAnimDict(dict)
    TaskPlayAnim(ped, dict, clip, 2.0, 2.0, -1, 49, 0, false, false, false)
end

local function attachCarryProp(ped, carryData)
    local modelName = carryData and carryData.prop
    if not modelName then return end
    local model = loadModel(modelName)
    if not model then return end

    local coords = GetEntityCoords(ped)
    carriedPropEntity = CreateObject(model, coords.x, coords.y, coords.z + 0.2, true, true, false)
    SetEntityAsMissionEntity(carriedPropEntity, true, false)
    SetEntityCollision(carriedPropEntity, false, false)

    local boneIndex = (carryData and carryData.boneIndex) or 60309
    local bone = GetPedBoneIndex(ped, boneIndex)
    local ox = 0.0
    local oy = 0.0
    local oz = 0.0
    local rx = -90.0
    local ry = 0.0
    local rz = 90.0
    if carryData and carryData.offsets and #carryData.offsets >= 6 then
        ox, oy, oz, rx, ry, rz = table.unpack(carryData.offsets)
    end
    AttachEntityToEntity(carriedPropEntity, ped, bone, ox, oy, oz, rx, ry, rz, true, true, false, true, 2, true)
    playCarryAnim(ped, carryData)
end

local function clearCarry()
    local ped = PlayerPedId()
    if carriedPropEntity and DoesEntityExist(carriedPropEntity) then
        DeleteEntity(carriedPropEntity)
    end
    carriedPropEntity = nil
    carryingScrap = false
    currentLootSpotIndex = nil
    ClearPedTasks(ped)
    ResetPedMovementClipset(ped, 0.0)
    currentCarryData = nil
end

-- disable sprint, jump, and vehicle seat shuffle while carrying
CreateThread(function()
    while true do
        if carryingScrap then
            if currentCarryData and currentCarryData.disableSprint then
                DisableControlAction(0, 21, true)  -- sprint
            end
            if currentCarryData and currentCarryData.disableJump then
                DisableControlAction(0, 22, true)  -- jump
            end
            if currentCarryData and currentCarryData.disableFight then
                DisableControlAction(0, 44, true)  -- cover
                DisableControlAction(0, 37, true)  -- select weapon
                DisableControlAction(0, 24, true)  -- attack
                DisableControlAction(0, 25, true)  -- aim
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 141, true)
                DisableControlAction(0, 142, true)
                DisableControlAction(0, 257, true)
            end
            Wait(0)
        else
            Wait(250)
        end
    end
end)

local function createBlip()
    if not Config.ScrapPlaces or not Config.ScrapPlaces.coords or not Config.ScrapPlaces.blip then return end
    local info = Config.ScrapPlaces
    local pos = info.blip.coords or vec3(info.coords.x, info.coords.y, info.coords.z)
    local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite(blip, info.blip.sprite or 1)
    SetBlipColour(blip, info.blip.color or 0)
    SetBlipScale(blip, info.blip.scale or 0.65)
    SetBlipAsShortRange(blip, info.blip.shortRange ~= false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(info.blip.name or 'Scrapyard')
    EndTextCommandSetBlipName(blip)
end

local createdPed = nil
local function spawnPedAndTarget()
    local info = Config.ScrapPlaces
    if not info or not info.coords then return end

    local model = loadModel(info.pedmodel or 's_m_m_dockwork_01')
    if not model then return end

    local coords = vec3(info.coords.x, info.coords.y, info.coords.z)
    createdPed = CreatePed(0, model, coords.x, coords.y, coords.z - 1.0, info.coords.w or 0.0, false, true)
    SetEntityAsMissionEntity(createdPed, true, true)
    SetBlockingOfNonTemporaryEvents(createdPed, true)
    SetEntityInvincible(createdPed, true)
    FreezeEntityPosition(createdPed, true)

    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:addLocalEntity(createdPed, {
            {
                name = 'scrapyard_deliver',
                icon = 'fa-solid fa-box',
                label = 'Deliver Scrap',
                distance = 2.0,
                canInteract = function(entity, distance, coordsName)
                    return carryingScrap and carryingScrap ~= false
                end,
                onSelect = function(data)
                    if not carryingScrap then return end
                    local success = lib.progressCircle({
                        label = 'Handing over scrap...',
                        duration = (Config.DeliverDuration or 5000),
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = false,
                        disable = { move = true, car = true, mouse = false, combat = true },
                        anim = { dict = 'mp_common', clip = 'givetake1_a' },
                    })
                    if not success then return end

                    TriggerServerEvent('scrapyard:deliver', carryingScrap)
                    clearCarry()
                end
            }
        })
    end
end

local function registerLootSpots()
    if GetResourceState('ox_target') ~= 'started' then
        print('ox_target is required for scrapyard loot spots')
        return
    end
    for index, spot in ipairs(Config.LootPlaces or {}) do
        exports.ox_target:addSphereZone({
            coords = spot,
            radius = (Config.TargetRadius or 0.6),
            debug = Config.Debug or false,
            options = {
                {
                    icon = 'fa-solid fa-magnifying-glass',
                    label = 'Search scrap',
                    distance = 1.5,
                    onSelect = function(data)
                        if carryingScrap then
                            lib.notify({ title = 'Scrapyard', description = 'You are already carrying scrap.', type = 'error' })
                            return
                        end
                        local begun, remainingTime = lib.callback.await('scrapyard:beginLoot', false, index)
                        if not begun then
                            if remainingTime and remainingTime > 0 then
                                local minutes = math.floor(remainingTime / 60)
                                local seconds = remainingTime % 60
                                local timeStr = minutes > 0 and string.format('%dm %ds', minutes, seconds) or string.format('%ds', seconds)
                                lib.notify({ 
                                    title = 'Scrapyard', 
                                    description = 'This spot is on cooldown. Try again in ' .. timeStr, 
                                    type = 'error' 
                                })
                            else
                                lib.notify({ title = 'Scrapyard', description = 'Nothing useful here right now.', type = 'error' })
                            end
                            return
                        end

                        local success = lib.progressCircle({
                            label = 'Searching...',
                            duration = (Config.SearchDuration or 7000),
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { move = true, car = true, mouse = false, combat = true },
                            anim = { dict = 'amb@prop_human_bum_bin@base', clip = 'base' },
                        })
                        if not success then return end

                        local ped = PlayerPedId()
                        local token = lib.callback.await('scrapyard:pickupScrap', false, index)
                        if not token then
                            lib.notify({ title = 'Scrapyard', description = 'Search failed.', type = 'error' })
                            return
                        end
                        carryingScrap = token
                        currentLootSpotIndex = index
                        if Config.ItemCarrying and #Config.ItemCarrying > 0 then
                            currentCarryData = Config.ItemCarrying[math.random(1, #Config.ItemCarrying)]
                        else
                            currentCarryData = { prop = 'prop_wheel_01', boneIndex = 60309, anim = 'idle', animDict = 'anim@heists@box_carry@', disableSprint = true, disableJump = true, disableFight = true, offsets = { 0.1, 0.0, 0.0, -90.0, 0.0, 90.0 } }
                        end
                        if currentCarryData then
                            attachCarryProp(ped, currentCarryData)
                        end
                        lib.notify({ title = 'Scrapyard', description = 'Carry the scrap to the scrapyard boss.', type = 'inform' })
                    end
                }
            }
        })
    end
end

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    clearCarry()
    if createdPed and DoesEntityExist(createdPed) then
        DeleteEntity(createdPed)
    end
end)

CreateThread(function()
    Wait(500)
    createBlip()
    spawnPedAndTarget()
    registerLootSpots()
end)


-- Listen to player state bag updates for lightweight reward messages
local function onStateChange(bagName, key, value, reserved, replicated)
    if key ~= 'scrapyardReward' then return end
    if not value or not value.msg then return end
    lib.notify({ title = 'Scrapyard', description = value.msg, type = 'success' })
end

local playerId = cache and cache.playerId or GetPlayerServerId(PlayerId())
local bag = ('player:%s'):format(playerId)
AddStateBagChangeHandler('scrapyardReward', bag, onStateChange)


