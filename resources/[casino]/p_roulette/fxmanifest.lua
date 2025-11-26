fx_version 'cerulean'
game 'gta5'
author 'piotreq'
description 'Casino Roulette'
lua54 'yes'

ui_page 'web/index.html'

files {
    'locales/*.json',
    'web/index.html',
    'web/img/*.svg'
}

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client/main.lua',
    'client/utils.lua',
    'client/editable.lua',
    'bridge/client/*.lua',
}

server_scripts {
    'server/*.lua',
    'bridge/server/*.lua'
}

escrow_ignore {
    'config.lua',
    'bridge/client/esx.lua',
    'bridge/client/qb.lua',
    'bridge/server/esx.lua',
    'bridge/server/qb.lua',
    'client/editable.lua'
}
dependency '/assetpacks'