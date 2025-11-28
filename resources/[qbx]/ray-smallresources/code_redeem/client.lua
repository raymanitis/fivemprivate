local Config = require 'code_redeem/config'

local function DebugPrint(message)
    if Config.Debug then
        print("[DEBUG] " .. message)
    end
end

function NotificationUser(_, description, type)
    lib.notify({
        description = description,
        type = type
    })
end

RegisterCommand(Config.GenerateCommand, function()
    if not lib.callback.await("ray-smallres:checkPermission") then return end

    local rewards = {}
    while true do
        local itemInput = lib.inputDialog('Add Reward Item', {
            { type = 'input', label = 'Item Name', placeholder = 'press cancel if no item', required = true },
            { type = 'number', label = 'Item Amount', placeholder = 'e.g. 1', required = true }
        })

        if not itemInput then
            DebugPrint("^1[DEBUG] Item input cancelled^7")
            break
        end

        local itemName = itemInput[1]
        local itemAmount = tonumber(itemInput[2])

        if itemName and itemAmount and itemAmount > 0 then
            table.insert(rewards, { item = itemName, amount = itemAmount })
        else
            NotificationUser(nil, 'Invalid item or amount. Please try again.', 'error')
            break
        end

        local choiceInput = lib.alertDialog({
            content = "Do you want to add another item?",
            centered = true,
            cancel = true,
            labels = {
                cancel = "No",
                confirm = "Yes"
            }
        })

        if choiceInput == 'cancel' then
            break
        end
    end
    Wait(500)

    local finalInput = lib.inputDialog('Finalize Redeem Code', {
        { type = 'input', label = 'Vehicle Name', placeholder = 'e.g. asbo', required = false },
        { type = 'number', label = 'Money Amount', placeholder = 'e.g. 500', required = false },
        { type = 'number', label = 'Uses', placeholder = 'e.g. 1', required = true },
        { type = 'number', label = 'Expiry (Days)', placeholder = 'e.g. 1', required = true },
        { type = 'input', label = 'Custom Code', placeholder = 'e.g. foodpack123', required = true }
    })

    if not finalInput then
        DebugPrint("^1[DEBUG] No input submitted for finalization^7")
        return
    end

    local vehicleName = finalInput[1] ~= "" and finalInput[1] or nil
    local moneyAmount = tonumber(finalInput[2])
    local uses = tonumber(finalInput[3])
    local expiryDays = tonumber(finalInput[4])
    local customCode = finalInput[5]

    if moneyAmount and moneyAmount > 0 then
        table.insert(rewards, { money = true, amount = moneyAmount })
    end

    if vehicleName then
        table.insert(rewards, { vehicle = true, model = vehicleName })
    end

    if #rewards == 0 then
        return NotificationUser(nil, 'You must provide at least an item, money, or vehicle.', 'error')
    end

    TriggerServerEvent("al-redeemcodes:generateCode", json.encode(rewards), uses, expiryDays, customCode)
end, false)

RegisterCommand(Config.RedeemCommand, function()
    local input = lib.inputDialog('Redeem Code', {
        { type = 'input', label = 'Enter Redeem Code', placeholder = 'e.g. raymanskruc1337', required = true },
        {
            default = 'cash',
            type = 'select',
            label = 'Receive Money In:',
            options = {
                { label = 'Cash', value = 'cash' },
                { label = 'Bank', value = 'bank' }
            },
            required = true
        }
    })

    if not input then return end

    local code = input[1]
    if code == '' then
        NotificationUser(nil, 'You must enter a redeem code.', 'error')
        return
    end
    local moneyOption = input[2]

    DebugPrint("CLIENT: sending redeemCode –", code, " as", moneyOption)
    TriggerServerEvent("al-redeemcodes:redeemCode", code, moneyOption)
end, false)