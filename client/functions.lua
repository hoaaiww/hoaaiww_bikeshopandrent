local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function openMenu(isShop) 
    if not listCreated then   -- On the fist UI open, create the list
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
        listCreated = true
    end

    if isShop then
        SendNUIMessage({ type = 'openShopMenu' })
    else
        SendNUIMessage({ type = 'openRentMenu' })
    end
    SetNuiFocus(true, true)
end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Wait(10)
		generatedPlate = string.upper(GetRandomLetter(3)..' '..GetRandomNumber(3))

		ESX.TriggerServerCallback('hoaaiww_bikeshopandrent:isPlateTaken', function (isPlateTaken)
			if (not isPlateTaken) then 
                doBreak = true 
            end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

function GetRandomNumber(length)
	Wait(10)
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Wait(10)
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

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

CreateThread(function()
    for k,v in pairs(Config.Bicycles) do AddTextEntry(k, v.name) end
end)

--Blips and NPCs
CreateThread(function()
    local settings = Config.BlipAndMarkers
    while (not HasModelLoaded(Config.NPC.model)) do RequestModel(Config.NPC.model) Wait(10) end

	for k,v in pairs(Config.RentPlaces) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)

        SetBlipSprite(blip, settings.Rental.blipId)
        SetBlipScale(blip, settings.Rental.blipSize)
        SetBlipColour(blip, settings.Rental.blipColour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(settings.Rental.blipName)
        EndTextCommandSetBlipName(blip)
	end

    -- Shop NPC --
    npcPed = CreatePed(4, Config.NPC.hash, Config.BicycleShop.coords.x, Config.BicycleShop.coords.y, Config.BicycleShop.coords.z - 1, Config.BicycleShop.coords.h, false, true)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)

    -- Shop blip --
    local blip = AddBlipForCoord(Config.BicycleShop.coords.x, Config.BicycleShop.coords.y, Config.BicycleShop.coords.z)

    SetBlipSprite(blip, settings.Shop.blipId)
    SetBlipScale(blip, settings.Shop.blipSize)
    SetBlipColour(blip, settings.Shop.blipColour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(settings.Shop.blipName)
    EndTextCommandSetBlipName(blip)
end)
