if Config.Framework ~= 'QB' then
    return
end

local QBCore = exports['qb-core']:GetCoreObject()

Core.ShowNotification = function(text)
    QBCore.Functions.Notify(text)
end

Core.GetPlayerChips = function()
    return exports['ox_inventory']:Search('count', 'casino_chips')
end