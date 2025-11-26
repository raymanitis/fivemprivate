function hasPermissions(source)
    -- Add your own check here if u want
    return IsPlayerAceAllowed(tostring(source), 'command.' .. Config.AdminCommand)
end