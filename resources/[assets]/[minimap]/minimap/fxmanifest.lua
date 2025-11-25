fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'abl - Advanced Minimap System'
author 'abdel4999'
version '1.0'
Discord 'https://discord.gg/vVUxCXjd46'
Tebex 'https://abdelemporium.tebex.io'
Youtube 'https://www.youtube.com/@AbdelEmporium/videos'

this_is_a_map 'yes'

client_scripts {
  'Files/CL.lua'
}

shared_scripts {
  'Shared/config.lua'
}

escrow_ignore {
  "Shared/*.lua"
  , "Files/*.lua"
}

dependency '/assetpacks'