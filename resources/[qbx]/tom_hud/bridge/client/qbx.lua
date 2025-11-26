if GetResourceState('qbx_core') ~= 'started' then return end

lib.print.info('Loading QBX bridge')

function GetPlayerData()
    return exports.qbx_core:GetPlayerData()
end