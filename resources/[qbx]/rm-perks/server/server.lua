local utils = require 'modules.utils'

-- Database table creation
CreateThread(function()
    exports.oxmysql:execute([[
        CREATE TABLE IF NOT EXISTS `specializations` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `citizenid` VARCHAR(50) NOT NULL,
            `specialization_id` VARCHAR(50) NOT NULL,
            `selected_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `citizenid` (`citizenid`),
            INDEX `idx_citizenid` (`citizenid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end)

-- Get player's current specialization
local function GetPlayerSpecialization(citizenid)
    local result = exports.oxmysql:querySync('SELECT * FROM specializations WHERE citizenid = ?', {citizenid})
    if result and #result > 0 then
        return result[1]
    end
    return nil
end

-- Set player's specialization
local function SetPlayerSpecialization(citizenid, specializationId)
    local existing = GetPlayerSpecialization(citizenid)
    
    if existing then
        exports.oxmysql:execute('UPDATE specializations SET specialization_id = ?, selected_at = CURRENT_TIMESTAMP WHERE citizenid = ?', {
            specializationId,
            citizenid
        })
    else
        exports.oxmysql:execute('INSERT INTO specializations (citizenid, specialization_id) VALUES (?, ?)', {
            citizenid,
            specializationId
        })
    end
end

-- Check if player can change specialization (once per week)
local function CanChangeSpecialization(citizenid)
    local data = GetPlayerSpecialization(citizenid)
    if not data then
        return true, 0 -- Can choose if they don't have one
    end
    
    -- Use MySQL to calculate time difference
    local result = exports.oxmysql:querySync('SELECT TIMESTAMPDIFF(SECOND, selected_at, NOW()) as seconds_passed FROM specializations WHERE citizenid = ?', {citizenid})
    if not result or #result == 0 then
        return true, 0
    end
    
    local secondsPassed = result[1].seconds_passed or 0
    local weekInSeconds = 7 * 24 * 60 * 60
    local timeRemaining = weekInSeconds - secondsPassed
    
    if timeRemaining <= 0 then
        return true, 0
    end
    
    return false, timeRemaining
end

-- Get all specializations data for a player
local function GetPlayerSpecializationsData(citizenid)
    local data = GetPlayerSpecialization(citizenid)
    local canChange, timeRemaining = CanChangeSpecialization(citizenid)
    
    return {
        currentSpecialization = data and data.specialization_id or nil,
        canChange = canChange,
        timeRemaining = timeRemaining,
        selectedAt = data and data.selected_at or nil
    }
end

-- Server event: Get specializations data
RegisterNetEvent('rm-perks:server:getSpecializations', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then
        return
    end
    
    local citizenid = Player.PlayerData.citizenid
    local specData = GetPlayerSpecializationsData(citizenid)
    
    TriggerClientEvent('rm-perks:client:receiveSpecializations', src, specData)
end)

-- Server event: Select specialization
RegisterNetEvent('rm-perks:server:selectSpecialization', function(specializationId)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then
        TriggerClientEvent('rm-perks:client:selectionResult', src, {success = false, error = 'Player not found'})
        return
    end
    
    local citizenid = Player.PlayerData.citizenid
    
    if not specializationId then
        TriggerClientEvent('rm-perks:client:selectionResult', src, {success = false, error = 'Invalid specialization'})
        return
    end
    
    local canChange, timeRemaining = CanChangeSpecialization(citizenid)
    
    if not canChange then
        local days = math.floor(timeRemaining / (24 * 60 * 60))
        local hours = math.floor((timeRemaining % (24 * 60 * 60)) / (60 * 60))
        TriggerClientEvent('rm-perks:client:selectionResult', src, {
            success = false,
            error = string.format('You can change your specialization in %d days and %d hours', days, hours)
        })
        return
    end
    
    SetPlayerSpecialization(citizenid, specializationId)
    
    TriggerClientEvent('ox_lib:notify', src, {
        type = 'success',
        title = 'Specialization Selected',
        description = 'You have selected: ' .. specializationId,
        duration = 5000
    })
    
    -- Send updated data
    local specData = GetPlayerSpecializationsData(citizenid)
    TriggerClientEvent('rm-perks:client:receiveSpecializations', src, specData)
    TriggerClientEvent('rm-perks:client:selectionResult', src, {success = true})
end)

-- Command: /spec - Show current specialization
RegisterCommand('spec', function(source, args, rawCommand)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then
        return
    end
    
    local citizenid = Player.PlayerData.citizenid
    local data = GetPlayerSpecialization(citizenid)
    
    if data then
        local canChange, timeRemaining = CanChangeSpecialization(citizenid)
        local message = 'Your specialization: ' .. data.specialization_id
        
        if not canChange then
            local days = math.floor(timeRemaining / (24 * 60 * 60))
            local hours = math.floor((timeRemaining % (24 * 60 * 60)) / (60 * 60))
            message = message .. string.format('\nYou can change it in %d days and %d hours', days, hours)
        else
            message = message .. '\nYou can change it now!'
        end
        
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'info',
            title = 'Specialization',
            description = message,
            duration = 5000
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'info',
            title = 'Specialization',
            description = 'You have not selected a specialization yet. Use the specialization menu to choose one.',
            duration = 5000
        })
    end
end, false)

-- Event to open UI
RegisterNetEvent('rm-perks:server:openUI', function()
    local src = source
    TriggerClientEvent('rm-perks:client:openUI', src)
end)

