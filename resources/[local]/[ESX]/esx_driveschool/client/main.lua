local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                     = nil
local CurrentAction     = nil
local CurrentActionMsg  = nil
local CurrentActionData = nil
local Licenses          = {}
local CurrentTest       = nil
local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint = 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local CurrentZoneType   = nil
local DriveErrors       = 0
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end

function StartTheoryTest()
	CurrentTest = 'theory'

	SendNUIMessage({
		openQuestion = true
	})

	ESX.SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)

	TriggerServerEvent('esx_dmvschool:pay', Config.Prices['dmv'])
	
	if IsControlJustReleased(0, 322) then
		SendNUIMessage({
			openQuestion = false
		})
		Citizen.Wait(200)
		SetNuiFocus(false)
	end
end

function StopTheoryTest(success)
	CurrentTest = nil

	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)

	if success then
		TriggerServerEvent('esx_dmvschool:addLicense', 'dmv')
		ESX.ShowNotification(_U('passed_test'))
	else
		ESX.ShowNotification(_U('failed_test'))
	end
end

function StartDriveTest(type)
	ESX.Game.SpawnVehicle(Config.VehicleModels[type], Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Pos.h, function(vehicle)
		CurrentTest       = 'drive'
		CurrentTestType   = type
		CurrentCheckPoint = 0
		LastCheckPoint    = -1
		CurrentZoneType   = 'residence'
		DriveErrors       = 0
		IsAboveSpeedLimit = false
		CurrentVehicle    = vehicle
		LastVehicleHealth = GetEntityHealth(vehicle)

		local playerPed   = PlayerPedId()
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
	end)

	TriggerServerEvent('esx_dmvschool:pay', Config.Prices[type])
end

function StopDriveTest(success)
	if success then
		TriggerServerEvent('esx_dmvschool:addLicense', CurrentTestType)
		ESX.ShowNotification(_U('passed_test'))
	else
		ESX.ShowNotification(_U('failed_test'))
	end

	CurrentTest     = nil
	CurrentTestType = nil
end

function SetCurrentZoneType(type)
CurrentZoneType = type
end

function OpenDMVSchoolMenu()
	local ownedLicenses = {}

	for i=1, #Licenses, 1 do
		ownedLicenses[Licenses[i].type] = true
	end

	local elements = {}

	if not ownedLicenses['dmv'] then
		table.insert(elements, {label = _U('theory_test') .. ' <span style="color: green;">$' .. Config.Prices['dmv'] .. '</span>', value = 'theory_test'})
	end

	if ownedLicenses['dmv'] then
		if not ownedLicenses['drive'] then
			table.insert(elements, {label = _U('road_test_car') .. ' <span style="color: green;">$' .. Config.Prices['drive'] .. '</span>', value = 'drive_test', type = 'drive'})
		end

		if not ownedLicenses['drive_bike'] then
			table.insert(elements, {label = _U('road_test_bike') .. ' <span style="color: green;">$' .. Config.Prices['drive_bike'] .. '</span>', value = 'drive_test', type = 'drive_bike'})
		end

		if not ownedLicenses['drive_truck'] then
			table.insert(elements, {label = _U('road_test_truck') .. ' <span style="color: green;">$' .. Config.Prices['drive_truck'] .. '</span>', value = 'drive_test', type = 'drive_truck'})
		end
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dmvschool_actions',
	{
		title    = _U('driving_school'),
		elements = elements,
		align    = 'left'
	}, function(data, menu)
		if data.current.value == 'theory_test' then
			menu.close()
			SzkolaJazdyRoute68()
		elseif data.current.value == 'drive_test' then
			StartDriveTest(data.current.type)
			ESX.UI.Menu.CloseAll()
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'dmvschool_menu'
		CurrentActionMsg  = _U('press_open_menu')
		CurrentActionData = {}
	end)
end

RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({
		openSection = 'question'
	})

	cb('OK')
end)

RegisterNUICallback('close', function(data, cb)
	StopTheoryTest(true)
	cb('OK')
end)

RegisterNUICallback('kick', function(data, cb)
	StopTheoryTest(false)
	cb('OK')
end)

AddEventHandler('esx_dmvschool:hasEnteredMarker', function(zone)
	if zone == 'DMVSchool' then
		CurrentAction     = 'dmvschool_menu'
		CurrentActionMsg  = _U('press_open_menu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_dmvschool:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('esx_dmvschool:loadLicenses')
AddEventHandler('esx_dmvschool:loadLicenses', function(licenses)
	Licenses = licenses
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.DMVSchool.Pos.x, Config.Zones.DMVSchool.Pos.y, Config.Zones.DMVSchool.Pos.z)

	SetBlipSprite (blip, 408)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, 15)
	SetBlipScale  (blip, 0.8)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('driving_school_blip'))
	EndTextCommandSetBlipName(blip)
end)

-- Display markers
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 15) then
				--DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				local Pozycja = {
					["x"] = v.Pos.x,
					["y"] = v.Pos.y,
					["z"] = v.Pos.z + 1
				}
				ESX.Game.Utils.DrawText3D(Pozycja, "NACIŚNIJ [~g~E~s~] ABY PODJĄĆ EGZAMIN", 0.55, 1.5, "~b~SZKOŁA JAZDY", 0.7)
			end
		end

	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(100)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_dmvschool:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_dmvschool:hasExitedMarker', LastZone)
		end
	end
end)

-- Block UI
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if CurrentTest == 'theory' then
			local playerPed = PlayerPedId()

			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisablePlayerFiring(playerPed, true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		else
			Citizen.Wait(500)
		end
	end
end)

local bledy = 0

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then

			--ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'dmvschool_menu' then
					OpenDMVSchoolMenu()
					bledy = 0
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Test Teoretyczny
function SzkolaJazdyRoute68()
	TriggerServerEvent('esx_dmvschool:pay', Config.Prices['dmv'])
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie1',
      {
          title    = 'Jeżeli kierowca pojazdu znajduje się na skrzyżowaniu i usłyszy syrenę pojazdu uprzywilejowanego powinien:',
          align    = 'center',
          elements = {
			{label = 'Przejechać przez skrzyżowanie i zatrzymać się po prawej stronie', value = 'prawda'},
			{label = 'Natychmiast zatrzymać się na skrzyżowaniu', value = 'falsz'},
			{label = 'Przejechać przez skrzyżowanie i zatrzymać się po lewej stronie', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Citizen.Wait(100)
		  Pytanie2()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie2()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie2',
      {
          title    = 'Krawężnik pomalowany na ________ oznacza, że nie można przy nim parkować. ',
          align    = 'center',
          elements = {
			{label = 'żółto', value = 'falsz'},
			{label = 'biało', value = 'falsz'},
			{label = 'czerwono', value = 'prawda'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Citizen.Wait(100)
		  Pytanie3()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie3()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie3',
      {
          title    = 'Widząc zwierzęta w pobliżu drogi którą się poruszamy należy:',
          align    = 'center',
          elements = {
			{label = 'Spokojnie, lecz ostrożnie przejechać obok nich', value = 'prawda'},
			{label = 'Trąbić aż zwierzęta zejdą z drogi', value = 'falsz'},
			{label = 'Przyspieszyć, aby przejechać zanim zwierzęta wbiegną na drogę', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Citizen.Wait(100)
		  Pytanie4()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie4()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie4',
      {
          title    = 'Kiedy zaobserwuję podczas jazdy zjawisko aquaplaningu:',
          align    = 'center',
          elements = {
			{label = 'Wcisnę gwałtownie hamulec', value = 'falsz'},
			{label = 'Delikatnie zdejmę nogę z gazu', value = 'prawda'},
			{label = 'Docisnę gaz, żeby auto złapało przyczepność', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Citizen.Wait(100)
		  Pytanie5()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie5()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie5',
      {
          title    = 'Światła mijania należy włączyć:',
          align    = 'center',
          elements = {
			{label = 'O każdej porze dnia', value = 'falsz'},
			{label = 'Po zmroku', value = 'prawda'},
			{label = 'Nie muszę o to dbać, bo w nowych autach światła są samoczynne', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Citizen.Wait(100)
		  Pytanie6()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie6()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie6',
      {
          title    = 'Jesteś świadkiem wypadku, w pobliżu nie ma innych kierowców, co robisz?',
          align    = 'center',
          elements = {
			{label = 'Oddalasz się powoli, by nie narażać się na niebezpieczeństwo', value = 'falsz'},
			{label = 'Wzywasz służby i uciekasz, żeby nie podejrzewano cie o spowodowanie wypadku', value = 'falsz'},
			{label = 'Udzielasz pierwszej pomocy poszkodowanym i powiadamiasz służby', value = 'prawda'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Citizen.Wait(100)
		  Pytanie7()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie7()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie7',
      {
          title    = 'Przed jazdą wypijasz dwa piwa:',
          align    = 'center',
          elements = {
			{label = 'Dzięki temu, będę mieć szybsza reakcję', value = 'falsz'},
			{label = 'Moje reakcje mogą być opóźnione', value = 'prawda'},
			{label = 'Mogę źle wyjść na zdjęciu fotoradaru', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Citizen.Wait(100)
		  Pytanie8()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie8()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie8',
      {
          title    = 'Jak sprawdzisz czy poszkodowany ma puls?',
          align    = 'center',
          elements = {
			{label = 'Poklepię go po czole', value = 'falsz'},
			{label = 'Nacisnę na tętnicę szyjną z całej siły', value = 'falsz'},
			{label = 'Sprawdzę na nadgarstku', value = 'prawda'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Citizen.Wait(100)
		  Pytanie9()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie9()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie9',
      {
          title    = 'Chcąc dołączyć do ruchu na autostradzie musisz:',
          align    = 'center',
          elements = {
			{label = 'Przyspieszyć, by zrównać się prędkością z autami jadącymi autostradą', value = 'prawda'},
			{label = 'Zwolnić by ostrożnie zająć miejsce na pasie', value = 'falsz'},
			{label = 'Po prostu wjechać na pas, mam przecież pierwszeństwo', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Citizen.Wait(100)
		  Pytanie10()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function Pytanie10()
	ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pytanie10',
      {
          title    = 'W manualnej skrzyni biegów, wciskając gaz i szybko puszczając sprzęgło możemy dopuścić do:',
          align    = 'center',
          elements = {
			{label = 'Uszkodzenia światła cofania', value = 'falsz'},
			{label = 'Utraty przyczepności podczas ruszania', value = 'prawda'},
			{label = 'Spalenia opony', value = 'falsz'},
		  }
      },
      function(data, menu)
          local odp = data.current.value
          if odp == 'falsz' then
            bledy = bledy + 1
		  end
		  menu.close()
		  Citizen.Wait(100)
		  KoniecPytan()
      end,
      function(data, menu)
          menu.close()
      end
  )
end

function KoniecPytan()
	if bledy >= 4 then
		bledy = 0
		TriggerEvent('pNotify:SendNotification', {text = "Test niezaliczony! Spróbuj jeszcze raz!"})
	elseif bledy < 4 then
		TriggerServerEvent('esx_dmvschool:addLicense', 'dmv')
		TriggerServerEvent('esx_dmvschool:reloadLicense')
		ESX.ShowNotification(_U('passed_test'))
	end
end

-- Drive test
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentTest == 'drive' then
			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local nextCheckPoint = CurrentCheckPoint + 1

			if Config.CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(CurrentBlip) then
					RemoveBlip(CurrentBlip)
				end

				CurrentTest = nil

				ESX.ShowNotification(_U('driving_test_complete'))

				if DriveErrors < Config.MaxErrors then
					StopDriveTest(true)
				else
					StopDriveTest(false)
				end
			else

				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(CurrentBlip) then
						RemoveBlip(CurrentBlip)
					end

					CurrentBlip = AddBlipForCoord(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z)
					SetBlipRoute(CurrentBlip, 1)

					LastCheckPoint = CurrentCheckPoint
				end

				local distance = GetDistanceBetweenCoords(coords, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, true)

				if distance <= 100.0 then
					DrawMarker(1, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3.0 then
					Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
					CurrentCheckPoint = CurrentCheckPoint + 1
				end
			end
		else
			-- not currently taking driver test
			Citizen.Wait(500)
		end
	end
end)

-- Speed / Damage control
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentTest == 'drive' then

			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) then

				local vehicle      = GetVehiclePedIsIn(playerPed, false)
				local speed        = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
				local tooMuchSpeed = false

				for k,v in pairs(Config.SpeedLimits) do
					if CurrentZoneType == k and speed > v then
						tooMuchSpeed = true

						if not IsAboveSpeedLimit then
							DriveErrors       = DriveErrors + 1
							IsAboveSpeedLimit = true

							ESX.ShowNotification(_U('driving_too_fast', v))
							ESX.ShowNotification(_U('errors', DriveErrors, Config.MaxErrors))
						end
					end
				end

				if not tooMuchSpeed then
					IsAboveSpeedLimit = false
				end

				local health = GetEntityHealth(vehicle)
				if health < LastVehicleHealth then

					DriveErrors = DriveErrors + 1

					ESX.ShowNotification(_U('you_damaged_veh'))
					ESX.ShowNotification(_U('errors', DriveErrors, Config.MaxErrors))

					-- avoid stacking faults
					LastVehicleHealth = health
					Citizen.Wait(1500)
				end
			end
		else
			-- not currently taking driver test
			Citizen.Wait(500)
		end
	end
end)
