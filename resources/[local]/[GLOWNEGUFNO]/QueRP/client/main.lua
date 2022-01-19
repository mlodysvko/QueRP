ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

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
local WorldName = 'alpha' -- //global/config
local IslandGlobal = GetCurrentResourceName()

local noClipSpeeds =  "noclip speeds"
local noClip = false
local noClipSpeed = 1
local noClipLabel = nil
local IslandLoaded = false
local LoadGtaOutils = false
local getcall = exports['mumble-voip']:GetPlayerCallChannel()
local gettingdebug = false
local removedConnect = false
local GlobalExports = false
local allowed = true

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

AddEventHandler('esx:playerLoaded', function()
	IslandLoaded = true
	LoadGtaOutils = true
	noClip = false
	TriggerServerEvent("Island:SendJoin")
	Citizen.Wait(1000)
	if allowed == true and PlayerData.job.name == 'police' then
		TriggerServerEvent('Island:GetJobsLicense')
	elseif allowed == true and PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'mecano' then
		TriggerServerEvent('Island:GetJobsDuty')
	elseif allowed == true and PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'mecano' then
		TriggerServerEvent('IslandGetJobsInsuraceEMS')
		TriggerServerEvent('IslandGetJobsInsuraceLSC')
	end
end)


CreateThread(function()
	--[[while true do 
		Citizen.Wait(5000)
		exports['esx_tattoos']:refresh()
	end
	while true do
		Citizen.Wait(5000)
		exports['esx_weaponsync']:RebuildLoadout()
	end]]
	while true do 
		Citizen.Wait(40000)
		TriggerServerEvent('Island:weaponchecking')
		TriggerServerEvent("Island:CheckPing")
	end
	NetworkSetVoiceChannel(99999)
	MumbleClearVoiceTarget()
	exports['mumble-voip']:removePlayerFromRadio()
	exports['mumble-voip']:removePlayerFromCall()
	while not IslandLoaded do
		if WorldName == 'default' or 'lspd' or 'alpha' or 'testowy' and "QueRP" ~= IslandGlobal then
			Citizen.Wait(200)
			NetworkSetVoiceChannel(99999)
			Citizen.Wait(10)
			NetworkSetTalkerProximity(3.5 + 0.0)
			if getcall and "QueRPRP" ~= IslandGlobal and WorldName == 'default' or 'lspd' or 'alpha' or 'testowy' then
				if gettingdebug == true then print(getcall) else print(WorldName,'; end') end
			else
				print(Worldname, ' Not in call')
			end
		end
	end
	
	if GlobalExports == true then
		function FreezeVehicle()
			FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), true), true)
		end
		function FreezePed()
			FreezeEntityPosition(PlayerPedId(), true)
		end
		function ClearTask()
			ClearPedTasksImmediately(PlayerPedId())
		end
		function UnFreezeVehicle()
			FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
		end
		function UnFreezePed()
			FreezeEntityPosition(PlayerPedId(), false)
		end
	end

	while LoadGtaOutils do
		Citizen.Wait(1)
		if not pausing and IsPauseMenuActive() then
			local PlayerData = ESX.GetPlayerData()
			for _, account in ipairs(PlayerData.accounts) do
				if account.name == 'bank' then
					StatSetInt("BANK_BALANCE", account.money, true)
					break
				end
			end

			StatSetInt("MP0_WALLET_BALANCE", PlayerData.money, true)
			pausing = true
		elseif pausing and not IsPauseMenuActive() then
			pausing = false
		end
	end
	IslandLoaded = nil
	NetworkClearVoiceChannel()
	MumbleIsConnected()
	NetworkSetTalkerProximity(3.5 + 0.0)
	print("Voice: Loaded")		
end)

CreateThread(function()
	while true do 
		Citizen.Wait(1)
		local inVehicle = IsPedInAnyVehicle(ped, false)
        local cc, cv = Config.Density.CitizenDefault, Config.Density.VehicleDefault
        if inVehicle then
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if GetPedInVehicleSeat(vehicle, -1) ~= ped then
                cc, cv = Config.Density.CitizenPassengers, Config.Density.VehiclePassengers
                if DisableShuffle and GetPedInVehicleSeat(vehicle, 0) == ped and GetIsTaskActive(ped, 165) then
                    SetPedIntoVehicle(ped, vehicle, 0)
                end
            else
                cc, cv = Config.Density.CitizenDriver, Config.Density.VehicleDriver
            end
        end
        

        if Config.AdjustDensity then
            SetPedDensityMultiplierThisFrame(cc)
            SetScenarioPedDensityMultiplierThisFrame(cc, cc)

            SetVehicleDensityMultiplierThisFrame(cv)
            SetRandomVehicleDensityMultiplierThisFrame(cv)
            SetParkedVehicleDensityMultiplierThisFrame(cv)
        end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(1)
		if Citizen.InvokeNative(0x997ABD671D25CA0B, (GetPlayerPed(-1))) then
			if Citizen.InvokeNative(0xBB40DD2270B65366, car, -1) == GetPlayerPed(-1) then
				Citizen.InvokeNative(0x6E8834B52EC20C77, PlayerId(), false)
			else
				Citizen.InvokeNative(0x6E8834B52EC20C77, PlayerId(), false)
			end
		end
		if WorldName == 'alpha' then
			if IsControlJustReleased(0, Keys[',']) then
				OpenBetaMenu()
			end
		elseif WorldName == 'default' or 'lspd' and "IslandRP" ~= IslandGlobal then
			CreateThread(function()
				local LastAim
				while true do
					Citizen.Wait(1)
					local sleep = true
					local playerPed = PlayerPedId()
					if DoesEntityExist(playerPed) then
						if IsPedArmed(playerPed, 4) then
							sleep = false
							local isAiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
							if isAiming and targetPed ~= LastAim then
								LastAim = targetPed
								if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) then
									if IsPedAPlayer(targetPed) then
										local targetId = NetworkGetPlayerIndexFromPed(targetPed)
										if targetId then											
											if pedId and (pedId > 0) then
												TriggerServerEvent('Fuckmedaddy:log', GetPlayerServerId(targetId))
											end
										end
									end
								end
							end
						end
					end
					if sleep then
						Wait(1000)
					end
				end 
			end)
		end
	end
end)

local blackout = false


CreateThread(function()
	while true do
		if noClip then
			local noclipEntity = PlayerPedId()
			if IsPedInAnyVehicle(noclipEntity, false) then
				local vehicle = GetVehiclePedIsIn(noclipEntity, false)
				if GetPedInVehicleSeat(vehicle, -1) == noclipEntity then
					noclipEntity = vehicle
				else
					noclipEntity = nil
				end
			end

			FreezeEntityPosition(noclipEntity, true)
			SetEntityInvincible(noclipEntity, true)

			DisableControlAction(0, 31, true)
			DisableControlAction(0, 30, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 20, true)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 33, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 35, true)

			local yoff = 0.0
			local zoff = 0.0
			if IsControlJustPressed(0, 21) then
				noClipSpeed = noClipSpeed + 1
				if noClipSpeed > #noClipSpeeds then
					noClipSpeed = 1
				end

			end

			if IsDisabledControlPressed(0, 32) then
				yoff = 0.25;
			end

			if IsDisabledControlPressed(0, 33) then
				yoff = -0.25;
			end

			if IsDisabledControlPressed(0, 34) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 2.0)
			end

			if IsDisabledControlPressed(0, 35) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 2.0)
			end

			if IsDisabledControlPressed(0, 44) then
				zoff = 0.1;
			end

			if IsDisabledControlPressed(0, 20) then
				zoff = -0.1;
			end

			local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (noClipSpeed + 0.3), zoff * (noClipSpeed + 0.3))

			local heading = GetEntityHeading(noclipEntity)
			SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
			SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
			SetEntityHeading(noclipEntity, heading)

			SetEntityCollision(noclipEntity, false, false)
			SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)
			Citizen.Wait(0)

			FreezeEntityPosition(noclipEntity, false)
			SetEntityInvincible(noclipEntity, false)
			SetEntityCollision(noclipEntity, true, true)
		else
			Citizen.Wait(200)
		end
	end
end)
--[[
function OpenBetaMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'Beta',
        {
			align    = 'center',
            title    = 'BETA TESTY - QueRP',
            elements = {
			    {label = 'Teleportuj do znacznika', value = '1'},
                {label = 'Noclip', value = '2'},
                {label = 'Revive', value = '3'},
                {label = 'Heal', value = '4'},
                {label = 'Zabij się', value = '5'},
                {label = 'Dodaj armor', value = '6'},
                {label = 'Dodaj auto do garażu', value = '7'},
                {label = 'Usuń pojazd', value = '8'},
                {label = 'Napraw pojazd', value = '12'},
                {label = 'Obróć pojazd', value = '9'},
                {label = 'Tuninguj pojazd', value = '10'},
                {label = 'Extras Menu LSPD', value = '11'},
				{label = 'Dodaj Broń', value = 'weapon_pistol'},
				{label = 'Dodaj GPS', value = 'gps'},
				{label = 'Dodaj Radio', value = 'radio'},
				{label = 'Dodaj Kajdanki', value = 'handcuffs'},
				{label = 'Dodaj pieniądze sobie 5MLN', value = 'kaska'},
            },
        },
        function(data, menu)
			if data.current.value == '1' then
                local WaypointHandle = GetFirstBlipInfoId(8)
                if DoesBlipExist(WaypointHandle) then
                    local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                    for height = 1, 1000 do
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        if foundGround then
                            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                            break
                        end

                        Citizen.Wait(5)
                    end

                    TriggerEvent("esx:showNotification","Przeteleportowano.")
                else
                    TriggerEvent("esx:showNotification","Zaznacz na mapie teleport.")
                end
            elseif data.current.value == '2' then
                if item == thisItem then
                    noClip = not noClip
                    if not noClip then
                        noClipSpeed = 1
                    end
                end
            elseif data.current.value == '3' then
                TriggerEvent('esx_ambulancejob:revive', source)
            elseif data.current.value == '4' then
                TriggerEvent('esx_basicneeds:healPlayer', source)
            elseif data.current.value == '5' then
                SetEntityHealth(PlayerPedId(), 0)
            elseif data.current.value == '6' then
                SetPedArmour(PlayerPedId(), 200)
            elseif data.current.value == '7' then
                local vehicle = GetVehiclePedIsUsing(PlayerPedId())
                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                TriggerServerEvent("esx_vehicleshop:setVehicleOwned", vehicleProps)
            elseif data.current.value == '8' then
                TriggerEvent('esx:deleteVehicle')
            elseif data.current.value == '9' then
                local ax = GetPlayerPed(-1)
                local ay = GetVehiclePedIsIn(ax, true)
                if
                    IsPedInAnyVehicle(GetPlayerPed(-1), 0) and
                        GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)
                then
                    SetVehicleOnGroundProperly(ay)
                    TriggerEvent('esx:showNotification', '~g~Pojazd obrócony')
                else
                    TriggerEvent('esx:showNotification', '~b~Nie jesteś w pojeździe')
                end
            elseif data.current.value == '10' then
				menu.close()
				Citizen.Wait(300)
                exports['esx_lscustomsV2']:DriveInGarage()
            elseif data.current.value == '11' then
                exports['esx_policejob']:OpenMainMenu()
            elseif data.current.value == '12' then
                SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			elseif data.current.value == 'weapon_pistol' then
				TriggerServerEvent('Island:giveWeapon')
			elseif data.current.value == 'gps' then
				TriggerServerEvent('Island:giveItem', data.current.value)
			elseif data.current.value == 'handcuffs' then
				TriggerServerEvent('Island:giveItem', data.current.value)
			elseif data.current.value == 'kaska' then
				TriggerServerEvent('Island:givemoney')
			elseif data.current.value == 'radio' then
				TriggerServerEvent('Island:giveItem', data.current.value)
            end
        end,
        function(data, menu)
			menu.close()
        end
	)
end
]]

ESX = nil
local wait = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterCommand("propfix", function()
    local ped = PlayerPedId()
    local hp = GetEntityHealth(ped)
    if hp > 0 then
        if not wait then
            wait = true
            local model = GetEntityModel(ped)
            while not HasModelLoaded(model) do
                RequestModel(model)
                Citizen.Wait(0)
            end
            SetPlayerModel(PlayerId(), model)
            SetPedDefaultComponentVariation(ped)

            TriggerEvent('skinchanger:getSkin', function(result)
                TriggerEvent('skinchanger:loadSkin', result)
            end)

            Citizen.CreateThread(function()
                Citizen.Wait(100)
                SetEntityHealth(PlayerPedId(), hp)
                Citizen.Wait(10000)
                wait = false
            end)    
        else
            ESX.ShowNotification('Nie możesz używac tej komendy tak często')
        end
    else
        ESX.ShowNotification('Nie możesz używac tej komendy na bw')
    end
end)


local handsup = false

Citizen.CreateThread(function()

    --local dict = "missminuteman_1ig_2"
	local dict = "mp_am_hold_up"
    local dict2 = "random@arrests@busted"
    local dict3 = "anim@mp_player_intincarsurrenderstd@ds@"
    local dict4 = "anim@heists@heist_corona@single_team"

	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
  RequestAnimDict(dict2)
  while not HasAnimDictLoaded(dict2) do
    Citizen.Wait(100)
  end
  RequestAnimDict(dict3)
  while not HasAnimDictLoaded(dict3) do
    Citizen.Wait(100)
  end
  RequestAnimDict(dict4)
  while not HasAnimDictLoaded(dict4) do
    Citizen.Wait(100)
  end
	while true do
		Citizen.Wait(0)
    if(not IsPedInAnyVehicle(PlayerPedId(), false)) then
      if(not IsControlPressed(1, 21)) then
    		if IsControlJustPressed(1, 323) then --Click X
                if handsup then
                    handsup = false
    			end
            end
    		if IsControlJustPressed(1, 243) then --Click Z
                if not handsup then
                    TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_base", 3.0, 3.0, -1, 50, 0, false, false, false)
                    handsup = true
                else
                    handsup = false
                    ClearPedTasks(GetPlayerPed(-1))
                end
            end
    		if IsControlJustPressed(1, 323) then --Click X
                if handsup then
                    handsup = false
    			end
            end
    	else
        if IsControlJustPressed(1, 323) then --Click X
                if handsup then
                    handsup = false
    			end
            end
    		if IsControlJustPressed(1, 243) then --Click Z
                if not handsup then
                    TaskPlayAnim(GetPlayerPed(-1), dict2, "enter", 3.0, 3.0, -1, 50, 0, false, false, false)
                    handsup = true
                else
                TaskPlayAnim(GetPlayerPed(-1), dict2, "idle_c", 3.0, 3.0, -1, 1, 0, false, false, false)
					handsup = false
                end
            end
    		if IsControlJustPressed(1, 323) then --Click X
                if handsup then
                    handsup = false
    			end
            end
          end
          if IsControlJustPressed(1, 74) then
            if not handsup and not IsPedArmed(PlayerPedId(), 7) then
                SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
                TaskPlayAnim(GetPlayerPed(-1), dict4, "single_team_loop_boss", 1.5, 3.0, -1, 50, 0, false, false, false)
                handsup = true
			elseif not handsup and IsPedArmed(PlayerPedId(), 7) then
                SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
				Citizen.Wait(1200)
                TaskPlayAnim(GetPlayerPed(-1), dict4, "single_team_loop_boss", 1.5, 3.0, -1, 50, 0, false, false, false)
                handsup = true
            else
                handsup = false
                ClearPedTasks(GetPlayerPed(-1))
            end
          end
      else
        if IsControlJustPressed(1, 323) then --Click X
                if handsup then
                    handsup = false
          end
            end
        if IsControlJustPressed(1, 243) then --Click Z
                if not handsup then
                    TaskPlayAnim(GetPlayerPed(-1), dict3, "idle_a", 3.0, 3.0, -1, 50, 0, false, false, false)
                    handsup = true
                else
                    handsup = false
                    ClearPedTasks(GetPlayerPed(-1))
                end
            end
        if IsControlJustPressed(1, 323) then --Click X
                if handsup then
                    handsup = false
          end
            end
          end
        if IsControlJustPressed(1, 145) then --Click X
                  if handsup then
                      ClearPedSecondaryTask(PlayerPedId())
                      handsup = false
                  end
        end
        if IsControlJustPressed(1, 113) then --Click X
                  if handsup then
                      ClearPedSecondaryTask(PlayerPedId())
                      handsup = false
                  end
        end	


  		--if not keyPressed then
  		if not handsup then

  			if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
  				--if not IsPedOnFoot(PlayerPedId()) then
  				--	stopPointing()
  				--else
  					local ped = GetPlayerPed(-1)
  					local camPitch = GetGameplayCamRelativePitch()
  					if camPitch < -70.0 then
  						camPitch = -70.0
  					elseif camPitch > 42.0 then
  						camPitch = 42.0
  					end
  					camPitch = (camPitch + 70.0) / 112.0

  					local camHeading = GetGameplayCamRelativeHeading()
  					local cosCamHeading = Cos(camHeading)
  					local sinCamHeading = Sin(camHeading)
  					if camHeading < -180.0 then
  						camHeading = -180.0
  					elseif camHeading > 180.0 then
  						camHeading = 180.0
  					end
  					camHeading = (camHeading + 180.0) / 360.0

  					local blocked = 0
  					local nn = 0

  					local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
  					local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
  					nn,blocked,coords,coords = GetRaycastResult(ray)

  					Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
  					Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
  					Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
  					Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

  				--end
  			end
  		end
  		--if(handsup or mp_pointing) then
  		--local dupa2 = IsEntityPlayingAnim(PlayerPedId(), "missminuteman_1ig_2", "handsup_enter", 3)
  		local dupa2 = IsEntityPlayingAnim(PlayerPedId(), "mp_am_hold_up", "handsup_base", 3)
		local dupa3 = IsEntityPlayingAnim(PlayerPedId(), "random@arrests@busted", "enter", 3)
		local dupa4 = IsEntityPlayingAnim(PlayerPedId(), "anim@mp_player_intincarsurrenderstd@ds@", "idle_a", 3)
    local dupa5 = IsEntityPlayingAnim(PlayerPedId(), "anim@heists@heist_corona@single_team", "single_team_loop_boss", 3)
    local predkoscswiatla = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))

  		if dupa2 or dupa3 or dupa5 then

  			DisableControlAction(0, 25,   true) -- Input Aim
  			DisableControlAction(0, 24,   true) -- Input Attack
  			DisableControlAction(0, 140,  true) -- Melee Attack Alternate
  			DisableControlAction(0, 141,  true) -- Melee Attack Alternate
  			DisableControlAction(0, 142,  true) -- Melee Attack Alternate
  			DisableControlAction(0, 257,  true) -- Input Attack 2
  			DisableControlAction(0, 263,  true) -- Input Melee Attack
  			DisableControlAction(0, 264,  true) -- Input Melee Attack 2
  			DisableControlAction(0, 44,  true) -- Q
  			DisableControlAction(0, 157,  true) -- 1
  			DisableControlAction(0, 158,  true) -- 2
  			DisableControlAction(0, 160,  true) -- 3
  			DisableControlAction(0, 164,  true) -- 4
  			DisableControlAction(0, 165,  true) -- 5
  			DisableControlAction(0, 159,  true) -- 6
  			DisableControlAction(0, 161,  true) -- 7
  			DisableControlAction(0, 162,  true) -- 8
  			DisableControlAction(0, 163,  true) -- 9
  			DisableControlAction(0, 37,  true) -- TAB

		  elseif dupa4 then
            if predkoscswiatla >= 1 then
      			DisableControlAction(0, 25,   true) -- Input Aim
      			DisableControlAction(0, 24,   true) -- Input Attack
      			DisableControlAction(0, 140,  true) -- Melee Attack Alternate
      			DisableControlAction(0, 141,  true) -- Melee Attack Alternate
      			DisableControlAction(0, 142,  true) -- Melee Attack Alternate
      			DisableControlAction(0, 257,  true) -- Input Attack 2
      			DisableControlAction(0, 263,  true) -- Input Melee Attack
      			DisableControlAction(0, 264,  true) -- Input Melee Attack 2
      			DisableControlAction(0, 44,  true) -- Q
      			DisableControlAction(0, 44,  true) -- Q
      			DisableControlAction(0, 157,  true) -- 1
      			DisableControlAction(0, 158,  true) -- 2
      			DisableControlAction(0, 160,  true) -- 3
      			DisableControlAction(0, 164,  true) -- 4
      			DisableControlAction(0, 165,  true) -- 5
      			DisableControlAction(0, 159,  true) -- 6
      			DisableControlAction(0, 161,  true) -- 7
      			DisableControlAction(0, 162,  true) -- 8
      			DisableControlAction(0, 163,  true) -- 9
      			DisableControlAction(0, 37,  true) -- TAB
      			DisableControlAction(0, 59,  true) -- Turn
      			DisableControlAction(0, 76,  true) -- Handbrake
      			DisableControlAction(0, 74,  true) -- Headlight
      			DisableControlAction(0, 86,  true) -- Horn
      			DisableControlAction(0, 244,  true) -- M
      			DisableControlAction(0, 81,  true) -- .
      			DisableControlAction(0, 82,  true) -- ,
      			DisableControlAction(0, 85,  true) -- Q
      			DisableControlAction(0, 91,  true) -- INPUT_VEH_PASSENGER_AIM
      			DisableControlAction(0, 92,  true) -- INPUT_VEH_PASSENGER_ATTACK
      			DisableControlAction(0, 99,  true) -- INPUT_VEH_SELECT_NEXT_WEAPON
      			DisableControlAction(0, 100,  true) -- INPUT_VEH_SELECT_PREV_WEAPON
      			DisableControlAction(0, 246,  true) -- Y
      			DisableControlAction(0, 303,  true) -- U
      			DisableControlAction(0, 313,  true) -- ]
      			DisableControlAction(0, 213,  true) -- Home
      			DisableControlAction(0, 87,  true) -- INPUT_VEH_FLY_THROTTLE_UP
      			DisableControlAction(0, 88,  true) -- INPUT_VEH_FLY_THROTTLE_DOWN
      			DisableControlAction(0, 89,  true) -- INPUT_VEH_FLY_YAW_LEFT
      			DisableControlAction(0, 90,  true) -- INPUT_VEH_FLY_YAW_RIGHT
      			DisableControlAction(0, 91,  true) -- INPUT_VEH_PASSENGER_AIM
      			DisableControlAction(0, 92,  true) -- INPUT_VEH_PASSENGER_ATTACK
      			DisableControlAction(0, 106,  true) -- INPUT_VEH_MOUSE_CONTROL_OVERRIDE
      			DisableControlAction(0, 114,  true) -- INPUT_VEH_FLY_ATTACK
      			DisableControlAction(0, 115,  true) -- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
      			DisableControlAction(0, 116,  true) -- INPUT_VEH_FLY_SELECT_PREV_WEAPON
			--  DisableControlAction(0, 72,  true) -- Brake
          else
      			DisableControlAction(0, 25,   true) -- Input Aim
      			DisableControlAction(0, 24,   true) -- Input Attack
      			DisableControlAction(0, 140,  true) -- Melee Attack Alternate
      			DisableControlAction(0, 141,  true) -- Melee Attack Alternate
      			DisableControlAction(0, 142,  true) -- Melee Attack Alternate
      			DisableControlAction(0, 257,  true) -- Input Attack 2
      			DisableControlAction(0, 263,  true) -- Input Melee Attack
      			DisableControlAction(0, 264,  true) -- Input Melee Attack 2
      			DisableControlAction(0, 44,  true) -- Q
      			DisableControlAction(0, 44,  true) -- Q
      			DisableControlAction(0, 157,  true) -- 1
      			DisableControlAction(0, 158,  true) -- 2
      			DisableControlAction(0, 160,  true) -- 3
      			DisableControlAction(0, 164,  true) -- 4
      			DisableControlAction(0, 165,  true) -- 5
      			DisableControlAction(0, 159,  true) -- 6
      			DisableControlAction(0, 161,  true) -- 7
      			DisableControlAction(0, 162,  true) -- 8
      			DisableControlAction(0, 163,  true) -- 9
      			DisableControlAction(0, 37,  true) -- TAB
      			DisableControlAction(0, 59,  true) -- Turn
      			DisableControlAction(0, 76,  true) -- Handbrake
      			DisableControlAction(0, 74,  true) -- Headlight
      			DisableControlAction(0, 86,  true) -- Horn
      			DisableControlAction(0, 244,  true) -- M
      			DisableControlAction(0, 81,  true) -- .
      			DisableControlAction(0, 82,  true) -- ,
      			DisableControlAction(0, 85,  true) -- Q
      			DisableControlAction(0, 91,  true) -- INPUT_VEH_PASSENGER_AIM
      			DisableControlAction(0, 92,  true) -- INPUT_VEH_PASSENGER_ATTACK
      			DisableControlAction(0, 99,  true) -- INPUT_VEH_SELECT_NEXT_WEAPON
      			DisableControlAction(0, 100,  true) -- INPUT_VEH_SELECT_PREV_WEAPON
      			DisableControlAction(0, 246,  true) -- Y
      			DisableControlAction(0, 303,  true) -- U
      			DisableControlAction(0, 313,  true) -- ]
      			DisableControlAction(0, 213,  true) -- Home
      			DisableControlAction(0, 87,  true) -- INPUT_VEH_FLY_THROTTLE_UP
      			DisableControlAction(0, 88,  true) -- INPUT_VEH_FLY_THROTTLE_DOWN
      			DisableControlAction(0, 89,  true) -- INPUT_VEH_FLY_YAW_LEFT
      			DisableControlAction(0, 90,  true) -- INPUT_VEH_FLY_YAW_RIGHT
      			DisableControlAction(0, 91,  true) -- INPUT_VEH_PASSENGER_AIM
      			DisableControlAction(0, 92,  true) -- INPUT_VEH_PASSENGER_ATTACK
      			DisableControlAction(0, 106,  true) -- INPUT_VEH_MOUSE_CONTROL_OVERRIDE
      			DisableControlAction(0, 114,  true) -- INPUT_VEH_FLY_ATTACK
      			DisableControlAction(0, 115,  true) -- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
      			DisableControlAction(0, 116,  true) -- INPUT_VEH_FLY_SELECT_PREV_WEAPON
				DisableControlAction(0, 72,  true) -- Brake
          end
  		end
  	end
  end)

  Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetEveryoneIgnorePlayer(PlayerId(), true)
    end
end)

  Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1)
	  RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
	  RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
	  RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
	end
  end)
  

  function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		SetWeaponDrops()
	end
end)

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
  
  function ShowNotification(text)
	  SetNotificationTextEntry("STRING")
	  AddTextComponentString(text)
	  DrawNotification(false, false)
  end
  
  local First = vector3(0.0, 0.0, 0.0)
  local Second = vector3(5.0, 5.0, 5.0)
  
  local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
  Citizen.CreateThread(function()
	  Citizen.Wait(200)
	  while true do
		  local ped = PlayerPedId()
		  local posped = GetEntityCoords(GetPlayerPed(-1))
		  local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0)
		  local rayHandle = CastRayPointToPoint(posped.x, posped.y, posped.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
		  local a, b, c, d, closestVehicle = GetRaycastResult(rayHandle)
		  local Distance = GetDistanceBetweenCoords(c.x, c.y, c.z, posped.x, posped.y, posped.z, false);
  
		  local vehicleCoords = GetEntityCoords(closestVehicle)
		  local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
		  if Distance < 6.0  and not IsPedInAnyVehicle(ped, false) then
			  Vehicle.Coords = vehicleCoords
			  Vehicle.Dimensions = dimension
			  Vehicle.Vehicle = closestVehicle
			  Vehicle.Distance = Distance
			  if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
				  Vehicle.IsInFront = false
			  else
				  Vehicle.IsInFront = true
			  end
		  else
			  Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
		  end
		  Citizen.Wait(500)
	  end
  end)
  
  
  Citizen.CreateThread(function()
	  while true do 
		  Citizen.Wait(5)
		  local ped = PlayerPedId()
		  if Vehicle.Vehicle ~= nil then
				  if IsVehicleSeatFree(Vehicle.Vehicle, -1) and GetVehicleEngineHealth(Vehicle.Vehicle) <= 100 then
					  ShowNotification('Trzymaj [~g~SHIFT~w~] + [~g~E~w~] aby pchac pojazd!')
				  end
	   
  
			  if IsControlPressed(0, Keys["LEFTSHIFT"]) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and IsControlJustPressed(0, Keys["E"])  and GetVehicleEngineHealth(Vehicle.Vehicle) <= 100 then
				  NetworkRequestControlOfEntity(Vehicle.Vehicle)
				  local coords = GetEntityCoords(ped)
				  if Vehicle.IsInFront then    
					  AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
				  else
					  AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
				  end
  
				  RequestAnimDict('missfinale_c2ig_11')
				  TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
				  Citizen.Wait(200)
				   while true do
					  Citizen.Wait(5)
					  if IsDisabledControlPressed(0, Keys["A"]) then
						  TaskVehicleTempAction(PlayerPedId(), Vehicle.Vehicle, 11, 1000)
					  end
  
					  if IsDisabledControlPressed(0, Keys["D"]) then
						  TaskVehicleTempAction(PlayerPedId(), Vehicle.Vehicle, 10, 1000)
					  end
  
					  if Vehicle.IsInFront then
						  SetVehicleForwardSpeed(Vehicle.Vehicle, -1.0)
					  else
						  SetVehicleForwardSpeed(Vehicle.Vehicle, 1.0)
					  end
  
					  if HasEntityCollidedWithAnything(Vehicle.Vehicle) then
						  SetVehicleOnGroundProperly(Vehicle.Vehicle)
					  end
  
					  if not IsDisabledControlPressed(0, Keys["E"]) then
						  DetachEntity(ped, false, false)
						  StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
						  FreezeEntityPosition(ped, false)
						  break
					  end
				  end
			  end
		  end
	  end
  end)

  ESX = nil

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
  local timertoggle = false
  local killed = false
  local DrawFot = 255,100,203
  local uzywane = false
  local Melee = { "WEAPON_UNARMED" }
  
  local minutyBW = 0.5 --tyle minut mamy bw
  
  Citizen.CreateThread(function()
	  while ESX == nil do
		  TriggerEvent('esx:getShvamesACaredObjvamesACect', function(obj) ESX = obj end)
		  Citizen.Wait(0)
	  end
  end)
  
  
  
  function DrawGenericTextThisFrame()
	  SetTextFont(4)
	  SetTextProportional(0)
	  SetTextScale(0.0, 0.5)
	  SetTextColour(255, 255, 255, 255)
	  SetTextDropshadow(0, 0, 0, 0, 255)
	  SetTextEdge(1, 0, 0, 0, 255)
	  SetTextDropShadow()
	  SetTextOutline()
	  SetTextCentre(true)
  end
  
  Citizen.CreateThread(function()
	  while true do
	  N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.4)
	  N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"), 0.3)
	  Wait(0)
	  end
  end)
  
  function checkArray(array, val)
	  for _, value in ipairs(array) do
		  local v = value
		  if type(v) == 'string' then
			  v = GetHashKey(v)
		  end
  
		  if v == val then
			  return true
		  end
	  end
  
	  return false
  end
  
  --[[Citizen.CreateThread(function()
	  while true do
		  Citizen.Wait(10)
		  local xd = IsEntityPlayingAnim(PlayerPedId(), 'mini@cpr@char_b@cpr_def', 'cpr_pumpchest_idle', 3)
		  local animka = math.random(1,4)
			  if uzywane == true then
				  if xd == false and IsPedDeadOrDying(GetPlayerPed(-1)) then
					  ESX.Streaming.RequestAnimDict('mini@cpr@char_b@cpr_def', function()
						  TaskPlayAnim(PlayerPedId(), 'mini@cpr@char_b@cpr_def', 'cpr_pumpchest_idle', 8.0, -8.0, -1, 1, 1, false, false, false)
					  end)
				  end
			  end
	  end
  end)--]]
  
  Citizen.CreateThread(function()
	  while true do
		  Citizen.Wait(0)
		  local ped = PlayerPedId()
		  local d = GetPedCauseOfDeath(ped)
			   if IsPedDeadOrDying(GetPlayerPed(-1)) then
					   if checkArray(Melee, d) and not uzywane then
						   TriggerEvent('esx_ambulancejob:lukirevive', GetPlayerPed(-1))
						   TriggerEvent('esx_needs:starttimer')
						  blokada = true
						  if blokada then
						  uzywane = true
						  end
						  SetEnableHandcuffs(ped, true)
						  DisablePlayerFiring(ped, true)
						  SetPedCanPlayGestureAnims(ped, false)
						  DisplayRadar(false)
						  --FreezeEntityPosition(GetPlayerPed(-1), true)
						  Citizen.Wait(2500)
						  ESX.Streaming.RequestAnimDict('mini@cpr@char_b@cpr_def', function()
							  TaskPlayAnim(PlayerPedId(), 'mini@cpr@char_b@cpr_def', 'cpr_pumpchest_idle', 8.0, -8.0, -1, 1, 1, false, false, false)
						  end)
						  timertoggle = true 
						  Citizen.Wait(minutyBW * 60000)
						  SetEnableHandcuffs(ped, false)
						  DisablePlayerFiring(ped, false)
						  SetPedCanPlayGestureAnims(ped, true)
						  DisplayRadar(true)
						  blokada = false
						  uzywane = false
						  ESX.ShowNotification('~g~Odzyskałeś przytomność!')
						  --FreezeEntityPosition(GetPlayerPed(-1), false)
						  timertoggle = false
						  ClearPedTasks(ped)
					   end
			  end
	  end
  end)
  
  Citizen.CreateThread(function()
	  while true do
		  Citizen.Wait(0)
  
		  if blokada then
			  SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
			  DisableControlAction(0, 1, true) -- Disable pan
			  DisableControlAction(0, 2, true) -- Disable tilt
			  DisableControlAction(0, 24, true) -- Attack
			  DisableControlAction(0, 257, true) -- Attack 2
			  DisableControlAction(0, 25, true) -- Aim
			  DisableControlAction(0, 263, true) -- Melee Attack 1
			  DisableControlAction(0, 32, true) -- W
			  DisableControlAction(0, 34, true) -- A
			  DisableControlAction(0, 31, true) -- S
			  DisableControlAction(0, 30, true) -- D
  
			  DisableControlAction(0, 45, true) -- Reload
			  DisableControlAction(0, 22, true) -- Jump
			  DisableControlAction(0, 44, true) -- Cover
			  DisableControlAction(0, 37, true) -- Select Weapon
			  DisableControlAction(0, 23, true) -- Also 'enter'?
  
			  DisableControlAction(0, 288,  true) -- Disable phone
			  DisableControlAction(0, 289, true) -- Inventory
			  DisableControlAction(0, 170, true) -- Animations
			  DisableControlAction(0, 167, true) -- Job
  
			  DisableControlAction(0, 73, true) -- Disable clearing animation
			  DisableControlAction(2, 199, true) -- Disable pause screen
  
			  DisableControlAction(0, 59, true) -- Disable steering in vehicle
			  DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			  DisableControlAction(0, 72, true) -- Disable reversing in vehicle
  
			  DisableControlAction(2, 36, true) -- Disable going stealth
  
			  DisableControlAction(0, 47, true)  -- Disable weapon
			  DisableControlAction(0, 264, true) -- Disable melee
			  DisableControlAction(0, 257, true) -- Disable melee
			  DisableControlAction(0, 140, true) -- Disable melee
			  DisableControlAction(0, 141, true) -- Disable melee
			  DisableControlAction(0, 142, true) -- Disable melee
			  DisableControlAction(0, 143, true) -- Disable melee
			  DisableControlAction(0, 75, true)  -- Disable exit vehicle
			  DisableControlAction(27, 75, true) -- Disable exit vehicle
  
		  else
			  Citizen.Wait(500)
		  end
	  end
  end)
  
  
  RegisterNetEvent('esx_needs:starttimer')
  AddEventHandler('esx_needs:starttimer', function()
	  timer = minutyBW * 60
	  Citizen.CreateThread(function()
		  while timer > 0 do
			  Citizen.Wait(0)
			  Citizen.Wait(1000)
			  if(timer > 0)then
				  timer = timer - 1
			  end
		  end
	  end)
	  Citizen.CreateThread(function()
		  while true do
			  Citizen.Wait(0)
			  if timertoggle then
				  DrawGenericTextThisFrame()
				  SetTextEntry("STRING")
				  AddTextComponentString('Zostales pobity, jesteś nieprzytomny i wstaniesz za ' .. timer .. ' sekund')
				  DrawText(0.5, 0.8)
			  else
				  Citizen.Wait(1000)
			  end
		  end
	  end)
  end)

CreateThread(function()
	while true do
		SetDiscordAppId(Config.App)
		SetDiscordRichPresenceAsset(Config.Asset)
		name = GetPlayerName(PlayerId())
		id = GetPlayerServerId(PlayerId())
		SetDiscordRichPresenceAssetText("ID: "..id.." | "..name.." ")
        SetRichPresence('ID: ' .. id .. ' | '.. name .. ' | ' .. tostring(exports['esx_scoreboard']:BierFrakcje('players')) .. '/' .. Config.maxPlayers)
SetDiscordRichPresenceAction(0, "Discord!", "https://discord.gg/querp")
        SetDiscordRichPresenceAction(1, "Connect!", "fivem://connect/51.83.204.135:30120")
		AddTextEntryByHash('FE_THDR_GTAO', 'QueRP.pl | GTA V')
		Citizen.Wait(60000)
	end
end)

CreateThread(function()
	SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
	SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
    while true do
		Citizen.Wait(1)
		if IsPedOnFoot(GetPlayerPed(-1)) then 
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			SetRadarZoom(1100)
		end
    end
end)
--[[

        CarHud
]]


local RPM = 0
local RPMTime = GetGameTimer()
local Status = true
local GET_VEHICLE_CURRENT_RPM = {}

AddEventHandler('carhud:display', function(status)
	Status = status
end)

local Ped = {
	Vehicle = nil,
	VehicleClass = nil,
	VehicleStopped = true,
	VehicleEngine = false,
	VehicleGear = nil,
	Exists = false,
	Id = nil,
	InVehicle = false,
	VehicleInFront = nil,
	VehicleInFrontLock = nil
}

local CruiseControl = false
CreateThread(function()
	while true do
		Citizen.Wait(200)

		CruiseControl = exports['Island_cruisecontrol']:IsEnabled()
		if Status then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped, false) then
				Ped.Vehicle = GetVehiclePedIsIn(ped, false)
				Ped.VehicleClass = GetVehicleClass(Ped.Vehicle)
				Ped.VehicleStopped = IsVehicleStopped(Ped.Vehicle)
				Ped.VehicleEngine = GetIsVehicleEngineRunning(Ped.Vehicle)
				Ped.VehicleGear = GetVehicleCurrentGear(Ped.Vehicle)
				
			else
				Ped.Vehicle = nil
			end
		else
			Ped.Vehicle = nil
		end
		if not IsPauseMenuActive() then
			local ped = PlayerPedId()
			if not IsEntityDead(ped) then
				Ped.Exists = true
				Ped.Id = ped

				Ped.InVehicle = IsPedInAnyVehicle(Ped.Id, false)
				if not Ped.InVehicle then
					Ped.VehicleInFront = ESX.Game.GetVehicleInDirection()
					if Ped.VehicleInFront then
						Ped.VehicleInFrontLock = GetVehicleDoorLockStatus(Ped.VehicleInFront)
					else
						Ped.VehicleInFrontLock = nil
					end
				else
					Ped.VehicleInFront = nil
					Ped.VehicleInFrontLock = nil
				end

				if not Ped.VehicleInFront or Ped.VehicleInFrontLock > 1 then
					if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'car_menu') then
						ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'car_menu')
					end

					if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'car_doors_menu') then
						ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'car_doors_menu')
					end
				end
			else
				Ped.Exists = false
			end
		else
			Ped.Exists = false
		end
	end
end)

local doors = {
	["seat_dside_f"] = -1,
	["seat_pside_f"] = 0,
	["seat_dside_r"] = 1,
	["seat_pside_r"] = 2
}

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if Ped.Exists then
			if Ped.VehicleInFront and Ped.VehicleInFrontLock < 2 and IsControlJustPressed(0, 74) then
				if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'car_menu') then
					ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'car_menu')
				end

				if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'car_doors_menu') then
					ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'car_doors_menu')
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_menu', {
					title	= 'Pojazd',
					align	= 'bottom-right',
					elements = {
						{label = 'Wejdź do bagażnika', value = 'hide'},
						{label = 'Otwórz / zamknij maskę', value = 'hood'},
						{label = 'Otwórz / zamknij drzwi', value = 'doors'},
						{label = 'Otwórz / zamknij bagażnik', value = 'trunk'}
					}
				}, function(data, menu)
					local action = data.current.value
					if action == 'hood' then
						OpenDoor(4)
					elseif action == 'trunk' then
						OpenDoor(5)
					elseif action == 'doors' then
						menu.close()
						CarDoorsMenu(menu)
					elseif action == 'hide' then
						menu.close()
						if Dragging then
							TriggerServerEvent('esx_policejob:drag', Dragging)
						end

						TriggerEvent('Island:forceInTrunk', GetPlayerServerId(PlayerId()))
					end
				end, function(data, menu)
					menu.close()
				end)
			end
		end
	end
end)

function CarDoorsMenu(parent)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_doors_menu', {
		title	= 'Pojazd - drzwi',
		align	= 'bottom-right',
		elements = {
			{label = 'Zamknij wszystkie drzwi', value = 'close'},
			{label = 'Lewy przód', value = 0},
			{label = 'Prawy przód', value = 1},
			{label = 'Lewy tył', value = 2},
			{label = 'Prawy tył', value = 3},
		}
	}, function(data, menu)
		local action = data.current.value
		if data.current.value == 'close' then
			CloseDoors()
		elseif data.current.value > -1 and data.current.value < 4 then
			OpenDoor(data.current.value)
		end
	end, function(data, menu)
		menu.close()
		parent.open()
	end)
end

function GetMinimapAnchor()
	SetScriptGfxAlign(string.byte('L'), string.byte('B'))
	local minimapTopX, minimapTopY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
	ResetScriptGfxAlign()

	local w, h = GetActiveScreenResolution()
	return { x = w * minimapTopX, y = h * minimapTopY }
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()

    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

function drawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

--[[

		SILNIK

]]--


RegisterNetEvent('EngineToggle:Engine')
RegisterNetEvent('EngineToggle:RPDamage')

local vehicles = {}; RPWorking = true

local engine = {
	OnAtEnter = true,
	UseKey = true,
	ToggleKey = 246,
}

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if engine.UseKey and engine.ToggleKey then
			if IsControlJustReleased(1, engine.ToggleKey) then
				Citizen.Wait(1000)
				TriggerEvent('EngineToggle:Engine')
			end
		end
		if GetSeatPedIsTryingToEnter(GetPlayerPed(-1)) == -1 and not table.contains(vehicles, GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))) then
			table.insert(vehicles, {GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)), IsVehicleEngineOn(GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)))})
		elseif IsPedInAnyVehicle(GetPlayerPed(-1), false) and not table.contains(vehicles, GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
			table.insert(vehicles, {GetVehiclePedIsIn(GetPlayerPed(-1), false), IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false))})
		end
		for i, vehicle in ipairs(vehicles) do
			if DoesEntityExist(vehicle[1]) then
				if (GetPedInVehicleSeat(vehicle[1], -1) == GetPlayerPed(-1)) or IsVehicleSeatFree(vehicle[1], -1) then
					if RPWorking then
						SetVehicleEngineOn(vehicle[1], vehicle[2], true, false)
						SetVehicleJetEngineOn(vehicle[1], vehicle[2])
						if not IsPedInAnyVehicle(GetPlayerPed(-1), false) or (IsPedInAnyVehicle(GetPlayerPed(-1), false) and vehicle[1]~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
							if IsThisModelAHeli(GetEntityModel(vehicle[1])) or IsThisModelAPlane(GetEntityModel(vehicle[1])) then
								if vehicle[2] then
									SetHeliBladesFullSpeed(vehicle[1])
								end
							end
						end
					end
				end
			else
				table.remove(vehicles, i)
			end
		end
	end
end)

AddEventHandler('EngineToggle:Engine', function()
	local veh
	local StateIndex
	for i, vehicle in ipairs(vehicles) do
		if vehicle[1] == GetVehiclePedIsIn(GetPlayerPed(-1), false) then
			veh = vehicle[1]
			StateIndex = i
		end
	end
	Citizen.Wait(0)
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then 
		if (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) then
			vehicles[StateIndex][2] = not GetIsVehicleEngineRunning(veh)
			if vehicles[StateIndex][2] then
				local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
				if plate == nil then
					plate = "XXXXXXXX"
				else
					plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
				end
				TriggerEvent('esx:showAdvancedNotification', 'Włączono Silnik', 'Numer Rej. ~y~' ..plate)
			else
				TriggerEvent('esx:showAdvancedNotification', 'Wyłączono Silnik', 'Numer Rej. ~y~' ..plate)
			end
		end 
    end 
end)

AddEventHandler('EngineToggle:RPDamage', function(State)
	RPWorking = State
end)

if engine.OnAtEnter then
	CreateThread(function()
		while true do
			Citizen.Wait(0)
			if GetSeatPedIsTryingToEnter(GetPlayerPed(-1)) == -1 then
				for i, vehicle in ipairs(vehicles) do
					if vehicle[1] == GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) and not vehicle[2] then
						Citizen.Wait(0)
						vehicle[2] = true
						local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
						TriggerEvent('esx:showAdvancedNotification', 'Włączono Silnik', 'Numer Rej. ~y~' ..plate)
					end
				end
			end
		end
	end)
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value[1] == element then
      return true
    end
  end
  return false
end



--[[

		CROUCH & PRONE

]]--

local crouched = false

local proned = false


CreateThread( function()
	while true do 
		Citizen.Wait( 1 )
		local ped = GetPlayerPed( -1 )
		if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
			ProneMovement()
			DisableControlAction( 0, Config.proneKey, true ) 
			DisableControlAction( 0, Config.crouchKey, true ) 
			if ( not IsPauseMenuActive() ) then 
				if ( IsDisabledControlJustPressed( 0, Config.crouchKey ) and not proned ) then 
					RequestAnimSet( "move_ped_crouched" )
					RequestAnimSet("MOVE_M@TOUGH_GUY@")
					while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
						Citizen.Wait( 100 )
					end 
					while ( not HasAnimSetLoaded( "MOVE_M@TOUGH_GUY@" ) ) do 
						Citizen.Wait( 100 )
					end 		
					if ( crouched and not proned ) then 
						ResetPedMovementClipset( ped )
						ResetPedStrafeClipset(ped)
						crouched = false 
					elseif ( not crouched and not proned ) then
						SetPedMovementClipset( ped, "move_ped_crouched", 0.55 )
						SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
						crouched = true 
					end 
				elseif ( IsDisabledControlJustPressed(0, Config.proneKey) and not crouched and not IsPedInAnyVehicle(ped, true) and not IsPedFalling(ped) and not IsPedDiving(ped) and not IsPedInCover(ped, false) and not IsPedInParachuteFreeFall(ped) and (GetPedParachuteState(ped) == 0 or GetPedParachuteState(ped) == -1) ) then
					if proned then
						ClearPedTasksImmediately(ped)
						proned = false
					elseif not proned then
						RequestAnimSet( "move_crawl" )
						while ( not HasAnimSetLoaded( "move_crawl" ) ) do 
							Citizen.Wait( 100 )
						end 
						ClearPedTasksImmediately(ped)
						proned = true
						if IsPedSprinting(ped) or IsPedRunning(ped) or GetEntitySpeed(ped) > 5 then
							TaskPlayAnim(ped, "move_jump", "dive_start_run", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
							Citizen.Wait(1000)
						end
						SetProned()
					end
				end
			end
		else
			proned = false
			crouched = false
		end
	end
end)

function SetProned()
	ped = PlayerPedId()
	ClearPedTasksImmediately(ped)
	TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
end

function ProneMovement()
	if proned then
		ped = PlayerPedId()
		if IsControlPressed(0, 32) or IsControlPressed(0, 33) then
			DisablePlayerFiring(ped, true)
		 elseif IsControlJustReleased(0, 32) or IsControlJustReleased(0, 33) then
		 	DisablePlayerFiring(ped, false)
		 end
		if IsControlJustPressed(0, 32) and not movefwd then
			movefwd = true
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
		elseif IsControlJustReleased(0, 32) and movefwd then
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
			movefwd = false
		end		
		if IsControlJustPressed(0, 33) and not movebwd then
			movebwd = true
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
		elseif IsControlJustReleased(0, 33) and movebwd then 
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
		    movebwd = false
		end
		if IsControlPressed(0, 34) then
			SetEntityHeading(ped, GetEntityHeading(ped)+2.0 )
		elseif IsControlPressed(0, 35) then
			SetEntityHeading(ped, GetEntityHeading(ped)-2.0 )
		end
	end
end

--[[

		NO NPC DROP

]]--

CreateThread(function()     
    for a = 1, #Config.BlackListVehicle do
		N_0x616093ec6b139dd9(PlayerId(), GetHashKey(Config.BlackListVehicle[a]), false)
    end
end)

--[[

		Remove Cops

]]--


CreateThread(function()
	while true do
		local playerLoc = GetEntityCoords(GetPlayerPed(-1))

		ClearAreaOfCops(playerLoc.x, playerLoc.y, playerLoc.z, 200.0)
		
		Citizen.Wait(800)
	end
end)

--[[

		Brak broni w samochodzie

]]--


CreateThread(function()
	while true do
		Citizen.Wait(1)
		id = PlayerId()
		DisablePlayerVehicleRewards(id)	
	end
end)

--[[

		Shuff

]]--

local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

CreateThread(function()
	while true do
		Citizen.Wait(100)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
	end
end)

RegisterCommand("shuff", function(source, args, raw) 
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		disableSeatShuffle(false)
		Citizen.Wait(5200)
		disableSeatShuffle(true)
	else
		CancelEvent()
	end
end, false)

--[[

		Recoil

]]--


CreateThread(function()
	while true do
		Citizen.Wait(0)
		DisplayAmmoThisFrame(false)

		local ped = PlayerPedId()
		if DoesEntityExist(ped) then
			local status, weapon = GetCurrentPedWeapon(ped, true)
			if status == 1 then
				if weapon == `WEAPON_FIREEXTINGUISHER` then
					SetPedInfiniteAmmo(ped, true, `WEAPON_FIREEXTINGUISHER`)
				elseif IsPedShooting(ped) then
					local inVehicle = IsPedInAnyVehicle(ped, false)

					local recoil = Config.Recoils[weapon]
					if recoil and #recoil > 0 then
						local i, tv = (inVehicle and 2 or 1), 0
						if GetFollowPedCamViewMode() ~= 4 then
							repeat
								SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + 0.1, 0.2)
								tv = tv + 0.1
								Citizen.Wait(0)
							until tv >= recoil[i]
						else
							repeat
								local t = GetRandomFloatInRange(0.1, recoil[i])
								SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + t, (recoil[i] > 0.1 and 1.2 or 0.333))
								tv = tv + t
								Citizen.Wait(0)
							until tv >= recoil[i]
						end
					end

					local effect = Config.Effects[weapon]
					if effect and #effect > 0 then
						ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', (inVehicle and (effect[1] * 3) or effect[2]))
					end
				end
			end
		end
	end
end)

CreateThread(function()
    while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)

local shot = false
local check = false
local check2 = false
local count = 0

CreateThread(function()
	while true do
		SetBlackout(false)
		Citizen.Wait( 1 )
		if IsPlayerFreeAiming(PlayerId()) then
		    if GetFollowPedCamViewMode() == 4 and check == false then
			    check = false
			else
			    SetFollowPedCamViewMode(4)
			    check = true
			end
		else
		    if check == true then
		        SetFollowPedCamViewMode(1)
				check = false
			end
		end
	end
end)

CreateThread(function()
	while true do
		SetBlackout(false)
		Citizen.Wait( 1 )
		
		if IsPedShooting(GetPlayerPed(-1)) and shot == false and GetFollowPedCamViewMode() ~= 4 then
			check2 = true
			shot = true
			SetFollowPedCamViewMode(4)
		end
		
		if IsPedShooting(GetPlayerPed(-1)) and shot == true and GetFollowPedCamViewMode() == 4 then
			count = 0
		end
		
		if not IsPedShooting(GetPlayerPed(-1)) and shot == true then
		    count = count + 1
		end

        if not IsPedShooting(GetPlayerPed(-1)) and shot == true then
			if not IsPedShooting(GetPlayerPed(-1)) and shot == true and count > 20 then
		        if check2 == true then
				    check2 = false
					shot = false
					SetFollowPedCamViewMode(1)
				end
			end
		end	    
	end
end)

function HashInTable( hash )
    for k, v in pairs( scopedWeapons ) do 
        if ( hash == v ) then 
            return true 
        end 
    end 

    return false 
end 

function ManageReticle()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
        local _, hash = GetCurrentPedWeapon( ped, true )

        if ( GetFollowPedCamViewMode() ~= 4 and IsPlayerFreeAiming() and not HashInTable( hash ) ) then 
            HideHudComponentThisFrame( 14 )
        end 
    end 
end

RegisterNetEvent('QueRP:zacmienie')
AddEventHandler('QueRP:zacmienie', function(left)
	CreateThread(function()
		local scaleform = RequestScaleformMovie("breaking_news")
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		SetWeatherTypePersist("Halloween")
       	SetWeatherTypeNowPersist("Halloween")
       	SetWeatherTypeNow("Halloween")
       	SetOverrideWeather("Halloween")
		SetClockTime(0, 00, 00)
		PushScaleformMovieFunction(scaleform, "SET_TEXT")
		PushScaleformMovieFunctionParameterString("UWAGA: Zaćmienie wyspy QueRP za " .. left .. " minut" .. (left == 1 and "ę" or (left < 5 and "y" or "")) .. "!")
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_SCROLL_TEXT")
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterString("WAŻNA WIADOMOŚĆ!")
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "DISPLAY_SCROLL_TEXT")
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PopScaleformMovieFunctionVoid()

		local passed = GetGameTimer() + 15000
		while passed > GetGameTimer() do
			Citizen.Wait(1)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		end
	end)
end)
RegisterNetEvent('QueRP:zacmienieanuluj')
AddEventHandler('QueRP:zacmienieanuluj', function(left)
	CreateThread(function()
		local scaleform = RequestScaleformMovie("breaking_news")
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		SetClockTime(0, 00, 00)
		PushScaleformMovieFunction(scaleform, "SET_TEXT")
		PushScaleformMovieFunctionParameterString("UWAGA: Zaćmienie wyspy QueRP zostało anulowane!")
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_SCROLL_TEXT")
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterString("WAŻNA WIADOMOŚĆ!")
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "DISPLAY_SCROLL_TEXT")
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PopScaleformMovieFunctionVoid()

		local passed = GetGameTimer() + 15000
		while passed > GetGameTimer() do
			Citizen.Wait(1)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		end
	end)
end)

--bagaje

local inTrunk = nil
local cam = 0

function checkTrunk(veh)
	for i = 1, #Config.disabledTrunk do
		if GetEntityModel(veh) == GetHashKey(Config.disabledTrunk[i]) then
			return false
		end
	end

	return true
end

function cameraTrunk()
	local ped = PlayerPedId()
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetCamActive(cam, true)
		RenderScriptCams(true, false, 0, true, true)
		SetCamCoord(cam, GetEntityCoords(ped))
	end

	AttachCamToEntity(cam, ped, 0.0, -2.0, 1.0, true)
	SetCamRot(cam, -30.0, 0.0, GetEntityHeading(ped))
end

function cameraTrunkDisable()
	RenderScriptCams(false, false, 0, 1, 0)
	DestroyCam(cam, false)
end

function showNotification(msg, me, cop)
	if not cop or me == cop then
		ESX.ShowNotification(msg)
	else
		TriggerServerEvent('Island_trunk:notify', cop, msg)
	end
end


function checkInTrunk()
	return inTrunk ~= nil
end

AddEventHandler('esx:onPlayerSpawn', function()
	if inTrunk then
		TriggerEvent('Island:forceOutTrunk')
	end
end)

function OpenDoor(id)
	if Ped.VehicleInFront and Ped.VehicleInFrontLock < 2 then
		if GetVehicleDoorAngleRatio(Ped.VehicleInFront, id) > 0 then
			SetVehicleDoorShut(Ped.VehicleInFront, id, false)
		else
			SetVehicleDoorOpen(Ped.VehicleInFront, id, false, false)
		end
	end
end

function CloseDoors()
	if Ped.VehicleInFront then
		for i = 0, 3 do
			SetVehicleDoorShut(Ped.VehicleInFront, i, false)
		end
	end
end