local webhook = "https://discord.com/api/webhooks/1264486460963160155/zUmXWW400Votzdi7LA9Z0rNjiJDvTrq3M8UakpEr5rOfObo4zObF3V9WyyMUkcLlqqbO"

function sendLog(source,type,items,code)
    if webhook == "" then return end -- <-- DON'T ADD ANYTHING HERE PLEASE AND THANK U...
    local name = GetPlayerName(source)
    local discord_user = GetPlayerIdentifierByType(source, 'discord')
    discord_user = getDiscord(discord_user)
    local title = "Code Reedemed"
    local description = false
    local color = 5793266
    if type == "created" then
        title = "Code Generated"
        local items_list = formatItems(items)
        description = {
            "**Created by:** "..name..(discord_user and " <@"..discord_user..">" or ""),
            "**Code:** "..code,
            "**Item List:** "..items_list,
        }
    else
        color = 5763719
        description = {
            "**User:** "..name..(discord_user and " <@"..discord_user..">" or ""),
            "**Code:** "..code,
        }
    end
    
    local message = {
        {
            ['title'] = title,
            ['description'] = table.concat(description, "\n"),
            ['color'] = color,
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
        } 
    }
    PerformHttpRequest(webhook, function() end, 'POST', json.encode({ username = 'AV Scripts', embeds = message }), { ['Content-Type'] = 'application/json' })
end

function getDiscord(input)
    if not input or input == "" then
      return false
    end
    local result = input:gsub("^discord:", "")
    return result
end

function formatItems(data)
    local items = {}
    for _, item in ipairs(data) do
        table.insert(items, item.amount.."x "..item.label)
    end
    return table.concat(items, ",  \n")
end