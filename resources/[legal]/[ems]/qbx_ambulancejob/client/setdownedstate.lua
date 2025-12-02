local config = require 'config.client'
local sharedConfig = require 'config.shared'
local doctorCount = 0
local helpCooldown = 0
local helpCooldownTimer = 0
local isUIVisible = false
local laststandStartTime = 0
local laststandTimerActive = false

local function getDoctorCount()
    return lib.callback.await('qbx_ambulancejob:server:getNumDoctors')
end

---Send NUI message to update the death screen UI
---@param messageType string
---@param data table
local function sendNUIMessage(messageType, data)
    -- Ensure canCallHelp is always a boolean (not nil)
    local canCallHelpValue = data.canCallHelp == true
    local message = {
        type = messageType,
        timer = data.timer,
        canCallHelp = canCallHelpValue,
        helpCooldown = data.helpCooldown,
    }
    SendNUIMessage(message)
end

---Show death screen UI
---@param deathTime number
local function showDeathUI(deathTime)
    if not isUIVisible then
        isUIVisible = true
        SetNuiFocus(false, false) -- Keep focus off, UI is non-interactive
    end
    sendNUIMessage('eliminated', {
        timer = math.ceil(deathTime),
        canCallHelp = true, -- Always allow showing the help text
        helpCooldown = helpCooldown > 0 and helpCooldown or nil,
    })
end

---Show last stand UI
---@param laststandTime number
local function showLastStandUI(laststandTime)
    if not isUIVisible then
        isUIVisible = true
        SetNuiFocus(false, false)
    end
    -- Use our config timer instead of qbx_medical's timer
    if not laststandTimerActive then
        laststandStartTime = GetGameTimer()
        laststandTimerActive = true
    end
    local elapsed = math.floor((GetGameTimer() - laststandStartTime) / 1000)
    local remainingTime = math.max(0, config.laststandTimer - elapsed)
    sendNUIMessage('knocked_down', {
        timer = math.ceil(remainingTime),
        canCallHelp = true, -- Always allow showing the help text
        helpCooldown = helpCooldown > 0 and helpCooldown or nil,
    })
end

---Hide death screen UI
local function hideDeathUI()
    if isUIVisible then
        isUIVisible = false
        sendNUIMessage('ambulance_reset', {})
    end
    laststandTimerActive = false
    laststandStartTime = 0
end

---Update death timer in UI
---@param deathTime number
local function updateDeathTimer(deathTime)
    if isUIVisible then
        if deathTime <= 0 then
            sendNUIMessage('update_respawn_available', {})
        else
            sendNUIMessage('update_respawn_timer', {
                timer = math.ceil(deathTime),
            })
        end
    end
end

---Handle help call from player (H key pressed)
local function handleHelpCall()
    -- Allow calling help regardless of doctor count, but check cooldown
    if helpCooldown <= 0 then
        TriggerServerEvent('hospital:server:ambulanceAlert', locale('info.civ_down'))
        EmsNotified = true
        helpCooldown = 300 -- 5 minutes cooldown
        helpCooldownTimer = GetGameTimer()
        sendNUIMessage('help_called', {
            helpCooldown = helpCooldown,
        })
        exports.qbx_core:Notify('Help request sent to medical personnel', 'success')
    else
        local remaining = math.ceil(helpCooldown - math.floor((GetGameTimer() - helpCooldownTimer) / 1000))
        exports.qbx_core:Notify(string.format('You must wait %d seconds before calling for help again', remaining), 'error')
    end
end

---@param ped number
local function playDeadAnimation(ped)
    if IsInHospitalBed then
        if not IsEntityPlayingAnim(ped, InBedDict, InBedAnim, 3) then
            lib.playAnim(ped, InBedDict, InBedAnim, 1.0, 1.0, -1, 1, 0, false, false, false)
        end
    else
        exports.qbx_medical:PlayDeadAnimation()
    end
end

---@param ped number
local function handleDead(ped)
    playDeadAnimation(ped)
end

local function handleLastStand()
    -- Animation is handled by qbx_medical
end

---Handle help cooldown timer
CreateThread(function()
    while true do
        if helpCooldown > 0 then
            local currentTime = GetGameTimer()
            local elapsed = math.floor((currentTime - helpCooldownTimer) / 1000)
            if elapsed >= helpCooldown then
                helpCooldown = 0
                helpCooldownTimer = 0
                EmsNotified = false
                if isUIVisible then
                    -- Update UI to show help is available again
                    local isDead = exports.qbx_medical:IsDead()
                    local inLaststand = exports.qbx_medical:IsLaststand()
                    if isDead then
                        local deathTime = exports.qbx_medical:GetDeathTime()
                        sendNUIMessage('eliminated', {
                            timer = math.ceil(deathTime),
                            canCallHelp = true,
                            helpCooldown = nil,
                        })
                    elseif inLaststand then
                        -- Use our config timer instead of qbx_medical's timer
                        if not laststandTimerActive then
                            laststandStartTime = GetGameTimer()
                            laststandTimerActive = true
                        end
                        local elapsed = math.floor((GetGameTimer() - laststandStartTime) / 1000)
                        local remainingTime = math.max(0, config.laststandTimer - elapsed)
                        sendNUIMessage('knocked_down', {
                            timer = math.ceil(remainingTime),
                            canCallHelp = true,
                            helpCooldown = nil,
                        })
                    end
                end
            else
                local remaining = helpCooldown - elapsed
                if isUIVisible then
                    sendNUIMessage('update_help_cooldown', {
                        helpCooldown = remaining,
                    })
                end
            end
        end
        Wait(1000)
    end
end)

---Update death timer continuously in UI (only when changed to prevent spam)
CreateThread(function()
    local lastSentTimer = nil
    while true do
        if isUIVisible then
            local isDead = exports.qbx_medical:IsDead()
            local inLaststand = exports.qbx_medical:IsLaststand()
            
            if isDead then
                local deathTime = math.ceil(exports.qbx_medical:GetDeathTime())
                -- Only send update if timer changed
                if lastSentTimer ~= deathTime then
                    lastSentTimer = deathTime
                    updateDeathTimer(deathTime)
                end
            elseif inLaststand then
                -- Use our config timer instead of qbx_medical's timer
                if not laststandTimerActive then
                    laststandStartTime = GetGameTimer()
                    laststandTimerActive = true
                end
                local elapsed = math.floor((GetGameTimer() - laststandStartTime) / 1000)
                local remainingTime = math.max(0, config.laststandTimer - elapsed)
                local laststandTime = math.ceil(remainingTime)
                -- Only send update if timer changed
                if lastSentTimer ~= laststandTime then
                    lastSentTimer = laststandTime
                    sendNUIMessage('update_respawn_timer', {
                        timer = laststandTime,
                    })
                end
            end
        else
            lastSentTimer = nil -- Reset when UI hidden
        end
        Wait(1000)
    end
end)

---Reset UI when player is revived
RegisterNetEvent('hospital:client:Revive', function()
    hideDeathUI()
    helpCooldown = 0
    helpCooldownTimer = 0
    LocalPlayer.state.invBusy = false
end)

RegisterNetEvent('qbx_medical:client:playerRevived', function()
    hideDeathUI()
    helpCooldown = 0
    helpCooldownTimer = 0
    LocalPlayer.state.invBusy = false
end)

---Block inventory and animations when dead
CreateThread(function()
    while true do
        local isDead = exports.qbx_medical:IsDead()
        local inLaststand = exports.qbx_medical:IsLaststand()
        
        if isDead or inLaststand then
            LocalPlayer.state.invBusy = true
            -- Prevent inventory from opening
            if exports.ox_inventory then
                DisableControlAction(0, 289, true) -- F2 key (inventory)
            end
            -- Block animations (hands up, etc.)
            DisableControlAction(0, 36, true) -- Ctrl (duck/crouch)
            DisableControlAction(0, 44, true) -- Q (hands up)
            DisableControlAction(0, 140, true) -- R (reload/animations)
            DisableControlAction(0, 141, true) -- Shift (sprint)
            DisableControlAction(0, 142, true) -- Alt (walk)
            DisableControlAction(0, 143, true) -- X (hands up)
            DisableControlAction(0, 172, true) -- Arrow up
            DisableControlAction(0, 173, true) -- Arrow down
            DisableControlAction(0, 174, true) -- Arrow left
            DisableControlAction(0, 175, true) -- Arrow right
            -- Enable H key for help call
            EnableControlAction(0, 74, true) -- H key
        else
            if not IsInHospitalBed then
                LocalPlayer.state.invBusy = false
            end
        end
        Wait(0)
    end
end)

---Listen for death events to show UI immediately
RegisterNetEvent('qbx_medical:client:onPlayerDied', function()
    CreateThread(function()
        Wait(500) -- Small delay to ensure death state is set
        local isDead = exports.qbx_medical:IsDead()
        if isDead then
            local deathTime = exports.qbx_medical:GetDeathTime()
            showDeathUI(deathTime)
        end
    end)
end)

RegisterNetEvent('qbx_medical:client:onPlayerLaststand', function()
    CreateThread(function()
        Wait(500) -- Small delay to ensure laststand state is set
        local inLaststand = exports.qbx_medical:IsLaststand()
        if inLaststand then
            -- Reset timer tracking when laststand starts
            laststandStartTime = GetGameTimer()
            laststandTimerActive = true
            showLastStandUI(config.laststandTimer)
        end
    end)
end)

---Set dead and last stand states.
CreateThread(function()
    local lastUpdate = 0 -- Initialize to 0 so we fetch immediately
    local isFirstCheck = true
    while true do
        local isDead = exports.qbx_medical:IsDead()
        local inLaststand = exports.qbx_medical:IsLaststand()
        
        if isDead or inLaststand then
            -- Always show UI when dead/laststand (in case events didn't fire)
            if not isUIVisible then
                if isDead then
                    local deathTime = exports.qbx_medical:GetDeathTime()
                    showDeathUI(deathTime)
                elseif inLaststand then
                    -- Reset timer tracking when laststand starts
                    if not laststandTimerActive then
                        laststandStartTime = GetGameTimer()
                        laststandTimerActive = true
                    end
                    showLastStandUI(config.laststandTimer)
                end
            end
            
            -- Fetch doctor count immediately on first death/laststand, then every 60 seconds
            local currentTime = GetGameTimer()
            if (currentTime - lastUpdate) > 60000 or isFirstCheck then
                doctorCount = getDoctorCount()
                lastUpdate = currentTime
                isFirstCheck = false
            end
            
            -- Handle animations
            if isDead then
                handleDead(cache.ped)
            elseif inLaststand then
                handleLastStand()
            end

            -- Handle help call key press (H key - control 74)
            -- Enable the control first, then check if pressed
            EnableControlAction(0, 74, true)
            if IsControlJustPressed(0, 74) and not IsPauseMenuActive() then
                handleHelpCall()
            end

            Wait(0)
        else
            if isUIVisible then
                hideDeathUI()
            end
            lastUpdate = 0 -- Reset so we fetch immediately next time
            isFirstCheck = true
            Wait(1000)
        end
    end
end)

