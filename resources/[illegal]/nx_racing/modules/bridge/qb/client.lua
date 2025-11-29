local QBCore = exports['qb-core']:GetCoreObject()
local vehicles = QBCore.Shared.Vehicles
local bridge = {}

function bridge.registerEvents()
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        TriggerServerEvent('racing:server:OnPlayerLoaded')
    end)
end

function bridge.getVehicleName(hash)
    local veh = string.lower(GetDisplayNameFromVehicleModel(hash))
    if not veh or not vehicles[veh] then
        return locale('unknownVehicle')
    end
    local vehicle = vehicles[veh]
    return vehicle and string.format("%s %s", vehicle.brand, vehicle.name) or locale('unknownVehicle')
end

return bridge