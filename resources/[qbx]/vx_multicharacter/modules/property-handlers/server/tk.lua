---@class ITkHousingRetVal
---@field id number|string
---@field label string
---@field name string
---@field price number
---@field type string
---@field coords vector3|vector4
---@field owner string
---@field citizenid string

local log = require("modules.utility.shared.logger")

---@type IPropertyHandler
---@diagnostic disable-next-line: missing-fields
local tk_housing = {}
tk_housing.__index = tk_housing

function tk_housing.new()
	local self = setmetatable({}, tk_housing)

	return self
end

function tk_housing:get_character_properties(char_identifier)
	---@type boolean, ITkHousingRetVal[]?
	local success, result = pcall(function()
		-- Try common tk_housing export patterns
		if exports.tk_housing and exports.tk_housing.GetProperties then
			return exports.tk_housing:GetProperties(char_identifier)
		elseif exports.tk_housing and exports.tk_housing.GetPlayerProperties then
			return exports.tk_housing:GetPlayerProperties(char_identifier)
		elseif exports.tk_housing and exports.tk_housing.GetAllProperties then
			return exports.tk_housing:GetAllProperties(char_identifier)
		else
			-- Fallback: try direct MySQL query if exports don't work
			return nil
		end
	end)

	if not success then
		log.warningf("[tk_housing::get_character_properties] Callback failed - %s", result)
		return {}
	end

	if not result or type(result) ~= "table" then
		log.warningf("[tk_housing::get_character_properties] Result is somehow not a table? Got - %s", result)
		return {}
	end

	---@type ICharacterApartment[]
	local apartments = {}

	for i = 1, #result do
		local v = result[i]

		if not v then goto continue end

		---@type IPosition
		local coords = {
			x = v.coords and v.coords.x or 0.0,
			y = v.coords and v.coords.y or 0.0,
			z = v.coords and v.coords.z or 0.0,
			heading = (v.coords and v.coords.w) or (v.coords and v.coords.heading) or 0.0
		}

		-- Try to get property data if available (for entry coords)
		if v.id then
			local success_data, property_data = pcall(function()
				if exports.tk_housing and exports.tk_housing.GetPropertyData then
					return exports.tk_housing:GetPropertyData(v.id)
				elseif exports.tk_housing and exports.tk_housing.GetPropertyInfo then
					return exports.tk_housing:GetPropertyInfo(v.id)
				end
				return nil
			end)

			if success_data and property_data then
				-- Use entry coords if available
				if property_data.entry_coords then
					coords = {
						x = property_data.entry_coords.x,
						y = property_data.entry_coords.y,
						z = property_data.entry_coords.z,
						heading = property_data.entry_coords.w or property_data.entry_coords.heading or 0.0
					}
				elseif property_data.coords then
					coords = {
						x = property_data.coords.x,
						y = property_data.coords.y,
						z = property_data.coords.z,
						heading = property_data.coords.w or property_data.coords.heading or 0.0
					}
				elseif property_data.enterCoords then
					coords = {
						x = property_data.enterCoords.x,
						y = property_data.enterCoords.y,
						z = property_data.enterCoords.z,
						heading = property_data.enterCoords.w or property_data.enterCoords.heading or 0.0
					}
				end
			end
		end

		apartments[#apartments + 1] = {
			id = v.id,
			name = v.label or v.name or ("Property #%s"):format(v.id),
			entry_coords = coords,
			owner = char_identifier
		}

		::continue::
	end

	return apartments
end

return tk_housing

