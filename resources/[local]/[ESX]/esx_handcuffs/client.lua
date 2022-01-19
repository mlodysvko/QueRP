local handcuffTimer, dragStatus = {}, {}
local isDead, isHandcuffed, handsup, odprzodu, odtylu = false, false, true, false, false
local prop = nil
dragStatus.isDragged = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('playerSpawned', function(spawn) isDead = false TriggerEvent('Tomci0:AwariaRozkuj') end)

AddEventHandler('esx:onPlayerDeath', function(data) isDead = true end)



function HanducuffMenu()

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'kajdany', {
		title    = 'Menu Kajdanek',
		align    = 'center',
		elements = {
            {label = 'Zakuj/Rozkuj Obywatela', value = 'cuff'},
            {label = 'Przeszukaj Obywatela', value = 'search'},
            {label = 'Przenieś Obywatela', value = 'drag'},
            {label = 'Wsadź Obywatela do Pojazdu', value = 'puttovehicle'},
            {label = 'Wyjmij Obywatela z Pojazdu', value = 'outofvehicle'},
        }
    }, function(data, menu)
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            local action = data.current.value

			if action == 'cuff' then
				local dupa = GetPlayerPed(closestPlayer)
				local lapy = IsEntityPlayingAnim(dupa, "missminuteman_1ig_2", "handsup_enter", 3)
				local zakuty = IsEntityPlayingAnim(dupa, "mp_arresting", "idle", 3)

				-- if lapy and not zakuty or IsPlayerDead(closestPlayer) and not IsPedCuffed(dupa) then
					TriggerServerEvent('Tomci0:zakuj', GetPlayerServerId(closestPlayer))
					TriggerEvent("FeedM:showNotification", 'Zakułeś/Rozkułeś obywatela ' ..GetPlayerServerId(closestPlayer), 4000, 'primary')
					TriggerServerEvent('Tomci0:Powiadomienie', GetPlayerServerId(closestPlayer), 'Zostałeś zakuty/rozkuty prez obywatela ' ..GetPlayerServerId(closestPlayer))
				-- else
				-- 	TriggerServerEvent('Tomci0:zakuj', GetPlayerServerId(closestPlayer))
				-- 	TriggerEvent("FeedM:showNotification", 'Rozkułeś obywatela ' ..GetPlayerServerId(closestPlayer), 4000, 'primary')
				-- 	TriggerServerEvent('Tomci0:Powiadomienie', GetPlayerServerId(closestPlayer), 'Zostałeś rozkuty prez obywatela ' ..GetPlayerServerId(closestPlayer))
				-- end
			elseif action == 'drag' then
				TriggerServerEvent('Tomci0:PodPache', GetPlayerServerId(closestPlayer))
				elseif action == 'worek' then
					TriggerServerEvent('esx_worek:naloz', GetPlayerServerId(closestPlayer))
			elseif action == 'puttovehicle' then
				-- if IsPedCuffed(GetPlayerPed(closestPlayer)) then
					TriggerServerEvent('Tomci0:doPojazdu', GetPlayerServerId(closestPlayer))
				-- else
				-- 	TriggerEvent("FeedM:showNotification", 'Gracz nie jest zakuty!', 4000, 'primary')
				-- end
			elseif action == 'outofvehicle' then
				TriggerServerEvent('Tomci0:zPojazdu', GetPlayerServerId(closestPlayer))
			elseif action == 'search' then
				local dupa = GetPlayerPed(closestPlayer)
				local xd1 = IsEntityPlayingAnim(dupa, "missminuteman_1ig_2", "handsup_enter", 3)
				local xd2 = IsEntityPlayingAnim(dupa, "mp_arresting", "idle", 3)

				if xd1 or xd2 and not IsPlayerDead(closestPlayer) or IsPlayerDead(closestPlayer) then
					SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
					Citizen.Wait(1)
					PrzeszukajMenu(closestPlayer)
				else
					TriggerEvent("FeedM:showNotification", 'Nie można przeszukać tego obywatela!', 4000, 'primary')
				end	
            end
        else
            TriggerEvent("FeedM:showNotification", 'Nie ma żadnego obywatela w pobliżu!', 4000, 'primary')
        end
    end, function(data, menu)
        menu.close()
    end)
end


function PrzeszukajMenu(player)

	TriggerEvent("FeedM:showNotification", 'Przeszukujesz gracza ' ..GetPlayerServerId(player), 4000, 'primary')
	TriggerServerEvent('Tomci0:Powiadomienie', GetPlayerServerId(player), 'Jesteś przeszukiwany przez obywatela ' ..GetPlayerServerId(player))

	ESX.TriggerServerCallback('Tomci0:GetInfo', function(data)
		local elements = {}

		table.insert(elements, {label = '<font color=#6CFFFF><center>~* Przedmioty *~</center></font>'})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = '[x' ..data.inventory[i].count.. '] ' ..data.inventory[i].label,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count,
					itemName = data.inventory[i].label,
				})
			end
		end

		table.insert(elements, {label = '<font color=#6CFFFF><center>~* Bronie *~</center></font>'})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = '[x' .. data.weapons[i].ammo..' ammo] ' ..ESX.GetWeaponLabel(data.weapons[i].name),
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo,
				itemName = ESX.GetWeaponLabel(data.weapons[i].name)
			})
		end


		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = "Ekwipunek Obywatela " ..GetPlayerServerId(player),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			if data.current.itemType ~= 'item_weapon' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = 'Ile ' ..data.current.itemName.. ' chcesz zabrac?'
				}, function(data2, menu2)
					local count = tonumber(data2.value)

					if not count then
						ESX.ShowNotification('Niepoprawna Ilość!')
					else
						menu2.close()
						menu.close()
						TriggerServerEvent('Tomci0:ZabierzPrzedmiot', GetPlayerServerId(player), data.current.itemType, data.current.value, count)
						PrzeszukajMenu(player)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			else
				menu2.close()
				menu.close()
				TriggerServerEvent('Tomci0:ZabierzPrzedmiot', GetPlayerServerId(player), data.current.itemType, data.current.value, count)
				PrzeszukajMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

-- RegisterNetEvent('Tomci0:Zakuj')
-- AddEventHandler('Tomci0:Zakuj', function()
-- 	local playerPed = PlayerPedId()

-- 	if not isHandcuffed then
-- 		RequestAnimDict('mp_arresting')
-- 		while not HasAnimDictLoaded('mp_arresting') do
-- 			Citizen.Wait(100)
-- 		end

-- 		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

--         NetworkSetFriendlyFireOption(false)
--         SetCanAttackFriendly(playerPed, false, false)
--         SetEnableHandcuffs(playerPed, true)
-- 		DisablePlayerFiring(playerPed, true)
-- 		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
--         SetPedCanPlayGestureAnims(playerPed, false)
--         TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'kajdanki', 0.3)
--         isHandcuffed = true
--     else
--         TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'cuff', 0.3)
-- 		ClearPedSecondaryTask(playerPed)
-- 		SetEnableHandcuffs(playerPed, false)
-- 		DisablePlayerFiring(playerPed, false)
--         SetPedCanPlayGestureAnims(playerPed, true)
--         NetworkSetFriendlyFireOption(true)
--         SetCanAttackFriendly(playerPed, true, true)
--         isHandcuffed = false
-- 	end
-- end)

RegisterNetEvent('Tomci0:Zakuj')
AddEventHandler('Tomci0:Zakuj', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)

	Citizen.CreateThread(function()
		if isHandcuffed then
			ESX.UI.Menu.CloseAll()
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			local dupa = GetPlayerPed(closestPlayer)
			local Ja = GetEntityHeading(GetPlayerPed(-1))
			local Ty = GetEntityHeading(dupa)
			local roznica = math.abs(Ja - Ty)

			if roznica > 90 then
				TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'cuff', 0.3)
				ClearPedTasks(playerPed)
				TaskPlayAnim(playerPed, 'rcmme_amanda1', 'stand_loop_ama', 8.0, 3.0, -1, 50, 0, 0, 0, 0)
				prop = CreateObject(GetHashKey('p_cs_cuffs_02_s'), GetEntityCoords(PlayerPedId()), true)
				AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), -0.030, 0.0, 0.070, 110.0, 90.0, 100.0, 1, 0, 0, 0, 0, 1)

				SetEnableHandcuffs(playerPed, true)
				DisablePlayerFiring(playerPed, true)
				SetPedCanPlayGestureAnims(playerPed, true)
				odprzodu = true
			elseif not FastHandcuffed then
				TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'cuff', 0.3)
				ClearPedTasks(playerPed)
				TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, 3.0, -1, 50, 0, 0, 0, 0)
				prop = CreateObject(GetHashKey('p_cs_cuffs_02_s'), GetEntityCoords(PlayerPedId()), true)
				AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), -0.030, 0.0, 0.070, 110.0, 90.0, 100.0, 1, 0, 0, 0, 0, 1)
				
				SetEnableHandcuffs(playerPed, true)
				DisablePlayerFiring(playerPed, true)
				SetPedCanPlayGestureAnims(playerPed, true)
				odtylu = true
			end
		else
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'kajdanki', 0.3)
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, false)
			DeleteEntity(prop)
			prop = nil
			odprzodu = false
			odtylu = false
			DetachEntity(playerPed, true, false)
			dragStatus.isDragged = false
		end
	end)
end)

RegisterNetEvent('Tomci0:AwariaRozkuj')
AddEventHandler('Tomci0:AwariaRozkuj', function()
	if isHandcuffed then
		isHandcuffed = false
		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, false)
		DeleteEntity(prop)
		prop = nil
		odprzodu = false
		odtylu = false
		DetachEntity(playerPed, true, false)
		dragStatus.isDragged = false
	end
end)
		
		

--[[ Przenoszenie Ludzi by Tomci0 ]]--

RegisterNetEvent('Tomci0:PodPache')
AddEventHandler('Tomci0:PodPache', function(copId)
 	if isHandcuffed then
 		dragStatus.isDragged = not dragStatus.isDragged
 		dragStatus.CopId = copId
    else
        TriggerEvent("FeedM:showNotification", 'Obywatel nie jest zakuty!', 4000, 'primary')
    end
end)

Citizen.CreateThread(function()
 	local wasDragged

 	while true do
 		Citizen.Wait(0)
 		local playerPed = PlayerPedId()

 		if isHandcuffed and dragStatus.isDragged then
 			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

 			if DoesEntityExist(targetPed)then
 				if not wasDragged then
 					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
 					wasDragged = true
 				else
 					Citizen.Wait(1000)
				end
			end
 		elseif wasDragged then
 			wasDragged = false
 			DetachEntity(playerPed, true, false)
 		else
 			Citizen.Wait(500)
 		end
 	end
end)

--[[ Wsadzanie do Pojazdu by Tomci0 ]]--

RegisterNetEvent('Tomci0:doPojazdu')
AddEventHandler('Tomci0:doPojazdu', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if IsAnyVehicleNearPoint(coords, 5.0) then
			local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

			if DoesEntityExist(vehicle) then
				local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

				for i=maxSeats - 1, 0, -1 do
					if IsVehicleSeatFree(vehicle, i) then
						freeSeat = i
						break
					end
				end

				if freeSeat then
					TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
					dragStatus.isDragged = false
				end
			end
		end
	end
end)


--[[RegisterNetEvent('Tomci0:doPojazdu')
AddEventHandler('Tomci0:doPojazdu', function()

	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			local freeSeat = nil

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat ~= nil then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				DragStatus.IsDragged = false
			end
		end
	end
end)]]--

--[[ Wysadzanie z Pojazdu by Tomci0 ]]--

RegisterNetEvent('Tomci0:zPojazdu')
AddEventHandler('Tomci0:zPojazdu', function()
	local playerPed = PlayerPedId()

	if isHandcuffed then
		if IsPedSittingInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			TaskLeaveVehicle(playerPed, vehicle, 64)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if isHandcuffed then
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1

			DisableControlAction(0, 45, true) -- Reload
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

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			-- DisableControlAction(0, 75, true)
			-- DisableControlAction(0, 75, true)
			DisableControlAction(0, 318, true)
			DisableControlAction(0, 27, true)

			SetPlayerCanDoDriveBy(PlayerId(), false)

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
			ESX.UI.Menu.CloseAll()
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('Tomci0:OtworzKajdanki')
AddEventHandler('Tomci0:OtworzKajdanki', function()
	if not isHandcuffed then
		if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			hasPhone(function (hasPhone)
				if hasPhone == true then
					HanducuffMenu()
				else
					TriggerEvent("FeedM:showNotification", 'Nie posiadasz przy sobie kajdanek!', 4000, 'primary')
				end
			end)
		else
			TriggerEvent("FeedM:showNotification", 'Nie możesz używać kajdanek w pojeździe!', 4000, 'primary')
		end
	else
		TriggerEvent("FeedM:showNotification", 'Jesteś zakuty! Nie możesz używać kajdanek!', 4000, 'primary')
		
	end
end)

--WOREK NA LEB


RegisterCommand('handcuffmenu', function()
	if IsControlPressed(0, 21) then
		if not isHandcuffed then
			if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
				hasPhone(function (hasPhone)
					if hasPhone == true then
						HanducuffMenu()
					else
						TriggerEvent("FeedM:showNotification", 'Nie posiadasz przy sobie kajdanek!', 4000, 'primary')
					end	
				end)
			else
				TriggerEvent("FeedM:showNotification", 'Nie możesz używać kajdanek w pojeździe!', 4000, 'primary')
			end
		else
			TriggerEvent("FeedM:showNotification", 'Jesteś zakuty! Nie możesz używać kajdanek!', 4000, 'primary')
		end
	end
end, false)

function hasPhone (cb)
	if (ESX == nil) then return cb(0) end
	ESX.TriggerServerCallback('Tomci0:GetKajdanki', function(qtty)
		if qtty > 0 then
			cb(true)
		else
			cb(false)
		end
	end, 'handcuffs')
end

RegisterKeyMapping('handcuffmenu', 'Drugi klawisz otwierania kajdanek', 'keyboard', 'E')

function procent(time, cb)
	if cb ~= nil then
		Citizen.CreateThread(function()
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