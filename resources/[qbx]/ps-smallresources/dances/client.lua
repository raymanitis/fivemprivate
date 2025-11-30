local Config = require 'dances/config'
local Dancing = false

-- // Events \\ --
RegisterNetEvent('al-dances:client:clear:dance')
AddEventHandler('al-dances:client:clear:dance', function()
    ClearPedTasks(cache.ped)
    Dancing = false
end)

RegisterNetEvent('al-dances:client:dance')
AddEventHandler('al-dances:client:dance', function(DanceNumber)
    local TotalAnims = #Config.Dances
    if DanceNumber == -1 then
        DanceNumber = math.random(TotalAnims)
    end
    if DanceNumber > TotalAnims or DanceNumber <= 0 then return end
    if not Config.Dances[DanceNumber]['Disabled'] then
        Dancing = true
        RequestAnimDict(Config.Dances[DanceNumber]['Dict'])
        while not HasAnimDictLoaded(Config.Dances[DanceNumber]['Dict']) do
            Wait(5)
        end
        TaskPlayAnim(cache.ped, Config.Dances[DanceNumber]['Dict'], Config.Dances[DanceNumber]['Anim'], 3.0, 3.0, -1, 1, 0, 0, 0, 0)
    end
end)
