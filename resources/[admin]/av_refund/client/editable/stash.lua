RegisterNetEvent('av_refund:openStash', function(name)
    dbug("av_refund:openStash", name)
    if Config.Inventory == "ox_inventory" then
        local exists = exports['ox_inventory']:openInventory('stash', name)
        if not exists then
            TriggerEvent("av_refund:notification")
        end
    elseif Config.Inventory == "qb-inventory" then
        TriggerServerEvent("av_refund:openStash", name, {maxweight = 500000, slots = 100, label = Lang['stash_label']})
    elseif Config.Inventory == "codem-inventory" then
        TriggerServerEvent('codem-inventory:server:openstash', name, 100,500000, Lang['stash_label'])
    else
        TriggerEvent("inventory:client:SetCurrentStash", name)
        TriggerServerEvent("inventory:server:OpenInventory", "stash", name, {
            maxweight = 500000,
            slots = 100,
        }, Lang['stash_label'])
    end
end)