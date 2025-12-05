fx_version 'cerulean'

game 'gta5'

description 'Housing System'

author 'TuKeh_'

version '1.4.2'

lua54 'yes'

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/**/*',
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
	'locales/*.lua',
	'config.lua',
}

client_scripts {
    'client/frameworks/*.lua',
    'client/main_editable.lua',
    'client/*.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    'config_sv.lua',
    'server/frameworks/*.lua',
    'server/main_editable.lua',
    'server/*.lua',
}

escrow_ignore {
    'locales/*.lua',
    'config.lua',
    'config_sv.lua',
    'client/frameworks/*.lua',
    'server/frameworks/*.lua',
    'client/main_editable.lua',
    'server/main_editable.lua',
}
dependency '/assetpacks'