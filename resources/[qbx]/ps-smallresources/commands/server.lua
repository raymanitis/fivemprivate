lib.addCommand('delazer', {
    help = 'Toggles delete lazer',
    restricted = 'group.admin'
}, function(source, args, raw)
    TriggerClientEvent("ray-smallres:client:delazer", source)
end)

lib.addCommand('openinv', {
    help = 'Opens player inventory',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    if args.target then
        exports.ox_inventory:forceOpenInventory(source, 'player', tonumber(args.target))
    end
end)

lib.addCommand('clothingmenu', {
    help = 'Opens the clothing shop (paid) for a player',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
    },
    restricted = { 'group.admin', 'group.mod' }
}, function(source, args, raw)
    local targetId = tonumber(args.target)

    if targetId and GetPlayerName(targetId) then
        -- Open clothing shop (not free)
        TriggerClientEvent('qb-clothing:client:openMenu', targetId)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Success',
            description = 'Opened clothing menu for player ID: ' .. targetId,
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Invalid player ID.',
            type = 'error'
        })
    end
end)

lib.addCommand('food', {
    help = 'Feeds the specified player',
    params = {
        {
            name = 'amount',
            type = 'number',
            help = 'Amount to feed',
            optional = true
        },
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
            optional = true
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    local amount = args.amount ~= nil and args.amount or 100
    local target = args.target ~= nil and args.target or source

    if amount > 100 then
        amount = 100
    end

    local ply = QBCore.Functions.GetPlayer(target)
    if ply ~= nil then
        ply.Functions.SetMetaData('hunger', amount)
        ply.Functions.SetMetaData('thirst', amount)
    end
end)

lib.addCommand('bring', {
    help = 'Bring a player to your location',
    params = { { name = 'id', help = 'Player ID' } },
    restricted = { 'group.admin', 'group.mod' }
}, function(source, args)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then
        exports.qbx_core:Notify(source, 'Your player data could not be found', 'error')
        return
    end
    local targetSource = tonumber(args.id)
    if not targetSource then
        exports.qbx_core:Notify(source, 'Invalid player ID', 'error')
        return
    end
    local targetPlayer = exports.qbx_core:GetPlayer(targetSource)
    if not targetPlayer then
        exports.qbx_core:Notify(source, 'Player not found', 'error')
        return
    end
    if targetPlayer.PlayerData.source == source then
        exports.qbx_core:Notify(source, 'You cannot bring yourself', 'error')
        return
    end
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    TriggerClientEvent('qbx_core:client:Teleport', targetPlayer.PlayerData.source, playerCoords)
    exports.qbx_core:Notify(source, 'Player brought to your location', 'success')
end)


---------- MENUT KOMANDAS TIRI PIRI VISS KKADI HUJN


lib.addCommand('offlineclearinv', {
    help = 'Clear a player\'s inventory by their license2 identifier',
    params = {
        {
            name = 'license2',
            type = 'string',
            help = 'The player\'s license2 identifier (e.g., license2:abcdef...)',
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    if not args.license2 then
        return lib.notify(source, {
            type = 'error',
            description = 'You must provide a license2 identifier.'
        })
    end

    local affectedRows = MySQL.update.await(
            'UPDATE `players` SET `inventory` = ? WHERE `license` = ?',
            { json.encode({}), args.license2 }
    )

    if affectedRows > 0 then
        lib.notify(source, {
            type = 'success',
            description = ('Cleared inventory for license2: %s'):format(args.license2)
        })
    else
        lib.notify(source, {
            type = 'error',
            description = 'No player found with that license2.'
        })
    end
end)

lib.addCommand('postal', {
    help = 'Sets a waypoint to the specified postal code',
    params = {
        {
            name = 'postal',
            type = 'number',
            help = 'Postal code',
        },
    },
}, function(source, args, raw)
    if args.postal then
        TriggerClientEvent("postalCode:setPoint", source, args.postal)
    end
end)

lib.addCommand('getjob', {
    help = 'Show player count for a job',
    params = {
        {
            name = 'job',
            type = 'string',
            help = 'Job name',
        },
    },
    restricted = 'group.mod'
}, function(source, args, raw)
    local jobName = args.job

    local totalCount = exports.qbx_core:GetDutyCountJob(jobName)
    if totalCount == 0 then
        TriggerClientEvent('chat:addMessage', source, {
            args = {
                "System",
                ("No player with the %s job was found"):format(jobName)
            }
        })
        return
    end

    TriggerClientEvent('chat:addMessage', source, {
        args = {
            "System",
            string.format(
                    "Total players with the %s job: %d",
                    jobName,
                    totalCount
            )
        }
    })
end)

lib.callback.register('ray-smallres:checkPermission', function(source)
    local hasPermission = IsPlayerAceAllowed(tostring(source), "admin")
    return hasPermission
end)

lib.addCommand('maxveh', {
    help = 'Maxes the vehicle',
    restricted = 'group.admin'
}, function(source)
    TriggerClientEvent("ray-smallres:maxVehicle", source)
end)

lib.addCommand('sling', {
    help = 'Shoot someone in the air',
    params = {
        {
            name = 'player',
            type = 'playerId',
            help = 'Player ID',
            optional = true
        },
    },
    restricted = 'group.admin'
}, function(source, args)
    local ped = GetPlayerPed(source)
    if args.player then
        ped = GetPlayerPed(args.player)
    end
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        local velocity = GetEntityVelocity(veh)
        SetEntityVelocity(veh, velocity.x, velocity.y, velocity.z + 20.0)
    else
        local velocity = GetEntityVelocity(ped)
        SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z + 50.0)
    end
end)

-- Command to leave a specific gang
lib.addCommand('leavegang', {
    help = 'Leave a specific gang',
    params = {
        {
            name = 'gangName',
            type = 'string',
            help = 'Name of the gang to leave',
        },
    },
}, function(source, args)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then
        lib.notify(source, {
            title = 'Error',
            description = 'Player not found',
            type = 'error'
        })
        return
    end

    -- Check if player is in the specified gang
    local groups = exports.qbx_core:GetGroups(source)
    if not groups[args.gangName] then
        lib.notify(source, {
            title = 'Error',
            description = 'You are not a member of this gang',
            type = 'error'
        })
        return
    end

    -- Remove player from the gang
    exports.qbx_core:RemovePlayerFromGang(player.PlayerData.citizenid, args.gangName)

    lib.notify(source, {
        title = 'Success',
        description = ('You have left the %s gang'):format(args.gangName),
        type = 'success'
    })
end)

-- Command to leave all gangs
lib.addCommand('leaveallgangs', {
    help = 'Leave all gangs you are currently in',
}, function(source)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then
        lib.notify(source, {
            title = 'Error',
            description = 'Player not found',
            type = 'error'
        })
        return
    end

    -- Get all player's groups
    local groups = exports.qbx_core:GetGroups(source)
    local leftCount = 0

    -- Remove player from each gang
    for gangName in pairs(groups) do
        exports.qbx_core:RemovePlayerFromGang(player.PlayerData.citizenid, gangName)
        leftCount = leftCount + 1
    end

    if leftCount > 0 then
        lib.notify(source, {
            title = 'Success',
            description = ('You have left %d gang(s)'):format(leftCount),
            type = 'success'
        })
    else
        lib.notify(source, {
            title = 'Info',
            description = 'You are not a member of any gangs',
            type = 'info'
        })
    end
end)

lib.addCommand('911', {
    help = 'Call the police',
    params = {
        {
            name = 'message',
            type = 'longString',
            help = 'Message to send',
        },
    },
}, function(source, args)
    if not args.message then return end
    local ply = exports.qbx_core:GetPlayer(source)
    if ply == nil then return end

    -- Get phone number using High Phone script statebag instead of yseries
    local phoneNum = Player(source).state['phone:number'] or 'Unknown'
    local fullName = ply.PlayerData.charinfo.firstname .. " " .. ply.PlayerData.charinfo.lastname
    exports.tk_dispatch:addCall({
        title = '911 Call',
        code = '10-84',
        priority = 'Priority 3',
        message = ("%s (%s): %s"):format(fullName, phoneNum, args.message),
        coords = GetEntityCoords(GetPlayerPed(source)),
        showLocation = true,
        showGender = true,
        playSound = true,
        blip = {
            color = 3,
            sprite = 161,
            scale = 0.75,
        },
        jobs = { 'police' }
    })
end)

lib.addCommand('911a', {
    help = 'Call the police anonymously',
    params = {
        {
            name = 'message',
            type = 'longString',
            help = 'Message to send',
        },
    },
}, function(source, args)
    if not args.message then return end
    exports.tk_dispatch:addCall({
        title = 'Anonymous 911 Call',
        code = '10-84',
        priority = 'Priority 3',
        message = args.message,
        coords = GetEntityCoords(GetPlayerPed(source)),
        showLocation = true,
        showGender = false,
        playSound = true,
        blip = {
            color = 3,
            sprite = 161,
            scale = 0.75,
        },
        jobs = { 'police' }
    })
end)

-- RegisterServerEvent('ray-smallresources:server:createInvoice', function(targetId, amount)
--     local src = source
--     local target = tonumber(targetId)
--     local invoiceAmount = tonumber(amount)

--     if not target or not invoiceAmount or invoiceAmount <= 0 then
--         TriggerClientEvent('qbx_core:client:notify', src, {
--             text = "Invalid player ID or amount.",
--             notifyType = "error"
--         })
--         return
--     end

--     local sender = exports.qbx_core:GetPlayer(src)
--     if not sender then
--         TriggerClientEvent('qbx_core:client:notify', src, {
--             text = "Failed to identify your character.",
--             notifyType = "error"
--         })
--         return
--     end

--     local citizenid = sender.citizenid
--     if not citizenid then
--         TriggerClientEvent('qbx_core:client:notify', src, {
--             text = "No citizen ID found.",
--             notifyType = "error"
--         })
--         return
--     end

--     -- Attempt to remove the invoice amount from sender via p_banking
--     local removed = exports['p_banking']:RemoveMoney(targetId, invoiceAmount)
--     if not removed then
--         TriggerClientEvent('qbx_core:client:notify', src, {
--             text = "You don't have enough money to send the invoice!",
--             notifyType = "error"
--         })
--         return
--     end

--     -- Notify the sender (src)
--     TriggerClientEvent('qbx_core:client:notify', src, {
--         text = ("You invoiced player ID %s for $%s."):format(target, invoiceAmount),
--         notifyType = "success"
--     })

--     -- Notify the target (recipient)
--     TriggerClientEvent('qbx_core:client:notify', target, {
--         text = ("You received an invoice from player ID %s for $%s."):format(src, invoiceAmount),
--         notifyType = "inform"
--     })
-- end)

lib.addCommand('ban', {
    help = 'Ban a player using lc_adminmenu system (Mod/Admin only)',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
        {
            name = 'duration',
            type = 'number',
            help = 'Ban duration in hours (-1 for permanent)',
            optional = true
        },
        {
            name = 'disconnect',
            type = 'boolean',
            help = 'Disconnect player immediately (true/false)',
            optional = true
        },
        {
            name = 'reason',
            type = 'longString',
            help = 'Ban reason (can contain multiple words)',
        },
    },
    restricted = { 'group.admin', 'group.mod' }
}, function(source, args, raw)
    if not args.target then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'You must provide a target player ID.',
            type = 'error'
        })
        return
    end

    if not args.reason then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'You must provide a ban reason.',
            type = 'error'
        })
        return
    end

    local targetId = tonumber(args.target)
    local duration = args.duration or 24 -- Default to 24 hours if not specified
    local disconnect = args.disconnect ~= nil and args.disconnect or true -- Default to true if not specified
    
    -- Convert hours to seconds
    local durationSeconds = duration == -1 and -1 or (duration * 3600)
    
    -- Get target player info
    local targetPlayer = exports.qbx_core:GetPlayer(targetId)
    if not targetPlayer then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Target player not found.',
            type = 'error'
        })
        return
    end
    
    -- Get admin player info
    local adminPlayer = exports.qbx_core:GetPlayer(source)
    if not adminPlayer then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Admin player data not found.',
            type = 'error'
        })
        return
    end
    
    -- Ban the player using lc_adminmenu
    local success = exports.lc_adminmenu:banPlayer(targetId, args.reason, durationSeconds, disconnect)
    
    if success then
        local durationText = duration == -1 and 'permanently' or ('for ' .. duration .. ' hours')
        local disconnectText = disconnect and ' and disconnected' or ' but allowed to continue playing'
        
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Success',
            description = ('Banned %s %s%s'):format(targetPlayer.PlayerData.charinfo.firstname, durationText, disconnectText),
            type = 'success'
        })
        
        -- Notify target player if they're still online
        if disconnect then
            TriggerClientEvent('ox_lib:notify', targetId, {
                title = 'Banned',
                description = ('You have been banned: %s'):format(args.reason),
                type = 'error'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to ban player.',
            type = 'error'
        })
    end
end)



lib.addCommand('openstorage', {
    help = 'Opens a stash/storage by name',
    params = {
        {
            name = 'storagename',
            type = 'string',
            help = 'Storage/Stash name (exact id)'
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    local stashId = args.storagename

    if not stashId or stashId == '' then
        return TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'You must provide a storage name.',
            type = 'error'
        })
    end

    -- Admin bypass protection
    local originalBucket = GetPlayerRoutingBucket(source)
    SetPlayerRoutingBucket(source, 0)
    SetPlayerInvincible(source, true)

    -- Always register the stash first, then try to open it
    exports.ox_inventory:RegisterStash(stashId, stashId, 50, 100000)
    local success = exports.ox_inventory:forceOpenInventory(source, 'stash', {id = stashId})

    -- Send notification
    TriggerClientEvent('ox_lib:notify', source, {
        title = success and 'Success' or 'Error',
        description = success and ('Opened storage: %s'):format(stashId) or ('Failed to open storage: %s'):format(stashId),
        type = success and 'success' or 'error'
    })

    -- Restore admin bypass protection
    SetPlayerInvincible(source, false)
    SetPlayerRoutingBucket(source, originalBucket)
end)

lib.addCommand('getcitizenid', {
    help = 'Get citizenid from license identifier (Admin only)',
    params = {
        {
            name = 'license2',
            type = 'string',
            help = 'License identifier (license:xxxxx or license2:xxxxx)'
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    if not args.license2 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'You must provide a license identifier.',
            type = 'error'
        })
        return
    end

    local license = args.license2
    
    -- Handle both license: and license2: formats
    if not string.match(license, "^license") then
        license = "license:" .. license
    end

    -- Query database to get all characters from license
    local result = MySQL.query.await('SELECT citizenid, charinfo, job FROM players WHERE license = ?', {license})
    
    if result and #result > 0 then
        -- Build character info for display
        local characterInfo = {}
        for i, char in ipairs(result) do
            local charData = json.decode(char.charinfo)
            local jobData = json.decode(char.job)
            local fullName = charData.firstname .. " " .. charData.lastname
            local jobInfo = jobData.name and jobData.name ~= 'unemployed' and ('Job: %s'):format(jobData.label or jobData.name) or 'Job: Unemployed'
            
            table.insert(characterInfo, {
                label = ('Character %d: %s'):format(i, fullName),
                value = char.citizenid,
                description = ('Citizen ID: %s | %s'):format(char.citizenid, jobInfo)
            })
        end
        
        -- Show dialog with all characters
        TriggerClientEvent('ray-smallres:client:showCitizenIds', source, characterInfo, license)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'No player found with that license.',
            type = 'error'
        })
    end
end)

lib.addCommand('giveitemoffline', {
    help = 'Add items to offline player inventory via UI (Admin only)',
    restricted = 'group.admin'
}, function(source, args, raw)
    -- Open ox_lib dialog for adding items
    TriggerClientEvent('ray-smallres:client:openAddItemsDialog', source)
end)

-- Server event to add items to offline player inventory
RegisterNetEvent('ray-smallres:server:addItemsToOfflinePlayer', function(citizenid, items)
    local source = source
    
    -- Check if player exists and get their inventory
    local playerData = MySQL.query.await('SELECT citizenid, license, inventory FROM players WHERE citizenid = ?', {citizenid})
    if not playerData or #playerData == 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = ('Player with citizen ID %s not found'):format(citizenid),
            type = 'error'
        })
        return
    end

    local player = playerData[1]
    local currentInventory = json.decode(player.inventory) or {}
    local addedItems = {}
    
    -- Helper function to find first free slot
    local function findFreeSlot(inventory)
        local usedSlots = {}
        for _, item in pairs(inventory) do
            if item.slot then
                usedSlots[item.slot] = true
            end
        end
        
        -- Find first free slot starting from 1
        local slot = 1
        while usedSlots[slot] do
            slot = slot + 1
        end
        return slot
    end
    
    -- Helper function to generate random serial number
    local function generateSerial()
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local serial = ""
        for i = 1, 8 do
            local rand = math.random(1, #chars)
            serial = serial .. string.sub(chars, rand, rand)
        end
        return serial .. "WMP" .. math.random(100000, 999999)
    end
    
    -- Add all items
    for _, itemData in ipairs(items) do
        local itemInfo = exports.ox_inventory:Items(itemData.item)
        
        if not itemInfo then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Warning',
                description = ('Item "%s" does not exist'):format(itemData.item),
                type = 'warning'
            })
        else
            -- Find first available slot
            local freeSlot = findFreeSlot(currentInventory)
            
            -- Create item with proper metadata
            local metadata = itemData.metadata or {}
            
            -- Check if item is a weapon and generate automatic metadata
            if string.sub(itemData.item, 1, 7) == "weapon_" then
                metadata = {
                    durability = 100,
                    serial = generateSerial(),
                    ammo = 0,
                    registered = "Rajmond Onkulis",
                    components = {}
                }
                print(('Debug - Generated weapon metadata for %s: durability=100, serial=%s, registered=Rajmond Onkulis'):format(itemData.item, metadata.serial))
            end
            
            local newItem = {
                name = itemData.item,
                label = itemInfo.label,
                weight = itemInfo.weight,
                slot = freeSlot,
                count = itemData.count,
                description = itemInfo.description,
                metadata = metadata,
                stack = itemInfo.stack,
                close = itemInfo.close
            }
            
            -- Add to inventory (ox_inventory uses numeric keys matching slot numbers)
            currentInventory[freeSlot] = newItem
            table.insert(addedItems, ('%dx %s'):format(itemData.count, itemData.item))
            
            print(('Debug - Added: %dx %s to slot %d'):format(itemData.count, itemData.item, freeSlot))
        end
    end

    if #addedItems > 0 then
        -- Update database with new inventory
        local success = MySQL.update.await('UPDATE players SET inventory = ? WHERE citizenid = ?', {
            json.encode(currentInventory),
            citizenid
        })
        
        if success then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Success',
                description = ('Added items to %s: %s'):format(citizenid, table.concat(addedItems, ', ')),
                type = 'success'
            })
        else
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Error',
                description = 'Failed to update database',
                type = 'error'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to add any items to player inventory',
            type = 'error'
        })
    end
end)
