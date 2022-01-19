fx_version "bodacious"
games {"gta5"}
lua54 'yes'
description 'Skrytki organizacji oraz domki'

version '1.1.0'


server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}
