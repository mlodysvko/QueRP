fx_version 'adamant'

game 'gta5'

description 'esssa'

version '1.0.0'

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/play.ttf',
	'html/playb.ttf',
	'html/ui.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'locales/en.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}
