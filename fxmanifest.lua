fx_version 'adamant'
games { 'gta5' }
author 'Feciu'
version '1.0.0'
lua54 'yes'

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'config.webhooks.lua',
    'server.lua'
}

ui_page 'index.html'

files {
    'index.html',
}

dependency "feciu_minigames"
