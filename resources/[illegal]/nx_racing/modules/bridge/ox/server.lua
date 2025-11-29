local Ox = require '@ox_core.lib.init'
local bridge = {}

function bridge.registerEvents()
    RegisterNetEvent('ox:playerLogout', function(playerId, _, _)
        TriggerServerEvent('racing:server:OnPlayerUnload', playerId)
    end)
end

function bridge.getFrameworkSettings()
    return {
        buyIns = true,
    }
end

function bridge.isLoggedIn(source)
    local ply = Ox.GetPlayer(source)
    if ply then
        return true
    end
    return false
end


function bridge.getIdentifier(source)
    local ply = Ox.GetPlayer(source)

    if ply then
        return ply.stateId
    end

    return nil
end

function bridge.getMoney(source)
    local money = exports.ox_inventory:Search(source, 'count', 'cash')

    if money then
        return money.count
    end
    return false
end

function bridge.removeMoney(source, amount)
    return exports.ox_inventory:RemoveItem(source, 'cash', amount)
end

function bridge.addMoney(source, amount)
    return exports.ox_inventory:AddItem(source, 'cash', amount)
end

return bridge