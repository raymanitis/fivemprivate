-- Pietupsanas --
local shouldCrouch = false
lib.addKeybind({
    name = 'crouchNow',
    description = 'Crouch',
    defaultKey = 'LCONTROL',
    onPressed = function()
        if cache.vehicle or IsPauseMenuActive() or (not DoesEntityExist(cache.ped)) or IsEntityDead(cache.ped) or IsPlayerFreeAiming(cache.playerId) or LocalPlayer.state.invOpen then
            return false
        end
        shouldCrouch = true
        startCrouching()
    end,
})

local crouched = false
function startCrouching()
    CreateThread(function()
        while shouldCrouch do
            Wait(1)
            local ped = cache.ped

            if crouched then
                ResetPedMovementClipset(ped, 0.5)
                ResetPedStrafeClipset(ped)
                local kvp = GetExternalKvpString("scully_emotemenu", "animations_walkstyle")
                if kvp ~= nil then
                    lib.requestAnimSet(kvp, 1000)
                    SetPedMovementClipset(cache.ped, kvp, 0.55)
                    RemoveAnimSet(kvp)
                end
                crouched = false
                shouldCrouch = false
            elseif not crouched then
                lib.requestAnimSet("move_ped_crouched")
                SetPedMovementClipset(ped, "move_ped_crouched", 0.55)
                SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
                crouched = true
                shouldCrouch = false
            end
        end
        while crouched do
            Wait(1500)
            SetPedMovementClipset(ped, "move_ped_crouched", 0.55)
            SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
        end
    end)
end
CreateThread(function()
    while true do
        local waitMs = 250
        if not cache.vehicle then
            local ped = cache.ped
            if GetPedStealthMovement(ped) then
                SetPedStealthMovement(ped, false)
                waitMs = 25
            elseif cache.weapon then
                DisableControlAction(0, 36, true) -- Disable stealth mode toggle
                waitMs = 5
            else
                waitMs = 15
            end
        end
        Wait(waitMs)
    end
end)
CreateThread(function()
    while true do
        Wait(0)
        local ped = cache.ped
        if not cache.vehicle then
            if crouched then
                if IsPlayerFreeAiming(cache.playerId) then
                    ResetPedMovementClipset(ped, 0.5)
                    ResetPedStrafeClipset(ped)
                    local kvp = GetExternalKvpString("scully_emotemenu", "animations_walkstyle")
                    if kvp ~= nil then
                        lib.requestAnimSet(kvp, 1000)
                        SetPedMovementClipset(cache.ped, kvp, 0.2)
                        RemoveAnimSet(kvp)
                    end
                    crouched = false
                end
            else
                Wait(150)
            end
        else
            Wait(500)
        end
    end
end)