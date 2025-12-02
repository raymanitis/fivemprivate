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
		distance = shopData.distance or 2.0
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
						client.openInventory('shop', { id = point.invId, type = point.type })
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
					client.openInventory('shop', { id = shopData.invId, type = shopData.type })
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

	for type, shop in pairs(shopTypes) do
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
                            client.openInventory('shop', { type = type })
                        end,
                        distance = 2
                    },
				})
		elseif shop.targets then
			for i = 1, #shop.targets do
				local target = shop.targets[i]
				local shopid = ('%s-%s'):format(type, i)

				-- Check if this shop uses ped-based targets
				if shop.ped then
					id += 1

					-- Get target location (support vec3 or vec4)
					local targetLoc = target.loc or target
					local targetHeading = target.heading or (type(targetLoc) == 'vector4' and targetLoc.w) or 0.0
					local targetCoords = type(targetLoc) == 'vector4' and vec3(targetLoc.x, targetLoc.y, targetLoc.z) or targetLoc

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
                                        client.openInventory('shop', { id = i, type = type })
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
				local targetHeading = type(targetLoc) == 'vector4' and targetLoc.w or (target.heading or 0.0)
				local targetCoords = type(targetLoc) == 'vector4' and vec3(targetLoc.x, targetLoc.y, targetLoc.z) or targetLoc

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
