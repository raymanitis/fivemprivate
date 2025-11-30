local Config = require 'wep_repair/config'

local function Notify(source, message, type, duration)
    lib.notify(source, {
        description = message,
        type = type,
        duration = duration
    })
end

lib.callback.register("ray-smallres:server:repairWep", function(source, data)
    local inv = exports.ox_inventory:GetSlot(source, data.slot)
    local finalCost = math.ceil(Config.Costs * (Config.MaxDurability - data.durability))
    if exports.ox_inventory:Search(source, "count", "black_money") >= finalCost then
        if inv then
            if inv.name == data.name and inv.metadata.serial == data.serial then
                if not inv.metadata?.hasRepaired then
                    inv.metadata.durability = Config.MaxDurability
                    inv.metadata.hasRepaired = true
                    exports.ox_inventory:SetMetadata(source, inv.slot, inv.metadata)
                    exports.ox_inventory:RemoveItem(source, "black_money", finalCost)
                else
                    Notify(source, "This weapon has already been repaired!", "error")
                end
            else
                Notify(source, "Are you cheating?")
            end
        else
            Notify(source, "Are you cheating?")
        end
    else
        Notify(source, "You don't have enough money on you, fool...", "error")
    end
end)