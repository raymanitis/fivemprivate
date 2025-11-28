lib.addKeybind({
    name = 'tackle',
    description = 'Tackle',
    defaultKey = 'E',
    onReleased = function(self)
        if cache.vehicle then return end
        if QBX.PlayerData.metadata.ishandcuffed then return end
        if IsPedSprinting(cache.ped) then
            local coords = GetEntityCoords(cache.ped)
            local targetId, targetPed, _ = lib.getClosestPlayer(coords, 2.0, false)
            if not targetPed then return end
            self:disable(true)
            if math.random(1, 100) <= 65 then -- 65% chance to tackle someone 
                TriggerServerEvent('tackle:server:TacklePlayer', GetPlayerServerId(targetId))
            end
            SetPedToRagdoll(cache.ped, 250, 250, 0, 0, 0, 0)
            SetTimeout(5500, function ()
                self:disable(false)
            end)
        end
    end
})

RegisterNetEvent('tackle:client:GetTackled', function()
    local tackleTime = math.random(1500, 2500)
    SetPedToRagdoll(cache.ped, tackleTime, tackleTime, 0, 0, 0, 0)
end)