Editable = {}

local function isStarted(resourceName)
    return GetResourceState(resourceName) == 'started'
end

---@param coords vector3
---@param tier 'basic' | 'upgrade'
function Editable.updateInteriorTier(coords, tier)
    local cocaineIpl = exports['bob74_ipl']:GetBikerCocaineObject()
    local weedIpl = exports['bob74_ipl']:GetBikerWeedFarmObject()
    local methIpl = exports['bob74_ipl']:GetBikerMethLabObject()

    local interiorId = GetInteriorAtCoords(coords.x, coords.y, coords.z)

    if interiorId == cocaineIpl.interiorId then
        cocaineIpl.Style.Set(tier == 'basic' and cocaineIpl.Style.basic or cocaineIpl.Style.upgrade)
        cocaineIpl.Security.Set(tier == 'basic' and cocaineIpl.Security.basic or cocaineIpl.Security.upgrade)
        cocaineIpl.Details.Enable({cocaineIpl.Details.cokeBasic1 }, true)

        RefreshInterior(cocaineIpl.interiorId)
    elseif interiorId == weedIpl.interiorId then
        weedIpl.Style.Set(tier == 'basic' and weedIpl.Style.basic or weedIpl.Style.upgrade)
        weedIpl.Security.Set(tier == 'basic' and weedIpl.Security.basic or weedIpl.Security.upgrade)
        
        weedIpl.Details.Enable({
            weedIpl.Details.drying
        }, true)

        weedIpl.Details.Enable({
            weedIpl.Details.chairs,
            weedIpl.Details.production
        }, false)

        weedIpl.Plant1.Set(weedIpl.Plant1.Stage.medium, weedIpl.Plant1.Light.basic)
        weedIpl.Plant2.Set(weedIpl.Plant2.Stage.full, weedIpl.Plant2.Light.basic)
        weedIpl.Plant3.Set(weedIpl.Plant3.Stage.medium, weedIpl.Plant3.Light.basic)
        -- weedIpl.Plant4.Set(weedIpl.Plant4.Stage.full, weedIpl.Plant4.Light.basic)
        weedIpl.Plant5.Set(weedIpl.Plant5.Stage.medium, weedIpl.Plant5.Light.basic)
        weedIpl.Plant6.Set(weedIpl.Plant6.Stage.full, weedIpl.Plant6.Light.basic)
        
        weedIpl.Plant7.Set(weedIpl.Plant7.Stage.medium, weedIpl.Plant7.Light.basic)
        -- weedIpl.Plant8.Set(weedIpl.Plant8.Stage.full, weedIpl.Plant8.Light.basic)
        weedIpl.Plant9.Set(weedIpl.Plant9.Stage.full, weedIpl.Plant9.Light.basic)

        --- clear
        weedIpl.Plant4.Clear()
        weedIpl.Plant8.Clear()

        RefreshInterior(weedIpl.interiorId)
    elseif interiorId == methIpl.interiorId then
        methIpl.Style.Set(tier == 'basic' and methIpl.Style.basic or methIpl.Style.upgrade)
        methIpl.Security.Set(tier == 'basic' and methIpl.Security.basic or methIpl.Security.upgrade)
        methIpl.Details.Enable(methIpl.Details.production, true)

        RefreshInterior(methIpl.interiorId)
    end
end

---@type string
local path

if isStarted('ox_inventory') then
    path = 'nui://ox_inventory/web/images/%s.png'
elseif isStarted('qb-inventory') then
    path = 'nui://qb-inventory/html/images/%s.png'
elseif isStarted('ps-inventory') then
    path = 'nui://ps-inventory/html/images/%s.png'
elseif isStarted('lj-inventory') then
    path = 'nui://lj-inventory/html/images/%s.png'
elseif isStarted('qs-inventory') then
    path = 'nui://qs-inventory/html/images/%s.png' -- Not really sure
end

---Returns the NUI path of an icon.
---@param itemName string
---@return string?
---@diagnostic disable-next-line: duplicate-set-field
function Editable.getInventoryIcon(itemName)
    if not path then
        warn('Inventory images path not set in cl_edit.lua!')
        return
    end

    return path:format(itemName) .. '?height=128'
end

function Editable.addHunger(amount)
    if Framework.name == 'es_extended' then
        TriggerEvent('esx_status:add', 'hunger', amount)
    else
        local value = Framework.object.Functions.GetPlayerData().metadata.hunger + amount
        TriggerServerEvent('consumables:server:addHunger', value)
    end
end

function Editable.addThirst(amount)
    if Framework.name == 'es_extended' then
        TriggerEvent('esx_status:add', 'thirst', amount)
    else
        local value = Framework.object.Functions.GetPlayerData().metadata.thirst + amount
        TriggerServerEvent('consumables:server:addThirst', value)
    end
end

function Editable.usedConsumable(itemName)
    -- add your implementation
end