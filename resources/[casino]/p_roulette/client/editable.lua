utils.toggleMenu = function(state)
    -- hud export
    SendNUIMessage({
        action = 'ToggleMenu',
        state = state
    })
end