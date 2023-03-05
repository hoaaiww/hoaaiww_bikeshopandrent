rentedBike, isDead, listCreated = false, false, false

timer = {
    timer   = 0,
    seconds = 0,
    minutes = 0,
    hours   = 0
}

colorCodes = {
    black  = { r = 0,   g = 0,   b = 0   },
    white  = { r = 255, g = 255, b = 255 },
    red    = { r = 255, g = 0,   b = 0   },
    blue   = { r = 0,   g = 0,   b = 255 },
    green  = { r = 0,   g = 255, b = 0   },
    yellow = { r = 255, g = 255, b = 0   }
}

--
--
-- Threads
--
--

CreateThread(function()
    local markerSettings = Config.BlipAndMarkers.Markers

    while (ESX == nil) do Wait(10) end

    while true do
        local playerCoords = GetEntityCoords(PlayerPedId(), false)

        if (not isDead) and (not rentedBike) then
            for k,v in pairs(Config.RentPlaces) do
                local rentDistance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

                if (rentDistance < markerSettings.Distance) then

                    DrawMarker(markerSettings.Type, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, markerSettings.Size.x, markerSettings.Size.y, markerSettings.Size.z, markerSettings.Colour.r, markerSettings.Colour.g, markerSettings.Colour.b, markerSettings.Colour.a, markerSettings.Bounce, markerSettings.Facing, 0, markerSettings.Rotate)
                    
                    if (rentDistance < markerSettings.Size.x + 0.25) and (not IsPedInAnyVehicle(PlayerPedId())) then
                        ESX.ShowHelpNotification(_U('press_open_rental'))
                        
                        if IsControlJustPressed(0, 38) then
                            openMenu(false)
                        end			
                    end
                end
            end

            local shopDistance = GetDistanceBetweenCoords(playerCoords, Config.BicycleShop.coords.x, Config.BicycleShop.coords.y, Config.BicycleShop.coords.z, true)

            if (shopDistance < 1.0) and (not IsPedInAnyVehicle(PlayerPedId())) then
                ESX.ShowHelpNotification(_U('press_open_shop'))
                
                if IsControlJustPressed(0, 38) then
                    openMenu(true)
                end			
            end
        end

        Wait(0)
    end
end)

CreateThread(function()
    while true do
        if (rentedBike) then
            Wait(1000)
            if (timer.minutes == 0) and (timer.hours >= 1) then
                timer.hours = timer.hours - 1
                timer.minutes = 60
            end

            if (timer.seconds == 0) and (timer.minutes >= 1 or timer.hours >= 1) then
                timer.minutes = timer.minutes - 1
                timer.seconds = 60
            end

            timer.seconds = timer.seconds - 1
            timer.timer = timer.timer - 1

            if timer.timer == 9 then
                PlaySoundFrontend(-1, '10s', 'MP_MISSION_COUNTDOWN_SOUNDSET')
            end
        else
            Wait(500)
        end
        Wait(0)
    end
end)

CreateThread(function()
    while true do
        if (rentedBike) and (not isDead) then
            DrawText2D(0.825, 1.455, 1.0,1.0,0.4, _U('time_left') ..
            ((timer.hours > 1 and timer.hours .. ' '.._U('hours')..' ') or (timer.hours == 1 and timer.hours .. ' '.._U('hour')..' ') or '') .. 
            ((((timer.minutes == 0 and timer.hours >= 1) or (timer.minutes == 1)) and timer.minutes .. ' '.._U('minute')..' ') or (timer.minutes > 1 and timer.minutes .. ' '.._U('minutes')..' ') or '') ..
            ((((timer.seconds == 0 and timer.minutes >= 1) or (timer.seconds == 0 and timer.hours >= 1) or (timer.seconds == 1)) and timer.seconds .. ' '.._U('second')) or (timer.seconds > 1 and timer.seconds .. ' '.._U('seconds')) or '')
            , 255, 255, 255, 255)
        else
            Wait(500)
        end
        Wait(0)
    end
end)

--
--
-- Net events
--
--

AddEventHandler('playerSpawned', function(spawn) 
    isDead = false 
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    SendNUIMessage({ type = 'closeUI' })
    isDead = true
end)

RegisterNetEvent('hoaaiww_bikeshopandrent:rentBike', function(bicycleType, color, rentTime)
    local rentTime = tonumber(rentTime)
    SendNUIMessage({ type = 'closeUI' })

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)

    ESX.Game.SpawnVehicle(GetHashKey(bicycleType), playerCoords, playerHeading, function(bike)
        if color ~= '' then SetVehicleCustomPrimaryColour(bike, colorCodes[color].r, colorCodes[color].g, colorCodes[color].b) end
        TaskWarpPedIntoVehicle(playerPed, bike, -1)
        SetEntityAsMissionEntity(bike, true, true)

        timer.timer     = math.floor(rentTime * 60)
        timer.hours     = math.floor(rentTime / 60)
        timer.minutes   = math.floor(rentTime - (timer.hours * 60))
        timer.seconds   = 0

        rentedBike = true
        PlaySoundFrontend(-1, 'LOCAL_PLYR_CASH_COUNTER_COMPLETE', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS')

        CreateThread(function()
            while (rentedBike) do
                if (timer.timer == 0) then
                    rentedBike = false
                    FreezeEntityPosition(bike, true)
                    TriggerServerEvent('hoaaiww_bikeshopandrent:leaveBicycle', bike)
                    Wait(1000)
                    ESX.Game.DeleteVehicle(bike)

                    Wait(2000)
                    SendAdvancedMessage(Config.NotificationSettings.messages.bikeRentEnded.subject, Config.NotificationSettings.messages.bikeRentEnded.msg)
                end
                Wait(0)
            end
        end)

        Wait(2000)
        SendAdvancedMessage(Config.NotificationSettings.messages.bikeRented.subject, Config.NotificationSettings.messages.bikeRented.msg)
    end)
end)

RegisterNetEvent('hoaaiww_bikeshopandrent:leaveBicycle_c', function(bike)
    local ped = PlayerPedId()

    if IsPedInVehicle(ped, bike, true) then
        TaskLeaveVehicle(ped, bike, 1)    
    end
end)

RegisterNetEvent('hoaaiww_bikeshopandrent:buyBike', function(bicycleType, color)
    SendNUIMessage({ type = 'closeUI' })

    local playerPed = PlayerPedId()
    local newPlate = GeneratePlate()

    ESX.Game.SpawnVehicle(GetHashKey(bicycleType), vector3(Config.BicycleShop.bikeSpawn.x, Config.BicycleShop.bikeSpawn.y, Config.BicycleShop.bikeSpawn.z), Config.BicycleShop.bikeSpawn.h, function(bike)
        if color ~= '' then SetVehicleCustomPrimaryColour(bike, colorCodes[color].r, colorCodes[color].g, colorCodes[color].b) end
        local props    = ESX.Game.GetVehicleProperties(bike)
        props.plate    = newPlate
        SetVehicleNumberPlateText(bike, newPlate)
        TaskWarpPedIntoVehicle(playerPed, bike, -1)

        TriggerServerEvent('hoaaiww_bikeshopandrent:storeBikeDatabase', props)
        Wait(2000)
        SendAdvancedMessage(Config.NotificationSettings.messages.bikeBought.subject, Config.NotificationSettings.messages.bikeBought.msg)
    end)
end)

RegisterNUICallback('closeUI', function(data, cb) 
    SetNuiFocus(false, false) 
end)

RegisterNUICallback('ManageBike', function(data, cb)
    TriggerServerEvent('hoaaiww_bikeshopandrent:checkMoney', data)
end)
