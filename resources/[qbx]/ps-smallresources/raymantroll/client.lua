---@diagnostic disable: undefined-global
local Config = require 'raymantroll/config'

local concealedSources = {}
local CONCEALED_HEAR_DISTANCE = 100.0
local DEFAULT_HEAR_DISTANCE = 15.0
local isLocalTrollvisActive = false
local overriddenPlayers = {}
local CUSTOM_VOICE_TARGET = 31 -- use a rarely-used target to avoid conflicts

local function debugPrint(message)
	if Config.Debug then
		print(('[raymantroll][DEBUG] %s'):format(message))
	end
end

local function applyConcealStateFor(sourceId, conceal)
	local player = cache(('rmt_player_%s'):format(sourceId), function()
		return GetPlayerFromServerId(sourceId)
	end, Config.cacheSettings.playerIdMapCacheTimeout)
	if player == -1 then return end -- invalid mapping; avoid concealing local ped
	local ped = cache(('rmt_ped_%s'):format(sourceId), function()
		return GetPlayerPed(player)
	end, Config.cacheSettings.playerPedCacheTimeout)
	if not ped or ped == 0 then return end
	-- Use visual invisibility instead of network conceal so voice remains intact
	if conceal then
		SetEntityAlpha(ped, 0, false)
		SetEntityNoCollisionEntity(PlayerPedId(), ped, true)
	else
		SetEntityAlpha(ped, 255, false)
		SetEntityNoCollisionEntity(PlayerPedId(), ped, false)
	end
	debugPrint(('Visual conceal (alpha) for %d -> %s'):format(sourceId, tostring(conceal)))
end

-- Switch to state bag-based sync: watch 'trollvisTarget'
-- Remove the old event-based path
-- React to replicated state
local function startHearingOverrideLoop()
    CreateThread(function()
        while isLocalTrollvisActive do
            local activePlayers = GetActivePlayers()
            -- rebuild custom voice target so we hear everyone regardless of pma proximity
            MumbleClearVoiceTarget(CUSTOM_VOICE_TARGET)
            for i = 1, #activePlayers do
                local pid = activePlayers[i]
                if pid ~= PlayerId() then
                    local sid = GetPlayerServerId(pid)
                    if sid and sid ~= 0 then
                        MumbleAddVoiceTargetPlayerByServerId(CUSTOM_VOICE_TARGET, sid)
                    end
                end
            end
            MumbleSetVoiceTarget(CUSTOM_VOICE_TARGET)
            -- apply/refresh overrides
            for i = 1, #activePlayers do
                local pid = activePlayers[i]
                if pid ~= PlayerId() then
                    MumbleSetVolumeOverride(pid, 1.0)
                    overriddenPlayers[pid] = true
                end
            end
            -- clear overrides for players that left
            for pid, _ in pairs(overriddenPlayers) do
                local stillActive = false
                for i = 1, #activePlayers do
                    if activePlayers[i] == pid then stillActive = true break end
                end
                if not stillActive then
                    MumbleClearVolumeOverride(pid)
                    overriddenPlayers[pid] = nil
                end
            end
            Wait(1000)
        end
        -- ensure all overrides are cleared when loop exits
        for pid, _ in pairs(overriddenPlayers) do
            MumbleClearVolumeOverride(pid)
            overriddenPlayers[pid] = nil
        end
        -- restore default voice target used by pma-voice (usually 1)
        MumbleClearVoiceTarget(CUSTOM_VOICE_TARGET)
        MumbleSetVoiceTarget(1)
    end)
end

CreateThread(function()
    AddStateBagChangeHandler('trollvisTarget', 'player:', function(bagName, key, value, _unused, replicated)
        local serverId = tonumber(bagName:sub(8))
        if not serverId then return end
        local myId = GetPlayerServerId(PlayerId())
        -- If this is our own state, never conceal our ped; only adjust hearing so we can still hear others
        if serverId == myId then
            if value and value > 0 then
                isLocalTrollvisActive = true
                -- try pma-voice proximity first; fallback to Mumble
                if exports['pma-voice'] and exports['pma-voice'].setVoiceProperty then
                    exports['pma-voice']:setVoiceProperty('proximity', CONCEALED_HEAR_DISTANCE)
                end
                MumbleSetAudioOutputDistance(CONCEALED_HEAR_DISTANCE)
                startHearingOverrideLoop()
            else
                isLocalTrollvisActive = false
                if exports['pma-voice'] and exports['pma-voice'].setVoiceProperty then
                    exports['pma-voice']:setVoiceProperty('proximity', DEFAULT_HEAR_DISTANCE)
                end
                MumbleSetAudioOutputDistance(DEFAULT_HEAR_DISTANCE)
            end
            return
        end
        if value and value > 0 then
            local conceal = myId ~= value
            concealedSources[serverId] = conceal or nil
            applyConcealStateFor(serverId, conceal)
        else
            concealedSources[serverId] = nil
            applyConcealStateFor(serverId, false)
        end
    end)
end)

-- Support immediate conceal updates from server (fast path)
RegisterNetEvent('raymantroll:conceal', function(sourceId, conceal)
    concealedSources[sourceId] = conceal or nil
    applyConcealStateFor(sourceId, conceal)
end)

CreateThread(function()
	while true do
		for sourceId, conceal in pairs(concealedSources) do
			if conceal then
				applyConcealStateFor(sourceId, true)
			end
		end
		Wait(Config.concealTickInterval)
	end
end)

-- On client start, unconceal everyone locally to avoid stale state after resource restart
CreateThread(function()
	local players = GetActivePlayers()
	for i = 1, #players do
		local serverId = GetPlayerServerId(players[i])
		if serverId and serverId ~= 0 then
			concealedSources[serverId] = nil
			applyConcealStateFor(serverId, false)
		end
	end
end)