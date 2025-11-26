Core = nil

CreateThread(function()
    if Config.Inventory ~= "ox_inventory" and GetResourceState('qb-core') == "started" then
        Core = exports['qb-core']:GetCoreObject()
    end
end)