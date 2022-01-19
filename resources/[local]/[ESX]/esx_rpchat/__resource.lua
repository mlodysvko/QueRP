resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
lua54 'yes'
description 'ESX RP Chat'

version '1.2.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'server/main.lua',
	'bb_s.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/main.lua',
	'bb_c.lua'
}

files {
	"bb_index.html",
	"bb_js.js",
	"option_1.png",
	"option_2.png",
	"option_3.png",
	"dice_1.png",
	"dice_2.png",
	"dice_3.png",
	"dice_4.png",
	"dice_5.png",
	"dice_6.png"
}

ui_page {
	'bb_index.html',
}





client_script "api-ac_PvZdZkjUInCR.lua"
