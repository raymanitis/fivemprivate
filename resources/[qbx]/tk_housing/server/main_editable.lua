function Notify(src, text, notifyType)
    if Config.NotificationType == 'mythic' then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = notifyType, text = text})
    elseif Config.NotificationType == 'ox' then
        lib.notify(src, {
            title = 'Housing',
            description = text,
            type = notifyType
        })
    else
        ShowNotification(src, text, notifyType)
    end
end

local function Split(s, delimiter)
    local result = {}

    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end

    return result
end

---Gets the identifiers of a player, used for webhooks
---@param playerId number server id of the player
---@return string identifiers
function GetIdentifiers(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    local data = {}

    for _,v in pairs(identifiers) do
        local s = Split(v, ':')
        data[s[1]] = s[2]
    end

    return json.encode(data, {indent = true})
end

function Webhook(message)
    if not ConfigSV.WebhookLink or ConfigSV.WebhookLink == '' then return end

    local msg = {{["color"] = Config.WebhookColor, ["title"] = "**".. _U('webhook_title') .."**", ["description"] = message, ["footer"] = {["text"] = os.date("%d.%m.%y Time: %X")}}}
    PerformHttpRequest(ConfigSV.WebhookLink, function(err, text, headers) end, 'POST', json.encode({embeds = msg}), {['Content-Type'] = 'application/json'})
end

---Called when a property (or properties) are created
---@param playerId number id of the player who created the properties
---@param propertyIds table ids of the properties that were created
---@param propertyData table data of the properties that were created
function PropertyCreated(playerId, propertyIds, propertyData)

end

---players purchases/rents a property
---@param playerId number id of the player who is purchasing the property
---@param price number price of the property
---@param propertyIndex number index of the property
---@param propertyData table data of the property
---@param moneyType 'money' | 'bank' money type to remove from the player
---@param purchaseType 'rent' | 'price' purchase type (price means that player is purchasing the property)
---@return boolean success whether the property was purchased/rented successfully
function PurchaseProperty(playerId, price, propertyIndex, propertyData, moneyType, purchaseType)
    local xPlayer = GetPlayerFromId(playerId)
    RemoveAccountMoney(xPlayer, moneyType, price)

    local propertyOwner = propertyData.owner
    if propertyOwner then
        UpdatePlayerBankBalance(propertyOwner, price)
    end

    return true
end

---Player pays rent for a property
---@param identifier string identifier of the player who is paying the rent
---@param rentAmount number amount of the rent to pay
---@return boolean success whether the rent was paid successfully
function PayRent(identifier, rentAmount)
    local xPlayer = GetPlayerFromIdentifier(identifier)
    if not xPlayer then
        return UpdatePlayerBankBalance(identifier, rentAmount)
    end

    if GetAccountMoney(xPlayer, 'bank') >= rentAmount then
        RemoveAccountMoney(xPlayer, 'bank', rentAmount)
        return true
    end

    return false
end

---Called when a player purchases furniture (checkout cart)
---@param playerId number server id of the player
---@param propertyIndex number index of the property
---@param furnitureType string type of the furniture
---@param model string model of the furniture
function PurchasedFurniture(playerId, propertyIndex, furnitureType, model)

end

---Checks if a player can transfer a property to another player
---@param playerId number id of the player who is transferring the property
---@param targetId number id of the player who is receiving the property
---@param propertyIndex number index of the property
---@return boolean canTransfer whether the property can be transferred
function CanTransferProperty(playerId, targetId, propertyIndex)
    return true
end

function EnteringHouse(playerId, propertyIndex, isPreviewing)
    SetRoutingBucketPopulationEnabled(propertyIndex, false)
    SetPlayerRoutingBucket(playerId, propertyIndex)
end

function LeavingHouse(playerId, propertyIndex)
    SetPlayerRoutingBucket(playerId, 0)
end

function EnteringGarage(playerId, propertyIndex, isPreviewing, vehNetId, isPassanger)
    SetRoutingBucketPopulationEnabled(propertyIndex, false)
    SetPlayerRoutingBucket(playerId, propertyIndex)
end

function LeavingGarage(playerId, propertyIndex, isPreviewing, vehNetId)
    SetPlayerRoutingBucket(playerId, 0)
end

-- called when garage vehicles are spawned (happens when a player enters garage and no one else is in the garage so will not be called if someone is already in the garage)
function SpawnedGarageVehicles(playerId, vehicles)
    -- qbx keys:
    --[[ for _,v in pairs(vehicles) do
        local vehicle = NetworkGetEntityFromNetworkId(v.netId)
        exports.qbx_vehiclekeys:GiveKeys(playerId, vehicle)
    end ]]


    -- qb keys:
    --[[ for _,v in pairs(vehicles) do
        exports['qb-vehiclekeys']:GiveKeys(playerId, v.props.plate)
    end ]]
end

function CanPutItemInStorage(playerId, item, amount, propertyIndex, furnitureType, storageId)
    return true
end

function CanTakeItemFromStorage(playerId, item, amount, propertyIndex, furnitureType, storageId)
    return true
end

function GetPlayerInventory(playerId) -- only used for storages on esx
    local xPlayer = GetPlayerFromId(playerId)
    local items = {}

    for _,v in pairs(xPlayer.inventory) do
        local amount = v.count or v.amount or 0

        if amount > 0 and not Config.StorageBlacklist[v.name] then
            items[#items+1] = {label = v.label, name = v.name, amount = amount}
        end
    end

    local money = GetAccountMoney(xPlayer, 'money')
    if not Config.StorageBlacklist.money and money > 0 then
        items[#items+1] = {label = _U('money'), name = 'money', amount = money}
    end

    local blackMoney = GetAccountMoney(xPlayer, 'black_money')
    if not Config.StorageBlacklist.black_money and blackMoney > 0 then
        items[#items+1] = {label = _U('black_money'), name = 'black_money', amount = blackMoney}
    end

    for _,v in pairs(xPlayer.loadout) do
        if not Config.StorageBlacklist[v.name] then
            items[#items+1] = {label = v.label, name = v.name, amount = v.ammo or 0}
        end
    end

    return items
end

function GetAdditionalWeaponData(source, weapon, amount)
    return
end

function GiveWeapon(source, item, amount, data) -- used for storages on esx, data is the additional data that was returned from GetAdditionalWeaponData, can be used to add support for weapon attachments etc.
    local xPlayer = GetPlayerFromId(source)
    AddItem(xPlayer, item, amount)
end

function RegisterOxStash(stashName, stashData)
    exports.ox_inventory:RegisterStash(stashName, _U('stash'), stashData.slots or 24, stashData.weight or 100000)
end

function GetVehicleOwner(plate)
    if Config.Framework == 'qb' then
        return MySQL.Sync.fetchScalar('SELECT citizenid FROM player_vehicles WHERE plate = ? LIMIT 1', {plate})
    end

    return MySQL.Sync.fetchScalar('SELECT owner FROM owned_vehicles WHERE plate = ? LIMIT 1', {plate})
end

function SetVehicleStored(src, plate, stored, garageName)
    local xPlayer = GetPlayerFromId(src)
    local identifier = GetIdentifier(xPlayer)

    if Config.Framework == 'qb' then
        MySQL.Sync.execute('UPDATE player_vehicles SET state = ?, garage = ? WHERE plate = ? and citizenid = ?', {stored, garageName, plate, identifier})
    else
        MySQL.Async.execute('UPDATE owned_vehicles SET stored = ?, garage_id = ? WHERE plate = ? and owner = ?', {stored, garageName, plate, identifier})
    end
end

RegisterCallback('tk_housing:getPlayerDressing', function(src, cb)
	local xPlayer = GetPlayerFromId(src)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count = store.count('dressing')
		local labels = {}

		for i = 1, count do
			local entry = store.get('dressing', i)
			labels[#labels+1] = entry.label
		end

		cb(labels)
	end)
end)

RegisterCallback('tk_housing:getPlayerOutfit', function(src, cb, num)
	local xPlayer = GetPlayerFromId(src)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		if outfit then
			cb(outfit.skin)
		end
	end)
end)

-- can be used to remove properties where players have not been inside in x days (/removeunusedproperties 10, removes properties that have been inactive for 10 days), will permanently delete the property and all its data
RegisterCommand('removeunusedproperties', function(src, args, raw)
    local days = tonumber(args[1]) or 30
    RemoveUnusedProperties(days)
end, true)