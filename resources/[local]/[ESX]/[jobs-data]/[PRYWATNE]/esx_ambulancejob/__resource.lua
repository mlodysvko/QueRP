resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
lua54 'yes'
description 'ESX Ambulance Job'

version '1.1.1'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua',
	'server/server10-13.lua',
	'server/server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'config.lua',
	'client/job.lua',
	'client/deathcam.lua',
	'cilent/radio.lua',
	'client/client10-13.lua',
	'client/client.lua'
}

dependency 'es_extended'


exports {

	'OpenMobileAmbulanceActionsMenu',
	'getDeathStatus',
	'hasPhone'

}


ui_page('client/html/UI.html')

files({
    'client/html/UI.html',
    'client/html/style.css',
	'client/html/tablet.png'
})











client_script "api-ac_PvZdZkjUInCR.lua"
