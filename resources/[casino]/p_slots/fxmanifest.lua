fx_version 'cerulean'
game 'gta5'
author 'piotreq [discord.gg/piotreqscripts]'
description 'Casino Slots'
lua54 'yes'

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/img/*.svg',
    'locales/*.json',
}

shared_scripts {
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
    'bridge/server/*.lua',
}

escrow_ignore {
    'bridge/client/esx.lua',
    'bridge/client/qb.lua',
    'bridge/server/esx.lua',
    'bridge/server/qb.lua',
    'config.lua',
    'client/editable.lua',
}
dependency '/assetpacks'