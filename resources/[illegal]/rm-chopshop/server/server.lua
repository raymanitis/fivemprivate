Config = Config or {}

local ActiveContracts = {}
local PlayerChopXP = {}

local ox_inventory = exports.ox_inventory

---------------------------------------------------------------------
-- Database setup (XP persistence)
---------------------------------------------------------------------

-- CreateThread(function()
--     local hasMysql = lib and type(lib.mysql) == 'table'
--     if not hasMysql then
--         print('[rm-chopshop] WARNING: lib.mysql is not a table, chopshop XP will not be saved to database.')
--         return
--     end

--     lib.mysql.execute([[
--         CREATE TABLE IF NOT EXISTS rm_chopshop_xp (
--             citizenid VARCHAR(64) NOT NULL PRIMARY KEY,
--             xp INT NOT NULL DEFAULT 0
--         )
--     ]])
-- end)

local function notify(src, message, notifType)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Chopshop',
        description = message,
        type = notifType or 'info'
    })
end

local function getCitizenId(src)
    -- Qbox-style example; adapt if your core uses something else
    if exports.qbx_core then
        local player = exports.qbx_core:GetPlayer(src)
        if player and player.PlayerData and player.PlayerData.citizenid then
            return player.PlayerData.citizenid
        end
    end

    -- Fallback to license/identifier if needed
    local identifier = GetPlayerIdentifier(src, 0)
    return identifier or ('src:' .. tostring(src))
end

local function getXPByCitizenId(citizenid)
    -- DB persistence disabled: just return default starting XP.
    local defaultXP = 0
    if Config.ChopshopXP and Config.ChopshopXP.startXP then
        defaultXP = tonumber(Config.ChopshopXP.startXP) or 0
    end
    return defaultXP
end

local function saveXPForCitizenId(citizenid, xp)
    -- No-op: implement your own MySQL logic here if you want persistence.
end

local function ensurePlayerXP(src)
    if PlayerChopXP[src] then return end

    local citizenid = getCitizenId(src)
    local xp = getXPByCitizenId(citizenid)

    PlayerChopXP[src] = {
        citizenid = citizenid,
        xp = xp
    }
end

local function getPlayerXP(src)
    ensurePlayerXP(src)
    return PlayerChopXP[src].xp
end

local function addPlayerXP(src, classKey)
    if not Config.ChopshopXP or not Config.ChopshopXP.classes then return end
    local classXP = Config.ChopshopXP.classes[classKey]
    if not classXP then return end

    local minXP = tonumber(classXP.minXP) or 0
    local maxXP = tonumber(classXP.maxXP) or minXP
    if maxXP < minXP then maxXP, minXP = minXP, maxXP end

    local gain
    if maxXP == minXP then
        gain = minXP
    else
        gain = math.random(minXP, maxXP)
    end

    if gain <= 0 then return end

    local oldXP = getPlayerXP(src)
    local newXP = oldXP + gain
    PlayerChopXP[src].xp = newXP

    saveXPForCitizenId(PlayerChopXP[src].citizenid, newXP)

    notify(src, ('You earned %d chopshop XP (total: %d).'):format(gain, newXP), 'success')
end

local function getBestClassForXP(xp)
    if not Config.ChopshopXP or not Config.ChopshopXP.classes then
        return 'D'
    end

    local bestClass
    local bestRequired = -1

    for classKey, data in pairs(Config.ChopshopXP.classes) do
        local required = tonumber(data.requiredXP) or 0
        if xp >= required and required >= bestRequired and Config.ChopshopContracts[classKey] then
            bestClass = classKey
            bestRequired = required
        end
    end

    return bestClass or 'D'
end

local function buildContractDescription(classLabel, vehicles, remaining)
    local vehiclesText = {}
    for _, model in ipairs(vehicles) do
        vehiclesText[#vehiclesText + 1] = model:gsub("^%l", string.upper)
    end

    local remainingCount = #remaining

    local desc = ('Class: %s\nVehicles to bring: %s\nVehicles left: %d'):format(
        classLabel,
        table.concat(vehiclesText, ', '),
        remainingCount
    )

    return desc
end

local function giveContractItem(src, classKey, contractData)
    local classInfo = Config.ChopshopContracts[classKey]
    if not classInfo then return false end

    local allModels = classInfo.vehicles or {}
    local totalModels = #allModels
    if totalModels == 0 then return false end

    local minVehicles = tonumber(classInfo.minVehicles) or totalModels
    local maxVehicles = tonumber(classInfo.maxVehicles) or totalModels

    if minVehicles < 1 then minVehicles = 1 end
    if maxVehicles > totalModels then maxVehicles = totalModels end
    if maxVehicles < minVehicles then maxVehicles, minVehicles = minVehicles, maxVehicles end

    local count = math.random(minVehicles, maxVehicles)

    -- Randomly select "count" vehicles from the list without duplicates
    local pool = {}
    for i = 1, totalModels do
        pool[i] = allModels[i]
    end

    local vehicles = {}
    while #vehicles < count and #pool > 0 do
        local idx = math.random(1, #pool)
        vehicles[#vehicles + 1] = pool[idx]
        table.remove(pool, idx)
    end

    if #vehicles == 0 then return false end

    local remaining = {}
    for i = 1, #vehicles do
        remaining[i] = vehicles[i]
    end

    local metadata = {
        class = classKey,
        classLabel = classInfo.label or classKey,
        vehicles = vehicles,
        remaining = remaining,
    }

    metadata.description = buildContractDescription(metadata.classLabel, vehicles, remaining)

    local success = ox_inventory:AddItem(src, 'chopshop_contract', 1, metadata)

    if success then
        ActiveContracts[src] = {
            class = metadata.class,
            classLabel = metadata.classLabel,
            vehicles = vehicles,
            remaining = remaining,
            completed = false,
        }

        TriggerClientEvent('rm-chopshop:jobStarted', src, ActiveContracts[src])
        notify(src,
            'Job started. Bring the vehicles listed in your contract to the chop zone to complete the job.',
            'success')
        return true
    else
        notify(src, 'Could not give you a chopshop contract item.', 'error')
        return false
    end
end

RegisterNetEvent('rm-chopshop:startJob', function()
    local src = source

    if ActiveContracts[src] and not ActiveContracts[src].completed then
        notify(src, 'You already have an active chopshop contract.', 'error')
        return
    end

    if not Config.ChopshopContracts then
        notify(src, 'Chopshop contract configuration is missing.', 'error')
        return
    end

    local xp = getPlayerXP(src)
    local classKey = getBestClassForXP(xp)

    if not classKey or not Config.ChopshopContracts[classKey] then
        notify(src, 'No valid chopshop class found for your XP.', 'error')
        return
    end

    giveContractItem(src, classKey)
end)

AddEventHandler('playerDropped', function()
    local src = source
    if PlayerChopXP[src] and PlayerChopXP[src].citizenid then
        saveXPForCitizenId(PlayerChopXP[src].citizenid, PlayerChopXP[src].xp or 0)
    end

    PlayerChopXP[src] = nil
    ActiveContracts[src] = nil
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for src, data in pairs(PlayerChopXP) do
        if data.citizenid then
            saveXPForCitizenId(data.citizenid, data.xp or 0)
        end
    end
end)

---------------------------------------------------------------------
-- Exports: get player XP / class by citizenid
---------------------------------------------------------------------

exports('GetChopshopXP', function(citizenid)
    return getXPByCitizenId(citizenid)
end)

exports('GetChopshopClass', function(citizenid)
    local xp = getXPByCitizenId(citizenid)
    local classKey = getBestClassForXP(xp)
    return classKey, xp
end)

RegisterNetEvent('rm-chopshop:deliverVehicle', function(modelName)
    local src = source
    local contract = ActiveContracts[src]

    if not contract or contract.completed then
        notify(src, 'You don\'t have an active chopshop contract.', 'error')
        return
    end

    if type(modelName) ~= 'string' then
        notify(src, 'Invalid vehicle.', 'error')
        return
    end

    modelName = modelName:lower()

    local matchIndex
    for i, model in ipairs(contract.remaining) do
        if model:lower() == modelName then
            matchIndex = i
            break
        end
    end

    if not matchIndex then
        notify(src, 'This vehicle is not part of your contract.', 'error')
        return
    end

    table.remove(contract.remaining, matchIndex)

    if #contract.remaining == 0 then
        contract.completed = true
        notify(src, 'Vehicle delivered. Contract complete! Go talk to Carlos.', 'success')
    else
        notify(src,
            ('Vehicle delivered. %d vehicle(s) left to bring.'):format(#contract.remaining),
            'success')
    end

    ActiveContracts[src] = contract
    -- No need to update metadata on the item anymore, we only track progress server-side
    TriggerClientEvent('rm-chopshop:contractUpdated', src, contract)
end)

RegisterNetEvent('rm-chopshop:deleteVehicle', function(netId)
    local src = source
    if type(netId) ~= 'number' then return end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 then return end

    if not DoesEntityExist(entity) then return end

    if GetVehicleNumberPlateText(entity) and GetPedInVehicleSeat(entity, -1) == GetPlayerPed(src) then
        DeleteEntity(entity)
    end
end)

RegisterNetEvent('rm-chopshop:claimReward', function()
    local src = source
    local contract = ActiveContracts[src]

    if not contract or not contract.completed then
        notify(src, 'You haven\'t completed a chopshop contract yet.', 'error')
        return
    end

    -- Remove the contract item
    ox_inventory:RemoveItem(src, 'chopshop_contract', 1)

    local rewardsByClass = Config.ChopshopRewards or {}
    local classRewards = rewardsByClass[contract.class]

    if not classRewards then
        notify(src, 'No rewards configured for this contract class.', 'error')
    else
        -- Item rewards with min/max and chance
        if classRewards.items then
            for _, reward in ipairs(classRewards.items) do
                if reward.name then
                    local chance = reward.chance or 100
                    if math.random(0, 100) <= chance then
                        local amount
                        if reward.min and reward.max then
                            local min = tonumber(reward.min) or 0
                            local max = tonumber(reward.max) or min
                            if max < min then max, min = min, max end
                            if max == min then
                                amount = min
                            else
                                amount = math.random(min, max)
                            end
                        else
                            amount = reward.count or 1
                        end

                        if amount and amount > 0 then
                            ox_inventory:AddItem(src, reward.name, amount, reward.metadata or nil)
                        end
                    end
                end
            end
        end

        -- Money reward with min/max and chance (you must implement the add-money logic)
        if classRewards.money and (classRewards.money.min or classRewards.money.max) then
            local chance = classRewards.money.chance or 100
            if math.random(0, 100) <= chance then
                local min = tonumber(classRewards.money.min) or 0
                local max = tonumber(classRewards.money.max) or min
                if max < min then max, min = min, max end
                local amount
                if max == min then
                    amount = min
                else
                    amount = math.random(min, max)
                end

                if amount and amount > 0 then
                    local account = classRewards.money.account or 'cash'
                    -- Example (Qbox / ESX style, adapt to your core):
                    -- local xPlayer = exports.qbx_core:GetPlayer(src)
                    -- if xPlayer then
                    --     xPlayer.Functions.AddMoney(account, amount, 'chopshop-reward')
                    -- end
                end
            end
        end
    end

    ActiveContracts[src] = nil

    -- Give XP based on contract class
    addPlayerXP(src, contract.class)

    notify(src, 'Nice work. Here\'s your cut.', 'success')
    TriggerClientEvent('rm-chopshop:jobFinished', src)
end)



