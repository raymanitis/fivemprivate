local Config = require 'bbusiegade/config'
local QBCore = GetResourceState('qb-core') == 'started' and exports['qb-core']:GetCoreObject()
local ESX = GetResourceState('es_extended') == 'started' and exports.es_extended:getSharedObject()
local usingQboxCore = GetResourceState('qbx_core') == 'started'

local function isPoliceJob(jobName)
    if not jobName then return false end

    local jobsConfig = Config.PoliceJobs
    if type(jobsConfig) == 'table' then
        if jobsConfig[jobName] then
            return true
        end

        for _, job in ipairs(jobsConfig) do
            if job == jobName then
                return true
            end
        end
    elseif type(jobsConfig) == 'string' then
        return jobsConfig == jobName
    end

    return jobsConfig == nil and jobName == 'police'
end

local function isJobOnDuty(job)
    if not Config.RequirePoliceOnDuty then
        return true
    end

    if not job then
        return false
    end

    if job.onduty == nil then
        return true
    end

    return job.onduty == true
end

local function getOnlinePoliceCount()
    if usingQboxCore then
        local cops = 0
        local players = exports.qbx_core:GetQBPlayers() or {}

        for _, player in pairs(players) do
            local playerData = player and player.PlayerData
            local job = playerData and playerData.job
            if job and isPoliceJob(job.name) and isJobOnDuty(job) then
                cops = cops + 1
            end
        end

        return cops
    end

    if QBCore and QBCore.Functions and QBCore.Functions.GetQBPlayers then
        local cops = 0
        local players = QBCore.Functions.GetQBPlayers() or {}

        for _, player in pairs(players) do
            if player and player.PlayerData then
                local job = player.PlayerData.job
                if job and isPoliceJob(job.name) and isJobOnDuty(job) then
                    cops = cops + 1
                end
            end
        end

        return cops
    end

    if ESX and ESX.GetPlayers then
        local cops = 0
        local players = ESX.GetPlayers() or {}

        for _, playerId in ipairs(players) do
            local player = ESX.GetPlayerFromId(playerId)
            if player then
                local job = (player.getJob and player.getJob()) or player.job or {}
                local jobName = job and job.name

                if isPoliceJob(jobName) and isJobOnDuty(job) then
                    cops = cops + 1
                end
            end
        end

        return cops
    end

    return 0
end

-- Function to retrieve player name
local function PlayerName(src)
    if QBCore then 
        local Player = QBCore.Functions.GetPlayer(src)
        return Player and (Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname) or GetPlayerName(src)
    elseif ESX then 
        local Player = ESX.GetPlayerFromId(src)
        if Player and Player.get then
            local firstName = Player.get('firstName') or Player.get('firstname')
            local lastName = Player.get('lastName') or Player.get('lastname')
            if firstName or lastName then
                return (firstName or '')..' '..(lastName or '')
            end
        end
        return GetPlayerName(src)
    else
        return GetPlayerName(src)
    end
end

-- Give Vehicle Keys
RegisterNetEvent('bbusiegade:server:GiveVehicleKey', function(plate)
    local src = source
    local player_name = PlayerName(src)
    -- Give keys to player for the vehicle
    local success = exports['Renewed-Vehiclekeys']:addKey(src, plate)
    
    if success then
        print(('Successfully gave keys for bus [%s] to player [%s]'):format(plate, src))
    else
        print(('Failed to give keys for bus [%s] to player [%s]'):format(plate, src))
    end
    
    -- Notify player
    TriggerClientEvent('ox_lib:notify', src, {
        id = 'key_success',
        description = 'Bus keys have been given to you',
        position = 'top-right',
        icon = 'key',
        iconColor = 'green'
    })
end)

RegisterNetEvent('bbusiegade:server:PurchaseBus', function(vehiclename, price, location)
    local src = source
    local player_name = PlayerName(src)
    local price = tonumber(price)

    if not price then
        TriggerClientEvent('ox_lib:notify', src, {
            id = 'bus_invalid_price',
            title = 'Purchase Error',
            description = 'Unable to process purchase: invalid price configured.',
            position = 'top-right',
            icon = 'triangle-exclamation',
            iconColor = '#C53030'
        })
        return
    end

    local requiredCops = tonumber(Config.RequiredCops) or 0
    if requiredCops > 0 then
        local copsOnline = getOnlinePoliceCount()
        if copsOnline < requiredCops then
            TriggerClientEvent('ox_lib:notify', src, {
                id = 'bus_not_enough_police',
                title = 'Purchase Unavailable',
                description = 'Not enough police are on duty to purchase this vehicle right now.',
                position = 'top-right',
                icon = 'shield-halved',
                iconColor = '#C53030'
            })
            return
        end
    end

    local hasBlackMoney = false
    local blackMoneyAmount = 0

    -- Check if player has black_money item
    if QBCore then 
        local Player = QBCore.Functions.GetPlayer(src)
        local blackMoneyItem = Player.Functions.GetItemByName('black_money')
        if blackMoneyItem then
            hasBlackMoney = true
            blackMoneyAmount = blackMoneyItem.amount
        end
    elseif ESX then 
        local Player = ESX.GetPlayerFromId(src)
        local blackMoneyItem = Player.getInventoryItem('black_money')
        if blackMoneyItem and blackMoneyItem.count > 0 then
            hasBlackMoney = true
            blackMoneyAmount = blackMoneyItem.count
        end
    end

    -- Check if the player has enough black money
    if not hasBlackMoney or blackMoneyAmount < price then 
        TriggerClientEvent('ox_lib:notify', src, {
            id = 'not_enough_black_money',
            description = 'You need $' .. price .. ' in black money to purchase this bus',
            position = 'top-right',
            icon = 'ban',
            iconColor = '#C53030'
        })
        return 
    end

    -- Remove black money
    if QBCore then 
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.RemoveItem('black_money', price)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['black_money'], "remove")
    elseif ESX then
        local Player = ESX.GetPlayerFromId(src)
        Player.removeInventoryItem('black_money', price)
    end

    -- Give bus ownership papers
    exports.ox_inventory:AddItem(src, 'bus_papers', 1, 
        {description = 'Owner: '..player_name..' | Vehicle: '..vehiclename:gsub("^%l", string.upper)}
    )

    -- Notify and Spawn Bus
    TriggerClientEvent('ox_lib:notify', src, {
        id = 'bus_purchase_success',
        description = vehiclename:gsub("^%l", string.upper)..' purchased for $'..price..' in black money.',
        position = 'top-right',
        icon = 'bus',
        iconColor = 'white'
    })
    TriggerClientEvent('bbusiegade:client:SpawnBus', src, vehiclename, location)
    
    TriggerClientEvent('ox_lib:notify', src, {
        id = 'bus_purchase_notice',
        title = 'Bus Purchase',
        description = ('$%s in black money was deducted for purchasing a %s.'):format(price, vehiclename:gsub("^%l", string.upper)),
        position = 'top-right',
        icon = 'credit-card',
        iconColor = 'green'
    })
             
end)
