local vehicleModes = lib.loadJson('pursuitmodes/config')
local currentLevel = 0
local modIds = {
    ["Turbo"] = 18,
    ["Engine"] = 11,
    ["Brakes"] = 12,
    ["Transmission"] = 13,
    ["XenonHeadlights"] = 22,
}

lib.addKeybind({
    name = 'pursuit',
    description = 'Toggle pursuit modes (police)',
    defaultKey = "",
    onPressed = function()
        local vehicle = cache.vehicle
        if not vehicle or cache.seat ~= -1 then return end

        local modelHash = GetEntityModel(vehicle)
        local vehicleName = GetDisplayNameFromVehicleModel(modelHash)
        
        -- Try to get the actual model name by checking against our config
        local actualModelName = nil
        for _, v in pairs(vehicleModes["global"]["vehicles"]) do
            local configModelHash = GetHashKey(v.model)
            if configModelHash == modelHash then
                actualModelName = v.model
                break
            end
        end
        
        if actualModelName then
            vehicleName = actualModelName
        else
            vehicleName = vehicleName:lower()
        end
        local vehiclePresetName
        local vehiclePresetMods = {}
        for _, v in pairs(vehicleModes["global"]["vehicles"]) do
            if v.model == vehicleName then
                vehiclePresetName = v.preset
                for x, y in pairs(vehicleModes["global"]["presets"]) do
                    if y.id == vehiclePresetName then
                        vehiclePresetMods = y.modes
                        break
                    end
                end
                break
            end
        end
        if not vehiclePresetName then return end

        modLevel = vehiclePresetMods[1]
        currentLevel = currentLevel + 1
        if currentLevel > #vehiclePresetMods then currentLevel = 1 end

        local modLevel = vehiclePresetMods[currentLevel]
        SetVehicleXenonLightsColour(vehicle, modLevel.appearance.colors.xenon)
        --print("[DEBUG] Set XenonColor to", modLevel.appearance.colors.xenon)

        SetVehicleModKit(vehicle, 0)
        for k, v in pairs(modLevel.mods) do
            if modIds[k] then
                local modId = tonumber(modIds[k])
                if k == "Turbo" or k == "XenonHeadlights" then
                    ToggleVehicleMod(vehicle, modId, v)
                else
                    if v == "max" then
                        local maxUpgrade = GetNumVehicleMods(vehicle, modId) - 1
                        SetVehicleMod(vehicle, modId, maxUpgrade, false)
                        --print("[DEBUG] Set " .. k .. " to", v, "(" .. maxUpgrade .. ")")
                    else
                        SetVehicleMod(vehicle, modId, v, false)
                        --print("[DEBUG] Set " .. k .. " to", v)
                    end
                end
            end
        end

        for i = 1, #modLevel.handling do
            if not DecorIsRegisteredAsType(modLevel.handling[i].field, 3) then
                DecorRegister(modLevel.handling[i].field, 3)
            end
            Wait(1)
            local defaultValue = DecorGetFloat(vehicle, modLevel.handling[i].field)
            if defaultValue == 0 then
                defaultValue = GetVehicleHandlingFloat(vehicle, 'CHandlingData', modLevel.handling[i].field)
                DecorSetFloat(vehicle, modLevel.handling[i].field, defaultValue)
            end
        end
        for i = 1, #modLevel.handling do
            SetVehicleHandlingFloat(vehicle, 'CHandlingData', modLevel.handling[i].field, DecorGetFloat(vehicle, modLevel.handling[i].field) * modLevel.handling[i].multiplier)
            --print("[DEBUG] Set " .. modLevel.handling[i].field .. " to " .. DecorGetFloat(vehicle, modLevel.handling[i].field) * modLevel.handling[i].multiplier)
        end
        lib.notify({
            description = "Pursuit Mode: " .. modLevel.name,
            type = "success",
            position = 'top'
        })
    end
})