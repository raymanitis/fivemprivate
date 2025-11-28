local Config = require 'rolldice.config'

lib.addCommand('roll', {
    help = 'Roll Dices',
    params = {
        { name = "dices", help = "Amount of Dices - Max: " .. Config.MaxDices, type = "number" },
        { name = "sides", help = "Amount of Sides - Max: " .. Config.MaxSides, type = "number" }
    },
}, function(source, args, raw)
    local dices = tonumber(args.dices)
    local sides = tonumber(args.sides)
    if (sides > 0 and sides <= Config.MaxSides) and (dices > 0 and dices <= Config.MaxDices) then
        TriggerEvent("ray-smallres:dice:server", source, dices, sides)
    else
        lib.notify(source, {
            description = "Invalid amount! Max Dices: ".. Config.MaxDices .." | Max Sides: ".. Config.MaxSides,
            type = "error"
        })
    end
end)

RegisterServerEvent('ray-smallres:dice:server')
AddEventHandler('ray-smallres:dice:server', function(source, dices, sides)
    local tabler = {}
    for i = 1, dices do
        table.insert(tabler, math.random(1, sides)) --Creates a table with the amount of dices. Randomises the sides eventually.
    end
    TriggerClientEvent("ray-smallres:dice:client:roll", -1, source, Config.MaxDistance, tabler, sides, GetEntityCoords(GetPlayerPed(source))) --Does the roll to everyone. It checks client sided if you are within the distance.
end)
