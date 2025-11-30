fx_version 'cerulean'
author 'Marttins'
game 'gta5'
description 'Shit scrayard script for QBCore and QBXCore by MT Scripts'
lua54 'yes'

shared_script '@ox_lib/init.lua'

client_script 'resource/client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'resource/server.lua'
}

files {
    'config/*.lua',
    'modules/**/*.lua',
    'locales/*.json'
}

escrow_ignore {
    'config/*',
    'modules/**/*.lua',
    -- 'resource/server.lua'
}
dependency '/assetpacks'