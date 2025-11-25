--#region Modules
local log = require("modules.utility.shared.logger")
--#endregion

---@class IQboxCoreStarterItems
---@field name string
---@field amount integer
---@field metadata fun(client: integer): table

---@class IQboxSharedConfigResponse
---@field serverName string
---@field defaultSpawn vector4
---@field notifyPosition string
---@field starterItems IQboxCoreStarterItems

return {
	--- Gets the starter items.
	---@return IQboxCoreStarterItems[]
	get_starter_items = function()
		if GetResourceState("qbx_core") == "missing" then
			log.warningf("[qbox::get_starter_items] `qbx_core` is missing, returning nothing.")
			return {}
		end

		local data = LoadResourceFile("qbx_core", "config/shared.lua")

		if not data then return {} end

		local success, result = pcall(load, data)

		if not success then
			log.warningf("[qbox::get_starter_items] Failed to load Lua code (Got - %s)", result)
			return {}
		end

		---@type boolean, IQboxSharedConfigResponse?
		local execute_success, config_table = pcall(result --[[@as fun()]])

		if not execute_success then
			log.warningf("[qbox::get_starter_items] Failed to execute Lua code (Got - %s)", config_table)
			return {}
		end

		if not config_table or not config_table.starterItems then
			log.warningf("[qbox::get_starter_items] No starter items found in config")
			return {}
		end

		return config_table.starterItems
	end,
}
