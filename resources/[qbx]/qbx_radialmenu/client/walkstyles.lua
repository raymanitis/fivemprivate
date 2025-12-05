-- Integration with scully_emotemenu for walk styles and animations

-- Open Animations Menu (scully_emotemenu)
RegisterNetEvent('qbx_radialmenu:client:openAnimations', function()
    if GetResourceState('scully_emotemenu') == 'started' then
        ExecuteCommand('emotemenu')
    else
        exports.qbx_core:Notify('Scully Emote Menu is not running!', 'error')
    end
end)

-- Set Walk Style
RegisterNetEvent('qbx_radialmenu:client:setWalk', function(walkStyle)
    if GetResourceState('scully_emotemenu') == 'started' then
        exports.scully_emotemenu:setWalk(walkStyle)
        exports.qbx_core:Notify('Walk style changed!', 'success')
    else
        exports.qbx_core:Notify('Scully Emote Menu is not running!', 'error')
    end
end)

-- Perks Menu
RegisterNetEvent('qbx_radialmenu:client:openPerks', function()
    if GetResourceState('rm-perks') == 'started' then
        TriggerEvent('rm-perks:client:openUI')
        lib.hideRadial()
    else
        exports.qbx_core:Notify('Perks Menu is not available!', 'error')
    end
end)

-- Skills Menu (XP Display)
RegisterNetEvent('qbx_radialmenu:client:openSkills', function()
    local resourceName = nil
    if GetResourceState('rm-xp') == 'started' then
        resourceName = 'rm-xp'
    elseif GetResourceState('pickle_xp') == 'started' then
        resourceName = 'pickle_xp'
    else
        return exports.qbx_core:Notify('Skills Menu is not available!', 'error')
    end
    
    if exports[resourceName] and exports[resourceName].ShowDisplay then
        exports[resourceName]:ShowDisplay()
        lib.hideRadial()
    else
        exports.qbx_core:Notify('Skills Menu is not available!', 'error')
    end
end)

