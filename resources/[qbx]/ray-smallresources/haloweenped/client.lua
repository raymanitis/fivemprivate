---@diagnostic disable: undefined-global
local Config = require 'haloweenped/config'

-- Spawn the Halloween ped and add interaction (E key or ox_target if present)
CreateThread(function()
	lib.requestModel(Config.pedModel)
	local ped = CreatePed(4, Config.pedModel, Config.pedCoords.x, Config.pedCoords.y, Config.pedCoords.z - 1.0, Config.pedCoords.w, false, true)
	SetEntityInvincible(ped, true)
	FreezeEntityPosition(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetPedCanRagdoll(ped, false)

	-- ox_target option if available
    if exports.ox_target then
		exports.ox_target:addLocalEntity(ped, {
			{
				label = Config.targetLabel,
                onSelect = function()
                    lib.callback('haloweenped:tryRedeem', false, function(success, payload)
                        if success and payload and payload.model and payload.plate then
                            -- Spawn vehicle for the player with returned model/plate
                            local model = payload.model
                            local plate = payload.plate

                            lib.requestModel(model)
                            local ped = cache.ped
                            local spawn = Config.vehicleSpawn
                            local coords = spawn and vec3(spawn.x, spawn.y, spawn.z) or GetEntityCoords(ped)
                            local heading = spawn and spawn.w or GetEntityHeading(ped)

                            local veh = CreateVehicle(joaat(model), coords.x, coords.y, coords.z, heading, true, false)
                            SetVehicleOnGroundProperly(veh)
                            SetVehicleNumberPlateText(veh, plate)
                            SetEntityAsMissionEntity(veh, true, true)

						-- Give keys and ensure unlocked
						SetVehicleHasBeenOwnedByPlayer(veh, true)
						SetVehicleDoorsLocked(veh, 1)
						SetVehicleDoorsLockedForAllPlayers(veh, false)
						-- Try common keys resources (safe if not present)
						TriggerEvent('vehiclekeys:client:SetOwner', plate) -- qb-vehiclekeys
						TriggerEvent('qbx_vehiclekeys:client:GiveKeys', plate) -- qbx vehicle keys (if available)

                            TaskWarpPedIntoVehicle(ped, veh, -1)
                            lib.notify({ title = 'Halloween', description = ('Enjoy your new car! Plate: %s'):format(plate), type = 'success' })
                            SetModelAsNoLongerNeeded(joaat(model))
                        else
                            local msg = type(payload) == 'string' and payload or 'Failed to redeem vehicle'
                            lib.notify({ title = 'Halloween', description = msg, type = 'error' })
                        end
                    end)
                end,
				icon = 'fa-solid fa-candy-cane'
			}
		})
	end

end)



