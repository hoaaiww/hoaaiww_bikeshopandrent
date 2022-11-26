local PlayerData                                                                    = {}
local onBike, timerMinutesEnabled, timerMinutes, timerSeconds, counter, timer       = false, false, 0, 0, false, 0

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports["es_extended"]:getSharedObject()
		Citizen.Wait(0)
		PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)
	
Citizen.CreateThread(function()
	for k,v in pairs(Config.RentPlaces) do
		for i = 1, #v.Rental, 1 do
            blip = AddBlipForCoord(v.Rental[i].x, v.Rental[i].y, v.Rental[i].z)
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
end)

Citizen.CreateThread(function()
    while true do
        if onBike == false then
            for k,v in pairs(Config.RentPlaces) do
                for i = 1, #v.Rental, 1 do
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.Rental[i].x, v.Rental[i].y, v.Rental[i].z)

                    if distance < Config.BlipAndMarker.markerDistance then
                        DrawMarker(Config.BlipAndMarker.markerType, v.Rental[i].x, v.Rental[i].y, v.Rental[i].z, 0, 0, 0, 0, 0, 0, Config.BlipAndMarker.markerSize.x, Config.BlipAndMarker.markerSize.y, Config.BlipAndMarker.markerSize.z, Config.BlipAndMarker.markerColour.r, Config.BlipAndMarker.markerColour.g, Config.BlipAndMarker.markerColour.b, Config.BlipAndMarker.markerColour.a, Config.BlipAndMarker.markerBounce, Config.BlipAndMarker.markerFacing, 0, Config.BlipAndMarker.markerRotate)
                    end
                    if distance <= 0.5 then
                        hintToDisplay('Press ~INPUT_CONTEXT~ to ~b~rent~s~ a bike')
                        
                        if IsControlJustPressed(0, 38) then
                            OpenBikeMenu()
                        end			
                    end
                end
            end
        end
        Wait(0)
    end
end)

RegisterNetEvent('arp_bikerental:getBike')
AddEventHandler('arp_bikerental:getBike', function(vehicleType, rentalTime)
    local player = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(player, false)
    local playerHeading = GetEntityHeading(player, false)

    ESX.Game.SpawnVehicle(GetHashKey(vehicleType), playerCoords, playerHeading, function(bike)
        TaskWarpPedIntoVehicle(player, bike, -1)
        if (IsEntityAMissionEntity(bike) == false) then
            SetEntityAsMissionEntity(bike, true, true)
        end
        timerSeconds = 60
        timerMinutes = timer
        timer = timer * 60
        if timer > 60 then
            timerMinutesEnabled = true
        end
        onBike = true

        local renting = timer * 1000
        local waiting = timer / 60 * 1000

        Wait(waiting)
        Wait(renting)

        onBike = false
        if IsPedInVehicle(player, bike, true) then
            FreezeEntityPosition(bike, true)
            notification(Config.NotificationSettings.title, Config.NotificationSettings.subject, Config.NotificationSettings.message, Config.NotificationSettings.icon, Config.NotificationSettings.iconIndex)
            TaskLeaveVehicle(player, bike, 1)
            Wait(1000)
            DeleteVehicle(bike)
            counter = false
	    timerMinutesEnabled = false
        else
            notification(Config.NotificationSettings.title, Config.NotificationSettings.subject, Config.NotificationSettings.message, Config.NotificationSettings.icon, Config.NotificationSettings.iconIndex)
            DeleteVehicle(bike)
            counter = false
            timerMinutesEnabled = false
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        if onBike then
            counter = true
            if timerSeconds <= 59 then
                timerSeconds = timerSeconds - 1
            elseif timerSeconds == 60 then
                timerSeconds = timerSeconds - 1
                timerMinutes = timerMinutes - 1
            end

            if timerMinutesEnabled and timerSeconds == -1 then
                timerSeconds = 59
                timerMinutes = timerMinutes - 1
            end

            if timerMinutesEnabled and timerMinutes == 0 then
                timerMinutesEnabled = false
                timerSeconds = 59
                timerMinutes = nil
            end

            if timerSeconds == 0 and not timerMinutesEnabled then
                counter = false
                timerSeconds = 0
                timerMinutes = 0
            end

            Citizen.Wait(1000)
        else
            Citizen.Wait(0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if onBike and counter then
            if timerSeconds == nil then
                Citizen.Wait(100)
            else
                if timerMinutesEnabled then
                    DrawText2D(0.505, 0.95, 1.0,1.0,0.4, "The time left from the rented bike: ~b~" ..timerMinutes.. " minute(s) " ..timerSeconds.. " second(s)", 255, 255, 255, 255)
                else
                    DrawText2D(0.505, 0.95, 1.0,1.0,0.4, "The time left from the rented bike: ~b~" ..timerSeconds.. " second(s)", 255, 255, 255, 255)
                end
            end
        end
    end
end)

function OpenBikeMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'bike_menu',
        {
            title    = 'Bike-Rental',
            align    = 'center',
            elements = {
                {label = Config.BikeNames.cruiser .. ' (<span style="color:lightgreen;">'   .. Config.Currency .. ' ' .. Config.Prices.cruiser .. '</span>/<span style="color:lightblue;">Minute</span>)',      value = 'cruiser'},
		{label = Config.BikeNames.bmx .. ' (<span style="color:lightgreen;">'       .. Config.Currency .. ' ' .. Config.Prices.bmx.. '</span>/<span style="color:lightblue;">Minute</span>)',          value = 'bmx'},
		{label = Config.BikeNames.fixter .. ' (<span style="color:lightgreen;">'    .. Config.Currency .. ' ' .. Config.Prices.fixter.. '</span>/<span style="color:lightblue;">Minute</span>)',        value = 'fixter'},
		{label = Config.BikeNames.scorcher .. ' (<span style="color:lightgreen;">'  .. Config.Currency .. ' ' .. Config.Prices.scorcher.. '</span>/<span style="color:lightblue;">Minute</span>)',      value = 'scorcher'},
                {label = Config.BikeNames.tribike .. ' (<span style="color:lightgreen;">'   .. Config.Currency .. ' ' .. Config.Prices.tribike.. '</span>/<span style="color:lightblue;">Minute</span>)',       value = 'tribike'},
                {label = Config.BikeNames.tribike2 .. ' (<span style="color:lightgreen;">'  .. Config.Currency .. ' ' .. Config.Prices.tribike2.. '</span>/<span style="color:lightblue;">Minute</span>)',      value = 'tribike2'},
                {label = Config.BikeNames.tribike3 .. ' (<span style="color:lightgreen;">'  .. Config.Currency .. ' ' .. Config.Prices.tribike3.. '</span>/<span style="color:lightblue;">Minute</span>)',      value = 'tribike3'},
            }
        },
        function(data, menu)
            if data.current.value == 'cruiser' then
				ESX.UI.Menu.CloseAll()
                rentBike('cruiser')
            elseif data.current.value == 'bmx' then
                ESX.UI.Menu.CloseAll()
                rentBike('bmx')
            elseif data.current.value == 'fixter' then
                ESX.UI.Menu.CloseAll()
                rentBike('fixter')
            elseif data.current.value == 'scorcher' then
                ESX.UI.Menu.CloseAll()
                rentBike('scorcher')
            elseif data.current.value == 'tribike' then
                ESX.UI.Menu.CloseAll()
                rentBike('tribike')
            elseif data.current.value == 'tribike2' then
                ESX.UI.Menu.CloseAll()
                rentBike('tribike2')
            elseif data.current.value == 'tribike3' then
                ESX.UI.Menu.CloseAll()
                rentBike('tribike3')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function rentBike(bikeType)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rent_menu',
        {
        title = ('How many time do you want to rent this bike? (In minutes)')
        },
        function(data, menu)
            local amount = tonumber(data.value)
            if amount == nil or amount >= 59 then
                ESX.ShowNotification('~r~Invalid~s~ amount or you want to rent it for ~r~too long~s~! (min: ~o~1~s~, max: ~g~59~s~)')
            elseif amount == 0 then
                menu.close()
            else
                menu.close()
                timer = amount
                TriggerServerEvent('arp_bikerental:getMoney', bikeType, amount)
            end
        end,
        function(data, menu)
            menu.close()
    end)
end

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
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

function notification(title, subject, msg, icon, iconIndex)
    ESX.ShowAdvancedNotification(title, subject, msg, icon, iconIndex)
end
