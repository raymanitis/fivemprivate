--#region Modules
local log = require("modules.utility.shared.logger")
local config = require("config.shared")
local enums = enums?.events?.client
local utility = require("modules.utility.shared.functions")
--#endregion

--#region
---Local function used to update the local player data
---@param core any
---@param data INewCharacterFormData
local function update_player_data(core, data)
	assert(core, "[update_player_data] Core/ESX Methods need to be passed to `update_player_data`")
	core.SetPlayerData("name", ("%s %s"):format(data.first_name, data.last_name))
	core.SetPlayerData("firstName", data.first_name)
	core.SetPlayerData("lastName", data.last_name)
	core.SetPlayerData("dateofbirth", data.date_of_birth)
	core.SetPlayerData("sex", data.sex)
	core.SetPlayerData("height", data.height)
end
--#endregion

---@type IFrameworkClient
---@diagnostic disable-next-line: missing-fields
local esx = {}
esx.__index = esx

function esx.new()
	local self = setmetatable({}, esx)

	if GetResourceState("es_extended") ~= "started" then
		log.errorf(
			"[esx.new] `es_extended` not found, make sure you haven't renamed it and it's started before the multicharacter.")
	end

	self.__name = "esx"
	self.core = exports["es_extended"]:getSharedObject()
	self.cache = {}

	---Called when the player has fully loaded & selected a character.
	---@param player_data any
	---@param is_new boolean
	---@param appearance_data any
	RegisterNetEvent("esx:playerLoaded", function(player_data, is_new, appearance_data)
		self:on_player_load(player_data, is_new, appearance_data)
	end)

	---Event used to update player data.
	---@param data INewCharacterFormData
	RegisterNetEvent(enums.esx_update_player_data, function(data)
		if GetInvokingResource() then return end

		update_player_data(self.core, data)
	end)

	RegisterNetEvent("esx:onPlayerLogout", function(...)
		if GetInvokingResource() then return end

		DoScreenFadeOut(250)

		resource_core:initialize_character_select()
	end)

	return self
end

function esx:should_init_char_select()
	Citizen.Wait(300)

	if LocalPlayer.state.has_logged_out then
		return true
	end

	return not self.core?.PlayerLoaded
end

function esx:on_character_selection_start()
	local core = self.core


	core.PlayerLoaded = false
	core.PlayerData = {}

	TriggerEvent("esx:loadingScreenOff")
end

function esx:set_ped_appearance(ped, data)
	TriggerEvent("skinchanger:loadSkin2", ped, data)
end

--- Called when a character has been selected.
---@param player_data IESXLoadedCharacterData
---@param is_new boolean
---@param appearance_data any
function esx:on_player_load(player_data, is_new, appearance_data)
	if not interface.loading_container.value() then
		interface.loading_container.toggle(true)
		log.debug("[esx::on_player_load] Interface loading screen was somehow not visible, toggling to true??")
	end

	local spawned_player_through_manager = false

	-- Needed to prevent race condition on ESX's part, `esx:onPlayerSpawn` needs to be triggered after `esx:playerLoaded` is fully done since ESX.PlayerData needs to get populated.
	Citizen.Wait(750)

	interface:toggle(false)

	local core = self.core

	is_new = is_new or not appearance_data or #appearance_data == 1

	if not resource_core._cache.camera_handlers.destroy_cam then
		RenderScriptCams(false, false, 0, false, false)
		log.warning("[esx::on_player_load] `destroy_cam` was somehow nil? (Fallback to RenderScriptsCam)")
	else
		resource_core._cache.camera_handlers.destroy_cam()
	end

	resource_core:refresh_player_variables()

	resource_core:on_player_load()

	if IsEntityPositionFrozen(resource_core.source_ped_id.value()) then
		FreezeEntityPosition(resource_core.source_ped_id.value(), false)
	end

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
		position = resource_core.active_character?.selected_spawn_point.coords
	end

	if not position then
		return log.errorf("[esx:on_player_load] No position found for character.")
	end

	local success, result = pcall(function()
		utility:spawn_player(position, function()
			spawned_player_through_manager = true
		end)
	end)

	if not success then
		log.errorf("[esx::on_player_load] Failed to spawn player using `spawn_player`. (Got - %s)", result)
	end

	if is_new then
		local model_string = resource_core.active_character?.sex == "male" and "mp_m_freemode_01" or "mp_f_freemode_01"
		local model = joaat(model_string)

		RequestModel(model)

		resource_core:wait_for_condition(HasModelLoaded, "esx::on_player_load::model", nil, nil, model)

		SetPlayerModel(core.playerId, model)

		SetModelAsNoLongerNeeded(model)

		resource_core:refresh_player_variables()

		local ped = resource_core.source_ped_id.value()

		for i = 0, 11 do
			SetPedComponentVariation(ped, i, 0, 0, 0)
		end

		ClearAllPedProps(ped)
	elseif not is_new then
		log.verbosef("[esx:on_player_load] Not a new character, loading appearance_data.")
		TriggerEvent("skinchanger:loadSkin", appearance_data)
	end

	while not spawned_player_through_manager do
		log.verbosef("[esx::on_player_load] Waiting for player to fully spawn.")
		Citizen.Wait(100)
	end

	resource_core:refresh_player_variables()

	TriggerServerEvent("esx:onPlayerSpawn")
	TriggerEvent("esx:onPlayerSpawn")
	TriggerEvent("esx:restoreLoadout")

	if IsScreenFadedOut() or IsScreenFadingOut() then
		DoScreenFadeIn(0)
	end

	interface.loading_container.toggle(false)

	camera_manager:play_entry_transition(nil, is_new)

	if not is_new then return end

	interface.toaster.add_toast({
		title = locales.common("find_place_to_customize_char"),
		message = locales.common("find_place_to_customize_char_subtitle"),
		close_delay = 4000,
	})

	Citizen.Wait(4000)

	TriggerEvent("esx_skin:openSaveableMenu")
end

function esx:on_registration_finalization(data)
	update_player_data(self.core, data)
end

function esx:setup_preview_character_appearance(char, ped, model)
	assert(char, "[esx:setup_preview_character_appearance] Invalid arguments passed.")

	local raw_char_data = char.raw_data --[[@as IESXRawCharacter]]

	if not raw_char_data?.skin?.model then
		if not raw_char_data.skin then
			---@diagnostic disable-next-line: missing-fields
			raw_char_data.skin = {}
		end

		raw_char_data.skin.model = model
	end

	TriggerEvent("skinchanger:loadSkin2", ped, raw_char_data.skin)
end

return esx
