local SPEED_MULTIPLIER = Config.useMPH and 2.23694 or 3.6
local HUD_UPDATE_INTERVAL = 250
local VEHICLE_UPDATE_INTERVAL = 250

local playerState = LocalPlayer.state
local vehicleData = {
    open = false,
    nitroActive = false,
    nos = 0,
    speed = 0
}

local hudState = {
    isOpen = false,
    isInvOpen = false,
    cinematicBarsActive = false,
    settingsOpen = false
}

local function sendNUIMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

local function updatePlayerHud(data)
    sendNUIMessage("UPDATE_STATS", data)
end

local function updateVehicleHud(data)
    sendNUIMessage("UPDATE_VEHICLE", data)
end

local function updateCompass(data)
    sendNUIMessage("UPDATE_COMPASS", data)
end

local function toggleMinimap(show)
    if show then  sendNUIMessage("MINIMAP_SHOW", true) else sendNUIMessage("MINIMAP_HIDE", true) end
    DisplayRadar(show)
end

local function toggleSettings(show)
    if show and hudState.settingsOpen then return end
    
    sendNUIMessage("TOGGLE_SETTINGS", show)
    SetNuiFocus(show, show)
    hudState.settingsOpen = show
end

local function getPlayerStats()
    local stamina = 100 - GetPlayerSprintStaminaRemaining(cache.playerId)
    local oxygen = IsPedSwimmingUnderWater(cache.ped) and (GetPlayerUnderwaterTimeRemaining(cache.playerId) * 10) or 100
    local playerMode = IsEntityInWater(cache.ped) and 'water' or 'land'
    local playerData = GetPlayerData()

    if not playerData or not playerData.metadata then
        lib.print.info("Waiting for player data to load")
        return nil
    end

    return {
        health = math.max(0, math.ceil(GetEntityHealth(cache.ped) - 100)),
        armor = math.ceil(GetPedArmour(cache.ped)),
        thirst = playerData.metadata.thirst or 100,
        hunger = playerData.metadata.hunger or 100,
        stress = math.ceil(StatData.stress or 0),
        voice = StatData.voiceProximity or 0,
        talking = GetPlayerVoiceMethod(cache.playerId),
        stamina = playerMode == 'land' and stamina or oxygen,
    }
end

local function updatePlayerStats()
    if IsPauseMenuActive() or hudState.isInvOpen or hudState.cinematicBarsActive then
        updatePlayerHud({ open = false })
        return
    end

    local stats = getPlayerStats()
    if not stats then return end

    updatePlayerHud({
        open = hudState.isOpen,
        health = stats.health,
        armor = stats.armor,
        hunger = stats.hunger,
        thirst = stats.thirst,
        stress = stats.stress,
        voice = stats.voice,
        talking = stats.talking,
        stamina = stats.stamina,
    })
end

local function getVehicleStats()
    if not cache.vehicle then return nil end

    local vehicle = cache.vehicle
    local plate = GetVehicleNumberPlateText(vehicle)
    local distance = lib.callback.await('tom_hud:getMileage', false, plate) or 0
    local highGear = GetVehicleHighGear(vehicle)
    local currentGear = GetVehicleCurrentGear(vehicle)
    local engineState = GetIsVehicleEngineRunning(vehicle)

    local gearString = "N"
    if not engineState then
        gearString = ""
    elseif currentGear == 0 and GetEntitySpeed(vehicle) > 0 then
        gearString = "R"
    elseif currentGear == 1 and GetEntitySpeed(vehicle) < 0.1 and engineState then
        gearString = "N"
    elseif currentGear == 1 then
        gearString = "1"
    elseif currentGear > 1 then
        gearString = tostring(math.floor(currentGear))
    end

    local speed = math.floor(GetEntitySpeed(vehicle) * SPEED_MULTIPLIER)
    local rpm = math.ceil(CovertRPM(GetVehicleCurrentRpm(vehicle)))
    local fuel = math.ceil(GetVehicleFuelLevel(vehicle))
    local engineHealth = math.ceil(GetVehicleEngineHealth(vehicle) / 10)

    return {
        speed = speed,
        rpm = rpm,
        fuel = fuel,
        engineHealth = engineHealth,
        gears = highGear,
        currentGear = gearString,
        seatbelt = playerState.seatbelt or false,
        distance = Config.useMilage and distance or 0,
        nos = vehicleData.nos
    }
end

local function updateVehicleStats()
    if hudState.isInvOpen then return end

    local stats = getVehicleStats()
    if not stats then return end

    vehicleData.speed = stats.speed
    updateVehicleHud({
        open = hudState.isOpen,
        speed = stats.speed,
        rpm = stats.rpm,
        fuel = stats.fuel,
        engineHealth = stats.engineHealth,
        gears = stats.gears,
        currentGear = stats.currentGear,
        seatbelt = stats.seatbelt,
        distance = stats.distance,
        nos = stats.nos
    })
end

local function updateRoute()
    if hudState.isInvOpen then return end
    
    local route = GetStreet()
    updateCompass({
        open = hudState.isOpen,
        currentStreet = route.streetName,
        nextStreet = route.nextNearestStreet,
        direction = route.heading
    })
end

local function handleVehicleLoop()
    while cache.vehicle do
        if IsPauseMenuActive() or hudState.isInvOpen or hudState.cinematicBarsActive then
            updateVehicleHud({ open = false })
            toggleMinimap(false)
            updateCompass({ open = false })
            Wait(500)
            goto continue
        end

        if GetIsVehicleEngineRunning(cache.vehicle) then
            updateVehicleHud({ open = hudState.isOpen })
            updateCompass({ open = hudState.isOpen })
            toggleMinimap(true)
            SetRadarZoom(1000)
            SetBlipAlpha(GetNorthRadarBlip(), 0)
            
            while GetIsVehicleEngineRunning(cache.vehicle) do
                if IsPauseMenuActive() or hudState.isInvOpen or hudState.cinematicBarsActive then
                    updateVehicleHud({ open = false })
                    toggleMinimap(false)
                    updateCompass({ open = false })
                    Wait(500)
                    break
                end

                updateVehicleStats()
                updateRoute()
                vehicleData.open = hudState.isOpen
                Wait(VEHICLE_UPDATE_INTERVAL)
            end
            
            vehicleData.open = false
            toggleMinimap(false)
            updateVehicleHud({ open = false })
            updateCompass({ open = false })
            lib.print.info("Engine turned off")
        end
        
        ::continue::
        Wait(500)
    end
    
    lib.print.info("Player exited the vehicle")
end

local function onInvOpenChanged(_, _, invOpen)
    hudState.isInvOpen = invOpen
    if invOpen then
        updatePlayerHud({ open = false })
        if cache.vehicle then
            updateVehicleHud({ open = false })
            toggleMinimap(false)
        end
    else
        updatePlayerHud({ open = hudState.isOpen })
        if cache.vehicle and GetIsVehicleEngineRunning(cache.vehicle) then
            updateVehicleHud({ open = hudState.isOpen })
            toggleMinimap(true)
        end
    end
end

-- NUI Callbacks
local function onToggleCinematicBars(data, cb)
    local enabled = data.enabled
    hudState.cinematicBarsActive = enabled
    
    if enabled then
        updatePlayerHud({ open = false })
        if cache.vehicle then
            updateVehicleHud({ open = false })
            toggleMinimap(false)
            updateCompass({ open = false })
        end
    else
        updatePlayerHud({ open = hudState.isOpen })
        if cache.vehicle and GetIsVehicleEngineRunning(cache.vehicle) then
            updateVehicleHud({ open = hudState.isOpen })
            toggleMinimap(true)
            updateCompass({ open = hudState.isOpen })
        end
    end
    
    cb(1)
end

local function onCloseSettings(_, cb)
    hudState.settingsOpen = false
    toggleSettings(false)
    cb(1)
end

local function initializeHud()
    Wait(500)
    updatePlayerStats()

    if not cache.vehicle then
        toggleMinimap(false)
    end

    if cache.vehicle then
        handleVehicleLoop()
    end

    SetupMinimap()
    local minimapData = CalculateMinimap()
    SendReactMessage('MINIMAP_LOADED', minimapData)

    hudState.isOpen = true
end

AddStateBagChangeHandler('invOpen', ('player:%s'):format(cache.serverId), onInvOpenChanged)

AddEventHandler("pma-voice:radioActive", function(radioTalking)
    PlayerVoiceMethod = radioTalking and 'radio' or false
end)

AddStateBagChangeHandler('seatbelt', ('player:%s'):format(cache.serverId), function(_, _, value)
    seatbelt = value
end)

if GetResourceState('qbx_nitro') == 'started' then
    qbx.entityStateHandler('nitroFlames', function(veh, netId, value)
        local plate = qbx.string.trim(GetVehicleNumberPlateText(veh))
        local cachePlate = qbx.string.trim(GetVehicleNumberPlateText(cache.vehicle))
        if plate ~= cachePlate then return end
        vehicleData.nitroActive = value
    end)

    qbx.entityStateHandler('nitro', function(veh, netId, value)
        local plate = qbx.string.trim(GetVehicleNumberPlateText(veh))
        local cachePlate = qbx.string.trim(GetVehicleNumberPlateText(cache.vehicle))
        if plate ~= cachePlate then return end
        vehicleData.nos = value
    end)
end

RegisterNetEvent('hud:client:UpdateNitrous', function(_, nitroLevel, bool)
    vehicleData.nos = nitroLevel
    vehicleData.nitroActive = bool
end)

RegisterNUICallback('toggleCinematicBars', onToggleCinematicBars)
RegisterNUICallback('closeSettings', onCloseSettings)

CreateThread(function()
    while true do
        Wait(HUD_UPDATE_INTERVAL)
        updatePlayerStats()
    end
end)

lib.onCache('vehicle', function(vehicle)
    if not vehicle then return end
    Wait(250)
    lib.print.info('Starting vehicle HUD loop')
    handleVehicleLoop()
end)

lib.addKeybind({
    name = 'settings',
    description = 'Open Settings',
    defaultMapper = 'keyboard',
    default = 'I',
    onPressed = function()
        toggleSettings(true)
    end
})

exports('getHudState', function()
    return hudState
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', initializeHud)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    lib.print.info('Hiding HUD')
    updatePlayerHud({ open = false })
    updateVehicleHud({ open = false })
    toggleMinimap(false)
    hudState.isOpen = false
end)

if LocalPlayer.state.isLoggedIn then
    initializeHud()
end