local chatInputActive = false
local chatLoaded = false

Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false)
end)

lib.addKeybind({
    name = 'openChat',
    description = 'Open your chat',
    defaultKey = 'T',
    onPressed = function()
        if chatInputActive then return end
        if IsNuiFocusKeepingInput() or IsNuiFocused() then return end
        chatInputActive = true
        SendNUIMessage({
            type = 'ON_OPEN'
        })
    end,
    onReleased = function()
        if not chatInputActive then return end
        if IsNuiFocusKeepingInput() or IsNuiFocused() then return end
        SetNuiFocus(true)
    end
})

-- Events
RegisterNetEvent('chatMessage')
AddEventHandler('chatMessage', function(author, ctype, text)
    local args = { text }
    if author ~= "" then
        table.insert(args, 1, author)
    end
    local ctype = ctype ~= false and ctype or "normal"
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = {
            template = '<div class="chat-message ' .. ctype .. '"><div class="chat-message-body"><strong>{0}:</strong> {1}</div></div>',
            args = { author, text }
        }
    })
end)
RegisterNetEvent('chat:addMessage')
AddEventHandler('chat:addMessage', function(message)
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = message
    })
end)
RegisterNetEvent('chat:addSuggestion')
AddEventHandler('chat:addSuggestion', function(name, help, params)
    SendNUIMessage({
        type = 'ON_SUGGESTION_ADD',
        suggestion = {
            name = name,
            help = help,
            params = params or nil
        }
    })
end)
RegisterNetEvent('chat:addSuggestions')
AddEventHandler('chat:addSuggestions', function(suggestions)
    for _, suggestion in ipairs(suggestions) do
        SendNUIMessage({
            type = 'ON_SUGGESTION_ADD',
            suggestion = suggestion
        })
    end
end)
RegisterNetEvent('chat:removeSuggestion')
AddEventHandler('chat:removeSuggestion', function(name)
    SendNUIMessage({
        type = 'ON_SUGGESTION_REMOVE',
        name = name
    })
end)
RegisterNetEvent('chat:clear')
AddEventHandler('chat:clear', function(name)
    SendNUIMessage({
        type = 'ON_CLEAR'
    })
end)
AddEventHandler('onClientResourceStart', function(resName)
    Citizen.SetTimeout(1000, function()
        refreshCommands()
    end)
end)
AddEventHandler('onClientResourceStop', function(resName)
    Citizen.SetTimeout(1000, function()
        refreshCommands()
    end)
end)
RegisterNUICallback('loaded', function(data, cb)
    TriggerServerEvent('chat:init');
    refreshCommands()
    chatLoaded = true
    cb('ok')
end)

-- Functions
RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false
    SetNuiFocus(false, false)
    if not data.canceled then
        local id = PlayerId()
        local r, g, b = 0, 0x99, 255
        if data.message:sub(1, 1) == '/' then
            ExecuteCommand(data.message:sub(2))
        else
            ExecuteCommand(data.message:sub(1))
        end
    end
    cb('ok')
end)
function refreshCommands()
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()
        local suggestions = {}
        for _, command in ipairs(registeredCommands) do
            if tostring(command.name):find("^+") or tostring(command.name):find("^-") then
                goto ending
            end
            if IsAceAllowed(('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
            :: ending ::
        end
        TriggerEvent('chat:addSuggestions', suggestions)
    end
end