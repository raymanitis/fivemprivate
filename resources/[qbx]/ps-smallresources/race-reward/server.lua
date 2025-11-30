AddEventHandler('nx_racing:server:raceFinished', function(raceData)
    if raceData.raceType ~= 'ranked' then return end

    for _, racer in ipairs(raceData.racers) do
        local src = racer.source
        local didFinish = racer.dnf == false

        if src and type(src) == 'number' and didFinish then
            -- Give guaranteed reward
            exports.ox_inventory:AddItem(src, 'material_case', 1)

            -- 50% chance for extra reward
            if math.random() < 0.5 then
                exports.ox_inventory:AddItem(src, 'engineupgrade_case', 1)
            end
        end
    end
end)
