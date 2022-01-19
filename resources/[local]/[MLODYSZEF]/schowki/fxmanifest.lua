fx_version 'adamant'

game 'gta5'

description 'woro_schowek'

client_scripts {
    'config.lua',
    'client/main.lua'
}
server_script {
    'server/main.lua',
    '@mysql-async/lib/MySQL.lua',
}
