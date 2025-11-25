---@class IQbxProperty
---@field id number
---@field property_name string
---@field coords string|vector3 @Stored as JSON string in DB, decoded to Vector3 in code
---@field owner string

--#region Modules
local log = require("modules.utility.shared.logger")
local qbox_sv_config = require("config.framework.server.qbox")
local starter_items = qbox_sv_config.get_starter_items()
local server_config = require("config.server")
-- local shared_config = require("config.shared")
-- local shared_utilities = require("modules.utility.shared.functions")
-- local client_enums = enums?.events.client
-- local enums = enums?.events?.server
--#endregion

---@type string
--#endregion

---@type IFrameworkServer
---@diagnostic disable-next-line: missing-fields
local qbox = {}
qbox.__index = qbox

function qbox.new()
	local self = setmetatable({}, qbox)

	if GetResourceState("qbx_core") ~= "started" then
		log.errorf("[qbox.new] `qbx_core` not found, make sure you haven't renamed it and it's started before the multicharacter.")
	end

	self.core = nil
	self.__name = "qbox"

	return self
end

function qbox:logout_client(client)
	local success, result = pcall(function()
		exports.qbx_core:Logout(client)
	end)

	if not success then
		return ("[qbox::logout_client] Failed to logout, got - %s"):format(result)
	end
end

function qbox:get_client_identifier(client)
	local license2, license = GetPlayerIdentifierByType(client, 'license2'), GetPlayerIdentifierByType(client, 'license')
	return { license2 = license2, license = license }
end

function qbox:get_player_properties(client, char)
	local raw_char_data = char?.raw_data --[[@as IQboxCharacterData]]

	assert(raw_char_data, "[qbox:get_player_properties] Raw char data is somehow nil?")

	return property_handler:get_character_properties(raw_char_data.citizenid)
end

--- Used to grab the properties for the selected characters.(func meant solely for qbx_properties, sepearate function used for external)
---@param chars ICharacter[]
---@return ICharacterApartment[]
function qbox:get_properties_for_characters(chars)
	assert(chars, "[qbox:get_properties_for_characters] Invalid arguments passed.")
	assert(GetResourceState("qbx_properties"):find("start"), "[qbox:get_properties_for_characters] ˜qbx_properties˜ isn't started, this function is solely meant for that.")
	local ids = {}

	for i = 1, #chars do
		local v = chars[i].raw_data --[[@as IQboxCharacterData]]

		if not v then
			log.verbosef("[qbox:get_properties_for_characters] Skipping index - %s (Reason - No value found)", i)
			goto continue
		end

		if not v.citizenid then
			log.warningf("[qbox:get_properties_for_characters] Index - %s has no citizen id.", i)
			goto continue
		end


		ids[#ids + 1] = v.citizenid

		::continue::
	end

	if #ids <= 0 then
		return {}
	end

	local placeholders = string.rep("?,", #ids):sub(1, -2)
	local query = ("SELECT id, property_name, coords, owner FROM properties WHERE owner IN (%s)"):format(placeholders)
	local rows = MySQL.query.await(query, ids)

	if not rows then return {} end

	log.debugf("[qbox:get_properties_for_characters] Rows - %s", json.encode(rows, { indent = true }))

	local apartments = {}

	for i = 1, #rows do
		local row = rows[i] --[[@as IQbxProperty]]

		if not row then goto continue end

		row.coords = type(row.coords) == "string" and json.decode(row.coords --[[@as string]]) or row.coords

		if not apartments[row.owner] then
			apartments[row.owner] = {}
		end

		local coords = row.coords
		local char_apartments = apartments[row.owner]

		char_apartments[#char_apartments + 1] = {
			id = row.id,
			name = row.property_name,
			entry_coords = {
				x = coords.x,
				y = coords.y,
				z = coords.z,
				heading = 0.0
			},
			owner = row.owner,
			raw_data = row
		}

		::continue::
	end

	log.debugf("[qbox:get_properties_for_characters] Retval - %s", json.encode(apartments, { indent = true }))

	return apartments
end

function qbox:get_characters_for_client(client_identifier)
	if type(client_identifier) ~= "table" then
		log.warningf("[qbox:get_characters_for_client] Invalid client identifier passed. (Got - %s)", client_identifier)
		return {}
	end

	local license, license2 = client_identifier.license, client_identifier.license2

	local result = MySQL.query.await([[
        SELECT
            p.citizenid, p.charinfo, p.money, p.job, p.gang, p.position, p.metadata,
            ps.skin as skin_data
        FROM players p
        LEFT JOIN playerskins ps ON ps.citizenid = p.citizenid AND ps.active = 1
        WHERE p.license = ? OR p.license = ?
        ORDER BY p.cid
    ]], { license, license2 })

	local chars_map = {}
	local chars = {}

	for i = 1, #result do
		local row = result[i]
		local citizenid = row.citizenid

		row.skin_data = type(row.skin_data) == "string" and json.decode(row.skin_data) or row.skin_data or {}

		if not chars_map[citizenid] then
			local charinfo = type(row.charinfo) == "string" and json.decode(row.charinfo) or row.charinfo
			local job = type(row.job) == "string" and json.decode(row.job) or row.job
			local position = type(row.position) == "string" and json.decode(row.position) or row.position
			-- local money = type(row.money) == "string" and json.decode(row.money) or row.money
			-- local metadata = type(row.metadata) == "string" and json.decode(row.metadata) or row.metadata

			---@type ICharacter
			local char_data = {
				first_name = charinfo.firstname,
				last_name = charinfo.lastname,
				date_of_birth = charinfo.birthdate,
				id = charinfo.cid,
				job_grade = job.grade.name,
				job_title = job.label,
				last_played = "N/A",
				selected_spawn_point = {
					label = "Last Location",
					id = "last_location",
					coords = {
						heading = position.w,
						x = position.x,
						y = position.y,
						z = position.z
					}
				},
				sex = charinfo.gender == 1 and "female" or "male",
				disabled = false,
				properties_loaded = false,
				apartments = {},
				position = {
					heading = position.w,
					x = position.x,
					y = position.y,
					z = position.z
				},
				raw_data = row
			}

			chars_map[citizenid] = char_data
			chars[#chars + 1] = char_data
		end
	end

	-- Disabled: qbx_properties integration disabled - using external property handler instead
	-- if GetResourceState("qbx_properties"):find("start") then
	-- 	local properties = self:get_properties_for_characters(chars)

	-- 	if properties and next(properties) then
	-- 		log.info("[qbox:get_characters_for_client] `qbx_properties` is started, and properties are valid.")
	-- 		for i = 1, #chars do
	-- 			local char = chars[i] --[[@as ICharacter]]

	-- 			if not char then goto continue end

	-- 			local raw_data = char.raw_data --[[@as IQboxCharacterData]]

	-- 			if not properties[raw_data.citizenid] then
	-- 				log.verbosef("[qbox:get_characters_for_client] No properties found for character. (Char - %s", (char.first_name .. char.last_name) or "nil", type(properties[raw_data.citizenid]))
	-- 				goto continue
	-- 			end

	-- 			char.apartments = properties[raw_data.citizenid]
	-- 			char.properties_loaded = true

	-- 			::continue::
	-- 		end
	-- 	end
	-- end

	return chars
end

function qbox:handle_char_select(client, char)
	local char_raw_data = char.raw_data --[[@as IQboxCharacterData]]
	local success = exports.qbx_core:Login(client, char_raw_data.citizenid)

	if not success then
		return ("An unknown error occurred while logging player in. (Got - %s)"):format(success)
	end

	return nil
end

function qbox:is_name_unique(first_name, last_name)
	-- NOTE: Not implemented in Qbox. Player names are stored inside the JSON-serialized `charinfo` column.
	-- Checking uniqueness would require fetching & deserializing all records, which is too inefficient.
	-- Always returns true.
	return true
end

function qbox:register_new_character(client, data)
	local qbox_data = {
		charinfo = {
			firstname = data.first_name,
			lastname = data.last_name,
			nationality = data.nationality,
			gender = data.sex == "female" and 1 or 0,
			birthdate = data.date_of_birth,
			cid = data.index
		}
	}

	local success = exports.qbx_core:Login(client, nil, qbox_data)

	if not success then
		return nil, ("Failed to create new character - %s"):format(success)
	end

	assert(GetResourceState("ox_inventory"):find("start"), "[qbox::register_new_character] Required resource - `ox_inventory` not found.")

	while not exports.ox_inventory:GetInventory(client) do
		Citizen.Wait(100)
	end

	for i = 1, #starter_items do
		local item = starter_items[i]

		if not item then
			log.warningf("[qbox:register_new_character] Skipping starter item since no value was found. (Index - %s)", i)
			goto continue
		end

		if item.metadata and type(item.metadata) == 'function' then
			exports.ox_inventory:AddItem(client, item.name, item.amount, item.metadata(client --[[@as integer]]))
		else
			exports.ox_inventory:AddItem(client, item.name, item.amount, item.metadata --[[@as unknown]])
		end

		::continue::
	end

	return data, nil
end

function qbox:delete_character(_client, char)
	local raw_char_data = char.raw_data --[[@as IQboxCharacterData]]
	exports.qbx_core:DeleteCharacter(raw_char_data.citizenid)
	return true
end

function qbox:get_client_max_slots(identifiers)
	assert(type(identifiers) == "table", "[qbox:get_client_max_slots] Invalid type for identifiers recieved.")

	local overrides = server_config.maximum_player_slots.overrides

	return overrides[identifiers.license2]
		or (identifiers.license and overrides[identifiers.license])
		or nil
end

return qbox
