local Config = require 'qbx_weapondamages/config'

CreateThread(function()
    repeat Wait(500) until QBX.PlayerData.job ~= nil
    for weaponHash, modifier in pairs(Config.Weapons) do
        SetWeaponDamageModifier(weaponHash, modifier)
    end
end)

lib.onCache('ped', function(newPed)
    SetPedSuffersCriticalHits(newPed, false)
end)