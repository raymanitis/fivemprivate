QBCore = exports['qb-core']:GetCoreObject()

-- Open the clothing menu with progress bar and specified animation
RegisterNetEvent('mt-clothingbag:client:openBag', function()
    QBCore.Functions.Progressbar('clothingbag_open', 'Opening Clothing Bag...', 3000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'clothingshirt',
        anim = 'try_shirt_positive_d',
        flags = 16,
    }, {}, {}, function()
        ClearPedTasks(PlayerPedId())
        TriggerEvent('qb-clothing:client:openOutfitMenu') -- Open the clothing menu directly
    end)
end)
