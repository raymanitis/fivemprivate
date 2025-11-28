-- Death reasons
-- https://docs.fivem.net/docs/game-references/weapon-models/
local Config = require 'logs/config'
local deathHashTable = Config.fivemDeathHashTable

local function processDeath(ped)
    local killerPed = GetPedSourceOfDeath(ped)
    local causeHash = GetPedCauseOfDeath(ped)
    local killer = false
    print(("Death cause: %s / 0x%x"):format(causeHash, causeHash))

    if killerPed == ped then
        killer = false
    else
        if IsEntityAPed(killerPed) and IsPedAPlayer(killerPed) then
            killer = NetworkGetPlayerIndexFromPed(killerPed)
        elseif IsEntityAVehicle(killerPed) then
            local drivingPed = GetPedInVehicleSeat(killerPed, -1)
            if IsEntityAPed(drivingPed) == 1 and IsPedAPlayer(drivingPed) then
                killer = NetworkGetPlayerIndexFromPed(drivingPed)
            end
        end
    end

    local deathReason = deathHashTable[causeHash] or 'unknown'

    if not killer then
        if deathReason ~= "unknown" then
            deathReason = "suicide (" .. deathReason .. ")"
        else
            deathReason = "suicide"
        end
    else
        killer = GetPlayerServerId(killer)
    end

    TriggerServerEvent('ray-smallres:deathlogs:log', killer, deathReason)
end

--[[ Thread ]]--
local deathFlag = false
local IsEntityDead = IsEntityDead
CreateThread(function()
    while true do
        Wait(500)
        local ped = cache.ped
        local isDead = IsEntityDead(ped)
        if isDead and not deathFlag then
            deathFlag = true
            processDeath(ped)
        elseif not isDead then
            deathFlag = false
        end
    end
end)
