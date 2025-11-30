Config = {}

Config.Framework = "QBCore"  -- or "ESX"
Config.KeyBind = "HOME"
Config.ServerName = "Atleast RP"
Config.EnableCursor = false
Config.ShowIdsAboveHeads = false -- staff only
Config.ShowIdsToEveryone = false -- ignores staff only and shows IDs to everyone
Config.ShowPing = true -- shows player ping
Config.ShowHighlightedJobs = false
Config.UseGenericNames = true -- if true, shows "player:atleast" instead of real names izmainas
Config.GenericNameFormat = "player:atleast" -- format for generic names (you can use {id} to include player ID)
Config.HighlightedJobs = {
  [1] = {
    jobs = {"police"}, -- the name of one or more jobs in QBCore that you want to be counted
    label = "Police", -- this can be any label you choose!
    icon = "shield", -- https://icons.getbootstrap.com/ - paste the name of the icon without the bi- prefix
    color = "#135dd8", -- this must be a hex code
    countOnDutyOnly = true -- only include players set as on duty in the count
  },
  [2] = {
    jobs = {"ambulance"},
    label = "Medics",
    icon = "heart-pulse",
    color = "#27ae60",
    countOnDutyOnly = true
  },
  [3] = {
    jobs = {"mechanic"},
    label = "Mechanics",
    icon = "wrench-adjustable",
    color = "#e67e22",
    countOnDutyOnly = true
  }
  -- [4] = {
  --   jobs = {"cardealer"},
  --   label = "Car Dealers",
  --   icon = "car-front",
  --   color = "#c0392b",
  --   countOnDutyOnly = false
  -- }
}

Config.ShowPlayers = true
Config.UseCharacterNames = false -- if true uses QB/ESX character name, if false uses FiveM username
Config.ShowAdminBadges = false
Config.AdminBadgeIcon = "star-fill" -- https://icons.getbootstrap.com/ - paste the name of the icon without the bi- prefix
Config.ShowPlayerIds = true
Config.ShowPlayerJob = false
Config.ShowPlayerJobDutyStatus = false