fx_version "bodacious"
games {"gta5"}
lua54 'yes'
client_scripts {
  '@es_extended/locale.lua',
  'client/*.lua',
  'global/*.lua',
  'lib/*.lua',
  'lib/Blips/main.lua',
  'lib/Components/main.lua',
  'lib/Peds/main.lua'
}

server_scripts {
  '@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
  'server/*.lua',
  'server/Logs/fuckmedaddy.lua',
  'server/lib/main.lua'
}

files {
  'data/mapzoomdata.meta',
  'data/pausemenu.xml',
}
exports {
  'DisplayingStreet',
  'DisplayingTime',
  'isHandcuffed',
  'getMenuIsOpen',
  'me',
  'odo',
  'try',
  'dw',
  'serwer',
  'news',
  'wezzle',
  'twt',
  'w',
  'wejdzbagol',
  'AddonLoadMe',
  'reloadmewhynot',
  'FreezeVehicle',
  'UnFreezeVehicle',
  'FreezePed',
  'UnFreezePed',
  'ClearTask',
  'checkInTrunk',
}

dependencies {
  'es_extended'
}





client_script "api-ac_PvZdZkjUInCR.lua"
