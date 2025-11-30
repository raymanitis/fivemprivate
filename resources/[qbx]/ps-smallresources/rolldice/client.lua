local Config = require 'rolldice/config'

local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextOutline()
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

local function CreateRollString(rollTable, sides)
    local text = "Roll: "
    local total = 0

    for k, roll in pairs(rollTable, sides) do
        total = total + roll
        if k == 1 then
            text = text .. roll .. "/" .. sides
        else
            text = text .. " | " .. roll .. "/" .. sides
        end
    end

    text = text .. " | (Total: " .. total .. ")"
    return text
end

local function DiceRollAnimation()
    lib.requestAnimDict("anim@mp_player_intcelebrationmale@wank")

    TaskPlayAnim(cache.ped, "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, -8.0, -1, 49, 0, false, false, false)
    Wait(1650)
    StopAnimTask(cache.ped, "anim@mp_player_intcelebrationmale@wank", "wank", 1.0)

    RemoveAnimDict("anim@mp_player_intcelebrationmale@wank")
end

local function ShowRoll(text, sourceId, _, location)
    local coords = GetEntityCoords(cache.ped)
    local dist = #(location - coords)

    if dist <= Config.MaxDistance then
        local display = true

        CreateThread(function()
            Wait(Config.ShowTime * 1000)
            display = false
        end)

        CreateThread(function()
            serverPed = GetPlayerPed(GetPlayerFromServerId(sourceId))
            while display do
                Wait(5)
                local currentCoords = GetEntityCoords(serverPed)

                DrawText3D(currentCoords.x, currentCoords.y, currentCoords.z + Config.Offset - 1.25, text)
            end
        end)
    end
end

RegisterNetEvent("ray-smallres:dice:client:roll")
AddEventHandler("ray-smallres:dice:client:roll", function(sourceId, maxDinstance, rollTable, sides, location)
    local rollString = CreateRollString(rollTable, sides)

    if cache.serverId == sourceId then
        DiceRollAnimation()
    end

    ShowRoll(rollString, sourceId, maxDinstance, location)
end)

CreateThread(function()
    while true do
        Wait(60000)
        collectgarbage("collect")
    end
end)