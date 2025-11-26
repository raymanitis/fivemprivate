if GetResourceState('qbx_core') ~= 'started' then return end

function GetPlayer(source)
    return exports.qbx_core:GetPlayer(source)
end