Config = Config or {}

local ActiveContracts = {}

local ox_inventory = exports.ox_inventory

local function notify(src, message, notifType)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Chopshop',
        description = message,
        type = notifType or 'info'
    })
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

local function updateContractMetadata(src, contract)
    -- Find the chopshop_contract in player inventory and update its metadata
    local result = ox_inventory:Search(src, 'slots', 'chopshop_contract')
    if not result or not result[1] then return end

    local slot = result[1].slot

    local metadata = {
        class = contract.class,
        classLabel = contract.classLabel,
        vehicles = contract.vehicles,
        remaining = contract.remaining,
    }

    metadata.description = buildContractDescription(metadata.classLabel, contract.vehicles, contract.remaining)

    ox_inventory:SetMetadata(src, slot, metadata)
end

RegisterNetEvent('rm-chopshop:startJob', function()
    local src = source

    if ActiveContracts[src] and not ActiveContracts[src].completed then
        notify(src, 'You already have an active chopshop contract.', 'error')
        return
    end

    -- For now always give Class D contract. You can randomize or select later.
    if not Config.ChopshopContracts or not Config.ChopshopContracts.D then
        notify(src, 'Chopshop configuration for Class D is missing.', 'error')
        return
    end

    giveContractItem(src, 'D')
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
    updateContractMetadata(src, contract)
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

    notify(src, 'Nice work. Here\'s your cut.', 'success')
    TriggerClientEvent('rm-chopshop:jobFinished', src)
end)



