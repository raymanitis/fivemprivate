fx_version 'cerulean'
game 'gta5'

author 'PEUREN DEVELOPMENT - peuren.tebex.io'
version '0.0.1'
lua54 'yes'

client_scripts { 'client/**/**' }
shared_scripts { 'shared/*.lua' }
server_scripts { 'server/**/**' }

files { 'locales/*.json', "web/build/**/*" }

dependency 'peuren_lib'

--ui_page "http://localhost:5173/"
ui_page "web/build/index.html"

escrow_ignore { 'shared/config.lua'}
--escrow_ignore { 'shared/config.lua', 'client/**', 'server/**' }

dependency '/assetpacks'