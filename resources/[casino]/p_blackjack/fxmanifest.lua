fx_version 'cerulean'
game 'gta5'
author 'piotreq'
description 'Casino Black Jack'
lua54 'yes'

ui_page 'web/index.html'

files {
    'locales/*.json',
    'web/index.html',
    'web/img/*.svg'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
	'init.lua',
}

client_scripts{
	'client/*.lua',
	'bridge/client/*.lua'
} 

server_scripts{
	'server/*.lua',
	'bridge/server/*.lua'
}

escrow_ignore {
	'client/utils.lua',
	'config.lua',
	'bridge/client/esx.lua',
	'bridge/client/qb.lua',
	'bridge/server/esx.lua',
	'bridge/server/qb.lua'
}

dependency '/assetpacks'