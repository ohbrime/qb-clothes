fx_version 'cerulean'
game 'gta5'

author 'Brime#0001'
description 'Edited version of Enzo-DC working with PolyZones'
version '1.0.0'

shared_scripts {
    'shared/sh_config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'game/build/client.js',
    'client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/static/js/*.js',
    'locales/*.json',
    'peds.json'
}

provide 'vyse-clothing'