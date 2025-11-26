local CurrentWeather = Config.StartWeather
local baseTime = Config.BaseTime
local timeOffset = Config.TimeOffset
local freezeTime = Config.FreezeTime
local blackout = Config.Blackout
local newWeatherTimer = Config.NewWeatherTimer
local globalHour = Config.BaseTime

-- Admin permission check
local function isAllowedToChange(src)
    return src == 0 or IsPlayerAceAllowed(src, 'admin')
end

-- Time adjustments helper functions
local function shiftToMinute(minute)
    timeOffset = timeOffset - (((baseTime + timeOffset) % 60) - minute)
end

local function shiftToHour(hour)
    timeOffset = timeOffset - ((((baseTime + timeOffset) / 60) % 24) - hour) * 60
end

-- Dynamic weather progression
local function nextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY" then
        CurrentWeather = (math.random(1, 5) > 2) and "CLEARING" or "OVERCAST" -- 60/40 chance
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1, 6)
        if new == 1 then CurrentWeather = (CurrentWeather == "CLEARING") and "FOGGY" or "RAIN"
        elseif new == 2 then CurrentWeather = "CLOUDS"
        elseif new == 3 then CurrentWeather = "CLEAR"
        elseif new == 4 then CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then CurrentWeather = "SMOG"
        else CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then CurrentWeather = "CLEAR"
    else CurrentWeather = "CLEAR"
    end
    TriggerEvent("al-weathersync:server:RequestStateSync")
end

-- Valid weather setter
local function setWeather(weather)
    local upper = string.upper(weather)
    for _, w in ipairs(Config.AvailableWeatherTypes) do
        if w == upper then
            CurrentWeather = upper
            newWeatherTimer = Config.NewWeatherTimer
            TriggerEvent('al-weathersync:server:RequestStateSync')
            return true
        end
    end
    return false
end

-- Time setter
local function setTime(hour, minute)
    local h, m = tonumber(hour), tonumber(minute) or 1
    if not h or h > 23 or m > 59 then return false end
    shiftToHour(h)
    shiftToMinute(m)
    TriggerEvent('al-weathersync:server:RequestStateSync')
    return true
end

-- Blackout toggle
local function setBlackout(state)
    blackout = state == nil and not blackout or state
    TriggerEvent('al-weathersync:server:RequestStateSync')
    TriggerEvent('al-weathersync:server:blackoutChanged', blackout)
    return blackout
end

-- Time freeze toggle
local function setTimeFreeze(state)
    freezeTime = state == nil and not freezeTime or state
    TriggerEvent('al-weathersync:server:RequestStateSync')
    return freezeTime
end

-- Dynamic weather toggle
local function setDynamicWeather(state)
    Config.DynamicWeather = state == nil and not Config.DynamicWeather or state
    TriggerEvent('al-weathersync:server:RequestStateSync')
    return Config.DynamicWeather
end

-- State sync
RegisterNetEvent('al-weathersync:server:RequestStateSync', function()
    TriggerClientEvent('al-weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('al-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
end)

-- Server commands with plain text notifications
RegisterNetEvent('al-weathersync:server:setWeather', function(weather)
    local src = source
    if isAllowedToChange(src) then
        local ok = setWeather(weather)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Weather Sync',
            description = ok and 'Weather has been updated.' or 'Invalid weather type.',
            type = ok and 'success' or 'error'
        })
    end
end)

RegisterNetEvent('al-weathersync:server:setTime', function(src, hour, minute)
    if isAllowedToChange(src) then
        local ok = setTime(hour, minute)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Time Sync',
            description = ok and string.format('Time has changed to %02d:%02d.', tonumber(hour), tonumber(minute) or 0)
                    or 'Invalid time syntax. Use /time <hour> <minute>.',
            type = ok and 'success' or 'error'
        })
    end
end)

RegisterNetEvent('al-weathersync:server:toggleBlackout', function(state)
    local src = source
    if isAllowedToChange(src) then
        local newstate = setBlackout(state)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Blackout Sync',
            description = newstate and 'Blackout is now enabled.' or 'Blackout is now disabled.',
            type = 'inform'
        })
    end
end)

RegisterNetEvent('al-weathersync:server:toggleFreezeTime', function(state)
    local src = source
    if isAllowedToChange(src) then
        local newstate = setTimeFreeze(state)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Time Freeze',
            description = newstate and 'Time is now frozen.' or 'Time is no longer frozen.',
            type = 'inform'
        })
    end
end)

RegisterNetEvent('al-weathersync:server:toggleDynamicWeather', function(state)
    local src = source
    if isAllowedToChange(src) then
        local newstate = setDynamicWeather(state)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Weather Sync',
            description = newstate and 'Dynamic weather changes are now enabled.' or 'Dynamic weather changes are now disabled.',
            type = 'inform'
        })
    end
end)

lib.addCommand('time', {
    help = "Change time",
    params = {
        { name = 'hours', help = 'Hours', type = 'number' },
        { name = 'minutes', help = 'minutes', type = 'number', optional = true }
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    TriggerEvent("al-weathersync:server:setTime", source, args.hours, args.minutes)
end)

lib.addCommand('weather', {
    help = "Change weather",
    restricted = 'group.admin'
}, function(source, args, raw)
    TriggerClientEvent("al-weathersync:client:openWeather", source)
end)

lib.addCommand('freezetime', { help = 'Freeze/unfreeze time.', restricted = 'group.admin' }, function(src)
    local ns = setTimeFreeze()
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Time Freeze', description = ns and 'Time is now frozen.' or 'Time is no longer frozen.', type = ns and 'success' or 'error'
    })
end)

lib.addCommand('freezeweather', { help = 'Toggle dynamic weather.', restricted = 'group.admin' }, function(src)
    local ns = setDynamicWeather()
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Weather Sync', description = ns and 'Dynamic weather enabled.' or 'Dynamic weather disabled.', type = ns and 'success' or 'error'
    })
end)

lib.addCommand('blackout', { help = 'Toggle blackout.', restricted = 'group.admin' }, function(src)
    local ns = setBlackout()
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Blackout Sync', description = ns and 'Blackout enabled.' or 'Blackout disabled.', type = ns and 'success' or 'error'
    })
end)

-- Dev toggle command
lib.addCommand('dev', {
    help = "Enables Dev mode",
    restricted = 'group.admin',
}, function(source, args)
    TriggerClientEvent("al-admin:client:ToggleDevmode", source)
end)

-- THREAD LOOPS
CreateThread(function()
    local previous = 0
    while true do
        Wait(0)
        local newBaseTime = os.time(os.date("!*t")) / 2 + 360 --Set the server time depending of OS time
        if (newBaseTime % 60) ~= previous then
            --Check if a new minute is passed
            previous = newBaseTime % 60 --Only update time with plain minutes, seconds are handled in the client
            if freezeTime then
                timeOffset = timeOffset + baseTime - newBaseTime
            end
            baseTime = newBaseTime
            globalHour = math.floor(((baseTime + timeOffset) / 60) % 24)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(2000)--Change to send every minute in game sync
        TriggerClientEvent('al-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

CreateThread(function()
    while true do
        Wait(300000)
        TriggerClientEvent('al-weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    end
end)

CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Wait((1000 * 60) * Config.NewWeatherTimer)
        if newWeatherTimer == 0 then
            if Config.DynamicWeather then
                nextWeatherStage()
            end
            newWeatherTimer = Config.NewWeatherTimer
        end
    end
end)

function GetCurrentTime()
    return globalHour
end
exports("GetCurrentTime", GetCurrentTime)
exports("GetCurrentHours", GetCurrentTime)

exports("GetCurrentWeather", function()
    return CurrentWeather
end)
exports("GetBlackout", function()
    return blackout
end)