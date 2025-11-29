local vehicles = exports.qbx_core:GetVehiclesByHash()
local bridge = {}

function bridge.registerEvents()
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        TriggerServerEvent('racing:server:OnPlayerLoaded')
    end)
end

function bridge.getVehicleName(hash)
    local vehicle = vehicles[hash]
    return vehicle and string.format("%s %s", vehicle.brand, vehicle.name) or locale('unknownVehicle')
end

return bridge