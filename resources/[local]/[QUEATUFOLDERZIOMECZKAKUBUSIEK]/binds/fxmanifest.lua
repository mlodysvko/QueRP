fx_version "bodacious"
games {"gta5"}

author 'szymczakovv#1937 & definitely not PK!?#1337'
description 'ESX Inventory Binds'
version '1.0.0'

client_scripts {
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/main.js',
  'html/img/*.png',
}

dependency 'es_extended'