currentVersion = tonumber(GetResourceMetadata(GetCurrentResourceName(), 'version'))
resourceName = GetCurrentResourceName()

if (resourceName ~= 'hoaaiww_bikeshopandrent') then 
    resourceName = 'hoaaiww_bikeshopandrent' .. ' ^5('..resourceName..')^2' 
end

if Config.CheckForUpdates then
	CreateThread(function()
		function checkVersion(err, response, headers)
			if err == 200 then
				local data = json.decode(response)
                local newestVersion = tonumber(data.bikeRentalVersion)

                if (currentVersion ~= newestVersion) and (currentVersion < newestVersion) then
                    print(''..
                        '^7--------------------------------'..
                        '\n[^3PROBLEM^7] Resource [^2'..resourceName..'^7] is ^3outdated^7.'..
                        '\nLatest version: ^2'..newestVersion..
                        '\n^7Installed version: ^3'..currentVersion..
                        '\n^7Get the latest version here: ^5https://github.com/hoaaiww/hoaaiww_bikeshopandrent/releases'..
                        '\n^7--------------------------------'
                    )
                elseif (currentVersion > newestVersion) then
                    print(''..
                        '^7--------------------------------'..
                        '\n^7[^3PROBLEM^7] Resource [^2'..resourceName..'^7] version seems to be ^3higher^7 than the latest version.'..
                        '\n^7Latest version: ^2'..newestVersion..
                        '\n^7Installed version: ^3'..currentVersion..
                        '\n^7Get the latest version here: ^5https://github.com/hoaaiww/hoaaiww_bikeshopandrent/releases'..
                        '\n^7--------------------------------'
                    )
                else
                    print(''..
                        '^7--------------------------------'..
                        '\n^7[^5INFO^7] Resource [^2'..resourceName..'^7] is ^2up to date^7! (^2v' .. currentVersion ..'^7)'..
                        '\n^7--------------------------------'
                    )
                end
			else
				print(''..
                    '^7--------------------------------'..
                    '\n^7[^1ERROR^7] Resource [^2'..resourceName..'^7] has encountered an ^1error^7!'..
                    '\n^3There was a HTTP error checking for updates. HTTP Error Code: ^1'..err..
                    '\n^7--------------------------------'
                )   
			end
			
			SetTimeout(1 --[[hours]] * 3600000, checkVersionHTTPRequest)
		end
		function checkVersionHTTPRequest()
			PerformHttpRequest('https://raw.githubusercontent.com/hoaaiww/version/main/versions.json', checkVersion, 'GET')
		end
		checkVersionHTTPRequest()
	end)
else
    CreateThread(function()
        Wait(3000)
        print(''..
            firstRows..
            '\n^7[^5INFO^7] Resource [^2'..resourceName..'^7] update checking is currently ^1disabled^7! ^3(not recommended)'..
            '\n^7--------------------------------'
        )   
    end)
end
