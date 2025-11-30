fx_version "adamant"
game "gta5"
lua54 "yes"

ui_page 'html/index.html'

shared_script '@ox_lib/init.lua'
client_script 'cl_chat.lua'
server_script 'sv_chat.lua'

files {
    'html/index.html',
    'html/**/*.*'
}