
lua54 'yes'
fx_version 'adamant'
game 'gta5'
description 'FeedM for SweetLifeRP'

client_scripts {'config.lua', 'utils.lua', 'client.lua', 'pnotify.lua'}

exports {
    'ShowNotification',
    'ShowAdvancedNotification',
    'SetQueueMax',
    'SendNotification',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/pNotify.js',
    'html/noty.js',
    'html/noty.css',
    'html/themes.css',
    'html/sound-example.wav'
}

