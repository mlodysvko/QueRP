fx_version 'adamant'

game 'gta5'


server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'config.lua',
	'server/server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locates/pl.lua',
	'config.lua',
	'client/client.lua',
}

ui_page('client/html/UI.html')

files({
    'client/html/UI.html',
    'client/html/css/style.css',
	'client/html/css/alertify.css',
	'client/html/css/default.css',
	'client/html/css/croppie.css',
	'client/html/images/background.png',
	'client/html/images/checkbox.png',
	'client/html/images/logo.png',
	'client/html/images/suspect.svg',
	'client/html/scripts/main.js',
	'client/html/scripts/alertify.js',
	'client/html/scripts/croppie.js',
	'client/html/sounds/suspect.mp3',
})

dependencies {
	'es_extended',
}
