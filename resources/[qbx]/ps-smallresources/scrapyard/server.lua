local Config = require 'scrapyard/config'

-- Individual player timers for each loot spot
local playerLootCooldowns = {} -- [playerId][spotIndex] = timestamp
local carryingByPlayer = {}
local begunSpotByPlayer = {}

local function debugPrint(...)
    if Config.Debug then
        print('[scrapyard]', ...)
    end
end

local function now()
    return os.time()
end

local function giveItemToPlayer(playerId, itemName, amount)
    if amount <= 0 then return false end
    if GetResourceState('ox_inventory') ~= 'started' then
        print('ox_inventory is not started; cannot give items')
        return false
    end
    local items = exports.ox_inventory:Items()
    if not items or not items[itemName] then
        debugPrint(('Invalid item in Config.Rewards: %s'):format(tostring(itemName)))
        return false
    end
    return exports.ox_inventory:AddItem(playerId, itemName, amount) ~= false
end

local function awardRewards(playerId)
    local rewardsGiven = {}
    for i = 1, #Config.Rewards do
        local r = Config.Rewards[i]
        if r and r.item and r.min and r.max then
            local chance = r.chance or 100
            if math.random(1, 100) <= chance then
                local amount = math.random(r.min, r.max)
                if amount > 0 then
                    if giveItemToPlayer(playerId, r.item, amount) then
                        rewardsGiven[#rewardsGiven+1] = { item = r.item, amount = amount }
                    end
                end
            end
        end
    end
    return rewardsGiven
end

local function generateToken(length)
    length = length or 16
    local charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local token = {}
    for i = 1, length do
        local rand = math.random(1, #charset)
        token[i] = string.sub(charset, rand, rand)
    end
    return table.concat(token)
end

lib.callback.register('scrapyard:beginLoot', function(source, index)
    index = tonumber(index)
    if not index then return false end
    if carryingByPlayer[source] then
        debugPrint(('Player %s attempted beginLoot while already carrying'):format(source))
        return false
    end
    -- must be near the loot spot
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return false end
    local coords = GetEntityCoords(ped)
    local spot = Config.LootPlaces[index]
    if not spot then return false end
    if #(coords - spot) > (Config.TargetRadius or 0.6) + 0.8 then
        debugPrint(('Player %s not near loot spot %s'):format(source, index))
        return false
    end
    
    -- Individual player cooldown check
    local cooldownSeconds = tonumber(Config.CooldownLootPlaces or 120)
    if not playerLootCooldowns[source] then
        playerLootCooldowns[source] = {}
    end
    
    local last = playerLootCooldowns[source][index] or 0
    local remaining = (last + cooldownSeconds) - now()
    if remaining > 0 then
        debugPrint(('Player %s tried loot %s but %s seconds remaining'):format(source, index, remaining))
        return false, remaining -- Return remaining time for client notification
    end
    
    -- Set individual player cooldown
    playerLootCooldowns[source][index] = now()
    begunSpotByPlayer[source] = { index = index, started = now() }
    return true, 0
end)

lib.callback.register('scrapyard:pickupScrap', function(source, index)
    index = tonumber(index)
    if not index then return false end
    if carryingByPlayer[source] then
        return false
    end
    local begun = begunSpotByPlayer[source]
    if not begun or begun.index ~= index then
        return false
    end
    -- ensure still near the spot and sufficient search duration elapsed
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return false end
    local coords = GetEntityCoords(ped)
    local spot = Config.LootPlaces[index]
    if not spot then return false end
    if #(coords - spot) > (Config.TargetRadius or 0.6) + 0.8 then
        return false
    end
    local minElapsed = math.floor((Config.SearchDuration or 7000) * 0.6)
    if (now() - (begun.started or now())) < math.max(2, math.floor(minElapsed / 1000)) then
        -- enforce at least ~60% of search duration in seconds
        return false
    end
    begunSpotByPlayer[source] = nil
    local token = generateToken(18)
    carryingByPlayer[source] = { spot = index, token = token, started = now() }
    return token
end)

lib.callback.register('scrapyard:giveRewards', function(source, token)
    local carry = carryingByPlayer[source]
    if not carry then
        debugPrint(('Player %s attempted giveRewards without carry state'):format(source))
        return {}
    end
    if type(token) ~= 'string' or token ~= carry.token then
        debugPrint(('Player %s provided invalid token for delivery'):format(source))
        return {}
    end
    local expire = tonumber(Config.CarryExpireSeconds or 180)
    if (now() - (carry.started or now())) > expire then
        debugPrint(('Player %s token expired for delivery'):format(source))
        carryingByPlayer[source] = nil
        return {}
    end
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return {} end
    -- Avoid client-only native on server; fall back to GetVehiclePedIsIn if available
    local inVehicle = false
    if type(GetVehiclePedIsIn) == 'function' then
        local veh = GetVehiclePedIsIn(ped, false)
        inVehicle = veh and veh ~= 0
    elseif type(IsPedInAnyVehicle) == 'function' then
        inVehicle = IsPedInAnyVehicle(ped, false)
    end
    if inVehicle then
        debugPrint(('Player %s attempted delivery in a vehicle'):format(source))
        return {}
    end
    local coords = GetEntityCoords(ped)
    local target = vec3(Config.ScrapPlaces.coords.x, Config.ScrapPlaces.coords.y, Config.ScrapPlaces.coords.z)
    local dist = #(coords - target)
    if dist > 5.0 then
        debugPrint(('Player %s too far from NPC for delivery (%.2f m)'):format(source, dist))
        return {}
    end
    carryingByPlayer[source] = nil
    local results = awardRewards(source)
    return results
end)

-- Event-based delivery to reduce callback payloads; notifies client via state bag
RegisterNetEvent('scrapyard:deliver', function(token)
    local src = source
    local carry = carryingByPlayer[src]
    if not carry then
        debugPrint(('Player %s attempted deliver without carry state'):format(src))
        return
    end
    if type(token) ~= 'string' or token ~= carry.token then
        debugPrint(('Player %s provided invalid token for deliver'):format(src))
        return
    end
    local expire = tonumber(Config.CarryExpireSeconds or 180)
    if (now() - (carry.started or now())) > expire then
        debugPrint(('Player %s token expired for delivery'):format(src))
        carryingByPlayer[src] = nil
        return
    end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return end
    local inVehicle = false
    if type(GetVehiclePedIsIn) == 'function' then
        local veh = GetVehiclePedIsIn(ped, false)
        inVehicle = veh and veh ~= 0
    elseif type(IsPedInAnyVehicle) == 'function' then
        inVehicle = IsPedInAnyVehicle(ped, false)
    end
    if inVehicle then
        debugPrint(('Player %s attempted delivery in a vehicle'):format(src))
        return
    end
    local coords = GetEntityCoords(ped)
    local target = vec3(Config.ScrapPlaces.coords.x, Config.ScrapPlaces.coords.y, Config.ScrapPlaces.coords.z)
    local dist = #(coords - target)
    if dist > 5.0 then
        debugPrint(('Player %s too far from NPC for delivery (%.2f m)'):format(src, dist))
        return
    end

    carryingByPlayer[src] = nil
    local rewards = awardRewards(src)
    local msg
    if rewards and #rewards > 0 then
        local lines = {}
        for i = 1, #rewards do
            local r = rewards[i]
            lines[#lines+1] = (('%s x%s'):format(r.item, r.amount))
        end
        msg = ('Delivered scrap. Rewards: %s'):format(table.concat(lines, ', '))
    else
        msg = 'Sorry, there was nothing useful in that scrap.'
    end
    local state = Player(src).state
    state:set('scrapyardReward', { msg = msg, t = GetGameTimer() or os.time() }, true)
end)

-- Callback to check individual player cooldown for a specific spot
lib.callback.register('scrapyard:checkCooldown', function(source, index)
    index = tonumber(index)
    if not index then return 0 end
    
    if not playerLootCooldowns[source] then
        return 0
    end
    
    local cooldownSeconds = tonumber(Config.CooldownLootPlaces or 120)
    local last = playerLootCooldowns[source][index] or 0
    local remaining = (last + cooldownSeconds) - now()
    
    return math.max(0, remaining)
end)

AddEventHandler('playerDropped', function()
    local playerId = source
    carryingByPlayer[playerId] = nil
    begunSpotByPlayer[playerId] = nil
    playerLootCooldowns[playerId] = nil -- Clean up individual player cooldowns
end)


