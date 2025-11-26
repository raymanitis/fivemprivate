fx_version "cerulean"
use_experimental_fxv2_oal 'yes'
lua54 "yes"
game "gta5"

shared_scripts { 
    "@ox_lib/init.lua", 
    "config.lua" 
}

client_scripts {
    "@qbx_core/modules/playerdata.lua",
    "client/main.lua"
}

server_scripts { 
    '@oxmysql/lib/MySQL.lua', 
    "server/main.lua" 
}

ui_page 'web/index.html'
files {
    'web/index.html',
    'web/assets/style.css',
    'web/assets/script.js'
}