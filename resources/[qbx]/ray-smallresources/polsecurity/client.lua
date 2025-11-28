local isSecurityActive = GlobalState.dx_security or false

RegisterNetEvent('dx_resource:securtySystem')
AddEventHandler('dx_resource:securtySystem', function(Security)
    isSecurityActive = Security and true or false
end)

AddStateBagChangeHandler('dx_security', 'global', function(bagName, key, value)
    isSecurityActive = value and true or false
end)

exports('isSecurityActive', function()
    return isSecurityActive
end)