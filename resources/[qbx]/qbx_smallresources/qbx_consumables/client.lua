local alcoholCount = 0
local relieveCount = 0
local healing = false
local smokingWeed = false

local function healOxy()
    if not healing then
        healing = true
    else
        return
    end

    local count = 9
    while count > 0 do
        Wait(1000)
        count -= 1
        SetEntityHealth(cache.ped, GetEntityHealth(cache.ped) + 6)
    end
    healing = false
end

local function trevorEffect()
    AnimpostfxPlay('DrugsTrevorClownsFightIn', 3.0, false)
    Wait(3000)
    AnimpostfxPlay('DrugsTrevorClownsFight', 3.0, false)
    Wait(3000)
    AnimpostfxPlay('DrugsTrevorClownsFightOut', 3.0, false)
    AnimpostfxStop('DrugsTrevorClownsFight')
    AnimpostfxStop('DrugsTrevorClownsFightIn')
    AnimpostfxStop('DrugsTrevorClownsFightOut')
end
exports('TrevorEffect', trevorEffect)

local function methBagEffect()
    local startStamina = 8
    trevorEffect()
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.49)
    while startStamina > 0 do
        Wait(1000)
        if math.random(5, 100) < 10 then
            RestorePlayerStamina(cache.playerId, 1.0)
        end
        startStamina -= 1
        if math.random(5, 100) < 51 then
            trevorEffect()
        end
    end
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
end
exports('MethBagEffect', methBagEffect)

local function ecstasyEffect()
    local startStamina = 30
    SetFlash(0, 0, 500, 7000, 500)
    while startStamina > 0 do
        Wait(1000)
        startStamina -= 1
        RestorePlayerStamina(cache.playerId, 1.0)
        if math.random(1, 100) < 51 then
            SetFlash(0, 0, 500, 7000, 500)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
        end
    end
    if IsPedRunning(cache.ped) then
        SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
end
exports('EcstasyEffect', ecstasyEffect)

local function alienEffect()
    AnimpostfxPlay('DrugsMichaelAliensFightIn', 3.0, false)
    Wait(math.random(5000, 8000))
    AnimpostfxPlay('DrugsMichaelAliensFight', 3.0, false)
    Wait(math.random(5000, 8000))
    AnimpostfxPlay('DrugsMichaelAliensFightOut', 3.0, false)
    AnimpostfxStop('DrugsMichaelAliensFightIn')
    AnimpostfxStop('DrugsMichaelAliensFight')
    AnimpostfxStop('DrugsMichaelAliensFightOut')
end
exports('AlienEffect', alienEffect)

local function crackBaggyEffect()
    local startStamina = 8
    alienEffect()
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.3)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 10 then
            RestorePlayerStamina(cache.playerId, 1.0)
        end
        startStamina -= 1
        if math.random(1, 100) < 60 and IsPedRunning(cache.ped) then
            SetPedToRagdoll(cache.ped, math.random(1000, 2000), math.random(1000, 2000), 3, false, false, false)
        end
        if math.random(1, 100) < 51 then
            alienEffect()
        end
    end
    if IsPedRunning(cache.ped) then
        SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
end
exports('CrackBaggyEffect', crackBaggyEffect)

local function cokeBaggyEffect()
    local startStamina = 20
    alienEffect()
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.1)
    while startStamina > 0 do
        Wait(1000)
        if math.random(1, 100) < 20 then
            RestorePlayerStamina(cache.playerId, 1.0)
        end
        startStamina -= 1
        if math.random(1, 100) < 10 and IsPedRunning(cache.ped) then
            SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
        end
        if math.random(1, 300) < 10 then
            alienEffect()
            Wait(math.random(3000, 6000))
        end
    end
    if IsPedRunning(cache.ped) then
        SetPedToRagdoll(cache.ped, math.random(1000, 3000), math.random(1000, 3000), 3, false, false, false)
    end
    SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
end
exports('CokeBaggyEffect', cokeBaggyEffect)

local function smokeWeed()
    CreateThread(function()
        while smokingWeed do
            Wait(10000)
            TriggerServerEvent('hud:server:RelieveStress', math.random(15, 18))
            relieveCount += 1
            if relieveCount == 6 then
                exports.scully_emotemenu:cancelEmote()
                if smokingWeed then
                    smokingWeed = false
                    relieveCount = 0
                end
            end
        end
    end)
end

lib.callback.register('consumables:client:Eat', function(anim, prop)
    if lib.progressBar({
            duration = 5000,
            label = locale('progress.eating'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            },
            anim = anim or {
                clip = 'mp_player_int_eat_burger',
                dict = 'mp_player_inteat@burger',
                flag = 49
            },
            prop = prop or {
                {
                    model = 'prop_cs_burger_01',
                    bone = 18905,
                    pos = { x = 0.13, y = 0.05, z = 0.02 },
                    rot = { x = -50.0, y = 16.0, z = 60.0 }
                }
            }
        }) then -- if completed
        return true
    else    -- if canceled
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
        return false
    end
end)

lib.callback.register('consumables:client:Drink', function(anim, prop)
    if lib.progressBar({
            duration = 5000,
            label = locale('progress.drinking'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            },
            anim = anim or {
                clip = 'loop_bottle',
                dict = 'mp_player_intdrink',
                flag = 49
            },
            prop = prop or {
                {
                    model = 'prop_ld_flow_bottle',
                    bone = 18905,
                    pos = { x = 0.12, y = 0.008, z = 0.03 },
                    rot = { x = 240.0, y = -60.0, z = 0.0 }
                }
            }
        }) then -- if completed
        return true
    else    -- if canceled
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
        return false
    end
end)

lib.callback.register('consumables:client:DrinkAlcohol', function(alcoholLevel, anim, prop)
    if lib.progressBar({
            duration = math.random(3000, 6000),
            label = locale('progress.drinking_liquor'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            },
            anim = anim or {
                clip = 'loop_bottle',
                dict = 'mp_player_intdrink',
                flag = 49
            },
            prop = prop or {
                {
                    model = 'prop_amb_beer_bottle',
                    bone = 18905,
                    pos = { x = 0.12, y = 0.008, z = 0.03 },
                    rot = { x = 240.0, y = -60.0, z = 0.0 }
                }
            }
        }) then -- if completed
        alcoholCount += alcoholLevel or 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent('evidence:client:SetStatus', 'alcohol', 200)
        elseif alcoholCount >= 4 then
            TriggerEvent('evidence:client:SetStatus', 'heavyalcohol', 200)
        end
        return true
    else -- if canceled
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
        return false
    end
end)

RegisterNetEvent('consumables:client:Cokebaggy', function()
    if lib.progressBar({
            duration = math.random(5000, 8000),
            label = locale('progress.popping_pills'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            },
            anim = {
                dict = 'switch@trevor@trev_smoking_meth',
                clip = 'trev_smoking_meth_loop',
                flag = 49
            }
        }) then -- if completed
        local used = lib.callback.await('consumables:server:usedItem', false, 'cokebaggy')
        if not used then return end

        TriggerEvent('evidence:client:SetStatus', 'widepupils', 200)
        cokeBaggyEffect()
    else -- if canceled
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
    end
end)

RegisterNetEvent('consumables:client:Crackbaggy', function()
    if lib.progressBar({
            duration = math.random(7000, 10000),
            label = locale('progress.smoking_crack'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            },
            anim = {
                dict = 'switch@trevor@trev_smoking_meth',
                clip = 'trev_smoking_meth_loop',
                flag = 49
            }
        }) then -- if completed
        local used = lib.callback.await('consumables:server:usedItem', false, 'crack_baggy')
        if not used then return end

        TriggerEvent('evidence:client:SetStatus', 'widepupils', 300)
        crackBaggyEffect()
    else -- if canceled
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
    end
end)

RegisterNetEvent('consumables:client:EcstasyBaggy', function()
    if lib.progressBar({
            duration = 3000,
            label = locale('progress.popping_pills'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            },
            anim = {
                dict = 'mp_suicide',
                clip = 'pill',
                flag = 49
            }
        }) then -- if completed
        local used = lib.callback.await('consumables:server:usedItem', false, 'xtcbaggy')
        if not used then return end

        ecstasyEffect()
    else -- if canceled
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
    end
end)

RegisterNetEvent('consumables:client:oxy', function()
    if lib.progressBar({
            duration = 2000,
            label = locale('progress.healing'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            },
            anim = {
                dict = 'mp_suicide',
                clip = 'pill',
                flag = 49
            }
        }) then -- if completed
        local used = lib.callback.await('consumables:server:usedItem', false, 'oxy')
        if not used then return end
        TriggerEvent("al-hospital:client:consumedOxy")

        ClearPedBloodDamage(cache.ped)
        healOxy()
    else -- if canceled
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
    end
end)

RegisterNetEvent('consumables:client:armor', function()
    if lib.progressBar({
            duration = 5000,
            label = 'Applying armor...',
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            },
            anim = {
                dict = 'clothingshirt',
                clip = 'try_shirt_positive_d',
                flag = 49
            }
        }) then -- if completed
        local used = lib.callback.await('consumables:server:usedItem', false, 'armor')
        if not used then return end

        local playerPed = PlayerPedId()
        SetPedArmour(playerPed, 100)

        exports.qbx_core:Notify('Armor applied successfully!', 'success')
    else -- if canceled
        exports.qbx_core:Notify('Action canceled', 'error')
    end
end)

function GiveFoodArmor(armorAmount)
    local playerPed = PlayerPedId()

    if type(armorAmount) == 'number' then
        local currentArmor = GetPedArmour(playerPed)
        local newArmor = math.min(currentArmor + armorAmount, 100)
        SetPedArmour(playerPed, newArmor)
    end
end

exports('GiveFoodArmor', GiveFoodArmor)

local isStaminaBoostActive = false

function GiveStaminaBoost(duration)
    local playerPed = PlayerPedId()
    if isStaminaBoostActive or type(duration) ~= 'number' then return end

    isStaminaBoostActive = true

    CreateThread(function()
        local endTime = GetGameTimer() + duration * 1000
        while GetGameTimer() < endTime do
            RestorePlayerStamina(PlayerId(), 1.0)
            Wait(100) -- tune this interval if needed
        end
        isStaminaBoostActive = false
    end)
end

exports('GiveStaminaBoost', GiveStaminaBoost)

RegisterNetEvent('consumables:client:pd_armor', function()
    if lib.progressBar({
            duration = 4000,
            label = 'Applying armor...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            },
            anim = {
                dict = 'clothingshirt',
                clip = 'try_shirt_positive_d',
                flag = 49
            }
        }) then -- if completed
        local used = lib.callback.await('consumables:server:usedItem', false, 'pd_armor')
        if not used then return end

        local playerPed = PlayerPedId()
        SetPedArmour(playerPed, 100)

        exports.qbx_core:Notify('Armor applied successfully!', 'success')
    else -- if canceled
        exports.qbx_core:Notify('Action canceled', 'error')
    end
end)

RegisterNetEvent('consumables:client:meth', function()
    if lib.progressBar({
            duration = 1500,
            label = locale('progress.smoking_meth'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            },
            anim = {
                dict = 'switch@trevor@trev_smoking_meth',
                clip = 'trev_smoking_meth_loop',
                flag = 49
            }
        }) then -- if completed
        local used = lib.callback.await('consumables:server:usedItem', false, 'meth')
        if not used then return end

        TriggerEvent('evidence:client:SetStatus', 'widepupils', 300)
        TriggerEvent('evidence:client:SetStatus', 'agitated', 300)
        methBagEffect()
    else -- if canceled
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
    end
end)

RegisterNetEvent('consumables:client:UseJoint', function()
    if lib.progressBar({
            duration = 1500,
            label = locale('progress.lighting_joint'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            }
        }) then -- if completed
        local used = lib.callback.await('consumables:server:usedItem', false, 'joint')
        if not used then return end

        exports.scully_emotemenu:playEmoteByCommand('joint')
        TriggerEvent('evidence:client:SetStatus', 'weedsmell', 300)
        smokeWeed()

        -- Armor regen over time (+10 total)
        local ped = PlayerPedId()
        local addedArmor = 5
        local interval = 2000 -- ms
        local maxGain = 25

        CreateThread(function()
            while addedArmor < maxGain do
                Wait(interval)
                if not DoesEntityExist(ped) or IsEntityDead(ped) then break end

                local currentArmor = GetPedArmour(ped)
                if currentArmor >= 100 then break end

                local newArmor = math.min(currentArmor + 1, 100)
                SetPedArmour(ped, newArmor)
                addedArmor += 1
            end

            if addedArmor > 0 then
                exports.qbx_core:Notify(("You feel tougher (+%s Armor)"):format(addedArmor), "success")
            end
        end)
    else -- if canceled
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
    end
end)

--@TODO Rework this to only run when needed.
CreateThread(function()
    while true do
        Wait(10)
        if alcoholCount > 0 then
            Wait(1000 * 60 * 15)
            alcoholCount -= 1
        else
            Wait(2000)
        end
    end
end)

RegisterNetEvent('consumables:client:ApplyAlcoholEffect', function(strength, type)
    if lib.progressBar({
            duration = 1500,
            label = 'Drinking...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = false,
                car = false,
                mouse = false,
                combat = true
            },
            anim = {
                dict = 'mp_player_intdrink',
                clip = 'loop_bottle',
                flag = 49
            },
            prop = { model = 'prop_beer_stz', pos = vec3(0.01, -0.02, -0.15), rot = vec3(5.0, 5.0, -180.5) }
        }) then -- if completed
        local used = lib.callback.await('consumables:server:usedItem', false, type)
        if not used then return end

        print("Applying alcohol effect with strength:", strength)
        local duration = 15000 * strength -- Longer effect for stronger drinks
        local playerPed = PlayerPedId()

        -- Visual effects
        StartScreenEffect('Drunk', 0, true)
        ShakeGameplayCam('DRUNK_SHAKE', 1.0)
        SetTimecycleModifier('spectator5')

        -- Movement sway (animation-style drunken movement)
        RequestAnimSet('move_m@drunk@verydrunk')
        while not HasAnimSetLoaded('move_m@drunk@verydrunk') do
            Wait(0)
        end
        SetPedMovementClipset(playerPed, 'move_m@drunk@verydrunk', true)

        -- QBox Notification
        exports.qbx_core:Notify('You feel dizzy...', 'inform', 5000, 'Alcohol Effect')

        -- Wait duration
        Wait(duration)

        -- Clear effects
        StopScreenEffect('Drunk')
        ShakeGameplayCam('DRUNK_SHAKE', 0.0)
        ClearTimecycleModifier()
        ResetPedMovementClipset(playerPed, 0.0)
    else -- if canceled
        exports.qbx_core:Notify(locale('error.canceled'), 'error')
    end
end)
