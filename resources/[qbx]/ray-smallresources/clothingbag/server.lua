QBCore = exports['qb-core']:GetCoreObject()

-- Make the clothing bag usable
QBCore.Functions.CreateUseableItem("clothing_bag", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) then
        TriggerClientEvent('mt-clothingbag:client:openBag', source)
    end
end)
