Config = {} -- Do not touch this!

Config.RentPlaces = {
    Places = {
        Rental = { -- The positions of where can players rent bike. "h" is the npc's heading.
            { x = 221.25,    y = -857.07,  z = 30.20, h = 0.0 }, -- Main Public Garage
            { x = -520.96,   y = -261.95,  z = 35.50, h = 206.43 }, -- Municipality House
            { x = 301.13,    y = -1393.93, z = 31.22, h = 0.0 }, -- Los Santos Central Hospital
            { x = 1854.07,   y = 3752.85,  z = 33.12, h = 149.38 }, -- Sandy Shores
            { x = -93.23,    y = 6325.83,  z = 31.49, h = 268.18 }, -- Paleto Bay
            { x = -2561.73,  y = 2317.22,  z = 33.21, h = 0.0}, -- At the west mid-highway
            { x = -1261.66,  y = -1439.61, z = 4.35,  h = 99.73}, -- Near the beach
            { x = -1050.69,  y = -2723.78, z = 13.75, h = 0.0 } -- Airport
        }
    }
}

Config.NPC = { -- The NPC at the bicycle shop.
    model = 's_m_m_autoshop_01', -- NPC's model name. | For more: https://wiki.rage.mp/index.php?title=Peds
    hash = 0x040EABE3 -- NPC's hash. It is under the model name. 
}

Config.BicycleShop = { x = -1223.08, y = -1495.86, z = 4.35, h = 96.25 } -- "h" is for the npc's heading.

Config.Currency = '$' -- You can set the currency whatever you want. Ect.: $, € or £
Config.CurrencyPlacement = 'before' -- currency placement 'before' or 'after' the prices (ex.: before: $10 or after: 10$)

Config.Bicycles = { -- bicycles' name rent price/minute and the price in case if you want to buy one at the bike shop 
    cruiser = {
        name      = 'Average Bicycle',
        rentPrice = 3,
        buyPrice  = 300
    },
    bmx = {
        name      = 'BMX Bicycle',
        rentPrice = 4,
        buyPrice  = 400
    },
    fixter = {
        name      = 'Fast City Bicycle',
        rentPrice = 5,
        buyPrice  = 500
    },
    scorcher = {
        name      = 'Off-Road Bicycle',
        rentPrice = 7,
        buyPrice  = 700
    },
    tribike = {
        name      = 'Whippet Race Bicycle',
        rentPrice = 10,
        buyPrice  = 1000
    },
    tribike2 = {
        name      = 'Endurex Race Bicycle',
        rentPrice = 10,
        buyPrice  = 1000
    },
    tribike3 = {
        name      = 'Tri-Cycles Race Bicycle',
        rentPrice = 10,
        buyPrice  = 1000
    },
}

Config.NotificationSettings = {
    sender       = 'Bicycle Rent&Shop Inc.',  -- The Title of the Message
    icon        = 'CHAR_BIKESITE', -- The Message Icon.    You can find thiese default icons here: https://wiki.gtanet.work/index.php?title=Notification_Pictures
    iconIndex   = 2,  -- Icon next to the title.             You can find more here: https://esx-brasil.github.io/es_extended/client/functions/showadvancednotification/#icon-types
    messages = {
        bikeRented = { -- Message when a player rents a bicycle
            subject = 'Bicycle Rented',
            msg     = 'Dear Customer! You have rented a bicycle from one of our renting places. We hope our bicycle\'s performace will impress you!'
        },
        bikeRentEnded = {
            subject = 'Bicycle Rent Ended',
            msg     = 'Dear Customer! We hope you were satisfied with the quality of our bicycle but unfortunately your retal period has expired. We hope you will come back! Have good a day!'
        },
        bikeBought = {
            subject = 'Bicycle Purchased',
            msg     = 'Dear Customer! We are glad you have choosen our Bicycle Shop to purchase a high quality bicycle! We hope you will enjoy your bicylce! Have a good day!'
        }
    }
}

Config.BlipAndMarker = {
    blipName    = 'City Bicycle Rental',
    blipColour  = 66,  -- The blip color. - You can find more here: https://docs.fivem.net/docs/game-references/blips/#blip-colors
    blipId      = 226,  -- The blip icon. - You can find more here: https://docs.fivem.net/docs/game-references/blips/
    blipSize    = 1.0,  -- The blip size.

    -- Rent Markers
    markerDistance  = 20, -- The distance where inside the value (in meters) players can see the marker
    markerType      = 21, -- The marker type. - You can find more here: https://docs.fivem.net/docs/game-references/markers/
    markerSize      = { x = 0.4, y = 0.4, z = 0.4}, -- The size of the marker
    markerColour    = { r = 240, g = 203, b = 87, a = 150}, -- The color of the marker
    markerBounce   = false, -- Make the marker bouncing
    markerRotate    = true, -- Make the marker rotating 360°
    markerFacing    = false, -- Make the marker always face to you (It works only if the markerRotate is false

    -- bike shop blip details
    shopblipName    = 'City Bicycle Shop',
    shopblipColour  = 47,
    shopblipId      = 226,
    shopblipSize    = 1.2,
}

Config.checkForUpdates  = true -- Check for updates? /!\ Recommended
Config.Version          = '2.1' -- Dont edit!
