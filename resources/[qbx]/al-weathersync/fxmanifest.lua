fx_version 'cerulean'
game 'gta5'
lua54 "yes"
use_experimental_fxv2_oal "yes"

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

server_script 'server/server.lua'
client_script 'client/client.lua'

lua54 'yes'
