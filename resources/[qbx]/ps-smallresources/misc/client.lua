---@diagnostic disable: undefined-global, param-type-mismatch, need-check-nil, assign-type-mismatch
-- /stuck cmd --
local Mod = require 'misc/config'
local Config = Mod
local ServerZones = nil
local legionSquare = vec3(234.12, -761.07, 30.86)

-- Warn if the zones config isn't loaded on client
if not Config or not Config.StuckBlockedZones then
    print('[ray-smallres] Config.StuckBlockedZones not loaded; /stuck zones not enforced')
end

-- Check if current coords are inside any blocked zone from Config
local function isPointInPolygon(point, polygon)
    if type(polygon) ~= 'table' or #polygon < 3 then return false end
    local px = point.x or point[1]
    local py = point.y or point[2]
    if not px or not py then return false end

    local inside = false
    local j = #polygon
    for i = 1, #polygon do
        local vi = polygon[i]
        local vj = polygon[j]
        local xi = vi.x or vi[1]
        local yi = vi.y or vi[2]
        local xj = vj.x or vj[1]
        local yj = vj.y or vj[2]
        if xi and yi and xj and yj then
            local intersect = ((yi > py) ~= (yj > py)) and (px < ((xj - xi) * (py - yi) / ((yj - yi) ~= 0 and (yj - yi) or 1e-9) + xi))
            if intersect then inside = not inside end
        end
        j = i
    end
    return inside
end

local function isInStuckBlockedZone(coords)
    local zones = ServerZones or (Config and Config.StuckBlockedZones) or {}
    if type(zones) ~= 'table' then return false end
    for _, zone in ipairs(zones) do
        -- Polygon zone (preferred): zone.points = { vec3(x1,y1,z1), vec3(x2,y2,z2), ... }
        if zone.points and type(zone.points) == 'table' and #zone.points >= 3 then
            if isPointInPolygon(coords, zone.points) then
                local z = coords.z or coords[3]
                local minZ = zone.minZ
                local maxZ = zone.maxZ
                local zOk = (not minZ or (z and z >= minZ)) and (not maxZ or (z and z <= maxZ))
                if zOk then
                    return true, (zone.label or 'Restricted Area')
                end
            end
        else
            -- Circle fallback: center + radius
            local center = zone.center
            local radius = tonumber(zone.radius) or 0.0
            if center and radius > 0.0 then
                local dx = coords.x - center.x
                local dy = coords.y - center.y
                local distSq = dx * dx + dy * dy
                if distSq <= (radius * radius) then
                    local z = coords.z or coords[3]
                    local minZ = zone.minZ
                    local maxZ = zone.maxZ
                    local zOk = (not minZ or (z and z >= minZ)) and (not maxZ or (z and z <= maxZ))
                    if zOk then
                        return true, (zone.label or 'Restricted Area')
                    end
                end
            end
        end
    end
    return false
end
RegisterCommand("stuck", function()
    if LocalPlayer.state.isDead or LocalPlayer.state.isHandCuffed then
        lib.notify({
            description = "Tu nedrīksti būt miris vai rokudzelžos",
            type = "error"
        })
        return
    end
    local ped = cache.ped
    -- Block /stuck in configured zones
    local here = GetEntityCoords(ped)
    local blocked, label = isInStuckBlockedZone(here)
    if blocked then
        lib.notify({
            description = (label and (label .. ': ') or '') .. "/stuck nav pieejams šajā zonā",
            type = "error"
        })
        return
    end
    if GetEntitySpeed(ped) == 0 and not cache.vehicle then
        if lib.progressBar({
            duration = 300 * 1000, -- 30 sek.
            label = 'Teleportē...',
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                combat = true,
                vehicle = true
            },
        }) then
            local coords = GetEntityCoords(ped)
            TriggerServerEvent('ray-smallres:stuck:log', { x = coords.x, y = coords.y, z = coords.z })
            DoScreenFadeOut(1500)
            Wait(2000)
            SetEntityCoords(ped, legionSquare.x, legionSquare.y, legionSquare.z, false, false, false, true)
            Wait(1000)
            DoScreenFadeIn(1500)
        end
    else
        if cache.vehicle then
            lib.notify({
                description = "Tu nedrīksti būt auto",
                type = "error"
            })
        else
            lib.notify({
                description = "Tu nedrīksti kustēties!",
                type = "error"
            })
        end
    end
end, false)

-- Receive zones from server
RegisterNetEvent('ray-smallres:stuck:setZones')
AddEventHandler('ray-smallres:stuck:setZones', function(zones)
    if type(zones) == 'table' then
        ServerZones = zones
    end
end)

-- Request zones on start
CreateThread(function()
    TriggerServerEvent('ray-smallres:stuck:requestZones')
end)

-- Hunger/Thirst notifications (per 1% drop under 20)
local lastHungerStep = nil
local lastThirstStep = nil

AddStateBagChangeHandler('hunger', ('player:%s'):format(cache.serverId), function(_, _, value)
    local current = math.floor(tonumber(value) or 0)
    if current < 20 then
        local last = lastHungerStep
        if last == nil then
            last = current + 1
        end
        if current < last then
            lib.notify({
                description = "You are feeling hungry!",
                icon = 'fa-burger',
                iconColor = '#dcae11',
                duration = 3500
            })
        end
        lastHungerStep = current
    else
        lastHungerStep = nil
    end
end)

AddStateBagChangeHandler('thirst', ('player:%s'):format(cache.serverId), function(_, _, value)
    local current = math.floor(tonumber(value) or 0)
    if current < 20 then
        local last = lastThirstStep
        if last == nil then
            last = current + 1
        end
        if current < last then
            lib.notify({
                description = "You are feeling thirsty!",
                icon = 'fa-droplet',
                iconColor = '#51aeff',
                duration = 3500
            })
        end
        lastThirstStep = current
    else
        lastThirstStep = nil
    end
end)

-- MaxVeh admin event --
local maxMods = { 11, 12, 13, 14, 15, 16 }
RegisterNetEvent("ray-smallres:maxVehicle")
AddEventHandler("ray-smallres:maxVehicle", function()
    if lib.callback.await("ray-smallres:checkPermission") then
        local veh = cache.vehicle
        if veh then
            SetVehicleModKit(veh, 0)
            for _, v in pairs(maxMods) do
                local maxMod = GetNumVehicleMods(veh, v) - 1
                SetVehicleMod(veh, v, maxMod, false)
                -- print(v, maxMod, true)
            end
            ToggleVehicleMod(veh, 18, true)
            print("Mods maxed")
        end
    else
        print("tev nav permi jefiņ")
    end
end)