local bridge = {}

---@param src number
---@param item string
---@param quantity number
bridge.addItem = function(src, item, quantity)
    exports.ox_inventory:AddItem(src, item, quantity)
end

---@param plate string
bridge.checkVehicleNotOwned = function(plate)
    local result = MySQL.scalar.await('SELECT plate FROM `vehicles` WHERE plate = ?', { plate })
    return (not result)
end

return bridge