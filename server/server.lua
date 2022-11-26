local rentalPrice, bikeName 		= nil, nil
local resourceVersion			= Config.Version

ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('arp_bikerental:getMoney')
AddEventHandler('arp_bikerental:getMoney', function(vehicleType, rentalTime)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local playerMoney = xPlayer.getAccount(Config.TypeMoney)
	local paid = false

	if vehicleType == 'cruiser' then
		rentalPrice = Config.Prices.cruiser
		bikeName = Config.BikeNames.cruiser
	elseif vehicleType == 'bmx' then
		rentalPrice = Config.Prices.bmx
		bikeName = Config.BikeNames.bmx
	elseif vehicleType == 'fixter' then
		rentalPrice = Config.Prices.fixter
		bikeName = Config.BikeNames.fixter
	elseif vehicleType == 'scorcher' then
		rentalPrice = Config.Prices.scorcher
		bikeName = Config.BikeNames.scorcher
	elseif vehicleType == 'tribike' then
		rentalPrice = Config.Prices.tribike
		bikeName = Config.BikeNames.tribike
	elseif vehicleType == 'tribike2' then
		rentalPrice = Config.Prices.tribike2
		bikeName = Config.BikeNames.tribike2
	elseif vehicleType == 'tribike3' then
		rentalPrice = Config.Prices.tribike3
		bikeName = Config.BikeNames.tribike3
	end

	if playerMoney >= rentalPrice * rentalTime then
		xPlayer.removeAccountMoney(Config.TypeMoney, (rentalPrice * rentalTime))
		paid = true
		notification('You ~g~Successfully~s~ rented a(n) ~b~' .. bikeName .. ' for~y~ '..rentalTime..' minute(s) ~s~for: ~g~' .. Config.Currency .. ' ' .. rentalPrice * rentalTime) 
	else
		notification('You ~r~do not~s~ have enough money! ~g~' .. Config.Currency .. ' ~y~' .. rentalPrice * rentalTime - playerMoney .. '~s~ ~r~is missing!~s~')
	end

	if paid then
		TriggerClientEvent('arp_bikerental:getBike', source, vehicleType, rentalTime)
	end
end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end

if Config.checkForUpdates then
	local version = resourceVersion
	local resourceName = GetCurrentResourceName()
	
	Citizen.CreateThread(function()
		function checkVersion(err, response, headers)
			if err == 200 then
				local data = json.decode(response)
				if version ~= data.bikeRentalVersion and tonumber(version) < tonumber(data.bikeRentalVersion) then
					print("The [^2"..resourceName.."^7] resource is ^1outdated^7.\nLatest version: ^2"..data.bikeRentalVersion.."\n^7Installed version: ^1"..version.."\n^7Get the latest version here: https://github.com/hoaaiww/arp_bikerental")
				elseif tonumber(version) > tonumber(data.bikeRentalVersion) then
					print("The [^2"..resourceName.."^7] resource version seems to be ^1higher^7 then the latest version. Please get the latest version here: https://github.com/hoaaiww/arp_bikerental")
				else
					print("The [^2"..resourceName.."^7] resource is ^2up to date^7! (^2v" .. version .."^7)")
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
