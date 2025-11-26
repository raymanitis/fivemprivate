lib.callback.register('tom_hud:getMileage', function(source, plate)
    local distance = exports["jg-vehiclemileage"]:GetMileage(plate)
    return distance
end)