local log = require("modules.utility.shared.logger")
local client_enums = enums?.events?.client
local enums = enums?.events?.server

---@class TServerUtilityFunctions
return {
	-- Credit: Inspired by the `triggerClientEvent` from ox_lib for packing args efficiently when triggering events
	--- Improves performance when calling multiple clients since we're only packing the args once.
	---@param event_name string
	---@param event_target number | ArrayLike<number>
	---@param ... unknown
	trigger_client_event = function(event_name, event_target, ...)
		assert(event_name and event_target, "[triggerClientEvent] Invalid arguments passed.")

		local payload = msgpack.pack_args(...)
		local payloadLen = #payload
		local type_of_targets = type(event_target)

		if type_of_targets ~= "table" and type_of_targets ~= "number" then
			return log.errorf("[triggerClientEvent] typeofTargets was not a table nor a number (Type: %s)", type_of_targets)
		end

		if type_of_targets == "number" then
			TriggerClientEventInternal(event_name, event_target --[[@as string]], payload, payloadLen)
			log.verbosef("[triggerClientEvent] Event Triggered, Name: %s, Targets: %s, Payload: %s, payloadLen: %s", event_name, json.encode(event_target), payload, payloadLen)
			return
		end

		local table_type = table.type(event_target)

		if table_type ~= "array" and table_type ~= "empty" then
			return log.errorf("[triggerClientEvent] `tableType` was neither an array nor empty, tableType: %s, targets: %s", table_type, event_target)
		end

		for i = 1, #event_target do
			TriggerClientEventInternal(event_name, event_target[i] --[[@as string]], payload, payloadLen)
		end

		log.verbosef("[triggerClientEvent] Triggered event for %s clients name: %s, payload: %s, payloadLen: %s", #event_target, event_name, payload, payloadLen)
	end,

	--- Handles the closing of an active request for the specified client.
	---@param client integer
	---@param state IActiveReqState
	---@param message? string
	---@param name? string When provided we need to check if the active request name matches the given one.
	close_request = function(client, state, message, name, data)
		assert(client and state, "[close_request] Invalid arguments passed.")

		TriggerClientEvent(client_enums.close_request, client, state, message, name, data)
	end,

	---Utilized to check if there's an update available.
	---Yoinked & Modified from https://github.com/overextended/ox_lib/blob/master/resource/version/server.lua
	---@param repo string
	check_version = function(repo)
		assert(repo, "[check_version] invalid arg `repo`")

		local currResourceName = GetCurrentResourceName()
		local currVersion = GetResourceMetadata(currResourceName, "version", 0)


		if currVersion then
			currVersion = currVersion:match("%d+%.%d+%.%d+")
		end

		Citizen.SetTimeout(1000, function()
			PerformHttpRequest(("https://api.github.com/repos/%s/releases/latest"):format(repo),
				function(status, body, headers, err_data)
					if status ~= 200 then
						return log.info("[check_version] API request unsuccessful.")
					end

					body = json.decode(body)

					if body.prerelease then
						return
					end

					local latestVersion = body.tag_name:match("%d+%.%d+%.%d+")

					if not latestVersion or latestVersion == currVersion then
						return
					end

					local cv = { string.strsplit(".", currVersion) }
					local lv = { string.strsplit(".", latestVersion) }

					for i = 1, #cv do
						local current, minimum = tonumber(cv[i]), tonumber(lv[i])

						if current ~= minimum then
							break
						end

						if current > minimum then
							break
						end

						print(("^3 An Update is available for \"vx_multicharacter\". Download Here: %s^0"):format("https://portal.cfx.re/"))
					end
				end, "GET")
		end)
	end

}
