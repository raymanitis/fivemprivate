local utils = {}

-- There is also a client-side function defined at utils/client.lua. Please change that, in case you're changing this.
function utils.notify(source, title, description, duration, type)
    lib.notify(source, {
        title = title,
        description = description,
        duration = duration,
        type = type
    })
end

function utils.isAdmin(source)
    return IsPlayerAceAllowed(source, 'admin')
end

-- There is also a client-side function defined at utils/client.lua. Please change that, in case you're changing this to have the race start DUI not render.
-- If this is false, return false and the reasoning behind not being able to join the race.
--- @return boolean, string?
function utils.canJoinRace(source, raceId)
    return true
end

function utils.canCreateTracks(source)
    return true
end

function utils.canStartRaces(source)
    return true
end

return utils