if Config.Framework ~= 'ESX' then
    return
end

local ESX = exports['es_extended']:getSharedObject()

Core.ShowNotification = function(text)
    ESX.ShowNotification(text)
end

Core.GetPlayerChips = function()
    return exports['ox_inventory']:Search('count', 'casino_chips')
end

local tableEntities = {}
Core.CreateInteraction = function(index, entity)
    if Config.Interactions == 'ox_target' then
        exports['ox_target']:addLocalEntity(entity, {
            {
                name = 'Roulette_Table_'..index,
                label = locale('sit'),
                icon = 'fa-solid fa-chair',
                distance = 2,
                onSelect = function()
                    local closestChair = utils.getClosestChairData(entity)
                    if not closestChair then
                        return
                    end
    
                    TriggerServerEvent('p_roulette:server:sitDown', index, closestChair)
                end
            }
        })
    elseif Config.Interactions == 'standalone' then
        tableEntities[#tableEntities + 1] = {index = index, entity = entity}
    end
end

if Config.Interactions == 'standalone' then
    Wait(1000)
    local closestTable, closestDist = nil, nil
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            local playerPed = cache.ped
            local plyCoords = GetEntityCoords(playerPed)
            for i = 1, #tableEntities do
                local tableEntity = tableEntities[i]
                local tableCoords = GetEntityCoords(tableEntity.entity)
                local newDist = #(plyCoords - tableCoords)
                local tableFound = false
                if newDist < 2.5 then
                    if closestDist and newDist < closestDist then
                        tableFound = true
                        closestDist, closestTable = newDist, tableEntity
                    elseif not closestDist then
                        tableFound = true
                        closestDist, closestTable = newDist, tableEntity
                    elseif closestTable and closestTable.entity == tableEntity.entity then
                        tableFound = true
                        closestDist = newDist
                    end
                end

                if not tableFound then
                    closestTable, closestDist = nil, nil
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            local sleep = 1000
            if closestTable and not selectedTable then
                sleep = 1
                AddTextEntry('rouletteEnter', locale('enter_table'))
                DisplayHelpTextThisFrame('rouletteEnter', false)
                if IsControlJustPressed(0, 38) then
                    local closestChair = utils.getClosestChairData(closestTable.entity)
                    if closestChair then
                        TriggerServerEvent('p_roulette:server:sitDown', closestTable.index, closestChair)
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end