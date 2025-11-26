if Config.Framework ~= 'QB' then
    return
end

Core.ShowNotification = function(playerId, text, type)
    TriggerClientEvent('QBCore:Notify', playerId, text, type or 'info')
end

Core.GetPlayerChips = function(playerId)
    return exports['ox_inventory']:Search(playerId, 'count', 'casino_chips')
end

Core.AddPlayerChips = function(playerId, amount)
    exports['ox_inventory']:AddItem(playerId, 'casino_chips', amount)
end

Core.RemovePlayerChips = function(playerId, amount)
    exports['ox_inventory']:RemoveItem(playerId, 'casino_chips', amount)
end