local SetPlayerCanDoDriveBy, IsPedDoingDriveby, IsControlPressed, IsUsingKeyboard, SetCamViewModeForContext, DisableControlAction = SetPlayerCanDoDriveBy, IsPedDoingDriveby, IsControlPressed, IsUsingKeyboard, SetCamViewModeForContext, DisableControlAction
local GetEntityModel, IsVehicleOnAllWheels = GetEntityModel, IsVehicleOnAllWheels
local SetVehicleMaxSpeed = SetVehicleMaxSpeed

-- Air Control
lib.onCache('vehicle', function()
    Wait(100)
    CreateThread(function()
        while cache.vehicle do
            Wait(1)
            local veh = cache.vehicle
            if cache.seat == -1 then
                --print(veh, cache.vehClass, GetEntityModel(veh), `polthrust`, IsVehicleOnAllWheels(veh))
                if not (cache.vehClass == 14 or cache.vehClass == 15 or cache.vehClass == 16 or cache.vehClass == 8 or cache.vehClass == 13 or GetEntityModel(veh) == `polthrust`) and not IsVehicleOnAllWheels(veh) then
                    DisableControlAction(0, 59) -- leaning left/right
                    DisableControlAction(0, 60) -- leaning up/down
                else
                    Wait(250)
                end
            else
                Wait(2500)
            end
        end
    end)
end)


-- FPS Mašīnās --
local cameraMode = false
local disableAim = false
local disabledWeapons = {
    [`weapon_appistol`] = true,
    [`weapon_minismg`] = true,
    [`weapon_tecpistol`] = true,
    [`weapon_microsmg`] = true,
    [`weapon_machinepistol`] = true,
    --[``] = true,
}
local DisableAiming = function()
    CreateThread(function()
        while disableAim do
            DisableControlAction(0, 25, true) -- disable aim
            Wait(1)
        end
    end)
end

lib.onCache('vehicle', function()
    Wait(100)
    CreateThread(function()
        while true do
            Wait(10)
            if cache.vehicle then
                if cache.vehClass == 8 or cache.vehClass == 13 then
                    if cameraMode then
                        if cache.vehClass == 8 then
                            SetCamViewModeForContext(2, 0)
                        else
                            SetCamViewModeForContext(1, 0)
                        end
                        cameraMode = false
                        DisableAiming()
                        SetPlayerCanDoDriveBy(cache.playerId, false)
                        Wait(1500)
                        disableAim = false
                    else
                        Wait(250)
                    end
                else
                    if disabledWeapons[cache.weapon] then
                        cameraMode = false
                        DisableAiming()
                        SetPlayerCanDoDriveBy(cache.playerId, false)
                    else
                        local playerPed = cache.ped
                        if (IsPedDoingDriveby(playerPed) or IsControlPressed(0, 25)) and IsUsingKeyboard(0) then
                            SetPlayerCanDoDriveBy(cache.playerId, true)
                            if cache.vehClass == 8 then
                                SetCamViewModeForContext(2, 4)
                            else
                                SetCamViewModeForContext(1, 4)
                            end
                            DisableControlAction(0, 36, true)
                            cameraMode = true
                        else
                            if cameraMode then
                                if cache.vehClass == 8 then
                                    SetCamViewModeForContext(2, 0)
                                else
                                    SetCamViewModeForContext(1, 0)
                                end
                                cameraMode = false
                                DisableAiming()
                                SetPlayerCanDoDriveBy(cache.playerId, false)
                                Wait(1500)
                                disableAim = false
                            else
                                Wait(150)
                            end
                        end
                    end
                end
            else
                if cameraMode then
                    SetCamViewModeForContext(0, 0)
                    cameraMode = false
                    DisableAiming()
                    SetPlayerCanDoDriveBy(cache.playerId, false)
                    Wait(1500)
                    disableAim = false
                end
                Wait(450)
            end
        end
    end)
end)

lib.onCache('vehicle', function()
    Wait(100)
    if not cache.vehicle then return end
    if cache.seat ~= -1 then return end

    if QBX.PlayerData.metadata.licences.aircraft then
        if cache.vehClass == 15 then
            SetHeliTurbulenceScalar(cache.vehicle, 0.0)
        else
            SetVehicleHandlingFloat(cache.vehicle, "CFlyingHandlingData", "fTurublenceMagnitudeMax", 0.0)
            SetVehicleHandlingFloat(cache.vehicle, "CFlyingHandlingData", "fTurublenceForceMulti", 0.0)
        end
    else
        if cache.vehClass == 15 then
            SetHeliTurbulenceScalar(cache.vehicle, 20.0)
        else
            SetVehicleHandlingFloat(cache.vehicle, "CFlyingHandlingData", "fTurublenceMagnitudeMax", 3.0)
            SetVehicleHandlingFloat(cache.vehicle, "CFlyingHandlingData", "fTurublenceForceMulti", 10.0)
        end
    end
end)


-- Global speed limiter (all vehicle types) --
local SPEED_LIMIT_MS = 270.0 / 3.6 -- 270 km/h

-- If tire-speed-limiter is active (due to tire damage), don't override its limit
local function isTireLimiterActive()
    local ok, result = pcall(function()
        return exports['ray-smallresources'] and exports['ray-smallresources'].isSpeedLimited and exports['ray-smallresources']:isSpeedLimited()
    end)
    return ok and result or false
end

lib.onCache('vehicle', function()
    Wait(100)
    CreateThread(function()
        while cache.vehicle do
            if cache.seat == -1 then
                if not isTireLimiterActive() then
                    SetVehicleMaxSpeed(cache.vehicle, SPEED_LIMIT_MS)
                end
                Wait(1000)
            else
                Wait(1500)
            end
        end
    end)
end)

lib.onCache('seat', function()
    if cache.vehicle and cache.seat == -1 then
        if not isTireLimiterActive() then
            SetVehicleMaxSpeed(cache.vehicle, SPEED_LIMIT_MS)
        end
    end
end)