return {
    -- Logging Configuration
    Logging = {
        enabled = true,          -- Enable/disable all logging
        logSmelting = true,      -- Log smelting activities
        logAntiCheat = true,     -- Log anti-cheat detections
        
        -- Embed colors for Discord webhooks (in decimal format)
        embedColor = {
            smelting = 16753920,  -- Orange color for smelting logs
            anticheat = 16711680  -- Red color for anti-cheat logs
        }
    },
    
    -- Discord Webhook URLs
    Webhooks = {
        smelting = "",    -- Discord webhook URL for smelting activities (leave empty to disable)
        anticheat = ""    -- Discord webhook URL for anti-cheat alerts (leave empty to disable)
    }
} 