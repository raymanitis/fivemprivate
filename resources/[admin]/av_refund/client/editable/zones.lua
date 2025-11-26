if not Config.UseDeliveryCoords then return end

local allZones = {}

CreateThread(function()
    if Config.DeliveryCoords and next(Config.DeliveryCoords) then
        for k, v in pairs(Config.DeliveryCoords) do
            allZones[#allZones+1] = lib.points.new({
                coords = vector3(v['x'], v['y'], v['z']),
                distance = 3,
            })
        end
        for _, zone in pairs(allZones) do
            function zone:nearby()
                if not lib.isTextUIOpen() then
                    lib.showTextUI(Lang['refund_textui'])
                end
                if self.currentDistance < 2 and IsControlJustReleased(0, 38) then
                    refundMenu()
                end
            end
            function zone:onExit()
                if lib.isTextUIOpen() then
                    lib.hideTextUI()
                end
            end
        end
    end
end)

function refundMenu()
    local input = lib.inputDialog(Lang['refund_title'], {
        {type = 'input', label = Lang['refund_code'], description = Lang['refund_description'], required = true, password = true},
    })
    if input and input[1] then
        TriggerServerEvent("av_refund:redeem", input[1])
    end
end