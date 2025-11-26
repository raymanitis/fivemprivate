local utils = require 'modules.utils'
local Config = require 'config'
local minimap = require 'modules.minimap'

local GetEntityHealth = GetEntityHealth
local GetPedArmour = GetPedArmour
local GetGameTimer = GetGameTimer
local PlayerPedId = PlayerPedId
local GetEntityHeading = GetEntityHeading
local GetEntityCoords = GetEntityCoords

local function diff(a, b, tol)
	if a == nil or b == nil then return true end
	return math.abs(a - b) > (tol or 0)
end

local lastHunger, lastThirst = 100, 100
local lastSource = 'default'
local oxcache = rawget(_G, 'cache')
if type(oxcache) ~= 'table' then oxcache = nil end

local hudVisible = false
local updateRadarVisible
local function setHudVisible(isVisible)
	hudVisible = isVisible and true or false
	utils.SendReactMessage('HUD_SET_VISIBLE', hudVisible)
	if updateRadarVisible then updateRadarVisible() end
	if Config.Debug then
		print(('rm-hudv2 -> HUD visible: %s'):format(tostring(hudVisible)))
	end
end

local inVehicleState = false
local radarShown = false
updateRadarVisible = function()
    local shouldShow = hudVisible and ((Config.MinimapShowOnFoot == true) or inVehicleState)
    radarShown = shouldShow
    DisplayRadar(shouldShow)
end

local function isPlayerLoaded()

	local okCore, QBCore = pcall(function()
		return exports['qb-core'] and exports['qb-core']:GetCoreObject()
	end)
	if okCore and QBCore and QBCore.Functions and QBCore.Functions.GetPlayerData then
		local okPd, playerData = pcall(QBCore.Functions.GetPlayerData)
		if okPd and playerData and (playerData.citizenid or playerData.metadata) then
			return true
		end
	end

	if LocalPlayer and LocalPlayer.state and LocalPlayer.state.isLoggedIn ~= nil then
		return LocalPlayer.state.isLoggedIn == true
	end
	return false
end

local cachedVoicePercent = 50

local function mapProximityToPercent(prox)
	if prox == nil then return nil end
	local t = type(prox)
	if t == 'table' then
		local idx = prox.index or prox.mode or prox[1]
		local name = prox.name or prox.mode
		if type(idx) == 'number' then
			if idx <= 1 then return 20 end
			if idx == 2 then return 50 end
			if idx >= 3 then return 100 end
		end
		if type(name) == 'string' then
			local s = string.lower(name)
			if s == 'whisper' then return 20 end
			if s == 'normal' then return 50 end
			if s == 'shout' or s == 'shouting' then return 100 end
		end
		return 50
	elseif t == 'number' then
		local n = prox
		if n <= 1 then return 20 end
		if n == 2 then return 50 end
		if n >= 3 then return 100 end
		return 50
	elseif t == 'string' then
		local s = string.lower(prox)
		if s == '1' or s == 'whisper' then return 20 end
		if s == '2' or s == 'normal' then return 50 end
		if s == '3' or s == 'shout' or s == 'shouting' then return 100 end
		return 50
	end
	return nil
end

RegisterNetEvent('pma-voice:setTalkingMode', function(mode)
	local pct = mapProximityToPercent(mode) or 50
	cachedVoicePercent = pct
	if Config.Debug then
		print(('rm-hudv2 voice -> event setTalkingMode mode:%s mapped:%s'):format(tostring(mode), tostring(pct)))
	end
end)

CreateThread(function()
    while true do
        if radarShown then
			HideHudComponentThisFrame(3)
			HideHudComponentThisFrame(4)
			HideHudComponentThisFrame(13)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
            HideHelpTextThisFrame()
            Wait(0)
        else
            Wait(250)
        end
    end
end)

local function sendTopRight()
	local serverId = GetPlayerServerId(PlayerId())
	local timeStr
	if Config.TopRightHud and Config.TopRightHud.time and Config.TopRightHud.time.enable then
		if Config.TopRightHud.time.ingame_time then
			local hour = GetClockHours()
			local minute = GetClockMinutes()
			timeStr = string.format('%02d:%02d', hour, minute)
		else
			local _y, _mo, _d, hour, minute, _s = GetLocalTime()
			timeStr = string.format('%02d:%02d', hour or 0, minute or 0)
		end
	end
	utils.SendReactMessage('HUD_TOPRIGHT', { playerId = serverId, timeStr = timeStr })
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    setHudVisible(true)
    CreateThread(function()
        Wait(150)
        minimap.setupMinimap()
        Wait(150)
        minimap.applyMinimapTextures('square')
        updateRadarVisible()
    end)
    sendTopRight()
    utils.SendReactMessage('HUD_CONFIG', {
        showCompassOnFoot = (Config.ShowCompassOnFoot == true),
        topRight = {
            idShow = (Config.TopRightHud and Config.TopRightHud.id_show == true) or false,
            timeEnable = (Config.TopRightHud and Config.TopRightHud.time and Config.TopRightHud.time.enable == true) or false,
            ingameTime = (Config.TopRightHud and Config.TopRightHud.time and Config.TopRightHud.time.ingame_time == true) or false,
            logoEnable = (Config.TopRightHud and Config.TopRightHud.logo and Config.TopRightHud.logo.enable == true) or false,
            logo = (Config.TopRightHud and Config.TopRightHud.logo and Config.TopRightHud.logo.logopng) or ''
        }
    })
end)
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
	setHudVisible(false)
end)

local function getFoodWater()
    local hunger, thirst
    local source = 'default'

	local okCore, QBCore = pcall(function()
		return exports['qb-core'] and exports['qb-core']:GetCoreObject()
	end)
    if okCore and QBCore and QBCore.Functions and QBCore.Functions.GetPlayerData then
		local okPd, playerData = pcall(QBCore.Functions.GetPlayerData)
		if okPd and playerData and playerData.metadata then
			hunger = playerData.metadata.hunger or hunger
			thirst = playerData.metadata.thirst or thirst
            source = 'qb-core:metadata'
		end
	end

	if hunger == nil or thirst == nil then
		local okQbx, playerData = pcall(function()
			if exports['qbx-core'] and exports['qbx-core'].GetPlayerData then
				return exports['qbx-core']:GetPlayerData()
			end
			if exports['qbx_core'] and exports['qbx_core'].GetPlayerData then
				return exports['qbx_core']:GetPlayerData()
			end
			return nil
		end)
        if okQbx and playerData and playerData.metadata then
			hunger = hunger or playerData.metadata.hunger
			thirst = thirst or playerData.metadata.thirst
            if hunger ~= nil or thirst ~= nil then
                source = 'qbx-core:metadata'
            end
		end
	end

    if (hunger == nil or thirst == nil) and LocalPlayer and LocalPlayer.state then
		local st = LocalPlayer.state
		local sHunger = st.hunger or st.Hunger or st.food or st.Food
		local sThirst = st.thirst or st.Thirst or st.water or st.Water
		if sHunger ~= nil then hunger = tonumber(sHunger) end
		if sThirst ~= nil then thirst = tonumber(sThirst) end
        if hunger ~= nil or thirst ~= nil then
            source = 'statebag'
        end
	end

	if hunger and hunger <= 1.0 and hunger >= 0 then hunger = hunger * 100 end
	if thirst and thirst <= 1.0 and thirst >= 0 then thirst = thirst * 100 end

	local function clamp(v)
		v = tonumber(v)
		if v == nil then return nil end
		if v < 0 then return 0 end
		if v > 100 then return 100 end
		return v
	end

	local ch = clamp(hunger)
	local ct = clamp(thirst)
    if ch == nil then ch = lastHunger else lastHunger = ch end
    if ct == nil then ct = lastThirst else lastThirst = ct end
    lastSource = source
    return ch, ct, source
end

-- Prefer statebag updates for hunger/thirst; fallback polling only when needed
_G.__hud_status_cache = _G.__hud_status_cache or { hunger = 100, thirst = 100, voice = 0, talking = false }
local __player_statebag = ('player:%s'):format((oxcache and oxcache.serverId) or GetPlayerServerId(PlayerId()))
AddStateBagChangeHandler('hunger', __player_statebag, function(_, _, value)
	local v = tonumber(value)
	if v ~= nil then _G.__hud_status_cache.hunger = v end
	_G.__hud_meta_source = 'statebag'
end)
AddStateBagChangeHandler('thirst', __player_statebag, function(_, _, value)
	local v = tonumber(value)
	if v ~= nil then _G.__hud_status_cache.thirst = v end
	_G.__hud_meta_source = 'statebag'
end)

-- Determine voice level percentage (mode) and whether player is talking
local function getVoiceState()
	local pid = (oxcache and oxcache.playerId) or PlayerId()
	local talking = false
    if NetworkIsPlayerTalking then
        local ok, res = pcall(NetworkIsPlayerTalking, pid)
        if ok then talking = (res == true or res == 1) end
    end
    if not talking and type(MumbleIsPlayerTalking) == 'function' then
        local ok, res = pcall(MumbleIsPlayerTalking, pid)
        if ok then talking = (res == true or res == 1) end
    end

	-- pma-voice talk distance mode (1=whisper,2=normal,3=shout)
	if GetResourceState and GetResourceState('pma-voice') == 'started' then
		-- Prefer state bag proximity (documented by pma-voice)
		local prox = (LocalPlayer and LocalPlayer.state and LocalPlayer.state.proximity) or nil
		local pct = mapProximityToPercent(prox)
		if pct == nil then
			-- Fallback to export if your build provides it
			local ok, mode = pcall(function()
				return exports['pma-voice'] and exports['pma-voice'].getMode and exports['pma-voice']:getMode()
			end)
			if ok and mode ~= nil then pct = mapProximityToPercent(mode) end
		end
		if pct == nil then pct = cachedVoicePercent end
		if Config.Debug then
			print(('rm-hudv2 voice -> prox:%s mapped:%s talking:%s'):format(tostring(prox), tostring(pct), tostring(talking)))
		end
		return pct, talking
	end

	-- mumble-voip fallback
	if GetResourceState and GetResourceState('mumble-voip') == 'started' then
		return 50, talking
	end

	return 50, talking
end

--- THIS WOULD BE FROM A FETCH NUI IN THE FRONTEND
RegisterNuiCallback('hideApp', function(data, cb)
    utils.ShowNUI('UPDATE_VISIBILITY', false)
    cb(true)
end)

-- Send unit to UI on start or when config changes
CreateThread(function()
	Wait(500)
	local unit = (Config.SpeedMeasurement == 'mph') and 'mph' or 'kph'
	utils.SendReactMessage('HUD_UNIT', unit)
	utils.SendReactMessage('HUD_CONFIG', {
		showCompassOnFoot = (Config.ShowCompassOnFoot == true),
		topRight = {
			idShow = (Config.TopRightHud and Config.TopRightHud.id_show == true) or false,
			timeEnable = (Config.TopRightHud and Config.TopRightHud.time and Config.TopRightHud.time.enable == true) or false,
			ingameTime = (Config.TopRightHud and Config.TopRightHud.time and Config.TopRightHud.time.ingame_time == true) or false,
			logoEnable = (Config.TopRightHud and Config.TopRightHud.logo and Config.TopRightHud.logo.enable == true) or false,
			logo = (Config.TopRightHud and Config.TopRightHud.logo and Config.TopRightHud.logo.logopng) or ''
		}
	})
	-- Start hidden until player is loaded
	if isPlayerLoaded() then
		setHudVisible(true)
		-- If already loaded on restart, push top-right once
		sendTopRight()
	else
		setHudVisible(false)
	end
	-- Initialize minimap layout and apply streamed textures shortly after start
	CreateThread(function()
		Wait(200)
		minimap.setupMinimap()
		Wait(200)
		minimap.applyMinimapTextures('square')
		updateRadarVisible()
	end)
end)

-- Status update loop (health, armour, hunger, thirst, voice)
CreateThread(function()
    -- Minimal-hud style: fixed waits; 150ms in vehicle, 500ms on foot
    local baseWait = 500
    local backoff = baseWait
    while true do
        Wait(backoff)
        -- Skip work when HUD hidden to save CPU
        if not hudVisible then goto continue end

		local ped = (oxcache and oxcache.ped) or PlayerPedId()

		-- Poll health/armour at a controlled cadence
		_G.__hud_next_hp = _G.__hud_next_hp or 0
		_G.__hud_hp_cache = _G.__hud_hp_cache or { health = 100, armour = 0 }
		local now = GetGameTimer()
		if now >= _G.__hud_next_hp then
			local h = GetEntityHealth(ped) - 100
			if h < 0 then h = 0 end
			local a = GetPedArmour(ped)
			_G.__hud_hp_cache.health = h
			_G.__hud_hp_cache.armour = a
			-- health/armour every 250ms in-vehicle, 500ms on-foot
			_G.__hud_next_hp = now + (inVehicleState and 250 or 500)
		end
		local health = _G.__hud_hp_cache.health
		local armour = _G.__hud_hp_cache.armour

		-- Throttle expensive metadata/voice fetches
		now = now -- reuse existing now
        _G.__hud_next_meta = _G.__hud_next_meta or 0
        _G.__hud_next_voice = _G.__hud_next_voice or 0

		local hunger, thirst
		if now >= _G.__hud_next_meta then
			-- Use statebag when available; otherwise fallback to export polling less often
			local st = LocalPlayer and LocalPlayer.state or nil
			local sHunger = st and (st.hunger or st.Hunger or st.food or st.Food) or nil
			local sThirst = st and (st.thirst or st.Thirst or st.water or st.Water) or nil
			if sHunger ~= nil or sThirst ~= nil then
				if sHunger ~= nil then _G.__hud_status_cache.hunger = tonumber(sHunger) or _G.__hud_status_cache.hunger end
				if sThirst ~= nil then _G.__hud_status_cache.thirst = tonumber(sThirst) or _G.__hud_status_cache.thirst end
				_G.__hud_meta_source = 'statebag'
				_G.__hud_next_meta = now + 5000
			else
				local h, t, src = getFoodWater()
				_G.__hud_status_cache.hunger = h
				_G.__hud_status_cache.thirst = t
				_G.__hud_meta_source = src
				_G.__hud_next_meta = now + ((src and src:find('metadata')) and 5000 or 10000)
			end
		end
		hunger = _G.__hud_status_cache.hunger
		thirst = _G.__hud_status_cache.thirst
		-- Clamp
		if hunger < 0 then hunger = 0 elseif hunger > 100 then hunger = 100 end
		if thirst < 0 then thirst = 0 elseif thirst > 100 then thirst = 100 end

		local voice, talking
        if now >= _G.__hud_next_voice then
            local v, tk = getVoiceState()
            _G.__hud_status_cache.voice = v
            _G.__hud_status_cache.talking = tk
            -- if pma-voice is present, rely mostly on its event and statebag; poll rarely
            _G.__hud_next_voice = now + 500
        end
		voice = _G.__hud_status_cache.voice
		talking = _G.__hud_status_cache.talking

		-- Only send when values change meaningfully (and throttle send rate)
		_G.__hud_last_status = _G.__hud_last_status or {}
		local ls = _G.__hud_last_status
		_G.__hud_next_status_send = _G.__hud_next_status_send or 0
		local nowSend = GetGameTimer()
		local changed = diff(health, ls.health, 1) or diff(armour, ls.armour, 1) or diff(hunger, ls.hunger, 1) or diff(thirst, ls.thirst, 1) or diff(voice, ls.voice, 1) or talking ~= ls.talking
        if changed and nowSend >= _G.__hud_next_status_send then
			utils.SendReactMessage('HUD_STATUS', {
				health = health,
				armour = armour,
				hunger = hunger,
				thirst = thirst,
				voice = voice,
				talking = talking
			})
			_G.__hud_last_status = { health = health, armour = armour, hunger = hunger, thirst = thirst, voice = voice, talking = talking }
            _G.__hud_next_status_send = nowSend + 400
            -- in-vehicle faster base wait
            backoff = inVehicleState and 150 or 500
		end

		::continue::
	end
end)

-- Vehicle + compass update loop
CreateThread(function()
    while true do
        local vehWait = inVehicleState and 150 or 500
        if not hudVisible then vehWait = 500 end
        Wait(vehWait)
        local ped = (oxcache and oxcache.ped) or PlayerPedId()

        -- Skip if HUD hidden
        if not hudVisible then goto continue end

        -- Compass (throttled + only when enabled); compute coords/heading only if needed
        if (Config.ShowCompassOnFoot == true) or inVehicleState then
            local now = GetGameTimer()
            _G.__hud_next_compass = _G.__hud_next_compass or 0
            _G.__hud_last_compass = _G.__hud_last_compass or { h = -1, street = '', zone = '' }
            -- read heading first; street/zone less often
            local heading = (oxcache and oxcache.heading) or GetEntityHeading(ped)
            if now >= _G.__hud_next_compass or math.abs((_G.__hud_last_compass.h or 0) - heading) >= 3.0 then
                local coords = (oxcache and oxcache.coords) or GetEntityCoords(ped)
                local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
                local street = GetStreetNameFromHashKey(streetHash) or ''
                local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z)) or ''
                if street ~= _G.__hud_last_compass.street or zone ~= _G.__hud_last_compass.zone or math.abs((_G.__hud_last_compass.h or 0) - heading) >= 1.0 then
                    utils.SendReactMessage('HUD_COMPASS', { heading = heading, street = street, zone = zone })
                    _G.__hud_last_compass = { h = heading, street = street, zone = zone }
                end
                _G.__hud_next_compass = now + (inVehicleState and 150 or 2000)
            end
        end

        -- Ensure Rockstar street/area labels stay hidden even if other resources toggle radar
        -- Common components: 6/7 area/vehicle, 8/9 street/subtitle depending on build
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)

		-- Vehicle
        local veh = (oxcache and oxcache.vehicle) or (IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) or nil)
        local nowInVehicle = veh ~= nil
        if nowInVehicle ~= inVehicleState then
            inVehicleState = nowInVehicle
            updateRadarVisible()
        end
        if veh then
			local speed = GetEntitySpeed(veh)
			if (Config.SpeedMeasurement == 'mph') then
				speed = speed * 2.236936 -- m/s -> mph
			else
				speed = speed * 3.6 -- m/s -> km/h
			end
            -- Fuel adapters
            local fuel = 100
            if Config.Fuel == 'cdn-fuel' and exports and exports['cdn-fuel'] and exports['cdn-fuel'].GetFuel then
                fuel = math.floor((exports['cdn-fuel']:GetFuel(veh)) or fuel)
            elseif Config.Fuel == 'ox_fuel' and GetVehicleFuelLevel then
                fuel = math.floor((GetVehicleFuelLevel(veh) or fuel))
            elseif Config.Fuel == 'native' and GetVehicleFuelLevel then
                fuel = math.floor((GetVehicleFuelLevel(veh) or fuel))
            elseif GetVehicleFuelLevel then
                fuel = math.floor((GetVehicleFuelLevel(veh) or fuel))
            end
			local rpm = GetVehicleCurrentRpm(veh) or 0.0
            if rpm < 0 then rpm = 0 end
            if rpm > 1 then rpm = 1 end
			local lightsOn = false
			local low, high = GetVehicleLightsState(veh)
			if low == 1 or high == 1 then lightsOn = true end
			local engineOn = GetIsVehicleEngineRunning(veh)
            -- Engine health mapped 0-100
            local engHealth = GetVehicleEngineHealth and GetVehicleEngineHealth(veh) or 1000.0
            if type(engHealth) ~= 'number' then engHealth = 1000.0 end
            local engineHealthPct = math.floor(math.max(0, math.min(100, (engHealth / 10.0))))
            -- Seatbelt state: try statebag first, then a global export flag hook
            local seatbelt = false
            if LocalPlayer and LocalPlayer.state and LocalPlayer.state.seatbelt ~= nil then
                seatbelt = LocalPlayer.state.seatbelt == true
            elseif exports and exports['qbx-seatbelt'] and exports['qbx-seatbelt'].IsSeatbeltOn then
                local ok, sb = pcall(function() return exports['qbx-seatbelt']:IsSeatbeltOn() end)
                if ok then seatbelt = sb == true end
            end

            -- Only send when values change meaningfully
            _G.__hud_last_vehicle = _G.__hud_last_vehicle or {}
            local lv = _G.__hud_last_vehicle
            local function diff(a, b, tol)
                if a == nil or b == nil then return true end
                return math.abs(a - b) > (tol or 0)
            end
            if diff(speed, lv.speedKmh, 0.5) or diff(fuel, lv.fuel, 1) or diff(rpm, lv.rpm, 0.02) or lightsOn ~= lv.lightsOn or engineOn ~= lv.engineOn or seatbelt ~= lv.seatbeltOn or diff(engineHealthPct, lv.engineHealth, 1) or not lv.inVehicle then
                utils.SendReactMessage('HUD_VEHICLE', {
                    speedKmh = speed,
                    fuel = fuel,
                    lightsOn = lightsOn,
                    engineOn = engineOn,
                    rpm = rpm,
                    seatbeltOn = seatbelt,
                    engineHealth = engineHealthPct,
                    inVehicle = true
                })
                _G.__hud_last_vehicle = { speedKmh = speed, fuel = fuel, lightsOn = lightsOn, engineOn = engineOn, rpm = rpm, seatbeltOn = seatbelt, engineHealth = engineHealthPct, inVehicle = true }
            end
        else
            if _G.__hud_last_vehicle == nil or _G.__hud_last_vehicle.inVehicle then
                utils.SendReactMessage('HUD_VEHICLE', { speedKmh = 0, inVehicle = false })
                _G.__hud_last_vehicle = { speedKmh = 0, inVehicle = false }
            end
		end

        ::continue::
	end
end)

-- No periodic refresher needed; top-right is set once on start/load