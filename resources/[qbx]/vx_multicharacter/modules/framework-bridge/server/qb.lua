--#region Modules
local log = require("modules.utility.shared.logger")
local server_config = require("config.server")
--#endregion

---@type IFrameworkServer
---@diagnostic disable-next-line: missing-fields
local qb = {}
qb.__index = qb

function qb.new()
	local self = setmetatable({}, qb)

	if GetResourceState("qb-core") ~= "started" then
		log.errorf("[qb.new] `qb-core` not found, make sure you haven't renamed it and it's started before the multicharacter.")
	end

	self.core = exports['qb-core']:GetCoreObject()
	self.__name = "qb"

	return self
end

function qb:get_player_properties(client, char)
	local raw_data = char?.raw_data --[[@as IQBRawCharacterData]]

	assert(raw_data, "[qb:get_player_properties] Raw data is somehow nil?")

	return property_handler:get_character_properties(raw_data.citizenid)
end

function qb:logout_client(client)
	self.core.Player.Logout(client)
end

function qb:get_client_identifier(client)
	log.debugf("[qb:get_client_identifier] Response from Core - %s", json.encode(self.core.Functions.GetIdentifier(client, 'license'), { indent = true }))
	return self.core.Functions.GetIdentifier(client, 'license')
end

function qb:get_client_max_slots(identifier)
	assert(type(identifier) == "string", "[qb:get_client_max_slots] Invalid type for identifiers recieved.")

	return server_config.maximum_player_slots.overrides[identifier]
end

function qb:delete_character(client, char)
	assert(char and char?.raw_data, "[qb:delete_character] Invalid data passed.")

	local raw_char_data = char.raw_data --[[@as IQBRawCharacterData]]
	self.core.Player.DeleteCharacter(client, raw_char_data.citizenid)

	return true
end

function qb:is_name_unique(first_name, last_name)
	-- NOTE: Not implemented in QB. Player names are stored inside the JSON-serialized `charinfo` column.
	-- Checking uniqueness would require fetching & deserializing all records, which is too inefficient.
	-- Always returns true.
	return true
end

function qb:register_new_character(client, data)
	log.debugf("[qb::register_new_character] Registering new character with data - %s", json.encode(data, { indent = true }))
	local qb_data = {
		cid = data.index,
		charinfo = {
			firstname = data.first_name,
			lastname = data.last_name,
			nationality = data.nationality,
			birthdate = data.date_of_birth,
			gender = data.sex == "male" and 0 or 1,
			cid = data.index
		}
	}

	local success = self.core.Player.Login(client, false, qb_data)

	if not success then
		return data, ("Unable to register new character, got - %s"):format(success)
	end

	---@type {amount: integer, item: string}[]
	local items = self.core.Shared.StarterItems
	local player = self.core.Functions.GetPlayer(client)

	for _, v in pairs(items) do
		local metadata = {}

		if v.item == "id_card" then
			metadata.citizenid = player.PlayerData.citizenid
			metadata.firstname = player.PlayerData.charinfo.firstname
			metadata.lastname = player.PlayerData.charinfo.lastname
			metadata.birthdate = player.PlayerData.charinfo.birthdate
			metadata.gender = player.PlayerData.charinfo.gender
			metadata.nationality = player.PlayerData.charinfo.nationality
		end

		if v.item == "driver_license" then
			metadata.firstname = player.PlayerData.charinfo.firstname
			metadata.lastname = player.PlayerData.charinfo.lastname
			metadata.birthdate = player.PlayerData.charinfo.birthdate
			metadata.type = 'Class C Driver License'
		end

		pcall(function()
			exports['qb-inventory']:AddItem(client, v.item, v.amount, false, metadata, 'qb-multicharacter:GiveStarterItems')
		end)
	end

	return data
end

function qb:handle_char_select(client, char)
	local raw_char_data = char.raw_data --[[@as IQBRawCharacterData]]
	local success = self.core.Player.Login(client, raw_char_data.citizenid)

	if not success then
		return ("An unknown error occurred while logging player in. (Got - %s)"):format(success)
	end

	return nil
end

function qb:get_characters_for_client(client_identifier)
	local result = MySQL.query.await([[
		SELECT
			p.*,
			ps.model,
			ps.skin as skin_data
		FROM `players` p
		LEFT JOIN `playerskins` ps ON ps.citizenid = p.citizenid AND ps.active = 1
		WHERE p.license = ?
		]], { client_identifier }) --[[@as IQBRawCharacterData[]]
	---@type ICharacter[]
	local chars = {}

	if not result then return {} end

	for i = 1, #result do
		local v = result[i]

		if not v then goto continue end

		v.charinfo = type(v.charinfo) == "string" and json.decode(v.charinfo --[[@as string]]) or v.charinfo
		v.position = type(v.position) == "string" and json.decode(v.position --[[@as string]]) or v.position
		v.job = type(v.job) == "string" and json.decode(v.job --[[@as string]]) or v.job
		v.skin_data = type(v.skin_data) == "string" and json.decode(v.skin_data --[[@as string]]) or v.skin_data
		v.skin_data?.model = v.model

		chars[#chars + 1] = {
			id = v.cid,
			last_played = "N/A",
			first_name = v.charinfo?.firstname,
			last_name = v.charinfo?.lastname,
			date_of_birth = v.charinfo?.birthdate,
			sex = v.charinfo?.gender == 0 and "male" or "female",
			properties_loaded = false,
			disabled = false,
			position = { x = v.position?.x, y = v.position?.y, z = v.position?.z, heading = 0 },
			selected_spawn_point = {
				id = "last_location",
				label = "Last Location",
				coords = {
					x = v.position?.x,
					y = v.position?.y,
					z = v.position?.z,
					heading = 0
				},
			},
			job_grade = v.job?.grade?.name,
			job_title = v.job?.label,
			apartments = {},
			raw_data = v,

		}
		::continue::
	end

	return chars
end

return qb
