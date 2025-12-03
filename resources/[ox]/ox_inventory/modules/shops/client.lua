if not lib then return end

local shopTypes = {}
local shops = {}
local createBlip = require 'modules.utils.client'.CreateBlip

for shopType, shopData in pairs(lib.load('data.shops') or {} --[[@as table<string, OxShop>]]) do
	local shop = {
		name = shopData.name,
		groups = shopData.groups or shopData.jobs,
		blip = shopData.blip,
        icon = shopData.icon,
		-- Shop-level ped configuration (applies to all targets)
		ped = shopData.ped,
		scenario = shopData.scenario,
		distance = shopData.distance or 2.0,
		-- Dialog configuration
		dialog = shopData.dialog
	}

	if shared.target then
		shop.model = shopData.model
		shop.targets = shopData.targets
	else
		shop.locations = shopData.locations
		-- Allow ped targets even when target is disabled for direct ped interaction
		shop.targets = shopData.targets
	end

	shopTypes[shopType] = shop
	local blip = shop.blip

	if blip then
		blip.name = ('ox_shop_%s'):format(shopType)
		AddTextEntry(blip.name, shop.name or shopType)
	end
end

-- Store active shop peds for interaction detection
local activeShopPeds = {}

-- Function to show shop dialog using mt_lib
local function showShopDialog(point)
	local shopConfig = shopTypes[point.type]
	if not shopConfig then return end

	-- Get dialog configuration from shop (with defaults)
	local dialogConfig = shopConfig.dialog or {}
	local pedName = dialogConfig.name or shopConfig.name or point.label or 'Shopkeeper'
	local speech = dialogConfig.speech or 'How can I help you?'
	local options = dialogConfig.options or {}

	-- Build mt_lib dialog options
	local dialogOptions = {}

	-- Add custom options from config
	for i = 1, #options do
		local option = options[i]
		table.insert(dialogOptions, {
			id = option.id or ('option_' .. i),
			label = option.label or option.title,
			icon = option.icon or 'circle',
			close = option.close ~= false, -- Default to true if not specified
			action = function()
				if option.action and type(option.action) == 'function' then
					option.action()
				elseif option.id == 'shop' or option.openShop then
					client.openInventory('shop', { id = point.invId, type = point.type })
				end
			end,
		})
	end

	-- If no options provided, add default "Open Shop" option
	if #dialogOptions == 0 then
		table.insert(dialogOptions, {
			id = 'shop',
			label = 'Open Shop',
			icon = 'shopping-basket',
			close = true,
			action = function()
				client.openInventory('shop', { id = point.invId, type = point.type })
			end,
		})
		table.insert(dialogOptions, {
			id = 'close',
			label = 'Nevermind',
			icon = 'times',
			close = true,
		})
	else
		-- Add close option if not already present
		local hasClose = false
		for i = 1, #dialogOptions do
			if dialogOptions[i].id == 'close' or dialogOptions[i].label:lower():match('close') or dialogOptions[i].label:lower():match('nevermind') or dialogOptions[i].label:lower():match('no') then
				hasClose = true
				break
			end
		end

		if not hasClose then
			table.insert(dialogOptions, {
				id = 'close',
				label = 'Nevermind',
				icon = 'times',
				close = true,
			})
		end
	end

	-- Show mt_lib dialogue
	local pedEntity = point.entity
	if pedEntity and DoesEntityExist(pedEntity) then
		exports.mt_lib:showDialogue({
			ped = pedEntity,
			label = pedName,
			speech = speech,
			options = dialogOptions
		})
	end
end

---@param point CPoint
local function onEnterShop(point)
	if not point.entity then
		local model = lib.requestModel(point.ped)

		if not model then return end

		local entity = CreatePed(0, model, point.coords.x, point.coords.y, point.coords.z, point.heading, false, true)

		if point.scenario then TaskStartScenarioInPlace(entity, point.scenario, 0, true) end

		SetModelAsNoLongerNeeded(model)
		FreezeEntityPosition(entity, true)
		SetEntityInvincible(entity, true)
		SetBlockingOfNonTemporaryEvents(entity, true)

		if shared.target then
			exports.ox_target:addLocalEntity(entity, {
				{
					icon = point.icon or 'fas fa-shopping-basket',
					label = point.label,
					groups = point.groups,
					onSelect = function()
						showShopDialog(point)
					end,
					iconColor = point.iconColor,
					distance = point.shopDistance or 2.0
				}
			})
		else
			-- Store ped info for direct interaction (no target system)
			activeShopPeds[entity] = {
				point = point,
				name = point.label, -- Shop name (set when creating point)
				icon = point.icon or 'fas fa-shopping-basket',
				groups = point.groups,
				distance = point.shopDistance or 2.0,
				invId = point.invId,
				type = point.type
			}
		end

		point.entity = entity
	end
end

local Utils = require 'modules.utils.client'

local function onExitShop(point)
	local entity = point.entity

	if not entity then return end

	if shared.target then
		exports.ox_target:removeLocalEntity(entity)
	else
		-- Remove from active shop peds
		activeShopPeds[entity] = nil
	end

	Utils.DeleteEntity(entity)

	point.entity = nil
end

local function hasShopAccess(shop)
	return not shop.groups or client.hasGroup(shop.groups)
end

local function wipeShops()
	for i = 1, #shops do
		local shop = shops[i]

		if shop.zoneId then
            exports.ox_target:removeZone(shop.zoneId)
            shop.zoneId = nil
		end

		if shop.remove then
			if shop.entity then onExitShop(shop) end

			shop:remove()
		end

		if shop.blip then
			RemoveBlip(shop.blip)
		end
	end

	table.wipe(shops)
	-- Clear active shop peds when wiping shops
	for entity in pairs(activeShopPeds) do
		activeShopPeds[entity] = nil
	end
end

local markerColour = { 30, 150, 30 }

-- Thread to handle direct ped interaction (when target is disabled)
CreateThread(function()
	while true do
		-- Only run if target is disabled and there are active shop peds
		if shared.target then
			Wait(1000)
		elseif next(activeShopPeds) == nil then
			Wait(500)
		else
			Wait(0)
			local playerPed = cache.ped
			local playerCoords = GetEntityCoords(playerPed)
			local closestPed = nil
			local closestDistance = nil

			-- Find closest shop ped
			for entity, shopData in pairs(activeShopPeds) do
				if DoesEntityExist(entity) then
					local pedCoords = GetEntityCoords(entity)
					local distance = #(playerCoords - pedCoords)

					if distance <= shopData.distance then
						-- Check if player has access
						if not shopData.groups or client.hasGroup(shopData.groups) then
							if not closestDistance or distance < closestDistance then
								closestDistance = distance
								closestPed = { entity = entity, shopData = shopData }
							end
						end
					end
				else
					-- Entity no longer exists, remove it
					activeShopPeds[entity] = nil
				end
			end

			-- Show/hide UI and handle interaction
			if closestPed then
				local shopData = closestPed.shopData

		-- Show text UI - "Open [shop name]"
		lib.showTextUI(('Open %s  \n%s'):format(shopData.name, locale('interact_prompt', GetControlInstructionalButton(0, 38, true):sub(3))))

				-- Check for E key press (38 = E key) and basic conditions
				if IsControlJustReleased(0, 38) and not cache.vehicle and not IsPauseMenuActive() then
					lib.hideTextUI()
					showShopDialog(shopData.point)
				end
			else
				lib.hideTextUI()
			end
		end
	end
end)

local function refreshShops()
	wipeShops()

	local id = 0

	for shopType, shop in pairs(shopTypes) do
		local blip = shop.blip

		if shared.target then
			if shop.model then
				if not hasShopAccess(shop) then goto skipLoop end

				exports.ox_target:removeModel(shop.model, shop.name)
				exports.ox_target:addModel(shop.model, {
                    {
                        name = shop.name,
                        icon = shop.icon or 'fas fa-shopping-basket',
                        label = shop.name,
                        onSelect = function()
                            client.openInventory('shop', { type = shopType })
                        end,
                        distance = 2
                    },
				})
		elseif shop.targets then
			for i = 1, #shop.targets do
				local target = shop.targets[i]
				local shopid = ('%s-%s'):format(shopType, i)

				-- Check if this shop uses ped-based targets
				if shop.ped then
					id += 1

					-- Get target location from vec4 (x, y, z, heading)
					local targetLoc = target.loc or target
					local isVec4 = type(targetLoc) == 'vector4' or (type(targetLoc) == 'table' and targetLoc.w ~= nil)
					local targetHeading = isVec4 and targetLoc.w or (target.heading or 0.0)
					local targetCoords = isVec4 and vec3(targetLoc.x, targetLoc.y, targetLoc.z - 1.0) or targetLoc

					shops[id] = lib.points.new({
						coords = targetCoords,
						heading = targetHeading,
						distance = 60,
						inv = 'shop',
						invId = i,
						type = shopType,
						blip = blip and hasShopAccess(shop) and createBlip(blip, targetCoords),
						ped = shop.ped, -- Use shop-level ped
						scenario = shop.scenario, -- Use shop-level scenario
						label = shop.name,
						groups = shop.groups,
						icon = shop.icon or 'fas fa-shopping-basket',
						onEnter = onEnterShop,
						onExit = onExitShop,
						shopDistance = shop.distance, -- Use shop-level distance (default 2.0)
					})
					else
						if not hasShopAccess(shop) then goto nextShop end

						id += 1

						shops[id] = {
							zoneId = Utils.CreateBoxZone(target, {
                                {
                                    name = shopid,
                                    icon = shop.icon or 'fas fa-shopping-basket',
                                    label = shop.name,
                                    groups = shop.groups,
                                    onSelect = function()
                                        client.openInventory('shop', { id = i, type = shopType })
                                    end,
                                    iconColor = target.iconColor,
                                    distance = target.distance
                                }
                            }),
							blip = blip and createBlip(blip, target.coords)
						}
					end

					::nextShop::
				end
			end
		elseif shop.locations then
			if not hasShopAccess(shop) then goto skipLoop end
            local shopPrompt = { icon = 'fas fa-shopping-basket' }

			for i = 1, #shop.locations do
				local coords = shop.locations[i]
				id += 1

				shops[id] = lib.points.new(coords, 16, {
					coords = coords,
					distance = 16,
					inv = 'shop',
					invId = i,
					type = type,
                    marker = markerColour,
                    prompt = {
                        options = shop.icon and { icon = shop.icon } or shopPrompt,
                        message = ('Open %s  \n%s'):format(shop.name, locale('interact_prompt', GetControlInstructionalButton(0, 38, true):sub(3)))
                    },
					nearby = Utils.nearbyMarker,
					blip = blip and createBlip(blip, coords)
				})
			end
		end

		-- Handle ped shops even when target is disabled
		if not shared.target and shop.targets and shop.ped then
			for i = 1, #shop.targets do
				local target = shop.targets[i]

				id += 1

				-- Get target location from vec4 (x, y, z, heading)
				local targetLoc = target.loc or target
				local isVec4 = type(targetLoc) == 'vector4' or (type(targetLoc) == 'table' and targetLoc.w ~= nil)
				local targetHeading = isVec4 and targetLoc.w or (target.heading or 0.0)
				local targetCoords = isVec4 and vec3(targetLoc.x, targetLoc.y, targetLoc.z - 1.0) or targetLoc

				shops[id] = lib.points.new({
					coords = targetCoords,
					heading = targetHeading,
					distance = 60,
					inv = 'shop',
					invId = i,
					type = type,
					blip = blip and hasShopAccess(shop) and createBlip(blip, targetCoords),
					ped = shop.ped, -- Use shop-level ped
					scenario = shop.scenario, -- Use shop-level scenario
					label = shop.name,
					groups = shop.groups,
					icon = shop.icon or 'fas fa-shopping-basket',
					onEnter = onEnterShop,
					onExit = onExitShop,
					shopDistance = shop.distance, -- Use shop-level distance (default 2.0)
				})
			end
		end

		::skipLoop::
	end
end

return {
	refreshShops = refreshShops,
	wipeShops = wipeShops,
}
