local displayDistance = 3.0
local function DrawText3D(x, y, z, text, newScale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(pX, pY, pZ) - vector3(x, y, z))
    local scale = newScale * (1 / dist) * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
local function DrawPlayerIds()
    local players = GetActivePlayers()
    local localPlayer = cache.ped
    local localCoords = GetEntityCoords(localPlayer)

    for _, playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(localCoords - targetCoords)

        if distance < displayDistance then
            local playerIdText = GetPlayerServerId(playerId)

            DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.1, "ID: " .. playerIdText, 1.6)
        end
    end
end

CreateThread(function()
    local idSleep = 1
    while true do
        Wait(idSleep)
        if IsControlPressed(0, 121) then
            idSleep = 3
            DrawPlayerIds()
        else
            idSleep = 50
        end
    end
end)