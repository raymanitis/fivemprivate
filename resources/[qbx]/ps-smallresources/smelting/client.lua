local Config = require 'smelting/config'

local blips = {} -- Store blips for cleanup

local function createBlip(blipData)
    if not blipData or not blipData.coords then return nil end
    
    local coords = blipData.coords
    -- Handle both vector3 and table formats
    if type(coords) == "table" and coords.x and coords.y and coords.z then
        coords = vector3(coords.x, coords.y, coords.z)
    elseif type(coords) == "vector3" then
        coords = coords
    else
        print("^1[Smelting] Invalid coordinates format for blip^0")
        return nil
    end
    
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipData.sprite or 496)
    SetBlipScale(blip, blipData.scale or 0.7)
    SetBlipColour(blip, blipData.color or 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipData.name or "Smelting Area")
    EndTextCommandSetBlipName(blip)
    
    -- Store blip for cleanup
    blips[#blips + 1] = blip
    
    return blip
end

local function smeltingMenu(locationKey)
    local menu = {}

    for ingotId, data in ipairs(Config.SmeltingItems) do
        local desc = {}
        for _, req in ipairs(data.required) do
            local itemInfo = exports.ox_inventory:Items()[req.item]
            local label = itemInfo and itemInfo.label or req.item
            desc[#desc + 1] = ("x%d %s"):format(req.count, label)
        end

        menu[#menu + 1] = {
            title = data.label,
            description = table.concat(desc, ', '),
            icon = data.icon or 'fa-solid fa-cube',
            event = 'smelting:select',
            args = {
                ingotId = ingotId,
                location = locationKey
            }
        }
    end

    lib.registerContext({
        id = 'smelt-menu',
        title = "Smelting Menu",
        options = menu
    })

    lib.showContext('smelt-menu')
end

RegisterNetEvent('smelting:select', function(data)
    local ingot = Config.SmeltingItems[data.ingotId]
    if not ingot then return end

    -- Calculate how many can be smelted
    local minCraft = math.huge
    for _, req in ipairs(ingot.required) do
        local owned = exports.ox_inventory:Search('count', req.item) or 0
        local canMake = math.floor(owned / req.count)
        if canMake < minCraft then
            minCraft = canMake
        end
    end

    if minCraft <= 0 then
        lib.notify({ type = 'error', description = 'You do not have the required items to smelt.' })
        return
    end

    -- Ask for quantity
    local result = lib.inputDialog('Smelting: ' .. ingot.label, {
        {
            type = 'slider',
            label = 'Quantity',
            min = 1,
            max = math.min(minCraft, ingot.maxCount or 10),
            default = 1,
            step = 1
        }
    })

    if not result or not result[1] then return end
    local quantity = result[1]
    local totalDuration = (ingot.duration or 5000) * quantity

    -- Freeze player and animation
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
    while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do Wait(0) end
    TaskPlayAnim(ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, -8.0, -1, 1, 0, false, false, false)

    -- Disable inventory opening (NPWD, ox_inventory, etc.)
    TriggerEvent('ox_inventory:disableInventory', true)
    LocalPlayer.state:set('invBusy', true, true)

    -- Progress bar
    local progress = lib.progressBar({
        duration = totalDuration,
        label = ('Smelting %dx %s...'):format(quantity, ingot.label),
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true }
    })

    -- Unfreeze + clear anim
    FreezeEntityPosition(ped, false)
    ClearPedTasks(ped)
    TriggerEvent('ox_inventory:disableInventory', false)
    LocalPlayer.state:set('invBusy', false, true)

    if not progress then
        lib.notify({ type = 'error', description = 'Smelting canceled.' })
        return
    end

    -- Smelting done
    TriggerServerEvent('smelting:start', data.ingotId, quantity, data.location)
end)


local addedTargets = {}

-- Cleanup function for resource stop
AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    
    -- Clean up blips
    for _, blip in ipairs(blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    blips = {}
    
    print("^3[Smelting] Cleaned up " .. #blips .. " blips^0")
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    for key, loc in pairs(Config.SmeltLocations) do
        -- Check if we already added this target
        if not addedTargets[key] then
            exports.ox_target:addBoxZone({
                coords = loc.coords,
                size = vec3(loc.radius, loc.radius, 2.5),
                rotation = 0,
                debug = false,
                options = {
                    {
                        name = 'smelting_' .. key,
                        icon = loc.icon or 'fa-solid fa-fire',
                        label = loc.label or 'Smelting Area',
                        onSelect = function()
                            smeltingMenu(key)
                        end
                    }
                }
            })

            -- Create blip if configured
            if loc.blip then
                if type(loc.blip) == "table" then
                    createBlip(loc.blip)
                    print("^2[Smelting] Created blip for location: " .. key .. "^0")
                elseif loc.blip == true then
                    -- If blip is just set to true, use location data
                    createBlip({
                        coords = loc.coords,
                        sprite = 648,
                        scale = 0.7,
                        color = 17,
                        name = loc.label or "Smelting Area"
                    })
                    print("^2[Smelting] Created default blip for location: " .. key .. "^0")
                end
            end

            addedTargets[key] = true -- Mark as added
        end
    end
end)
