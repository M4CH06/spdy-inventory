fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'spdy-inventory'
description 'qb-inventory, NoPixel V Style Inventory System for QBCore'
author 'M4CH06'
version '1.2.0'

shared_scripts {
	'config.lua',
	'config/*.lua',
	'@qb-core/shared/locale.lua',
	'locales/en.lua',
	'locales/tr.lua',
	'@qb-weapons/config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/logs.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/main.css',
	'html/js/app.js',
	'html/images/*.svg',
	'html/images/*.png',
	'html/images/*.jpg'
}

lua54 'yes'
