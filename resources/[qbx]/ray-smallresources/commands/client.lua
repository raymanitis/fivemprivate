-- local legionSquare = vec3(234.12, -761.07, 30.86)
-- RegisterCommand("stuck", function()
--     local ped = cache.ped
--     if GetEntitySpeed(ped) == 0 and not cache.vehicle then
--         if lib.progressBar({
--             duration = 30 * 1000, -- 30 sek.
--             label = 'Teleportē...',
--             position = 'bottom',
--             useWhileDead = false,
--             canCancel = true,
--             disable = {
--                 move = true,
--                 combat = true,
--                 vehicle = true
--             },
--         }) then
--             DoScreenFadeOut(1500)
--             Wait(2000)
--             SetEntityCoords(ped, legionSquare.x, legionSquare.y, legionSquare.z)
--             Wait(1000)
--             DoScreenFadeIn(1500)
--         end
--     else
--         if cache.vehicle then
--             lib.notify({
--                 description = "Tu nedrīksti būt auto",
--                 type = "error"
--             })
--         else
--             lib.notify({
--                 description = "Tu nedrīksti kustēties!",
--                 type = "error"
--             })
--         end
--     end
-- end)

-- RegisterCommand("createinvoice", function(source, args)
--     local allowedJobs = { "police", "mechanic", "ambulance", "bennys", "tommyworkshop" } -- Add job names here

--     -- Check if player has any of the allowed jobs
--     local hasAccess = exports.qbx_core:HasGroup(allowedJobs)
--     if not hasAccess then
--         lib.notify({
--             description = "You are not authorized to use this command!",
--             type = "error"
--         })
--         return
--     end

--     local targetId = tonumber(args[1])
--     if not targetId then
--         -- If no ID is specified, open with input
--         local input = lib.inputDialog('Create Invoice', {
--             {type = 'number', label = 'Player ID', description = 'Enter the target player ID', icon = 'hashtag', required = true},
--         })

--         if not input then return end -- Dialog was cancelled

--         targetId = input[1]
--         if not targetId then
--             lib.notify({
--                 description = "Please enter a valid player ID",
--                 type = "error"
--             })
--             return
--         end
--     end

--     -- Open the invoice menu
--     exports['p_banking']:openInvoiceMenu(targetId)
-- end, false)

-- RegisterCommand("createinvoice", function()
--     local allowedJobs = { "police", "mechanic", "ambulance", "bennys", "tommyworkshop" }

--     local hasAccess = exports.qbx_core:HasGroup(allowedJobs)
--     if not hasAccess then
--         exports.qbx_core:Notify({
--             text = "You are not authorized to use this command!",
--             notifyType = "error"
--         })
--         return
--     end

--     local input = lib.inputDialog('Create Invoice', {
--         { type = 'number', label = 'Player ID', description = 'Enter the target player ID', icon = 'hashtag', required = true },
--         { type = 'number', label = 'Invoice Amount', description = 'Enter the invoice amount', required = true },
--     })

--     if not input then return end

--     local targetId = input[1]
--     local amount = input[2]

--     if not targetId or not amount then
--         exports.qbx_core:Notify({
--             text = "Please fill in all required fields",
--             notifyType = "error"
--         })
--         return
--     end

--     TriggerServerEvent('ray-smallresources:server:createInvoice', targetId, amount)
-- end, false)

-- DELETE LAZER
local DeleteLazer = false
RegisterNetEvent("ray-smallres:client:delazer", function()
    DeleteLazer = not DeleteLazer
end)
local function DrawEntityBoundingBox(entity)
    x, y, z = table.unpack(GetEntityCoords(entity, true))
    SetDrawOrigin(x, y, z, 0)
    RequestStreamedTextureDict("helicopterhud", false)
    DrawSprite("helicopterhud", "hud_corner", -0.01, -0.01, 0.05, 0.05, 0.0, 0, 255, 0, 200)
    DrawSprite("helicopterhud", "hud_corner", 0.01, -0.01, 0.05, 0.05, 90.0, 0, 255, 0, 200)
    DrawSprite("helicopterhud", "hud_corner", -0.01, 0.01, 0.05, 0.05, 270.0, 0, 255, 0, 200)
    DrawSprite("helicopterhud", "hud_corner", 0.01, 0.01, 0.05, 0.05, 180.0, 0, 255, 0, 200)
    ClearDrawOrigin()
end
local function RotationToDirection(rotation)
    local adjustedRotation = { x = (math.pi / 180) * rotation.x, y = (math.pi / 180) * rotation.y, z = (math.pi / 180) * rotation.z }
    local direction = { x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), z = math.sin(adjustedRotation.x) }
    return direction
end
local function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination = { x = cameraCoord.x + direction.x * distance, y = cameraCoord.y + direction.y * distance, z = cameraCoord.z + direction.z * distance }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end
local function Draw3DText(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
local function deleteWithLazer(ent)
    if not ent then return end
    if not DoesEntityExist(ent) then return end
    CreateThread(function()
        local timeout = 0
        while true do
            if timeout >= 3000 then return end
            timeout = timeout + 1
            NetworkRequestControlOfEntity(ent)
            local nTimeout = 0
            while not NetworkHasControlOfEntity(ent) and nTimeout < 1000 do
                nTimeout = nTimeout + 1
                NetworkRequestControlOfEntity(ent)
                Wait(0)
            end
            SetEntityAsMissionEntity(ent, true, true)
            DeleteEntity(ent)
            if GetEntityType(ent) == 2 then DeleteVehicle(ent) end
            if not DoesEntityExist(ent) then return end
            Wait(0)
        end
    end)
end
CreateThread(function()
    while true do
        Wait(0)
        if DeleteLazer then
            local colorActive = { r = 255, g = 0, b = 0, a = 200 }
            local colorDefault = { r = 255, g = 255, b = 255, a = 200 }
            local position = GetEntityCoords(cache.ped)
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)

            if hit and (IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)) then
                local entityCoord = GetEntityCoords(entity)
                DrawEntityBoundingBox(entity)
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, colorActive.r, colorActive.g, colorActive.b, colorActive.a)
                DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, colorActive.r, colorActive.g, colorActive.b, colorActive.a, false, true, 2, nil, nil, false)
                Draw3DText(entityCoord.x, entityCoord.y, entityCoord.z + 0.5, "Object: " .. entity .. "\nModel: " .. GetEntityModel(entity) .. "\nPress [~g~E~s~] to delete this object!")
                if IsControlJustReleased(0, 38) then
                    deleteWithLazer(entity)
                end
            elseif coords.x ~= 0.0 and coords.y ~= 0.0 then
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, colorDefault.r, colorDefault.g, colorDefault.b, colorDefault.a)
                DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, colorDefault.r, colorDefault.g, colorDefault.b, colorDefault.a, false, true, 2, nil, nil, false)
            end
        else
            Wait(450)
        end
    end
end)

-- Show citizen IDs in ox_lib dialog
RegisterNetEvent('ray-smallres:client:showCitizenIds', function(characterInfo, license)
    local options = {}
    
    -- Add each character as an option
    for i, char in ipairs(characterInfo) do
        table.insert(options, {
            title = char.label,
            description = char.description,
            icon = 'user',
            onSelect = function()
                -- Copy citizen ID to clipboard
                lib.setClipboard(char.value)
                lib.notify({
                    title = 'Copied',
                    description = ('Citizen ID copied: %s'):format(char.value),
                    type = 'success'
                })
            end
        })
    end
    
    -- Add option to copy all citizen IDs
    table.insert(options, {
        title = 'Copy All Citizen IDs',
        description = 'Copy all citizen IDs separated by commas',
        icon = 'copy',
        onSelect = function()
            local allIds = {}
            for _, char in ipairs(characterInfo) do
                table.insert(allIds, char.value)
            end
            local allIdsString = table.concat(allIds, ', ')
            lib.setClipboard(allIdsString)
            lib.notify({
                title = 'Copied All',
                description = 'All citizen IDs copied to clipboard',
                type = 'success'
            })
        end
    })
    
    -- Show the dialog
    lib.registerContext({
        id = 'citizen_ids_menu',
        title = ('Characters for License: %s'):format(license),
        options = options
    })
    
    lib.showContext('citizen_ids_menu')
end)

-- Open add items dialog for offline players
RegisterNetEvent('ray-smallres:client:openAddItemsDialog', function()
    local items = {}
    local citizenid = nil
    
    local function addItemDialog(isFirstItem)
        local dialogFields = {}
        
        -- Only ask for citizen ID on first item
        if isFirstItem then
            table.insert(dialogFields, {type = 'input', label = 'Citizen ID', description = 'Enter the player\'s citizen ID', required = true})
        end
        
        table.insert(dialogFields, {type = 'input', label = 'Item Name', description = 'Enter the item name', required = true})
        table.insert(dialogFields, {type = 'number', label = 'Count', description = 'Enter the item count', default = 1, min = 1})
        table.insert(dialogFields, {type = 'input', label = 'Metadata (JSON)', description = 'Enter metadata as JSON (optional)', placeholder = '{"durability": 100}'})
        
        local input = lib.inputDialog('Add Item to Offline Player', dialogFields)
        
        if not input then return end
        
        -- Handle citizen ID (only on first item)
        if isFirstItem then
            citizenid = input[1]
        end
        
        local itemName = isFirstItem and input[2] or input[1]
        local count = isFirstItem and input[3] or input[2]
        local metadataInput = isFirstItem and input[4] or input[3]
        local metadata = {}
        
        if metadataInput and metadataInput ~= '' then
            local success, result = pcall(json.decode, metadataInput)
            if success then
                metadata = result
            else
                lib.notify({
                    title = 'Error',
                    description = 'Invalid JSON format for metadata',
                    type = 'error'
                })
                return
            end
        end
        
        table.insert(items, {
            item = itemName,
            count = count,
            metadata = metadata
        })
        
        -- Show options to add more items or finish
        local options = {
            {
                title = 'Add Another Item',
                description = 'Add more items to the same player',
                icon = 'plus',
                onSelect = function()
                    addItemDialog(false) -- false = not first item
                end
            },
            {
                title = 'Finish & Add Items',
                description = ('Add %d item(s) to %s'):format(#items, citizenid),
                icon = 'check',
                onSelect = function()
                    TriggerServerEvent('ray-smallres:server:addItemsToOfflinePlayer', citizenid, items)
                end
            },
            {
                title = 'Cancel',
                description = 'Cancel adding items',
                icon = 'x',
                onSelect = function()
                    lib.notify({
                        title = 'Cancelled',
                        description = 'Item addition cancelled',
                        type = 'info'
                    })
                end
            }
        }
        
        lib.registerContext({
            id = 'add_items_menu',
            title = ('Add Items to %s'):format(citizenid),
            options = options
        })
        
        lib.showContext('add_items_menu')
    end
    
    addItemDialog(true) -- true = first item
end)