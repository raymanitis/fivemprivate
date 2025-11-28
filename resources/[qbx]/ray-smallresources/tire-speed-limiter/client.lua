local Config = require 'tire-speed-limiter/config'
---@diagnostic disable: undefined-global

local function DebugPrint(message)
    if Config.Debug then
        print("[DEBUG] " .. message)
    end
end

-- Cache keys for ox_lib
local CACHE_KEYS = {
    TIRE_DAMAGE = 'tire_damage_%s',
    VEHICLE_SPEED = 'vehicle_speed_%s',
}

-- State variables
local currentSpeedLimit = nil
local speedEnforcementThread = nil
local lastVehicle = nil

-- Apply or clear a hard speed cap on the vehicle without using brakes
local function applyVehicleSpeedLimit(vehicle, limitKmh)
    if not vehicle or vehicle == 0 then return end

    if limitKmh and limitKmh > 0 then
        local limitMs = limitKmh / 3.6
        SetVehicleMaxSpeed(vehicle, limitMs)
        DebugPrint(("Applied speed cap: %.1f km/h (%.2f m/s)"):format(limitKmh, limitMs))
    else
        -- -1.0 removes any custom cap and restores default max speed
        SetVehicleMaxSpeed(vehicle, -1.0)
        DebugPrint("Cleared speed cap (unlimited)")
    end
end

-- Reset all speed limiting
local function reset(vehicleParam)
    if speedEnforcementThread then
        speedEnforcementThread = nil
    end

    local vehicle = vehicleParam or cache.vehicle
    if vehicle and vehicle ~= 0 then
        -- Clear any previously applied speed cap
        SetVehicleMaxSpeed(vehicle, -1.0)
    end

    currentSpeedLimit = nil

    DebugPrint("Speed limiting reset")
end

-- Check tire damage and update speed limit
local function checkTireDamage(vehicle)
    local tireCacheKey = CACHE_KEYS.TIRE_DAMAGE:format(vehicle)
    
    -- Use ox_lib cache for tire damage data
    local tireData = cache(tireCacheKey, function()
        local data = {}
        for i = 0, 5 do
            -- Check for burst tires (this should detect shot/damaged tires)
            local isBurst = IsVehicleTyreBurst(vehicle, i, false)
            data[i] = isBurst
        end
        return data
    end, Config.cacheSettings.tireDamageCacheTimeout)

    local damagedTires = 0
    for i = 0, 5 do
        if tireData[i] then
            damagedTires = damagedTires + 1
        end
    end

    local newSpeedLimit = Config.speedLimits[damagedTires]

    if newSpeedLimit ~= currentSpeedLimit then
        currentSpeedLimit = newSpeedLimit
        
        DebugPrint(("Tire damage changed: %d/6 tires damaged"):format(damagedTires))
        DebugPrint(("Speed limit: %s"):format(
            currentSpeedLimit and (currentSpeedLimit .. " km/h") or "None"
        ))

        if currentSpeedLimit then
            applyVehicleSpeedLimit(vehicle, currentSpeedLimit)
        else
            reset(vehicle)
        end
    end
end

-- Start main monitoring thread
local function startMainThread()
    CreateThread(function()
        while true do
            local vehicle = cache.vehicle
            local seat = cache.seat

            if vehicle and vehicle ~= 0 and seat == -1 then
                -- Force fresh check when entering a new vehicle
                if lastVehicle ~= vehicle then
                    if lastVehicle and lastVehicle ~= 0 then
                        -- Clear cap from the previous vehicle
                        reset(lastVehicle)
                    end
                    lastVehicle = vehicle
                    -- Reset speed limit to force fresh check
                    currentSpeedLimit = nil
                    DebugPrint("Entered new vehicle, forcing fresh tire check")
                end
                
                checkTireDamage(vehicle)
            else
                -- Reset when not in driver seat
                if currentSpeedLimit or lastVehicle then
                    reset(lastVehicle or cache.vehicle)
                end
                lastVehicle = nil
            end

            Wait(Config.cacheSettings.updateInterval)
        end
    end)
end

-- Initialize the speed limiter
local function init()
    DebugPrint("Initializing tire speed limiter...")
    startMainThread()
end

-- Exports
exports('getCurrentSpeedLimit', function()
    return currentSpeedLimit
end)

exports('getDamagedTireCount', function(vehicle)
    vehicle = vehicle or cache.vehicle
    if not vehicle or vehicle == 0 then return 0 end

    local tireCacheKey = CACHE_KEYS.TIRE_DAMAGE:format(vehicle)
    local tireData = cache(tireCacheKey, function()
        local data = {}
        for i = 0, 5 do
            data[i] = IsVehicleTyreBurst(vehicle, i, false)
        end
        return data
    end, Config.cacheSettings.tireDamageCacheTimeout)

    local count = 0
    for i = 0, 5 do
        if tireData[i] then count = count + 1 end
    end
    return count
end)

exports('getVehicleSpeed', function(vehicle)
    vehicle = vehicle or cache.vehicle
    if not vehicle or vehicle == 0 then return 0 end

    local speedCacheKey = CACHE_KEYS.VEHICLE_SPEED:format(vehicle)
    return cache(speedCacheKey, function()
        return GetEntitySpeed(vehicle) * 3.6
    end, Config.cacheSettings.vehicleSpeedCacheTimeout)
end)

exports('isSpeedLimited', function()
    return currentSpeedLimit ~= nil
end)

-- Initialize when resource starts
CreateThread(function()
    Wait(1000) -- Wait for ox_lib to load
    init()
end)
