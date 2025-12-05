Config = {}

Config.Language = "en"

Config.NotifyXP = true

Config.MenuCommand = ""

Config.EnableF7Keybind = false

Config.Categories = {
    ["driving"] = {
        label = "Driving", -- Label of the category in the display & notifications.
        category = "default", -- Category filter: "default", "criminal", or "civilian"
        xpStart = 1000, -- Level 2 XP requirement.
        xpFactor = 0.5, -- Multiplier for much to increase the next level's XP requirement.
        maxLevel = 10 -- Maximum level achievable.
    },
    ["Strength"] = {
        label = "Strength", -- Label of the category in the display & notifications.
        category = "default", -- Category filter: "default", "criminal", or "civilian"
        xpStart = 1000, -- Level 2 XP requirement.
        xpFactor = 0.5, -- Multiplier for much to increase the next level's XP requirement.
        maxLevel = 10 -- Maximum level achievable.
    },
    ["crafting"] = {
        label = "Crafting", -- Label of the category in the display & notifications.
        category = "default", -- Category filter: "default", "criminal", or "civilian"
        xpStart = 1000, -- Level 2 XP requirement.
        xpFactor = 0.5, -- Multiplier for much to increase the next level's XP requirement.
        maxLevel = 10 -- Maximum level achievable.
    },
    ['Mining'] = {
        label = "Mining", -- Label of the category in the display & notifications.
        category = "default", -- Category filter: "default", "criminal", or "civilian"
        xpStart = 1000, -- Level 2 XP requirement.
        xpFactor = 0.5, -- Multiplier for much to increase the next level's XP requirement.
        maxLevel = 10 -- Maximum level achievable.
    },

    ['Hustler'] = {
        label = "Hustler", -- Label of the category in the display & notifications.
        category = "criminal", -- Category filter: "default", "criminal", or "civilian"
        xpStart = 1000, -- Level 2 XP requirement.
        xpFactor = 0.5, -- Multiplier for much to increase the next level's XP requirement.
        maxLevel = 10 -- Maximum level achievable.
    },
    ['Hacker'] = {
        label = "Hacker", -- Label of the category in the display & notifications.
        category = "criminal", -- Category filter: "default", "criminal", or "civilian"
        xpStart = 1000, -- Level 2 XP requirement.
        xpFactor = 0.5, -- Multiplier for much to increase the next level's XP requirement.
        maxLevel = 10 -- Maximum level achievable.
    },
    ['drug_lord'] = {
        label = "Drug Lord", -- Label of the category in the display & notifications.
        category = "criminal", -- Category filter: "default", "criminal", or "civilian"
        xpStart = 1000, -- Level 2 XP requirement.
        xpFactor = 0.5, -- Multiplier for much to increase the next level's XP requirement.
        maxLevel = 10 -- Maximum level achievable.
    },

    ['Grinder'] = {
        label = "Grinder", -- Label of the category in the display & notifications.
        category = "civilian", -- Category filter: "default", "criminal", or "civilian"
        xpStart = 1000, -- Level 2 XP requirement.
        xpFactor = 0.5, -- Multiplier for much to increase the next level's XP requirement.
        maxLevel = 10 -- Maximum level achievable.
    },
    ['entrepreneur'] = {
        label = "Entrepreneur", -- Label of the category in the display & notifications.
        category = "civilian", -- Category filter: "default", "criminal", or "civilian"
        xpStart = 1000, -- Level 2 XP requirement.
        xpFactor = 0.5, -- Multiplier for much to increase the next level's XP requirement.
        maxLevel = 10 -- Maximum level achievable.
    },
}