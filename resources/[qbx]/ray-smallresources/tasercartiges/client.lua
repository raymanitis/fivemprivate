local Config = require 'tasercartiges/config'

local cartridges = Config.MaxCartridges
local NoCartgridgesMessage = false
local cartridgesin = true
local SpamCooldownPressed = false

exports("PressedReload", function()
    if cache.weapon == `WEAPON_STUNGUN` then
        if cartridgesin == false then
            if SpamCooldownPressed == false then
                if Config.Debug == true then
                    print('Debug Pressed R')
                end
                SpamCooldownPressed = true
                TriggerServerEvent('checkTaserCartridges')
                Wait(Config.SpamCooldown)
                SpamCooldownPressed = false
                if Config.Debug == true then
                    print('Spam Protection Deactivated')
                end
            end
        end
    end
end)

RegisterNetEvent('reloadTaser')
AddEventHandler('reloadTaser', function()
    cartridgesin = true
    cartridges = Config.MaxCartridges
    NoCartgridgesMessage = false
    TriggerEvent('playReloadAnimation')
    TriggerEvent('spam')

end)

CreateThread(function()
    while true do
        Wait(5)
        if cache.weapon == `WEAPON_STUNGUN` then
            if cartridges <= 0 then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 257, true)
                DisableControlAction(0, 142, true)
                SetPedInfiniteAmmo(cache.ped, false, `WEAPON_STUNGUN`)
                if NoCartgridgesMessage == false then
                    cartridgesin = false
                    NoCartgridgesMessage = true
                    lib.notify({
                        description = 'Out of charges!',
                        type = 'error'
                    })
                end
            end
            if IsPedShooting(cache.ped) then
                if cartridges > 0 then
                    cartridges = cartridges - 1
                    if NoCartgridgesMessage == false then
                        if cartridges <= 0 then
                            cartridgesin = false
                            NoCartgridgesMessage = true
                            lib.notify({
                                description = 'Out of charges!',
                                type = 'error'
                            })
                        end
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

-- Function to play reload animation
RegisterNetEvent('playReloadAnimation')
AddEventHandler('playReloadAnimation', function()
    local playerPed = cache.ped
    local animDict = 'anim@cover@weapon@reloads@pistol@revolver'  -- Replace with the correct animation dictionary
    local animName = 'reload_low_left'  -- Replace with the correct animation name

    lib.requestAnimDict(animDict)
    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 48, 0, false, false, false)

    StopAnimTask(playerPed, animDict, animName, 1.0)
    RemoveAnimDict(animDict)
end)