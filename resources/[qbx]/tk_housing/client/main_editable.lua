function Notify(text, notifyType)
    if Config.NotificationType == 'mythic' then
        exports['mythic_notify']:DoHudText(notifyType, text)
    elseif Config.NotificationType == 'ox' then
        lib.notify({
            title = 'Housing',
            description = text,
            type = notifyType
        })
    else
        ShowNotification(text, notifyType)
    end
end

function DisplayHelpText(text)
    AddTextEntry('housing_help_text', text)
    DisplayHelpTextThisFrame('housing_help_text', false)
end

function ShowTextUI(text)
    if Config.UseOxLib then
        lib.showTextUI(text, {position = 'right-center'})
    else
        exports['qb-core']:DrawText(text, 'left')
    end
end

function HideTextUI()
    if Config.UseOxLib then
        lib.hideTextUI()
    else
        exports['qb-core']:HideText()
    end
end

function OxRemoveBoxZone(zone)
    exports.ox_target:removeZone(zone)
end

function OxAddBoxZone(options)
    return exports.ox_target:addBoxZone(options)
end

function OxAddLocalEntity(entity, options)
    return exports.ox_target:addLocalEntity(entity, options)
end

function OxRemoveLocalEntity(entity)
    exports.ox_target:removeLocalEntity(entity)
end

function Draw3DText(coords, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 400
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local propertyBlips = {}

function RemovePropertyBlip(propertyIndex)
    if propertyBlips[propertyIndex] and DoesBlipExist(propertyBlips[propertyIndex]) then
        RemoveBlip(propertyBlips[propertyIndex])
    end

    propertyBlips[propertyIndex] = nil
end

function CreatePropertyBlip(propertyIndex, coords, blipType)
    RemovePropertyBlip(propertyIndex)

    if not coords then return end
    local settings = Config.Blips[blipType]
    if not settings?.enable then return end

    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, settings.sprite)
    SetBlipScale(blip, settings.scale)
    SetBlipColour(blip, settings.color)
    SetBlipDisplay(blip, 2)
    SetBlipAsShortRange(blip, true)

    if blipType == 'owned' then
        SetBlipCategory(blip, 11)
    elseif blipType == 'access' then
        SetBlipCategory(blip, 11)
    elseif blipType == 'on_sale' then
        SetBlipCategory(blip, 10)
    end

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(_U('blip_' .. blipType, propertyIndex))
    EndTextCommandSetBlipName(blip)

    propertyBlips[propertyIndex] = blip
end

function WeatherSync(enable) -- Add your weather sync enable / disable event here
    if enable then -- enable weather sync
        TriggerEvent('cd_easytime:PauseSync', false)
        return
    end

    TriggerEvent('cd_easytime:PauseSync', true)

    CreateThread(function()
        while isInsideProperty do
            NetworkOverrideClockTime(12, 0, 0)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist('OVERCAST')
            SetWeatherTypeNow('OVERCAST')
            SetWeatherTypeNowPersist('OVERCAST')
            SetRainLevel(0.0)
            Wait(0)
        end
    end)
end

function LockpickDoor(propertyIndex)
    if Config.Lockpicking.door.item and GetItemAmount(Config.Lockpicking.door.item) <= 0 then return Notify(_U('need_lockpick', 'error')) end
    if GetAmountOfOnlinePlayersWithAccessToProperty(propertyIndex) < Config.Lockpicking.door.playersWithAccessNeeded then return Notify(_U('cant_lockpick_right_now'), 'error') end
    TriggerServerEvent('tk_housing:alertPlayersWithAccessToProperty', propertyIndex)

    local success = Config.DebugMode or exports['pd-safe']:createSafe({math.random(0,99), math.random(0,99), math.random(0,99), math.random(0,99)}) -- change lockpicking minigame here

    if not success then
        RemoveItem(Config.Lockpicking.door.item)
        Notify(_U('lockpicking_failed'), 'error')
        return
    end

    Notify(_U('lockpicking_succeeded'), 'success')
    EnterProperty()
end

---player tries to purchase a property
---@param purchaseType 'price' | 'rent' price means player is buying a property, rent means player is renting a property
---@param propertyData table data of the property
---@return boolean canPurchase whether the player can purchase the property
function CanPurchaseProperty(purchaseType, propertyData)
    return true
end

function OpenGarageMenu(propertyIndex) -- only used if Config.UseCustomGarageMenu is true, add your own logic here to open the garage menu
    print('Open garage menu', propertyIndex)
end

function CanEnterProperty(propertyData) -- called when player is trying to enter a property
    return true
end

function EnteringHouse(propertyIndex) -- called when player is entering a house

end

function LeavingHouse(propertyIndex) -- called when player is leaving a house

end

function EnteringGarage(propertyIndex) -- called when player is entering a garage

end

function LeavingGarage(propertyIndex) -- called when player is leaving a garage

end

function ToggleFurnishing(isFurnishing) -- called when player starts/stops furnishing a house

end

function TogglePhotoMode(isTakingPhoto) -- called when a player is taking a photo

end

function LockpickStorage(propertyIndex, propertyType, storageId, model)
    if Config.Lockpicking.storage.item and GetItemAmount(Config.Lockpicking.storage.item) <= 0 then return Notify(_U('need_lockpick', 'error')) end
    if GetAmountOfOnlinePlayersWithAccessToProperty(propertyIndex) < Config.Lockpicking.storage.playersWithAccessNeeded then return Notify(_U('cant_lockpick_right_now', 'error')) end

    TriggerServerEvent('tk_housing:alertPlayersWithAccessToProperty', propertyIndex)

    local success = Config.DebugMode or exports['pd-safe']:createSafe({math.random(0,99), math.random(0,99), math.random(0,99), math.random(0,99)}) -- change lockpicking minigame here

    if not success then
        RemoveItem(Config.Lockpicking.storage.item)
        Notify(_U('lockpicking_failed'), 'error')
        return
    end

    Notify(_U('lockpicking_success'), 'success')
    OpenStorage(propertyIndex, propertyType, storageId, model)
end

function GetVehicleFuel(veh)
    local success, result = pcall(function()
        return exports['LegacyFuel']:GetFuel(veh)
    end)

    if success then
        return result
    end

    return GetVehicleFuelLevel(veh)
end

function SetVehicleFuel(veh, fuel)
    local success = pcall(function()
        exports["LegacyFuel"]:SetFuel(veh, fuel)
    end)

    if not success then
        SetVehicleFuelLevel(veh, fuel)
    end
end

function GetVehicleProperties(veh)
    if Config.Framework == 'qb' then
        return QBCore.Functions.GetVehicleProperties(veh)
    end

    return ESX.Game.GetVehicleProperties(veh)
end

function SetVehicleProperties(veh, props)
    if Config.Framework == 'qb' then
        QBCore.Functions.SetVehicleProperties(veh, props)
    else
        ESX.Game.SetVehicleProperties(veh, props)
    end
end

function CanStoreVehicle(veh) -- called when you try to store a vehicle into the society garage, can be used for example to check if player owns the vehicle
    return true
end

-- Wardrobe

function GetPlayerDressing()
    local p = promise.new()
    TriggerCallback('tk_housing:getPlayerDressing', function(dressing)
        p:resolve(dressing)
    end)
    return Citizen.Await(p)
end

function LoadClothes(index)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerCallback('tk_housing:getPlayerOutfit', function(clothes)
            TriggerEvent('skinchanger:loadClothes', skin, clothes)
            TriggerEvent('esx_skin:setLastSkin', skin)
            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerServerEvent('esx_skin:save', skin)
            end)
        end, index)
    end)
end

function OxWardrobeMenu(dressing)
    local elements = {}

    for k,v in pairs(dressing) do
        elements[#elements+1] = {
            title = v,
            onSelect = function()
                LoadClothes(k)
            end,
        }
    end
    lib.registerContext({
        id = 'wardrobe',
        title = _U('wardrobe'),
        options = elements,
    })
    lib.showContext('wardrobe')
end

function OpenWardrobe()
    if Config.Clothing == 'illenium' then
        TriggerEvent('illenium-appearance:client:openOutfitMenu')
        return
    end

    if Config.Framework == 'qb' then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
        return
    end

    local dressing = GetPlayerDressing()
    if Config.UseOxLib then return OxWardrobeMenu(dressing) end

    local elements = {}

    for k,v in pairs(dressing) do
        elements[#elements+1] = {label = v, value = k}
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wardrobe', {
        title = _U('wardrobe'),
        align = Config.MenuAlign,
        elements = elements,
    }, function(data, menu)
        LoadClothes(data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

-- Storage

function GetAmountInput()
    local amount = lib.inputDialog(_U('amount'), {
        { type = "number", label = _U('amount'), placeholder = 0 },
    })

    if not amount or not amount[1] then return end

    if amount[1] <= 0 then
        Notify(_U('invalid_amount'), 'error')
        return
    end

    return amount[1]
end

function CreateItemElements(items, actionType, propertyIndex, furnitureType, storageId)
    local elements = {}

    for k,v in pairs(items) do
        local title
        local label = v.label or GetItemLabel(v.name)

        if v.name == 'money' then
            title = _U('menu_money_label', label, ESX.Math.GroupDigits(v.amount))
        elseif v.name == 'black_money' then
            title = _U('menu_black_money_label', label, ESX.Math.GroupDigits(v.amount))
        elseif IsWeapon(v.name) then
            title = _U('menu_weapon_label', label, v.amount)
        else
            title = _U('menu_item_label', label, v.amount)
        end

        elements[#elements+1] = {
            title = title,
            onSelect = function()
                if IsWeapon(v.name) then
                    TriggerServerEvent('tk_housing:'..actionType..'Item', v.name, v.amount, propertyIndex, furnitureType, storageId, actionType == 'take' and k)
                end

                local amount = GetAmountInput()
                if amount then
                    TriggerServerEvent('tk_housing:'..actionType..'Item', v.name, amount, propertyIndex, furnitureType, storageId, actionType == 'take' and k)
                end
            end
        }
    end

    return elements
end

function OxPutItemsHouseMenu(propertyIndex, furnitureType, storageId, data)
    local elements = CreateItemElements(data, 'put', propertyIndex, furnitureType, storageId)

    lib.registerContext({
        id = 'put_items_menu',
        title = _U('put_items_menu'),
        options = elements
    })
    lib.showContext('put_items_menu')
end

function OxTakeItemsHouseMenu(propertyIndex, furnitureType, storageId, items)
    local elements = CreateItemElements(items, 'take', propertyIndex, furnitureType, storageId)

    lib.registerContext({
        id = 'take_items_menu',
        title = _U('take_items_menu'),
        options = elements
    })
    lib.showContext('take_items_menu')
end

function OxStorageInventoryMenu(propertyIndex, furnitureType, storageId)
    local elements = {
        {
            title = _U('take_items'),
            onSelect = function()
                TakeItemsHouse(propertyIndex, furnitureType, storageId)
            end
        },
        {
            title = _U('put_items'),
            onSelect = function()
                PutItemsHouse(propertyIndex, furnitureType, storageId)
            end
        },
    }
    lib.registerContext({
        id = 'storage_inv',
        title = _U('storage'),
        options = elements,
    })
    lib.showContext('storage_inv')
end

function OpenStorageInventory(propertyIndex, furnitureType, storageId)
    if Config.UseOxLib then 
        return OxStorageInventoryMenu(propertyIndex, furnitureType, storageId)
    end

    local elements = {
        {label = _U('take_items'), value = 'take_items'},
        {label = _U('put_items'), value = 'put_items'},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'storage_inv', {
        title = _U('storage'),
        align = Config.MenuAlign,
        elements = elements,
    }, function(data, menu)
        if data.current.value == 'take_items' then
            TakeItemsHouse(propertyIndex, furnitureType, storageId)
        elseif data.current.value == 'put_items' then
            PutItemsHouse(propertyIndex, furnitureType, storageId)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenStorage(propertyIndex, furnitureType, storageId, model)
    local stashName = 'tk_housing_storage_'..propertyIndex..'_'..furnitureType..'_'..storageId
    local stashData = GetStorageStashDataByModel(model)

    if Config.Inventory == 'ox' then
        exports.ox_inventory:openInventory('stash', stashName)
    elseif Config.Inventory == 'quasar' then
        TriggerEvent("inventory:client:SetCurrentStash", stashName)
        TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName)
    elseif Config.Inventory == 'qb_old' then
        TriggerEvent("inventory:client:SetCurrentStash", stashName)
        TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, {
            maxweight = stashData.weight or 100000,
            slots = stashData.slots or 24,
        })
    elseif Config.Inventory == 'qb_new' then
        TriggerServerEvent('tk_housing:openQBStorage', propertyIndex, furnitureType, storageId, model)
    else
        OpenStorageInventory(propertyIndex, furnitureType, storageId)
    end
end

function TakeScreenshot(token)
    local p = promise.new()
    exports['screenshot-basic']:requestScreenshotUpload('https://api.fivemanage.com/api/image', 'image', {
        headers = {
            Authorization = token
        }
    }, function(data)
        local resp = json.decode(data)
        p:resolve(resp.url)
    end)
    return Citizen.Await(p)
end

RegisterCommand('addproperty', function()
    AddPropertyCommand()
end, false)
RegisterCommand('propertylist', function()
    PropertyListCommand()
end, false)