local bridge = {}
local QBCore = exports['qb-core']:GetCoreObject()

---@param src number
---@param item string
---@param quantity number
bridge.addItem = function(src, item, quantity)
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, quantity)
end

---@param plate string
bridge.checkVehicleNotOwned = function(plate)
    local result = MySQL.scalar.await('SELECT plate FROM `player_vehicles` WHERE plate = ?', { plate })
    return (not result)
end

return bridge