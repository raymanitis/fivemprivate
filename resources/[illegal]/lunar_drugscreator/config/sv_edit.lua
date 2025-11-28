Editable = {}

local tables = {
    [[
        CREATE TABLE IF NOT EXISTS `lunar_drugscreator` (
            `key` VARCHAR(50) NOT NULL,
            `data` LONGTEXT NOT NULL,
            PRIMARY KEY (`key`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `lunar_drugscreator_labs` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(46) DEFAULT NULL,
            `index` int(11) NOT NULL,
            `entranceIndex` int(11) NOT NULL,
            `keys` longtext NOT NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `lab_entrance` (`index`,`entranceIndex`)
        ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `lunar_drugscreator_lamps` (
            `id` int(11) NOT NULL,
            `data` longtext NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `lunar_drugscreator_plants` (
            `id` int(11) NOT NULL,
            `data` longtext NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `lunar_drugscreator_stats` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `date` date NOT NULL,
            `drug_name` varchar(50) NOT NULL,
            `processed` int(11) DEFAULT 0,
            `sold` int(11) DEFAULT 0,
            PRIMARY KEY (`id`),
            UNIQUE KEY `date_drug` (`date`,`drug_name`)
        ) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `lunar_drugscreator_tables` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `data` longtext NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]]
}

MySQL.ready(function()
    for i = 1, #tables do
        MySQL.query.await(tables[i])
    end
end)

local function isStarted(resourceName)
    return GetResourceState(resourceName) == 'started'
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
        warn('Inventory images path not set in sv_edit.lua!')
        return
    end

    return path:format(itemName) .. '?height=128'
end

---Called when a retail sale successfully happens
---@param player Player The player who made the sale
---@param itemName string The name of the item sold
---@param amount number The amount of items sold
---@param price number The price per item
function Editable.onRetailSale(player, itemName, amount, price)
    -- Add your custom logic here for when a retail sale happens
    -- local source = player.source
end