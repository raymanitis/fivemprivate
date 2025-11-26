utils.toggleMenu = function(state)
    SendNUIMessage({
        action = 'ToggleMenu',
        state = state
    })
end