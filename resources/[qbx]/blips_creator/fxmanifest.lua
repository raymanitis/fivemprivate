version '3.1.2' -- Script version

author 'jaksam1074'

shared_script 'shared.lua'

client_scripts {
    "language.lua",
    'sh_config.lua',
    "callbacks/cl_callbacks.lua",
    "client/nui_callbacks.lua",
    "client/main.lua",

    -- Dialogs
    "utils/dialogs/**/cl_*.lua",

}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    'sh_config.lua',
    "callbacks/sv_callbacks.lua",
    "server/database.lua",
    "server/main.lua",
    "server/sprites.lua",

    -- Dialogs
    "utils/dialogs/**/sv_*.lua",
    "utils/miscellaneous/misc.js",
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/index.css',
    'html/index.js',
    '_sprites/**/*.png',
    "utils/dialogs/**/*.js",
    "utils/miscellaneous/**/*",   
}

lua54 'yes'

this_is_a_map 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/L1_1.ytyp' 

files {
    'stream/L1_1.ytyp',
    'stream/L1_1.ydr',
}

escrow_ignore {
    "sql/blips_creator.sql",
    "sh_config.lua",
    "language.lua",
}

dependencies {
    '/server:4752'
}

fx_version 'cerulean'
game 'gta5'
dependency '/assetpacks'