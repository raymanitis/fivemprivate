---@diagnostic disable: undefined-global
local disabled = false
local function switchSeat(_, args)
    -- Block command if player is dead (deathStage 2)
    local playerServerId = GetPlayerServerId(PlayerId())
    local playerState = Player(playerServerId).state
    local deathStage = playerState and (playerState.deathStage or playerState.isDead) or 0
    if deathStage == 2 then
        lib.notify({
            description = 'You cannot switch seats while dead',
            type = 'error',
            position = 'top-right'
        })
        return
    end

    local seatIndexRaw = tonumber(args[1])
    if not seatIndexRaw then
        lib.notify({
            description = 'Provide a valid seat number (0-3)',
            type = 'error',
            position = 'top-right'
        })
        return
    end
    local seatIndex = seatIndexRaw - 1

    if seatIndex < -1 or seatIndex >= 4 then
        lib.notify({
            description = ('Seat %s is not recognized'):format(seatIndex + 1),
            type = 'error',
            position = 'top-right'
        })
    else
        local ped = cache.ped
        local veh = cache.vehicle

        if veh then
            lib.progressBar({
                duration = 2000,
                label = 'Switching seat...',
                useWhileDead = false,
                canCancel = false,
                disable = {
                    move = true,
                    car = true,
                    combat = true
                }
            })

            CreateThread(function()
                disabled = true
                SetPedIntoVehicle(ped, veh, seatIndex)
                Wait(50)
                disabled = false
            end)
        end
    end
end

CreateThread(function()
    RegisterCommand("seat", switchSeat, false)
    TriggerEvent('chat:addSuggestion', '/seat', 'Switch seats in the current vehicle', {
        {
            name = 'seat',
            help = "Switch seats in the current vehicle. 0 = driver, 1 = passenger, 2-3 = back seats"
        }
    })
end)

AddEventHandler('onClientResourceStop', function(name)
    if name == 'ray-smallresources' then
        SetPedConfigFlag(cache.ped, 184, false)
    end
end)