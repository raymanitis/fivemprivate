game 'gta5'
fx_version 'cerulean'

name 'Nexure Racing'
description 'Racing script based on the modern standards of FiveM'
author 'Nexure Development'
version '1.2.0'

dependencies {
    'nx_racing_props',
    'ox_lib',
    'oxmysql'
}

ui_page 'web/build/index.html'

shared_script '@ox_lib/init.lua'
server_script '@oxmysql/lib/MySQL.lua'

files {
    'locales/*.json',
    'configs/config.lua',
    'configs/vehicleClasses.lua',
    'modules/**/client.lua',
    'web/build/index.html',
	'web/build/**/*',
    'web/build/*.ttf',
    'web/waypoints/build/index.html',
	'web/waypoints/build/**/*',
    'web/raceStart/build/index.html',
	'web/raceStart/build/**/*',
    'sql/*.sql',
}

shared_script 'load.lua'

shared_scripts {
    'shared/*.lua',
    'imports.lua'
}

server_scripts {
    'server/*.lua',
}

client_scripts {
    'client/*.lua'
}

lua54 'yes'

use_experimental_fxv2_oal 'yes'

escrow_ignore {
    'configs/*.lua',
    'modules/**/*.lua',
    'imports.lua',
}
dependency '/assetpacks'