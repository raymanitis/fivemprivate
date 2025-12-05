fx_version "cerulean"
lua54 "yes"
game "gta5"

author "Thomas"

files {
    "modules/*.lua",
	"web/build/index.html",
	"web/build/**/*",
}

shared_scripts {
    "@ox_lib/init.lua",      -- ox_lib (required for vec3/vec4, callbacks, etc.)
    "config/sv_config.lua",  -- main config (server/client shared for simplicity)
    "config/config.lua",     -- extra/shared config (optional, left for future use)
}

client_scripts {
    "client/client.lua",
}

server_scripts {
    "server/server.lua",
}

dependencies {
    "ox_lib",
    "ox_target",
    "ox_inventory",
    -- "qbx_core", -- uncomment if your Qbox core resource is named qbx_core
}