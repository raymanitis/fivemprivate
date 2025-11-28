local Config = require 'recoil/config'

local function getGroupName(weaponHash)
    local group = GetWeapontypeGroup(weaponHash)
    if group == 416676503 then return 'PISTOL' end
    if group == -957766203 then return 'SMG' end
    if group == 970310034 then return 'RIFLE' end
    return nil
end

local function getWeaponOverride(weaponHash)
    -- Match override by comparing provided weapon hash to GetHashKey of configured weapon names
    for weaponName, cfg in pairs(Config.weapons) do
        if GetHashKey(weaponName) == weaponHash then
            return cfg
        end
    end
    return nil
end

local function applyRecoil(ped, weapon, recoilSeconds)
    local startTime = GetGameTimer()
    while (GetGameTimer() - startTime) / 1000 < recoilSeconds do
        if GetFollowPedCamViewMode() ~= 4 then
            SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + 0.065, 0.17)
        end
        Wait(0)
    end
end

---@diagnostic disable: undefined-global
CreateThread(function()
    local ped = PlayerPedId()
    while true do
        Wait(0)
        ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if IsPedShooting(ped) then
            local overrideCfg = getWeaponOverride(weapon)
            local groupName = getGroupName(weapon)
            local classCfg = overrideCfg or ((groupName and Config.classes[groupName]) or Config.default)
            
            -- Apply camera shake
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', classCfg.shake)
            
            -- Apply recoil
            if classCfg.recoil > 0 and not IsPedDoingDriveby(ped) then
                applyRecoil(ped, weapon, classCfg.recoil)
            end
        end
    end
end)