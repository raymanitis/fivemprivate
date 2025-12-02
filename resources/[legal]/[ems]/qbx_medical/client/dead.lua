local config = require 'config.client'
local sharedConfig = require 'config.shared'
local WEAPONS = exports.qbx_core:GetWeapons()
local allowRespawn = true

---blocks until ped is no longer moving
function WaitForPlayerToStopMoving()
    local timeOut = 10000
    while GetEntitySpeed(cache.ped) > 0.1 and IsPedRagdoll(cache.ped) and timeOut > 1 do
        timeOut -= 10 Wait(10)
    end
end

--- low level GTA resurrection
function ResurrectPlayer()
    local pos = GetEntityCoords(cache.ped)
    local heading = GetEntityHeading(cache.ped)

    NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z + 0.5, heading, true, false)
    if cache.vehicle then
        SetPedIntoVehicle(cache.ped, cache.vehicle, cache.seat)
    end
end

local function playDeadAnimation()
    -- Stop ALL animations first
    ClearPedTasksImmediately(cache.ped)
    
    local deadAnimDict = 'dead'
    local playerData = QBX.PlayerData
    local metadata = playerData and playerData.metadata
    local deadAnim = metadata and metadata.ishandcuffed and 'dead_f' or 'dead_a'

    local deadVehAnimDict = 'veh@low@front_ps@idle_duck'
    local deadVehAnim = 'sit'

<<<<<<< HEAD
    -- Request animation dictionary
    lib.requestAnimDict(deadAnimDict, 5000)
    lib.requestAnimDict(deadVehAnimDict, 5000)
=======
    -- Request animation dictionary (wait for it to load)
    lib.requestAnimDict(deadAnimDict, 5000)
    lib.requestAnimDict(deadVehAnimDict, 5000)
    
    -- Wait a moment for dictionaries to load
    Wait(100)
>>>>>>> parent of aef42f2 (ems)

    if cache.vehicle then
        -- Stop any existing animation
        StopAnimTask(cache.ped, deadVehAnimDict, deadVehAnim, 0.0)
        -- Play vehicle death animation
        TaskPlayAnim(cache.ped, deadVehAnimDict, deadVehAnim, 1.0, 1.0, -1, 1, 0, false, false, false)
    else
        -- Stop any existing animation
        StopAnimTask(cache.ped, deadAnimDict, deadAnim, 0.0)
        -- Force play death animation
        TaskPlayAnim(cache.ped, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, false, false, false)
    end
end

exports('PlayDeadAnimation', playDeadAnimation)

---put player in death animation and make invincible
function OnDeath(attacker, weapon)
    -- Initialize death time if not set
    if DeathTime <= 0 then
        DeathTime = config.deathTime
    end
    
    -- Force DEAD state immediately - no laststand
    SetDeathState(sharedConfig.deathState.DEAD)
    
    -- AGGRESSIVELY stop ALL animations immediately
    ClearPedTasksImmediately(cache.ped)
    StopAnimTask(cache.ped, 'combat@damage@writhe', 'writhe_loop', 0.0)
    ClearPedSecondaryTask(cache.ped)
    RemoveAnimDict('combat@damage@writhe')
    
    -- Trigger events immediately
    TriggerEvent('qbx_medical:client:onPlayerDied', attacker, weapon)
    TriggerServerEvent('qbx_medical:server:onPlayerDied', attacker, weapon)
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'demo', 0.1)

    -- Wait for player to stop moving
    WaitForPlayerToStopMoving()

<<<<<<< HEAD
=======
    LocalPlayer.state.invBusy = true

    -- Resurrect and setup death state FIRST
    ResurrectPlayer()
    SetEntityInvincible(cache.ped, true)
    SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
    
    -- Wait a moment for resurrection to complete
    Wait(100)
    
    -- Force death animation immediately after resurrection
    playDeadAnimation()
    Wait(200) -- Wait for animation to start
    playDeadAnimation() -- Play again to ensure it's active
    
>>>>>>> parent of aef42f2 (ems)
    -- Start control disabling thread
    CreateThread(function()
        while DeathState == sharedConfig.deathState.DEAD do
            DisableControls()
            SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
            -- Continuously stop any laststand animations that might try to play
            if IsEntityPlayingAnim(cache.ped, 'combat@damage@writhe', 'writhe_loop', 3) then
                StopAnimTask(cache.ped, 'combat@damage@writhe', 'writhe_loop', 1.0)
                ClearPedTasksImmediately(cache.ped)
            end
            Wait(0)
        end
    end)
    
<<<<<<< HEAD
    LocalPlayer.state.invBusy = true

    -- Resurrect and setup death state
    ResurrectPlayer()
    SetEntityInvincible(cache.ped, true)
    SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
    
    -- Force death animation immediately - play it multiple times to ensure it sticks
    playDeadAnimation()
    Wait(50)
    playDeadAnimation() -- Play again to ensure it's active
    Wait(50)
    playDeadAnimation() -- Play one more time
=======
    -- Continuously play death animation to ensure it stays active
    CreateThread(function()
        local deadAnimDict = 'dead'
        local playerData = QBX.PlayerData
        local metadata = playerData and playerData.metadata
        local deadAnim = metadata and metadata.ishandcuffed and 'dead_f' or 'dead_a'
        
        lib.requestAnimDict(deadAnimDict, 5000)
        
        while DeathState == sharedConfig.deathState.DEAD do
            -- Continuously ensure death animation is playing
            if not IsEntityPlayingAnim(cache.ped, deadAnimDict, deadAnim, 3) then
                TaskPlayAnim(cache.ped, deadAnimDict, deadAnim, 1.0, 1.0, -1, 1, 0, false, false, false)
            end
            Wait(100) -- Check every 100ms
        end
    end)
>>>>>>> parent of aef42f2 (ems)
    
    -- Start respawn check
    CheckForRespawn()
end

exports('KillPlayer', OnDeath)

local function respawn()
    local success = lib.callback.await('qbx_medical:server:respawn')
    if not success then return end
<<<<<<< HEAD
=======
    
    -- Reset death state and lock
    SetDeathState(sharedConfig.deathState.ALIVE)
    ResetDeathLock()
    
>>>>>>> parent of aef42f2 (ems)
    if QBX.PlayerData.metadata.ishandcuffed then
        TriggerEvent('police:client:GetCuffed', -1)
    end
    TriggerEvent('police:client:DeEscort')
    LocalPlayer.state.invBusy = false
end

---Allow player to respawn
function CheckForRespawn()
    RespawnHoldTime = 5
    while DeathState == sharedConfig.deathState.DEAD do
        if IsControlPressed(0, 38) and RespawnHoldTime <= 1 and allowRespawn then
            respawn()
            return
        end
        if IsControlPressed(0, 38) then
            RespawnHoldTime -= 1
        end
        if IsControlReleased(0, 38) then
            RespawnHoldTime = 5
        end
        if RespawnHoldTime <= 0 then
            RespawnHoldTime = 0
        end
        DeathTime -= 1
        if DeathTime <= 0 and allowRespawn then
            respawn()
            return
        end
        Wait(1000)
    end
end

function AllowRespawn()
    allowRespawn = true
end

exports('AllowRespawn', AllowRespawn)

exports('DisableRespawn', function()
    allowRespawn = false
end)

---log the death of a player along with the attacker and the weapon used.
---@param victim number ped
---@param attacker number ped
---@param weapon string weapon hash
local function logDeath(victim, attacker, weapon)
    local playerId = NetworkGetPlayerIndexFromPed(victim)
    local playerName = (' %s (%d)'):format(GetPlayerName(playerId), GetPlayerServerId(playerId)) or locale('info.self_death')
    local killerId = NetworkGetPlayerIndexFromPed(attacker)
    local killerName = ('%s (%d)'):format(GetPlayerName(killerId), GetPlayerServerId(killerId)) or locale('info.self_death')
    local weaponItem = WEAPONS[weapon]
    local weaponLabel = (weaponItem and weaponItem.label) or 'Unknown'
    local weaponName = (weaponItem and weaponItem.name) or 'Unknown'
    local message = locale('logs.death_log_message', killerName, playerName, weaponLabel, weaponName)

    lib.callback.await('qbx_medical:server:log', false, 'logDeath', message)
end

---Monitor health and trigger death immediately when health reaches 0 (skip laststand)
CreateThread(function()
    local deathTriggered = false
    while true do
        Wait(0) -- Check every frame for INSTANT response
        local currentHealth = GetEntityHealth(cache.ped)
        local isDead = IsEntityDead(cache.ped)
        
        -- If health dropped to 0 or below and we're NOT dead, trigger death IMMEDIATELY
        if DeathState ~= sharedConfig.deathState.DEAD and (currentHealth <= 0 or isDead) then
            if not deathTriggered then
                deathTriggered = true
                -- IMMEDIATELY stop ALL animations before anything else
                ClearPedTasksImmediately(cache.ped)
                StopAnimTask(cache.ped, 'combat@damage@writhe', 'writhe_loop', 0.0)
                -- Initialize death time FIRST
                DeathTime = config.deathTime
                -- Force DEAD state immediately
                SetDeathState(sharedConfig.deathState.DEAD)
                -- Then call OnDeath
                OnDeath()
            end
        elseif DeathState == sharedConfig.deathState.DEAD then
            -- Keep flag true when dead
            deathTriggered = true
        else
            -- Reset flag when alive
            deathTriggered = false
        end
    end
end)

---when player is killed by another player, go directly to death (skip laststand)
---@param event string
---@param data table
AddEventHandler('gameEventTriggered', function(event, data)
    if event ~= 'CEventNetworkEntityDamage' then return end
    local victim, attacker, victimDied, weapon = data[1], data[2], data[4], data[7]
    if not IsEntityAPed(victim) or not victimDied or NetworkGetPlayerIndexFromPed(victim) ~= cache.playerId or not IsEntityDead(cache.ped) then return end
    
<<<<<<< HEAD
    -- IMMEDIATELY stop all animations and force death
    ClearPedTasksImmediately(cache.ped)
    StopAnimTask(cache.ped, 'combat@damage@writhe', 'writhe_loop', 1.0)
    
    -- Always go directly to death - no laststand check needed
=======
    -- Stop all animations and force death
    ClearPedTasksImmediately(cache.ped)
    StopAnimTask(cache.ped, 'combat@damage@writhe', 'writhe_loop', 1.0)
    
    -- Go directly to death
>>>>>>> parent of aef42f2 (ems)
    if DeathState ~= sharedConfig.deathState.DEAD then
        OnDeath(attacker, weapon)
    end
end)

function DisableControls()
    DisableAllControlActions(0)
    EnableControlAction(0, 1, true)
    EnableControlAction(0, 2, true)
    EnableControlAction(0, 245, true)
    EnableControlAction(0, 38, true)
    EnableControlAction(0, 0, true)
    EnableControlAction(0, 322, true)
    EnableControlAction(0, 288, true)
    EnableControlAction(0, 213, true)
    EnableControlAction(0, 249, true)
    EnableControlAction(0, 46, true)
    EnableControlAction(0, 47, true)
end