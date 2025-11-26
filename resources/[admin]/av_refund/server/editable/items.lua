function getItems()
    if Config.Inventory == "ox_inventory" then
        return exports['ox_inventory']:Items()
    elseif Config.Inventory == "qs-inventory" or Config.Inventory == "codem-inventory" then
        return exports[Config.Inventory]:GetItemList()
        
    else
        if Core and (Core.Shared and Core.Shared.Items) then
            return Core.Shared.Items
        end
    end
    return false
end