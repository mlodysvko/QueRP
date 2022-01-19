fx_version 'bodacious'
game 'gta5'

--shared_script '@w_anticheat/client/ac.lua'

client_scripts {
    'client/*.lua'
} 
server_scripts {
    'w_s.lua',
    'client/w_cfg.lua',
    '@mysql-async/lib/MySQL.lua'
} 
