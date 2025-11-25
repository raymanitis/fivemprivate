--#region Modules
local log = require("modules.utility.shared.logger")
--#endregion

return {
	---Removes an element from the table by swapping it with the last element and popping it.
	---This is an O(1) operation, but the original table order will be changed.
	---@param tbl table The table to operate on.
	---@param index integer The index of the element to remove.
	---@return integer? Returns 412 if the input is invalid, otherwise nil.
	swap_remove = function(tbl, index)
		if not tbl or not index then return 412 end

		local size = #tbl
		tbl[index] = tbl[size]
		tbl[size] = nil
	end,

	---Formats a string so that the first letter is uppercase and the rest are lowercase.
	---Example: "hello" -> "Hello", "WORLD" -> "World"
	---@param v string The string to format.
	---@return string The formatted string with proper casing.
	format_name = function(v)
		assert(v and type(v) == "string", "[format_name] Invalid arguments passed.")

		return v:sub(1, 1):upper() .. v:sub(2):lower()
	end,

	---Wrapper over the original freeze logic, simply with more stuff :]
	---@param state boolean
	freeze_client = function(state)
		assert(type(state) == "boolean", "[freeze_client] Invalid arguments passed.")

		local ped = PlayerPedId()

		SetPlayerControl(PlayerId(), not state, 0)

		if state then
			SetEntityCollision(ped, false, false)
			FreezeEntityPosition(ped, true)
			return
		end

		SetEntityCollision(ped, true, true)
		FreezeEntityPosition(ped, false)
	end,

	--- Wrapper of the `spawnPlayer` export from spawnmanager.
	---@param self unknown
	---@param position IPosition
	---@param cb fun()
	spawn_player = function(self, position, cb)
		assert(position, "[spawn_player] Invalid arguments passed.")
		local ped = PlayerPedId()

		self.freeze_client(true)

		RequestCollisionAtCoord(position.x, position.y, position.z)
		SetEntityCoordsNoOffset(ped, position.x, position.y, position.z, false, false, false, true)
		NetworkResurrectLocalPlayer(position.x, position.y, position.z, position.heading, true, true, false)
		ClearPedTasksImmediately(ped)
		ClearPlayerWantedLevel(PlayerId())

		local time = GetGameTimer()

		while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
			Citizen.Wait(0)
		end

		if IsScreenFadedOut() then
			DoScreenFadeIn(500)

			while not IsScreenFadedIn() do
				Citizen.Wait(0)
			end
		end

		self.freeze_client(false)

		TriggerEvent('playerSpawned', position)

		Citizen.Wait(750)

		if cb then
			cb()
		end
	end

}
