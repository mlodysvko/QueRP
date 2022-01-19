local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}

local menuIsShowed 				 = false
local hasAlreadyEnteredMarker 	 = false
local lastZone 					 = nil
local isInJoblistingMarker 		 = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function ShowJobListingMenuMain(data)
	ESX.TriggerServerCallback('esx_department:getJobsList', function(data)
		local jobelements = {}
		for i = 1, #data, 1 do
			table.insert(
				jobelements,
				{label = data[i].label, value = data[i].value}
			)
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'joblisting',
		{
			title    = _U('job_center'),
			align    = 'center',
			elements = {
				{label = 'Wybierz Pracę', value = 'jobs'},
				{label = 'Zarządzanie Garażem', value = 'garages'},
				{label = 'Zarządzanie Nieruchomościami', value = 'OpenSubownerMenu'},
			}
		}, function(data, menu)
		if data.current.value == 'jobs' then
			ShowJobListingMenu()
		elseif data.current.value == 'garages' then
			menu.close()
			--TriggerEvent('esx:showNotification', 'Aby wyświetlić opcje garażu, podaj numer tablicy rejestracyjnej!')
			--TriggerEvent('esx_department:SetSubowner')
			--exports['arivi_garages']:OpenSellCarMenu()
			garages()
		elseif data.current.value == 'OpenSubownerMenu' then
			exports['esx_property']:OpenSubownerMenu()
		end
		end, function(data, menu)
			menu.close()
		end)

	end)
end

function garages(data)
		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'joblisting',
		{
			title    = _U('job_center'),
			align    = 'center',
			elements = {
				{label = 'Wyświetl menu zarządzania pojazdami', value = 'gigga'},
				{label = 'Wystaw umowę sprzedaży pojazdu', value = 'nigga'},
			}
		}, function(data, menu)
		if data.current.value == 'gigga' then
			TriggerEvent('esx:showNotification', 'Aby wyświetlić opcje garażu, podaj numer tablicy rejestracyjnej!')
			TriggerEvent('esx_department:SetSubowner')
		elseif data.current.value == 'nigga' then
			exports['Island_garages']:OpenSellCarMenu()
		end
		end, function(data, menu)
			ShowJobListingMenuMain(data)
		end)
end

function ShowJobListingMenu(data)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'joblisting',
	{
		title    = _U('job_center'),
		align    = 'center',
		elements = {
			{label = 'Praca Taxi', value = 'xSKAKYS1'},
			{label = 'Praca Kawiarni', value = 'xSKAKYS2'},
			{label = 'Zwolnij Sie', value = 'xSKAKYS3'}
		}
	}, function(data, menu)
		if data.current.value == 'xSKAKYS1' then
			TriggerServerEvent('esx_jk_jobs:setJobp')
			print('test1')
		elseif data.current.value == 'xSKAKYS2' then
			TriggerServerEvent('esx_jk_jobs:setJobn')
			print('test2')
		elseif data.current.value == 'xSKAKYS3' then
			TriggerServerEvent('esx_jk_jobs:setJobt')
			print('test3')
		end
		end, function(data, menu)
			ShowJobListingMenuMain(data)
		end)
end

AddEventHandler('esx_department:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i=1, #Config.Zones, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		isInJoblistingMarker  = false
		local currentZone = nil
		for i=1, #Config.Zones, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < Config.ZoneSize.x) then
				isInJoblistingMarker  = true
				SetTextComponentFormat('STRING')
				AddTextComponentString(_U('access_job_center'))
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end
		end
		if isInJoblistingMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end
		if not isInJoblistingMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_department:hasExitedMarker')
		end
	end
end)


Citizen.CreateThread(function()
	for i=1, #Config.Zones, 1 do
		local blip = AddBlipForCoord(Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z)
		SetBlipSprite (blip, 498)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 3)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('job_center'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsControlJustReleased(0, Keys['E']) and isInJoblistingMarker and not menuIsShowed then
			ShowJobListingMenuMain()
		end
	end
end)
