local utils = {}

function utils.SendReactMessage(action, data)
	SendNUIMessage({
		action = action,
		data = data
	})
end

function utils.ShowNUI(action, shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
	SendNUIMessage({
		action = action,
		data = shouldShow
	})
end


return utils