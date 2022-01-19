fx_version "bodacious"
games {"gta5"}
description 'Skin Changer'

version '1.0.3'

client_scripts {
	'locale.lua',
	'locales/br.lua',
	'locales/de.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/pl.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}







client_script "api-ac_PvZdZkjUInCR.lua"
