local Config = require 'anti_afk/config'
local PrevPos;

local function AFKNotification(time)
    lib.notify({
        description = ("You will be kicked in %s seconds"):format(time),
        position = 'bottom',
        style = {
            borderRadius = 5,
            backgroundColor = '#000000bf',
            color = 'white'
        },
        icon = 'ban',
        iconColor = '#C53030'
    })
end

CreateThread(function()
    local time = 10
    while true do
        Wait(1000)
        local playerPed = cache.ped
        if playerPed then
            local CurrentPos = GetEntityCoords(playerPed)
            if CurrentPos == PrevPos then
                if time > 0 then
                    if time <= 30 then
                        AFKNotification(time)
                    end
                    time = time - 1
                else
                    TriggerServerEvent("ray-smallres:anti_afk")
                end
            else
                time = Config.timeAFK
            end
            PrevPos = CurrentPos
        end
    end
end)