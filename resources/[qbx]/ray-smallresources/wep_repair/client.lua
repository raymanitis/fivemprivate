local Config = require 'wep_repair/config'
local shared_items = exports.ox_inventory:Items()
CreateThread(function()
    repeat Wait(125) until QBX.PlayerData.job ~= nil

    SpawnPed()
end)

local function Notify(message, type, duration)
    lib.notify({
        description = message,
        type = type,
        duration = duration
    })
end

local function RepairWeapon(data)
    lib.callback.await('ray-smallres:server:repairWep', false, data)
end

local function OpenWeaponMenu()
    local inventory = exports.ox_inventory:GetPlayerItems()
    local weapons = {}
    for _, v in pairs(inventory) do
        if tostring(v.name):lower():sub(1, 7) == "weapon_" then
            if v.metadata?.durability < 50 then
                table.insert(weapons, {
                    name = v.name,
                    slot = v.slot,
                    durability = v.metadata.durability,
                    hasRepaired = v.metadata?.hasRepaired,
                    serial = v.metadata.serial,
                })
            end
        end
    end

    if weapons == nil or #weapons == 0 then
        Notify("You don't have any weapons to fix", "error")
        return
    end
    local menuOptions = {}
    for _, v in pairs(weapons) do
        table.insert(menuOptions, {
            title = shared_items[v.name].label,
            description = "Slot: " .. v.slot .. "\nSerial: " .. v.serial .. "\nDurability: " .. v.durability .. "%\nFor repair to 55%: " .. math.ceil(Config.Costs * (Config.MaxDurability - v.durability)) .. "$",
            progress = v.durability,
            icon = 'nui://ox_inventory/web/images/' .. v.name .. '.png',
            onSelect = function()
                RepairWeapon(v)
            end,
            colorScheme = v.hasRepaired and "dark" or "yellow",
            readOnly = v.hasRepaired,
            metadata = (v.hasRepaired and { "You can't repair an already once repaired weapon!" }) or nil
        })
    end
    lib.registerContext({
        id = 'weapons_repair',
        title = 'Weapon repairing',
        options = menuOptions
    })
    lib.showContext('weapons_repair')
end

function SpawnPed()
    local hash = Config.Ped.Models[math.random(#Config.Ped.Models)]
    lib.requestModel(hash)
    local ped = CreatePed(4, hash, Config.Ped.Coords.x, Config.Ped.Coords.y, Config.Ped.Coords.z, Config.Ped.Coords.w, false, true)
    repeat Wait(500) until DoesEntityExist(ped)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)

    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanRagdoll(ped, false)
    SetPedConfigFlag(ped, 287, true)
    SetPedConfigFlag(ped, 209, true)
    SetPedConfigFlag(ped, 208, true)
    SetModelAsNoLongerNeeded(hash)

    exports.ox_target:addLocalEntity(ped, {
        {
            icon = 'fa-solid fa-gun',
            label = "Talk",
            distance = 2.0,
            onSelect = OpenWeaponMenu
        }
    })
end