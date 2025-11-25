---@diagnostic disable: undefined-global
fx_version("cerulean")
use_experimental_fxv2_oal("yes")
game("gta5")
lua54("yes")
nui_callback_strict_mode("true")

author("snakewiz & iLLeniumStudios (Rewrite & Redesign in Svelte 5 by vipex)")
description(
	"A complete overhaul & re-build of the front-end/interface of the original illenium-appearance, slight tweaks have been made to the back-end with more on the way, basically an attempt to modernize illenium."
)
version("1.21.91")

files({
	"dist/index.html",
	"dist/images/*.png",
	"dist/images/*.webp",
	"dist/assets/*.js",
	"dist/assets/*.css",
	"modules/utility/shared/**/*.lua",
})

shared_scripts({
	"@ox_lib/init.lua",
	"shared/config.lua",
	"shared/theme.lua",
	"shared/blacklist.lua",
	"shared/peds.lua",
	"shared/tattoos.lua",
	"shared/framework/framework.lua",
	"shared/framework/esx/util.lua",
	"locales/init.lua",
	"locales/languages/*.lua",
})

client_scripts({
	"modules/required/client/**/*.lua",
	"game/constants.lua",
	"game/bridge.lua",
	"game/util.lua",
	"game/customization.lua",
	"game/nui.lua",
	"client/outfits.lua",
	"client/common.lua",
	"client/zones.lua",
	"client/framework/framework.lua",
	"client/framework/qb/compatibility.lua",
	"client/framework/qb/main.lua",
	"client/framework/qb/migrate.lua",
	"client/framework/esx/compatibility.lua",
	"client/framework/esx/main.lua",
	"client/framework/ox/main.lua",
	"client/target/target.lua",
	"client/target/qb.lua",
	"client/target/ox.lua",
	"client/management/management.lua",
	"client/management/common.lua",
	"client/management/qb.lua",
	"client/management/qbx.lua",
	"client/management/esx.lua",
	"client/radial/radial.lua",
	"client/radial/qb.lua",
	"client/radial/ox.lua",
	"client/stats.lua",
	"client/defaults.lua",
	"client/blips.lua",
	"client/props.lua",
	"client/client.lua",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"server/database/database.lua",
	"server/database/jobgrades.lua",
	"server/database/managementoutfits.lua",
	"server/database/playeroutfitcodes.lua",
	"server/database/playeroutfits.lua",
	"server/database/players.lua",
	"server/database/playerskins.lua",
	"server/database/users.lua",
	"server/framework/qb/main.lua",
	"server/framework/qb/migrate.lua",
	"server/framework/esx/main.lua",
	"server/framework/esx/migrate.lua",
	"server/framework/esx/callbacks.lua",
	"server/framework/esx/management.lua",
	"server/framework/ox/main.lua",
	"server/util.lua",
	"server/server.lua",
	"server/permissions.lua",
})

escrow_ignore({
	"shared/**/*.lua",
	"locales/**/*.lua",
	"modules/utility/server/**/*.lua",
	"modules/utility/shared/**/*.lua",
	"game/bridge.lua",
	"game/util.lua",
	"game/constants.lua",
	"client/framework/**/*.lua",
	"client/management/**/*.lua",
	"client/radial/**/*.lua",
	"client/target/**/*.lua",
	"client/blips.lua",
	"client/client.lua",
	"client/common.lua",
	"client/defaults.lua",
	"client/outfits.lua",
	"client/props.lua",
	"client/stats.lua",
	"client/zones.lua",
	"server/database/**/*.lua",
	"server/framework/**/*.lua",
	"server/permissions.lua",
	"server/server.lua",
	"server/util.lua",
})

dependencies("ox_lib")
ui_page("dist/index.html")
-- ui_page("http://localhost:5173")

provides({ "esx_skin", "skinchanger" })

dependency '/assetpacks'