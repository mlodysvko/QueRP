local isLoadoutLoaded, isPaused, isDead = false, false, false
local lastLoadout = {}

CreateThread(function()
	while true do
		Citizen.Wait(0)

		if Citizen.InvokeNative(0xB8DFD30D6973E135, PlayerId()) then
			TriggerServerEvent('esx:onPlayerJoined')
			break
		end
	end
end)

ESX.UI.HUD.DisplayTicket = function(position)
	ESX.UI.HUD.RegisterElement('ticket', position, 0, '<div><img src="img/ticket.png"/>&nbsp;{{id}}</div>', {
	  id = '-'
	})
	ESX.UI.HUD.UpdateElement('ticket', {
	 id = GetPlayerServerId(PlayerId())
	})
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerLoaded = true
	ESX.PlayerData = playerData
	local loadingPosition = (ESX.PlayerData.coords or {x = -1042.28, y = -2745.42, z = 20.40})
	ESX.UI.HUD.DisplayTicket(0)

	--PVP
	SetCanAttackFriendly(playerPed, true, false)
	NetworkSetFriendlyFireOption(true)
	
	--Wanted LVL
	ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(0)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned')
	
	isLoadoutLoaded = true
	DecorRegister('isSpawned', 2)
	TriggerEvent('esx:restoreLoadout')
	Citizen.InvokeNative(0xABA17D7CE615ADBF, "FMMC_STARTTRAN")
	Citizen.InvokeNative(0xBD12F8228410D9B4, 4)
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	
	local ped = PlayerPedId()
	SetEntityCoords(ped, loadingPosition.x, loadingPosition.y, loadingPosition.z)
	FreezeEntityPosition(ped, false)

	Citizen.InvokeNative(0xEA1C610A04DB6BBB, ped, true)
	Citizen.InvokeNative(0x239528EACDC3E7DE, PlayerId(), false)
	StopAudioScene("MP_LEADERBOARD_SCENE")
	
	DoScreenFadeOut(0)	
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()

	SetPedMaxHealth(ped, 200)
	Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, ped, 200)
	Citizen.Wait(1000)
	
	TriggerServerEvent('esx_inventoryhud:getOwnedSim')
	
	Citizen.Wait(2000)

	ESX.UI.HUD.SetDisplay(1.0)
	
	TriggerEvent('chat:clear')
	Citizen.InvokeNative(0x10D373323E5B9C0D)
	Citizen.Wait(3000)
	DoScreenFadeIn(10000)
	StartServerSyncLoops()
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerServerEvent('esx_inventoryhud:getOwnedSim')
	end
end)

AddEventHandler('esx:onPlayerSpawn', function() 
	isDead = false 
end)

AddEventHandler('esx:onPlayerDeath', function() 
	isDead = true 
end)

AddEventHandler('skinchanger:loadDefaultModel', function() 
	isLoadoutLoaded = false 
end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(100)
	end

	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
	local playerPed = PlayerPedId()
	local ammoTypes = {}
	
	Citizen.InvokeNative(0xF25DF915FA38C5F3, playerPed, true)

	for k,v in ipairs(ESX.PlayerData.loadout) do
		local weaponName = v.name
		local weaponHash = GetHashKey(weaponName)

		Citizen.InvokeNative(0xBF0FD6E56C964FCB, playerPed, weaponHash, 0, false, false)
		SetPedWeaponTintIndex(playerPed, weaponHash, v.tintIndex)

		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

		for k2,v2 in ipairs(v.components) do
			local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash

			GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponHash, v.ammo)
			ammoTypes[ammoType] = true
		end
	end

	isLoadoutLoaded = true
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for k,v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count, showNotification)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
			ESX.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end

	if showNotification then
		ESX.UI.ShowInventoryItemNotification(true, item, count)
	end

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, showNotification)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
			if item == 'pistol_ammo' or 'rifle_ammo' then
			
			ESX.PlayerData.inventory[k].count = count
			break
		else
			ESX.UI.ShowInventoryItemNotification(false, v.label, v.count - count)
			ESX.PlayerData.inventory[k].count = count
			break
		end
		end
	end


	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)


--[[ weaponsync
RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, silent)

  for i=1, #ESX.PlayerData.inventory, 1 do
	if ESX.PlayerData.inventory[i].name == item.name then
	  ESX.PlayerData.inventory[i] = item
	end
  end

  if not silent then
	ESX.UI.ShowInventoryItemNotification(false, item, count)
  end

  if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
	ESX.ShowInventory()
  end

end)]]

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	ESX.PlayerData.hiddenjob = hiddenjob
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	--[[if weaponHash == 0 then
		-- nil
	elseif not isDead then]]
		Citizen.InvokeNative(0xBF0FD6E56C964FCB, playerPed, weaponHash, ammo, false, false)
	--end
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:removeWeaponAmmo')
AddEventHandler('esx:removeWeaponAmmo', function(weaponName, weaponAmmo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	--[[if weaponHash ~= 0 then
		local ammoType = GetPedAmmoType(playerPed, weaponHash)
		SetPedAmmoByType(playerPed, ammoType, GetPedAmmoByType(playerPed, ammoType) + weaponAmmo)
	end]]
	Citizen.InvokeNative(0x14E56BC5B5DB6A19, playerPed, weaponHash, weaponAmmo)
end)

RegisterNetEvent('esx:updateGiveAmmo')
AddEventHandler('esx:updateGiveAmmo', function(weaponName, weaponAmmo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	if weaponHash ~= 0 then
		local ammoType = GetPedAmmoType(playerPed, weaponHash)
		SetPedAmmoByType(playerPed, ammoType, weaponAmmo)
	end
end)



RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo', function(weaponName, weaponAmmo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	--[[if weaponHash ~= 0 then
		local ammoType = GetPedAmmoType(playerPed, weaponHash)
		SetPedAmmoByType(playerPed, ammoType, GetPedAmmoByType(playerPed, ammoType) + weaponAmmo)
	end]]
	Citizen.InvokeNative(0x14E56BC5B5DB6A19, playerPed, weaponHash, weaponAmmo)
end)

RegisterNetEvent('esx:setWeaponTint')
AddEventHandler('esx:setWeaponTint', function(weaponName, weaponTintIndex)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedWeaponTintIndex(playerPed, weaponHash, weaponTintIndex)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	Citizen.InvokeNative(0x4899CB088EDF59B8, playerPed, weaponHash)
	
	if ammo then
		local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
		local finalAmmo = math.floor(pedAmmo - ammo)
		
		Citizen.InvokeNative(0x14E56BC5B5DB6A19, playerPed, weaponHash, finalAmmo)
	else
		Citizen.InvokeNative(0x14E56BC5B5DB6A19, playerPed, weaponHash, 0)
	end
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(coords)
	local playerPed = PlayerPedId()

	-- ensure decmial number
	coords.x = coords.x + 0.0
	coords.y = coords.y + 0.0
	coords.z = coords.z + 0.0

	ESX.Game.Teleport(playerPed, coords)
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(vehicleName)
	local model = (type(vehicleName) == 'number' and vehicleName or GetHashKey(vehicleName))

	if IsModelInCdimage(model) then
		local playerPed = PlayerPedId()
		local playerCoords, playerHeading = GetEntityCoords(playerPed), GetEntityHeading(playerPed)

		ESX.Game.SpawnVehicle(model, playerCoords, playerHeading, function(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)
	else
		TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Invalid vehicle model.'}})
	end
end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model, coords)
	ESX.Game.SpawnObject(model, coords)
end)

RegisterNetEvent('esx:registerSuggestions')
AddEventHandler('esx:registerSuggestions', function(registeredCommands)
	for name,command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function(radius)
	local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)

		for k,entity in ipairs(vehicles) do
			local attempt = 0

			while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(entity)
				attempt = attempt + 1
			end

			if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
				ESX.Game.DeleteVehicle(entity)
			end
		end
	else
		local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end)

-- Keep track of ammo usage
function StartServerSyncLoops()

	--[[CreateThread(function()
		while true do
			Citizen.Wait(0)

			if isDead then
				Citizen.Wait(500)
			else
				local playerPed = PlayerPedId()

				if IsPedShooting(playerPed) then
					local _,weaponHash = GetCurrentPedWeapon(playerPed, true)
					local weapon = ESX.GetWeaponFromHash(weaponHash)

					if weapon then
						local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
						TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
					end
				end
			end
		end
	end)]]

	CreateThread(function()
		while true do
			Citizen.Wait(5000)
	
			local playerPed      = PlayerPedId()
			local loadout        = {}
			local loadoutChanged = false
	
			for k,v in ipairs(Config.Weapons) do
				local weaponName = v.name
				local weaponHash = GetHashKey(weaponName)
				local weaponComponents = {}
				local tint = 0
	
				if HasPedGotWeapon(playerPed, weaponHash, false) and weaponName ~= 'WEAPON_UNARMED' then
					local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
	
					for k2,v2 in ipairs(v.components) do
						if HasPedGotWeaponComponent(playerPed, weaponHash, v2.hash) then
							table.insert(weaponComponents, v2.name)
						end
					end

					if GetPedWeaponTintIndex(playerPed, weaponHash) > 0 then
						tint = GetPedWeaponTintIndex(playerPed, weaponHash)
					end
	
					if not lastLoadout[weaponName] or lastLoadout[weaponName] ~= ammo then
						loadoutChanged = true
					end
	
					lastLoadout[weaponName] = ammo
	
					table.insert(loadout, {
						name = weaponName,
						ammo = ammo,
						label = v.label,
						components = weaponComponents,
						tintIndex = tint
					})
				else
					if lastLoadout[weaponName] then
						loadoutChanged = true
					end
	
					lastLoadout[weaponName] = nil
				end
			end
	
			if loadoutChanged and isLoadoutLoaded then
				ESX.PlayerData.loadout = loadout
				TriggerServerEvent('esx:updateLoadout', loadout)
			end
		end
	end)

	CreateThread(function()
		local previousCoords = vector3(ESX.PlayerData.coords.x, ESX.PlayerData.coords.y, ESX.PlayerData.coords.z)

		while true do
			Citizen.Wait(5000)
			local playerPed = PlayerPedId()

			if DoesEntityExist(playerPed) then
				local playerCoords = GetEntityCoords(playerPed)
				local distance = #(playerCoords - previousCoords)

				if distance > 5 then
					previousCoords = playerCoords
					local playerHeading = ESX.Math.Round(GetEntityHeading(playerPed), 1)
					local formattedCoords = {x = ESX.Math.Round(playerCoords.x, 1), y = ESX.Math.Round(playerCoords.y, 1), z = ESX.Math.Round(playerCoords.z, 1), heading = playerHeading}
					TriggerServerEvent('esx:updateCoords', formattedCoords)
				end
			end
		end
	end)
	
end

CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustReleased(0, 289) then
			if exports['esx_ambulancejob']:getDeathStatus() or exports['esx_policejob']:isHandcuffed() then 
				TriggerEvent('esx:showNotification', 'Nie możesz otworzyć ekwipunku podczas bycia zakutym.')
			else
				ESX.ShowInventory()
			end
		end
	end
end)
