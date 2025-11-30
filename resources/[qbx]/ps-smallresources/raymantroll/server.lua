---@diagnostic disable: undefined-global
local Config = require 'raymantroll/config'

local trollTargets = {}

local function debugPrint(message)
	if Config.Debug then
		print(('[raymantroll][DEBUG] %s'):format(message))
	end
end

local function toNumber(value)
	local n = tonumber(value)
	return n and math.floor(n) or nil
end

local function setTrollvisState(sourceId, targetId)
    local ply = Player(sourceId)
    if not ply then return end
    -- Replicated so all clients receive the state change
    ply.state:set('trollvisTarget', targetId, true)
end

local function broadcastConcealImmediate(sourceId, targetId)
    local players = GetPlayers()
    for i = 1, #players do
        local pid = toNumber(players[i])
        if pid and pid ~= sourceId then
            local conceal = false
            if targetId ~= nil then
                conceal = (pid ~= targetId)
            end
            TriggerClientEvent('raymantroll:conceal', pid, sourceId, conceal)
        end
    end
end

lib.addCommand(Config.commandEnable, {
	help = 'Make only the selected player see you',
	params = {
		{ name = 'targetId', type = 'playerId', help = 'Target player\'s server id' }
	},
	restricted = Config.restrictedGroup
}, function(source, args, raw)
	local src = source
	local targetId = toNumber(args.targetId)
	if not targetId or not GetPlayerName(targetId) then
		TriggerClientEvent('chat:addMessage', src, { args = { 'raymantroll', 'Invalid target ID' } })
		return
	end

	if targetId == src then
		TriggerClientEvent('chat:addMessage', src, { args = { 'raymantroll', 'Target cannot be yourself' } })
		return
	end

    trollTargets[src] = targetId
    setTrollvisState(src, targetId)
    broadcastConcealImmediate(src, targetId)
	debugPrint(('Source %d concealed from everyone except %d'):format(src, targetId))
	TriggerClientEvent('chat:addMessage', src, { args = { 'raymantroll', ('Only player %d can see you now'):format(targetId) } })
end)

lib.addCommand(Config.commandDisable, {
    help = 'Restore normal visibility (everyone sees you)',
    restricted = Config.restrictedGroup
}, function(source, args, raw)
    local src = source
    trollTargets[src] = nil
    setTrollvisState(src, nil)
    broadcastConcealImmediate(src, nil)
    debugPrint(('Source %d visibility reset for all'):format(src))
    TriggerClientEvent('chat:addMessage', src, { args = { 'raymantroll', 'Visibility reset. Everyone can see you.' } })
end)

AddEventHandler('playerDropped', function()
	local src = source
	if trollTargets[src] then
		-- Clear state; viewers will naturally stop seeing the ped as it despawns
		trollTargets[src] = nil
        setTrollvisState(src, nil)
	end
end)

-- Clear any leftover state on (re)start so nobody is stuck concealed
AddEventHandler('onResourceStart', function(resource)
	if resource ~= GetCurrentResourceName() then return end
	for _, id in ipairs(GetPlayers()) do
		local pid = toNumber(id)
		if pid then
			local ply = Player(pid)
			if ply then
				ply.state:set('trollvisTarget', nil, true)
			end
		end
	end
	-- reset internal mapping
	trollTargets = {}
end)