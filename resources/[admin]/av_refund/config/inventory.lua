Config = Config or {}
Config.Inventory = false -- false it will auto detect your inventory, or set manually your inventory name "qb-inventory", "ox_inventory", etc.
Config.InventoryPath = { -- Where your items images are located
    ['qb-inventory'] = "qb-inventory/html/images/",
    ['ox_inventory'] = "ox_inventory/web/images/",
    ['qs-inventory'] = "qs-inventory/html/images/",
    ['codem-inventory'] = "codem-inventory/html/itemimages/"
}

CreateThread(function()
    if Config.Inventory then return end
    if GetResourceState("ox_inventory") ~= "missing" then
        Config.Inventory = "ox_inventory"
        return
    end
    if GetResourceState("qb-inventory") ~= "missing" then
        Config.Inventory = "qb-inventory"
        return
    end
    if GetResourceState("qs-inventory") ~= "missing" then
        Config.Inventory = "qs-inventory"
        return
    end
    if GetResourceState("codem-inventory") ~= "missing" then
        Config.Inventory = "codem-inventory"
        return
    end
    if not Config.Inventory then
        print("^1[ERROR] We couldn't find a compatible inventory, this resource will just stop working...")
        print("^1[ERROR] We couldn't find a compatible inventory, this resource will just stop working...")
        print("^1[ERROR] We couldn't find a compatible inventory, this resource will just stop working...")
        print("^1[ERROR] We couldn't find a compatible inventory, this resource will just stop working...")
        print("^1[ERROR] We couldn't find a compatible inventory, this resource will just stop working...^7")
    end
end)