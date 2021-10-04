Config = {}
Config.RentPlaces = {
    Places = {
        Rental = { -- The positions of where can players rent bike
            {x = 221.25 , y = -857.07 , z = 30.20}, -- Main Public Garage
            {x = -520.96 , y = -261.95 , z = 35.50}, -- Municipality House
            {x = 301.13 , y = -1393.93 , z = 31.22}, -- Hospital
            {x = 1854.07 , y = 3752.85 , z = 33.12}, -- Sandy Shores
            {x = -93.23 , y = 6325.83 , z = 31.49}, -- Paleto Bay
            {x = -2561.73 , y = 2317.22 , z = 33.21}, -- At the west mid-highway
            {x = -1262.88 , y = -1440.08 , z = 4.35}, -- Near the beach
            {x = -1050.69 , y = -2723.78 , z = 13.75} -- Airport
        }
    },
}

Config.Prices = { -- The bicycles' price/minute
    cruiser     = 3,
    bmx         = 5,
    fixter      = 5,
    scorcher    = 6,
    tribike     = 7,
    tribike2    = 10,
    tribike3    = 10
}

Config.Currency = '$' -- You can set the currency whatever you want. Ect.: $, € or £

Config.BikeNames = { -- The bicycles' name      - /!\ You can't add here more "vehicle"
    cruiser     = 'Average Bicycle',
    bmx         = 'BMX Bicycle',
    fixter      = 'City Bicycle',
    scorcher    = 'Off-Road Bicycle',
    tribike     = 'Sport Bicycle (Yellow)',
    tribike2    = 'Sport Bicycle (Red)',
    tribike3    = 'Sport Bicycle (Blue)'
}

Config.NotificationSettings = {
    title       = 'City Bike-Rental',  -- The Title of the Message
    subject     = 'Bike Rental Message',  -- The Subject of the Message
    message     = 'Thank you for using our services! The bike that you rented has collected by our employees! Have a good day!', -- Main Message
    icon        = 'CHAR_BIKESITE', -- The Message Icon.    You can find thiese default icons here: https://wiki.gtanet.work/index.php?title=Notification_Pictures
    iconIndex   = 2  -- Icon next to the title.             You can find more here: https://esx-framework.github.io/es_extended/client/functions/showadvancednotification/#icon-types
}

Config.BlipAndMarker = {

    --  Blip 
    blipName    = 'City Bike-Rental',
    blipColour  = 66,  -- The blip color. - You can find more here: https://docs.fivem.net/docs/game-references/blips/#blip-colors
    blipId      = 226,  -- The blip icon. - You can find more here: https://docs.fivem.net/docs/game-references/blips/
    blipSize    = 1.0,  -- The blip size.

    -- Marker
    markerDistance  = 20, -- The distance where inside the value (in meters) players can see the marker
    markerType      = 21, -- The marker type. - You can find more here: https://docs.fivem.net/docs/game-references/markers/
    markerSize      = { x = 0.4, y = 0.4, z = 0.4}, -- The size of the marker
    markerColour    = { r = 240, g = 203, b = 87, a = 150}, -- The color of the marker
    markerBounce   = false, -- Make the marker bouncing
    markerRotate    = true, -- Make the marker rotating 360°
    markerFacing    = false, -- Make the marker always face to you (It works only if the markerRotate is false)
}

Config.checkForUpdates  = true -- Check for updates? /!\ Recommended
