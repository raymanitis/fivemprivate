GlobalState.dx_security = GlobalState.dx_security or false

local function setSecurity(isActive)
	local active = isActive and true or false
	if GlobalState.dx_security ~= active then
		GlobalState.dx_security = active
		-- Back-compat for clients listening to the old event
		TriggerClientEvent('dx_resource:securtySystem', -1, active)
	end
end

local function isAuthorized(source)
	local player = exports.qbx_core:GetPlayer(source)
	if not player or not player.PlayerData or not player.PlayerData.job then
		return false, player
	end
	local job = player.PlayerData.job
	return (job.name == 'police' and (job.grade and job.grade.level or 0) > 4), player
end

local lib = rawget(_G, 'lib')
if GetResourceState('ox_lib') == 'started' and lib and lib.addCommand then
    lib.addCommand('polsecurity', {
        help = 'Toggle the police security system',
    }, function(source, args, raw)
		local authorized, player = isAuthorized(source)
		if not authorized then
			local src = source
			if player and player.PlayerData and player.PlayerData.source then src = player.PlayerData.source end
			exports.qbx_core:Notify(src, "Your rank is too low", 'error')
			return
		end
		setSecurity(not GlobalState.dx_security)
		local src = player.PlayerData.source
		if GlobalState.dx_security then
			exports.qbx_core:Notify(src, "Security system is enabled", 'success')
		else
			exports.qbx_core:Notify(src, "Security system is disabled", 'error')
		end
	end)
else
    RegisterCommand('polsecurity', function(source, args, raw)
		local authorized, player = isAuthorized(source)
		if not authorized then
			local src = source
			if player and player.PlayerData and player.PlayerData.source then src = player.PlayerData.source end
			exports.qbx_core:Notify(src, "Your rank is too low", 'error')
			return
		end
		setSecurity(not GlobalState.dx_security)
		local src = player.PlayerData.source
		if GlobalState.dx_security then
			exports.qbx_core:Notify(src, "Security system is enabled", 'success')
		else
			exports.qbx_core:Notify(src, "Security system is disabled", 'error')
		end
    end, false)
end