local isEscorted = false

-- This function is kept for compatibility but does nothing
function PlayLastStandAnimation()
    -- Do nothing - laststand removed
end

---@param bool boolean
---TODO: this event name should be changed within qb-policejob to be generic
AddEventHandler('hospital:client:isEscorted', function(bool)
    isEscorted = bool
end)