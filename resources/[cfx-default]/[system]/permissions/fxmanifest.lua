fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script 'client/main.lua'
server_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'server/api.lua',
    'server/main.lua'
}