if not StressConfig.Enable then return end

local playerState = LocalPlayer.state

local seatbelt = playerState.seatbelt or false

local speedingLoop = function()
    CreateThread(function()
        while cache.vehicle do
            Wait(20000)

            local vehClass = GetVehicleClass(cache.vehicle)
            local speed = GetEntitySpeed(cache.vehicle) * 3.6

            local stressSpeed = (vehClass == 8) and StressConfig.MinimumSpeed or (seatbelt and StressConfig.MinimumSpeed or StressConfig.MinimumSpeedUnbuckled)
            
            if speed >= stressSpeed then
                lib.print.info('SPEEDING STRESS GAIN')
                TriggerServerEvent('hud:server:GainStress', math.random(1, 5))
            end
        end
    end)
end

local shootingLoop = function()
    CreateThread(function()
        while cache.weapon do
            Wait(0)

            if IsPedShooting(cache.ped) then
                if math.random() < StressConfig.StressChance and not StressConfig.WhitelistedWeaponStress[cache.weapon] then
                    lib.print.info('SHOOTING STRESS GAIN')
                    TriggerServerEvent('hud:server:GainStress', math.random(1, 5))
                end
            end
        end
    end)
end

lib.onCache('vehicle', function(vehicle)
    if not vehicle then return end
    Wait(5)

    lib.print.info('START VEHICLE STRESS LOOP')
    speedingLoop()
end)

lib.onCache('weapon', function(weapon)
    Wait(5)
    if not weapon then return end

    lib.print.info('START SHOOTING STRESS LOOP')
    shootingLoop()
end)

local function FadeIn(targetStrength, duration)
    SetTimecycleModifier("MP_death_grade_blend01")
    local steps = 30
    local stepTime = duration / steps
    for i = 1, steps do
        local progress = i / steps
        local currentStrength = targetStrength * progress
        SetTimecycleModifierStrength(currentStrength)
        Wait(stepTime)
    end
end

local function FadeOut(targetStrength, duration)
    local steps = 30
    local stepTime = duration / steps
    for i = 1, steps do
        local progress = i / steps
        local currentStrength = targetStrength * (1 - progress)
        SetTimecycleModifierStrength(currentStrength)
        Wait(stepTime)
    end
end

local function GetBlurIntensity(stresslevel)
    for _, v in pairs(StressConfig.Intensity['blur']) do
        if stresslevel >= v.min and stresslevel <= v.max then
            return v.intensity
        end
    end

    return 1500
end

local function GetEffectInterval(stresslevel)
    for _, v in pairs(StressConfig.EffectInterval) do
        if stresslevel >= v.min and stresslevel <= v.max then
            return v.timeout
        end
    end

    return 60000
end

CreateThread(function()
    while true do
        if StatData.stress <= 0 then
            ClearTimecycleModifier()
            Wait(1000)
        else
            local targetStrength = StatData.stress / 100
            local blurDuration = GetBlurIntensity(StatData.stress)
            local transitionDuration = math.max(blurDuration, 3000)
            FadeIn(targetStrength, transitionDuration)

            Wait(math.random(3000, 5000))

            FadeOut(targetStrength, transitionDuration)

            Wait(GetEffectInterval(StatData.stress))
        end
    end
end)