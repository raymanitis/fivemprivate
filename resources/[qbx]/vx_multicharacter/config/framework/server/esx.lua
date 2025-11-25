return {
	identifier_prefix = "char", -- Make sure it matches whatever you had before, although the resource will attempt to auto detect this.
	database = {
		-- Toggle the deletion (this will wipe any table listed below for any deleted character)
		---@type boolean
		cleanup = false,

		-- A list of tables that you wish to clean when they are deleted.
		tables = {
			{ name = 'users',          column = 'identifier' },
			{ name = 'owned_vehicles', column = 'owner' },
			-- { name = 'playerskins', column = 'citizenid' },
			-- { name = 'player_outfits', column = 'citizenid' },
		},
	}
}
