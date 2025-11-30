---@diagnostic disable: undefined-global
local Config = require 'haloweenped/config'

local function hasAllItems(src)
	for _, item in ipairs(Config.requiredItems) do
		local count = exports.ox_inventory:Search(src, 'count', item)
		if (count or 0) < 1 then
			return false, item
		end
	end
	return true
end

local function takeAllItems(src)
	for _, item in ipairs(Config.requiredItems) do
		exports.ox_inventory:RemoveItem(src, item, 1)
	end
end

-- Resolve an item name to its display label using ox_inventory definitions
local itemsCache
local function getItemLabel(itemName)
	itemsCache = itemsCache or exports.ox_inventory:Items()
	local def = itemsCache and itemsCache[itemName]
	return (def and (def.label or def.name)) or itemName
end

-- Check if the player already owns the given vehicle model (by license or citizenid)
local function playerAlreadyOwnsVehicle(src, model)
	local Player = exports.qbx_core:GetPlayer(src)
	if not Player or not Player.PlayerData then
		return false
	end

	local identifiers = GetPlayerIdentifiers(src)
	local identifier
	for _, id in ipairs(identifiers) do
		if id:find('license:') then identifier = id break end
	end
	if not identifier then
		for _, id in ipairs(identifiers) do
			if id:find('license2:') or id:find('steam:') or id:find('discord:') then
				identifier = id
				break
			end
		end
	end

	local citizenid = Player.PlayerData.citizenid or 'unknown'
	local hash = GetHashKey(model)

	-- Look for any existing entry for this player and vehicle
	local exists = exports.oxmysql:scalar('SELECT 1 FROM `player_vehicles` WHERE (license = ? OR citizenid = ?) AND (vehicle = ? OR hash = ?) LIMIT 1', {
		identifier or 'unknown', citizenid, model, hash
	})

	return exists ~= nil
end

-- Grant owned vehicle to player (Qbox persistence via player_vehicles)
local function grantVehicleToPlayer(src, model)
	local Player = exports.qbx_core:GetPlayer(src)
	if not Player or not Player.PlayerData then
		return false, 'No player data'
	end

	-- derive a primary identifier (license preferred)
	local identifiers = GetPlayerIdentifiers(src)
	local identifier
	for _, id in ipairs(identifiers) do
		if id:find('license:') then identifier = id break end
	end
	if not identifier then
		for _, id in ipairs(identifiers) do
			if id:find('license2:') or id:find('steam:') or id:find('discord:') then
				identifier = id
				break
			end
		end
	end

	local citizenid = Player.PlayerData.citizenid or 'unknown'
	local plate = ('HWN%02d%03d'):format(math.random(10,99), math.random(100,999))
	local props = {
		model = model,
		plate = plate,
	}
	local state = 1

	-- insert into player_vehicles like other resources do
	exports.oxmysql:execute('INSERT INTO `player_vehicles` (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
		identifier or 'unknown', citizenid, model, GetHashKey(model), json.encode(props), plate, state
	})

	return true, { plate = plate, model = model }
end

lib.callback.register('haloweenped:tryRedeem', function(src)
	local ok, missing = hasAllItems(src)
	if not ok then
		return false, ('Missing item: %s'):format(getItemLabel(missing))
	end

	-- Prevent duplicate redemption if the player already owns this vehicle
	if playerAlreadyOwnsVehicle(src, Config.rewardVehicle) then
		return false, 'You already own this reward vehicle'
	end

	-- Now consume items and grant the vehicle
	takeAllItems(src)
	local success, payload = grantVehicleToPlayer(src, Config.rewardVehicle)
	if success then
		return true, payload
	else
		return false, ('Failed to grant vehicle: %s'):format(payload or 'unknown')
	end
end)


