local EnableNotifOX = true -- Enable use of ox_lib for notifications if available
local EnableNotifLation = false -- Enable use of lation_ui for notifications if available

--- Table of supported inventory systems.
local inventories = {
    { name = "ox_inventory" },
    { name = "qs-inventory" },
    { name = "qs-inventory-pro" },
    { name = "qb-inventory" },
    { name = "ps-inventory" },
    { name = "lj-inventory" },
    { name = "codem-inventory" }
}

--- Selects and returns the function for retrieving item image paths.
--- @return function Function to get item image path
local SelectInventoryImagePath = function()
    for _, resource in ipairs(inventories) do
        if GetResourceState(resource.name) == 'started' then
            if resource.name == "ox_inventory" then
                return function(item)
                    return string.format("nui://%s/web/images/%s.png", resource.name, item)
                end
            elseif resource.name == "codem-inventory" then
                return function(item)
                    return string.format("nui://%s/html/itemimages/%s.png", resource.name, item)
                end
            elseif resource.name == "qb-inventory" or resource.name == "lj-inventory" or
                   resource.name == "ps-inventory" or resource.name == "qs-inventory" or
                   resource.name == "qs-inventory-pro" then
                return function(item)
                    return string.format("nui://%s/html/images/%s.png", resource.name, item)
                end
            end
        end
    end
    return function(item)
        return nil
    end
end

local GetImagePathForItem = SelectInventoryImagePath()

--- Gets item image path for the inventory system.
--- @param item string The item name
--- @return string|nil The image path
GetItemImage = function(item)
    return GetImagePathForItem(item)
end

--- Capitalizes the first letter of a string and lowercases the rest.
---@param str string The string to capitalize.
---@return string The capitalized string.
CapitalizeFirst = function(str)
    return str:sub(1, 1):upper() .. str:sub(2):lower()
end

--- Selects and returns the most appropriate notification function based on the current game setup.
-- This function checks the available libraries and configurations to determine which notification method to use.
-- It then returns a function tailored to use that method for showing notifications.
---@return function A function configured to show notifications using the determined method.
local CreateNotificationFunction = function()
    if lib ~= nil and EnableNotifOX then
        return function(data)
            local title = CapitalizeFirst(data.type or 'inform')
            lib.notify({
                id = math.random(1, 999999),
                title = data.title,
                description = data.description,
                type = data.type or 'inform'
            })
        end
    elseif EnableNotifLation then
        return function(data)
            local title = CapitalizeFirst(data.type or 'inform')
            exports.lation_ui:notify({
                title = data.title,
                message = data.description,
                type = data.type or 'info',
            })
        end
    else
        if Framework == 'esx' then
            return function(data)
                ESX.ShowNotification(data.description)
            end
        elseif Framework == 'qb' then
            return function(data)
                QBCore.Functions.Notify(data.description, data.type or 'info')
            end
        end

        return function(data)
            error(string.format("Notification system not supported. Message was: %s, Type was: %s", data.description, data.type))
        end
    end
end

--- The chosen method for showing notifications, determined at the time of script initialization.
local Notify = CreateNotificationFunction()

--- Display a notification to the user.
-- This function triggers a notification with a specific message and type.
---@param message string The text of the notification to be displayed.
---@param type string The type of notification, which may dictate the visual style or urgency.
ShowNotification = function(data)
    Notify(data)
end

Target = {}
local target = nil

--- Initialize the target system by checking available resources and setting the target module.
local Initialize = function()
    local resources = {"ox_target", "qb-target", "qtarget"}
    for _, resource in ipairs(resources) do
        if GetResourceState(resource) == 'started' then
            target = resource
            break
        end
    end

    if not target then
        error("No target resource found or started.")
        return false
    end
    return true
end

Initialize()

--- Converts ox_target style options to qb-target/qtarget style
---@param options table ox_target style options array
---@return table qb-target style options array
local function ConvertOptions(options)
    if target == 'ox_target' then
        return options
    end

    -- Convert ox_target format to qb-target/qtarget format
    local converted = {}
    for _, option in ipairs(options) do
        table.insert(converted, {
            type = option.type or "client",
            event = option.event,
            icon = option.icon,
            label = option.label,
            action = option.onSelect,
            canInteract = option.canInteract,
            distance = option.distance,
            groups = option.groups,
            items = option.items
        })
    end
    return converted
end

--- Add a box zone (accepts ox_target params, works with all targets).
---@param data table Zone data with coords, size, rotation, debug, and options.
---@return number|string Zone ID
Target.addBoxZone = function(data)
    if target == 'ox_target' then
        return exports.ox_target:addBoxZone(data)
    else
        -- qb-target/qtarget use different API
        local name = data.name or ('box_zone_' .. math.random(100000, 999999))
        local size = data.size or vec3(2, 2, 2)
        local heading = data.rotation or 0

        return exports[target]:AddBoxZone(name, data.coords, size.x, size.y, {
            name = name,
            heading = heading,
            debugPoly = data.debug or false,
            minZ = data.coords.z - (size.z / 2),
            maxZ = data.coords.z + (size.z / 2),
        }, {
            options = ConvertOptions(data.options),
            distance = data.distance or 2.5,
        })
    end
end

--- Add a sphere zone (accepts ox_target params, works with all targets).
---@param data table Zone data with coords, radius, debug, and options.
---@return number|string Zone ID
Target.addSphereZone = function(data)
    if target == 'ox_target' then
        return exports.ox_target:addSphereZone(data)
    else
        -- qb-target/qtarget use CircleZone for spheres
        local name = data.name or ('sphere_zone_' .. math.random(100000, 999999))

        return exports[target]:AddCircleZone(name, data.coords, data.radius or 1.0, {
            name = name,
            useZ = true,
            debugPoly = data.debug or false,
        }, {
            options = ConvertOptions(data.options),
            distance = data.distance or 2.5,
        })
    end
end

--- Add a poly zone (accepts ox_target params, works with all targets).
---@param data table Zone data with points, thickness, debug, and options.
---@return number|string Zone ID
Target.addPolyZone = function(data)
    if target == 'ox_target' then
        return exports.ox_target:addPolyZone(data)
    else
        local name = data.name or ('poly_zone_' .. math.random(100000, 999999))

        return exports[target]:AddPolyZone(name, data.points, {
            name = name,
            debugPoly = data.debug or false,
            minZ = data.coords and data.coords.z - (data.thickness or 2) / 2,
            maxZ = data.coords and data.coords.z + (data.thickness or 2) / 2,
        }, {
            options = ConvertOptions(data.options),
            distance = data.distance or 2.5,
        })
    end
end

--- Add target to an entity (accepts ox_target params, works with all targets).
---@param netId number Network ID of the entity.
---@param options table Options for the target.
---@return boolean Success
Target.addEntity = function(netId, options)
    if target == 'ox_target' then
        return exports.ox_target:addEntity(netId, options)
    else
        local entity = NetworkGetEntityFromNetworkId(netId)
        exports[target]:AddTargetEntity(entity, {
            options = ConvertOptions(options),
            distance = options.distance or 2.5,
        })
        return true
    end
end

--- Add target to a local entity (accepts ox_target params, works with all targets).
---@param entity number Entity handle.
---@param options table Options for the target.
---@return boolean Success
Target.addLocalEntity = function(entity, options)
    if target == 'ox_target' then
        return exports.ox_target:addLocalEntity(entity, options)
    else
        exports[target]:AddTargetEntity(entity, {
            options = ConvertOptions(options),
            distance = options.distance or 2.5,
        })
        return true
    end
end

--- Add target to a model (accepts ox_target params, works with all targets).
---@param models table|string Model or array of models.
---@param options table Options for the target.
---@return boolean Success
Target.addModel = function(models, options)
    if target == 'ox_target' then
        return exports.ox_target:addModel(models, options)
    else
        local modelList = type(models) == 'table' and models or {models}
        exports[target]:AddTargetModel(modelList, {
            options = ConvertOptions(options),
            distance = options.distance or 2.5,
        })
        return true
    end
end

--- Add global target for all peds (accepts ox_target params, works with all targets).
---@param options table Options for the target.
---@return number|boolean Target ID
Target.addGlobalPed = function(options)
    if target == 'ox_target' then
        return exports.ox_target:addGlobalPed(options)
    else
        exports[target]:AddGlobalPed({
            options = ConvertOptions(options),
            distance = options.distance or 2.5,
        })
        return true
    end
end

--- Add global target for all vehicles (accepts ox_target params, works with all targets).
---@param options table Options for the target.
---@return number|boolean Target ID
Target.addGlobalVehicle = function(options)
    if target == 'ox_target' then
        return exports.ox_target:addGlobalVehicle(options)
    else
        exports[target]:AddGlobalVehicle({
            options = ConvertOptions(options),
            distance = options.distance or 2.5,
        })
        return true
    end
end

--- Add global target for all objects (accepts ox_target params, works with all targets).
---@param options table Options for the target.
---@return number|boolean Target ID
Target.addGlobalObject = function(options)
    if target == 'ox_target' then
        return exports.ox_target:addGlobalObject(options)
    else
        exports[target]:AddGlobalObject({
            options = ConvertOptions(options),
            distance = options.distance or 2.5,
        })
        return true
    end
end

--- Add global target for all players (accepts ox_target params, works with all targets).
---@param options table Options for the target.
---@return number|boolean Target ID
Target.addGlobalPlayer = function(options)
    if target == 'ox_target' then
        return exports.ox_target:addGlobalPlayer(options)
    else
        exports[target]:AddGlobalPlayer({
            options = ConvertOptions(options),
            distance = options.distance or 2.5,
        })
        return true
    end
end

--- Remove a zone by ID (accepts ox_target params, works with all targets).
---@param id number|string Zone ID to remove.
---@return boolean Success
Target.removeZone = function(id)
    if target == 'ox_target' then
        return exports.ox_target:removeZone(id)
    else
        exports[target]:RemoveZone(id)
        return true
    end
end

--- Remove target from an entity (accepts ox_target params, works with all targets).
---@param netId number Network ID of the entity.
---@param label string|nil Optional label to remove specific option.
---@return boolean Success
Target.removeEntity = function(netId, label)
    if target == 'ox_target' then
        return exports.ox_target:removeEntity(netId, label)
    else
        local entity = NetworkGetEntityFromNetworkId(netId)
        exports[target]:RemoveTargetEntity(entity, label)
        return true
    end
end

--- Remove target from a local entity (accepts ox_target params, works with all targets).
---@param entity number Entity handle.
---@param label string|nil Optional label to remove specific option.
---@return boolean Success
Target.removeLocalEntity = function(entity, label)
    if target == 'ox_target' then
        return exports.ox_target:removeLocalEntity(entity, label)
    else
        exports[target]:RemoveTargetEntity(entity, label)
        return true
    end
end

--- Remove target from a model (accepts ox_target params, works with all targets).
---@param models table|string Model or array of models.
---@param label string|nil Optional label to remove specific option.
---@return boolean Success
Target.removeModel = function(models, label)
    if target == 'ox_target' then
        return exports.ox_target:removeModel(models, label)
    else
        local modelList = type(models) == 'table' and models or {models}
        exports[target]:RemoveTargetModel(modelList, label)
        return true
    end
end

--- Remove global ped target (accepts ox_target params, works with all targets).
---@param label string|nil Optional label to remove specific option.
---@return boolean Success
Target.removeGlobalPed = function(label)
    if target == 'ox_target' then
        return exports.ox_target:removeGlobalPed(label)
    else
        exports[target]:RemoveGlobalPed(label)
        return true
    end
end

--- Remove global vehicle target (accepts ox_target params, works with all targets).
---@param label string|nil Optional label to remove specific option.
---@return boolean Success
Target.removeGlobalVehicle = function(label)
    if target == 'ox_target' then
        return exports.ox_target:removeGlobalVehicle(label)
    else
        exports[target]:RemoveGlobalVehicle(label)
        return true
    end
end

--- Remove global object target (accepts ox_target params, works with all targets).
---@param label string|nil Optional label to remove specific option.
---@return boolean Success
Target.removeGlobalObject = function(label)
    if target == 'ox_target' then
        return exports.ox_target:removeGlobalObject(label)
    else
        exports[target]:RemoveGlobalObject(label)
        return true
    end
end

--- Remove global player target (accepts ox_target params, works with all targets).
---@param label string|nil Optional label to remove specific option.
---@return boolean Success
Target.removeGlobalPlayer = function(label)
    if target == 'ox_target' then
        return exports.ox_target:removeGlobalPlayer(label)
    else
        exports[target]:RemoveGlobalPlayer(label)
        return true
    end
end