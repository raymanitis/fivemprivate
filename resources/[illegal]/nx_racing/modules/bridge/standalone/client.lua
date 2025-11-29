local bridge = {}

function bridge.registerEvents()
    RegisterNetEvent('playerSpawned', function()
        TriggerServerEvent('racing:server:OnPlayerLoaded')
    end)
end

function bridge.getVehicleName(hash)
    local displayName = GetDisplayNameFromVehicleModel(hash)
    if displayName == 'CARNOTFOUND' then
        return locale('unknownVehicle')
    end
    local vehicleName = GetLabelText(displayName)
    return vehicleName or locale('unknownVehicle')
end

return bridge