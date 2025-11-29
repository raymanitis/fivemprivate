return {
    -- Logging Enabled/Disabled
    enabled = false,

    -- "ox_lib" or "discord"
    -- https://overextended.dev/ox_lib/Modules/Logger/Server for more information on the ox_lib logger.
    type = "ox_lib",

    discord = {
        -- If this is defined, the webhook will be used for all logs. If this is not defined (set to false), the webhooks below will be used.
        single = "https://discord.com/api/webhooks/1234567890/abcdefghijklmnopqrstuvwxyz",

        -- These will be ignored, if the single webhook is defined.

        -- Log for when races are created.
        raceGeneration = "https://discord.com/api/webhooks/1234567890/abcdefghijklmnopqrstuvwxyz",
        -- Log for when a race ends, and the winners are announced.
        raceEnded = "https://discord.com/api/webhooks/1234567890/abcdefghijklmnopqrstuvwxyz",
        -- Admin logs.
        admin = "https://discord.com/api/webhooks/1234567890/abcdefghijklmnopqrstuvwxyz",
    }
}