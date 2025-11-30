local utils = {}
local config = require 'config.client'

---@param dict string
utils.loadAnimDict = function(dict)
    if not HasAnimDictLoaded(dict) then
        while not HasAnimDictLoaded(dict) do
            RequestAnimDict(dict)
            Wait(5)
        end
    end
end

---@param model string
utils.loadModel = function(model)
    if not HasModelLoaded(model) then
        while not HasModelLoaded(model) do
            RequestModel(model)
            Wait(5)
        end
    end
end

utils.checkBlackListedVehicle = function(vehicle)
    if not config.blacklisteVehicles then return false end
    if #config.blacklisteVehicles <= 0 then return false end

    for _, blacklisted in pairs(config.blacklisteVehicles) do
        if string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) == blacklisted then
            return true
        end
    end

    if not config.blacklistedVehiclesTypes then return false end
    if #config.blacklistedVehiclesTypes <= 0 then return false end

    for _, blacklisted in pairs(config.blacklistedVehiclesTypes) do
        if GetVehicleType(vehicle) == blacklisted then
            return true
        end
    end

    return false
end

utils.minigame = function()
    if (not config.useMinigame) then return true end
    return (lib.skillCheck({ 'medium', 'medium' }, { '1', '2', '3', '4' }) and config.useMinigame)
end

---@param message string
---@param type string
utils.notify = function(message, type)
    lib.notify({ description = message, type = type })
end

utils.policeAlert = function()
    TriggerServerEvent('police:server:policeAlert', locale('police_alert'))
end

---@param label string
---@param duration number
---@param disable table
---@param anim table
---@param prop table
utils.progressBar = function(label, duration, disable, anim, prop)
	return lib.progressCircle({
        label = label,
        duration = duration,
        position = config.progressbarPos,
        useWhileDead = false,
        canCancel = true,
        disable = disable,
        anim = anim,
        prop = prop
    })
end

---@param entity number
---@param options table
---@param distance number
---@param name string
utils.localEntityTarget = function(entity, options, distance, name)
    if GetResourceState('ox_target') == 'started' then
        return exports.ox_target:addLocalEntity(entity, options)
    elseif GetResourceState('qb-target') == 'started' then
        return exports['qb-target']:AddTargetEntity(entity, { name = name, options = options, distance = distance })
    end

    utils.debug('No target system detected, edit the mt_chopshop/modules/utils/client.lua', 'error')
    return {}
end

---@param coords vector
---@param radius number
---@param options table
---@param distance number
---@param name string
---@return unknown
utils.createSphereZoneTarget = function(coords, radius, options, distance, name)
    if GetResourceState('ox_target') == 'started' then
        return exports.ox_target:addSphereZone({ debug = config.debug, coords = coords, radius = radius, options = options })
    elseif GetResourceState('qb-target') == 'started' then
        -- Here we use Box Zone cause qb-target Sphere Zone does not exists and the Circle Zone is the big shit ever made
        exports['qb-target']:AddBoxZone(name, coords, radius, radius, { debugPoly = config.debug, name = name, minZ = coords.z-radius, maxZ = coords.z+radius }, { options = options, distance = distance })
        return name
    end

    utils.debug('No target system detected, edit the mt_chopshop/modules/utils/client.lua', 'error')
    return {}
end

---@param zone number
utils.removeZone = function(zone)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:removeZone(zone)
    elseif GetResourceState('qb-target') == 'started' then
        exports['qb-target']:RemoveZone(zone)
    end
end

---@param coords vector3
---@param sprite number
---@param display number
---@param scale number
---@param color number
---@param label string
utils.createBlip = function(coords, sprite, display, scale, color, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, display)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

return utils