ESX                           = nil

local zacmienie = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

-- zacmienie
function weather()
    Citizen.CreateThread(function()
        while true and zacmienie do
            SetWeatherTypePersist("HALLOWEEN")
            SetWeatherTypeNowPersist("HALLOWEEN")
            SetWeatherTypeNow("HALLOWEEN")
            SetOverrideWeather("HALLOWEEN")
			NetworkOverrideClockTime(0, 00, 00)
            SetClockTime(0, 0, 0)
            PauseClock(true)
            Citizen.Wait(0)
        end
    end)
end

function clearweather()
    Citizen.CreateThread(function()
        SetWeatherTypePersist("CLEAR")
        SetWeatherTypeNowPersist("CLEAR")
        SetWeatherTypeNow("CLEAR")
        SetOverrideWeather("CLEAR")
    end)
end

RegisterNetEvent('ntrp_zacmienie')
AddEventHandler('ntrp_zacmienie', function(minutes)
	zacmienie = true
    weather()

    while minutes > 0 and zacmienie do
        ESX.Scaleform.ShowBreakingNews("Ważna Informacja!", "<font size='24'>Zaćmienie odbędzie się za " .. minutes .. " minut. Prosimy o pobranie biletu wylotowego</font>", bottom, 60)
		if not zacmienie then return end
        minutes = minutes - 1
    end
	
end)

RegisterNetEvent('ntrp_zacmieniestop')
AddEventHandler('ntrp_zacmieniestop', function()
	clearweather()
	zacmienie = false
end)

