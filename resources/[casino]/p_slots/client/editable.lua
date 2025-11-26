utils.toggleMenu = function(state)
    -- you can add export to hide / show hud here
    SendNUIMessage({
        action = 'ToggleMenu',
        state = state
    })
end

utils.checkClose = function() -- it will close ui and leave slot machine if return true
    if LocalPlayer.state.isDead then
        return true
    end

    return false
end

utils.onStart = function() -- this function will execute when player enter slots
end

utils.onExit = function() -- this function will execute when player leave slots
end