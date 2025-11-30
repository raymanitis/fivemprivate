local bridge = {}
local ESX = exports['es_extended']:getSharedObject()

---@param src number
---@param item string
---@param quantity number
bridge.addItem = function(src, item, quantity)
    local Player = ESX.GetPlayerFromId(src)
    Player.addInventoryItem(item, quantity)
end

---@param plate string
bridge.checkVehicleNotOwned = function(plate)
    local result = MySQL.scalar.await('SELECT plate FROM `owned_vehicles` WHERE plate = ?', { plate })
    return (not result)
end

return bridge