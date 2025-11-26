if Config.Framework ~= 'QB' then
    return
end

local QBCore = exports['qb-core']:GetCoreObject()

Core.ShowNotification = function(text)
    QBCore.Functions.Notify(text)
end

Core.GetPlayerChips = function()
    return exports['ox_inventory']:Search('count', 'casino_chips')
end

Core.CreateInteraction = function(models)
    if Config.Interactions == 'ox_target' then
        exports['ox_target']:addModel(models, {
            {
                name = 'CasinoSlots',
                label = locale('play'),
                icon = locale('play_icon'),
                distance = 1.5,
                onSelect = function(data)
                    enterSlots(data)
                end
            }
        })
    elseif Config.Interactions == 'standalone' then
        local closestSlot, closestDist = nil, nil
        local plyCoords = nil
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(500)
                local playerPed = cache.ped
                plyCoords = GetEntityCoords(playerPed)
                local slotFound = false
                for i = 1, #models do
                    local model = models[i]
                    local tempSlot = GetClosestObjectOfType(plyCoords, 1.5, model, false, false, false)
                    if tempSlot and tempSlot ~= 0 then
                        local newDist = #(plyCoords - GetEntityCoords(tempSlot))
                        if closestDist and closestDist > newDist then
                            closestDist = newDist
                            closestSlot = tempSlot
                            slotFound = true
                        elseif not closestDist then
                            closestDist = newDist
                            closestSlot = tempSlot
                            slotFound = true
                        elseif closestSlot and closestSlot == tempSlot then
                            closestDist = newDist
                            slotFound = true
                        end
                    end
                end

                if not slotFound then
                    closestSlot = nil
                end
            end
        end)

        Citizen.CreateThread(function()
            while true do
                local sleep = 1000
                if closestSlot and not slotData.isActive then
                    sleep = 1
                    AddTextEntry('slotsEnter', locale('enter_slots'))
                    DisplayHelpTextThisFrame('slotsEnter', false)
                    if IsControlJustPressed(0, 38) then
                        enterSlots({
                            distance = closestDist,
                            entity = closestSlot
                        })
                    end
                end
                Citizen.Wait(sleep)
            end
        end)
    end
end