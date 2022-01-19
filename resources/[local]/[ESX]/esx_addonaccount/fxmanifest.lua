fx_version "bodacious"
games {"gta5"}

description 'ESX Addon Account'
version '1.0.1'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/classes/addonaccount.lua',
	'server/main.lua'
}

dependency 'es_extended'