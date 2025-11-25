--#region Modules
local log = require("modules.utility.shared.logger")
local config = require("config.framework.server.esx")
local server_config = require("config.server")
local shared_config = require("config.shared")
local shared_utilities = require("modules.utility.shared.functions")
local framework_config = require("config.framework.server.esx")
local client_enums = enums?.events.client
local enums = enums?.events?.server
--#endregion

--#region Constants
---@type string
local PRIMARIY_IDENTIFIER
local ONESYNC_STATE = GetConvar("onesync", "off")
--#endregion

--#region Framework related function
---Fetches the player's slots if it exists from the db, returns the default slots if it doesn't exist.
---@param identifier string
---@return integer|unknown
local function query_get_client_slots(identifier)
	return MySQL.scalar.await("SELECT slots FROM multicharacter_slots WHERE identifier = ?", { identifier })
		or nil
end

---Credit: https://github.com/esx-framework/esx_core/blob/main/%5Bcore%5D/esx_identity/server/main.lua#L47
---@param str string
---@return boolean
local function validate_dob_format(str)
	local registration_options = shared_config.registration_options

	str = tostring(str)
	if not string.match(str, "(%d%d)/(%d%d)/(%d%d%d%d)") then
		return false
	end

	local d, m, y = string.match(str, "(%d+)/(%d+)/(%d+)")

	m = tonumber(m)
	d = tonumber(d)
	y = tonumber(y)

	if ((d <= 0) or (d > 31)) or ((m <= 0) or (m > 12)) or ((y <= registration_options.date_of_birth.min_year) or (y > registration_options.date_of_birth.max_year)) then
		return false
	elseif m == 4 or m == 6 or m == 9 or m == 11 then
		return d <= 30
	elseif m == 2 then
		if y % 400 == 0 or (y % 100 ~= 0 and y % 4 == 0) then
			return d <= 29
		else
			return d <= 28
		end
	else
		return d <= 31
	end
end

---Credit: https://github.com/esx-framework/esx_core/blob/main/%5Bcore%5D/esx_identity/server/main.lua#L74-L85
---@param str string
---@return string
local function format_date(str)
	assert(str, "[format_date] Invalid arguments passed.")

	local d, m, y = string.match(str, "(%d+)/(%d+)/(%d+)")
	local date = str
	local registration_options = shared_config.registration_options

	if registration_options.date_of_birth.format == "MM/DD/YYYY" then
		date = m .. "/" .. d .. "/" .. y
	elseif registration_options.date_of_birth.format == "YYYY/MM/DD" then
		date = y .. "/" .. m .. "/" .. d
	end

	return date
end

---Validates the format of the character data
---@param data INewCharacterFormData
---@return boolean, string|nil Whether it's valid or not and a message.
local function validate_new_character_data(data)
	local registration_options = shared_config.registration_options

	if string.match(data.first_name, "[^a-zA-Z]") then
		return false, "First name must only contain letters."
	end

	if string.match(data.last_name, "[^a-zA-Z]") then
		return false, "Last name must only contain letters."
	end

	if data.first_name:len() > registration_options.first_name.max_length or data.first_name:len() < registration_options.first_name.min_length then
		return false, ("Please make sure your first name is a minimum of %s letters and a maximum of %s!"):format(registration_options.first_name.min_length, registration_options.first_name.max_length)
	end

	if data.last_name:len() > registration_options.last_name.max_length or data.last_name:len() < registration_options.last_name.min_length then
		return false, ("Please make sure your last name is a minimum of %s letters and a maximum of %s!"):format(registration_options.last_name.min_length, registration_options.last_name.max_length)
	end

	if not data.sex or (data.sex ~= "male" and data.sex ~= "female") then return false, "An unkown error occurred, character sex was invalid." end

	if not string.match(data.date_of_birth, "(%d%d)/(%d%d)/(%d%d%d%d)") or not validate_dob_format(data.date_of_birth) then
		return false, ("Your DOB is not valid. %s (%s) (%s)"):format(string.match(data.date_of_birth, "(%d%d)/(%d%d)/(%d%d%d%d)"), validate_dob_format(data.date_of_birth), data.date_of_birth)
	end

	if not data.height or (data.height > registration_options.height.max or data.height < registration_options.height.min) then
		return false, "The specified height is not within the allowed range."
	end

	return true
end

---Sets the clients data on the ESX part.
---@param player any
---@param data INewCharacterFormData
local function set_client_data(player, data)
	assert(player and data, "[set_client_data] Invalid arguments passed.")

	local full_name = ("%s %s"):format(data.first_name, data.last_name)
	local client_state = Player(player.source).state

	player.setName(full_name)
	player.set("firstName", data.first_name)
	player.set("lastName", data.last_name)
	player.set("dateofbirth", data.date_of_birth)
	player.set("sex", data.sex)
	player.set("height", data.height)

	client_state:set("name", full_name, true)
	client_state:set("firstName", data.first_name, true)
	client_state:set("lastName", data.last_name, true)
	client_state:set("dateofbirth", data.date_of_birth, true)
	client_state:set("sex", data.sex, true)
	client_state:set("height", data.height, true)
end

---Registers a new character in the DB.
---@param identifier string
---@param data INewCharacterFormData
local function register_new_identity_in_db(identifier, data)
	MySQL.update.await("UPDATE users SET firstname = ?, lastname = ?, dateofbirth = ?, sex = ?, height = ? WHERE identifier = ?",
		{ data.first_name, data.last_name, data.date_of_birth, data.sex, data.height, identifier })
end

--#endregion


---@type IFrameworkServer
---@diagnostic disable-next-line: missing-fields
local esx = {}
esx.__index = esx

function esx.new()
	local self = setmetatable({}, esx)

	if GetResourceState("es_extended") ~= "started" then
		log.errorf("[esx.new] `es_extended` not found, make sure you haven't renamed it and it's started before the multicharacter.")
	end

	self.core = exports["es_extended"]:getSharedObject()
	self.__name = "esx"
	self.core.Players = {}

	PRIMARIY_IDENTIFIER = self.core.GetConfig().Identifier or GetConvar("sv_lan", "") == "true" and "ip" or "license"

	self:reset_player_list()
	return self
end

function esx:get_player_properties(client, char)
	local raw_data = char?.raw_data --[[@as IESXRawCharacter]]

	assert(raw_data, "[esx:get_player_properties] Raw Data is somehow nil?")

	return property_handler:get_character_properties(raw_data.identifier)
end

function esx:is_name_unique(first_name, last_name)
	local result = MySQL.prepare.await("SELECT 1 FROM `users` WHERE `firstname` = ? AND `lastname` = ? LIMIT 1", { first_name, last_name })

	if result then
		log.verbosef("[esx::is_name_unique] Name already exists. (Name - %s)", ("%s %s"):format(first_name, last_name))
		return false
	end

	return true
end

function esx:logout_client(client)
	TriggerEvent("esx:playerLogout", client)
end

function esx:get_client_identifier(client)
	local is_fxdk = GetConvarInt("sv_fxdkMode", 0)

	if is_fxdk == 1 then
		return "ESX-DEBUG-LICENSE"
	end

	local identifier = GetPlayerIdentifierByType(client, PRIMARIY_IDENTIFIER)
	return identifier and identifier:gsub(PRIMARIY_IDENTIFIER .. ":", "")
end

function esx:get_characters_for_client(client_identifier)
	local core = self.core
	local prefix = framework_config.identifier_prefix

	local client_identifier = ("%s%s%s"):format(prefix, "%:", client_identifier)
	local raw_characters = MySQL.query.await(
		"SELECT identifier, accounts, job, job_grade, firstname, lastname, dateofbirth, sex, position, skin, disabled FROM users WHERE identifier LIKE ?",
		{ client_identifier }
	)
	local characters

	if not raw_characters then
		return {}, {}
	end

	local character_count = #raw_characters

	---@type ICharacter[]
	characters = table.create(0, character_count)
	local active_characters = {}

	for i = 1, character_count, 1 do
		local character = raw_characters[i]

		if not character then goto continue end

		character.skin = json.decode(character.skin)

		local job, grade = character.job or "unemployed", tostring(character.job_grade)

		if core.Jobs[job] and core.Jobs[job].grades[grade] then
			grade = job == "unemployed" and "" or core.Jobs[job].grades[grade].label
			job = core.Jobs[job].label
		end

		-- local decoded_accounts = json.decode(character.accounts)
		local validated_id = string.sub(character.identifier, #prefix + 1, string.find(character.identifier, ":") - 1)

		local numbered_id = tonumber(validated_id)

		if not numbered_id then
			log.warningf("[esx:get_characters_for_client] Failed to grab numbered_id for char: %s", json.encode(character, { indent = true }))
			goto continue
		end

		if type(character.disabled) == "number" then
			character.disabled = character.disabled == 1
		end

		-- local decoded_accounts = json.decode(character.accounts)

		character.accounts = character.accounts and json.decode(character.accounts) or {}

		---@type IPosition | nil
		local position = character.position and json.decode(character.position) or nil
		local data = {
			id = numbered_id,
			first_name = character.firstname,
			last_name = character.lastname,
			date_of_birth = character.dateofbirth,
			job_grade = grade,
			job_title = job,
			job = job,
			last_played = "N/A",
			position = character.position and json.decode(character.position) or nil --[[@as IPlayerPosition]],
			selected_spawn_point = {
				label = "Last Location",
				id = "last_location",
				coords = position,
			},
			apartments = {},
			sex = character.sex == "m" and "male" or "female",
			disabled = character.disabled,
			raw_data = character
		}

		characters[#characters + 1] = data

		if not data.disabled then
			active_characters[#active_characters + 1] = data
		end

		::continue::
	end

	return characters, active_characters
end

function esx:on_client_connect(client, deferrals)
	deferrals.defer()

	Citizen.Wait(0)

	if not SetEntityOrphanMode then
		return deferrals.done("[vx_multicharacter] ESX Requires a minimum artifact version of 10188, please update your artifacts.")
	end

	if ONESYNC_STATE ~= "on" then
		return deferrals.done(("[vx_multicharacter] ESX Requires Onesync Infinity to work. This server currently has Onesync set to: %s"):format(ONESYNC_STATE))
	end

	local client_identifier = self:get_client_identifier(client --[[@as string]])

	if not client_identifier then
		return deferrals.done(("[vx_multicharacter] Unable to retrieve player identifier.\nIdentifier type: %s"):format(PRIMARIY_IDENTIFIER))
	end

	local core = self.core

	if core.GetConfig().EnableDebug then
		return deferrals.done()
	end

	if core.Players[client_identifier] then
		return deferrals.done(("[vx_multicharacter] A player is already connected to the server with this identifier.\nYour identifier: %s:%s"):format(PRIMARIY_IDENTIFIER, client_identifier))
	end

	deferrals.done()
end

function esx:handle_char_select(client, character)
	local core = self.core
	local prefix = framework_config.identifier_prefix
	local client_identifier = self:get_client_identifier(client)

	if not core.GetConfig().EnableDebug then
		local identifier = ("%s%s:%s"):format(prefix, character.id, client_identifier)

		log.debugf("[esx:handle_play] Identifier: %s (Org - %s) (Id - %s)", identifier, ("%s%s"):format(prefix, character.id), character.id)

		if core.GetPlayerFromIdentifier(identifier) then
			DropPlayer(client, ("[Multicharacter] Someone with the same identifier is already connected to the server.\nIdentifier: %s"):format(identifier))
			return nil
		end
	end

	TriggerEvent("esx:onPlayerJoined", client, ("%s%s"):format(prefix, character.id))
	core.Players[client_identifier] = true

	return nil
end

function esx:delete_character(client, char)
	local prefix = framework_config.identifier_prefix
	local identifier = ("%s%s:%s"):format(prefix, char.id, self:get_client_identifier(client --[[@as string]]))

	if not config.database.cleanup then
		MySQL.update.await("UPDATE `users` SET `disabled` = 1 WHERE `identifier` = ?", { identifier })
		log.verbosef("[esx::delete_character] Full cleanup of the database is disabled.")
		return true
	end

	local query = "DELETE FROM `%s` WHERE %s = ?"
	local queries = {}

	for i = 1, #config.database.tables do
		local table = config.database.tables[i]

		if not table or type(table) ~= "table" then goto continue end

		if not table?.name or not table?.column then
			log.warningf("[esx::delete_character] Invalid value encountered on the table? (Name - %s) (Col Name - %s) (Index - %s)", table?.name or "nil", table?.column or "nil", i)
			goto continue
		end

		queries[#queries + 1] = { query = query:format(table.name, table.column), values = { identifier } }

		::continue::
	end

	log.debugf("[esx:delete_character] (Identifier - %s)", identifier)

	local success = MySQL.transaction.await(queries)

	return success
end

function esx:register_new_character(client, data)
	data.date_of_birth = format_date(data.date_of_birth)

	local success, err = validate_new_character_data(data)

	if not success then return nil, err end

	local core = self.core
	local player = core.GetPlayerFromId(client)

	data.first_name = shared_utilities.format_name(data.first_name)
	data.last_name = shared_utilities.format_name(data.last_name)
	data.sex = data.sex == "male" and "m" or "f" --[[@as string]]

	if player then
		set_client_data(player, data)
		register_new_identity_in_db(player.identifier, data)

		log.debugf("[esx::register_new_character] Player isn't nil, setting client data.")

		return data
	end

	local identifier = ("%s%s"):format(framework_config.identifier_prefix, data.index)
	local full_identifier = ("%s:%s"):format(identifier, self:get_client_identifier(client))

	local exists = MySQL.scalar.await(
		"SELECT 1 FROM `users` WHERE `identifier` = ? LIMIT 1",
		{ full_identifier }
	)

	log.debugf("[esx::register_new_character] Does identifier exist?: %s (Identifier - %s)", exists or "nil", full_identifier or "nil")

	if exists then
		return nil, "Index sent from the resource was invalid as it already exists."
	end

	core.Players[self:get_client_identifier(client)] = true

	TriggerEvent("esx:onPlayerJoined", client, identifier, {
		firstname = data.first_name,
		lastname = data.last_name,
		dateofbirth = data.date_of_birth,
		sex = data.sex,
		height = data.height
	})

	log.debugf("[esx::register_new_character] Successfully registered new character\ndata: %s\n client: %s", json.encode(data, { indent = true }), client)

	return data
end

function esx:get_sql_query()
	return [[
	CREATE TABLE IF NOT EXISTS `multicharacter_slots` (
		`identifier` VARCHAR(60) NOT NULL,
		`slots` INT(11) NOT NULL,
		PRIMARY KEY (`identifier`) USING BTREE,
		INDEX `slots` (`slots`) USING BTREE
	) ENGINE=InnoDB;
	]]
end

function esx:on_client_exit(client)
	self.core.Players[self:get_client_identifier(client)] = nil
end

---Primarily used to reset the esx player list on startup.
function esx:reset_player_list()
	local core = self.core

	if not next(core.Players) then
		return
	end

	local players = table.clone(core.Players)

	table.wipe(core.Players)

	for _, v in pairs(players) do
		if not v?.source then goto continue end

		core.Players[self:get_client_identifier(v.source)] = true

		::continue::
	end
end

function esx:on_database_connection_ready()
	MySQL.query.await([[
			CREATE TABLE IF NOT EXISTS `multicharacter_slots` (
				`identifier` VARCHAR(60) NOT NULL,
				`slots` INT(11) NOT NULL,
				PRIMARY KEY (`identifier`) USING BTREE,
				INDEX `slots` (`slots`) USING BTREE
			) ENGINE=InnoDB;
		]])

	MySQL.query.await([[
			ALTER TABLE `users`
			ADD COLUMN IF NOT EXISTS `disabled` TINYINT(1) NULL DEFAULT '0';
		]])

	local result = MySQL.prepare.await([[
			SELECT identifier
			FROM users
			LIMIT 1
		]]) --[[@as string]]

	if not result or type(result) ~= "string" then return log.verbosef("[esx:on_database_connection_ready] Result for prefix was invalid - %s", result) end

	local prefix = string.match(result, "([^:]+)")

	if not prefix then
		return log.warningf("Failed to extract prefix: input string does not contain ':' or is nil")
	end

	local cleanedPrefix = string.match(prefix, "^(%a+)")

	if not cleanedPrefix then
		return log.warningf("Failed to clean prefix: no alphabetic characters found before the number in prefix '%s'", prefix)
	end

	framework_config.identifier_prefix = cleanedPrefix

	log.infof("[ESX] Identifier prefix successfully set to '%s'", cleanedPrefix)
end

function esx:get_client_max_slots(identifier)
	assert(identifier and type(identifier) == "string", "[esx:get_client_max_slots] Invalid identifier recieved.")

	if server_config.maximum_player_slots.overrides[identifier] then
		return server_config.maximum_player_slots.overrides[identifier]
	end

	return query_get_client_slots(identifier)
end

return esx
