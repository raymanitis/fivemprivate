local trackedVehicles = {}

local function normalizePlate(plate)
    if not plate or type(plate) ~= 'string' then return nil end
    return plate:gsub('%s+', ''):upper()
end

local function isPlayerInVehicleWithControl()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        return vehicle
    end
    local coords = GetEntityCoords(ped)
    local vehicleInFront = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)
    if vehicleInFront ~= 0 then
        return vehicleInFront
    end
    return 0
end

local function keepVehicleCleanLoop()
    CreateThread(function()
        while true do
            local sleep = 25000
            if next(trackedVehicles) ~= nil then
                sleep = 200
                for vehicle, _ in pairs(trackedVehicles) do
                    if DoesEntityExist(vehicle) then
                        SetVehicleDirtLevel(vehicle, 0.0)
                        WashDecalsFromVehicle(vehicle, 1.0)
                    else
                        trackedVehicles[vehicle] = nil
                    end
                end
            end
            Wait(sleep)
        end
    end)
end

keepVehicleCleanLoop()

RegisterNetEvent('dx_wax:client:beginWax', function()
    local vehicle = isPlayerInVehicleWithControl()
    if vehicle == 0 then
        lib.notify({ type = 'error', description = 'Vehicle not found' })
        return
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    local normalized = normalizePlate(plate)
    if not normalized then return end

    local alreadyWaxed = lib.callback.await('dx_wax:server:isWaxed', false, normalized)
    if alreadyWaxed then
        lib.notify({ type = 'info', description = 'This vehicle is already waxed.' })
        return
    end

    if lib.progressBar({ duration = 3500, label = 'Waxing vehicle...', useWhileDead = false, canCancel = true, disable = { car = true, move = true, combat = true }}) then
        TriggerServerEvent('dx_wax:server:applyWax', normalized)
    end
end)

RegisterNetEvent('dx_wax:client:waxed', function(normalizedPlate)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        local coords = GetEntityCoords(ped)
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)
        if vehicle == 0 then return end
    end
    local plate = GetVehicleNumberPlateText(vehicle)
    if normalizePlate(plate) ~= normalizedPlate then return end
    trackedVehicles[vehicle] = true
    SetVehicleDirtLevel(vehicle, 0.0)
    WashDecalsFromVehicle(vehicle, 1.0)
end)

CreateThread(function()
    local lastVehicle = 0
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= lastVehicle and vehicle ~= 0 then
            lastVehicle = vehicle
            local plate = GetVehicleNumberPlateText(vehicle)
            local normalized = normalizePlate(plate)
            if normalized and lib.callback.await('dx_wax:server:isWaxed', false, normalized) then
                trackedVehicles[vehicle] = true
                SetVehicleDirtLevel(vehicle, 0.0)
            end
        elseif vehicle == 0 then
            lastVehicle = 0
        end
        Wait(1000)
    end
end)


