local waxedPlates = {}

local function normalizePlate(plate)
    if not plate or type(plate) ~= 'string' then return nil end
    return plate:gsub('%s+', ''):upper()
end

CreateThread(function()
    exports.qbx_core:CreateUseableItem('vehicle_wax', function(source, item)
        TriggerClientEvent('dx_wax:client:beginWax', source)
    end)
end)

RegisterNetEvent('dx_wax:server:applyWax', function(plate)
    local src = source
    local normalized = normalizePlate(plate)
    if not normalized then return end

    local removed = exports.ox_inventory:RemoveItem(src, 'vehicle_wax', 1)
    if not removed then
        return
    end

    waxedPlates[normalized] = true
    TriggerClientEvent('dx_wax:client:waxed', src, normalized)
    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'Vehicle has been waxed!' })
end)

lib.callback.register('dx_wax:server:isWaxed', function(_, plate)
    local normalized = normalizePlate(plate)
    if not normalized then return false end
    return waxedPlates[normalized] or false
end)



