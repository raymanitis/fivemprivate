local config = require 'config.client'
local sharedConfig = require 'config.shared'
local doctorCount = 0
local helpCooldown = 0
local helpCooldownTimer = 0
local isUIVisible = false
local showTransferPrompt = false
local transferPromptShown = false

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
        canTransfer = data.canTransfer or false,
    }
    SendNUIMessage(message)
end

---Show death screen UI (death is now the final stage, no laststand stage)
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

---Hide death screen UI
local function hideDeathUI()
    if isUIVisible then
        isUIVisible = false
        sendNUIMessage('ambulance_reset', {})
    end
    showTransferPrompt = false
    transferPromptShown = false
end

---Update death timer in UI (death is the final stage)
---@param deathTime number
local function updateDeathTimer(deathTime)
    if isUIVisible then
        if deathTime <= 0 then
            sendNUIMessage('update_respawn_available', {
                canTransfer = config.allowTransferToHospital,
            })
            -- Show transfer prompt when timer ends
            if config.allowTransferToHospital and not transferPromptShown then
                showTransferPrompt = true
                transferPromptShown = true
            end
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
            canTransfer = config.allowTransferToHospital,
        })
        exports.qbx_core:Notify('Help request sent to medical personnel', 'success')
        -- Show transfer prompt when help is called
        if config.allowTransferToHospital and not transferPromptShown then
            showTransferPrompt = true
            transferPromptShown = true
            sendNUIMessage('update_transfer_available', {
                canTransfer = true,
            })
        end
    else
        local remaining = math.ceil(helpCooldown - math.floor((GetGameTimer() - helpCooldownTimer) / 1000))
        exports.qbx_core:Notify(string.format('You must wait %d seconds before calling for help again', remaining), 'error')
    end
end

---Show transfer to hospital dialog
local function showTransferDialog()
    if not config.allowTransferToHospital then return end
    
    local warningText = config.transferLoseItems and locale('info.transfer_warning_items') or locale('info.transfer_warning')
    local dialog = lib.inputDialog(locale('info.transfer_to_hospital'), {
        {
            type = 'label',
            label = warningText,
        }
    })
    
    if not dialog then
        -- User cancelled, just close the dialog
        showTransferPrompt = false
        return
    end
    
    -- User confirmed, transfer to hospital
    local closestHospital = lib.callback.await('qbx_ambulancejob:server:getClosestHospital', false)
    
    if closestHospital then
        -- Use card payment by default for transfer
        local success = lib.callback.await('qbx_ambulancejob:server:checkIn', false, cache.serverId, closestHospital, 'card')
        if success then
            exports.qbx_core:Notify(locale('success.transferred_to_hospital'), 'success')
            hideDeathUI()
        else
            exports.qbx_core:Notify(locale('error.transfer_failed'), 'error')
        end
    else
        exports.qbx_core:Notify(locale('error.transfer_failed'), 'error')
    end
end

---@param ped number
local function handleDead(ped)
    -- Continuously ensure death animation is playing
    if not IsInHospitalBed then
        exports.qbx_medical:PlayDeadAnimation()
    end
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
                    -- Only handle death (no laststand stage)
                    if isDead then
                        local deathTime = math.ceil(exports.qbx_medical:GetDeathTime())
                        sendNUIMessage('eliminated', {
                            timer = deathTime,
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
            
            -- Only handle death (no laststand stage)
            if isDead then
                local deathTime = math.ceil(exports.qbx_medical:GetDeathTime())
                -- Only send update if timer changed
                if lastSentTimer ~= deathTime then
                    lastSentTimer = deathTime
                    updateDeathTimer(deathTime)
                end
                
                -- Show transfer prompt when timer ends
                if deathTime <= 0 and config.allowTransferToHospital and not transferPromptShown then
                    showTransferPrompt = true
                    transferPromptShown = true
                end
            end
            
            -- Update transfer availability in UI
            if showTransferPrompt and config.allowTransferToHospital then
                sendNUIMessage('update_transfer_available', {
                    canTransfer = true,
                })
            end
        else
            lastSentTimer = nil -- Reset when UI hidden
            if lib.isTextUIOpen() then
                lib.hideTextUI()
            end
        end
        Wait(1000)
    end
end)

---Reset UI when player is revived
RegisterNetEvent('hospital:client:Revive', function()
    hideDeathUI()
    helpCooldown = 0
    helpCooldownTimer = 0
    showTransferPrompt = false
    transferPromptShown = false
    LocalPlayer.state.invBusy = false
end)

RegisterNetEvent('qbx_medical:client:playerRevived', function()
    hideDeathUI()
    helpCooldown = 0
    helpCooldownTimer = 0
    showTransferPrompt = false
    transferPromptShown = false
    LocalPlayer.state.invBusy = false
end)

---Block inventory and animations when dead (final stage)
CreateThread(function()
    while true do
        local isDead = exports.qbx_medical:IsDead()
        
        -- Only handle death (no laststand stage)
        if isDead then
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
            
            -- Handle transfer prompt (E key)
            if showTransferPrompt and config.allowTransferToHospital then
                EnableControlAction(0, 38, true) -- E key
                if IsControlJustPressed(0, 38) then
                    showTransferDialog()
                end
            end
        else
            if not IsInHospitalBed then
                LocalPlayer.state.invBusy = false
            end
        end
        Wait(0)
    end
end)

---Listen for death events (death is now the final stage, no laststand stage)
RegisterNetEvent('qbx_medical:client:onPlayerDied', function()
    CreateThread(function()
        Wait(100) -- Small delay to ensure death state is set
        local isDead = exports.qbx_medical:IsDead()
        if isDead then
            local deathTime = exports.qbx_medical:GetDeathTime()
            if deathTime <= 0 then
                deathTime = 300 -- Default if not set
            end
            showDeathUI(deathTime)
        end
    end)
end)

---Set death state (death is now the final stage, no laststand stage)
CreateThread(function()
    local lastUpdate = 0 -- Initialize to 0 so we fetch immediately
    local isFirstCheck = true
    while true do
        local isDead = exports.qbx_medical:IsDead()
        
        -- Only handle death (no laststand stage)
        if isDead then
            -- Always show UI when dead (in case events didn't fire)
            if not isUIVisible then
                local deathTime = exports.qbx_medical:GetDeathTime()
                showDeathUI(deathTime)
            end
            
            -- Fetch doctor count immediately on first death, then every 60 seconds
            local currentTime = GetGameTimer()
            if (currentTime - lastUpdate) > 60000 or isFirstCheck then
                doctorCount = getDoctorCount()
                lastUpdate = currentTime
                isFirstCheck = false
            end
            
            -- Handle animations (use death animation)
            handleDead(cache.ped)

            -- Handle help call key press (H key - control 74)
            -- Enable the control first, then check if pressed
            EnableControlAction(0, 74, true)
            if IsControlJustPressed(0, 74) and not IsPauseMenuActive() then
                handleHelpCall()
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
            
            -- Handle transfer prompt (E key)
            if showTransferPrompt and config.allowTransferToHospital then
                EnableControlAction(0, 38, true) -- E key
                if IsControlJustPressed(0, 38) then
                    showTransferDialog()
                end
            end

            Wait(0)
        else
            if isUIVisible then
                hideDeathUI()
            end
            lastUpdate = 0 -- Reset so we fetch immediately next time
            isFirstCheck = true
            if not IsInHospitalBed then
                LocalPlayer.state.invBusy = false
            end
            Wait(1000)
        end
    end
end)

