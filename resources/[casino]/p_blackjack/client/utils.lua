utils = {}

utils.toggleMenu = function(state)
    -- export hud
    LocalPlayer.state.invBusy = state
    LocalPlayer.state.invHotkeys = not state
    SendNUIMessage({
        action = 'ToggleMenu',
        state = state
    })
end

utils.setupMenu = function()
    SendNUIMessage({action = 'setupMenu'})
end

utils.updateMenu = function(field, value)
    SendNUIMessage({
        action = 'UpdateMenu',
        field = field,
        value = value
    })
end