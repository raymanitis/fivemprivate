local LoggedIn = false
local isJailed = false
local timeLeft = 0

CreateThread(function()
    lib.zones.sphere({
        coords = Config.JailPosition,
        radius = 10.0,
        debug = false,
        inside = function()
            if isJailed then
                local isDead = LocalPlayer.state?.isDead or false
                if isDead then
                    TriggerServerEvent("al-jail:server:revivePlayer")
                    Wait(1500)
                else
                    Wait(2500)
                end
            else
                Wait(1500)
            end
        end,
        onExit = function()
            if isJailed then
                SetEntityCoords(cache.ped, Config.JailPosition.x, Config.JailPosition.y, Config.JailPosition.z)
                lib.notify({
                    description = "Nice try, tūtiņ...",
                    type = "error",
                    duration = 10000
                })
            end
        end
    })
end)

CreateThread(function()
    repeat Wait(500) until QBX.PlayerData.job ~= nil
    LoggedIn = true
    Wait(1500) -- We wait for character loading processes
    timeLeft, reason, admin = lib.callback.await('al-jail:isJailed')
    if timeLeft ~= 0 then
        isJailed = true
        SetEntityCoords(cache.ped, Config.JailPosition.x, Config.JailPosition.y, Config.JailPosition.z)
        SendNUIMessage({
            action = 'jailed',
            time = timeLeft,
            reason = reason,
            admin = admin
        })
    end
end)

RegisterNetEvent("al-jail:client:sentToJail")
AddEventHandler("al-jail:client:sentToJail", function(reason, time, admin)
    lib.notify({
        description = "You have been jailed for " .. time .. " minutes!",
        type = "error",
        duration = 10000
    })
    SetEntityCoords(cache.ped, Config.JailPosition.x, Config.JailPosition.y, Config.JailPosition.z)
    isJailed = true
    timeLeft = time
    SendNUIMessage({
        action = 'jailed',
        time = timeLeft,
        reason = reason,
        admin = admin
    })
end)

RegisterNetEvent("al-jail:client:unjailed")
AddEventHandler("al-jail:client:unjailed", function()
    lib.notify({
        description = "You have been unjailed! Congratulations!",
        type = "success",
        duration = 10000
    })
    SetEntityCoords(cache.ped, Config.UnjailPosition.x, Config.UnjailPosition.y, Config.UnjailPosition.z)
    isJailed = false
    timeLeft = 0
    SendNUIMessage({
        action = 'unjailed',
    })
end)

RegisterNetEvent("al-jail:client:updateCounter")
AddEventHandler("al-jail:client:updateCounter", function(time)
    timeLeft = time
    SendNUIMessage({
        action = 'updateTime',
        time = timeLeft
    })
end)

RegisterCommand("jailnui", function()
    SetNuiFocus(not IsNuiFocused(), not IsNuiFocused())
end)

RegisterNUICallback('toggleNui', function(data, cb)
    SetNuiFocus(data.toggle, data.toggle)
    cb(true)
end)

local paused = false
RegisterNUICallback('toggleTime', function(data, cb)
    if data.pause and not paused then
        TriggerServerEvent("al-jails:pausedTimeToggle", data.pause)
        paused = data.pause
    elseif not data.pause and paused then
        TriggerServerEvent("al-jails:pausedTimeToggle", data.pause)
        paused = data.pause
    end
    cb(true)
end)