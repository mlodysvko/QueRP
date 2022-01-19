-----------------------------------------
-- Created by Mr Dawid#7841
-----------------------------------------
local PlayerData, GUI, CurrentActionData, JobBlips = {}, {}, {}, {}
local HasAlreadyEnteredMarker, publicBlip = false, false
local LastZone, CurrentAction, CurrentActionMsg

local LastStation             = nil
local LastPart                = nil
local LastPartNum             = nil
local CurrentActionData       = {}
local onDuty 		          = false
local hintToDisplay           = "no hint to display"
local hintIsShowed            = false

ESX = nil
GUI.Time = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if hintIsShowed == true then
		SetTextComponentFormat("STRING")
		AddTextComponentString(hintToDisplay)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	  end
	end
  end)
  
function TeleportFadeEffect(entity, coords)

	Citizen.CreateThread(function()

		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		ESX.Game.Teleport(entity, coords, function()
			DoScreenFadeIn(800)
		end)
	end)
end

function OpenCloakroomActionsMenu()

	local elements = {
		{label = _U('psm_clothes_civil'), value = 'citizen_wear'},
		{label = _U('psm_clothes_psm'), value = 'psm_wear'},
		{label = _U('deposit_stock'), value = 'put_stock'}
	}

	if Config.EnablePlayerManagement and PlayerData.job ~= nil and (PlayerData.job.grade_name ~= 'recrue' and PlayerData.job.grade_name ~= 'novice')then -- Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss'
		table.insert(elements, {label = _U('take_stock'), value = 'get_stock'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom_actions', {
			title    = 'Szafka',
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'put_stock' then
				OpenPutStocksMenu()
			end

			if data.current.value == 'get_stock' then
				OpenGetStocksMenu()
			end

			if data.current.value == 'citizen_wear' then

				TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_COP_IDLES", 0, true)
				Wait(Config.Czasprzebierania * 1000 + 250)
				ClearPedTasks(GetPlayerPed(-1))
				  onDuty = false
  
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if data.current.value == 'psm_wear' then

				TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_COP_IDLES", 0, true)
				Wait(Config.Czasprzebierania * 1000 + 250)
				ClearPedTasks(GetPlayerPed(-1))
				  onDuty = true
  
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					else
						TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					end
				end)
			end

			menu.close()

			CurrentAction     = 'cloakroom_actions_menu'
			CurrentActionMsg  = _U('press_to_open')
			CurrentActionData = {}
		end)
end


function OpenPsmActionsMenu()

	local elements = {
	}
  
	if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then -- Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss'
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'psm_actions', {
			title    = 'Firma 4PSM',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'boss_actions' then
				TriggerEvent('esx_society:openBossMenu', 'psm', function(data, menu)
					menu.close()
				end)
			end
		end, function(data, menu)

			menu.close()

			CurrentAction     = 'psm_actions_menu'
			CurrentActionMsg  = _U('press_to_open_boss')
			CurrentActionData = {}
		end)
end


function OpenVehicleSpawnerMenu(station, partNum)
	print(station, partNum)
	local vehicles = Config.PSM[station].Vehicles

	ESX.UI.Menu.CloseAll()

	local elements = {}

	for _, vehicle in ipairs(Config.AuthorizedVehicles) do
		local let = false
		if vehicle.grade then
			if not CanPlayerUse(vehicle.grade) then
				let = false
			else
				let = true
			end
		elseif vehicle.grades and #vehicle.grades > 0 then
			let = false
			for _, grade in ipairs(vehicle.grades) do
				if grade == PlayerData.job.grade then
					let = true
					break
				end
			end
		end
		if let then
			table.insert(elements, { label = vehicle.label, model = vehicle.model, plate = vehicle.plate })
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
		title    = _U('vehicle_menu'),
		align    = 'center',
		elements = elements
	  }, function(data, menu)
		ESX.Game.SpawnVehicle(data.current.model, {x = Config.PSM[station].Vehicles[partNum].SpawnPoint.x, y = Config.PSM[station].Vehicles[partNum].SpawnPoint.y, z = Config.PSM[station].Vehicles[partNum].SpawnPoint.z}, Config.PSM[station].Vehicles[partNum].heading, function(vehicle)
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			if setPlate then
			  local plate = "PSM " .. GetRandomIntInRange(1000,9999)
			  SetVehicleNumberPlateText(vehicle, plate)
			end
			TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
		end)
	  end,
	  function(data, menu)
		menu.close()
	end)

end

function CanPlayerUse(grade)
	return not grade or PlayerData.job.grade >= grade
end

function OpenMobileVigneActionsMenu()

	

	ESX.UI.Menu.Open('defau', GetCurrentResourceName(), 'mobile_psm_actions', {
			title    = 'PSM',
			align    = 'top-left',
			elements = {
			}
		}, function(data, menu)

			if data.current.value == 'billing' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
						title = _U('invoice_amount')
					}, function(data, menu)

						local amount = tonumber(data.value)

						if amount == nil or amount <= 0 then
							ESX.ShowNotification(_U('amount_invalid'))
						else
							menu.close()

							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification(_U('no_players_near'))
							else
								local playerPed        = GetPlayerPed(-1)

								Citizen.CreateThread(function()
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
									Citizen.Wait(5000)
									ClearPedTasks(playerPed)
									TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_psm', 'PSM', amount)
								end)
							end
						end
					end, function(data, menu)
						menu.close()
					end)
			end
		end, function(data, menu)
			menu.close()
		end)
end

function OpenGetStocksMenu()

	ESX.TriggerServerCallback('esx_psm:getStockItems', function(items)

		print(json.encode(items))

		local elements = {}

		for i=1, #items, 1 do
			if (items[i].count ~= 0) then
				table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
				title    = 'Schowek',
				align    = 'top-left',
				elements = elements
			}, function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
						title = _U('quantity')
					}, function(data2, menu2)
		
						local count = tonumber(data2.value)

						if count == nil or count <= 0 then
							ESX.ShowNotification(_U('quantity_invalid'))
						else
							menu2.close()
							menu.close()
							OpenGetStocksMenu()

							TriggerServerEvent('esx_psm:getStockItem', itemName, count)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
			end, function(data, menu)
				menu.close()
			end)
	end)
end

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('esx_psm:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do

			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
				title    = _U('inventory'),
				elements = elements
			}, function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
						title = _U('quantity')
					}, function(data2, menu2)

						local count = tonumber(data2.value)

						if count == nil or count <= 0 then
							ESX.ShowNotification(_U('quantity_invalid'))
						else
							menu2.close()
							menu.close()
							OpenPutStocksMenu()

							TriggerServerEvent('esx_psm:putStockItems', itemName, count)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
			end, function(data, menu)
				menu.close()
			end)
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	blips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	deleteBlips()
	blips()
end)

AddEventHandler('esx_psm:hasEnteredMarker', function(zone, station, partNum)
	if zone == 'Material' and PlayerData.job ~= nil and PlayerData.job.name == 'psm' and onDuty == true then
		CurrentAction     = 'material_harvest'
		CurrentActionMsg  = _U('press_material')
		CurrentActionData = {zone= zone}
	end
		
	if zone == 'Szycie' and onDuty == true then
		CurrentAction     = 'szycie'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone= zone}
	end		
		
	if zone == 'Pakowanie' and onDuty == true then
		CurrentAction     = 'pakowanie'
		CurrentActionMsg  = _U('press_traitement')
		CurrentActionData = {zone = zone}
	end
		
	if zone == 'SellFarm' and onDuty == true then
		CurrentAction     = 'farm_resell'
		CurrentActionMsg  = _U('press_sell')
		CurrentActionData = {zone = zone}
	end

	if zone == 'PsmActions' and PlayerData.job ~= nil and PlayerData.job.name == 'psm' then
		CurrentAction     = 'psm_actions_menu'
		CurrentActionMsg  = _U('press_to_open_boss')
		CurrentActionData = {}
	end
  
	if zone == 'Cloakrooms' and PlayerData.job ~= nil and PlayerData.job.name == 'psm' then
		CurrentAction     = 'cloakroom_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end

	if zone == 'Vehicles' and PlayerData.job ~= nil and PlayerData.job.name == 'psm' then
		CurrentAction     = 'vehicle_spawner_menu'
		CurrentActionMsg  = _U('spawn_veh')
		CurrentActionData = {station = station, partNum = partNum}
	end
		
	if zone == 'VehicleDeleter' and PlayerData.job ~= nil and PlayerData.job.name == 'psm' then

		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)
		
		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle, distance = ESX.Game.GetClosestVehicle({
				x = coords.x,
				y = coords.y,
				z = coords.z
			})

			if distance ~= -1 and distance <= 1.0 then

				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('store_veh')
				CurrentActionData = {vehicle = vehicle}
			end
		end
	end
end)

AddEventHandler('esx_psm:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	if (zone == 'Material') and PlayerData.job ~= nil and PlayerData.job.name == 'psm' then
		TriggerServerEvent('esx_psm:stopHarvest')
	end  
	if (zone == 'Szycie' or zone == 'Pakowanie') and PlayerData.job ~= nil and PlayerData.job.name == 'psm' then
		TriggerServerEvent('esx_psm:stopTransform')
	end
	if (zone == 'SellFarm') and PlayerData.job ~= nil and PlayerData.job.name == 'psm' then
		TriggerServerEvent('esx_psm:stopSell')
	end
	CurrentAction = nil
	hintIsShowed = false
end)

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
		RemoveBlip(JobBlips[i])
		JobBlips[i] = nil
		end
	end
end

-- Create Blips
function blips()
    if PlayerData.job ~= nil and PlayerData.job.name == 'psm' then

		for k,v in pairs(Config.Zones)do
			if v.Type == 1 then
				local blip2 = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

				SetBlipSprite (blip2, Config.Blipikon)
				SetBlipDisplay(blip2, 4)
				SetBlipScale  (blip2, Config.Blipwielkosc)
				SetBlipColour (blip2, Config.Blipkolor)
				SetBlipAsShortRange(blip2, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(v.Name)
				EndTextCommandSetBlipName(blip2)
				table.insert(JobBlips, blip2)
			end
		end
	end
end
-- Display markers
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if PlayerData.job ~= nil and PlayerData.job.name == 'psm' and onDuty == true then
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end

		for k,v in pairs(Config.PSM) do
			if PlayerData.job ~= nil and PlayerData.job.name == 'psm' then
				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.PsmActions, 1 do
					if GetDistanceBetweenCoords(coords, v.PsmActions[i].x, v.PsmActions[i].y, v.PsmActions[i].z, true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.PsmActions[i].x, v.PsmActions[i].y, v.PsmActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Vehicles, 1 do
					if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < Config.DrawDistance then
						DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do

		Wait(0)

		if PlayerData.job ~= nil and PlayerData.job.name == 'psm' then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentPart = k
				end
			end

			
			for k,v in pairs(Config.PSM) do

				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Cloakrooms'
						currentPartNum = i
					end
				end

				for i=1, #v.PsmActions, 1 do
					if GetDistanceBetweenCoords(coords, v.PsmActions[i].x, v.PsmActions[i].y, v.PsmActions[i].z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'PsmActions'
						currentPartNum = i
					end
				end

				for i=1, #v.Vehicles, 1 do
					if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Vehicles'
						currentPartNum = i
					end
				end

				for i=1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < Config.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'VehicleDeleter'
						currentPartNum = i
					end
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentPart) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentPart
				TriggerEvent('esx_psm:hasEnteredMarker', currentPart, currentStation, currentPartNum)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_psm:hasExitedMarker', LastZone)
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  38) and PlayerData.job ~= nil and PlayerData.job.name == 'psm' and (GetGameTimer() - GUI.Time) > 300 then
				if CurrentAction == 'material_harvest' then
					TriggerServerEvent('esx_psm:startHarvest', CurrentActionData.zone)
					hintToDisplay = "Aby zakończyć pracę, opuść teren"
					hintIsShowed = true
				end
				if CurrentAction == 'szycie' then
					TriggerServerEvent('esx_psm:startTransform', CurrentActionData.zone)
					hintToDisplay = "Aby zakończyć pracę, opuść teren"
					hintIsShowed = true
				end
				if CurrentAction == 'pakowanie' then
					TriggerServerEvent('esx_psm:startTransform', CurrentActionData.zone)
					hintToDisplay = "Aby zakończyć pracę, opuść teren"
					hintIsShowed = true
				end
				if CurrentAction == 'farm_resell' then
					TriggerServerEvent('esx_psm:startSell', CurrentActionData.zone)
					hintToDisplay = "Aby zakończyć pracę, opuść teren"
					hintIsShowed = true
				end
				
				if CurrentAction == 'psm_actions_menu' then
					OpenPsmActionsMenu()
				end
				if CurrentAction == 'cloakroom_actions_menu' then
					OpenCloakroomActionsMenu()
				end
				if CurrentAction == 'vehicle_spawner_menu' then
					OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
				end
				if CurrentAction == 'delete_vehicle' then

					if Config.EnableSocietyOwnedVehicles then
						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'psm', vehicleProps)
					end

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()
			end
		end

		if IsControlPressed(0,  167) and Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'psm' and (GetGameTimer() - GUI.Time) > 150 then
			OpenMobileVigneActionsMenu()
			GUI.Time = GetGameTimer()
		end
	end
end)