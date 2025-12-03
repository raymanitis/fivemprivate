-- Integration with scully_emotemenu for walk styles

RegisterNetEvent('qbx_radialmenu:client:setWalk', function(walkStyle)
    -- Check if scully_emotemenu is running
    if GetResourceState('scully_emotemenu') == 'started' then
        exports.scully_emotemenu:setWalk(walkStyle)
    else
        exports.qbx_core:Notify('Scully Emote Menu is not running!', 'error')
    end
end)

