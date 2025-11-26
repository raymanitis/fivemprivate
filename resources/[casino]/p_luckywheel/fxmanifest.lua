fx_version 'cerulean'
game 'gta5'
author 'pScripts [tebex.pscripts.store]'
description 'p_luckywheel - A customizable lucky wheel for FiveM'
lua54 'yes'
version '1.0.0'

ui_page 'web/build/index.html'

client_script "client/**/*"
server_scripts {
	"server/**/*",
	'@oxmysql/lib/MySQL.lua'
}

files {
	'web/build/index.html',
	'web/build/**/*',
	'web/wheel.html',
    'stream/*.gfx',
  	'locales/*.json'
}

shared_scripts {
    '@ox_lib/init.lua',
	'config.lua'
}

dependencies {
	'ox_lib',
	'p_bridge'
}

escrow_ignore {
	'config.lua',
	'server/editable_functions.lua'
}
dependency '/assetpacks'