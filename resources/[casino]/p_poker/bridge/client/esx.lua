if Config.Framework ~= 'ESX' then
    return
end

local ESX = exports['es_extended']:getSharedObject()

Core.ShowNotification = function(text)
    ESX.ShowNotification(text)
end

Core.GetPlayerChips = function()
    return exports['ox_inventory']:Search('count', 'casino_chips')
end