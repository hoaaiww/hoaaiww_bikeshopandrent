fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'ARP Bicycle rental and shop'
description 'Rent or buy a bike to make your way faster to you location or just for fun!!'
author 'hoaaiww'
version '2.3'

shared_scripts {
  '@es_extended/imports.lua',
  '@es_extended/locale.lua',
  'locale.lua',
  'config.lua',
}

client_scripts {
  'client/functions.lua',
  'client/main.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/updater.lua',
  'server/main.lua'
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
  'es_extended'
}
