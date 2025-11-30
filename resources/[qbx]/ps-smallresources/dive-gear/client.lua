local Config = require 'dive-gear/config'

local currentGear = {
    mask = 0,
    tank = 0,
    enabled = false
}

local oxygenLevel = 0

local function enableScuba()
    -- Don't use SetEnableScuba as it makes player invulnerable
    -- Instead, just set the underwater time to allow breathing
    SetPedMaxTimeUnderwater(cache.ped, 2000.00)
end

local function disableScuba()
    -- Reset underwater time to normal
    SetPedMaxTimeUnderwater(cache.ped, 1.00)
end

lib.callback.register('qbx_divegear:client:fillTank', function()
    if IsPedSwimmingUnderWater(cache.ped) then
        exports.qbx_core:Notify('You cannot do this underwater...', 'error')
        return false
    end

    if lib.progressBar({
        duration = Config.refillTankTimeMs,
        label = 'Filling air...',
        useWhileDead = false,
        canCancel = true,
        anim = {
            dict = 'clothingshirt',
            clip = 'try_shirt_positive_d',
            blendIn = 8.0
        }
    }) then
        oxygenLevel = Config.startingOxygenLevel
        exports.qbx_core:Notify('You\'ve successfully refilled your air tank!', 'success')
        if currentGear.enabled then
            enableScuba()
        end
        return true
    end
end)

local function deleteGear()
	if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, false, true)
        DeleteEntity(currentGear.mask)
		currentGear.mask = 0
    end

	if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, false, true)
        DeleteEntity(currentGear.tank)
		currentGear.tank = 0
	end
end

local function attachGear()
    local maskModel = `p_d_scuba_mask_s`
    local tankModel = `p_s_scuba_tank_s`
    lib.requestModel(maskModel)
    lib.requestModel(tankModel)

    currentGear.tank = CreateObject(tankModel, 1.0, 1.0, 1.0, true, true, false)
    SetEntityCollision(currentGear.tank, false, false)
    local bone1 = GetPedBoneIndex(cache.ped, 24818)
    AttachEntityToEntity(currentGear.tank, cache.ped, bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, true, true, false, false, 2, true)

    currentGear.mask = CreateObject(maskModel, 1.0, 1.0, 1.0, true, true, false)
    SetEntityCollision(currentGear.mask, false, false)
    local bone2 = GetPedBoneIndex(cache.ped, 12844)
    AttachEntityToEntity(currentGear.mask, cache.ped, bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, true, true, false, false, 2, true)
    SetModelAsNoLongerNeeded(maskModel)
    SetModelAsNoLongerNeeded(tankModel)
end

local function takeOffSuit()
    if lib.progressBar({
        duration = Config.takeOffSuitTimeMs,
        label = 'Taking off your diving suit...',
        useWhileDead = false,
        canCancel = true,
        anim = {
            dict = 'clothingshirt',
            clip = 'try_shirt_positive_d',
            blendIn = 8.0
        }
    }) then
        SetPedMaxTimeUnderwater(cache.ped, 50.00)
        currentGear.enabled = false
        deleteGear()
        exports.qbx_core:Notify('You\'ve taken your gear off!')
        -- Stop breathing suit audio
    end
end

local function startOxygenLevelDrawTextThread()
    CreateThread(function()
        while currentGear.enabled do
            -- Show UI only when underwater and gear is equipped a
            if oxygenLevel > 0 and IsPedSwimmingUnderWater(cache.ped) then
                -- Calculate time remaining in minutes and seconds
                local minutes = math.floor(oxygenLevel / 60)
                local seconds = oxygenLevel % 60
                local timeText = string.format("%02d:%02d", minutes, seconds)
                
                -- Draw small black background behind text
                DrawRect(0.5, 0.85, 0.08, 0.03, 0, 0, 0, 150)
                
                -- Draw time remaining in white
                SetTextScale(0.4, 0.4)
                SetTextFont(4)
                SetTextProportional(true)
                SetTextColour(255, 255, 255, 255)
                SetTextDropShadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(true)
                AddTextComponentString(timeText)
                DrawText(0.5, 0.835)
            end
            Wait(0)
        end
    end)
end

local function startOxygenLevelDecrementerThread()
    CreateThread(function()
        while currentGear.enabled do
            if IsPedSwimmingUnderWater(cache.ped) and oxygenLevel > 0 then
                oxygenLevel -= 1
                if oxygenLevel % 10 == 0 and oxygenLevel ~= Config.startingOxygenLevel then
                    -- Initiate breathing suit audio
                end
                if oxygenLevel == 0 then
                    disableScuba()
                    -- Stop breathing suit audio
                end
            end
            Wait(1000)
        end
    end)
end

local function putOnSuit()
    if oxygenLevel <= 0 then
        exports.qbx_core:Notify('You need to refill your oxygen! Get a replacement air supply!', 'error')
        return
    end

    if IsPedSwimming(cache.ped) or cache.vehicle then
        exports.qbx_core:Notify('You need to be on solid ground to put this on...', 'error')
        return
    end

    if lib.progressBar({
        duration = Config.putOnSuitTimeMs,
        label = 'Putting on your diving suit...',
        useWhileDead = false,
        canCancel = true,
        anim = {
            dict = 'clothingshirt',
            clip = 'try_shirt_positive_d',
            blendIn = 8.0
        }
    }) then
        deleteGear()
        attachGear()
        enableScuba()
        currentGear.enabled = true
        -- Initiate breathing suit audio
        startOxygenLevelDecrementerThread()
        startOxygenLevelDrawTextThread()
    end
end

RegisterNetEvent('qbx_divegear:client:useGear', function()
    if currentGear.enabled then
        takeOffSuit()
    else
        putOnSuit()
    end
end)