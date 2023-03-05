RegisterServerEvent('hoaaiww_bikeshopandrent:checkMoney', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()
	local price = Config.Bicycles[data.bike].buyPrice
	local paid = false

	if data.renting then price = (Config.Bicycles[data.bike].rentPrice * data.rentTime) end

	if playerMoney >= price then
		xPlayer.removeMoney(price)
		paid = true
	end

	if paid then
		if data.renting then
			TriggerClientEvent('hoaaiww_bikeshopandrent:rentBike', source, data.bike, data.color, data.rentTime)
		else
			TriggerClientEvent('hoaaiww_bikeshopandrent:buyBike', source, data.bike, data.color)
		end
	else
		local missingMoney = (Config.CurrencyPlacement ~= 'after' and Config.Currency or '') .. math.floor(price - playerMoney) .. (Config.CurrencyPlacement == 'after' and Config.Currency or '')
		xPlayer.showNotification(_U('no_money', (data.renting and _U('rent') or _U('buy')), missingMoney))
	end
end)

RegisterServerEvent('hoaaiww_bikeshopandrent:leaveBicycle', function(bike)
	TriggerClientEvent('hoaaiww_bikeshopandrent:leaveBicycle_c', -1, bike)
end)

RegisterServerEvent('hoaaiww_bikeshopandrent:storeBikeDatabase', function(bikeData)
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
			print('[^1ERROR^7] '.. (GetCurrentResourceName() .. ': Couldn\'t store %s bike in the database!'):format(xPlayer.identifier))
		end
	end)
end)

ESX.RegisterServerCallback('hoaaiww_bikeshopandrent:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', { ['@plate'] = plate }, function(result) 
		cb(result[1] ~= nil)
	end)
end)
