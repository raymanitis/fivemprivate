local ox_inventory = exports['ox_inventory']

RegisterServerEvent('checkTaserCartridges')
AddEventHandler('checkTaserCartridges', function()
    local _source = source
    local itemCount = ox_inventory:Search(_source, "count", 'taser_cartridge')

    if itemCount > 0 then
        ox_inventory:RemoveItem(_source, 'taser_cartridge', 1)
        TriggerClientEvent('reloadTaser', _source)
    end

end)