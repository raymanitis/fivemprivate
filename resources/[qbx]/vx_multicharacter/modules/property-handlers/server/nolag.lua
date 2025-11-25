---@class INoLagRetVal
---@field id number
---@field label string
---@field price number
---@field type string
---@field doorLocked boolean
---@field coords vector3|vector4
---@field hasKey boolean

local log = require("modules.utility.shared.logger")

---@type IPropertyHandler
---@diagnostic disable-next-line: missing-fields
local nolag_properties = {}
nolag_properties.__index = nolag_properties

function nolag_properties.new()
	local self = setmetatable({}, nolag_properties)

	return self
end

function nolag_properties:get_character_properties(char_identifier)
	---@type boolean, INoLagRetVal[]?
	local success, result = pcall(function()
		return exports.nolag_properties:GetAllProperties(char_identifier, 'user', true)
	end)

	if not success then
		log.warningf("[nl_properties::get_character_properties] Callback failed - %s", result)
		return {}
	end

	if type(result) ~= "table" then
		log.warningf("[nl_properties::get_character_properties] Result is somehow not a table? Got - %s", result)
		return {}
	end

	---@type ICharacterApartment[]
	local apartments = {}

	for i = 1, #result do
		local v = result[i]

		if not v then goto continue end

		---@type boolean, {buildingId?: string, metadata: {enterData: vector4, exitCoords: vector4}}?
		local success, result = pcall(function()
			return exports.nolag_properties:GetPropertyData(v.id)
		end)

		---@type IPosition
		local coords = {
			x = v.coords.x,
			y = v.coords.y,
			z = v.coords.z,
			heading = v.coords.w or 0.0
		}

		if not success then
			log.warningf("[nl_properties::get_character_properties] Internal callback failed - %s", result)
		elseif result and result?.metadata then
			local metadata = result.metadata

			if result?.buildingId then
				coords = {
					x = metadata.enterData.x,
					y = metadata.enterData.y,
					z = metadata.enterData.z,
					heading = metadata.enterData.w or 0.0
				}
			else
				coords = {
					x = metadata.exitCoords.x,
					y = metadata.exitCoords.y,
					z = metadata.exitCoords.z,
					heading = metadata.exitCoords.w or 0.0

				}
			end
		end


		apartments[#apartments + 1] = {
			id = v.id,
			name = v.label,
			entry_coords = coords,
			owner = char_identifier
		}

		::continue::
	end

	return apartments
end

return nolag_properties
