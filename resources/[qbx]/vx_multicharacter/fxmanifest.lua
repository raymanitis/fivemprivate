---@diagnostic disable: undefined-global
fx_version("cerulean")
use_experimental_fxv2_oal("yes")
game("gta5")
lua54("yes")
nui_callback_strict_mode("true")

author("vipex <discord:vipex.v>")
description("A modern cinematic multicharacter system with an advanced spawn selector.")
version("1.0.67")

files({
	"data/**/*.json",
	"config/shared.lua",
	"config/framework/shared/**/*.lua",
	"modules/utility/shared/**/*.lua",
	"modules/framework-bridge/**/*.lua",
})

files({
	"locales/**/*.json",
	"dist/index.html",
	"dist/fonts/*.woff2",
	"dist/images/*.webp",
	"dist/assets/*.js",
	"dist/assets/*.css",
})

shared_scripts({
	"enums/**/*.lua",
	"modules/required/shared/**/*.lua",
	"shared.init.lua",
})

client_scripts({
	"modules/required/client/**/*.lua",
	"client.init.lua"
})


server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"modules/required/server/**/*.lua",
	"server.init.lua"
})

ui_page("dist/index.html")
-- ui_page("http://localhost:5173")

dependencies({
	"oxmysql"
})

escrow_ignore({
	"config/**/*.lua",
	"modules/framework-bridge/**/*.lua",
	"modules/property-handlers/**/*.lua",
	"modules/utility/**/*.lua"
})

provides({ "esx_identity", "esx_multicharacter", "qb-multicharacter" })

dependency '/assetpacks'