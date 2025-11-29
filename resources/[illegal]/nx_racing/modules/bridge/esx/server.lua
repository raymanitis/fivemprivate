local ESX = exports.es_extended:getSharedObject()
local bridge = {}

function bridge.registerEvents()
    RegisterNetEvent('esx:playerDropped', function(playerId, _)
        TriggerServerEvent('racing:server:OnPlayerUnload', playerId)
      end)
end

function bridge.getFrameworkSettings()
    return {
        buyIns = true,
    }
end

function bridge.isLoggedIn(source)
    local ply = ESX.GetPlayerFromId(source)
    if ply then
        return true
    end
    return false
end


function bridge.getIdentifier(source)
    local ply = ESX.GetPlayerFromId(source)

    if ply then
        return ply.identifier
    end

    return nil
end

function bridge.getMoney(source)
    local ply = ESX.GetPlayerFromId(source)

    if ply then
        return ply.getMoney()
    end
    return false
end

function bridge.removeMoney(source, amount)
    local ply = ESX.GetPlayerFromId(source)

    if ply then
        return ply.removeMoney(amount)
    end
    return false
end

function bridge.addMoney(source, amount)
    local ply = ESX.GetPlayerFromId(source)

    if ply then
        return ply.addMoney(amount)
    end
    return false
end

return bridge