Editable = {}

local ESX, QBCore = nil, nil
if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

function Editable:randomPlate()
    local request = 'SELECT * FROM '..(ESX and 'owned_vehicles' or 'player_vehicles')..' WHERE plate = ?'
    local plate = nil
    repeat
        -- https://overextended.dev/ox_lib/Modules/String/Shared
        plate = lib.string.random('.', 8) -- 8 character long plate
    until not MySQL.single.await(request, {plate})
    return plate
end

---@param playerId number
---@param rewardData table {name: string, label: string, count: number, type: string, chance: number, animation: string}
function Editable:giveReward(playerId, rewardData)
    local _source = playerId
    if rewardData.type == 'item' then
        if ESX then
            local xPlayer = ESX.GetPlayerFromId(_source)
            xPlayer.addInventoryItem(rewardData.name, rewardData.count)
        elseif QBCore then
            local Player = QBCore.Functions.GetPlayer(_source)
            Player.Functions.AddItem(rewardData.name, rewardData.count)
        end
    elseif rewardData.type == 'vehicle' then
        local randomPlate = self:randomPlate()
        local vehicleData = {
            model = joaat(rewardData.name),
            plate = randomPlate,
            engineHealth = 1000.0,
            bodyHealth = 1000.0,
            fuelLevel = 100.0,
        }
        local id = nil
        if ESX then
            local xPlayer = ESX.GetPlayerFromId(_source)
            id = MySQL.insert.await([[
                INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) 
                VALUES (?, ?, ?, ?, ?)
            ]], {xPlayer.identifier, randomPlate, json.encode(vehicleData), 'car', 1})
        elseif QBCore then
            local Player = QBCore.Functions.GetPlayer(_source)
            id = MySQL.insert.await([[
                INSERT INTO player_vehicles (citizenid, plate, vehicle, hash, mods) 
                VALUES (?, ?, ?, ?, ?)
            ]], {Player.PlayerData.citizenid, randomPlate, rewardData.name, vehicleData.model, json.encode(vehicleData)})
        end

        if id then
            Bridge.Debug(('[Lucky Wheel] Vehicle reward given to %s (Plate: %s)'):format(GetPlayerName(_source), randomPlate))
        else
            lib.print.error('Failed to insert vehicle reward into database')
        end
    end
end