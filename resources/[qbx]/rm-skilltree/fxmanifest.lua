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
    "@ox_lib/init.lua",
}

client_script {
    "client/client.lua",
}