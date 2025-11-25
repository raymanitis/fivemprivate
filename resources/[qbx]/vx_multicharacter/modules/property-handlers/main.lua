local log = require("modules.utility.shared.logger")
local config = require("config.shared")

if not config.disable_auto_detection and config.property_system == "none" then
	local SUPPORTED_RESOURCES = { "nolag_properties", "tk_housing" }
	local PROPERTIES_INDEX = { "nolag", "tk" }


	for i = 1, #SUPPORTED_RESOURCES do
		if GetResourceState(SUPPORTED_RESOURCES[i]):find("start") then
			config.property_system = PROPERTIES_INDEX[i] or "none"
			log.infof("[property_handler::main] Auto dtected system - %s", SUPPORTED_RESOURCES[i])
			break
		end
	end
end

if config.property_system == "none" then return log.verbose(
	"[property_handler::main] No property system was auto-detected or found, returning.") end

---@type boolean, IPropertyHandler?
local success, result = pcall(require, ("modules.property-handlers.server.%s"):format(config.property_system))

if not success or not result then
	return log.warningf("[property_handler::main] Failed to load module for property system - %s, got - %s",
		config.property_systema, result or "nil")
end

---@diagnostic disable-next-line: undefined-field
return result.new()
