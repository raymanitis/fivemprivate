--#region Modules
local log = require("modules.utility.shared.logger")
local config = require("config.shared")
local interface_enums = enums.interface
local utility = require("modules.utility.shared.functions")
local qbox_shared_config = require("config.framework.shared.qbox")
--#endregion

---@type IFrameworkClient
---@diagnostic disable-next-line: missing-fields
local qbox = {}
qbox.__index = qbox

function qbox.new()
	local self = setmetatable({}, qbox)

	if GetResourceState("qbx_core") ~= "started" then
		log.errorf("[qbox.new] `qbx_core` not found, make sure you haven't renamed it and it's started before the multicharacter.")
	end

	self.__name = "qbox"
	self.core = nil
	self.cache = {
		camera_handlers = {},
		peds_to_cleanup = {},
	}

	RegisterNetEvent("qbx_core:client:playerLoggedOut", function()
		if GetInvokingResource() then return end

		DoScreenFadeOut(250)

		resource_core:initialize_character_select()
	end)

	return self
end

function qbox:should_init_char_select()
	local player_data = exports.qbx_core:GetPlayerData()

	Citizen.Wait(300)

	if LocalPlayer.state.has_logged_out then
		return true
	end

	if not player_data or not next(player_data) then return true end

	return false
end

function qbox:on_registration_start()
	return promise.new(function(p)
		if qbox_shared_config.support_starting_apartments then
			resource_core.selected_apartment.set(nil)

			interface:message(interface_enums.messages.set_apartment_selector_visibility, true)

			while not resource_core.selected_apartment.value() do
				Citizen.Wait(300)
			end

			interface:message(interface_enums.messages.set_apartment_selector_visibility, { state = false, keep_loading_screen = true })
		end

		p:resolve()
	end)
end

function qbox:on_character_load(char, is_new)
	if not interface.loading_container.value() then
		interface.loading_container.toggle(true)
	end

	local using_spawn_manager, spawned_player_through_manager = false, false
	resource_core:refresh_player_variables()

	Citizen.Wait(300)

	interface:toggle(false)

	resource_core._cache.camera_handlers.destroy_cam()

	resource_core:on_player_load()

	if IsEntityPositionFrozen(resource_core.source_ped_id.value()) then
		FreezeEntityPosition(resource_core.source_ped_id.value(), false)
	end

	if not (is_new and qbox_shared_config.support_starting_apartments) then
		---@type IPosition?
		local position

		if is_new then
			local random_spawn_points = config.registration_options.new_player_spawn_points
			local random_spawn_point = random_spawn_points[math.random(1, #random_spawn_points)]

			position = {
				x = random_spawn_point.x,
				y = random_spawn_point.y,
				z = random_spawn_point.z,
				heading = random_spawn_point.w or 0.0,
			}
		else
			position = char.selected_spawn_point.coords
		end

		if not position then
			return log.errorf("[qbox:on_character_load] No position found for character.")
		end

		using_spawn_manager = true

		local success, result = pcall(function()
			utility:spawn_player(position, function()
				spawned_player_through_manager = true
			end)
		end)

		if not success then
			log.errorf("[qbox:on_character_load] Failed to spawn player using `spawn_player`. (Got - %s)", result)
		end
	end

	if is_new and not qbox_shared_config.support_starting_apartments then
		local model_string = char.sex == "male" and "mp_m_freemode_01" or "mp_f_freemode_01"
		local model = joaat(model_string)

		RequestModel(model)

		resource_core:wait_for_condition(HasModelLoaded, "qb::on_character_load::model", nil, nil, model)

		SetPlayerModel(PlayerId(), model)

		SetModelAsNoLongerNeeded(model)

		resource_core:refresh_player_variables()

		local ped = resource_core.source_ped_id.value()

		for i = 0, 11 do
			SetPedComponentVariation(ped, i, 0, 0, 0)
		end

		ClearAllPedProps(ped)
	end

	if not (is_new and qbox_shared_config.support_starting_apartments) then
		TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
		TriggerEvent('QBCore:Client:OnPlayerLoaded')
		TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
		TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
		TriggerEvent('qb-weathersync:client:EnableSync')
	else
		if not resource_core.selected_apartment.value() then
			return log.errorf("[qbox:on_character_load] Selected apartment is somehow nil?")
		end

		local raw_apartment_data = resource_core.selected_apartment.value().raw_data --[[@as IQboxApartmentOption]]

		SetEntityCoords(resource_core.source_ped_id.value(), raw_apartment_data.enter.x, raw_apartment_data.enter.y, raw_apartment_data.enter.z - 2.0, false, false, false, false)

		TriggerServerEvent("qbx_properties:server:apartmentSelect", resource_core.selected_apartment.value().index)
	end

	-- Spaghetti code but yea.
	if is_new and qbox_shared_config.support_starting_apartments then
		TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
		TriggerEvent('QBCore:Client:OnPlayerLoaded')
	end

	if using_spawn_manager then
		local timeout = 12500
		local abort_at = GetGameTimer() + timeout

		Citizen.Trace("[qbox:on_character_load] Waiting for spawn manager to fully spawn/load the selected player.")

		while not spawned_player_through_manager do
			if GetGameTimer() > abort_at then
				Citizen.Trace("[qbox:on_character_load] Spawn manager timeout reached, proceeding anyway.")
				break
			end

			Citizen.Wait(100)
		end

		if not spawned_player_through_manager then
			log.warning("[qbox:on_character_load] Spawn manager failed or timed out.")
		end
	else
		Citizen.Wait((is_new and qbox_shared_config.support_starting_apartments) and 2000 or 3250)
	end

	interface.loading_container.toggle(false)

	if not (is_new and qbox_shared_config.support_starting_apartments) then
		camera_manager:play_entry_transition(nil, is_new)
	end

	if not is_new or (is_new and qbox_shared_config.support_starting_apartments) then
		return
	end

	interface.toaster.add_toast({
		title = locales.common("find_place_to_customize_char"),
		message = locales.common("find_place_to_customize_char_subtitle"),
		close_delay = 4000,
	})

	Citizen.Wait(4000)

	TriggerEvent('qb-clothes:client:CreateFirstCharacter')
end

function qbox:on_character_selection_start()
	log.debug("[QBOX] Loaded character select.")
end

function qbox:get_character_model_hash(char)
	local raw_data = char.raw_data --[[@as IQboxCharacterData]]

	if raw_data.skin_data?.model then
		return joaat(raw_data.skin_data?.model)
	end

	return nil
end

function qbox:setup_preview_character_appearance(char, ped, model)
	local raw_data = char.raw_data --[[@as IQboxCharacterData]]

	if not raw_data?.skin_data?.model then
		raw_data.skin_data.model = model
		log.debugf("[qbox:setup_preview_character_appearance] No model found for data, updating to - %s", model)
	end

	pcall(function() exports['illenium-appearance']:setPedAppearance(ped, raw_data.skin_data) end)
end

function qbox:on_registration_finalization(data)
	self:on_character_load(data, true)
end

function qbox:get_starter_apartments()
	if GetResourceState("qbx_properties") == "missing" then
		return {}
	end

	local data = LoadResourceFile("qbx_properties", "config/shared.lua")

	if not data then return {} end

	local success, result = pcall(load, data)

	if not success then
		log.warningf("[qbox:get_starter_apartments] Failed to load Lua code (Got - %s)", result)
		return {}
	end

	local execute_success, config_table = pcall(result --[[@as fun()]])

	if not execute_success then
		log.warningf("[qbox:get_starter_apartments] Failed to execute Lua code (Got - %s)", config_table)
		return {}
	end

	if not config_table or not config_table.apartmentOptions then
		log.warningf("[qbox:get_starter_apartments] No apartmentOptions found in config")
		return {}
	end

	---@type IStarterApartment[]
	local parsed_apartments = {}

	for i = 1, #config_table.apartmentOptions do
		local v = config_table.apartmentOptions[i] --[[@as IQboxApartmentOption]]

		if not v then goto continue end

		parsed_apartments[#parsed_apartments + 1] = {
			name = v.label,
			coords = {
				x = v.enter.x,
				y = v.enter.y,
				z = v.enter.z,
				heading = 0.0
			},
			index = i,
			id = v.interior,
			raw_data = v
		}

		::continue::
	end

	return parsed_apartments
end

return qbox
