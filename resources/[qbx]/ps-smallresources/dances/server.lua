lib.addCommand('dance', {
    help = 'Have a nice dance',
    params = {
        {
            name = 'dance',
            help = 'a number or just nothing',
            type = 'number',
            optional = true
        }
    },
}, function(source, args)
    if args.dance then
        local DanceNumber = tonumber(args.dance)
        TriggerClientEvent('al-dances:client:dance', source, DanceNumber)
    else
        TriggerClientEvent('al-dances:client:dance', source, -1)
    end
end)