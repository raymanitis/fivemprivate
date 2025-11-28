fx_version 'cerulean'
game 'gta5'

author 'Samuel#0008'
description 'FiveM Shop System'
version '1.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'bridge/init.lua',
    'bridge/shared.lua',
    'configs/*.lua'
}

client_scripts {
    'bridge/client.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/server.lua',
    'server/management.lua',
    'server/main.lua'
}

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/assets/*.js',
    'web/build/assets/*.css',
    'locales/*.json'
}

escrow_ignore { 'configs/*.lua', 'bridge/*.lua' }

lua54 'yes'

dependency '/assetpacks'