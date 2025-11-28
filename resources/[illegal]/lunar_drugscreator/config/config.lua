/*
    THANKS FOR PURCHASING OUR DRUGS CREATOR SCRIPTS! <3
    
    Target, 3D prompts, dispatch, notifications and progress bar can be configured in lunar_bridge/config
    Want to use dirty money item as an account? Configure it in lunar_bridge/config/config.lua

    Need help with the script?
    Join our discord, claim the customer role and open a support ticket:
    https://discord.gg/AAuvQYgyqX
*/

Config = {}

-- The command to open up the menu
Config.command = 'drugscreator'

-- The /drugscreator menu locales are separate from the normal in-game locales
-- You can find them in web/dist/locales
Config.uiLanguage = 'en'

-- You can add a font name here
-- Don't add <font face=""> etc., just add the font name
Config.blipsFont = ''

-- The groups that can use /drugscreator
-- Ignore this if you're on qb-core and use this inside server.cfg: add_ace group.admin drugscreator_admin allow
Config.adminGroups = {
    ['admin'] = true,
    ['god'] = true
}