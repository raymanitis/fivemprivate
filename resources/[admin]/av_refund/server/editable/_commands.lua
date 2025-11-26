-- Admin command

lib.addCommand(Config.AdminCommand, {
    help = Lang['admin_command_description'],
    params = {},
    restricted = Config.AdminGroups
}, function(source, args, raw)
    local items = getItems()
    if items then
        TriggerClientEvent("av_refund:openMenu", source, items)
    else
        print("^3[WARNING] ^7Function getItems() returned false instead of Items table, verify it in server/items.lua")
    end
end)

if Config.UsersCommand then
    lib.addCommand(Config.UsersCommand, {
        help = Lang['user_command_description'],
        params = {
            {
                name = 'code',
                help = 'Refund Code',
            }
        },
    }, function(source, args, raw)
        local code = args['code']
        if code then
            local res = MySQL.single.await('SELECT * FROM `av_refund` WHERE `identifier` = ? LIMIT 1', {
                code
            })
            if res then
                local identifier = processCode(source,res,code)
                TriggerClientEvent("av_refund:openStash", source, identifier)
            else
                TriggerClientEvent("av_refund:notification",source,Lang['title'],Lang['wrong_code'], "error")
            end
        end
    end)
end