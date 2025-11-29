local bridge = {}

function bridge.registerEvents()
    RegisterNetEvent('playerDropped', function()
        TriggerEvent('racing:server:OnPlayerUnload', source)
    end)
end

function bridge.getFrameworkSettings()
    return {
        buyIns = false, -- Set to true if you implement the money functions.
    }
end

function bridge.isLoggedIn(source) -- realistically this should return true when the getIdentifier function returns a valid identifier.
                                   -- Which for standalone means whenever the player is connected.
    return true
end

function bridge.getIdentifier(source)
    return GetPlayerIdentifierByType(source, 'license2')
end

function bridge.getMoney(source)
    return 999999 -- Implement your own logic here.
end

function bridge.removeMoney(source, amount)
    return true -- Implement your own logic here.
end

function bridge.addMoney(source, amount)
    return true -- Implement your own logic here.
end

return bridge