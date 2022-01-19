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

ESX = nil

PlayerData = {}

local jailTime = 0
local siedzi = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	LoadTeleporters()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if siedzi then
			DisableControlAction(0, 37, true)
		end
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
	PlayerData = newData

	Citizen.Wait(25000)

	ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime)
		if inJail then

			jailTime = newJailTime

			JailLogin()
		end
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	PlayerData["job"] = response
end)

RegisterNetEvent("esx-qalle-jail:openJailMenu")
AddEventHandler("esx-qalle-jail:openJailMenu", function()
	OpenJailMenu()
end)

RegisterNetEvent("route68jail:jailPlayerRoute68Client")
AddEventHandler("route68jail:jailPlayerRoute68Client", function(newJailTime)
	jailTime = newJailTime

	Cutscene()
end)

RegisterNetEvent("esx-qalle-jail:unJailPlayer")
AddEventHandler("esx-qalle-jail:unJailPlayer", function()
	jailTime = 0

	UnJail()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if siedzi then
			local Gracz = PlayerPedId()
			local PozycjaGracza = GetEntityCoords(Gracz)
			local DystansCele = GetDistanceBetweenCoords(PozycjaGracza, 1794.07, 2483.27, -122.71, true)
			local DystansMagazyn = GetDistanceBetweenCoords(PozycjaGracza, 1009.82, -3101.09, -39.0, true)
			local DystansWidzenia = GetDistanceBetweenCoords(PozycjaGracza, 1697.55, 2577.44, -69.39, true)
			local DystansSpacerniak = GetDistanceBetweenCoords(PozycjaGracza, 1693.4, 2565.93, 45.56, true)
			if (DystansCele > 40) and (DystansMagazyn > 80) and (DystansWidzenia > 15) and (DystansSpacerniak > 85) then
				local JailPosition = Config.JailPositions["Cell"]
				SetEntityCoords(PlayerPedId(), JailPosition["x"], JailPosition["y"], JailPosition["z"] - 1)
				TriggerEvent("pNotify:SendNotification", {text = "Nie możesz tak daleko odejść!"})
			end
			Citizen.Wait(10000)
		end
	end
end)

function JailLogin()
	local JailPosition = Config.JailPositions["Cell"]
	SetEntityCoords(PlayerPedId(), JailPosition["x"], JailPosition["y"], JailPosition["z"] - 1)

	ESX.ShowNotification("Jesteś w więzieniu, ponieważ Twoja postać nie ukończyła Wyroku przed wyjściem z serwera")
	siedzi = true
	SetPlayerInvincible(PlayerPedId(), true)
	SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263, true)

	local Male = GetHashKey("mp_m_freemode_01")

	if GetEntityModel(PlayerPedId()) == Male then
		sex = 'male'
	else
		sex = 'female'
	end

	TriggerEvent('skinchanger:getSkin', function(skin)
		if sex == 'male' then
			local clothesSkin = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,
				['torso_1'] = 5, ['torso_2'] = 0,
				['arms'] = 5,		 ['arms_2'] = 0,
				['pants_1'] = 9, ['pants_2'] = 4,
				['shoes_1'] = 14, ['shoes_2'] = 5,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

		elseif sex == 'female' then
			local clothesSkin = {
				['tshirt_1'] = 14, ['tshirt_2'] = 0,
				['torso_1'] = 3, ['torso_2'] = 0,
				['arms'] = 3,			['arms_2'] = 0,
				['pants_1'] = 66, ['pants_2'] = 6,
				['shoes_1'] = 10, ['shoes_2'] = 0,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end
	end)

	InJail()
end

function UnJail()
	InJail()

	ESX.Game.Teleport(PlayerPedId(), Config.Teleports["Wyjście"])
	
	Citizen.Wait(1000)
	TriggerEvent('esx_ciuchymenu:wszystko')

	ESX.ShowNotification("Zakończono odsiadkę!")
	SetEntityCoords(GetPlayerPed(-1), 1845.602, 2585.802, 45.67, 1, 0, 0, 1)
	siedzi = false
	SetPlayerInvincible(PlayerPedId(), false)
	SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263, true)
end

function InJail()

	--Jail Timer--

	Citizen.CreateThread(function()

		while jailTime > 0 do

			jailTime = jailTime - 1

			ESX.ShowNotification("Pozostało " .. jailTime .. " minut odsiadki...")
			siedzi = true
			SetPlayerInvincible(PlayerPedId(), true)
			SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263, true)

			TriggerServerEvent("esx-qalle-jail:updateJailTime", jailTime)

			if jailTime <= 0 then
				UnJail()
				TriggerServerEvent("esx-qalle-jail:updateJailTime", 0)
			end

			Citizen.Wait(60000)
		end

	end)

	--Jail Timer--

	--Prison Work--

	Citizen.CreateThread(function()
		while jailTime > 0 do

			local sleepThread = 500

			local Packages = Config.PrisonWork["Packages"]

			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)

			for posId, v in pairs(Packages) do

				local DistanceCheck = GetDistanceBetweenCoords(PedCoords, v["x"], v["y"], v["z"], true)

				if DistanceCheck <= 10.0 then

					sleepThread = 5

					local PackageText = "WEŹ PACZKĘ"

					if not v["state"] then
						PackageText = "PACZKA ZABRANA"
					end

					ESX.Game.Utils.DrawText3D(v, "[~g~E~s~] " .. PackageText, 0.4)

					if DistanceCheck <= 1.5 then

						if IsControlJustPressed(0, 38) then

							if v["state"] then
								PackPackage(posId)
							else
								ESX.ShowNotification("Już zabrano tą paczkę!")
							end

						end

					end

				end

			end

			Citizen.Wait(sleepThread)

		end
	end)

	--Prison Work--

end

function LoadTeleporters()
	Citizen.CreateThread(function()
		while true do

			local sleepThread = 500

			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)

			for p, v in pairs(Config.Teleports) do

				local DistanceCheck = GetDistanceBetweenCoords(PedCoords, v["x"], v["y"], v["z"], true)

				if DistanceCheck <= 7.5 then

					sleepThread = 5

					local PozycjaTekstu= {
						["x"] = v["x"],
						["y"] = v["y"],
						["z"] = v["z"]
					}
					ESX.Game.Utils.DrawText3D(PozycjaTekstu, "NACIŚNIJ [~g~E~s~] ABY PRZEJŚĆ", 0.55, 1.5, "~b~PRZEJŚCIE", 0.7)

					if DistanceCheck <= 1.0 then
						if IsControlJustPressed(0, 38) then
							TeleportPlayer(v)
						end
					end
				end
			end

			Citizen.Wait(sleepThread)

		end
	end)
end

function PackPackage(packageId)
	local Package = Config.PrisonWork["Packages"][packageId]

	LoadModel("prop_cs_cardbox_01")

	local PackageObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), Package["x"], Package["y"], Package["z"], true)

	PlaceObjectOnGroundProperly(PackageObject)

	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, false)

	local Packaging = true
	local StartTime = GetGameTimer()

	while Packaging do

		Citizen.Wait(1)

		local TimeToTake = 60000 * 1.20 -- Minutes
		local PackPercent = (GetGameTimer() - StartTime) / TimeToTake * 100

		if not IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_BUM_BIN") then
			DeleteEntity(PackageObject)

			ESX.ShowNotification("Anulowano!")

			Packaging = false
		end

		if PackPercent >= 100 then

			Packaging = false

			DeliverPackage(PackageObject)

			Package["state"] = false
		else
			ESX.Game.Utils.DrawText3D(Package, "PAKOWANIE... " .. math.ceil(tonumber(PackPercent)) .. "%", 0.4)
		end

	end
end

function DeliverPackage(packageId)
	if DoesEntityExist(packageId) then
		AttachEntityToEntity(packageId, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)

		ClearPedTasks(PlayerPedId())
	else
		return
	end

	local Packaging = true

	LoadAnim("anim@heists@box_carry@")

	while Packaging do

		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
			TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if not IsEntityAttachedToEntity(packageId, PlayerPedId()) then
			Packaging = false
			DeleteEntity(packageId)
		else
			local DeliverPosition = Config.PrisonWork["DeliverPackage"]
			local PedPosition = GetEntityCoords(PlayerPedId())
			local DistanceCheck = GetDistanceBetweenCoords(PedPosition, DeliverPosition["x"], DeliverPosition["y"], DeliverPosition["z"], true)

			ESX.Game.Utils.DrawText3D(DeliverPosition, "[~g~E~s~] ODŁÓŻ PACZKĘ", 0.4)

			if DistanceCheck <= 2.0 then
				if IsControlJustPressed(0, 38) then
					DeleteEntity(packageId)
					ClearPedTasksImmediately(PlayerPedId())
					Packaging = false

					TriggerServerEvent("esx-qalle-jail:prisonWorkReward")
				end
			end
		end

	end

end

function OpenJailMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'jail_prison_menu',
		{
			title    = "Menu Wyroku",
			align    = 'left',
			elements = {
				{ label = "Wyślij do Więzienia", value = "jail_closest_player" },
				{ label = "Ułaskaw Więźnia", value = "unjail_player" }
			}
		},
	function(data, menu)

		local action = data.current.value

		if action == "jail_closest_player" then

			menu.close()

			ESX.UI.Menu.Open(
          		'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
          		{
            		title = "Czas Wyroku (w minutach)"
          		},
          	function(data2, menu2)

            	local jailTime = tonumber(data2.value)

            	if jailTime == nil then
              		ESX.ShowNotification("Nieprawidłowy czas!")
            	else
              		menu2.close()

              		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              		if closestPlayer == -1 or closestDistance > 3.0 then
                		ESX.ShowNotification("Brak graczy w pobliżu!")
					else
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
							{
							  title = "Powód Wyroku"
							},
						function(data3, menu3)

						  	local reason = data3.value

						  	if reason == nil then
								ESX.ShowNotification("Powód nie może być pusty!")
						  	else
								menu3.close()

								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

								if closestPlayer == -1 or closestDistance > 3.0 then
								  	ESX.ShowNotification("Brak graczy w pobliżu!")
								else
								  	TriggerServerEvent("route68jail:jailPlayerRoute68", GetPlayerServerId(closestPlayer), jailTime, reason)
								end

						  	end

						end, function(data3, menu3)
							menu3.close()
						end)
              		end

				end

          	end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "unjail_player" then

			local elements = {}

			ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(playerArray)

				if #playerArray == 0 then
					ESX.ShowNotification("Więzienie jest puste!")
					return
				end

				for i = 1, #playerArray, 1 do
					table.insert(elements, {label = "Skazany/a: " .. playerArray[i].name .. " | Pozostała odsiadka: " .. playerArray[i].jailTime .. " minut", value = playerArray[i].identifier })
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'jail_unjail_menu',
					{
						title = "Ułaskaw Więźnia",
						align = "left",
						elements = elements
					},
				function(data2, menu2)

					local action = data2.current.value

					TriggerServerEvent("esx-qalle-jail:unJailPlayer", action)

					menu2.close()

				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		end

	end, function(data, menu)
		menu.close()
	end)
end
