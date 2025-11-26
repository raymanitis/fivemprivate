if GetResourceState('qb-core') ~= 'started' or GetResourceState('qbx_core') == 'started' then return end

lib.print.info('Loading QB bridge')

local QBCore = exports['qb-core']:GetCoreObject()

function GetPlayerData()
    return QBCore.Functions.GetPlayerData()
end