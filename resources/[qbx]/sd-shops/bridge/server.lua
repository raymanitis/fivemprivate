-- Detect inventory system
local inventorySystem
local codemInv, oxInv, qbInv, qsProInv, qsInv, origenInv = 'codem-inventory', 'ox_inventory', 'qb-inventory', 'qs-inventory-pro', 'qs-inventory', 'origen_inventory'

if GetResourceState(codemInv) == 'started' then
    inventorySystem = 'codem'
elseif GetResourceState(oxInv) == 'started' then
    inventorySystem = 'ox'
elseif GetResourceState(qbInv) == 'started' then
    inventorySystem = 'qb'
elseif GetResourceState(qsProInv) == 'started' then
    inventorySystem = 'qs-pro'
elseif GetResourceState(qsInv) == 'started' then
    inventorySystem = 'qs'
elseif GetResourceState(origenInv) == 'started' then
    inventorySystem = 'origen'
end

--- Player Management
local CreateGetPlayerFunction = function()
    if Framework == 'esx' then
        return function(source)
            return ESX.GetPlayerFromId(source)
        end
    elseif Framework == 'qb' then
        return function(source)
            return QBCore.Functions.GetPlayer(source)
        end
    else
        return function(source)
            error(string.format("Unsupported framework. Unable to retrieve player object for source: %s", source))
            return nil
        end
    end
end

GetPlayer = CreateGetPlayerFunction()

--- Get player identifier
local CreateGetIdentifierFunction = function()
    if Framework == 'esx' then
        return function(player)
            return player.identifier
        end
    elseif Framework == 'qb' then
        return function(player)
            return player.PlayerData.citizenid
        end
    else
        return function()
            error("Unsupported framework for GetIdentifier.")
        end
    end
end

local GetIdentifierFromPlayer = CreateGetIdentifierFunction()

GetIdentifier = function(source)
    local player = GetPlayer(source)
    return player and GetIdentifierFromPlayer(player) or nil
end

--- Money Management
Money = {}

local ConvertMoneyType = function(moneyType)
    if moneyType == 'money' and Framework == 'qb' then
        return 'cash'
    elseif moneyType == 'cash' and Framework == 'esx' then
        return 'money'
    else
        return moneyType
    end
end

local CreateAddMoneyFunction = function()
    if Framework == 'esx' then
        return function(player, moneyType, amount)
            player.addAccountMoney(ConvertMoneyType(moneyType), amount)
        end
    elseif Framework == 'qb' then
        return function(player, moneyType, amount)
            player.Functions.AddMoney(ConvertMoneyType(moneyType), amount)
        end
    else
        return function()
            error("Unsupported framework for AddMoney.")
        end
    end
end

local CreateRemoveMoneyFunction = function()
    if Framework == 'esx' then
        return function(player, moneyType, amount)
            player.removeAccountMoney(ConvertMoneyType(moneyType), amount)
        end
    elseif Framework == 'qb' then
        return function(player, moneyType, amount)
            player.Functions.RemoveMoney(ConvertMoneyType(moneyType), amount)
        end
    else
        return function()
            error("Unsupported framework for RemoveMoney.")
        end
    end
end

local CreateGetPlayerAccountFundsFunction = function()
    if Framework == 'esx' then
        return function(player, moneyType)
            local account = player.getAccount(ConvertMoneyType(moneyType))
            return account and account.money or 0
        end
    elseif Framework == 'qb' then
        return function(player, moneyType)
            return player.PlayerData.money[ConvertMoneyType(moneyType)] or 0
        end
    else
        return function()
            error("Unsupported framework for GetPlayerAccountFunds.")
            return 0
        end
    end
end

local AddMoneyToPlayer = CreateAddMoneyFunction()
local RemoveMoneyFromPlayer = CreateRemoveMoneyFunction()
local GetPlayerAccountFunds = CreateGetPlayerAccountFundsFunction()

Money.AddMoney = function(source, moneyType, amount)
    local player = GetPlayer(source)
    if player then
        AddMoneyToPlayer(player, moneyType, amount)
    end
end

Money.RemoveMoney = function(source, moneyType, amount)
    local player = GetPlayer(source)
    if player then
        RemoveMoneyFromPlayer(player, moneyType, amount)
    end
end

Money.GetPlayerAccountFunds = function(source, moneyType)
    local player = GetPlayer(source)
    return player and GetPlayerAccountFunds(player, moneyType) or 0
end

--- Black Money Management (for illegal shops)
local CreateGetBlackMoneyFunction = function()
    if inventorySystem == 'ox' then
        -- ox_inventory uses black_money as an item
        return function(player, source)
            local count = Inventory.HasItem(source, 'black_money')
            return count or 0
        end
    elseif Framework == 'qb' and inventorySystem == 'qb' then
        -- QBCore uses markedbills item with worth metadata (requires qb-inventory)
        return function(player, source)
            local markedBills = exports['qb-inventory']:GetItemsByName(source, 'markedbills')
            if not markedBills then return 0 end

            local totalWorth = 0
            for _, bill in pairs(markedBills) do
                if bill.info and bill.info.worth then
                    totalWorth = totalWorth + bill.info.worth
                end
            end
            return totalWorth
        end
    elseif Framework == 'esx' then
        -- ESX uses black_money account
        return function(player)
            local account = player.getAccount('black_money')
            return account and account.money or 0
        end
    else
        return function()
            error("Unsupported framework for GetBlackMoney.")
            return 0
        end
    end
end

local CreateRemoveBlackMoneyFunction = function()
    if inventorySystem == 'ox' then
        -- ox_inventory uses black_money as an item
        return function(player, amount, source)
            return Inventory.RemoveItem(source, 'black_money', amount)
        end
    elseif Framework == 'qb' and inventorySystem == 'qb' then
        -- QBCore uses markedbills item with worth metadata (requires qb-inventory)
        return function(player, amount, source)
            local markedBills = exports['qb-inventory']:GetItemsByName(source, 'markedbills')
            if not markedBills then return false end

            local remaining = amount
            for slot, bill in pairs(markedBills) do
                if remaining <= 0 then break end

                if bill.info and bill.info.worth then
                    if bill.info.worth <= remaining then
                        -- Remove entire stack
                        remaining = remaining - bill.info.worth
                        player.Functions.RemoveItem('markedbills', 1, slot)
                    else
                        -- Partial removal - update worth
                        bill.info.worth = bill.info.worth - remaining
                        remaining = 0
                        player.Functions.SetInventory(player.PlayerData.inventory)
                    end
                end
            end

            return remaining == 0
        end
    elseif Framework == 'esx' then
        -- ESX uses black_money account
        return function(player, amount)
            player.removeAccountMoney('black_money', amount)
            return true
        end
    else
        return function()
            error("Unsupported framework for RemoveBlackMoney.")
            return false
        end
    end
end

local GetBlackMoneyFunc = CreateGetBlackMoneyFunction()
local RemoveBlackMoneyFunc = CreateRemoveBlackMoneyFunction()

Money.GetBlackMoney = function(source)
    local player = GetPlayer(source)
    return player and GetBlackMoneyFunc(player, source) or 0
end

Money.RemoveBlackMoney = function(source, amount)
    local player = GetPlayer(source)
    if player then
        return RemoveBlackMoneyFunc(player, amount, source)
    end
    return false
end

-- Add black money to player
local CreateAddBlackMoneyFunction = function()
    if inventorySystem == 'ox' then
        -- ox_inventory uses black_money as an item
        return function(player, amount, source)
            return Inventory.AddItem(source, 'black_money', amount)
        end
    elseif Framework == 'qb' and inventorySystem == 'qb' then
        -- QBCore uses markedbills item with worth metadata (requires qb-inventory)
        return function(player, amount, source)
            local info = {
                worth = amount
            }
            return player.Functions.AddItem('markedbills', 1, false, info)
        end
    elseif Framework == 'esx' then
        -- ESX uses black_money account
        return function(player, amount)
            player.addAccountMoney('black_money', amount)
            return true
        end
    else
        return function()
            error("Unsupported framework for AddBlackMoney.")
            return false
        end
    end
end

local AddBlackMoneyFunc = CreateAddBlackMoneyFunction()

Money.AddBlackMoney = function(source, amount)
    local player = GetPlayer(source)
    if player then
        return AddBlackMoneyFunc(player, amount, source)
    end
    return false
end

--- Get player name
GetPlayerFullName = function(source)
    local player = GetPlayer(source)
    if not player then return "Unknown" end

    if Framework == 'esx' then
        return player.getName()
    elseif Framework == 'qb' then
        return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
    end

    return "Unknown"
end

--- Get player job
GetPlayerJob = function(source)
    local player = GetPlayer(source)
    if not player then return nil end

    if Framework == 'esx' then
        return player.job and player.job.name or nil
    elseif Framework == 'qb' then
        return player.PlayerData.job and player.PlayerData.job.name or nil
    end

    return nil
end

--- Get player gang
GetPlayerGang = function(source)
    local player = GetPlayer(source)
    if not player then return nil end

    if Framework == 'esx' then
        -- ESX doesn't have gangs by default, return nil
        return nil
    elseif Framework == 'qb' then
        return player.PlayerData.gang and player.PlayerData.gang.name or nil
    end

    return nil
end

--- Inventory Management
Inventory = {}

local CreateAddItemFunction = function()
    if inventorySystem == 'ox' then
        return function(source, item, count)
            return exports[oxInv]:AddItem(source, item, count)
        end
    elseif inventorySystem == 'codem' then
        return function(source, item, count)
            return exports[codemInv]:AddItem(source, item, count)
        end
    elseif inventorySystem == 'qs' or inventorySystem == 'qs-pro' then
        return function(source, item, count)
            local inv = inventorySystem == 'qs' and qsInv or qsProInv
            return exports[inv]:AddItem(source, item, count)
        end
    elseif inventorySystem == 'origen' then
        return function(source, item, count)
            return exports[origenInv]:AddItem(source, item, count)
        end
    else
        -- Framework fallback
        if Framework == 'esx' then
            return function(source, item, count)
                local player = GetPlayer(source)
                if player then
                    player.addInventoryItem(item, count)
                    return true
                end
                return false
            end
        elseif Framework == 'qb' then
            return function(source, item, count)
                local player = GetPlayer(source)
                if player then
                    return player.Functions.AddItem(item, count)
                end
                return false
            end
        end
    end
end

local AddItemToPlayer = CreateAddItemFunction()

Inventory.AddItem = function(source, item, count)
    return AddItemToPlayer(source, item, count)
end

-- HasItem function
local CreateHasItemFunction = function()
    if inventorySystem == 'ox' then
        return function(source, item)
            -- ox_inventory returns items as table, need to sum up counts
            local items = exports[oxInv]:Search(source, 'slots', item)
            if type(items) == 'table' then
                local totalCount = 0
                for _, itemData in pairs(items) do
                    totalCount = totalCount + (itemData.count or 0)
                end
                return totalCount
            end
            return 0
        end
    elseif inventorySystem == 'codem' then
        return function(source, item)
            return exports[codemInv]:GetItemsTotalAmount(source, item) or 0
        end
    elseif inventorySystem == 'qb' then
        return function(source, item)
            return exports[qbInv]:GetItemCount(source, item) or 0
        end
    elseif inventorySystem == 'qs' or inventorySystem == 'qs-pro' then
        return function(source, item)
            local inv = inventorySystem == 'qs' and qsInv or qsProInv
            return exports[inv]:GetItemTotalAmount(source, item) or 0
        end
    elseif inventorySystem == 'origen' then
        return function(source, item)
            return exports[origenInv]:getItemCount(source, item, false, false) or 0
        end
    else
        -- Framework fallback
        if Framework == 'esx' then
            return function(source, item)
                local player = GetPlayer(source)
                if player then
                    local itemData = player.getInventoryItem(item)
                    return itemData and (itemData.count or itemData.amount) or 0
                end
                return 0
            end
        elseif Framework == 'qb' then
            return function(source, item)
                local player = GetPlayer(source)
                if player then
                    local itemData = player.Functions.GetItemByName(item)
                    return itemData and (itemData.amount or itemData.count) or 0
                end
                return 0
            end
        end
    end
end

local GetPlayerItemCount = CreateHasItemFunction()

Inventory.HasItem = function(source, item)
    return GetPlayerItemCount(source, item)
end

-- RemoveItem function
local CreateRemoveItemFunction = function()
    if inventorySystem == 'ox' then
        return function(source, item, count)
            return exports[oxInv]:RemoveItem(source, item, count)
        end
    elseif inventorySystem == 'codem' then
        return function(source, item, count)
            return exports[codemInv]:RemoveItem(source, item, count)
        end
    elseif inventorySystem == 'qb' then
        return function(source, item, count)
            return exports[qbInv]:RemoveItem(source, item, count)
        end
    elseif inventorySystem == 'qs' or inventorySystem == 'qs-pro' then
        return function(source, item, count)
            local inv = inventorySystem == 'qs' and qsInv or qsProInv
            return exports[inv]:RemoveItem(source, item, count)
        end
    elseif inventorySystem == 'origen' then
        return function(source, item, count)
            return exports[origenInv]:removeItem(source, item, count)
        end
    else
        -- Framework fallback
        if Framework == 'esx' then
            return function(source, item, count)
                local player = GetPlayer(source)
                if player then
                    player.removeInventoryItem(item, count)
                    return true
                end
                return false
            end
        elseif Framework == 'qb' then
            return function(source, item, count)
                local player = GetPlayer(source)
                if player then
                    return player.Functions.RemoveItem(item, count)
                end
                return false
            end
        end
    end
end

local RemoveItemFromPlayer = CreateRemoveItemFunction()

Inventory.RemoveItem = function(source, item, count)
    return RemoveItemFromPlayer(source, item, count)
end

-- CanCarryItem function
local CreateCanCarryItemFunction = function()
    if inventorySystem == 'codem' then
        return function(player, item, count, metadata, source)
            return true
        end
    elseif inventorySystem == 'ox' then
        return function(player, item, count, metadata, source)
            return exports[oxInv]:CanCarryItem(source, item, count, metadata)
        end
    elseif inventorySystem == 'qb' then
        return function(player, item, count, slot, source)
            return exports[qbInv]:CanAddItem(source, item, count)
        end
    elseif inventorySystem == 'qs-pro' then
        return function(player, item, count, metadata, source)
            return exports[qsProInv]:CanCarryItem(source, item, count)
        end
    elseif inventorySystem == 'qs' then
        return function(player, item, count, slot, source)
            return exports[qsInv]:CanCarryItem(source, item, count)
        end
    elseif inventorySystem == 'origen' then
        return function(player, item, count, metadata, source)
            return exports[origenInv]:CanCarryItem(source, item, count)
        end
    else
        if Framework == 'esx' then
            return function(player, item, count)
                local currentItem = player.getInventoryItem(item)
                if currentItem then
                    local maxWeight = player.getMaxWeight()
                    local currentWeight = player.getWeight()
                    local itemWeight = currentItem.weight or 0
                    local totalWeight = currentWeight + (itemWeight * count)
                    return totalWeight <= maxWeight
                end
                return false
            end
        elseif Framework == 'qb' then
            return function(player, item, count, slot)
                return player.Functions.CanAddItem(item, count, slot)
            end
        else
            return function()
                error("Unsupported framework for CanCarryItem.")
            end
        end
    end
end

local CanCarryItemCheck = CreateCanCarryItemFunction()

Inventory.CanCarryItem = function(source, item, count, slot)
    local player = GetPlayer(source)
    if player then
        return CanCarryItemCheck(player, item, count, slot, source)
    end
    return false
end

-- GetItemLabel function
local CreateGetItemLabelFunction = function()
    if inventorySystem == 'ox' then
        return function(itemName)
            local item = exports[oxInv]:Items(itemName)
            return item and item.label or itemName
        end
    elseif inventorySystem == 'codem' then
        return function(itemName)
            -- Codem inventory doesn't have a direct export for this, fallback to QB/ESX
            if Framework == 'qb' then
                local item = QBCore.Shared.Items[itemName]
                return item and item.label or itemName
            elseif Framework == 'esx' then
                local item = ESX.GetItemLabel(itemName)
                return item or itemName
            end
            return itemName
        end
    elseif inventorySystem == 'qb' then
        return function(itemName)
            local item = QBCore.Shared.Items[itemName]
            return item and item.label or itemName
        end
    elseif inventorySystem == 'qs' or inventorySystem == 'qs-pro' then
        return function(itemName)
            -- QS inventories typically use QB/ESX items
            if Framework == 'qb' then
                local item = QBCore.Shared.Items[itemName]
                return item and item.label or itemName
            elseif Framework == 'esx' then
                local item = ESX.GetItemLabel(itemName)
                return item or itemName
            end
            return itemName
        end
    elseif inventorySystem == 'origen' then
        return function(itemName)
            -- Origen typically uses ESX
            if Framework == 'esx' then
                local item = ESX.GetItemLabel(itemName)
                return item or itemName
            end
            return itemName
        end
    else
        -- Framework fallback
        if Framework == 'esx' then
            return function(itemName)
                local item = ESX.GetItemLabel(itemName)
                return item or itemName
            end
        elseif Framework == 'qb' then
            return function(itemName)
                local item = QBCore.Shared.Items[itemName]
                return item and item.label or itemName
            end
        else
            return function(itemName)
                return itemName
            end
        end
    end
end

local GetItemLabelFunc = CreateGetItemLabelFunction()

Inventory.GetItemLabel = function(itemName)
    return GetItemLabelFunc(itemName)
end

-- GetItemDescription function
local CreateGetItemDescriptionFunction = function()
    if inventorySystem == 'ox' then
        return function(itemName)
            local item = exports[oxInv]:Items(itemName)
            if not item then return nil end
            -- Check for common description field names
            return item.description or item.desc or item.info or nil
        end
    elseif inventorySystem == 'codem' then
        return function(itemName)
            -- Codem inventory doesn't have a direct export for this, fallback to QB/ESX
            if Framework == 'qb' then
                local item = QBCore.Shared.Items[itemName]
                if not item then return nil end
                return item.description or item.desc or item.info or nil
            elseif Framework == 'esx' then
                -- ESX items typically don't have descriptions, return nil
                return nil
            end
            return nil
        end
    elseif inventorySystem == 'qb' then
        return function(itemName)
            local item = QBCore.Shared.Items[itemName]
            if not item then return nil end
            return item.description or item.desc or item.info or nil
        end
    elseif inventorySystem == 'qs' or inventorySystem == 'qs-pro' then
        return function(itemName)
            -- QS inventories typically use QB/ESX items
            if Framework == 'qb' then
                local item = QBCore.Shared.Items[itemName]
                if not item then return nil end
                return item.description or item.desc or item.info or nil
            elseif Framework == 'esx' then
                return nil
            end
            return nil
        end
    elseif inventorySystem == 'origen' then
        return function(itemName)
            -- Origen typically uses ESX
            if Framework == 'esx' then
                return nil
            end
            return nil
        end
    else
        -- Framework fallback
        if Framework == 'esx' then
            return function(itemName)
                return nil
            end
        elseif Framework == 'qb' then
            return function(itemName)
                local item = QBCore.Shared.Items[itemName]
                if not item then return nil end
                return item.description or item.desc or item.info or nil
            end
        else
            return function(itemName)
                return nil
            end
        end
    end
end

local GetItemDescriptionFunc = CreateGetItemDescriptionFunction()

Inventory.GetItemDescription = function(itemName)
    return GetItemDescriptionFunc(itemName)
end

--- Job & Society Management
Job = {}

-- Auto-detect banking system for societies
local function DetectBankingSystem()
    if GetResourceState('okokBanking') == 'started' then
        return 'okokBanking'
    elseif GetResourceState('Renewed-Banking') == 'started' then
        return 'Renewed-Banking'
    elseif GetResourceState('fd_banking') == 'started' then
        return 'fd_banking'
    elseif GetResourceState('tgg-banking') == 'started' then
        return 'tgg-banking'
    end

    if Framework == 'qb' then
        if GetResourceState('qb-banking') == 'started' then
            local version = GetResourceMetadata('qb-banking', 'version', 0)
            if version and tonumber(string.sub(version, 1, 3)) >= 2 then
                return 'qb-banking'
            end
        end
        if GetResourceState('qb-management') == 'started' then
            return 'qb-management'
        end
    elseif Framework == 'esx' then
        if GetResourceState('esx_society') == 'started' then
            return 'esx_addonaccount'
        end
    end

    return nil
end

local bankingSystem = DetectBankingSystem()

-- Get player's job name
local CreateGetPlayerJobNameFunction = function()
    if Framework == 'esx' then
        return function(player)
            return player.job and player.job.name or nil
        end
    elseif Framework == 'qb' then
        return function(player)
            return player.PlayerData.job and player.PlayerData.job.name or nil
        end
    else
        return function()
            return nil
        end
    end
end

local GetPlayerJobNameFunc = CreateGetPlayerJobNameFunction()

Job.GetJobName = function(source)
    local player = GetPlayer(source)
    return player and GetPlayerJobNameFunc(player) or nil
end

-- Get player's job grade
local CreateGetPlayerJobGradeFunction = function()
    if Framework == 'esx' then
        return function(player)
            return player.job and player.job.grade or 0
        end
    elseif Framework == 'qb' then
        return function(player)
            return player.PlayerData.job and player.PlayerData.job.grade and player.PlayerData.job.grade.level or 0
        end
    else
        return function()
            return 0
        end
    end
end

local GetPlayerJobGradeFunc = CreateGetPlayerJobGradeFunction()

Job.GetJobGrade = function(source)
    local player = GetPlayer(source)
    return player and GetPlayerJobGradeFunc(player) or 0
end

-- Get all player jobs (including multijob support)
Job.GetAllJobs = function(source)
    local player = GetPlayer(source)
    if not player then return {} end

    local jobs = {}

    if Framework == 'qb' then
            -- Single job system
            local jobData = player.PlayerData.job
            if jobData then
                jobs[jobData.name] = {
                    name = jobData.name,
                    grade = jobData.grade and jobData.grade.level or 0,
                    label = jobData.label or jobData.name
                }
        end
    elseif Framework == 'esx' then
        -- ESX single job
        local jobData = player.job
        if jobData then
            jobs[jobData.name] = {
                name = jobData.name,
                grade = jobData.grade or 0,
                label = jobData.label or jobData.name
            }
        end
    end

    return jobs
end

-- Check if player has a specific job with minimum grade
Job.HasJob = function(source, jobName, minGrade)
    minGrade = minGrade or 0
    local jobs = Job.GetAllJobs(source)

    if jobs[jobName] then
        return jobs[jobName].grade >= minGrade
    end

    return false
end

--- License Management
License = {}

-- Check if player has a specific license
local CreateHasLicenseFunction = function()
    if Framework == 'qb' then
        return function(source, licenseType)
            local player = GetPlayer(source)
            if not player then return false end

            -- Check in player metadata licenses
            local licenses = player.PlayerData.metadata and player.PlayerData.metadata.licences
            if not licenses then
                licenses = player.PlayerData.metadata and player.PlayerData.metadata.licenses
            end

            if licenses and licenses[licenseType] then
                return true
            end

            return false
        end
    elseif Framework == 'esx' then
        return function(source, licenseType)
            local player = GetPlayer(source)
            if not player then return false end

            local identifier = player.identifier
            local hasLicense = MySQL.scalar.await('SELECT 1 FROM `user_licenses` WHERE `type` = ? AND `owner` = ?', { licenseType, identifier })
            return hasLicense ~= nil
        end
    else
        return function()
            return false
        end
    end
end

local HasLicenseFunc = CreateHasLicenseFunction()

License.HasLicense = function(source, licenseType)
    if not licenseType then return true end
    return HasLicenseFunc(source, licenseType)
end

--- Society Banking
Society = {}

-- Get society account balance
Society.GetBalance = function(societyName)
    if not bankingSystem then return 0 end

    if bankingSystem == 'qb-banking' then
        return exports['qb-banking']:GetAccountBalance(societyName) or 0
    elseif bankingSystem == 'qb-management' then
        return exports['qb-management']:GetAccount(societyName) or 0
    elseif bankingSystem == 'esx_addonaccount' then
        local balance = promise.new()
        TriggerEvent("esx_society:getSociety", societyName, function(data)
            if not data then return balance:resolve(0) end

            TriggerEvent("esx_addonaccount:getSharedAccount", data.account, function(account)
                return balance:resolve(account.money or 0)
            end)
        end)
        return Citizen.Await(balance)
    elseif bankingSystem == 'Renewed-Banking' then
        return exports['Renewed-Banking']:getAccountMoney(societyName) or 0
    elseif bankingSystem == 'okokBanking' then
        return exports.okokBanking:GetAccount(societyName) or 0
    elseif bankingSystem == 'fd_banking' then
        return exports.fd_banking:GetAccount(societyName) or 0
    elseif bankingSystem == 'tgg-banking' then
        return exports['tgg-banking']:GetSocietyAccountMoney(societyName) or 0
    end

    return 0
end

-- Add money to society account
Society.AddMoney = function(societyName, amount)
    if not bankingSystem then return false end

    if bankingSystem == 'qb-banking' then
        exports['qb-banking']:AddMoney(societyName, amount)
    elseif bankingSystem == 'qb-management' then
        exports['qb-management']:AddMoney(societyName, amount)
    elseif bankingSystem == 'esx_addonaccount' then
        TriggerEvent("esx_society:getSociety", societyName, function(data)
            if data then
                TriggerEvent("esx_addonaccount:getSharedAccount", data.account, function(account)
                    if account then
                        account.addMoney(amount)
                    end
                end)
            end
        end)
    elseif bankingSystem == 'Renewed-Banking' then
        exports['Renewed-Banking']:addAccountMoney(societyName, amount)
    elseif bankingSystem == 'okokBanking' then
        exports.okokBanking:AddMoney(societyName, amount)
    elseif bankingSystem == 'fd_banking' then
        exports.fd_banking:AddMoney(societyName, amount)
    elseif bankingSystem == 'tgg-banking' then
        exports['tgg-banking']:AddSocietyMoney(societyName, amount)
    end

    return true
end

-- Remove money from society account
Society.RemoveMoney = function(societyName, amount)
    if not bankingSystem then return false end

    if bankingSystem == 'qb-banking' then
        exports['qb-banking']:RemoveMoney(societyName, amount)
    elseif bankingSystem == 'qb-management' then
        exports['qb-management']:RemoveMoney(societyName, amount)
    elseif bankingSystem == 'esx_addonaccount' then
        TriggerEvent("esx_society:getSociety", societyName, function(data)
            if data then
                TriggerEvent("esx_addonaccount:getSharedAccount", data.account, function(account)
                    if account then
                        account.removeMoney(amount)
                    end
                end)
            end
        end)
    elseif bankingSystem == 'Renewed-Banking' then
        exports['Renewed-Banking']:removeAccountMoney(societyName, amount)
    elseif bankingSystem == 'okokBanking' then
        exports.okokBanking:RemoveMoney(societyName, amount)
    elseif bankingSystem == 'fd_banking' then
        exports.fd_banking:RemoveMoney(societyName, amount)
    elseif bankingSystem == 'tgg-banking' then
        exports['tgg-banking']:RemoveSocietyMoney(societyName, amount)
    end

    return true
end

--- Checks for updates by comparing local version with GitHub releases
---@param repo string The GitHub repository in format 'owner/repository'
CheckVersion = function(repo)
    local resource = GetInvokingResource() or GetCurrentResourceName()
    local currentVersion = GetResourceMetadata(resource, 'version', 0) or GetResourceMetadata(resource, 'Version', 0)

    if currentVersion then
        currentVersion = currentVersion:match('%d+%.%d+%.%d+')
    end

    if not currentVersion then
        return print("^1Unable to determine current resource version for '^2" .. resource .. "^1'^0")
    end
    
    print('^3Checking for updates for ^2' .. resource .. '^3...^0')
    
    SetTimeout(1000, function()
        local url = ('https://api.github.com/repos/%s/releases/latest'):format(repo)
        PerformHttpRequest(url, function(status, response)
            if status ~= 200 then
                print('^1Failed to fetch release information for ^2' .. resource .. '^1. HTTP status: ' .. status .. '^0')
                return
            end
            
            local data = json.decode(response)
            if not data then
                print('^1Failed to parse release information for ^2' .. resource .. '^1.^0')
                return
            end
            
            if data.prerelease then
                print('^3Skipping prerelease for ^2' .. resource .. '^3.^0')
                return
            end
            
            local latestVersion = data.tag_name and data.tag_name:match('%d+%.%d+%.%d+')
            if not latestVersion then
                print('^1Failed to get valid latest version for ^2' .. resource .. '^1.^0')
                return
            end
            
            if latestVersion == currentVersion then
                print('^2' .. resource .. ' ^3is up-to-date with version ^2' .. currentVersion .. '^3.^0')
                return
            end
            
            -- Compare versions
            local parseVersion = function(version)
                local parts = {}
                for part in version:gmatch('%d+') do
                    table.insert(parts, tonumber(part))
                end
                return parts
            end
            
            local cv = parseVersion(currentVersion)
            local lv = parseVersion(latestVersion)
            
            for i = 1, math.max(#cv, #lv) do
                local current = cv[i] or 0
                local latest = lv[i] or 0
                
                if current < latest then
                    local releaseNotes = data.body or "No release notes available."
                    local message = releaseNotes:find("\n") and 
                        "Check release page or changelog channel on Discord for more information!" or 
                        releaseNotes
                    
                    print(string.format(
                        '^3An update is available for ^2%s^3 (current: ^2%s^3)\r\nLatest: ^2%s^3\r\nRelease Notes: ^7%s',
                        resource, currentVersion, latestVersion, message
                    ))
                    break
                elseif current > latest then
                    print(string.format(
                        '^2%s ^3has newer local version (^2%s^3) than latest public release (^2%s^3).^0',
                        resource, currentVersion, latestVersion
                    ))
                    break
                end
            end
        end, 'GET', '')
    end)
end

print(string.format("^2[SD-SHOPS]^0 Bridge initialized - Framework: ^3%s^0, Inventory: ^3%s^0, Banking: ^3%s^0", Framework, inventorySystem or "framework-default", bankingSystem or "none"))
