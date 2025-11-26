local playerState = LocalPlayer.state

StatData = {
    open = false,
    health = 0,
    armor = 0,
    hunger = 0,
    thirst = 0,
    stress = playerState.stress or 0,
    stamina = 0,
    talking = false,
    voiceProximity = playerState.proximity.distance
}

RegisterNetEvent('hud:client:UpdateStress', function(newStress)
    StatData.stress = newStress
end)

AddStateBagChangeHandler('stress', ('player:%s'):format(cache.serverId), function(_, _, value)
    StatData.stress = value
    lib.print.debug(('Setting stress to %s'):format(value))
end)

AddStateBagChangeHandler('proximity', ('player:%s'):format(cache.serverId), function(_, _, value)
    StatData.voiceProximity = value.distance
    lib.print.debug(('Setting voiceProximity to %s'):format(value))
end)