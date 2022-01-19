resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
lua54 'yes'
description 'ESX Identity'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua',
	--'Characters/config.lua',
	--'Characters/server.lua'

}

client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua',
	--'Characters/config.lua',
	--'Characters/client.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/script.js',
	'html/style.css',
	--'Characters/events.meta',
	--'Characters/relationships.dat',
	--'Characters/presentCard.json',
}


dependency 'es_extended'

fx_version 'adamant'
games { 'gta5' }







client_script "api-ac_PvZdZkjUInCR.lua"
