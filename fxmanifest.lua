fx_version 'cerulean'
game 'gta5'

name 'ARP Bicycle rental and shop'
description 'Rent or buy a bike to make your way faster to you location or just for fun!!'
author 'hoaaiww'
version '2.2'

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'config.lua',
  'server/server.lua'
}

client_scripts {
  'config.lua',
  'client/client.lua'
}

files {
  'html/css.css',
  'html/js.js',
  'html/imgs/*.png',
  'html/ui.html'
}

ui_page 'html/ui.html'

dependencies {
  'oxmysql',
  'es_extended',
  'esx_vehicleshop'
}
