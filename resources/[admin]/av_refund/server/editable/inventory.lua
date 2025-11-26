local itemList = false

CreateThread(function()
    while not Config.Inventory do Wait(0) end
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:registerHook('swapItems', function(payload)
            local to = payload['toInventory']
            if to and string.find(to, "itemsrefund") then
                return false
            end
            return true
        end)
    end
    if Config.Inventory == "codem-inventory" or Config.Inventory == "qs-inventory" then
        itemList = exports[Config.Inventory ]:GetItemList()
    end
end)

RegisterServerEvent('av_refund:openStash', function(name,data)
    dbug("av_refund:openStash", name)
    local src = source
    exports[Config.Inventory]:OpenInventory(src, name, data)
end)

function registerStash(name,slots,weight)
    if Config.Inventory == "ox_inventory" then
        exports['ox_inventory']:RegisterStash(name, "Refund System", slots, weight)
        return
    end
    if Config.Inventory == "qb-inventory" then
        local data = {
            label = "Refund System",
            maxweight = weight,
            slots = slots
        }
        exports['qb-inventory']:registerInventory(name, data)
        return
    end
end

function getItemInfo(name)
    dbug("getItemInfo()", name)
    if itemList and itemList[name] then
        return itemList[name]
    end
    if Config.Inventory == "ox_inventory" then
        return exports['ox_inventory']:Items(name)
    else
        if Core.Shared and Core.Shared.Items then
            return Core.Shared.Items[name] or false
        end
    end
    return false
end

function addToStash(name, item, count, metadata, slot)
    dbug("addToStash(name, item, count, metadata, slot)") 
    dbug(name, item, count, metadata, slot)
    local metadata = metadata or {}
    for field, value in pairs(metadata) do
        if value and tonumber(value) then
            value = tonumber(value)
            metadata[field] = value
        end
    end
    if Config.Inventory == "qs-inventory" then
        return exports[Config.Inventory]:AddItemIntoStash(name, item, count, slot, metadata)
    end
    if Config.Inventory == "ox_inventory" then
        local success, response = exports['ox_inventory']:AddItem(name, item, count, metadata, slot)
        return success
    end
    if Config.Inventory == "qb-inventory" then
        local res = exports[Config.Inventory]:AddItem(name, item, count, slot, metadata, false)
        return res
    end
    if Config.Inventory == "codem-inventory" then
        local stash_items = exports['codem-inventory']:GetStashItems(name)
        stash_items = stash_items or {}
        if stash_items then
            local slot = countItems(stash_items)
            local itemInfo = itemList[item] or {}
            stash_items[tostring(slot)] = {
                name = itemInfo.name or item,
                label = itemInfo.label or exports['codem-inventory']:GetItemLabel(item),
                image = itemInfo.image or "",
                weight = itemInfo.weight or 0,
                type = itemInfo.type or 'item',
                amount = count,
                description = itemInfo.description or '',
                slot = slot and tostring(slot) or "1",
                info = metadata or {},
                unique = itemInfo.unique or true,
                useable = itemInfo.useable or false,
                shouldClose = itemInfo.shouldClose or false
            }
            exports['codem-inventory']:UpdateStash(name, stash_items)
            return true
        end
        return false
    end
end

function countItems(stash)
    local count = 0
    for _, _ in pairs(stash) do
        count = count + 1
    end
    return count > 0 and count + 1 or 1
end
