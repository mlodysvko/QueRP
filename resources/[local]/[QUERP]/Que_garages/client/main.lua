local GUI                     = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentZone             = nil
local LastGarage              = nil
local CurrentGarage           = nil
local PlayerData              = {}
local CurrentAction           = nil
local IsInShopMenu            = false
local pCoords 				  = nil
local isInVehicle             = false
ESX                           = nil
GUI.Time                      = 0

Citizen.CreateThread(function()
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

-- Create Blips
Citizen.CreateThread(function()
	for i=1, #Config.Garages do
		if Config.Garages[i].Blip == true then
			local blip = AddBlipForCoord(Config.Garages[i].Marker)
			SetBlipSprite (blip, 50)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.5)
			SetBlipColour (blip, 38)
			SetBlipAsShortRange(blip, true)		
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('garage_blip'))
			EndTextCommandSetBlipName(blip)
		end
	end
	for i=1, #Config.Impound, 1 do
		local blip2 = AddBlipForCoord(Config.Impound[i])
		SetBlipSprite (blip2, 67)
		SetBlipDisplay(blip2, 4)
		SetBlipScale  (blip2, 0.6)
		SetBlipColour (blip2, 61)
		SetBlipAsShortRange(blip2, true)		
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('impound_blip'))
		EndTextCommandSetBlipName(blip2)
	end
end)

-- Check if is in vehicle
Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		isInVehicle = IsPedInAnyVehicle(playerPed)
		Citizen.Wait(500)
	end
end)

-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		local playerCoords = GetEntityCoords(PlayerPedId())
		local letSleep, isInMarker, hasExited = true, false, false

		-- GARAŻE
		local kolorr = 0
		local kolorg = 0
		local kolorb = 0
		for k,v in ipairs(Config.Garages) do
			local distance = #(playerCoords - v.Marker)

			if distance < Config.DrawDistance then
				if v.Visible[1] == nil then
					
					if isInVehicle then
						kolorr, kolorg, kolorb = 211, 0, 47
					else 
						kolorr, kolorg, kolorb = 47, 161, 211
					end
					DrawMarker(Config.MarkerType, v.Marker, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, kolorr, kolorg, kolorb, 100, false, true, 2, true, false, false, false)
					letSleep = false

					if distance < Config.MarkerSize.x then
						if isInVehicle then
							isInMarker, CurrentZone, CurrentGarage = true, 'park_car', v.Marker			
						else
							isInMarker, CurrentZone, CurrentGarage = true, 'pullout_car', v.Marker
						end
					end
				else
					for j,value in ipairs(v.Visible) do
						if PlayerData.job and PlayerData.job.name == value then
							DrawMarker(Config.MarkerType, v.Marker, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false

							if distance < Config.MarkerSize.x then
								if isInVehicle then
									isInMarker, CurrentZone, CurrentGarage = true, 'park_car', v.Marker			
								else
									isInMarker, CurrentZone, CurrentGarage = true, 'pullout_car', v.Marker
								end
							end
						end
					end
				end
			end
		end

		-- Impound
		for k,v in ipairs(Config.Impound) do
			local distance = #(playerCoords - v)

			if distance < Config.DrawDistance then

				DrawMarker(Config.MarkerType, v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)

				letSleep = false

				if distance < Config.MarkerSize.x then
					isInMarker, CurrentZone, CurrentGarage = true, 'impound_veh', v	
				end
			end
		end

		-- Police Impound
		if PlayerData.job and PlayerData.job.name == "police" then
			for k,v in ipairs(Config.PoliceImpound) do
				local distance = #(playerCoords - v)

				if distance < Config.DrawDistance then

					DrawMarker(Config.MarkerType, v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)

					letSleep = false

					if distance < Config.MarkerSize.x then
						isInMarker, CurrentZone, CurrentGarage = true, 'police_impound_veh', v	
					end
				end
			end
		end

		-- SetSubowner
		for k,v in ipairs(Config.SetSubowner) do
			local distance = #(playerCoords - v)

			if distance < Config.DrawDistance then

				DrawMarker(Config.MarkerType, v.x, v.y, v.z - 0.8, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)

				letSleep = false

				if distance < 2.5 then
					isInMarker, CurrentZone, CurrentGarage = true, 'subowner_veh', v
				end
			end
		end

		-- SellCar
		for k,v in ipairs(Config.SellCar) do
			local distance = #(playerCoords - v.Marker)

			if distance < Config.DrawDistance then

				DrawMarker(Config.MarkerType, v.Marker.x, v.Marker.y, v.Marker.z - 0.8, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)

				letSleep = false

				if distance < 2.5 then
					isInMarker, CurrentZone, CurrentGarage = true, 'sell_veh', v.Marker
				end
			end
		end

		-- Logic for exiting & entering markers
		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastZone ~= CurrentZone or LastGarage ~= CurrentGarage)) then
			if
				(LastGarage ~= nil and LastZone ~= nil) and
				(LastGarage ~= CurrentGarage or LastZone ~= CurrentZone)
			then
				TriggerEvent('flux_garages:hasExitedMarker', LastZone, LastGarage)
				hasExited = true
			end

			HasAlreadyEnteredMarker, LastZone, LastGarage = true, CurrentZone, CurrentGarage

			TriggerEvent('flux_garages:hasEnteredMarker', CurrentZone, CurrentGarage)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('flux_garages:hasExitedMarker', CurrentZone, CurrentGarage)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

function SpawnImpoundedVehicle(plate)
	TriggerServerEvent('flux_garages:updateState', plate)
end

function SubownerVehicle()
	ESX.UI.Menu.Open(
		'dialog', GetCurrentResourceName(), 'subowner_player',
		{
			title = _U('veh_reg'),
			align = 'center'
		},
		function(data, menu)
			local plate = string.upper(tostring(data.value))
			if string.len(plate) ~= 8 then
				ESX.ShowNotification(_U('no_veh'))
			else
				ESX.TriggerServerCallback('flux_garages:checkIfPlayerIsOwner', function(isOwner)
					if isOwner then
						menu.close()
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'subowner_menu',
							{
								title = _U('owner_menu', plate),
								align = 'center',
								elements	= {
									{label = _U('set_sub'), value = 'give_sub'},
									{label = _U('manage_sub'), value = 'manage_sub'},
								}
							},
							function(data2, menu2)
								if data2.current.value == 'give_sub' then
									local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									if closestPlayer ~= -1 and closestDistance <= 3.0 then
										TriggerServerEvent('flux_garages:setSubowner', plate, GetPlayerServerId(closestPlayer))
									else
										ESX.ShowNotification(_U('no_players'))
									end
								elseif data2.current.value == 'manage_sub' then
									ESX.TriggerServerCallback('flux_garages:getSubowners', function(subowners)
										if #subowners > 0 then
											ESX.UI.Menu.Open(
												'default', GetCurrentResourceName(), 'subowners',
												{
													title = _U('deleting_sub', plate),
													align = 'center',
													elements = subowners
												},
												function(data3, menu3)
													local subowner = data3.current.value
													ESX.UI.Menu.Open(
														'default', GetCurrentResourceName(), 'yesorno',
														{
															title = _U('sure_delete'),
															align = 'center',
															elements = {
																{label = _U('no'), value = 'no'},
																{label = _U('yes'), value = 'yes'}
															}
														},
														function(data4, menu4)
															if data4.current.value == 'yes' then
																TriggerServerEvent('flux_garages:deleteSubowner', plate, subowner)
																menu4.close()
																menu3.close()
																menu2.close()
															elseif data4.current.value == 'no' then
																menu4.close()
															end
														end,
														function(data4, menu4)
															menu4.close()
														end
													)													
												end,
												function(data3, menu3)
													menu3.close()
												end
											)
										else
											ESX.ShowNotification(_U('no_subs'))
										end
									end, plate)
								end
							end,
							function(data2,menu2)
								menu2.close()
							end
						)
					else
						ESX.ShowNotification(_U('not_owner'))
					end
				end, plate)
			end
		end,
		function(data,menu)
			menu.close()
		end
	)
end
-- Key controls
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(1)
		if CurrentAction ~= nil then
			if CurrentAction == 'park_car' then
				DisplayHelpText(_U('store_veh'))
			elseif CurrentAction == 'pullout_car' then
				DisplayHelpText(_U('release_veh'))
			elseif CurrentAction == 'tow_menu' then
				DisplayHelpText(_U('tow_veh'))
			elseif CurrentAction == 'police_impound_menu' then
				DisplayHelpText(_U('p_impound_veh'))
			end

			if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 300 then
				if CurrentAction == 'park_car' then
					local playerPed = GetPlayerPed(-1)
					local vehicle       = GetVehiclePedIsIn(playerPed)
					local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
					local name          = GetDisplayNameFromVehicleModel(vehicleProps.model)
					local plate         = vehicleProps.plate
					local health		= GetVehicleEngineHealth(vehicle)
					if health > Config.MinimumHealth then
						ESX.TriggerServerCallback('flux_garages:checkIfVehicleIsOwned', function (owned)
							if owned ~= nil then                    
								TriggerServerEvent("flux_garages:updateOwnedVehicle", vehicleProps)
								TaskLeaveVehicle(playerPed, vehicle, 16)
								ESX.Game.DeleteVehicle(vehicle)
							else
								ESX.ShowNotification(_U('not_owner'))
							end
						end, vehicleProps.plate)
					else
						ESX.ShowNotification(_U('repair'))
					end
				elseif CurrentAction == 'pullout_car' then
					SendNUIMessage({
						clearme = true
					})
					ESX.TriggerServerCallback('flux_garages:getVehiclesInGarage', function(vehicles)
						for i=1, #vehicles, 1 do
							local nazwa
							local nazwa2
							if nazwa == nil then
								nazwa = '#fc2200'
								if round(vehicles[i].engineHealth)/10 < 30.99 then
									nazwa = '#fc2200'
								elseif round(vehicles[i].engineHealth)/10 > 31 and round(vehicles[i].engineHealth)/10 < 75.99 then
									nazwa = '#fca400'
								elseif round(vehicles[i].engineHealth)/10 > 76 then
									nazwa = '#4dd446'
								end
							end

							if nazwa2 == nil then
								nazwa2 = '#fc2200'
								if round(vehicles[i].bodyHealth)/10 < 30.99 then
									nazwa2 = '#fc2200'
								elseif round(vehicles[i].bodyHealth)/10 > 31 and round(vehicles[i].bodyHealth)/10 < 75.99 then
									nazwa2 = '#fca400'
								elseif round(vehicles[i].bodyHealth)/10 > 76 then
									nazwa2 = '#4dd446'
								end
							end
							SendNUIMessage({
								addcar = true,
								number = i,
								model = vehicles[i].plate,
								name = "<font color=#000000>[ " .. vehicles[i].plate .. " ]</font>&emsp;<b>" ..  GetDisplayNameFromVehicleModel(vehicles[i].model) .. "</b>&emsp;  <font size=2.5></br><b>Silnik</b>: <font color="..nazwa..">" .. round(vehicles[i].engineHealth) /10 .. "%</font>" .. "&emsp;  <b>Karoseria</b>: <font color="..nazwa2..">" .. round(vehicles[i].bodyHealth) /10 .. "%</font>"
							})
						end
					end)
					openGui()
				elseif CurrentAction == 'tow_menu' then
					SendNUIMessage({
						clearimp = true
					})
					ESX.TriggerServerCallback('flux_garages:getVehiclesToTow', function(vehicles)
						for i=1, #vehicles, 1 do
							SendNUIMessage({
								impcar = true,
								number = i,
								model = vehicles[i].plate,
								name = "<font color=#000000>[" .. vehicles[i].plate .. "]</font>&emsp;" ..  GetDisplayNameFromVehicleModel(vehicles[i].model)
							})
						end
					end)
					openGui()
				elseif CurrentAction == 'police_impound_menu' then
					SendNUIMessage({
						clearpolice = true
					})
					ESX.TriggerServerCallback('flux_garages:getTakedVehicles', function(vehicles)
						for i=1, #vehicles, 1 do
							SendNUIMessage({
								policecar = true,
								number = i,
								model = vehicles[i].plate,
								name = "<font color=#000000>[" .. vehicles[i].plate .. "]</font>&emsp;" ..  GetDisplayNameFromVehicleModel(vehicles[i].model)
							})
						end
					end)
					openGui()
				end
				CurrentAction = nil
				GUI.Time      = GetGameTimer()
			end
		end
	end
end)

function round(n)
    if not n then return 0; end
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

RegisterNetEvent('flux_garages:otworzmenusubowner')
AddEventHandler('flux_garages:otworzmenusubowner', function()
	if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
		SubownerVehicle()
	end
end)

RegisterNetEvent('flux_garages:otworzmenusell')
AddEventHandler('flux_garages:otworzmenusell', function()
	if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
		SellVehicle()
	end
end)

Citizen.CreateThread(function()
	SetNuiFocus(false, false)
end)

-- Open Gui and Focus NUI
function openGui()
	SetNuiFocus(true, true)
	SendNUIMessage({openGarage = true})
end

-- Close Gui and disable NUI
function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openGarage = false})
end

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
	closeGui()
	cb('ok')
end)

-- NUI Callback Methods
RegisterNUICallback('pullCar', function(data, cb)
	local playerPed  = GetPlayerPed(-1)
	ESX.TriggerServerCallback('flux_garages:checkIfVehicleIsOwned', function (owned)
		local spawnCoords  = {
			x = CurrentGarage.x,
			y = CurrentGarage.y,
			z = CurrentGarage.z,
		}
		ESX.Game.SpawnVehicle(owned.model, spawnCoords, GetEntityHeading(playerPed), function(vehicle)
			TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
			ESX.Game.SetVehicleProperties(vehicle, owned)
			local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
			TriggerEvent("ls:newVehicle", localVehPlate)
			local networkid = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent("flux_garages:removeCarFromParking", owned.plate, networkid)
		end)
	end, data.model)
	closeGui()
	cb('ok')
end)

RegisterNUICallback('towCar', function(data, cb)
	closeGui()
	cb('ok')
	ESX.TriggerServerCallback('flux_garages:towVehicle', function(id)
		if id ~= nil then
			local entity = NetworkGetEntityFromNetworkId(tonumber(id))
			ESX.ShowNotification(_U('checking_veh'))
			Citizen.Wait(math.random(500, 4000))
			if entity == 0 then
				ESX.TriggerServerCallback('flux_garages:checkMoney', function(hasMoney)
					if hasMoney then
						ESX.ShowNotification(_U('checking_veh'))
						Citizen.Wait(math.random(500, 4000))
						TriggerServerEvent('flux_garages:pay')
						SpawnImpoundedVehicle(data.model)
						ESX.ShowNotification(_U('veh_impounded', data.model))
					else
						ESX.ShowNotification(_U('no_money'))
					end
				end)
			elseif entity ~= 0 and (GetVehicleNumberOfPassengers(entity) > 0 or not IsVehicleSeatFree(entity, -1)) then
				ESX.ShowNotification(_U('cant_impound'))
			else
				ESX.TriggerServerCallback('flux_garages:checkMoney', function(hasMoney)
					if hasMoney then
						TriggerServerEvent('flux_garages:pay')
						SpawnImpoundedVehicle(data.model)
						if entity ~= 0 then
							ESX.Game.DeleteVehicle(entity)
						end
						ESX.ShowNotification(_U('veh_impounded', data.model))
					else
						ESX.ShowNotification(_U('no_money'))
					end
				end)
			end
		else
			ESX.TriggerServerCallback('flux_garages:checkMoney', function(hasMoney)
				if hasMoney then
					ESX.ShowNotification(_U('checking_veh'))
					Citizen.Wait(math.random(500, 4000))
					TriggerServerEvent('flux_garages:pay')
					SpawnImpoundedVehicle(data.model)
					ESX.ShowNotification(_U('veh_impounded', data.model))
				else
					ESX.ShowNotification(_U('no_money'))
				end
			end)
		end
	end, data.model)
end)

RegisterNUICallback('impoundCar', function(data, cb)
	closeGui()
	cb('ok')
	local playerPed  = GetPlayerPed(-1)
	ESX.TriggerServerCallback('flux_garages:checkVehProps', function(veh)
		ESX.ShowNotification(_U('checking_veh'))
		Citizen.Wait(math.random(500, 4000))
		local spawnCoords  = {
			x = CurrentGarage.x,
			y = CurrentGarage.y,
			z = CurrentGarage.z,
		}
		ESX.Game.SpawnVehicle(veh.model, spawnCoords, GetEntityHeading(playerPed), function(vehicle)
			TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
			ESX.Game.SetVehicleProperties(vehicle, veh)
			local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
			TriggerEvent("ls:newVehicle", localVehPlate)
			local networkid = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent("flux_garages:removeCarFromPoliceParking", data.model, networkid)
		end)
	end, data.model)
	
end)

function DisplayHelpText(str)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentScaleform(str)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end

AddEventHandler('flux_garages:hasEnteredMarker', function (zone)
	if zone == 'pullout_car' then
		CurrentAction = 'pullout_car'
	elseif zone == 'park_car' then
		CurrentAction = 'park_car'
	elseif zone == 'impound_veh' then
		CurrentAction = 'tow_menu'
	elseif zone == 'police_impound_veh' then
		CurrentAction = 'police_impound_menu'
	elseif zone == 'subowner_veh' then
		CurrentAction = 'subowner_veh'
	elseif zone == 'sell_veh' then
		CurrentAction = 'sell_veh'
	end
end)

AddEventHandler('flux_garages:hasExitedMarker', function (zone)
	if IsInShopMenu then
		IsInShopMenu = false
    	CurrentGarage = nil
	end
	  
  	if not IsInShopMenu then
		ESX.UI.Menu.CloseAll()
  	end
  	CurrentAction = nil
end)

function SellVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'subowner_player',
	{
		title = _U('veh_reg'),
		align = 'center'
	},
	function(data, menu)
		local plate = string.upper(tostring(data.value))
		if string.len(plate) ~= 8 then
			ESX.ShowNotification(_U('no_veh'))
		else
			ESX.TriggerServerCallback('flux_garages:checkBeforeSell', function(isOwner, err, vehicle)
				if isOwner then
					menu.close()
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_menu_price',
					{
						title = _U('sell_menu_price'),
						align = 'center',
					},
					function(data2, menu2)
						local price = tonumber(data2.value)
						if price then
							menu2.close()
							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_menu_dialog',
							{
								title = _U('sell_vehicle_id'),
								align = 'center'
							},
							function(data3, menu3)
								local id = tonumber(data3.value)

								if id then
									if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(id))), true) < 10 then
										TriggerServerEvent('flux_garages:sellingProceed', id, price, plate, vehicle)
										ESX.ShowNotification(_U('offer_sent', id))
										menu3.close()
										menu2.close()
										menu.close()
									else
										ESX.ShowNotification(_U('player_offline'))
									end
								else
									ESX.ShowNotification(_U('wrong_id'))
								end
							end,
							function(data3,menu3)
								menu3.close()
							end)
						else
							ESX.ShowNotification(_U('wrong_price'))
						end
					end,
					function(data2,menu2)
						menu2.close()
					end)
				else
					if err == "not_owner" then
						ESX.ShowNotification(_U('not_owner'))
					elseif err == "not_garage" then
						ESX.ShowNotification(_U('not_garage'))
					end
				end
			end, plate)
		end
	end,
	function(data,menu)
		menu.close()
	end)
end

RegisterNetEvent('flux_garages:displayOffer')
AddEventHandler('flux_garages:displayOffer', function(offering, price, plate, vehicle)
	local vehicleData = json.decode(vehicle)
	local model = GetLabelText(GetDisplayNameFromVehicleModel(vehicleData.model))

	local elements = {
		{label = "Model auta: " .. model},
		{label = "Rejestracja: " .. plate},
		{label = "Cena: <span style='color:green'>$" .. price .."</span>"},
		{label = "<span style='color:green'>Potwierdź</span>", value="accept"},
		{label = "<span style='color:red'>Odrzuć</span>", value="decline"},
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'subowners',
	{
		title = _U('offer_received', offering),
		align = 'center',
		elements = elements
	},
	function(data, menu)

		if data.current.value == "accept" then
			TriggerServerEvent('flux_garages:vehicleSold', offering, price, plate)
			menu.close()
		end

		if data.current.value == "decline" then
			TriggerServerEvent('flux_garages:offerDeclined', offering)
			menu.close()
		end
												
	end,
	function(data, menu)
		TriggerServerEvent('flux_garages:offerDeclined', offering)
		menu.close()
	end)
end)

RegisterNetEvent('esx_giveownedcar:spawnVehicle')
AddEventHandler('esx_giveownedcar:spawnVehicle', function(model, playerID, playerName, type)
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local carExist  = false

	ESX.Game.SpawnVehicle(model, coords, 0.0, function(vehicle) --get vehicle info
		if DoesEntityExist(vehicle) then
			carExist = true
			SetEntityVisible(vehicle, false, false)
			SetEntityCollision(vehicle, false)
			
			local newPlate     = exports.esx_vehicleshop:GeneratePlate()
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			vehicleProps.plate = newPlate
			TriggerServerEvent('esx_giveownedcar:setVehicle', vehicleProps, playerID)
			ESX.Game.DeleteVehicle(vehicle)	
			if type ~= 'console' then
				ESX.ShowNotification(_U('gived_car', model, newPlate, playerName))
			else
				--local msg = ('addCar: ' ..model.. ', plate: ' ..newPlate.. ', toPlayer: ' ..playerName)
				--TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
			end				
		end		
	end)
	
	Wait(1000)
	if not carExist then
		if type ~= 'console' then
			ESX.ShowNotification(_U('unknown_car'))
		else
			--TriggerServerEvent('esx_giveownedcar:printToConsole', "ERROR: unknown car")
		end		
	end
end)