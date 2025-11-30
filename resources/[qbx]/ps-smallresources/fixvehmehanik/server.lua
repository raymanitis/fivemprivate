local Config = require 'fixvehmehanik/config'
local QBCore = GetResourceState('qb-core') == 'started' and exports['qb-core']:GetCoreObject()
local ESX = GetResourceState('es_extended') == 'started' and exports.es_extended:getSharedObject()

local function PlayerName(src)
    if QBCore then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player and Player.PlayerData and Player.PlayerData.charinfo then
            return (Player.PlayerData.charinfo.firstname or '') .. ' ' .. (Player.PlayerData.charinfo.lastname or '')
        end
    elseif ESX then
        local Player = ESX.GetPlayerFromId(src)
        if Player and Player.get then
            local first = Player.get('firstName') or Player.get('firstname') or ''
            local last = Player.get('lastName') or Player.get('lastname') or ''
            return (first .. ' ' .. last):gsub('^%s*(.-)%s*$', '%1')
        end
    end
    return GetPlayerName(src)
end

local function playerCanPay(src, price)
    local moneytype = 'bank'
    local bank, cash = 0, 0
    if QBCore then
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return false end
        bank = Player.PlayerData.money.bank or 0
        cash = Player.PlayerData.money.cash or 0
    elseif ESX then
        local Player = ESX.GetPlayerFromId(src)
        if not Player then return false end
        bank = Player.getAccount('bank') and Player.getAccount('bank').money or 0
        cash = Player.getAccount('money') and Player.getAccount('money').money or 0
    end
    if (Config.Settings.useBankFirst and bank >= price) or (not Config.Settings.useBankFirst and cash >= price) then
        return true, Config.Settings.useBankFirst and 'bank' or 'money'
    end
    if bank >= price then return true, 'bank' end
    if cash >= price then return true, 'money' end
    return false, 'money'
end

local function removeMoney(src, amount, moneytype)
    if QBCore then
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return false end
        Player.Functions.RemoveMoney(moneytype, amount)
        return true
    elseif ESX then
        local Player = ESX.GetPlayerFromId(src)
        if not Player then return false end
        if moneytype == 'money' then
            Player.removeMoney(amount)
        else
            Player.removeAccountMoney('bank', amount)
        end
        return true
    end
    return false
end

local function addOrganizationMoney(orgName, amount)
    if not orgName or amount <= 0 then return end
    if GetResourceState('Renewed-Banking') == 'started' and exports['Renewed-Banking'] then
        exports['Renewed-Banking']:addAccountMoney(orgName, amount)
    elseif QBCore and exports['qbx_management'] then
        exports['qbx_management']:AddMoney(orgName, amount)
    elseif ESX and exports['esx_society'] then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..orgName, function(account)
            if account then account.addMoney(amount) end
        end)
    end
end

RegisterNetEvent('fixvehmehanik:server:payAndRepair', function(zoneId, netVeh)
    local src = source
    local zoneCfg = Config.MechanicLocations[zoneId]
    if not zoneCfg then return end

    -- Validate distance server-side
    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)
    if #(pedCoords - zoneCfg.coords) > (zoneCfg.radius or 10.0) + 5.0 then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Too far from repair zone.' })
        return
    end

    local canPay, moneytype = playerCanPay(src, zoneCfg.price)
    if not canPay then
        TriggerClientEvent('fixvehmehanik:client:repairDenied', src, netVeh)
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Not enough money.' })
        return
    end

    if not removeMoney(src, zoneCfg.price, moneytype) then
        TriggerClientEvent('fixvehmehanik:client:repairDenied', src, netVeh)
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Payment failed.' })
        return
    end

    addOrganizationMoney(zoneCfg.organization, zoneCfg.price)

    TriggerClientEvent('fixvehmehanik:client:finishRepair', src, netVeh)
    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = ('Paid $%s (%s) for repair.'):format(zoneCfg.price, moneytype) })
end)


