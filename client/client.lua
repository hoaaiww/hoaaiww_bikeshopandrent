ESX = nil
local rentedBike = false
local timer = {
    countDown = 0,
    hours     = 0,
    minutes   = 0,
    seconds   = 0
}
colorCodes = {
    black  = { r = 0,   g = 0,   b = 0   },
    white  = { r = 255, g = 255, b = 255 },
    red    = { r = 255, g = 0,   b = 0   },
    blue   = { r = 0,   g = 0,   b = 255 },
    green  = { r = 0,   g = 255, b = 0   },
    yellow = { r = 255, g = 255, b = 0   }
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
        Wait(0)
	end

    for k,v in pairs(Config.Bicycles) do
        SendNUIMessage({ 
            type = 'setList',
            currency  = Config.Currency,
            CP        = Config.CurrencyPlacement,
            bikeId    = k,
            bikeName  = v.name,
            rentPrice = v.rentPrice,
            buyPrice  = v.buyPrice,
            bikePrice = v.buyPrice
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)

        if not rentedBike then
            for k,v in pairs(Config.RentPlaces) do
                for i = 1, #v.Rental, 1 do
                    local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.Rental[i].x, v.Rental[i].y, v.Rental[i].z)

                    if distance < Config.BlipAndMarker.markerDistance then
                        DrawMarker(Config.BlipAndMarker.markerType, v.Rental[i].x, v.Rental[i].y, v.Rental[i].z, 0, 0, 0, 0, 0, 0, Config.BlipAndMarker.markerSize.x, Config.BlipAndMarker.markerSize.y, Config.BlipAndMarker.markerSize.z, Config.BlipAndMarker.markerColour.r, Config.BlipAndMarker.markerColour.g, Config.BlipAndMarker.markerColour.b, Config.BlipAndMarker.markerColour.a, Config.BlipAndMarker.markerBounce, Config.BlipAndMarker.markerFacing, 0, Config.BlipAndMarker.markerRotate)
                        
                        if distance < 1.0 then
                            ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to ~b~rent~s~ a ~y~Bicycle~s~')
                            
                            if IsControlJustPressed(0, 38) then
                                SetNuiFocus(true, true)
                                SendNUIMessage({ type = 'openRentMenu' })
                            end			
                        end
                    end
                end
            end
        end

        local shopDistance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.BicycleShop.x, Config.BicycleShop.y, Config.BicycleShop.z)

        if shopDistance < 1.5 then
            ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to ~b~visit~s~ the ~y~Bicycle Shop~s~')
            
            if IsControlJustPressed(0, 38) then
                SetNuiFocus(true, true)
                SendNUIMessage({ type = 'openShopMenu' })
            end			
        end
        Wait(0)
    end
end)

RegisterNetEvent('hoaaiww_bikeshopandrent:rentBike')
AddEventHandler('hoaaiww_bikeshopandrent:rentBike', function(bicycleType, color, rentTime)
    SendNUIMessage({ type = 'closeUI' })
    local player = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(player, false)
    local playerHeading = GetEntityHeading(player, false)

    ESX.Game.SpawnVehicle(GetHashKey(bicycleType), playerCoords, playerHeading, function(bike)
        if color ~= '' then SetVehicleCustomPrimaryColour(bike, colorCodes[color].r, colorCodes[color].g, colorCodes[color].b) end
        TaskWarpPedIntoVehicle(player, bike, -1)
        SetEntityAsMissionEntity(bike, true, true)

        timer.countDown = math.floor(rentTime * 60)
        timer.hours     = math.floor(rentTime / 60)
        timer.minutes   = math.floor(rentTime - (timer.hours * 60))
        timer.seconds   = 60

        rentedBike = true
        PlaySoundFrontend(-1, 'LOCAL_PLYR_CASH_COUNTER_COMPLETE', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS')

        Citizen.CreateThread(function()
            while rentedBike do
                if timer.countDown == 0 then
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

RegisterNetEvent('hoaaiww_bikeshopandrent:leaveBicycle_c')
AddEventHandler('hoaaiww_bikeshopandrent:leaveBicycle_c', function(bike)
    local ped = GetPlayerPed(-1)
    if IsPedInVehicle(ped, bike, true) then
        TaskLeaveVehicle(ped, bike, 1)    
    end
end)

RegisterNetEvent('hoaaiww_bikeshopandrent:buyBike')
AddEventHandler('hoaaiww_bikeshopandrent:buyBike', function(bicycleType, color)
    SendNUIMessage({ type = 'closeUI' })

    local player = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(player, false)
    local playerHeading = GetEntityHeading(player, false)
    local newPlate = exports['autoshop']:GeneratePlate()

    ESX.Game.SpawnVehicle(GetHashKey(bicycleType), playerCoords, playerHeading, function(bike)
        if color ~= '' then SetVehicleCustomPrimaryColour(bike, colorCodes[color].r, colorCodes[color].g, colorCodes[color].b) end
        local props    = ESX.Game.GetVehicleProperties(bike)
        props.plate    = newPlate
        SetVehicleNumberPlateText(bike, newPlate)
        TaskWarpPedIntoVehicle(player, bike, -1)

        TriggerServerEvent('hoaaiww_bikeshopandrent:storeBikeDatabase', props)
        Wait(2000)
        SendAdvancedMessage(Config.NotificationSettings.messages.bikeBought.subject, Config.NotificationSettings.messages.bikeBought.msg)
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if rentedBike then

            if (timer.minutes == 0) and (timer.hours >= 1) then
                timer.hours = timer.hours - 1
                timer.minutes = 60
            end

            if (timer.seconds == 0 or timer.seconds == 60) and (timer.minutes >= 1 or timer.hours >= 1) then
                timer.minutes = timer.minutes - 1
                timer.seconds = 60    
            end
            timer.seconds = timer.seconds - 1

            Wait(1000)
            timer.countDown = timer.countDown - 1

            if timer.countDown == 10 then
                PlaySoundFrontend(-1, '10s', 'MP_MISSION_COUNTDOWN_SOUNDSET')
            end
        else
            Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if rentedBike then
            DrawText2D(0.825, 1.455, 1.0,1.0,0.4, "The time left from the rented bike: ~b~" .. 
            ((timer.hours > 1 and timer.hours .. ' hours ') or (timer.hours == 1 and timer.hours .. ' hour ') or '') .. 
            ((((timer.minutes == 0 and timer.hours >= 1) or (timer.minutes == 1)) and timer.minutes .. ' minute ') or (timer.minutes > 1 and timer.minutes .. ' minutes ') or '') ..
            ( (((timer.seconds == 0 and timer.minutes >= 1) or (timer.seconds == 0 and timer.hours >= 1) or (timer.seconds == 1)) and timer.seconds .. ' second') or (timer.seconds > 1 and timer.seconds .. ' seconds') or 'Ended')
            , 255, 255, 255, 255)
        else
            Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Bicycles) do
        AddTextEntry(k, v.name) -- Sets the bike's name ingame (like in garages, ect..)
    end
end)

function SendAdvancedMessage(subject, msg)
    PlaySoundFrontend(-1, 'Menu_Accept', 'Phone_SoundSet_Default')
    ESX.ShowAdvancedNotification(Config.NotificationSettings.sender, subject, msg, Config.NotificationSettings.icon, Config.NotificationSettings.iconIndex)
end

function DrawText2D(x, y, width, height, scale, text, r, g, b, a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

--Blips and NPCs
Citizen.CreateThread(function()
    while not HasModelLoaded(Config.NPC.model) do RequestModel(Config.NPC.model) Wait(10) end

	for k,v in pairs(Config.RentPlaces) do
		for i = 1, #v.Rental, 1 do
            local blip = AddBlipForCoord(v.Rental[i].x, v.Rental[i].y, v.Rental[i].z)
            SetBlipSprite(blip, Config.BlipAndMarker.blipId)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.BlipAndMarker.blipSize)
            SetBlipColour(blip, Config.BlipAndMarker.blipColour)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.BlipAndMarker.blipName)
            EndTextCommandSetBlipName(blip)
        end
	end

    --shop
    npcPed = CreatePed(4, Config.NPC.hash, Config.BicycleShop.x, Config.BicycleShop.y, Config.BicycleShop.z - 1, Config.BicycleShop.h, true, true)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)

    local blip = AddBlipForCoord(Config.BicycleShop.x, Config.BicycleShop.y, Config.BicycleShop.z)
    SetBlipSprite(blip, Config.BlipAndMarker.shopblipId)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, Config.BlipAndMarker.shopblipSize)
    SetBlipColour(blip, Config.BlipAndMarker.shopblipColour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipAndMarker.shopblipName)
    EndTextCommandSetBlipName(blip)
end)

RegisterNUICallback('closeUI', function(data, cb) 
    SetNuiFocus(false, false) 
end)

RegisterNUICallback('ManageBike', function(data, cb) 
    TriggerServerEvent('hoaaiww_bikeshopandrent:checkMoney', data)
end)
