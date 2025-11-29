local QBCore = exports['qb-core']:GetCoreObject()
local bridge = {}

function bridge.registerEvents()
    AddEventHandler('QBCore:Server:OnPlayerUnload', function(source)
        TriggerEvent('racing:server:OnPlayerUnload', source)
    end)
end

function bridge.getFrameworkSettings()
    return {
        buyIns = true,
    }
end

function bridge.isLoggedIn(source)
    -- return Player(source).state.isLoggedIn
    -- Fuck QB.
    return QBCore.Functions.GetPlayer(source) ~= nil
end

function bridge.getIdentifier(source)
    local ply = QBCore.Functions.GetPlayer(source)

    if ply then
        return ply.PlayerData.citizenid
    end

    return nil
end

function bridge.getMoney(source)
    local ply = QBCore.Functions.GetPlayer(source)

    if ply then
        return ply.PlayerData.money["cash"]
    end
    return false
end

function bridge.removeMoney(source, amount)
    local ply = QBCore.Functions.GetPlayer(source)

    if ply then
        return ply.Functions.RemoveMoney("cash", amount)
    end
    return false
end

function bridge.addMoney(source, amount)
    local ply = QBCore.Functions.GetPlayer(source)

    if ply then
        return ply.Functions.AddMoney("cash", amount)
    end
    return false
end

return bridge