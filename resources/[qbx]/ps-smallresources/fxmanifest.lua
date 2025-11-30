
fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal "yes"

shared_script '@ox_lib/init.lua'
server_script {
    '@oxmysql/lib/MySQL.lua',
    '**/server.lua'
}

client_script {
    '@qbx_core/modules/playerdata.lua',
    '**/client.lua'
}

files {
    'pursuitmodes/config.json',
    '**/config.lua'
}

export 'isSecurityActive'