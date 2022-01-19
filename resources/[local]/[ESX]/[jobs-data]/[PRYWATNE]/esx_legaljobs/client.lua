ESX = nil
local PlayerData, CurrentAction = {}
local currentjoblocation = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
  	end
  
  	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function OpenOrganisationActionsMenu()
    ESX.UI.Menu.CloseAll()
	local elements = {}
	--[[if Config.Organisations[PlayerData.job.name].HandcuffsRestrictAction == true and PlayerData.job.grade >= Config.Interactions[PlayerData.job.name].HandcuffsRestrictAction then
		table.insert(elements, {label = 'Interakcja z Obywatelami', value = 'handcuffs-restrict'})
	end]]
	if PlayerData.job.grade >= Config.Interactions[PlayerData.job.name].repair then
		table.insert(elements, { label = 'Napraw pojazd', value = 'repair' })
	end
	if PlayerData.job.name == 'psycholog' then
		table.insert(elements, { label = 'Pokaż Legitymację', value = 'psycholog' })
	end
	if PlayerData.job.name == 'doj' then
		table.insert(elements, { label = 'Pokaż Legitymację', value = 'doj' })
	end


    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'organisation_actions',
    {
        title    = Config.Organisations[PlayerData.job.name].Label,
        align    = 'center',
        elements = elements
	}, function(data, menu)
		if data.current.value == 'handcuffs-restrict' then
			menu.close()
			exports['Island_kajdanki']:HandcuffsRestrictAction()
		elseif data.current.value == 'repair' then
			menu.close()
			exports['esx_mecanojob']:whyuniggarepairingme()
		elseif data.current.value == 'doj' then
			menu.close()
			TriggerServerEvent('dojodznaka')
		elseif data.current.value == 'psycholog' then 
			menu.close()
			TriggerServerEvent('psychologodznaka')

		end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenWeaponsMenu(station)
	ESX.UI.Menu.CloseAll()
	local elements = {
		{ label = 'Włóż broń', value = 'deposit' },
		{ label = 'Wyciągnij broń', value = 'withdraw' },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
	{
		title    = 'Zbrojownia',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'withdraw' then
			ESX.TriggerServerCallback('Island_stocks:getStock', function(inventory)
				local elements = {}
				for i=1, #inventory.weapons, 1 do
					local weapon = inventory.weapons[i]
					table.insert(elements, {
						label = ESX.GetWeaponLabel(weapon.name) .. ' [' .. weapon.ammo .. ']',
						type  = 'item_weapon',
						value = weapon.name,
						ammo  = weapon.ammo
					})
				end
			
				ESX.UI.Menu.Open(
				  'default', GetCurrentResourceName(), 'armory_get_weapon',
				  {
					title    = "Wyciągnij broń",
					align    = 'center',
					elements = elements,
				  },
				  function(data, menu)
					menu.close()
					TriggerServerEvent('Island_stocks:getWeaponInStock', data.current.value, data.current.ammo, station)
					ESX.SetTimeout(500, function()
						OpenWeaponsMenu(station)
					end)
				  end,
				  function(data, menu)
					menu.close()
				  end
				)
			  end, station)
		else
			local elements   = {}
			local playerPed  = GetPlayerPed(-1)
			local weaponList = ESX.GetWeaponList()
			for i=1, #weaponList, 1 do
				local weaponHash = GetHashKey(weaponList[i].name)
				if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
				table.insert(elements, {label = weaponList[i].label .. " [" .. ammo .. "]", value = weaponList[i].name, ammo = ammo})
				end
			end
			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'armory_put_weapon',
				{
				title    = "Włóż broń",
				align    = 'center',
				elements = elements,
				},
				function(data, menu)
					if data.current.ammo <= 1 then
						menu.close()
						TriggerServerEvent('Island_stocks:putWeaponInStock', data.current.value, data.current.ammo, station)
						ESX.SetTimeout(500, function()
							OpenWeaponsMenu(station)
						end)
					else
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_count', {
							title = "Ilość amunicji"
						}, function(data2, menu2)
							local quantity = tonumber(data2.value)
		
							if quantity == nil then
								ESX.ShowNotification("~r~Nieprawidłowa ilość")
							else
								if quantity <= data.current.ammo then
									menu.close()
									menu2.close()
									TriggerServerEvent('Island_stocks:putWeaponInStock', data.current.value, tonumber(data2.value), station)
									ESX.SetTimeout(500, function()
										OpenWeaponsMenu(station)
									end)
								else
									ESX.ShowNotification("~r~Nie masz tyle amunicji")
								end
							end
						end, function(data2, menu2)
							menu2.close()
						end)
					end
				end,
				function(data, menu)
				menu.close()
				end
			)
		end
	end, function(data, menu)
		menu.close()
		if isUsing then
			isUsing = false
			TriggerServerEvent('Island_organizations:setStockUsed', 'society_'..PlayerData.job.name, 'weapons', false)
		end
	end)
end

function OpenInventoryMenu(station)
	ESX.UI.Menu.CloseAll()
	local elements = {
		{label = "Włóż", value = 'deposit'},
		{label = "Wyciągnij", value = 'withdraw'}
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
	{
		title    = 'Magazyn',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'withdraw' then
			ESX.TriggerServerCallback('Island_stocks:getSharedInventoryInJob', function(inventory)
				local elements = {}
				for i=1, #inventory.items, 1 do
					local item = inventory.items[i]
					if item.count > 0 then
					table.insert(elements, {
						label = item.label .. ' x' .. item.count,
						type = 'item_standard',
						value = item.name
					})
					end
				end
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'stocks_menu',
					{
					title    = "Magazyn",
					align    = 'center',
					elements = elements
					},
					function(data, menu)
					local itemName = data.current.value
					ESX.UI.Menu.Open(
						'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
						{
						title = "Ilość",
						},
						function(data2, menu2)
							local count = tonumber(data2.value)
							if count == nil then
								ESX.ShowNotification("~r~Nieprawidłowa wartość!")
							else
								menu2.close()
								menu.close()
								TriggerServerEvent('Island_stocks:getItemInStock', data.current.type, data.current.value, count, station)
								ESX.SetTimeout(500, function()
									OpenInventoryMenu(station)
								end)
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
			end, station)
		else
			ESX.TriggerServerCallback('Island_stocks:getPlayerInventory', function(inventory)
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
					title    = "Ekwipunek",
					align    = 'center',
					elements = elements
					},
					function(data, menu)
					local itemName = data.current.value
					local itemType = data.current.type
					ESX.UI.Menu.Open(
						'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
						{
						title = "Ilość"
						},
						function(data2, menu2)
							local count = tonumber(data2.value)
							if count == nil then
								ESX.ShowNotification("~r~Nieprawidłowa wartość!")
							else
								menu2.close()
								menu.close()
								TriggerServerEvent('Island_stocks:putItemInStock', itemType, itemName, count, station)
								ESX.SetTimeout(500, function()
									OpenInventoryMenu(station)
								end)
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
	end, function(data, menu)
		menu.close()
		if isUsing then
			isUsing = false
			TriggerServerEvent('Island_organizations:setStockUsed', 'society_'..PlayerData.job.name, 'inventory', false)
		end
	end)
end

AddEventHandler('esx_organisation:hasEnteredMarker', function(zone)
	print(zone)
	if zone == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
		CurrentActionData = {}
	elseif zone == 'Inventory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafkę.')
		CurrentActionData = {station = station}
	elseif zone == 'Weapons' then
		CurrentAction     = 'menu_armory_weapons'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć zbrojownie.')
		CurrentActionData = {station = station}
	elseif zone == "BossMenu" then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = "Naciśnij ~INPUT_PICKUP~ aby otworzyć panel zarządzania"
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_organisation:hasExitedMarker', function(zone)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	zoneName = nil
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData.job ~= nil then
			if Config.Organisations[PlayerData.job.name] then
				local playerPed = PlayerPedId()
				local isInMarker  = false
				local currentZone = nil
				local coords, letSleep = GetEntityCoords(playerPed), true
				
				for k,v in pairs(Config.Organisations[PlayerData.job.name]) do
					if GetDistanceBetweenCoords(coords, v.coords, true) < Config.DrawDistance then
						letSleep = false
						DrawMarker(22, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 22, 219, 101, 80, false, true, 2, false, false, false, false)
					end

					if(GetDistanceBetweenCoords(coords, v.coords, true) < 1.5) then
						isInMarker  = true
						currentZone = k
					end
				end

				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker = true
					LastZone                = currentZone
					TriggerEvent('esx_organisation:hasEnteredMarker', currentZone)
				end

				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('esx_organisation:hasExitedMarker', LastZone)
				end

				if letSleep then
					Citizen.Wait(1000)
				end
			else
				Citizen.Wait(5000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(1)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, 38) and PlayerData.job and Config.Organisations[PlayerData.job.name] and not exports['esx_policejob']:isHandcuffed() and not exports['esx_ambulancejob']:getDeathStatus() then
				if CurrentAction == 'menu_armory' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestDistance > 3 or closestPlayer == -1 then
						ESX.TriggerServerCallback('Island_organizations:checkStock', function(isUsed)
							if not isUsed then
								isUsing = true
								TriggerServerEvent('Island_organizations:setStockUsed', 'society_'..PlayerData.job.name, 'inventory', true)
								zoneName = 'inventory'
								OpenInventoryMenu('society_' .. PlayerData.job.name)
							else
								ESX.ShowNotification("~r~Ktoś właśnie używa tej szafki")
							end
						end, 'society_'..PlayerData.job.name, 'inventory')
					else
						ESX.ShowNotification('Stoisz za blisko innego gracza!')
					end
				elseif CurrentAction == 'menu_armory_weapons' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestDistance > 3 or closestPlayer == -1 then
							OpenWeaponsMenu(CurrentActionData.station)
						else
							ESX.ShowNotification('Stoisz za blisko innego gracza!')
						end
				elseif CurrentAction == 'menu_cloakroom' then
					ESX.TriggerServerCallback('Island_stocks:getPlayerDressing', function(dressing)
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
								ESX.TriggerServerCallback('Island_stocks:getPlayerOutfit', function(clothes)
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
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					OpenBossMenu(PlayerData.job.name, Config.Organisations[PlayerData.job.name].BossMenu.from)
				end
				CurrentAction = nil
			end
		end
		if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
			if IsControlJustReleased(0, 167) and GetEntityHealth(GetPlayerPed(-1)) > 100 and PlayerData.job and Config.Interactions[PlayerData.job.name] then
				OpenOrganisationActionsMenu(PlayerData.job.name)
			end
		end
	end		
end)

function OpenBossMenu(job, grade)
		--print(org, grade)
	if PlayerData.job.grade >= grade then
		TriggerEvent('esx_society:openBossMenu', job, function(data, menu)
			menu.close()
		end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true })
	else
		TriggerEvent('esx_society:openBossMenu', job, function(data, menu)
			menu.close()
		end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false })
	end
end