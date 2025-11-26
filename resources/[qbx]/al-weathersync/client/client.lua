local CurrentWeather = Config.StartWeather
local lastWeather = CurrentWeather
local baseTime = Config.BaseTime
local globalHour = Config.BaseTime
local timeOffset = Config.TimeOffset
local timer = 0
local freezeTime = Config.FreezeTime
local blackout = Config.Blackout
local blackoutVehicle = Config.BlackoutVehicle
local disable = Config.Disabled
local GetGameTimer, NetworkOverrideClockTime = GetGameTimer, NetworkOverrideClockTime
local SetVehicleDensityMultiplierThisFrame, SetPedDensityMultiplierThisFrame, SetRandomVehicleDensityMultiplierThisFrame, SetParkedVehicleDensityMultiplierThisFrame, SetScenarioPedDensityMultiplierThisFrame = SetVehicleDensityMultiplierThisFrame, SetPedDensityMultiplierThisFrame, SetRandomVehicleDensityMultiplierThisFrame, SetParkedVehicleDensityMultiplierThisFrame, SetScenarioPedDensityMultiplierThisFrame

Citizen.CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do
        Wait(100)
    end
    TriggerEvent("al-weathersync:client:EnableSync")
end)

RegisterNetEvent('al-weathersync:client:EnableSync', function()
    disable = false
    TriggerServerEvent('al-weathersync:server:RequestStateSync')
end)

RegisterNetEvent('al-weathersync:client:DisableSync', function()
    disable = true
    CreateThread(function()
        while disable do
            SetRainLevel(0.0)
            SetWeatherTypePersist('CLEAR')
            SetWeatherTypeNow('CLEAR')
            SetWeatherTypeNowPersist('CLEAR')
            if isInCharSelection then
                NetworkOverrideClockTime(22, 0, 0)
            else
                NetworkOverrideClockTime(23, 0, 0)
            end
            Wait(5000)
        end
    end)
end)

function SetClientSync(bool)
    if bool then
        TriggerEvent("al-weathersync:client:EnableSync")
    else
        TriggerEvent("al-weathersync:client:DisableSync")
    end
end
exports("SetClientSync", SetClientSync)

RegisterNetEvent("al-weathersync:client:openWeather", function()
    local input = lib.inputDialog("Change Weather", {
        { type = "select", label = "Weather Type", options = Config.WeatherNames, default = CurrentWeather, icon = 'cloud', required = true }
    })
    if not input then return end
    if input[1] then
        TriggerServerEvent("al-weathersync:server:setWeather", input[1])
    end
end)

RegisterNetEvent('al-weathersync:client:SyncWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

RegisterNetEvent('al-weathersync:client:SyncTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

CreateThread(function()
    while true do
        if not disable then
            if lastWeather ~= CurrentWeather then
                lastWeather = CurrentWeather
                SetWeatherTypeOverTime(CurrentWeather, 15.0)
                Wait(15000)
            end
            Wait(100) -- Wait 100 seconds to prevent crashing.
            SetArtificialLightsState(blackout)
            SetArtificialLightsStateAffectsVehicles(blackoutVehicle)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist(lastWeather)
            SetWeatherTypeNow(lastWeather)
            SetWeatherTypeNowPersist(lastWeather)
            if lastWeather == 'XMAS' then
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
            if lastWeather == 'RAIN' then
                SetRainLevel(0.3)
            elseif lastWeather == 'THUNDER' then
                SetRainLevel(0.5)
            else
                SetRainLevel(0.0)
            end
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    local hour
    local minute = 0
    local second = 0 --Add seconds for shadow smoothness
    while true do
        if not disable then
            Wait(0)
            local newBaseTime = baseTime
            if GetGameTimer() - 22 > timer then
                second = second + 1 --Minutes are sent from the server every 2 seconds to keep sync
                timer = GetGameTimer()
            end
            if freezeTime then
                timeOffset = timeOffset + baseTime - newBaseTime
                second = 0
            end
            baseTime = newBaseTime
            hour = math.floor(((baseTime + timeOffset) / 60) % 24)
            globalHour = math.floor(((baseTime + timeOffset) / 60) % 24)
            if minute ~= math.floor((baseTime + timeOffset) % 60) then
                minute = math.floor((baseTime + timeOffset) % 60)
                second = 0
            end
            NetworkOverrideClockTime(hour, minute, second) --Send hour included seconds to network clock time
        else
            Wait(1000)
        end
    end
end)

exports("GetCurrentWeather", function()
    return CurrentWeather
end)
exports("GetCurrentTime", function()
    return globalHour
end)
exports("GetBlackout", function()
    return blackout
end)

local devMode = false
RegisterNetEvent("al-admin:client:ToggleDevmode", function()
    devMode = not devMode
    if devMode then
        lib.notify({
            description = "Devmode toggled on!",
            type = "success"
        })
    else
        lib.notify({
            description = "Devmode toggled off!",
            type = "error"
        })
    end
end)

local DensityMultiplier = {
    ["vehs"] = 0.2,
    ["peds"] = 0.6,
    ["randomvehs"] = 0.2,
    ["parkedvehs"] = 0.2,
    ["scenpeds"] = 0.5
}
CreateThread(function()
    while true do
        Wait(5)
        if devMode or blackout then
            DensityMultiplier["vehs"] = 0.0
            DensityMultiplier["peds"] = 0.0
            DensityMultiplier["randomvehs"] = 0.0
            DensityMultiplier["parkedvehs"] = 0.0
            DensityMultiplier["scenepeds"] = 0.0
        elseif globalHour >= 20 or globalHour <= 7 then
            -- nakts
            DensityMultiplier["vehs"] = 0.1
            DensityMultiplier["peds"] = 0.1
            DensityMultiplier["randomvehs"] = 0.1
            DensityMultiplier["parkedvehs"] = 0.7
            DensityMultiplier["scenepeds"] = 0.1
        else
            -- diena
            DensityMultiplier["vehs"] = 0.3
            DensityMultiplier["peds"] = 0.7
            DensityMultiplier["randomvehs"] = 0.4
            DensityMultiplier["parkedvehs"] = 0.1
            DensityMultiplier["scenepeds"] = 0.5
        end
        SetVehicleDensityMultiplierThisFrame(DensityMultiplier["vehs"])
        SetPedDensityMultiplierThisFrame(DensityMultiplier["peds"])
        SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier["randomvehs"])
        SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier["parkedvehs"])
        SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier["scenpeds"], DensityMultiplier["scenpeds"])
    end
end)
