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
    return Player(source).state.isLoggedIn
end

function bridge.getIdentifier(source)
    local ply = exports.qbx_core:GetPlayer(source)

    if ply then
        return ply.PlayerData.citizenid
    end
    return false
end

function bridge.getMoney(source)
    local ply = exports.qbx_core:GetPlayer(source)

    if ply then
        return ply.PlayerData.money["cash"]
    end
    return false
end

function bridge.removeMoney(source, amount)
    local ply = exports.qbx_core:GetPlayer(source)

    if ply then
        return ply.Functions.RemoveMoney("cash", amount)
    end
    return false
end

function bridge.addMoney(source, amount)
    local ply = exports.qbx_core:GetPlayer(source)

    if ply then
        return ply.Functions.AddMoney("cash", amount)
    end
    return false
end

return bridge