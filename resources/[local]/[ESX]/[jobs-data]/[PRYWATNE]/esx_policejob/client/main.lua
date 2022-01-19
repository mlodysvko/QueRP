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
local sdkjahjsdhsja 			  = false
local Binoculars              = false
local FOV                     = 37.5

local Dragging                = nil

local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsFirstHandcuffTick       = true
local IsHandcuffed              = false
local IsDragged                 = false
local hasAlreadyJoined          = false
local blipsCops                 = {}
local isDead                    = false

local fixing, turn = false, false
local zcoords, mcolor = 255, 153, 51
local position = 0

local tempInfo = "~y~Radar gotowy do działania..."
local veh,a, b, c, d, e, f, g, h, i, j, fmodel, fvspeed, fplate, bmodel, bvspeed, bplate
local radar = {
	shown = false,
	freeze = false,
	info = tempInfo,
	info2 = tempInfo,
	frontPlate = "",
	frontModel = "",
	backPlate = "",
	backModel = "",
	minSpeed = 5.0,
	maxSpeed = 80.0,
}

CurrentTask                     = {}

ESX                             = nil
GUI.Time                        = 0

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	if PlayerData.job ~= nil and (PlayerData.job.name == 'police') then
	TriggerServerEvent("arivi_gps:refreshGPS")
    TriggerEvent('esx_policejob:displayGPS')
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(1)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i=1, #Config.ClothesZone, 1 do
			if PlayerData.job ~= nil and (PlayerData.job.name == 'police') then
				if(GetDistanceBetweenCoords(coords, Config.ClothesZone[i].x, Config.ClothesZone[i].y, Config.ClothesZone[i].z, true) < 30) then
					sleep = false
					DrawMarker(1, Config.ClothesZone[i].x, Config.ClothesZone[i].y, Config.ClothesZone[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end
			end
			--sleep = true
		end
		for i=1, #Config.Ilosc, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Ilosc[i].x, Config.Ilosc[i].y, Config.Ilosc[i].z, true) < 10) then
				sleep = false
				DrawMarker(22, Config.Ilosc[i].x, Config.Ilosc[i].y, Config.Ilosc[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.2, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
			--sleep = true
		end
		if sleep then
			Citizen.Wait(3000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		isInPoliceSkinMarker  = false
		local currentZone = nil
		for i=1, #Config.ClothesZone, 1 do
			if PlayerData.job ~= nil and (PlayerData.job.name == 'police') then
				if(GetDistanceBetweenCoords(coords, Config.ClothesZone[i].x, Config.ClothesZone[i].y, Config.ClothesZone[i].z, true) < Config.MarkerSize.x) then
					isInPoliceSkinMarker  = true
					SetTextComponentFormat('STRING')
					AddTextComponentString("Naciśnij ~INPUT_CONTEXT~ aby edytować ~y~ubranie")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)

				end
			end
		end
		isInPoliceIloscMarker = false
		for i=1, #Config.Ilosc, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Ilosc[i].x, Config.Ilosc[i].y, Config.Ilosc[i].z, true) < Config.MarkerSize.x) then
				isInPoliceIloscMarker  = true
				SetTextComponentFormat('STRING')
				AddTextComponentString("Naciśnij ~INPUT_CONTEXT~ aby sprawdzić ilość ~b~funkcjonariuszy na służbie.")
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end
		end
		if isInPoliceSkinMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end
		if isInPoliceIloscMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end
		if not isInPoliceSkinMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			sleep = true
			TriggerEvent('esx_policejobskin:hasExitedMarker')
		end
		if not isInPoliceIloscMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			sleep = true
			TriggerEvent('esx_policejobskin:hasExitedMarker')
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsControlJustReleased(0, Keys['E']) and isInPoliceSkinMarker and not menuIsShowed then
			TriggerEvent('esx_skin:openSaveableMenu', player)
		elseif IsControlJustReleased(0, Keys['E']) and isInPoliceIloscMarker and not menuIsShowed then
			local police = exports['esx_scoreboard']:BierFrakcje('police')
			TriggerEvent('esx:showNotification', 'Ilość funkcjonariuszy na służbie: ~b~'..police)
		end
	end
end)

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 270
	DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

local timeLeft = nil
CreateThread(function()
	while true do
		Citizen.Wait(0)
		if timeLeft ~= nil then
			local coords = GetEntityCoords(PlayerPedId())	
			DrawText3D(coords.x, coords.y, coords.z + 0.1, timeLeft .. '~g~%', 0.4)
		end
	end
end)

function procent(time, cb)
	if cb ~= nil then
		CreateThread(function()
			timeLeft = 0
			repeat
				timeLeft = timeLeft + 1
				Citizen.Wait(time)
			until timeLeft == 100
			timeLeft = nil
			cb()
		end)
	else
		timeLeft = 0
		repeat
			timeLeft = timeLeft + 1
			Citizen.Wait(time)
		until timeLeft == 100
		timeLeft = nil
	end
end



function SetVehicleMaxMods(vehicle, livery, offroad, color, extras, bulletproof, tint, wheel, tuning)
	local t = {
		modArmor        = 4,
		modTurbo        = true,
		modXenon        = true,
		windowTint      = 0,
		dirtLevel       = 0,
		extras          = {1,1,1,1,1,1,1,1,1,1,1,1}
	}
	if tuning then
		t.modEngine = 3
		t.modBrakes = 2
		t.modTransmission = 2
		t.modSuspension = 3
	end

	if offroad then
		t.wheels = 4
		t.modFrontWheels = 10
	end

	if bulletproof then
		t.bulletProofTyre = true
	end

	if color then
		t.color1 = color
		t.color2 = color
		t.pearlescentColor = color
	end

	if extras then
		for k, v in pairs(extras) do
			t.extras[tonumber(k)] = tonumber(v)
		end
	end

	if tint then
		t.windowTint = tint
	end

	if wheel then
		t.wheelColor = wheel.color
		t.wheels = wheel.group
		t.modFrontWheels = wheel.type
	end

	ESX.Game.SetVehicleProperties(vehicle, t)
	if livery then
		SetVehicleLivery(vehicle, livery)
	end
end

function CanPlayerUse(grade, swat, sheriff, marshal, swim)
	if swat and not IsSWAT then
		return false
	end

	if sheriff and not IsSheriff then
		return false
	end

	if marshal and not IsMarshal then
		return false
	end

	if swim and not IsSWM then
		return false
	end

	return not grade or PlayerData.job.grade >= grade
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform(job, playerPed)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
      if Config.Uniforms[job].male ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
      else
		ESX.ShowNotification(_U('no_outfit'))
      end
      if job == 'kampod' or job == 'kamgang' or job == 'kammars' or job == 'kamdeft' then
        SetPedArmour(playerPed, 50)
      end
    else
      if Config.Uniforms[job].female ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
      else
		ESX.ShowNotification(_U('no_outfit'))
      end
      if job == 'kampod' or job == 'kamgang' or job == 'kammars' or job == 'kamdeft' then
        SetPedArmour(playerPed, 50)
      end
    end

  end)
end

function OpenCloakroomMenu()

  local playerPed = GetPlayerPed(-1)

  local elements = {
    { label = _U('citizen_wear'), value = 'citizen_wear' },
	{ label = 'Prywatna Garderoba', value = 'property_wear' },
    { label = 'Mundury SAST', value = 'LSPD'},
	{ label = 'Mundury SAST - Bojowe', value = 'bojowe'},
	{ label = 'Inne', value = 'inne'},
    { label = 'Kamizelki', value = 'lspdkamzy'},
  }
  local found = false
  ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
	  if hasWeaponLicense then
			table.insert(elements, { label = 'SWAT', value = 'swat'})
	  end
	  found = true
  end, GetPlayerServerId(PlayerId()), 'police_swat')

  while not found do
	  Citizen.Wait(100)
  end
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'center',
      elements = elements,
    },
    function(data, menu)

      cleanPlayer(playerPed)

    if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
          TriggerEvent('skinchanger:loadSkin', skin)
			GetPedData()
			reloadskin()
        end)
	elseif data.current.value == 'lspdkamzy' then
		Openjebacpisituska()
	
	elseif data.current.value == 'property_wear' then
	
		ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerDressing', function(dressing)
			local elements = {}

			for i=1, #dressing, 1 do
				table.insert(elements, {
					label = dressing[i],
					value = i
				})
			end


			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
				title = 'Prywatna Garderoba',	
				align    = 'center',
				elements = elements
			}, function(data2, menu2)
				TriggerEvent('skinchanger:getSkin', function(skin)
					ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerOutfit', function(clothes)
						TriggerEvent('skinchanger:loadClothes', skin, clothes)
						TriggerEvent('esx_skin:setLastSkin', skin)

						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)
					end, data2.current.value)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end)

      elseif data.current.value == 'LSPD' then 
        local sjkjkdad = {
          { label = 'Cadet', value = 'kadet'},
          --[[{ label = 'Trooper', value = 'oficershort'},
		  { label = 'Trooper - Dlugi', value = 'oficerlong'},
          { label = 'Sergeant', value = 'sierzantshort'},
		  { label = 'Sergeant  - Dlugi', value = 'sierzantlong'},
          { label = 'Lieutenant', value = 'porucznikshort'},
		  { label = 'Lieutenant - Dlugi', value = 'poruczniklong'},
          { label = 'Capitan', value = 'kapitanshort'},
		  { label = 'Capitan - Dlugi', value = 'kapitanlong'},
		  { label = 'Commander', value = 'commandershort'},
		  { label = 'Commander - Dlugi', value = 'commanderlong'},]]
        }
		if PlayerData.job.grade >= 1 then
			table.insert(sjkjkdad, {label = 'Trooper', value = 'oficershort'})
		end
		if PlayerData.job.grade >= 3 then
			table.insert(sjkjkdad, {label = 'Sergeant', value = 'sierzantshort'})
		end
		if PlayerData.job.grade >= 5 then
			table.insert(sjkjkdad, {label = 'Lieutenant', value = 'porucznikshort'})
		end
		if PlayerData.job.grade >= 7 then
			table.insert(sjkjkdad, {label = 'Capitan', value = 'kapitanshort'})
		end
		if PlayerData.job.grade >= 9 then
			table.insert(sjkjkdad, {label = 'Commander', value = 'commandershort'})
		end
		if PlayerData.job.grade >= 14 then
			table.insert(sjkjkdad, {label = 'Chief Of Police', value = 'commanderlong'})
		end

        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'cloakroomMundury',
          {
            title = 'Mundury SAST',
            align = 'center',
            elements = sjkjkdad
          }, 
          function(data2, menu2)
            cleanPlayer(playerPed)

            setUniform(data2.current.value, playerPed)
          end, function(data2, menu2)
            menu2.close()
          end
        )
	elseif data.current.value == 'swat' then 
        local motoelement = {
          { label = 'Normalny', value = 'swatalways'},
          { label = 'Lekki', value = 'swatlight'},
		  { label = 'Ciezki', value = 'swatheavy'},
        }

        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'cloakroomMoto',
          {
            title = 'Mundury SAST - Bojowe',
            align = 'center',
            elements = motoelement
          },
          function(data2, menu2)
            cleanPlayer(playerPed)

            setUniform(data2.current.value, playerPed)
          end, function(data2, menu2)
            menu2.close()
          end
        )
      elseif data.current.value == 'bojowe' then 
        local motoelement = {}
		if PlayerData.job.grade >= 4 then
			table.insert(motoelement, {label = 'Sergeant - Bojowy', value = 'sierzantboj'})
		end
		if PlayerData.job.grade >= 6 then
			table.insert(motoelement, {label = 'Lieutenant - Bojowy', value = 'porucznikboj'})
		end
		if PlayerData.job.grade >= 8 then
			table.insert(motoelement, {label = 'Capitan - Bojowy', value = 'kapitanboj'})
		end
		
        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'cloakroomMoto',
          {
            title = 'SWAT',
            align = 'center',
            elements = motoelement
          },
          function(data2, menu2)
            cleanPlayer(playerPed)

            setUniform(data2.current.value, playerPed)
          end, function(data2, menu2)
            menu2.close()
          end
        )
	elseif data.current.value == 'inne' then 
        local motoelement = {
			{ label = 'Galowy', value = 'galowy'},
        }
		
        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'cloakroomMoto',
          {
            title = 'Inne',
            align = 'center',
            elements = motoelement
          },
          function(data2, menu2)
            cleanPlayer(playerPed)

            setUniform(data2.current.value, playerPed)
          end, function(data2, menu2)
            menu2.close()
          end
        )
      elseif data.current.value == 'lspdkamzy' then 
        local kamelement = {
          { label = 'Kamizelka Odblaskowa', value = 'kadet2'},
          { label = 'Podstawowa', value = 'oficer2'},
          { label = 'SWAT', value = 'swat2'},
          { label = 'AIAD', value = 'aiad2'},
        }
        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'cloakroomKamzy',
          {
            title = 'Kamizelki Kuloodporne SAST',
            align = 'center',
            elements = kamelement
          },
          function(data2, menu2)
            cleanPlayer(playerPed)

            setUniform(data2.current.value, playerPed)
          end, function(data2, menu2)
            menu2.close()
          end
        )
      elseif data.current.value == 'lspddodatki' then 
        local dodelement = {
          { label = 'Kabura przy pasie taktycznym', value = 'kaburapas'},
          { label = 'Kabura przy udzie', value = 'kaburaudo'},
          { label = 'Kask - Motocycle Division', value = 'motokask'},
          { label = 'Maska - Motocycle Division', value = 'motomask'},
        }
        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'cloakroomDodatki',
          {
            title = 'Dodatki Do Munduru',
            align = 'center',
            elements = dodelement
          },
          function(data2, menu2)
            cleanPlayer(playerPed)

            setUniform(data2.current.value, playerPed)
          end, function(data2, menu2)
            menu2.close()
          end
        )
      else
        setUniform(data.current.value, playerPed)
      end

      
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )
end

function reloadskin()

    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

    TriggerEvent('esx:showNotification', 'Ładowanie postaci..')

    Wait(2000)

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)

        TriggerEvent('skinchanger:loadSkin', skin)

    end)

    TriggerEvent('esx_tattooshop:refreshTattoos')

end



function GetPedData()

	return Ped

end

function Openjebacpisituska()
    local elements = {}
	if PlayerData.job.grade >= 1 then
		table.insert(elements, {label = '1 Wkład', value = '1/4'})
	end
	if PlayerData.job.grade >= 5 then
		table.insert(elements, {label = '2 Wkłady', value = '2/4'})
	end
	if PlayerData.job.grade >= 7 then
		table.insert(elements, {label = '3 Wkłady', value = '3/4'})
	end
	if PlayerData.job.grade >= 8 then
		table.insert(elements, {label = '4 Wkłady', value = '4/4'})
	end

	ESX.UI.Menu.CloseAll()
  
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'Szymczakof',
		{
		  title    = 'Wkłady do kamizelek',
		  align    = 'center',
		  elements = elements,
		},
		function(data, menu)
  
		if data.current.value == '1/4' then
			SetPedArmour(GetPlayerPed(-1), 15)
		elseif data.current.value == '2/4' then
			SetPedArmour(GetPlayerPed(-1), 50)
		elseif data.current.value == '3/4' then
			SetPedArmour(GetPlayerPed(-1), 75)
		elseif data.current.value == '4/4' then
			SetPedArmour(GetPlayerPed(-1), 100)
		end		
	 end,
		function(data, menu)
			menu.close()
		end
	)
end

function OpenSzymczakCustomMenu(station)

    local elements = {
	  {label = _U('tgps'), value = 'gps'},
	  {label = _U('fixkit'), value = 'fixkit'},
	  {label = 'Panic Button', value = 'panicbutton'},
	  {label = 'Lornetka', value = 'binoculars'},
	  {label = 'Latarka', value = 'flashlight'},
	  {label = 'Pałka', value = 'nightstick'},
	  {label = 'Tazer', value = 'stungun'},
	  {label = 'Radio', value = 'radio'},
	  {label = 'Magazynek', value = 'pistol_ammo'},
    }


    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'SzymczakCustom',
      {
        title    = _U('SzymczakCustom'),
        align    = 'center',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'fixkit' then
			data = 'fixkit'
			TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk1', data)
			TriggerServerEvent('Island:LogPolice', data)
		elseif data.current.value == 'gps' then
			data = 'gps'
			TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk1', data)
			TriggerServerEvent('Island:LogPolice', data)
		elseif data.current.value == 'panicbutton' then
			data = 'panicbutton'
			TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk1', data)
			TriggerServerEvent('Island:LogPolice', data)
		elseif data.current.value == 'binoculars' then
			data = 'binoculars'
			TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk1', data)
			TriggerServerEvent('Island:LogPolice', data)
		elseif data.current.value == 'flashlight' then
			data = 'flashlight'
			TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk1', data)
			TriggerServerEvent('Island:LogPolice', data)
		elseif data.current.value == 'nightstick' then
			data = 'nightstick'
			TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk1', data)
			TriggerServerEvent('Island:LogPolice', data)
		elseif data.current.value == 'stungun' then
			data = 'stungun'
			TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk', data)
			TriggerServerEvent('Island:LogPolice', data)
		elseif data.current.value == 'radio' then
			data = 'radio'
			TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk221', data)
			TriggerServerEvent('Island:LogPolice', data)
		elseif data.current.value == 'pistol_ammo' then
			data = 'pistol_ammo'
			TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk22', data)
			TriggerServerEvent('Island:LogPolice', data)
		end		
    end,
        function(data, menu)
			menu.close()
			OpenArmoryMenu(station)
        end
    )

end



function OpenArmoryMenu(station)

  if Config.EnableArmoryManagement then

    local elements = {
	  {label = 'Weź Broń', value = 'wez_bronxd'},
	 -- {label = _U('put_weapon'),     value = 'put_weapon'},
	  {label = 'Szafka na Kontrabandę', value = 'kontrabanda'},
	  {label = _U('SzymczakCustom'), value = 'SzymczakCustom'},

    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = _U('armory'),
        align    = 'center',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'SzymczakCustomGetWeapon' then
          OpenSzymczakCustomGetWeaponMenu()
		end
		
		if data.current.value == 'kontrabanda' then
			OpenSzymczakJestFajnyKontrabanda()
		end

        if data.current.value == 'SzymczakCustom' then
          OpenSzymczakCustomMenu()
        end
		
        if data.current.value == 'put_weapon' then
          OpenPutWeaponMenu()
        end

        if data.current.value == 'get_weapon' then
          OpenGetWeaponMenu()
		end
		if data.current.value == 'wez_bronxd' then
			JKEBACPSAJIPDHIJOAHIDHAIHIP()
        end


    	if data.current.value == 'buy_weapons' then
          OpenBuyWeaponsMenu(station)
    	end

        if data.current.value == 'put_stock' then
          OpenPutStocksMenu()
        end

        if data.current.value == 'get_stock' then
          OpenGetStocksMenu()
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
      end
    )

   end

end


function JKEBACPSAJIPDHIJOAHIDHAIHIP()
	local elements = {
		{label = 'Pistolet Bojowy', value = 'combatpistol'},
		{label = 'Pistolet Vintage', value = 'vintagepistol'},
		{label = 'Ciezki Pistolet', value = 'heavypistol'}
	}
		PlayerData = ESX.GetPlayerData()
	if PlayerData.job.grade == 4 then
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
	elseif PlayerData.job.grade == 5 then
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
	elseif PlayerData.job.grade == 6 then
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
	elseif PlayerData.job.grade == 7 then
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
	elseif PlayerData.job.grade == 8 then
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
	elseif PlayerData.job.grade == 9 then
		
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
	elseif PlayerData.job.grade == 10 then
		
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
		local found = false
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				table.insert(elements, { label = 'Pistolet Vintage', value = 'vintagepistol'})
			end
			found = true
		end, GetPlayerServerId(PlayerId()), 'police_swat')

		while not found do
			Citizen.Wait(100)
		end
		
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
		local found = false
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				table.insert(elements, { label = 'Pistolet Vintage', value = 'vintagepistol'})
			end
			found = true
		end, GetPlayerServerId(PlayerId()), 'police_swat')

		while not found do
			Citizen.Wait(100)
		end
		
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
		local found = false
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				table.insert(elements, { label = 'Pistolet Vintage', value = 'vintagepistol'})
				table.insert(elements, { label = 'Pistolet Ciężki', value = 'heavypistol'})
			end
			found = true
		end, GetPlayerServerId(PlayerId()), 'police_swat')

		while not found do
			Citizen.Wait(100)
		end
		
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
		local found = false
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				table.insert(elements, { label = 'Pistolet Vintage', value = 'vintagepistol'})
				table.insert(elements, { label = 'Pistolet Ciężki', value = 'heavypistol'})
			end
			found = true
		end, GetPlayerServerId(PlayerId()), 'police_swat')

		while not found do
			Citizen.Wait(100)
		end
		
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
		local found = false
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				table.insert(elements, { label = 'Pistolet Vintage', value = 'vintagepistol'})
				table.insert(elements, { label = 'Pistolet Ciężki', value = 'heavypistol'})
			end
			found = true
		end, GetPlayerServerId(PlayerId()), 'police_swat')

		while not found do
			Citizen.Wait(100)
		end

		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
		local found = false
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				table.insert(elements, { label = 'Pistolet Vintage', value = 'vintagepistol'})
				table.insert(elements, { label = 'Pistolet Ciężki', value = 'heavypistol'})
			end
			found = true
		end, GetPlayerServerId(PlayerId()), 'police_swat')

		while not found do
			Citizen.Wait(100)
		end
		
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
		local found = false
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				table.insert(elements, { label = 'Pistolet Vintage', value = 'vintagepistol'})
				table.insert(elements, { label = 'Pistolet Ciężki', value = 'heavypistol'})
			end
			found = true
		end, GetPlayerServerId(PlayerId()), 'police_swat')

		while not found do
			Citizen.Wait(100)
		end
		
		table.insert(elements, { label = 'Pistolet Bojowy', value = 'combatpistol'})
	end
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'police_actions',
	{
		title    = 'Menu Policjanta',
		align    = 'center',
		elements = elements
	}, function(data, menu)
			if data.current.value == 'pistol' then
				data = 'pistol'
				TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk', data)
				TriggerServerEvent('Island:LogPolice', data)
			elseif data.current.value == 'heavypistol' then
				data = 'heavypistol'
				TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk', data)
				TriggerServerEvent('Island:LogPolice', data)
			elseif data.current.value == 'combatpistol' then
				data = 'combatpistol'
				TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk', data)
				TriggerServerEvent('Island:LogPolice', data)
			elseif data.current.value == 'pistol_mk2' then
				data = 'pistol_mk2'
				TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk', data)
				TriggerServerEvent('Island:LogPolice', data)
			elseif data.current.value == 'vintagepistol' then
				data = 'vintagepistol'
				TriggerServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk', data)
				TriggerServerEvent('Island:LogPolice', data)
			end
		end, 
		function(data, menu)
			menu.close()
		end
	)
end

function OpenSzymczakJestFajnyKontrabanda()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'kontrabanda',
        {
			align    = 'center',
            title    = 'Szafka - Kontrabanda',
            elements = {
      			{label = _U('remove_object'),  value = 'get_stock'},
	 			{label = _U('deposit_object'), value = 'put_stock'}
            }
        },
        function(data, menu)
           
        if data.current.value == 'put_stock' then
          OpenPutStocksMenu()
        end

        if data.current.value == 'get_stock' then
          OpenGetStocksMenu()
        end
        end,
        function(data, menu)
			menu.close()
			OpenArmoryMenu()
        end
    )
end



function OpenVehicleSpawnerMenu(station, partNum)
	local vehicles = Config.PoliceStations[station].Vehicles
	ESX.UI.Menu.CloseAll()

	local elements = {}
	for i, group in ipairs(Config.VehicleGroups) do
		local found = false
		local isSwat = false


		--if (i ~= 6 and i ~= 6 and i ~= 6 and i ~= 6) or (i == 6 and found) or (i == 13 and IsSEU) or (i == 13 and IsSheriff) or (i == 13 and IsMarshal) or (i == 13 and IsSWAT) then
			local elements2 = {}
			for _, vehicle in ipairs(Config.AuthorizedVehicles) do
				local let = false
				for _, group in ipairs(vehicle.groups) do
					if group == i then
						let = true
						break
					end
				end

				if let then
					if vehicle.grade then
						if not CanPlayerUse(vehicle.grade, vehicle.swat, nil, vehicle.marshal, nil) or (vehicle.label:find('SEU') and not IsSEU) then
							let = false
						end
					elseif vehicle.grades and #vehicle.grades > 0 then
						let = false
						for _, grade in ipairs(vehicle.grades) do
							if (grade == PlayerData.job.grade or (grade == 6 and PlayerData.job.grade ~= 6 and IsDTU) or (vehicle.marshal and IsMarshal) or (vehicle.swat and IsSWAT)) and (not vehicle.label:find('SEU') or IsSEU) then
								let = true
								break
							end
						end
					end

					if let then
						table.insert(elements2, { label = vehicle.label, model = vehicle.model, livery = vehicle.livery, offroad = vehicle.offroad, color = vehicle.color, extras = vehicle.extras, plate = vehicle.plate, tint = vehicle.tint, bulletproof = vehicle.bulletproof, wheel = vehicle.wheel, tuning = vehicle.tuning })
					end
				end
			end

			if #elements2 > 0 then
				table.insert(elements, { label = group, value = elements2, group = i })
			end
		--end
	end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
      title    = _U('vehicle_menu'),
      align    = 'center',
      elements = elements
    }, function(data, menu)
        menu.close()
		if type(data.current.value) == 'table' and #data.current.value > 0 then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner_' .. data.current.group, {
			  title    = data.current.label,
			  align    = 'center',
			  elements = data.current.value
			}, function(data2, menu2)
				local livery = data2.current.livery
				local offroad = data2.current.offroad
				local color = data2.current.color
				local extras = data2.current.extras
				local bulletproof = data2.current.bulletproof or false
				local tint = data2.current.tint
				local wheel = data2.current.wheel
				local tuning = data2.current.tuning

				local setPlate = true
				if data2.current.plate ~= nil and not data2.current.plate then
					setPlate = false
				end

				local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z, 3.0, 0, 71)
				if not DoesEntityExist(vehicle) then
					local playerPed = PlayerPedId()
					ESX.Game.SpawnVehicle(data2.current.model, {
					  x = vehicles[partNum].SpawnPoint.x,
					  y = vehicles[partNum].SpawnPoint.y,
					  z = vehicles[partNum].SpawnPoint.z
					}, vehicles[partNum].Heading, function(vehicle)
						TriggerEvent('EngineToggle:Engine')
					  SetVehicleMaxMods(vehicle, livery, offroad, color, extras, bulletproof, tint, wheel, tuning)
					  SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
					  if setPlate then
						  local plate = "SAST" .. GetRandomIntInRange(100,999)
						  SetVehicleNumberPlateText(vehicle, plate)
						  
						  TriggerServerEvent('ls:addOwner', plate)
						  SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
						  
						  SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
						  
					  else
						  TriggerServerEvent('ls:addOwner', GetVehicleNumberPlateText(vehicle, true))
						  SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
						  SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
					  end

					  TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					end)
				else
				  ESX.ShowNotification(_U('vehicle_out'))
				end
			end,
			function(data2, menu2)
				menu.close()
				OpenVehicleSpawnerMenu(station, partNum)
			end)
		end
    end,
    function(data, menu)
      menu.close()

      CurrentAction     = 'menu_vehicle_spawner'
      CurrentActionMsg  = _U('vehicle_spawner')
      CurrentActionData = {station = station, partNum = partNum}
      TriggerServerEvent('szymczakovv:policeGarageLog',org,model,1)
    end)
end
function OpenPoliceActionsMenu()
  local elements = {}
  local ped = PlayerPedId()
	if not IsPedInAnyVehicle(PlayerPedId(-1), true) then
		table.insert(elements, {label = 'Interakcje z cywilami', value = 'citizen_interaction'})
	end

  
  table.insert(elements, {label = 'Interakcje z pojazdami', value = 'vehicle_interaction'})  
    if PlayerData.job.name == 'police' then
      table.insert(elements, {label = 'Interakcje z obiektami', value = 'object_spawner'})
	end
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'police_actions',
	{
		title    = 'Menu Policjanta',
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('search'),			    value = 'body_search'},
				{label = _U('handcuff'),		    value = 'handcuff'},
				{label = _U('drag'),			      value = 'drag'},
				{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},	
        		{label = _U('id_card'),			    value = 'identity_card'},
			}
			if PlayerData.job.grade >= 6 then
				table.insert(elements, { label = 'Daj Licencje', value = 'license1' })
			end
			if Config.EnableLicenses then
				table.insert(elements, { label = _U('license_check'), value = 'license' })
			end
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = 'Interakcje z Cywilami',
				align    = 'center',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

          if action == 'identity_card' then
            procent(10, function()
              OpenIdentityCardMenu(closestPlayer)
			end)
			
		elseif action == 'body_search' then
            if IsPedCuffed(GetPlayerPed(closestPlayer)) or IsPlayerDead(closestPlayer) then
				procent(20, function()
					OpenBodySearchMenu(closestPlayer)

				end)
			else
				TriggerEvent('esx:showNotification', 'Obywatel musi być zakuty')
			end
		elseif action == 'handcuff' then
			ESX.ShowNotification('~o~Zakułeś/Rozkułeś ~b~' .. GetPlayerServerId(closestPlayer))
			TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
            TriggerServerEvent('szymczakovv:handcuffLog',org, GetPlayerServerId(closestPlayer))
          elseif action == 'drag' then
            if IsPedCuffed(GetPlayerPed(closestPlayer)) or IsPlayerDead(closestPlayer) then
			 ESX.ShowNotification('~o~Przenosisz obywatela ~b~' .. GetPlayerServerId(closestPlayer))
							TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
						else
						ESX.ShowNotification("~r~Najpierw musisz zakuć obywatela.")
						end
          elseif action == 'put_in_vehicle' then
			ESX.ShowNotification('~o~Wsadzasz do pojazdu ~b~' .. GetPlayerServerId(closestPlayer))
						TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
          elseif action == 'out_the_vehicle' then
			ESX.ShowNotification('~o~Wyciągasz z pojazdu ~b~' .. GetPlayerServerId(closestPlayer))
						TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))				
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
          elseif action == 'license1' then
            TriggerServerEvent('esx_policejob:DajLicencje', GetPlayerServerId(closestPlayer))
			ESX.ShowNotification('~o~Dajesz licencje na broń krótką ~b~' .. GetPlayerServerId(closestPlayer))
					end					
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements = {}
			local playerPed = GetPlayerPed(-1)
			local coords    = GetEntityCoords(playerPed)
			local vehicle   = ESX.Game.GetVehicleInDirection()
			
			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'),	value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
				table.insert(elements, {label = _U('impound'),		value = 'impound'})
				table.insert(elements, {label = 'Napraw Pojazd', value = 'jebacrzyduf'})
			end
			


			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_interaction',
			{
				title    = 'Interakcje z pojazdami',
				align    = 'center',
				elements = elements
			}, function(data2, menu2)
				coords    = GetEntityCoords(playerPed)
				vehicle   = ESX.Game.GetVehicleInDirection()
				action    = data2.current.value
				
				if action == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
					if action == 'vehicle_infos' then
						OpenVehicleInfosMenu(vehicleData)	
					elseif action == 'jebacrzyduf' then
						exports['esx_mecanojob']:whyuniggarepairingme()
						menu.close()					
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
							Citizen.Wait(20000)
							ClearPedTasksImmediately(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							ESX.ShowNotification(_U('vehicle_unlocked'))
						end
					elseif action == 'impound' then
					
						if CurrentTask.Busy then
							return
						end
						
						SetTextComponentFormat('STRING')
						AddTextComponentString(_U('impound_prompt'))
						DisplayHelpTextFromStringLabel(0, 0, 1, -1)
						
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
						
						CurrentTask.Busy = true
						CurrentTask.Task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Citizen.Wait(500) 
						end)
						
						CreateThread(function()
							while CurrentTask.Busy do
								Citizen.Wait(1000)
							
								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and CurrentTask.Busy then
									ESX.ShowNotification(_U('impound_canceled_moved'))
									ESX.ClearTimeout(CurrentTask.Task)
									ClearPedTasks(playerPed)
									CurrentTask.Busy = false
									break
								end
							end
						end)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end
			)

		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = 'Interakcje z obiektami',
				align    = 'center',
				elements = {
					{label = _U('cone'),		value = 'prop_roadcone02a'},
					{label = _U('barrier'),		value = 'prop_barrier_work06a'},
					{label = _U('spikestrips'),	value = 'p_ld_stinger_s'},
				}
			}, function(data2, menu2)
				local model     = data2.current.value
				local playerPed = GetPlayerPed(-1)
				local coords    = GetEntityCoords(playerPed)
				local forward   = GetEntityForwardVector(playerPed)
				local x, y, z   = table.unpack(coords + forward * 1.0)

				if model == 'prop_roadcone02a' then
					z = z - 2.0
				end

				ESX.Game.SpawnObject(model, {
					x = x,
					y = y,
					z = z
				}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)

			end, function(data2, menu2)
				menu2.close()
			end)
    elseif data.current.value == 'binoculars' then
			menu.close()
	  Binoculars = not Binoculars
		  elseif data.current.value == 'repairvehXD' then
			exports['esx_mecanojob']:whyuniggarepairingme()
    end

	end, function(data, menu)
		menu.close()
	end)
end


function OpenIdentityCardMenu(player)

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

      local jobLabel    = nil
      local sexLabel    = nil
      local sex         = nil
      local dobLabel    = nil
      local heightLabel = nil
      local idLabel     = nil

      if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
        jobLabel = 'Praca: ' .. data.job.label .. ' - ' .. data.job.grade_label
      else
        jobLabel = 'Praca: ' .. data.job.label
      end

      if data.sex ~= nil then
        if (data.sex == 'm') or (data.sex == 'M') then
          sex = _('Male')
        else
          sex = _('Female')
        end
        sexLabel = 'Sex: ' .. sex
      else
        sexLabel = 'Sex: ' .. data.sex
      end

      if data.dob ~= nil then
        dobLabel = 'DOB: ' .. data.dob
      else
        dobLabel = 'DOB: Unknown'
      end

      if data.height ~= nil then
        heightLabel = 'Height: ' .. data.height
      else
        heightLabel = 'Height: Unknown'
      end

      if data.name ~= nil then
        idLabel = 'ID: ' .. data.name
      else
        idLabel = 'ID: Unknown'
      end

      local elements = {
        {label = _U('name', data.firstname .. ' ' .. data.lastname), value = nil},
        {label = sexLabel,    value = nil},
        {label = dobLabel,    value = nil},
        {label = heightLabel, value = nil},
        {label = jobLabel,    value = nil},
        {label = idLabel,     value = nil},
      }

      if data.drunk ~= nil then
        table.insert(elements, {label = _U('bac', data.drunk), value = nil})
      end

      if data.licenses ~= nil then

        table.insert(elements, {label = '--- Licencje ---', value = nil})

        for i=1, #data.licenses, 1 do
          table.insert(elements, {label = data.licenses[i].label, value = nil})
        end

      end
      TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), '~g~Funkcjonariusz sprawdza twoje dokumenty')

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'citizen_interaction',
        {
          title    = 'Wynik z Odcisków Palcy',
          align    = 'center',
          elements = elements,
        },
        function(data, menu)

        end,
        function(data, menu)
          menu.close()
        end
      )

    end, GetPlayerServerId(player))

end


function OpenBodySearchMenu(target)
    local serverId = GetPlayerServerId(target)
    ESX.TriggerServerCallback('esx_policejob:checkSearch', function(cb)
        if cb == true then
            ESX.ShowAdvancedNotification("Ta osoba jest już przeszukiwana!") 
        else
            ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
                TriggerServerEvent('esx_policejob:isSearching', serverId)
				local elements = {}
                for i=1, #data.accounts, 1 do
                    if data.accounts[i].money > 0 then
                        if data.accounts[i].name == 'black_money' then
                            table.insert(elements, {
                                label    = '[Brudna Gotówka] $'..data.accounts[i].money,
                                value    = 'black_money',
                                type     = 'item_account',
                                amount   = data.accounts[i].money
                            })
                            break
                        end
                    end
                end
                
                for i=1, #data.inventory, 1 do
                    if data.inventory[i].count > 0 then
                        table.insert(elements, {
                            label    = data.inventory[i].label .. " x" .. data.inventory[i].count,
                            value    = data.inventory[i].name,
                            type     = 'item_standard',
                            amount   = data.inventory[i].count
                        })
                    end
                end
 
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
                    title    = 'Przeszukaj',
                    align    = 'center',
                    elements = elements
                }, function(data, menu)
                    local itemType = data.current.type
                    local itemName = data.current.value
                    local amount   = data.current.amount
                    local playerCoords = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
                    local targetCoords = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, target))
                    if itemType == 'item_sim' then
                        ESX.TriggerServerCallback('esx_policejob:checkSearch2', function(cb)
                            if cb == true then
                                ESX.UI.Menu.CloseAll()
                                if #(playerCoords - targetCoords) <= 3.0 then
                                    procent(5, function()
                                        TriggerServerEvent('esx_policejob:isSearching', serverId, false)
										OpenBodySearchMenu(closestPlayer)
                                    end)
                                end
                            else
								print('xD?')
                            end
                        end, serverId)
                    else
                        if data.current.value ~= nil then
                            ESX.TriggerServerCallback('esx_policejob:checkSearch2', function(cb)
                                if cb == true then
                                    ESX.UI.Menu.CloseAll()
                                    if #(playerCoords - targetCoords) <= 3.0 then
                                        TriggerServerEvent('esx_policejob:confiscatePlayerItem', serverId, itemType, itemName, amount)
                                        procent(5, function()
                                            TriggerServerEvent('esx_policejob:isSearching', serverId, false)
											OpenBodySearchMenu(closestPlayer)
                                        end)
                                    end
                                else
                                    print('xd?')
                                end
                            end, serverId)
                        end
                    end
                end, function(data, menu)
                    menu.close()
                    TriggerServerEvent('esx_policejob:isSearching', serverId, false)
                end)
            end, serverId)
        end
    end, serverId)
end


function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_policejob:getVehicleFromPlate', function(owner, found)
				if found then
			ESX.ShowAdvancedNotification('~b~SAST Centrala', '~g~Chowasz Radiolke','O Rejestracji: ' ..GetVehicleNumberPlateText(vehicle),'Własiciciel: ' ..owner, 'CustomLogo', 2 )
				else
			ESX.ShowAdvancedNotification('~b~SAST ', '~g~Chowasz Radiolke','O Rejestracji: ' ..GetVehicleNumberPlateText(vehicle), 'CustomLogo', 2)
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		if data.licenses ~= nil then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
					table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
				end
			end
		end
		
		if Config.EnableESXIdentity then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end
		
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'manage_license',
		{
			title    = _U('license_revoke'),
			align    = 'center',
			elements = elements,
		},
		function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))
			
			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)
			
			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end,
		function(data, menu)
			menu.close()
		end
		)

	end, GetPlayerServerId(player))
end


function OpenVehicleInfosMenu(vehicleData)

  ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(infos)

    local elements = {}

    table.insert(elements, {label = _U('plate', infos.plate), value = nil})

    if infos.owner == nil then
      table.insert(elements, {label = _U('owner_unknown'), value = nil})
    else
      table.insert(elements, {label = _U('owner', infos.owner), value = nil})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_infos',
      {
        title    = _U('vehicle_info'),
        align    = 'center',
        elements = elements,
      },
      nil,
      function(data, menu)
        menu.close()
      end
    )

  end, vehicleData.plate)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'center',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'center',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value, true)

    end,
    function(data, menu)
      menu.close()
    end
  )

end



function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)


    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = '' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
		title    = 'Wyciągnij Kontrabandę',
		align = 'center',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
			  ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_policejob:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Włóż kontrabandę',
		elements = elements,
		align = 'center',
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
			  TriggerEvent('esx:showNotification', _U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_policejob:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	
	Citizen.Wait(5000)
	TriggerServerEvent('esx_policejob:forceBlip')
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

  local specialContact = {
    name       = 'Police',
    number     = 'police',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
  }

  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = _U('open_cloackroom')
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  end

  if part == 'VehicleSpawner' then
    CurrentAction     = 'menu_vehicle_spawner'
    CurrentActionMsg  = _U('vehicle_spawner')
    CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'HelicopterSpawner' then

    local helicopters = Config.PoliceStations[station].Helicopters

    if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z,  3.0) then

      ESX.Game.SpawnVehicle('polmav', {
        x = helicopters[partNum].SpawnPoint.x,
        y = helicopters[partNum].SpawnPoint.y,
        z = helicopters[partNum].SpawnPoint.z
      }, helicopters[partNum].Heading, function(vehicle)
        SetVehicleModKit(vehicle, 0)
        SetVehicleLivery(vehicle, 0)
      end)

    end

  end

  if part == 'VehicleDeleter' then

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed, false)

      if DoesEntityExist(vehicle) then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
        TriggerServerEvent('szymczakovv:policeGarageLog',org,model,0)
      end

    end

  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end

end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)

  local playerPed = GetPlayerPed(-1)

  if PlayerData.job ~= nil and PlayerData.job.name == 'police' and not IsPedInAnyVehicle(playerPed, false) then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = _U('remove_prop')
    CurrentActionData = {entity = entity}
  end

  if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed)

      for i=0, 7, 1 do
        SetVehicleTyreBurst(vehicle,  i,  true,  1000)
      end

    end

  end

end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)


RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
  local closestPlayer = ESX.Game.GetClosestPlayer()
	IsHandcuffed = not IsHandcuffed
	sdkjahjsdhsja = true
  TriggerServerEvent('InteractSound_SV:PlayOnSource', 4.5, 'handcuff', 0.2)
  ESX.ShowNotification('~o~Zakuty/Rozkuty przez ~b~' .. GetPlayerServerId(closestPlayer))
	--[[if IsPedInAnyVehicle(PlayerPedId(-1), true) then
		DisableControlAction(2, Keys["A"], true) 
		DisableControlAction(2, Keys["D"], true) 
	end]]
	local playerPed = PlayerPedId()
	CreateThread(function()
    if IsHandcuffed then
			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(0)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0.0, 0, 0, 0)

			ESX.UI.Menu.CloseAll()

			SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true) 
			DisablePlayerFiring(playerPed, true)
			SetEnableHandcuffs(playerPed, true)

			SetPedCanPlayGestureAnims(playerPed, false)
			if Config.EnableHandcuffTimer then
				StartHandcuffTimer()
			end		
    else
			ClearPedTasksImmediately(playerPed)
			if Config.EnableHandcuffTimer and HandcuffTimer then
				ESX.ClearTimeout(HandcuffTimer)
			end

			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			TriggerEvent('radar:setHidden', false)

		end
	end)
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(1)
	if IsHandcuffed then
		DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
		DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
		DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
		DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
		DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
		DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
		DisableControlAction(0, 257, true) -- INPUT_ATTACK2
		DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
		DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
		DisableControlAction(0, 24, true) -- INPUT_ATTACK
		DisableControlAction(0, 25, true) -- INPUT_AIM
		DisableControlAction(0, 289, true) -- F2
    if IsPedInAnyVehicle(PlayerPedId()) then
    	local locked = GetVehicleDoorLockStatus(GetVehiclePedIsIn(false))
    	if locked == 4 then
    		DisableControlAction(0, Keys['F'], true)
    	end
    end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	if IsHandcuffed then
		IsHandcuffed = false
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 4.5, 'handcuff', 0.2)
		local playerPed = PlayerPedId()

		ClearPedTasksImmediately(playerPed)
		if Config.EnableHandcuffTimer and HandcuffTimer then
			ESX.ClearTimeout(HandcuffTimer)
		end

		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)

		TriggerEvent('radar:setHidden', false)
		FreezeEntityPosition(playerPed, false)
	end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(cop)
  if IsHandcuffed or IsPlayerDead(PlayerId()) then
    local closestPlayer = ESX.Game.GetClosestPlayer()
	ESX.ShowNotification('~o~Jesteś przenoszony przez ~b~' .. GetPlayerServerId(closestPlayer))
		IsDragged = not IsDragged
		CopPlayer = tonumber(cop)
	end
end)

RegisterNetEvent('esx_policejob:dragging')
AddEventHandler('esx_policejob:dragging', function(target, dropped)
	if not dropped then
		Dragging = target
	elseif Dragging == target then
		Dragging = nil
	end
end)

CreateThread(function()
	local attached = false
	while true do
		if Dragging then
			local ped = PlayerPedId()
			if DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) and not IsPedDeadOrDying(GetPlayerPed(GetPlayerFromServerId(Dragging)), 1) then
				TriggerServerEvent('esx_policejob:drag', Dragging)
			end

			SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
			Citizen.Wait(100)
		elseif IsHandcuffed or IsPlayerDead(PlayerId()) then
			local playerPed = PlayerPedId()
			if IsDragged then
				if not attached then
					attached = true
					AttachEntityToEntity(playerPed, GetPlayerPed(GetPlayerFromServerId(CopPlayer)), 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					TriggerServerEvent('esx_policejob:dragging', CopPlayer, GetPlayerServerId(PlayerId()))
				end
			elseif CopPlayer then
				DetachEntity(playerPed, true, false)

				TriggerServerEvent('esx_policejob:dragging', CopPlayer)
				attached = false
				CopPlayer = nil
			end

			Citizen.Wait(10)
		else
			if IsDragged then
				local playerPed = PlayerPedId()
				DetachEntity(playerPed, true, false)
				TriggerServerEvent('esx_policejob:dragging', CopPlayer)

				local coords = GetEntityCoords(playerPed, true)
				RequestCollisionAtCoord(coords.x, coords.y, coords.z)

				attached = false
				CopPlayer = nil
				IsDragged = false
			end

			Citizen.Wait(500)
		end
	end
end)


RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
  local closestPlayer = ESX.Game.GetClosestPlayer()
  ESX.ShowNotification('~o~Zostajesz wsadzony do pojazdu przez ~b~' .. GetPlayerServerId(closestPlayer))
  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(t)
  local closestPlayer = ESX.Game.GetClosestPlayer()
  ESX.ShowNotification('~o~Zostajesz wyciągnięty z pojazdu przez ~b~' .. GetPlayerServerId(closestPlayer))
	local ped = GetPlayerPed(t)
	ClearPedTasksImmediately(ped)
	plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
	local xnew = plyPos.x+2
	local ynew = plyPos.y+2

	SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsHandcuffed then
			if IsFirstHandcuffTick then
				IsFirstHandcuffTick = false
				ESX.UI.Menu.CloseAll()
			end

			DisableControlAction(2, 24, true) -- Attack
			DisableControlAction(2, 257, true) -- Attack 2
			DisableControlAction(2, 25, true) -- Aim

			local playerPed = PlayerPedId()
			if IsPedInAnyPoliceVehicle(playerPed) then
				DisableControlAction(0, 75, true)  -- Disable exit vehicle
				DisableControlAction(27, 75, true) -- Disable exit vehicle
			end

			RequestAnimDict('mp_arresting')
      while not HasAnimDictLoaded('mp_arresting') do
        Citizen.Wait(0)
      end

      if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
				TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
      end
		else
			IsFirstHandcuffTick = true
			Citizen.Wait(500)
		end
	end
end)


function GetColors(color)
	local colors = {}
	if color == 'black' then
		colors = {
			{ index = 0, label = _U('black')},
			{ index = 1, label = _U('graphite')},
			{ index = 2, label = _U('black_metallic')},
			{ index = 3, label = _U('caststeel')},
			{ index = 11, label = _U('black_anth')},
			{ index = 12, label = _U('matteblack')},
			{ index = 15, label = _U('darknight')},
			{ index = 16, label = _U('deepblack')},
			{ index = 21, label = _U('oil')},
			{ index = 147, label = _U('carbon')}
		}
	elseif color == 'white' then
		colors = {
			{ index = 106, label = _U('vanilla')},
			{ index = 107, label = _U('creme')},
			{ index = 111, label = _U('white')},
			{ index = 112, label = _U('polarwhite')},
			{ index = 113, label = _U('beige')},
			{ index = 121, label = _U('mattewhite')},
			{ index = 122, label = _U('snow')},
			{ index = 131, label = _U('cotton')},
			{ index = 132, label = _U('alabaster')},
			{ index = 134, label = _U('purewhite')}
		}
	elseif color == 'grey' then
		colors = {
			{ index = 4, label = _U('silver')},
			{ index = 5, label = _U('metallicgrey')},
			{ index = 6, label = _U('laminatedsteel')},
			{ index = 7, label = _U('darkgray')},
			{ index = 8, label = _U('rockygray')},
			{ index = 9, label = _U('graynight')},
			{ index = 10, label = _U('aluminum')},
			{ index = 13, label = _U('graymat')},
			{ index = 14, label = _U('lightgrey')},
			{ index = 17, label = _U('asphaltgray')},
			{ index = 18, label = _U('grayconcrete')},
			{ index = 19, label = _U('darksilver')},
			{ index = 20, label = _U('magnesite')},
			{ index = 22, label = _U('nickel')},
			{ index = 23, label = _U('zinc')},
			{ index = 24, label = _U('dolomite')},
			{ index = 25, label = _U('bluesilver')},
			{ index = 26, label = _U('titanium')},
			{ index = 66, label = _U('steelblue')},
			{ index = 93, label = _U('champagne')},
			{ index = 144, label = _U('grayhunter')},
			{ index = 156, label = _U('grey')}
		}
	elseif color == 'red' then
		colors = {
			{ index = 27, label = _U('red')},
			{ index = 28, label = _U('torino_red')},
			{ index = 29, label = _U('poppy')},
			{ index = 30, label = _U('copper_red')},
			{ index = 31, label = _U('cardinal')},
			{ index = 32, label = _U('brick')},
			{ index = 33, label = _U('garnet')},
			{ index = 34, label = _U('cabernet')},
			{ index = 35, label = _U('candy')},
			{ index = 39, label = _U('matte_red')},
			{ index = 40, label = _U('dark_red')},
			{ index = 43, label = _U('red_pulp')},
			{ index = 44, label = _U('bril_red')},
			{ index = 46, label = _U('pale_red')},
			{ index = 143, label = _U('wine_red')},
			{ index = 150, label = _U('volcano')}
		}
	elseif color == 'pink' then
		colors = {
			{ index = 135, label = _U('electricpink')},
			{ index = 136, label = _U('salmon')},
			{ index = 137, label = _U('sugarplum')}
		}
	elseif color == 'blue' then
		colors = {
			{ index = 54, label = _U('topaz')},
			{ index = 60, label = _U('light_blue')},
			{ index = 61, label = _U('galaxy_blue')},
			{ index = 62, label = _U('dark_blue')},
			{ index = 63, label = _U('azure')},
			{ index = 64, label = _U('navy_blue')},
			{ index = 65, label = _U('lapis')},
			{ index = 67, label = _U('blue_diamond')},
			{ index = 68, label = _U('surfer')},
			{ index = 69, label = _U('pastel_blue')},
			{ index = 70, label = _U('celeste_blue')},
			{ index = 73, label = _U('rally_blue')},
			{ index = 74, label = _U('blue_paradise')},
			{ index = 75, label = _U('blue_night')},
			{ index = 77, label = _U('cyan_blue')},
			{ index = 78, label = _U('cobalt')},
			{ index = 79, label = _U('electric_blue')},
			{ index = 80, label = _U('horizon_blue')},
			{ index = 82, label = _U('metallic_blue')},
			{ index = 83, label = _U('aquamarine')},
			{ index = 84, label = _U('blue_agathe')},
			{ index = 85, label = _U('zirconium')},
			{ index = 86, label = _U('spinel')},
			{ index = 87, label = _U('tourmaline')},
			{ index = 127, label = _U('paradise')},
			{ index = 140, label = _U('bubble_gum')},
			{ index = 141, label = _U('midnight_blue')},
			{ index = 146, label = _U('forbidden_blue')},
			{ index = 157, label = _U('glacier_blue')}
		}
	elseif color == 'yellow' then
		colors = {
			{ index = 42, label = _U('yellow')},
			{ index = 88, label = _U('wheat')},
			{ index = 89, label = _U('raceyellow')},
			{ index = 91, label = _U('paleyellow')},
			{ index = 126, label = _U('lightyellow')}
		}
	elseif color == 'green' then
		colors = {
			{ index = 49, label = _U('met_dark_green')},
			{ index = 50, label = _U('rally_green')},
			{ index = 51, label = _U('pine_green')},
			{ index = 52, label = _U('olive_green')},
			{ index = 53, label = _U('light_green')},
			{ index = 55, label = _U('lime_green')},
			{ index = 56, label = _U('forest_green')},
			{ index = 57, label = _U('lawn_green')},
			{ index = 58, label = _U('imperial_green')},
			{ index = 59, label = _U('green_bottle')},
			{ index = 92, label = _U('citrus_green')},
			{ index = 125, label = _U('green_anis')},
			{ index = 128, label = _U('khaki')},
			{ index = 133, label = _U('army_green')},
			{ index = 151, label = _U('dark_green')},
			{ index = 152, label = _U('hunter_green')},
			{ index = 155, label = _U('matte_foilage_green')}
		}
	elseif color == 'orange' then
		colors = {
			{ index = 36, label = _U('tangerine')},
			{ index = 38, label = _U('orange')},
			{ index = 41, label = _U('matteorange')},
			{ index = 123, label = _U('lightorange')},
			{ index = 124, label = _U('peach')},
			{ index = 130, label = _U('pumpkin')},
			{ index = 138, label = _U('orangelambo')}
		}
	elseif color == 'brown' then
		colors = {
			{ index = 45, label = _U('copper')},
			{ index = 47, label = _U('lightbrown')},
			{ index = 48, label = _U('darkbrown')},
			{ index = 90, label = _U('bronze')},
			{ index = 94, label = _U('brownmetallic')},
			{ index = 95, label = _U('Expresso')},
			{ index = 96, label = _U('chocolate')},
			{ index = 97, label = _U('terracotta')},
			{ index = 98, label = _U('marble')},
			{ index = 99, label = _U('sand')},
			{ index = 100, label = _U('sepia')},
			{ index = 101, label = _U('bison')},
			{ index = 102, label = _U('palm')},
			{ index = 103, label = _U('caramel')},
			{ index = 104, label = _U('rust')},
			{ index = 105, label = _U('chestnut')},
			{ index = 108, label = _U('brown')},
			{ index = 109, label = _U('hazelnut')},
			{ index = 110, label = _U('shell')},
			{ index = 114, label = _U('mahogany')},
			{ index = 115, label = _U('cauldron')},
			{ index = 116, label = _U('blond')},
			{ index = 129, label = _U('gravel')},
			{ index = 153, label = _U('darkearth')},
			{ index = 154, label = _U('desert')}
		}
	elseif color == 'purple' then
		colors = {
			{ index = 71, label = _U('indigo')},
			{ index = 72, label = _U('deeppurple')},
			{ index = 76, label = _U('darkviolet')},
			{ index = 81, label = _U('amethyst')},
			{ index = 142, label = _U('mysticalviolet')},
			{ index = 145, label = _U('purplemetallic')},
			{ index = 148, label = _U('matteviolet')},
			{ index = 149, label = _U('mattedeeppurple')}
		}
	elseif color == 'chrome' then
		colors = {
			{ index = 117, label = _U('brushedchrome')},
			{ index = 118, label = _U('blackchrome')},
			{ index = 119, label = _U('brushedaluminum')},
			{ index = 120, label = _U('chrome')}
		}
	elseif color == 'gold' then
		colors = {
			{ index = 37, label = _U('gold')},
			{ index = 158, label = _U('puregold')},
			{ index = 159, label = _U('brushedgold')},
			{ index = 160, label = _U('lightgold')}
		}
	end
	return colors
end

CreateThread(function()
  while true do

    Wait(1)

    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)

      for k,v in pairs(Config.PoliceStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < 50.0 then
            DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < 50.0 then
            DrawMarker(Config.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.Vehicles, 1 do
          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < 50.0 then
            DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < 50.0 then
            DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end


        for i=1, #v.BossActions, 1 do
          if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < 50.0 then
            DrawMarker(Config.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
          end
        end

      end

    end

  end
end)

CreateThread(function()

  while true do

    Wait(0)

    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

      local playerPed      = GetPlayerPed(-1)
      local coords         = GetEntityCoords(playerPed)
      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config.PoliceStations) do

        for i=1, #v.Cloakrooms, 1 do
          if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
		end

        for i=1, #v.Armories, 1 do
          if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
          end
        end

        for i=1, #v.Vehicles, 1 do

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawner'
            currentPartNum = i
          end

          if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawnPoint'
            currentPartNum = i
          end

        end

        for i=1, #v.VehicleDeleters, 1 do
          if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleDeleter'
            currentPartNum = i
          end
        end


        for i=1, #v.BossActions, 1 do
          if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'BossActions'
            currentPartNum = i
          end
        end

      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

    end

  end
end)

CreateThread(function()

  local trackedEntities = {
    'prop_roadcone02a',
    'prop_barrier_work06a',
    'p_ld_stinger_s',
  }

  while true do

    Citizen.Wait(500)

    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)

    local closestDistance = -1
    local closestEntity   = nil

    for i=1, #trackedEntities, 1 do

      local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)

      if DoesEntityExist(object) then

        local objCoords = GetEntityCoords(object)
        local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)

        if closestDistance == -1 or closestDistance > distance then
          closestDistance = distance
          closestEntity   = object
        end

      end

    end

    if closestDistance ~= -1 and closestDistance <= 3.0 then

      if LastEntity ~= closestEntity then
        TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end

    else

      if LastEntity ~= nil then
        TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end

    end

  end
end)

AddEventHandler('esx_policejob:ishandcuffed', function(cb) cb(IsHandcuffed) end)
function isHandcuffed()
	return IsHandcuffed
end

CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and (GetGameTimer() - GUI.Time) > 150 and not exports['esx_policejob']:isHandcuffed() and not exports['esx_ambulancejob']:getDeathStatus() then

				if CurrentAction == 'menu_cloakroom' then
         			OpenCloakroomMenu()
				elseif CurrentAction == 'menu_armory' then
					OpenArmoryMenu(CurrentActionData.station)
				elseif CurrentAction == 'menu_vehicle_spawner' then
					OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
				elseif CurrentAction == 'delete_vehicle' then
					local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
					TriggerServerEvent('esx_society:putVehicleInGarage', 'police', vehicleProps)
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
					ESX.ShowAdvancedNotification('~b~SAST Centrala', '~g~Chowasz radiowóz','Rejestracja: ' ..vehicleProps.plate, 'CustomLogo', 2)
				elseif PlayerData.job.name == 'police' and CurrentAction == 'menu_boss_actions' then
					OpenManageMenu()
				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end
				
				CurrentAction = nil
				GUI.Time      = GetGameTimer()
			end
		end -- CurrentAction end
		
		if IsControlPressed(0, Keys['F6']) and not isDead and not IsHandcuffed and PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') and (GetGameTimer() - GUI.Time) > 150 then
			OpenPoliceActionsMenu()
			GUI.Time = GetGameTimer()
		end
		
		if IsControlPressed(0, Keys['E']) and CurrentTask.Busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(CurrentTask.Task)
			ClearPedTasks(GetPlayerPed(-1))
			
			CurrentTask.Busy = false
		end
	end
end)

function OpenManageMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {
		{ label = 'Akcje Szefa', value = 'bossmenu'},
	}

	if PlayerData.job.grade >= 9 then
		table.insert(elements, { label = 'Odznaki', value = 'badgemenu'})
		table.insert(elements, { label = 'Zarządzaj licencjami', value = 'licenses'})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_action_menu',
    {
        title    = 'Zarządzanie',
        align    = 'center',
        elements = elements

	}, function(data, menu)
        if data.current.value == 'bossmenu' then
			local opt = {
				withdraw  = true,
				deposit   = true,
				wash      = false,
				employees = true,
				grades    = false
			}
			if PlayerData.job.grade < 9 then 
				opt.employees = false
			end
			
			if PlayerData.job.grade < 9 then 
				opt.accounts = false
			end

			if PlayerData.job.grade < 9 then 
				opt.withdraw = false
			end
			TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
				menu.close()
				CurrentAction     = 'menu_boss_actions'
				CurrentActionMsg  = _U('open_bossmenu')
				CurrentActionData = {}
			end, opt)
        elseif data.current.value == 'badgemenu' then
			menu.close()
			BadgeMenu()
		elseif data.current.value == 'licenses' then
			menu.close()
			OpenLicensesMenu('police')
        end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenLicensesMenu(society)
	ESX.TriggerServerCallback('esx_society:getEmployeeslic', function(employees)
		local elements = nil
		local identifier = ''

		elements = {
			head = {"Pracownik", "SEU", "HELI", "FTO", "AIAD", "SWAT", "Akcje"},
			rows = {}
		}

		for i=1, #employees, 1 do
			local licki = {}
			if employees[i].licensess.seu == true then
				licki[1] = '✔️'
			else
				licki[1] = "❌"
			end
			if employees[i].licensess.heli == true then
				licki[2] = '✔️'
			else
				licki[2] = "❌"
			end
			if employees[i].licensess.fto == true then
				licki[3] = '✔️'
			else
				licki[3] = "❌"
			end
			if employees[i].licensess.aiad == true then
				licki[4] = '✔️'
			else
				licki[4] = "❌"
			end
			if employees[i].licensess.swat == true then
				licki[5] = '✔️'
			else
				licki[5] = "❌"
			end				
				
			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					licki[1],
					licki[2],
					licki[3],
					licki[4],
					licki[5],
					'{{' .. "Nadaj Licencję" .. '|give}} {{' .. "Odbierz Licencję" .. '|take}}'
				}
			})
		end


		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'give' then
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'licka', {
					title = 'Licencje Jednostek'
				}, function(data2, menu2)
					local amount = data2.value
					local wartosc = ''
					if amount == nil then
						ESX.ShowNotification('Podaj nazwę licencji')
						return
					elseif amount == 'seu' then
						wartosc = 'police_seu'
					elseif amount == 'heli' then
						wartosc = 'police_heli' 
					elseif amount == 'fto' then
						wartosc = 'police_fto'
					elseif amount == 'aiad' then
						wartosc = 'police_aiad'
					elseif amount == 'swat' then
						wartosc = 'police_swat'
					else
						ESX.ShowNotification('Nie podałeś prawidłowej nazwy licencji<br>Spis prawdidłowych lecencji:<br>1. swat<br>2. ocean<br>3. air<br>4. seuoffroad<br>5. seu')
						return
					end

					TriggerServerEvent('esx_policejob:addlicense', employee.identifier, wartosc)
					ESX.ShowNotification('Licencja: '..amount)
					
					menu2.close()
				end, function(data2, menu2)
					menu2.close()
				end)
			elseif data.value == 'take' then
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'licka', {
					title = 'Licencje Jednostek'
				}, function(data3, menu3)
					local amount = data3.value
					local wartosc = ''
					
					if amount == nil then
						ESX.ShowNotification('Podaj nazwę licencji')
						return
					elseif amount == 'seu' then
						wartosc = 'police_seu'
					elseif amount == 'heli' then
						wartosc = 'police_heli' 
					elseif amount == 'fto' then
						wartosc = 'police_fto'
					elseif amount == 'aiad' then
						wartosc = 'police_aiad'
					elseif amount == 'swat' then
						wartosc = 'police_swat'
					else
						ESX.ShowNotification('Nie podałeś prawidłowej nazwy licencji<br>Spis prawdidłowych lecencji:<br>1. swat<br>2. ocean<br>3. air<br>4. seuoffroad<br>5. seu')
						return
					end
					
					TriggerServerEvent('esx_policejob:removelicense', employee.identifier, wartosc)
					ESX.ShowNotification('Licencja: '..amount)
					
					menu3.close()

			
				end, function(data3, menu3)
					menu3.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, 'police', society)
end

BadgeMenu = function()
	ESX.TriggerServerCallback('esx_policejob:badgeList', function(data)
		local elements = {
			head = {'Funkcjonariusz', 'Numer Odznaki', 'Akcje'},
			rows = {}
		}
	
		for i=1, #data, 1 do
		  local characterName = data[i].name
		  local fullBadge = 'Brak odznaki'

		  if data[i].badge.number == nil then
		  else
		  if data[i].badge.number >= 1 then
			fullBadge = data[i].badge.label .. ' ' .. data[i].badge.number
		  end
		end
		  table.insert(elements.rows, {
			  data = data[i], 
			  cols = {
				  characterName, 
				  fullBadge, 
				  '{{' .. 'Nadaj' .. '|give}} {{' .. 'Usuń' .. '|remove}}'
				}
		  	})
		end
	
		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'badge_list', elements, function(data, menu)
			local cop = data.data
			local copName = cop.name
			local badgeNumber = nil
			local badgeName = nil
	
		  	if data.value == 'give' then
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'setBadge1',
				{
					title = 'Podaj nazwę odznaki np. XRAY',
				}, function(data2, menu2)
					badgeName = data2.value
				
					if badgeName == nil then
						ESX.ShowNotification('~r~Nieprawidłowa nazwa odznaki')
					else
						menu2.close()
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'setBadge2',
						{
							title = 'Podaj numer odznaki',
						}, function(data3, menu3)
							badgeNumber = data3.value
				
							if badgeNumber == nil then
								ESX.ShowNotification('~r~Nieprawidłowy numer odznaki')
							else
								menu3.close()
								TriggerServerEvent('esx_policejob:setBadge', cop.identifier, copName, badgeNumber, badgeName)
							end
						end, function(data3, menu3)
							menu3.close()
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
		  	elseif data.value == 'remove' then
				TriggerServerEvent('esx_policejob:removeBadge', cop.identifier, copName)
				menu.close()
		  	end
		end, function(data, menu)
		  	menu.close()
		end)
	end, 'police')
end


function createBlip(id)
	ped = GetPlayerPed(id)
	blip = GetBlipFromEntity(ped)
	
	if not DoesBlipExist(blip) then
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true)
		SetBlipRotation(blip, math.ceil(GetEntityHeading(veh)))
		SetBlipNameToPlayerName(blip, id)
		SetBlipScale(blip, 0.9)
		SetBlipColour (blip, 30)
		SetBlipAsShortRange(blip, true)
		
		table.insert(blipsCops, blip)
	end
end

RegisterNetEvent('esx_policejob:updateBlip')
AddEventHandler('esx_policejob:updateBlip', function()
	
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end
	
	blipsCops = {}
	
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
			for i=1, #players, 1 do
				if players[i].job.name == 'police' then
					for id = 0, 100 do
						if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1) and GetPlayerName(id) == players[i].name then
							createBlip(id)
						end
					end
				end
			end
		end)
	end

end)


AddEventHandler('playerSpawned', function(spawn)
	isDead = false

	TriggerEvent('esx_policejob:unrestrain')
	if not hasAlreadyJoined then
		TriggerServerEvent('esx_policejob:duty', false)
		TriggerServerEvent('esx_policejob:spawned')
		TriggerEvent('duty:boats')
		hasAlreadyJoined = true
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_policejob:unrestrain')
	end
end)

function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and HandcuffTimer then
		ESX.ClearTimeout(HandcuffTimer)
	end

	HandcuffTimer = ESX.SetTimeout(Config.HandcuffTimer, function()
	ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_policejob:unrestrain')
	end)
end


function ImpoundVehicle(vehicle)
	ESX.Game.DeleteVehicle(vehicle) 
	ESX.ShowNotification(_U('impound_successful'))
	CurrentTask.Busy = false
end

RegisterNetEvent('esx_policejob:binoculars')
AddEventHandler('esx_policejob:binoculars', function()
	Binoculars = not Binoculars
end)

CreateThread(function()
	while true do
		if Binoculars then
			Citizen.Wait(10)

			local lPed = PlayerPedId()
			if not IsPedSittingInAnyVehicle(lPed) then
				CreateThread(function()
					TaskStartScenarioInPlace(lPed, "WORLD_HUMAN_BINOCULARS", 0, 1)
					PlayAmbientSpeech1(lPed, "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
				end)
			end

			Citizen.Wait(1500)
			SetTimecycleModifier("default")
			SetTimecycleModifierStrength(0.3)

			local scaleform = RequestScaleformMovie("BINOCULARS")
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(10)
			end

			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
			AttachCamToEntity(cam, lPed, 0.0, 0.0, 1.0, true)
			SetCamRot(cam, 0.0, 0.0, GetEntityHeading(lPed))
			SetCamFov(cam, FOV)

			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(1)
			PopScaleformMovieFunctionVoid()

			ESX.UI.HUD.SetDisplay(0.0)
			TriggerEvent('es:setMoneyDisplay', 0.0)
			TriggerEvent('esx_status:setDisplay', 0.0)
			TriggerEvent('esx_voice:setDisplay', 0.0)
			TriggerEvent('radar:setHidden', false)
			TriggerEvent('chat:display', false)
			TriggerEvent('carhud:display', false)
			TriggerEvent('dzwonixon:display', false)

			local vehicle = GetVehiclePedIsIn(lPed)
			while Binoculars and not IsEntityDead(lPed) and GetVehiclePedIsIn(lPed) == vehicle do
				if IsControlJustPressed(0, Keys["BACKSPACE"]) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ClearPedTasks(PlayerPedId())
					break
				end

				local zoomvalue = (1.0 / (70.0 - 5.0)) * (FOV - 5.0)
				CheckInputRotation(cam, zoomvalue)

				HandleZoom(cam)
				HideHUDThisFrame()

				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Citizen.Wait(0)
			end

			ESX.UI.HUD.SetDisplay(1.0)
			TriggerEvent('es:setMoneyDisplay', 1.0)
			TriggerEvent('esx_status:setDisplay', 1.0)
			TriggerEvent('esx_voice:setDisplay', 1.0)
			TriggerEvent('radar:setHidden', false)
			TriggerEvent('chat:display', true)
			TriggerEvent('carhud:display', true)
			TriggerEvent('dzwonixon:display', true)

			Binoculars = false
			ClearTimecycleModifier()
			FOV = (70.0 + 5.0) * 0.5

			RenderScriptCams(false, false, 0, 1, 0)
			SetScaleformMovieAsNoLongerNeeded(scaleform)

			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		else
			Citizen.Wait(250)
		end
	end
end)

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)

	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX * -1.0 * 8.0 * (zoomvalue + 0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * 8.0 * (zoomvalue + 0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	if not IsPedSittingInAnyVehicle(PlayerPedId()) then
		if IsControlJustPressed(0, 241) then
			FOV = math.max(FOV - 10.0, 5.0)
		end

		if IsControlJustPressed(0, 242) then
			FOV = math.min(FOV + 10.0, 70.0)
		end

		local current_fov = GetCamFov(cam)
		if math.abs(FOV - current_fov) < 0.1 then
			FOV = current_fov
		end

		SetCamFov(cam, current_fov + (FOV - current_fov) * 0.05)
	else
		if IsControlJustPressed(0, 17) then
			FOV = math.max(FOV - 10.0, 5.0)
		end

		if IsControlJustPressed(0,16) then
			FOV = math.min(FOV + 10.0, 70.0)
		end

		local current_fov = GetCamFov(cam)
		if math.abs(FOV - current_fov) < 0.1 then
			FOV = current_fov
		end

		SetCamFov(cam, current_fov + (FOV - current_fov) * 0.05)
	end
end

function DrawAdvancedText(x, y, w, h, sc, text, r, g, b, a, font, jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end


RegisterNetEvent('duty:boats')
AddEventHandler('duty:boats', function()
    boatxdd()
end)

function boatxdd()
	if Config.EnableBoatGarageBlip == true and PlayerData.job ~= nil and (PlayerData.job.name == 'police') then
		for k,v in pairs(Config.BoatZones) do
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				SetBlipSprite(blip, 427)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.65)
				SetBlipColour (blip, 38)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Policyjne Łódki")
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end

local insideMarker = false


function DrawAdvancedText(x, y, w, h, sc, text, r, g, b, a, font, jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

CreateThread(function()
	while true do
		if radar.shown then
			local pPed = GetPlayerPed(-1)
			veh = GetVehiclePedIsIn(pPed, false)
		end
		Citizen.Wait(5000)
	end
end)

CreateThread(function()
	while true do
		if radar.shown then
			local coordA = GetOffsetFromEntityInWorldCoords(veh, 0.0, 1.0, 1.0)
			local coordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, 105.0, 0.0)
			local frontcar = StartShapeTestCapsule(coordA, coordB, 3.0, 10, veh, 7)
			a, b, c, d, e = GetShapeTestResult(frontcar)
			if IsEntityAVehicle(e) then
				fmodel = GetDisplayNameFromVehicleModel(GetEntityModel(e))
				fvspeed = GetEntitySpeed(e)*3.6
				fplate = GetVehicleNumberPlateText(e)
			end
			local bcoordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, -105.0, 0.0)
			local rearcar = StartShapeTestCapsule(coordA, bcoordB, 3.0, 10, veh, 7)
			f, g, h, i, j  = GetShapeTestResult(rearcar)
			if IsEntityAVehicle(j) then
				bmodel = GetDisplayNameFromVehicleModel(GetEntityModel(j))
				bvspeed = GetEntitySpeed(j)*3.6
				bplate = GetVehicleNumberPlateText(j)
			end
		end
		Citizen.Wait(500)
	end
end)

CreateThread( function()
	while true do
		Citizen.Wait(5)
		if IsControlJustPressed(1, 157) and IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
			if radar.shown then
				radar.shown = false
			elseif not radar.shown then
				radar.shown = true
			end
            Citizen.Wait(200)
		end
		if IsControlJustPressed(1, 158) and IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
			if radar.freeze then 
				radar.freeze = false
			else 
				radar.freeze = true
			end
		end
		if radar.freeze then
			DrawAdvancedText(0.591, 0.833, 0.005, 0.0028, 0.40, "~r~Zatrzymano radar ([2] Aby Odblokować) ", 0, 191, 255, 255, 6, 0)
		end
		if radar.shown then
			if radar.freeze == false then
				if IsEntityAVehicle(e) then
					radar.frontPlate = fplate
					radar.frontModel = fmodel
					radar.info = string.format("~y~Nr rej..: ~w~%s  ~y~Model: ~w~%s  ~y~Prędkość: ~w~%s km/h", fplate, fmodel, math.ceil(fvspeed))
				end
				if IsEntityAVehicle(j) then
					radar.backPlate = bplate
					radar.backModel = bmodel
					radar.info2 = string.format("~y~Nr rej..: ~w~%s  ~y~Model: ~w~%s  ~y~Prędkość: ~w~%s km/h", bplate, bmodel, math.ceil(bvspeed))				
				end
			end
			if IsControlJustPressed(1, 164) then
				TriggerServerEvent('radar:checkVehicle', radar.frontPlate, radar.frontModel)
			end
			if IsControlJustPressed(1, 165) then
				TriggerServerEvent('radar:checkVehicle', radar.backPlate, radar.backModel)
			end	
			DrawAdvancedText(0.591, 0.863, 0.005, 0.0028, 0.35, "RADAR - Front ([4] aby sprawdzić bazę)", 0, 191, 255, 255, 6, 0)
			DrawAdvancedText(0.591, 0.884, 0.005, 0.0028, 0.35, radar.info, 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.591, 0.913, 0.005, 0.0028, 0.35, "RADAR - Tył ([5] aby sprawdzić bazę)", 0, 191, 255, 255, 6, 0)
			DrawAdvancedText(0.591, 0.934, 0.005, 0.0028, 0.35, radar.info2, 255, 255, 255, 255, 6, 0)
		end
		if(not IsPedInAnyVehicle(GetPlayerPed(-1))) then
			radar.shown = false
			radar.freeze = false
		end
	end
end)

function PoliceGarage(type)
	local elements = {
		{ label = "Przechowaj Pojazd", action = "store_vehicle" },
		{ label = "Wyciągnij Pojazd", action = "get_vehicle" },
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeGarage_menu",
		{
			title    = "Garaż",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		menu.close()
		local action = data.current.action
		if action == "get_vehicle" then
			if type == 'car' then
				VehicleMenu('car')
			elseif type == 'helicopter' then
				VehicleMenu('helicopter')
			elseif type == 'boat' then
				VehicleMenu('boat')
			end
		elseif data.current.action == 'store_vehicle' then
			local veh,dist = ESX.Game.GetClosestVehicle(playerCoords)
			if dist < 3 then
				DeleteEntity(veh)
			ESX.ShowNotification("~b~Pojazd Zaparkowany")
			else
			ESX.ShowNotification("~r~Nie znajdujesz się w pojeździe")
			end
			insideMarker = false
		end
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end, function(data, menu)
	end)
end

VehicleMenu = function(type)
	local storage = nil
	local elements = {}
	local ped = GetPlayerPed(-1)
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(ped)
	
	if type == 'car' then
		for k,v in pairs(Config.PoliceVehicles) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, type = 'car'})
		end
	elseif type == 'helicopter' then
		for k,v in pairs(Config.Helicopters) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, type = 'helicopter'})
		end
	elseif type == 'boat' then
		for k,v in pairs(Config.Boats) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, type = 'boat'})
		end
	end
		
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_policeGarage_vehicle_garage",
		{
			title    = Config.TitlePoliceGarage,
			align    = "center",
			elements = elements
		},
	function(data, menu)
		menu.close()
		insideMarker = false
		local plate = exports['esx_vehicleshop']:GeneratePlate()
		VehicleLoadTimer(data.current.model)
		local veh = CreateVehicle(data.current.model,pos.x,pos.y,pos.z,GetEntityHeading(playerPed),true,false)
		SetPedIntoVehicle(GetPlayerPed(-1),veh,-1)
		SetVehicleNumberPlateText(veh,plate)
		
		if type == 'car' then
			ESX.ShowNotification("~b~Wyciągnąłeś pojazd z garażu")
		elseif type == 'helicopter' then
			ESX.ShowNotification("~b~Wyciągnąłeś helikopter z garażu.")
		elseif type == 'boat' then
			ESX.ShowNotification("~b~Wyciągnąłeś łódkę z garażu.")
		end
		
		TriggerEvent("fuel:setFuel",veh,100.0)
		SetVehicleDirtLevel(veh, 0.1)		
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end, function(data, menu)
	end)
end

function VehicleLoadTimer(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)

			drawLoadingText("~g~Oczekuj na załadowanie modelu", 255, 255, 255, 255)
		end
	end
end

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end



function OpenExtraMenu()
	local elements = {}
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) 

			if state then
				table.insert(elements, {
					label = "Extra: "..id.." | "..('<span style="color:green;">%s</span>'):format("Włączone"),
					value = id,
					state = not state
				})
			else
				table.insert(elements, {
					label = "Extra: "..id.." | "..('<span style="color:red;">%s</span>'):format("Wyłączone"),
					value = id,
					state = not state
				})
			end
		end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extra_actions', {
		title    = "Dodatki",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		SetVehicleExtra(vehicle, data.current.value, not data.current.state)
		local newData = data.current
		if data.current.state then
			newData.label = "Extra: "..data.current.value.." | "..('<span style="color:green;">%s</span>'):format("Włączone")
		else
			newData.label = "Extra: "..data.current.value.." | "..('<span style="color:red;">%s</span>'):format("Wyłączone")
		end
		newData.state = not data.current.state

		menu.update({value = data.current.value}, newData)
		menu.refresh()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenLiveryMenu()
	local elements = {}
	
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
	local liveryCount = GetVehicleLiveryCount(vehicle)
			
	for i = 1, liveryCount do
		local state = GetVehicleLivery(vehicle) 
		local text
		
		if state == i then
			text = "Livery: "..i.." | "..('<span style="color:green;">%s</span>'):format("Włączone")
		else
			text = "Livery: "..i.." | "..('<span style="color:red;">%s</span>'):format("Wyłączone")
		end
		
		table.insert(elements, {
			label = text,
			value = i,
			state = not state
		}) 
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'livery_menu', {
		title    = "Kolory",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		SetVehicleLivery(vehicle, data.current.value, not data.current.state)
		local newData = data.current
		if data.current.state then
			newData.label = "Livery: "..data.current.value.." | "..('<span style="color:green;">%s</span>'):format("Włączone")
		else
			newData.label = "Livery: "..data.current.value.." | "..('<span style="color:red;">%s</span>'):format("Wyłączone")
		end
		newData.state = not data.current.state
		menu.update({value = data.current.value}, newData)
		menu.refresh()
		menu.close()	
	end, function(data, menu)
		menu.close()		
	end)
end

function OpenMainMenu()
	local elements = {
		{label = "Pierwszy",value = 'primary'},
		{label = "Drugi",value = 'secondary'},
		{label = "Dodatki",value = 'extra'},
		{label = "Kolory",value = 'livery'}
	}
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'color_menu', {
		title    = "Dodatki",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'extra' then
			OpenExtraMenu()
		elseif data.current.value == 'livery' then
			OpenLiveryMenu()
		elseif data.current.value == 'primary' then
			OpenMainColorMenu('primary')
		elseif data.current.value == 'secondary' then
			OpenMainColorMenu('secondary')
		end
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end)
end

function OpenMainColorMenu(colortype)
	local elements = {}
	for k,v in pairs(Config.Colors) do
		table.insert(elements, {
			label = v.label,
			value = v.value
		})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'main_color_menu', {
		title    = "Kolor",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		OpenColorMenu(data.current.type, data.current.value, colortype)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenColorMenu(type, value, colortype)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extra_actions', {
		title    = "Wartość",
		align    = 'center',
		elements = GetColors(value)
	}, function(data, menu)
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local pr,sec = GetVehicleColours(vehicle)
		if colortype == 'primary' then
			SetVehicleColours(vehicle, data.current.index, sec)
		elseif colortype == 'secondary' then
			SetVehicleColours(vehicle, pr, data.current.index)
		end
		
	end, function(data, menu)
		menu.close()
	end)
end

CreateThread(function ()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.Dzwonek) do
            if GetDistanceBetweenCoords(coords, v.Coords.x, v.Coords.y, v.Coords.z, true) < 3 then
                local location = v
                DrawText3D(v.Coords.x, v.Coords.y, v.Coords.z - 1.0, _U('pageFloatingText'))
				if IsControlJustReleased(1, 119) then
					SendSignaldzown()
                end
			end
		end
	end
end)

local lastGameTimerDzwonek = 0

function SendSignaldzown()
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			  local data = {
				number = 'police',
				message = 'Pilnie wzywana jest jednostka SAST na Recepcję Mission Row'
			}
			if GetGameTimer() > lastGameTimerDzwonek then
			TriggerEvent('Island-alert:callNumberD', data)
			lastGameTimerDzwonek = GetGameTimer() + 300000
			else
				TriggerEvent("chatMessage", "^1[SAST]> ", {255, 255, 0}, "Nie możesz tak często klikac dzwonka!")
			end
end

function DrawText3D(x,y,z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local p = GetGameplayCamCoords()
	local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
	local scale = (1 / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
	if onScreen then
		  SetTextScale(0.35, 0.35)
		  SetTextFont(4)
		  SetTextProportional(1)
		  SetTextColour(255, 255, 255, 215)
		  SetTextEntry("STRING")
		  SetTextCentre(1)
		  AddTextComponentString(text)
		  DrawText(_x,_y)
		  local factor = (string.len(text)) / 370
		  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
	  end
end


CreateThread(function()	
    while true do
		Citizen.Wait(5)	

		local playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(playerPed, true)		
		for k,v in pairs(Config.RepairVeh) do
			if not fixing then
				if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 100) then
					if IsPedInAnyVehicle(playerPed, false) and not exports['esx_ambulancejob']:getDeathStatus() or exports['esx_policejob']:isHandcuffed() then
						DrawMarker(1, v.x, v.y, v.z-0.4, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 255, 153, 51, false, false, 2, false, false, false, false)
						if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 1.5) then							
							position = k
								hintToDisplay('Nacisnij ~INPUT_PICKUP~ aby naprawić pojazd.')
								if IsControlJustPressed(0, 38) then	
									TriggerEvent('esx_policejob:fixCar')						
									SetPedCoordsKeepVehicle(playerPed, v.x, v.y, v.z)
								end																							
						end
					end
				end
			else		
				if position == k then

				else
				end
			end
		end
    end
end)
RegisterNetEvent('esx_policejob:markAnimation')
AddEventHandler('esx_policejob:markAnimation', function()
    while true do
		Citizen.Wait(25)	
		if fixing then
			if zcoords < 0.5 and not turn then
				zcoords = zcoords + 0.03
				mcolor = mcolor + 2
			else
				turn = true
				zcoords = zcoords - 0.051
				mcolor = mcolor + 2
				if zcoords <= -0.4 then
					turn = false
				end
			end
		else
			break
		end
	end
end)
RegisterNetEvent('esx_policejob:fixCar')
AddEventHandler('esx_policejob:fixCar', function()
	local playerPed = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	fixing = true
	TriggerEvent('esx_policejob:markAnimation')	
	FreezeEntityPosition(vehicle, true)
	sendNotification('Naprawianie w trakcie, poczekaj chwile...', 'warning', 5000 -1)
	Wait(5000)
	fixing = false
	SetVehicleFixed(vehicle)
	SetVehicleDeformationFixed(vehicle)
	FreezeEntityPosition(vehicle, false)
	hintToDisplay('~g~Pojazd został naprawiony!')
	zcoords, mcolor, turn = 0.0, 0, false
end)
function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "katalog",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end