-- Resource Metadata
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Lunar Scripts'
description 'Drugs Creator'
version '1.1.0'

-- What to run
escrow_ignore {
    'config/**/*.lua',
}

dependency {
    'lunar_bridge'
}

files {
    'locales/*.json',
    'web/dist/**/*',
}

ui_page 'web/dist/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'init.lua',
    'config/config.lua',
}

client_scripts {
    '@lunar_bridge/framework/esx/client.lua',
    '@lunar_bridge/framework/qb/client.lua',
    'config/cl_edit.lua',
    'client/modules/*.lua',
    'client/ui.lua',
    'client/helper.lua',
    'client/main.lua',
}

server_scripts {
    '@lunar_bridge/framework/esx/server.lua',
    '@lunar_bridge/framework/qb/server.lua',
    '@oxmysql/lib/MySQL.lua',
    'config/sv_config.lua',
    'config/sv_edit.lua',
    'server/modules/*.lua',
    'server/default.lua',
    'server/discord.lua',
    'server/webhook.lua',
    'server/stats.lua',
    'server/main.lua',
}
dependency '/assetpacks'