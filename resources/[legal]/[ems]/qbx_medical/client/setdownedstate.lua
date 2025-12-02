local isEscorted = false
-- Removed all laststand animation variables and functions - laststand stage is completely removed
-- Death animation is handled by dead.lua instead

-- This function is kept for compatibility but does nothing (laststand removed)
function PlayLastStandAnimation()
    -- Do nothing - laststand is removed, use death animation instead
end

---@param bool boolean
---TODO: this event name should be changed within qb-policejob to be generic
AddEventHandler('hospital:client:isEscorted', function(bool)
    isEscorted = bool
end)