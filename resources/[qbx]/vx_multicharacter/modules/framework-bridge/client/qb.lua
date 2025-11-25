--#region Modules
local log = require("modules.utility.shared.logger")
local config = require("config.shared")
local qb_shared_config = require("config.framework.shared.qb")
local utility = require("modules.utility.shared.functions")
local interface_enums = enums?.interface
--#endregion

---@type IFrameworkClient
---@diagnostic disable-next-line: missing-fields
local qb = {}
qb.__index = qb

function qb.new()
	local self = setmetatable({}, qb)

	if GetResourceState("qb-core") ~= "started" then
		log.errorf("[qb.new] `qb-core` not found, make sure you haven't renamed it and it's started before the multicharacter.")
	end

	self.__name = "qb"
	self.core = exports['qb-core']:GetCoreObject()
	self.cache = {}

	RegisterNetEvent("QBCore:Client:OnPlayerUnload", function()
		if GetInvokingResource() then return end

		DoScreenFadeOut(250)

		resource_core:initialize_character_select()
	end)

	return self
end

function qb:should_init_char_select()
	Citizen.Wait(300)

	if LocalPlayer.state.has_logged_out then
		return true
	end

	return not LocalPlayer.state.isLoggedIn
end

function qb:on_character_selection_start()
	log.debug("[QB] Loaded character select.")
end

function qb:setup_preview_character_appearance(char, ped, model)
	local raw_data = char.raw_data --[[@as IQBRawCharacterData]]

	if not raw_data.skin_data then
		return log.warningf("[qb:setup_preview_character_appearance] Invalid skin_data found.")
	end

	TriggerEvent('qb-clothing:client:loadPlayerClothing', raw_data.skin_data, ped)
end

function qb:get_character_model_hash(char)
	local raw_data = char.raw_data --[[@as IQBRawCharacterData]]

	if raw_data.skin_data?.model then
		log.debugf("returning model hash - %s (%s) (%s)", raw_data.skin_data?.model, joaat(raw_data.skin_data?.model), type(raw_data.skin_data?.model))
		return tonumber(raw_data.skin_data?.model)
	end

	return nil
end

function qb:on_registration_finalization(data)
	self:on_character_load(data, true)
end

function qb:get_starter_apartments()
	qb_shared_config.support_starting_apartments = false

	if GetResourceState("qb-apartments") == "missing" then
		return {}
	end

	local chunk = LoadResourceFile("qb-apartments", "config.lua")

	if not chunk then
		log.warning("[qb::get_starter_apartments] Could not read config.lua")
		return {}
	end

	local env = {}
	setmetatable(env, { __index = _G })

	local fn, load_err = load(chunk, "qb-apartments/config.lua", "t", env)

	if not fn then
		log.warningf("[qb::get_starter_apartments] Failed to load config: %s", load_err)
		return {}
	end

	local ok, run_err = pcall(fn)

	if not ok then
		log.warningf("[qb::get_starter_apartments] Failed to run config: %s", run_err)
		return {}
	end

	local apartments = env.Apartments
	if not apartments or not apartments.Locations then
		log.warning("[qb::get_starter_apartments] No Apartments table found in config.")
		return {}
	end

	---@type IStarterApartment[]
	local data = {}
	local counter = 0

	for _, v in pairs(apartments.Locations) do
		data[#data + 1] = {
			index = counter,
			id = v.name,
			name = v.label,
			coords = {
				x = v.coords.enter.x,
				y = v.coords.enter.y,
				z = v.coords.enter.z,
				heading = v.coords.enter.w or 0.0
			},
			raw_data = v
		}
		counter = counter + 1
	end

	qb_shared_config.support_starting_apartments = #data >= 1

	return data
end

function qb:on_registration_start()
	return promise.new(function(p)
		if qb_shared_config.support_starting_apartments then
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

function qb:on_character_load(char, is_new)
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

	---@type IPosition?
	if not (is_new and qb_shared_config.support_starting_apartments) then
		local position

		if is_new then
			local random_spawn_points = config.registration_options.new_player_spawn_points
			local random_spawn_point = random_spawn_points[math.random(1, #random_spawn_points)]

			position = {
				heading = 0.0,
				x = random_spawn_point.x,
				y = random_spawn_point.y,
				z = random_spawn_point.z
			}
		else
			position = char.selected_spawn_point.coords
		end

		if not position then
			return log.errorf("[qb:on_character_load] Unable to load a position for character! (New Char? - %s)", is_new or "false")
		end

		using_spawn_manager = true

		local success, result = pcall(function()
			utility:spawn_player(position, function()
				spawned_player_through_manager = true
			end)
		end)

		if not success then
			log.errorf("[qb:on_character_load] Failed to spawn player using `spawn_player`. (Got - %s)", result)
		end
	end

	if is_new and not qb_shared_config.support_starting_apartments then
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

	if not (is_new and qb_shared_config.support_starting_apartments) then
		TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
		TriggerEvent('QBCore:Client:OnPlayerLoaded')

		TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
		TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)

		TriggerEvent('qb-weathersync:client:EnableSync')
	else
		if not resource_core.selected_apartment.value() then
			return log.errorf("[qb:on_character_load] Selected apartment is somehow nil?")
		end

		local apartment_data = resource_core.selected_apartment.value()

		SetEntityCoords(resource_core.source_ped_id.value(), apartment_data.coords.x, apartment_data.coords.y, apartment_data.coords.z, false, false, false, false)

		log.debugf("Raw data (new ID - %s) - %s", apartment_data.id, json.encode(apartment_data.raw_data, { indent = true }))
		TriggerServerEvent("apartments:server:CreateApartment", apartment_data.raw_data.name, apartment_data.name, true)
	end

	if is_new and qb_shared_config.support_starting_apartments then
		TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
		TriggerEvent('QBCore:Client:OnPlayerLoaded')
	end

	if using_spawn_manager then
		local timeout = 12500
		local abort_at = GetGameTimer() + timeout

		Citizen.Trace("[qb:on_character_load] Waiting for spawn manager to fully spawn/load the selected player.")

		while not spawned_player_through_manager do
			if GetGameTimer() > abort_at then
				Citizen.Trace("[qb:on_character_load] Spawn manager timeout reached, proceeding anyway.")
				break
			end

			Citizen.Wait(100)
		end

		if not spawned_player_through_manager then
			log.warning("[qb:on_character_load] Spawn manager failed or timed out.")
		end
	else
		Citizen.Wait(3000)
	end

	interface.loading_container.toggle(false)

	if not (is_new and qb_shared_config.support_starting_apartments) then
		camera_manager:play_entry_transition(nil, is_new)
	end

	if not is_new or (is_new and qb_shared_config.support_starting_apartments) then return end

	interface.toaster.add_toast({
		title = locales.common("find_place_to_customize_char"),
		message = locales.common("find_place_to_customize_char_subtitle"),
		close_delay = 4000,
	})

	Citizen.Wait(4000)

	TriggerEvent('qb-clothes:client:CreateFirstCharacter')
end

return qb
