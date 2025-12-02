local config = require 'config.client'
local sharedConfig = require 'config.shared'
local WEAPONS = exports.qbx_core:GetWeapons()

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

---remove last stand mode from player.
---NOTE: Laststand is removed, this function does nothing now
function EndLastStand()
    -- Do nothing - laststand is completely removed
    LaststandTime = 0
end

local function logPlayerKiller()
    local killer_2, killerWeapon = NetworkGetEntityKillerOfPlayer(cache.playerId)
    local killer = GetPedSourceOfDeath(cache.ped)

    if killer_2 ~= 0 and killer_2 ~= -1 then
        killer = killer_2
    end

    local killerId = NetworkGetPlayerIndexFromPed(killer)
    local killerName = killerId ~= -1 and (' %s (%d)'):format(GetPlayerName(killerId), GetPlayerServerId(killerId)) or locale('info.self_death')
    local weaponItem = WEAPONS[killerWeapon]
    local weaponLabel = locale('info.wep_unknown') or (weaponItem and weaponItem.label)
    local weaponName = locale('info.wep_unknown') or (weaponItem and weaponItem.name)
    local message = locale('logs.death_log_message', killerName, GetPlayerName(cache.playerId), weaponLabel, weaponName)

    lib.callback.await('qbx_medical:server:log', false, 'playerKiller', message)
end

---count down last stand - laststand is now the final stage (no death transition)
local function countdownLastStand()
    if LaststandTime - 1 > 0 then
        LaststandTime -= 1
    else
        -- Laststand timer ended, but stay in laststand (no transition to death)
        -- Timer will stay at 0, player can still be revived
        LaststandTime = 0
    end
end

local startLastStandLock = false

---put player in last stand mode and notify EMS.
---NOTE: This function now redirects to death immediately (laststand stage removed)
function StartLastStand(attacker, weapon)
    -- Skip laststand completely, go directly to death (final stage)
    if startLastStandLock then return end
    startLastStandLock = true
    
    -- IMMEDIATELY stop any animations before calling OnDeath
    ClearPedTasksImmediately(cache.ped)
    StopAnimTask(cache.ped, 'combat@damage@writhe', 'writhe_loop', 1.0)
    
    -- Immediately call OnDeath instead of starting laststand
    if attacker and weapon then
        OnDeath(attacker, weapon)
    else
        OnDeath()
    end
    
    startLastStandLock = false
end

exports('StartLastStand', StartLastStand)
