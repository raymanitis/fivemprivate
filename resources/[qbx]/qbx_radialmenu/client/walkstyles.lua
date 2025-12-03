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

-- Perks Menu (placeholder - customize to your needs)
RegisterNetEvent('qbx_radialmenu:client:openPerks', function()
    exports.qbx_core:Notify('Perks Menu - Coming Soon!', 'info')
    -- Add your perks menu logic here
    -- Example: TriggerEvent('your_perks_script:openMenu')
end)

-- Skill Tree (placeholder - customize to your needs)
RegisterNetEvent('qbx_radialmenu:client:openSkillTree', function()
    exports.qbx_core:Notify('Skill Tree - Coming Soon!', 'info')
    -- Add your skill tree logic here
    -- Example: TriggerEvent('your_skill_script:openTree')
end)

