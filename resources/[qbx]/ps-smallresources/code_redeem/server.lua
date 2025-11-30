local webhookUrl = 'https://discord.com/api/webhooks/1398636566225616916/GF7tre3Ioez__7tyrkKl-ZdnMHzggpNr5vvyri1vv1fXDyuxje6K8sPt9NoQwqKFEPYV'
local Config = 'code_redeem/config'

local function Notify(src, description, type)
    lib.notify(src, {
        description = description,
        type = type,
    })
end

function DebugPrint(message)
    if Config.Debug then
        print("[DEBUG] " .. message)
    end
end

function SendToDiscord(title, message, color, extraFields)
    if not webhookUrl or webhookUrl == "" then
        return DebugPrint("^1[Discord Webhook] No webhook URL defined.^7")
    end

    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = color or 16777215,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ", os.time())
        }
    }

    if extraFields and type(extraFields) == "table" then
        for k, v in pairs(extraFields) do
            embed[1][k] = v
        end
    end

    PerformHttpRequest(webhookUrl, function(err, text, headers)
        if err ~= 204 then
            DebugPrint(string.format("^1[Discord Webhook] Failed to send message. HTTP %s | Response: %s^7", tostring(err), tostring(text)))
        end
    end, 'POST', json.encode({ embeds = embed }), { ['Content-Type'] = 'application/json' })
end

function GenerateRedeemCode(source, itemsJson, uses, expiryDays, customCode)
    if source ~= 0 and source ~= -1 and not exports.qbx_core:HasPermission(source, 'admin') then
        return Notify(source, "You do not have permission to use this command.", "error", 6000)
    end

    local playerName = GetPlayerName(source) or "Console"
    local identifiers = GetPlayerIdentifiers(source)
    local identifierMap = {}

    for _, id in ipairs(identifiers) do
        if id:find("license:") then
            identifierMap.license = id
        elseif id:find("license2:") then
            identifierMap.license2 = id
        elseif id:find("discord:") then
            identifierMap.discord = id:gsub("discord:", "")
        elseif id:find("steam:") then
            identifierMap.steam = id
        end
    end

    local cfxId = identifierMap.license or "N/A"
    local discordId = identifierMap.discord or "N/A"
    local steamId = identifierMap.steam or "N/A"

    local success, itemsTable = pcall(json.decode, itemsJson)
    if not success or type(itemsTable) ~= "table" then
        return Notify(source, "Invalid item data.", "error", 6000)
    end

    uses = tonumber(uses)
    expiryDays = tonumber(expiryDays)
    if not uses or uses <= 0 then return Notify(source, "Invalid uses.", "error", 6000) end
    if not expiryDays or expiryDays < 0 then expiryDays = 0 end

    local expiryDate = expiryDays > 0 and os.date("%Y-%m-%d %H:%M:%S", os.time() + (expiryDays * 86400)) or nil
    local expiryRaw = expiryDays > 0 and os.time() + (expiryDays * 86400) or nil

    local function isArray(t)
        if type(t) ~= "table" then return false end
        for k in pairs(t) do if type(k) ~= "number" then return false end end
        return true
    end

    local rewards = isArray(itemsTable) and itemsTable or { itemsTable }

    local totalItemCount = 0
    for _, reward in ipairs(rewards) do
        if reward.item then totalItemCount = totalItemCount + (tonumber(reward.amount) or 0) end
    end

    exports.oxmysql:execute(
            'INSERT INTO redeem_codes (code, total_item_count, items, uses, created_by, expiry, redeemed_by) VALUES (?, ?, ?, ?, ?, ?, ?)',
            { customCode, totalItemCount, itemsJson, uses, playerName, expiryDate, json.encode({}) },
            function(rowsChanged)
                local affected = type(rowsChanged) == "table" and rowsChanged.affectedRows or rowsChanged
                if affected and affected > 0 then
                    Notify(source, "Redeem code created successfully!", "success", 6000)

                    local rewardLines = {}
                    for _, reward in ipairs(rewards) do
                        if reward.item then
                            table.insert(rewardLines, string.format("- %dx %s", reward.amount or 1, reward.item))
                        elseif reward.money then
                            table.insert(rewardLines, string.format("- $%s (%s)", reward.amount or 0, reward.option or "cash"))
                        elseif reward.vehicle then
                            table.insert(rewardLines, string.format("- Vehicle: %s", reward.model or "Unknown"))
                        end
                    end

                    local rewardText = table.concat(rewardLines, "\n")
                    local message = string.format(
                            "**Admin:** `%s`\n**Code:** `%s`\n**Uses:** `%s`\n**Expiry:** <t:%s:R>\n\n**Rewards:**\n```asciidoc\n%s```\n\n**Identifiers:**\n```asciidoc\n- CFX: %s\n- Discord: %s\n- Steam: %s```",
                            playerName, customCode, uses, expiryRaw or "Never", rewardText, cfxId, discordId, steamId
                    )

                    SendToDiscord("Redeem Code Created", message, 3066993)
                else
                    Notify(source, "Failed to insert code into DB.", "error", 6000)
                end
            end
    )
end

RegisterServerEvent("al-redeemcodes:generateCode", function(itemsJson, uses, expiryDays, customCode)
    GenerateRedeemCode(source, itemsJson, uses, expiryDays, customCode)
end)

RegisterServerEvent("al-redeemcodes:redeemCode", function(code, option)
    local src = source
    local playerName = GetPlayerName(src)

    local identifiers = GetPlayerIdentifiers(src)
    local identifierMap = {}
    for _, id in ipairs(identifiers) do
        if id:find("license:") then
            identifierMap.license = id
        elseif id:find("license2:") then
            identifierMap.license2 = id
        elseif id:find("discord:") then
            identifierMap.discord = id:gsub("discord:", "")
        elseif id:find("steam:") then
            identifierMap.steam = id
        end
    end

    local identifier = identifierMap.license or identifierMap.license2 or identifierMap.steam or identifierMap.discord or "unknown"
    local playerId = identifier

    exports.oxmysql:execute('SELECT * FROM redeem_codes WHERE code = ? AND (expiry IS NULL OR expiry > NOW())', {
        code
    }, function(result)
        if result[1] then
            local redeemData = result[1]
            local items = json.decode(redeemData.items)
            local remainingUses = redeemData.uses
            local redeemedBy = json.decode(redeemData.redeemed_by) or {}

            if redeemedBy[playerId] then
                return Notify(src, "You have already redeemed this code!", "error", 6000)
            end

            if remainingUses <= 0 then
                return Notify(src, "This code has already been used the maximum number of times!", "error", 6000)
            end

            --local receivedSummary = {}
            local moneyReward = 0
            local accountType = option or "cash"

            for _, reward in ipairs(items) do
                if reward.item then
                    exports.ox_inventory:AddItem(src, reward.item, reward.amount)
                    --table.insert(receivedSummary, ("• %dx %s"):format(reward.amount or 1, reward.item))
                elseif reward.money then
                    local account = reward.option or option or "cash"
                    exports.qbx_core:AddMoney(src, account, reward.amount)
                    moneyReward = moneyReward + (tonumber(reward.amount) or 0)
                    accountType = account
                    --                    table.insert(receivedSummary, ("• $%s (%s)"):format(reward.amount or 0, account))
                elseif reward.vehicle then
                    local model = reward.model
                    if model then
                        local plate = string.upper(string.sub(GetPlayerName(src), 1, 3)) .. math.random(10000, 99999)
                        local props = {
                            model = model,
                            plate = plate
                        }

                        local state = 1
                        local Player = exports.qbx_core:GetPlayer(src)
                        exports.oxmysql:execute('INSERT INTO `player_vehicles` (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                            identifier, Player and Player.PlayerData.citizenid or "unknown", model, GetHashKey(model), json.encode(props), plate, state
                        })

                        --                        table.insert(receivedSummary, ("• Vehicle: %s (Plate: %s)"):format(model, plate))
                    end
                end
            end

            --local notifyMsg = "successful! You have received:\n" .. table.concat(receivedSummary, "\n")
            --Notify(src, notifyMsg, "success")

            redeemedBy[playerId] = true
            exports.oxmysql:execute('UPDATE redeem_codes SET uses = ?, redeemed_by = ? WHERE code = ?', {
                remainingUses - 1,
                json.encode(redeemedBy),
                code
            })

            local cfxId = identifierMap.license or "N/A"
            local discordId = identifierMap.discord or "N/A"
            local steamId = identifierMap.steam or "N/A"

            local itemSummary = "```asciidoc\n"
            for _, item in ipairs(items) do
                print(json.encode(item))
                local label = item.item or item.model or (item.option or "cash")
                if item.vehicle then
                    itemSummary = itemSummary .. "- Vehicle: " .. label .. "\n"
                elseif item.money then
                    itemSummary = itemSummary .. "- $" .. item.amount .. " (" .. label .. ")\n"
                else
                    itemSummary = itemSummary .. "- x" .. (item.amount or 1) .. " " .. label .. "\n"
                end
            end
            itemSummary = itemSummary .. "```"

            local message = string.format(
                    "**Redeemed By:** `%s`\n**Code:** `%s`\n\n**Rewards:**\n%s\n\n**Identifiers:**\n```asciidoc\n- CFX: %s\n- Discord: %s\n- Steam: %s```",
                    playerName, code, itemSummary, cfxId, discordId, steamId
            )

            SendToDiscord("Code Redeemed", message, 15844367)
        else
            Notify(src, "Invalid or expired code!", "error", 6000)
        end
    end)
end)

exports('GenerateRedeemCode', function(source, itemsJson, uses, expiryDays, customCode)
    GenerateRedeemCode(source, itemsJson, uses, expiryDays, customCode)
end)
