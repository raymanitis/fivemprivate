local triggered = false
AddEventHandler("playerSpawned", function()
    if not triggered then
        triggered = true
        Wait(1000 * 20)
        TriggerServerEvent('rm-perms:PlayerLoaded')
    end
end)