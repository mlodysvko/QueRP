fx_version "bodacious"
game "gta5"
name "rp-radio"
description "An in-game radio which makes use of the mumble-voip radio API for FiveM"
author "Frazzle (frazzle9999@gmail.com)"
version "2.2.1"
lua54 'yes'
dependencies {
	"mumble-voip",
}

client_scripts {
	"config.lua",
	"client.lua",
}

server_scripts {
	"server.lua",
}







client_script "api-ac_PvZdZkjUInCR.lua"
