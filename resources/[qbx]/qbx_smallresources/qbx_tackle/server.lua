RegisterNetEvent('tackle:server:TacklePlayer', function(target)
    if target == nil then
        return
    end
    local src = source

    local srcCoords = GetEntityCoords(GetPlayerPed(src))
    local targetCoords = GetEntityCoords(GetPlayerPed(target))

    if #(srcCoords - targetCoords) > 2.0 then return end

    TriggerClientEvent('tackle:client:GetTackled', target)
end)
