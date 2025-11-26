fx_version "cerulean"
lua54 "yes"
game "gta5"
use_experimental_fxv2_oal "yes"

author "Thomas"
description "An optimized HUD for fivem made with React Typescript and mantine"

ui_page "web/build/index.html"

files {
	"web/build/index.html",
	"web/build/**/*",
}

shared_scripts {
    "@ox_lib/init.lua",
    -- "@qbx_core/modules/lib.lua", -- Uncomment this line if you are using qbx_core
    "configs/*.lua",
}

client_script {
    "bridge/client/**.lua",
    "client/**/*",
}

server_scripts {
    "bridge/server/**.lua",
    "server/**/*"
}

escrow_ignore {
    "bridge/**/*",
    "client/**/*",
    "server/**/*",
    "configs/**/*",
    "web/build/index.html",
	"web/build/**/*",
    "fxmanifest.lua",
}

dependency '/assetpacks'
dependency '/assetpacks'