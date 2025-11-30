local Config = require 'fixvehmehanik/config'
local QBCore = GetResourceState('qb-core') == 'started' and exports['qb-core']:GetCoreObject()
local ESX = GetResourceState('es_extended') == 'started' and exports.es_extended:getSharedObject()

local isNearZone = false
local currentZoneId = nil

local function getClosestZone()
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    for zoneId, data in pairs(Config.MechanicLocations) do
        if #(pcoords - data.coords) <= (data.radius or 10.0) then
            return zoneId, data
        end
    end
    return nil, nil
end

local function canRepairVehicle(vehicle)
    if not DoesEntityExist(vehicle) then return false end
    if GetEntityModel(vehicle) == 0 then return false end
    return true
end

local function openBonnet(vehicle)
    SetVehicleDoorOpen(vehicle, 4, false, false)
end

local function closeBonnet(vehicle)
    SetVehicleDoorShut(vehicle, 4, false)
end

local function findFrontOfVehiclePosition(vehicle)
    local coords = GetEntityCoords(vehicle)
    local forward = GetEntityForwardVector(vehicle)
    local offset = Config.Settings.pedOffset or 3.0
    return coords + (forward * offset)
end

local spawnedMechanic = nil

local function cleanupRepair(vehicle)
    if spawnedMechanic and DoesEntityExist(spawnedMechanic) then
        DeleteEntity(spawnedMechanic)
        spawnedMechanic = nil
    end
    if vehicle and DoesEntityExist(vehicle) then
        closeBonnet(vehicle)
    end
    FreezeEntityPosition(PlayerPedId(), false)
end

local function startRepair(zoneId, zoneCfg, vehicle)
    local playerPed = PlayerPedId()
    local frontPos = findFrontOfVehiclePosition(vehicle)
    openBonnet(vehicle)

    -- spawn mechanic ped
    local model = GetHashKey(Config.Settings.pedModel or 's_m_m_autoshop_02')
    RequestModel(model)
    local wait = 0
    while not HasModelLoaded(model) and wait < 500 do wait = wait + 1 Wait(10) end
    local zOffset = Config.Settings.pedZOffset or 0.0
    spawnedMechanic = CreatePed(4, model, frontPos.x, frontPos.y, frontPos.z + zOffset, (GetEntityHeading(vehicle) + 180.0) % 360.0, false, true)
    SetEntityInvincible(spawnedMechanic, true)
    SetBlockingOfNonTemporaryEvents(spawnedMechanic, true)
    FreezeEntityPosition(spawnedMechanic, true)

    -- play mechanic anim
    local dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@'
    local anim = 'machinic_loop_mechandplayer'
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(spawnedMechanic, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)

    -- freeze player in vehicle
    FreezeEntityPosition(playerPed, true)

    local ok = exports.ox_lib:progressBar({
        duration = zoneCfg.repairTime or 10000,
        label = ('Repairing vehicle...'):format(zoneCfg.price),
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true },
    })

    if not ok then
        cleanupRepair(vehicle)
        return
    end

    TriggerServerEvent('fixvehmehanik:server:payAndRepair', zoneId, VehToNet(vehicle))
end

CreateThread(function()
    while true do
        local sleep = 800
        local zoneId, zoneCfg = getClosestZone()
        if zoneId and IsPedInAnyVehicle(PlayerPedId(), false) then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if canRepairVehicle(veh) then
                sleep = 0
                if not isNearZone or currentZoneId ~= zoneId then
                    isNearZone = true
                    currentZoneId = zoneId
                end
                local priceText = zoneCfg and zoneCfg.price or 0
                local text = ('Press E to repair your vehicle for $%s'):format(priceText)
                exports.ox_lib:showTextUI(text)
                if IsControlJustPressed(0, Config.Settings.keybind or 38) then
                    startRepair(zoneId, zoneCfg, veh)
                end
            end
        else
            if isNearZone then
                isNearZone = false
                currentZoneId = nil
                exports.ox_lib:hideTextUI()
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('fixvehmehanik:client:finishRepair', function(netVeh)
    local vehicle = NetToVeh(netVeh)
    local vehicleFuel = exports['cdn-fuel']:GetFuel(vehicle)
    if not DoesEntityExist(vehicle) then return end
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleDirtLevel(vehicle, 0.0)
    cleanupRepair(vehicle)
    exports['cdn-fuel']:SetFuel(vehicle, vehicleFuel)
    TriggerEvent('ox_lib:notify', { description = 'Vehicle repaired', type = 'success' })
end)

RegisterNetEvent('fixvehmehanik:client:repairDenied', function(netVeh)
    local vehicle = NetToVeh(netVeh)
    cleanupRepair(vehicle)
end)


