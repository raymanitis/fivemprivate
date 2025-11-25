Config = Config or {}

Config.Options = {
    enableBackground = false,   -- Toggle background change on/off
    opacity = 90,               -- Change background opacity
    ChangeHeaderNames = false,  -- Toggle header name changes on/off
    enableColorChanges = true, -- Toggle all color changes on/off
    RedGreenBlueAlpha = {

        --- [[[[[[[[[[[[[  https://rgbacolorpicker.com  ]]]]]]]]]]]]]
        --- [[[[[[[[[[[[[  https://rgbacolorpicker.com  ]]]]]]]]]]]]]
        --- [[[[[[[[[[[[[  https://rgbacolorpicker.com  ]]]]]]]]]]]]]
        --- [[[[[[[[[[[[[  https://rgbacolorpicker.com  ]]]]]]]]]]]]]
        --- [[[[[[[[[[[[[  https://rgbacolorpicker.com  ]]]]]]]]]]]]]

        HudLineColor = {
            ["RED"] = 0,
            ["GREEN"] = 0,
            ["BLUE"] = 0,
            
           ---- Dont change ALPHA ❌
            ["ALPHA"] = 0.8,
        },
        PauseMenuStyleColor = {
            ["RED"] = 62,
            ["GREEN"] = 62,
            ["BLUE"] = 62,
            
           ---- Dont change ALPHA ❌
            ["ALPHA"] = 0.8,
        },
        MapWaypointColor = {
            ["RED"] = 189,
            ["GREEN"] = 0,
            ["BLUE"] = 255,

           ---- Dont change ALPHA ❌
            ["ALPHA"] = 0.8,
        },
    },
    Header = {
        ["TITLE"] = "Server Name Menu",
        ["SUBTITLE"] = "The beautiful city",
        ["MAP"] = "Map",
        ["GAME"] = "Exit Game",
        ["LEAVE"] = "Return to Server List",
        ["QUIT"] = "Return to Desktop",
        ["INFO"] = "Information",
        ["STATS"] = "Statistics",
        ["SETTINGS"] = "Settings",
        ["GALLERY"] = "Gallery",
        ["KEYBIND"] = "Main Keybinds",
        ["EDITOR"] = "Rockstar Editor",
        ["SERVER_NAME"] = "Server Name",
        ["SERVER_TEXT"] = "Welcome to our city",
        ["SERVER_DISCORD"] = "discordlink.gg"
    }
}
