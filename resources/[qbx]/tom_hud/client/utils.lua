local Config = require 'configs.config'

---@param action string The action you wish to target
---@param data any The data you wish to send along with this action
function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

---                 North
---     45°           0°           315°
---       \    .- - - - - - -.    /
---          X                 X
---        .'   \           /   '.
---       |        \     /        |
--- West  |           X           |  East
---       |        /     \        |
---        '.   /           \   .'
---          X                 X
---       /    '- - - - - - -'    \
---     135°                      225°
---                 South
---

--- Returns the cardinal or intercardinal direction that the given entity is staring towards, or nil if the entity doesn't exist.
function GetCardinalDirection(entity)
    local heading = GetEntityHeading(entity) % 360

    if heading < 22.5 or heading >= 337.5 then
        return 'N'
    elseif heading >= 22.5 and heading < 67.5 then
        return 'NE'
    elseif heading >= 67.5 and heading < 112.5 then
        return 'E'
    elseif heading >= 112.5 and heading < 157.5 then
        return 'SE'
    elseif heading >= 157.5 and heading < 202.5 then
        return 'S'
    elseif heading >= 202.5 and heading < 247.5 then
        return 'SW'
    elseif heading >= 247.5 and heading < 292.5 then
        return 'W'
    else -- heading >= 292.5 and heading < 337.5
        return 'NW'
    end
end

--- Returns the cardinal or intercardinal direction that the player camera is staring towards.
function GetCamCardinalDirection()
    local camRot = GetGameplayCamRot(0)
    local heading = lib.math.round(360.0 - ((camRot.z + 360.0) % 360.0))

    if heading < 22.5 or heading >= 337.5 then
        return 'N'
    elseif heading >= 22.5 and heading < 67.5 then
        return 'NE'
    elseif heading >= 67.5 and heading < 112.5 then
        return 'E'
    elseif heading >= 112.5 and heading < 157.5 then
        return 'SE'
    elseif heading >= 157.5 and heading < 202.5 then
        return 'S'
    elseif heading >= 202.5 and heading < 247.5 then
        return 'SW'
    elseif heading >= 247.5 and heading < 292.5 then
        return 'W'
    else -- heading >= 292.5 and heading < 337.5
        return 'NW'
    end
end

function GetPlayerVoiceMethod(player)
    if PlayerVoiceMethod ~= "radio" then
        PlayerVoiceMethod = MumbleIsPlayerTalking(player) and "voice" or false
    end
    return PlayerVoiceMethod
end

function GetStreet()
    local playerPed = cache.ped
    local coords = GetEntityCoords(playerPed)

    local streetHash, crossingRoadHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = string.upper(GetStreetNameFromHashKey(streetHash))
    local crossingRoadName = crossingRoadHash and string.upper(GetStreetNameFromHashKey(crossingRoadHash)) or "UNKNOWN"
    local heading = GetCamCardinalDirection()

    return {
        streetName = streetName,
        heading = heading,
        nextNearestStreet = crossingRoadName
    }
end

function CovertRPM(value)
    local percentage = math.ceil(value * 10000 - 2001) / 80
    return math.max(0, math.min(percentage, 100))
end

function ConvertEngineHealthToPercentage(value)
    local percentage = ((value + 4000) / 5000) * 100
    percentage = math.max(0, math.min(percentage, 100))
    return percentage
end

function Round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num + 0.5 * mult)
end

function CalculateMinimap()
    local safezoneSize = GetSafeZoneSize()
    local aspectRatio = GetAspectRatio(false)

    if aspectRatio > 2 then aspectRatio = 16 / 9 end

    local screenWidth, screenHeight = GetActiveScreenResolution()
    local xScale = 1.0 / screenWidth
    local yScale = 1.0 / screenHeight

    local minimap = {
        width = xScale * (screenWidth / (3.49 * aspectRatio)),
        height = yScale * (screenHeight / 5.6),
        leftX = xScale * (screenWidth * (1.0 / 20.0 * ((math.abs(safezoneSize - 1.0)) * 10))),
        bottomY = 0.930 - yScale * (screenHeight * (1.0 / 20.0 * ((math.abs(safezoneSize - 1.0)) * 10)))
    }
    
    if aspectRatio > 2 then
        minimap.leftX = minimap.leftX + minimap.width * 0.845
        minimap.width = minimap.width * 0.76
    elseif aspectRatio > 1.8 then
        minimap.leftX = minimap.leftX + minimap.width * 0.2225
        minimap.width = minimap.width * 0.995
    end
    
    minimap.topY = minimap.bottomY - minimap.height

    return {
        width = minimap.width * screenWidth,
        height = minimap.height * screenHeight,
        left = minimap.leftX * 100,
        top = minimap.topY * 100
    }
end

function PreventBigmapFromStayingActive()
    local timeout = 0
    while true do

        SetBigmapActive(false, false)

        if timeout >= 10000 then
            return
        end

        timeout = timeout + 1000
        Wait(1000)
    end
end

function SetupMinimap()
    local defaultAspectRatio = 1920 / 1080
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX / resolutionY
    local minimapOffset = 0

    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
    end

    RequestStreamedTextureDict("squaremap", false)

    while not HasStreamedTextureDictLoaded("squaremap") do
        Wait(100)
    end

    SetMinimapClipType(0)
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")

    SetMinimapComponentPosition("minimap", "L", "B", 0.0 + minimapOffset, -0.047, 0.1638, 0.183)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.0, 0.128, 0.20)
    SetMinimapComponentPosition("minimap_blur", "L", "B", -0.010 + minimapOffset, 0.005, 0.262, 0.300)

    if not cache.vehicle then
        DisplayRadar(false)
    end

    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetBigmapActive(true, false)
    SetMinimapClipType(0)
    CreateThread(PreventBigmapFromStayingActive)
end