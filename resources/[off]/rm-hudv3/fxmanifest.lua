fx_version "cerulean"
lua54 "yes"
game "gta5"

author "Thomas"

ui_page "web/build/index.html"

files {
    "modules/*.lua",
	"web/build/index.html",
	"web/build/**/*",
	"stream/*.ytd",
	"stream/*.gfx",
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua'
}

client_script {
    "client/client.lua",
}

server_script {
    "server/server.lua",
}