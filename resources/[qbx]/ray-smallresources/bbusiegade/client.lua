local Config = require 'bbusiegade/config'
local QBCore = GetResourceState('qb-core') == 'started' and exports['qb-core']:GetCoreObject()
local ESX = GetResourceState('es_extended') == 'started' and exports.es_extended:getSharedObject()

local ped = {}

local function setVehicleFullFuel(vehicle)
    if not DoesEntityExist(vehicle) then return end

    local fullFuel = 100.0

    local fuelResources = {
        'cdn-fuel',
        'LegacyFuel',
        'ps-fuel',
        'lj-fuel',
        'qb-fuel',
        'lc_fuel',
        'ox_fuel',
        'Renewed-Fuel',
        'nd_fuel',
        'myFuel',
        'qs-fuelstations',
        'okokGasStation',
        'rcore_fuel',
        'BigDaddy-Fuel',
        'ld-fuel',
        'x-fuel',
        'ti_fuel'
    }

    local success = false

    for _, resource in ipairs(fuelResources) do
        if GetResourceState(resource) == 'started' then
            local exportName = resource

            -- Adjust export names when they differ from the resource folder
            if resource == 'ld-fuel' then
                exportName = 'ld-fuel'
            elseif resource == 'BigDaddy-Fuel' then
                exportName = 'BigDaddy-Fuel'
            end

            local ok, err = pcall(function()
                exports[exportName]:SetFuel(vehicle, fullFuel)
            end)

            if ok then
                success = true
                break
            else
                print(('[bbusiegade] Failed to set fuel using %s: %s'):format(resource, err))
            end
        end
    end

    if not success then
        SetVehicleFuelLevel(vehicle, fullFuel)
    end

    if type(Entity) == 'function' then
        local vehEntity = Entity(vehicle)
        if vehEntity and vehEntity.state then
            vehEntity.state.fuel = fullFuel
        end
    end

    SetVehicleFuelLevel(vehicle, fullFuel)
end

Citizen.CreateThread(function()
    for k, v in pairs(Config.locations) do 
        if v.ped then 
            RequestModel(Config.pedmodel)
            while not HasModelLoaded(Config.pedmodel) do
                Wait(10)
            end
            ped[k] = CreatePed(4, Config.pedmodel, v.coords.x, v.coords.y, v.coords.z, v.coords.w, false, true)
            if Config.scenario then 
                TaskStartScenarioInPlace(ped[k], Config.scenario, 0, true)
            end
            SetEntityCoordsNoOffset(ped[k], v.coords.x, v.coords.y, v.coords.z, false, false, false)
            Wait(100)
            FreezeEntityPosition(ped[k], true)
            SetEntityInvincible(ped[k], true)
            SetBlockingOfNonTemporaryEvents(ped[k], true)
        end 

        if not v.ped then 
            if Config.qbtarget then 
                exports['qb-target']:AddBoxZone(k, v.coords, v.length, v.width, {
                    name = k,
                    heading = v.coords.w,
                    debugPoly = false,
                    minZ = v.coords.z,
                    maxZ = v.coords.z
                }, {
                    options = {
                        {
                            icon = 'fas fa-bus',
                            label = 'Buy Bus',
                            action = function()
                                TriggerEvent('bbusiegade:client:OpenMenu', k)
                            end

                        },
                    },
                    distance = 2.0
                })
            elseif Config.oxtarget then 
                local menu_options = {
                    {
                        name = 'bus_purchase',
                        icon = 'fas fa-bus',
                        label = 'Buy Bus',
                        onSelect = function()
                            TriggerEvent('bbusiegade:client:OpenMenu', k)
                        end
                    },
                }
                exports.ox_target:addBoxZone({
                    coords = v.coords, 
                    size = vec3(v.length or 1.5, v.width or 1.5, (v.maxZ or v.coords.z + 1.0) - (v.minZ or v.coords.z - 1.0)),
                    rotation = v.coords.w,
                    debug = v.debug or false,
                    options = menu_options
                })
            end
        else 
            if Config.qbtarget then 
                exports['qb-target']:AddTargetEntity(ped[k], {
                    options = {
                        {
                            icon = 'fas fa-bus',
                            label = 'Buy Bus',
                            action = function()
                                TriggerEvent('bbusiegade:client:OpenMenu', k)
                            end,
                        },
                    },
                    distance = 2.0
                })
            elseif Config.oxtarget then 
                local options = {
                    {
                        name = 'bus_purchase',
                        icon = 'fas fa-bus',
                        label = 'Buy Bus',
                        onSelect = function()
                            TriggerEvent('bbusiegade:client:OpenMenu', k)
                        end
                    },
                }
                exports.ox_target:addLocalEntity(ped[k], options)
                
            end
        end
    end
        
end)

RegisterNetEvent('bbusiegade:client:OpenMenu', function(k)

    local menu_options = {}

    for location, info in pairs(Config.locations) do 
        if location == k then 
            for vehicle, details in pairs(info.vehicles) do 
                table.insert(menu_options, {
                    title = vehicle:gsub("^%l", string.upper),
                    image = details.image,
                    description = '$' .. details.price .. ' (Black Money)',
                    onSelect = function()
                        TriggerServerEvent('bbusiegade:server:PurchaseBus', vehicle, details.price, location)
                    end
                })
            end
        end
    end 

    exports.ox_lib:registerContext({
        id = 'bus_purchase',
        title = 'Buy Bus',
        options = menu_options,
    })

    exports.ox_lib:showContext('bus_purchase')
end)

RegisterNetEvent('bbusiegade:client:SpawnBus', function(vehiclename, location)
    local player = PlayerPedId()
    local vehicle = GetHashKey(vehiclename)
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Wait(10)
    end
    local spawn = Config.locations[location].vehiclespawncoords
    local bus = CreateVehicle(vehicle, spawn.x, spawn.y, spawn.z, spawn.w, true, false)
    local plate = GetVehicleNumberPlateText(bus)
    SetVehicleOnGroundProperly(bus)
    TaskWarpPedIntoVehicle(player, bus, -1) 
    SetVehicleEngineOn(bus, true, true, false)
    setVehicleFullFuel(bus)
    TriggerServerEvent('bbusiegade:server:GiveVehicleKey', plate)
    if exports and exports['Renewed-Vehiclekeys'] then
        exports['Renewed-Vehiclekeys']:addKey(plate)
    end

    -- give keys 
    -- if QBCore then 
    --     exports['Renewed-Vehiclekeys']:addKey(plate)
    -- end
        
    SetModelAsNoLongerNeeded(vehicle)
end)