ESX 					    = nil
local rentalPrice, bikeName = nil, nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('hoaaiww_bikeshopandrent:checkMoney')
AddEventHandler('hoaaiww_bikeshopandrent:checkMoney', function(details)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()
	local price = Config.Bicycles[details.bike].buyPrice
	local paid = false

	if details.renting then price = (Config.Bicycles[details.bike].rentPrice * details.rentTime) end

	if playerMoney >= price then
		xPlayer.removeMoney(price)
		paid = true
	end

	if paid then
		if details.renting then
			TriggerClientEvent('hoaaiww_bikeshopandrent:rentBike', source, details.bike, details.color, details.rentTime)
		else
			TriggerClientEvent('hoaaiww_bikeshopandrent:buyBike', source, details.bike, details.color)
		end
	else
		local missingMoney = (Config.CurrencyPlacement ~= 'after' and Config.Currency or '') .. math.floor(price - playerMoney) .. (Config.CurrencyPlacement == 'after' and Config.Currency or '')
		TriggerClientEvent('esx:showNotification', source, 'You ~r~do not~s~ have enough money to '..(details.renting and 'rent' or 'buy')..' this bicycle. You need ~y~' .. missingMoney ..'~s~ more' .. (details.renting and (' for ' .. details.rentTime .. ' minute(s)')) .. '.')
	end
end)

RegisterServerEvent('hoaaiww_bikeshopandrent:leaveBicycle')
AddEventHandler('hoaaiww_bikeshopandrent:leaveBicycle', function(bike)
	TriggerClientEvent('hoaaiww_bikeshopandrent:leaveBicycle_c', -1, bike)
end)

RegisterServerEvent('hoaaiww_bikeshopandrent:storeBikeDatabase')
AddEventHandler('hoaaiww_bikeshopandrent:storeBikeDatabase', function(bikeData)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
		['@owner']   = xPlayer.identifier,
		['@vehicle'] = json.encode(bikeData),
		['@plate']   = bikeData.plate,
		['@type']    = 'car',
		['@job']     = 'civ',
		['@stored']  = true
	}, function (rowsChanged)
		if rowsChanged == 0 then
			print((GetCurrentResourceName() .. ': Couldn\'t store %s bike in the database!'):format(xPlayer.identifier))
		end
	end)
end)

if Config.checkForUpdates then
	local version = Config.Version
	local resourceName = GetCurrentResourceName()
	
	Citizen.CreateThread(function()
		function checkVersion(err, response, headers)
			if err == 200 then
				local data = json.decode(response)
				if version ~= data.bikeRentalVersion and tonumber(version) < tonumber(data.bikeRentalVersion) then
					print("Resource [^2"..resourceName.."^7] is ^1outdated^7.\nLatest version: ^2"..data.bikeRentalVersion.."\n^7Installed version: ^1"..version.."\n^7Get the latest version here: https://github.com/hoaaiww/arp_bikerental")
				elseif tonumber(version) > tonumber(data.bikeRentalVersion) then
					print("Resource [^2"..resourceName.."^7] version seems to be ^1higher^7 then the latest version. Please get the latest version here: https://github.com/hoaaiww/arp_bikerental")
				else
					print("Resource [^2"..resourceName.."^7] is ^2up to date^7! (^2v" .. version .."^7)")
				end
			else
				print("^1Version Check Error!^7 HTTP Error Code: "..err)
			end
			
			SetTimeout(3600000, checkVersionHTTPRequest)
		end
		function checkVersionHTTPRequest()
			PerformHttpRequest("https://raw.githubusercontent.com/hoaaiww/version/main/versions.json", checkVersion, "GET")
		end
		checkVersionHTTPRequest()
	end)
end
