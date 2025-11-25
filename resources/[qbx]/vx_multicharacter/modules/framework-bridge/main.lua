---@alias IFrameworkTypes "qb" | "esx" | "ox" | "qbox" | "nd" | "custom" | "none"

local log = require("modules.utility.shared.logger")
local config = require("config.shared")

if not config.disable_auto_detection and config.framework == "none" then
	---@type IFrameworkTypes[]
	local FRAMEWORK_TITLES = { "esx", "qbox", "qb" }
	local FRAMEWORK_RESOURCE_NAMES = { "es_extended", "qbx_core", "qb-core" }

	for i = 1, #FRAMEWORK_RESOURCE_NAMES do
		if GetResourceState(FRAMEWORK_RESOURCE_NAMES[i]):find("start") then
			config.framework = FRAMEWORK_TITLES[i]
			log.infof("[FRAMEWORK_BRIDGE::MAIN] Auto detected framework - \"%s\"", FRAMEWORK_RESOURCE_NAMES[i])
			break
		end
	end
end

if config.framework == "none" then
	return log.errorf("[framework_bridge::main] Failed to auto-detect framework.")
end

---@type boolean, IFrameworkClient|IFrameworkServer?
local success, result = pcall(require, ("modules.framework-bridge.%s.%s"):format(IsDuplicityVersion() and "server" or "client", config.framework))

if not success or not result then
	return log.errorf("[FRAMEWORK_BRIDGE::CLIENT::MAIN] Failed to load framework (Framework - %s)\nError - %s", config.framework, result)
end

return result.new()
