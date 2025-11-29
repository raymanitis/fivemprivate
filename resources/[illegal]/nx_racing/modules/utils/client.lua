local utils = {}
local vehicleClasses = require 'configs.vehicleClasses'

-- There is also a server-side function defined at utils/server.lua. Please change that, in case you're changing this.
function utils.notify(title, description, duration, type)
    lib.notify({
        title = title,
        description = description,
        duration = duration,
        type = type
    })
end

function utils.showTextUI(text)
    lib.showTextUI(text)
end

function utils.notAtStartTextUI()
    lib.showTextUI(locale('textUILineToStart'), {
        position = 'top-center',
        style = { color = "red" }
    })
end

function utils.hideTextUI()
    lib.hideTextUI()
end

function utils.getManualVehicleClass()
    local hash = GetEntityModel(cache.vehicle)
    local class = vehicleClasses[hash] or Config.vehicleClasses.manualFallbackClass
    return class + 1 -- Adds 1 to support the All Class
end

-- There is also a server-side function defined at utils/server.lua. Please change that, in case you're changing this for security reasons.
function utils.canJoinRace(raceId)
    return true
end

return utils