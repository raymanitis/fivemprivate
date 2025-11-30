RegisterServerEvent('_chat:messageEntered')
AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then return end
    TriggerEvent('chatMessage', source, author, message)
end)

RegisterServerEvent('__cfx_internal:commandFallback')
AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)
    TriggerEvent('chatMessage', source, name, '/' .. command)
    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, false, '/' .. command)
    end
    CancelEvent()
end)

RegisterServerEvent('chat:init')
AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Citizen.SetTimeout(1000, function()
        for _, player in ipairs(GetPlayers()) do
            refreshCommands(player)
        end
    end)
end)

-- Functions
function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()
        local suggestions = {}
        for _, command in ipairs(registeredCommands) do
            if tostring(command.name):find("^+") or tostring(command.name):find("^-") then
                goto ending
            end
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
            :: ending ::
        end
        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

local gbsJobList = {
    {
        job = 'police',
        grade = 2,
        message = {
            tag = {
                text = "POLICE",
                color = "#43b8ff"
            }
        }
    },
    {
        job = 'ambulance',
        grade = 2,
        message = {
            tag = {
                text = "EMS",
                color = "#ff4343"
            }
        }
    }
}
lib.addCommand('gbs', {
    help = "Global broadcast system for certain jobs",
    params = {
        {
            name = 'message',
            help = 'Message to broadcast',
            type = "longString",
        },
    },
}, function(source, args)
    local p = exports.qbx_core:GetPlayer(source)
    if p ~= nil then
        local data = nil
        for _, v in pairs(gbsJobList) do
            if p.PlayerData.job.name == v.job and (p.PlayerData.job.grade.level >= v.grade and p.PlayerData.job.onduty) then
                data = {
                    args = args.message,
                    tag = {
                        name = v.message.tag.text,
                        background = v.message.tag.color
                    },
                }
                break
            end
        end
        if data == nil then return end

        TriggerClientEvent('chat:addMessage', -1, data)
    end
end)