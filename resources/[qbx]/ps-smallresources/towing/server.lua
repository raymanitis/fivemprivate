-- ---@diagnostic disable: undefined-global, param-type-mismatch, need-check-nil
-- local Config = (require 'towing/config').Config
-- local ropes = {}

-- -- Qbox (qbx_core) integration for usable item (optional)
-- local QBCore = nil
-- local hasOxInv = false
-- CreateThread(function()
--     if Config.useQbox then
--         local ok, core = pcall(function()
--             return exports['qbx_core']:GetCoreObject()
--         end)
--         if ok and core then
--             QBCore = core
--             QBCore.Functions.CreateUseableItem(Config.towRopeItem, function(source, item)
--                 -- No menu; ox_target handles interactions client-side
--             end)
--         end
--     end

--     -- Optional: ox_inventory usable item
--     hasOxInv = pcall(function()
--         return exports.ox_inventory
--     end)
--     if hasOxInv then
--         -- Prefer correct casing for ox_inventory export
--         local ok = pcall(function()
--             exports.ox_inventory:RegisterUsableItem(Config.towRopeItem, function(data, slot)
--                 -- No menu; ox_target handles interactions client-side
--             end)
--         end)
--         if not ok then
--             -- Fallback for older forks using lowercase name
--             pcall(function()
--                 exports.ox_inventory:registerUsableItem(Config.towRopeItem, function(data, slot)
--                     -- No menu; ox_target handles interactions client-side
--                 end)
--             end)
--         end
--     end
-- end)



-- -- ESX support removed for qbox/standalone

-- RegisterServerEvent("kuz_towing:tow")
-- AddEventHandler("kuz_towing:tow", function(veh1, veh2)
--     if hasOxInv then
--         -- Ensure player has the rope item when attempting to tow
--         local count = exports.ox_inventory:Search(source, 'count', Config.towRopeItem)
--         if (count or 0) <= 0 then
--             TriggerClientEvent('ox_lib:notify', source, { type = 'error', title = 'Towing', description = 'You need a rope to tow.' })
--             return
--         end
--     end

--     local allPlayers = GetPlayers()
--     for k, player in pairs(allPlayers) do
--         local playerId = tonumber(player) or player
--         TriggerClientEvent('kuz_towing:makeRope', playerId, veh1, veh2, source)
--     end
--     table.insert(ropes, {veh1, veh2, source})
-- end)


-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(Config.ropeSyncDuration * 1000)
--         refreshRopes()
--     end
-- end)

-- function refreshRopes()
--     local allPlayers = GetPlayers()
--     if #ropes > 0 then
--         for k, rope in pairs(ropes) do
--             for i, player in pairs(allPlayers) do
--                 local playerId = tonumber(player) or player
--                 TriggerClientEvent('kuz_towing:makeRope', playerId, rope[1], rope[2], rope[3], rope[3] == playerId)
--             end
--         end
--     end
-- end

-- RegisterServerEvent("kuz_towing:stopTow")
-- AddEventHandler("kuz_towing:stopTow", function()
--     local allPlayers = GetPlayers()

--     for k, rope in pairs(ropes) do
--         if rope[3] == source then
--             for i, player in pairs(allPlayers) do
--                 local playerId = tonumber(player) or player
--                 TriggerClientEvent('kuz_towing:removeRope', playerId, source, rope[1], rope[2])
--                 ropes[k] = nil
--             end
--         end
--     end
-- end)