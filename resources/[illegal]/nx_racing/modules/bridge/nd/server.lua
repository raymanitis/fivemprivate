local ND_Core = exports.ND_Core
local bridge = {}

function bridge.registerEvents()
    AddEventHandler("ND:characterUnloaded", function(source, _)
        TriggerServerEvent('racing:server:OnPlayerUnload', source)
    end)
end

function bridge.getFrameworkSettings()
    return {
        buyIns = true,
    }
end

function bridge.isLoggedIn(source)
    local ply = ND_Core:getPlayer(source)
    if ply then
        return true
    end
    return false
end

function bridge.getIdentifier(source)
    local ply = ND_Core:getPlayer(source)

    if ply then
        return ply.getData('identifier')
    end

    return nil
end

function bridge.getMoney(source)
    local ply = ND_Core:getPlayer(source)
    local money = plygetData("cash")

    if money then
        return money
    end
    return false
end

function bridge.removeMoney(source, amount)
    local ply = ND_Core:getPlayer(source)

    if ply then
        return ply.deductMoney("cash", amount, "Buy-In")
    end
    return false
end

function bridge.addMoney(source, amount)
    local ply = ND_Core:getPlayer(source)

    if ply then
        return ply.addMoney("cash", amount, "Race winnings")
    end
    return false
end


return bridge