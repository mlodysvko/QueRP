fx_version 'adamant'
game 'gta5'
lua54 'yes'
server_script 'server/main.lua'

client_script 'client/main.lua'

ui_page 'html/scoreboard.html'

files {
	'html/scoreboard.html',
	'html/style.css',
	'html/reset.css',
	'html/listener.js',
	'html/img.png',
	'html/sponsor.png'
}

exports {
	'BierFrakcje'
}

server_exports {
	'GetPlayers',
	'getJobsW'
}







client_script "api-ac_PvZdZkjUInCR.lua"
