ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('flux_garages:getOwnedVehicles', function (playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner',
	{
		['@owner'] = identifier
	},
	function (result2)
		local vehicles = {}

		for i=1, #result2, 1 do
			local vehicleData = json.decode(result[i].vehicle)
			table.insert(vehicles, vehicleData)
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('flux_garages:checkIfVehicleIsOwned', function (playerId, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	local found = nil
	local vehicleData = nil
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner',
	{ 
		['@owner'] = identifier
	},
	function (result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			vehicleData = json.decode(result2[i].vehicle)
			if vehicleData.plate == plate then
				found = true
				cb(vehicleData)
				break
			end
		end
		if not found then
			cb(nil)
		end
	end)
end)

ESX.RegisterServerCallback('flux_garages:checkVehProps', function (playerId, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate',
	{ 
		['@plate'] = plate
	},
	function (result2)
		if result2[1] then
			cb(json.decode(result2[1].vehicle))
		end
	end
	)
end)

ESX.RegisterServerCallback('flux_garages:checkIfPlayerIsOwner', function (playerId, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND owner_type = 1',
	{ 
		['@owner'] = identifier,
		['@plate'] = plate
	},
	function (result2)
		if result2[1] ~= nil then
			cb(true)
		else
			cb(false)
		end
	end)
end)

RegisterServerEvent('flux_garages:updateOwnedVehicle')
AddEventHandler('flux_garages:updateOwnedVehicle', function(vehicleProps)
 	local playerId = source
 	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner',
	{
		['@owner'] = identifier
	},
	function(result2) 
		local foundVehicleId = nil 
		for i=1, #result2, 1 do 				
			local vehicle = json.decode(result2[i].vehicle)
			if vehicle.plate == vehicleProps.plate then
				foundVehiclePlate = result2[i].plate
				break
			end
		end

		if foundVehiclePlate ~= nil then
			MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle, vehicleid = NULL, state = 1 WHERE plate = @plate',
			{
				['@vehicle'] 	= json.encode(vehicleProps),
				['@plate']      = vehicleProps.plate
			}) 
		end
	end)
 end)

RegisterServerEvent('flux_garages:removeCarFromParking')
AddEventHandler('flux_garages:removeCarFromParking', function(plate, networkid)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if plate ~= nil then
		MySQL.Async.execute('UPDATE `owned_vehicles` SET state = 0, vehicleid = @networkid WHERE plate = @plate',
		{
			['@plate'] = plate,
			['@networkid'] = networkid
		})
		TriggerClientEvent('esx:showNotification', playerId, _U('veh_released'))
	end
end)

RegisterServerEvent('flux_garages:removeCarFromPoliceParking')
AddEventHandler('flux_garages:removeCarFromPoliceParking', function(plate, networkid)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if plate ~= nil then
		MySQL.Async.execute('UPDATE `owned_vehicles` SET state = 0, vehicleid = @networkid WHERE plate = @plate',
		{
			['@plate'] = plate,
			['@networkid'] = networkid
		})
		TriggerClientEvent('esx:showNotification', playerId, _U('veh_released'))
	end
end)

ESX.RegisterServerCallback('flux_garages:getVehiclesInGarage', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	MySQL.Async.fetchAll('SELECT * FROM `owned_vehicles` WHERE owner = @identifier AND state = 1',
	{
		['@identifier'] = identifier
	},
	function(result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			local vehicleData = json.decode(result2[i].vehicle)
			table.insert(vehicles, vehicleData)
		end
		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('flux_garages:towVehicle', function(playerId, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	MySQL.Async.fetchAll("SELECT vehicleid FROM owned_vehicles WHERE owner=@identifier AND plate = @plate",
	{
		['@identifier'] = identifier,
		['@plate'] = plate
	}, 
	function(data)
		if data[1] ~= nil then
			cb(data[1].vehicleid)
		end
	end)
end)

ESX.RegisterServerCallback('flux_garages:getVehiclesToTow',function(playerId, cb)	
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	local vehicles = {}
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND state=0",
	{
		['@identifier'] = identifier
	}, 
	function(data) 
		for _,v in pairs(data) do
			if v.vehicleid == nil then
				v.vehicleid = -1
			end
			v.vehicle = v.vehicle:sub(1,-2)
			v.vehicle = v.vehicle .. ',"networkid":' .. v.vehicleid .. '}'
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicles, vehicle)
		end
		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('flux_garages:getTakedVehicles', function(playerId, cb)
	local vehicles = {}
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE state=2",
	{}, 
	function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicles, vehicle)
		end
		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('flux_garages:checkMoney', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if xPlayer.getMoney() >= Config.ImpoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('flux_garages:pay')
AddEventHandler('flux_garages:pay', function()
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	xPlayer.removeMoney(Config.ImpoundPrice)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		account.addMoney(Config.ImpoundPrice/2)
	end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
		account.addMoney(Config.ImpoundPrice/2)
	end)
end)

RegisterServerEvent('flux_garages:updateState')
AddEventHandler('flux_garages:updateState', function(plate)
	MySQL.Sync.execute('UPDATE `owned_vehicles` SET state = 1, vehicleid = NULL WHERE plate = @plate',
	{
		['@plate'] = plate
	})
end)

--SUBOWNER
ESX.RegisterServerCallback('flux_garages:getSubowners', function(playerId, cb, plate)
	local subowners = {}
	local found = false

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate and owner_type = 0',
	{ 
		['@plate'] = plate 
	},
	function(data)
		if #data == nil or #data < 1 then
			found = true
		else
			for i=1, #data, 1 do
				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',
				{
					['@identifier'] = data[i].owner
				},
				function(data2)
					local subowner = {}
					table.insert(subowners, {label = data2[1].firstname .. " " .. data2[1].lastname, value= data[i].owner})
				end)

				if i==#data then
					found = true
				end
			end
		end
	end)
	Citizen.CreateThread(function()
		while found == false do
			Citizen.Wait(250)
			if found == true then
				cb(subowners)
			end
		end
	end)
end)

RegisterServerEvent('flux_garages:setSubowner')
AddEventHandler('flux_garages:setSubowner', function(plate, tID)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local tPlayer = ESX.GetPlayerFromId(tID)
	local identifier = xPlayer.getIdentifier()
	local tIdentifier = tPlayer.getIdentifier()
	
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate AND owner_type = 1',
	{
		['@plate'] = plate
	},
	function(result2)
		if result2 ~= nil then
			if result2[1].owner_type == 1 then
				MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate AND owner_type = 0',
				{
					['@plate'] = plate
				},
				function(count)
					if #count >= Config.MaxSubs then
						TriggerClientEvent('esx:showNotification', playerId, _U('max_subs'))
					else
						MySQL.Sync.execute('INSERT INTO owned_vehicles (owner, owner_type, state, plate, vehicle, vehicleid) VALUES (@owner, @owner_type, @state, @plate, @vehicle, @vehicleid)',
						{
							['@owner']   = tIdentifier,
							['@owner_type'] = 0,
							['@state'] = result2[1].state,
							['@plate'] = plate,
							['@vehicle'] =	result2[1].vehicle,
							['@vehicleid'] = result2[1].vehicleid
						})

						TriggerClientEvent('esx:showNotification', playerId, _U('sub_added'))
						TriggerEvent('lakrous_discord:send', playerId, 'https://discordapp.com/api/webhooks/759417112631443477/Z4a7YYsckZvUkjuyzPW1LQ13AWEFP0UKoiXRzmk4Voow0W4VmjFIJ-qlJI6dYAe9izbF', 'Dał kluczyki graczowi: '..tPlayer..'\nRejestracja: '..plate)
						TriggerClientEvent('esx:showNotification', tID, _U('you_are_sub', plate))	
					end
				end)
				
			else
				TriggerClientEvent('esx:showNotification', playerId, _U('not_owner'))
			end
		else
			TriggerClientEvent('esx:showNotification', playerId, _U('not_veh'))
		end
	end)
end)

RegisterServerEvent('flux_garages:deleteSubowner')
AddEventHandler('flux_garages:deleteSubowner', function(plate, identifier)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	MySQL.Sync.execute('DELETE FROM owned_vehicles WHERE owner = @owner AND plate = @plate',
	{
		['@owner']   = identifier,
		['@plate'] 	 = plate
	})
	TriggerClientEvent('esx:showNotification', playerId, _U('sub_deleted'))
end)

function parkAllOwnedVehicles()
	MySQL.ready(function ()
		MySQL.Sync.execute('UPDATE `owned_vehicles` SET vehicleid = NULL WHERE vehicleid IS NOT NULL',
		{}, 
		function(rowsChanged)
		end)
	end)
end

-- SELL VEHICLE
ESX.RegisterServerCallback('flux_garages:checkBeforeSell', function (playerId, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = xPlayer.getIdentifier()
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND owner_type = 1',
	{ 
		['@owner'] = identifier,
		['@plate'] = plate
	},
	function (result)
		if result[1] ~= nil then
			if result[1].state == 1 then
				cb(true, "", result[1].vehicle)
			else
				cb(false, "not_garage")
			end
		else
			cb(false, "not_owner")
		end
	end)
end)

RegisterServerEvent('flux_garages:sellingProceed')
AddEventHandler('flux_garages:sellingProceed', function(target, price, plate, vehicle)
	local playerId = source
	TriggerClientEvent('flux_garages:displayOffer', target, playerId, price, plate, vehicle)
end)

RegisterServerEvent('flux_garages:vehicleSold')
AddEventHandler('flux_garages:vehicleSold', function(offering, price, plate)
	local playerId = source
	local targetxPlayer = ESX.GetPlayerFromId(playerId)
	local offeringxPlayer = ESX.GetPlayerFromId(offering)
	if targetxPlayer and offeringxPlayer then
		if targetxPlayer.getMoney() >= price then
			local targetIdentifier = targetxPlayer.getIdentifier()
			local offeringIdentifier = offeringxPlayer.getIdentifier()

			MySQL.Sync.execute('DELETE FROM owned_vehicles WHERE plate = @plate AND owner_type != 1',
			{
				['@plate'] 	 = plate
			})

			MySQL.Sync.execute('UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate AND owner = @offering',
			{
				['@plate'] = plate,
				['@offering'] = offeringIdentifier,
				['@owner'] = targetIdentifier
			})

			targetxPlayer.removeMoney(price)
			offeringxPlayer.addMoney(price)

			TriggerClientEvent('esx:showNotification', offering, _U('veh_sold'))
			TriggerEvent('lakrous_discord:send', offering, 'https://discordapp.com/api/webhooks/759406912244154411/mjwtTDqhzkqc1AxrlmniWAN8GgzEVK6ouSzpRnImzH5stFgxH_91l0P2-Wl5rdt_PDvz', 'Sprzedał auto graczowi: '..GetPlayerName(playerId)..'\nNumery rejestracyjne: '..plate)
			TriggerClientEvent('esx:showNotification', playerId, _U('you_are_owner', plate))
		else
			TriggerClientEvent('esx:showNotification', playerId, _U('no_money_selling'))
		end
	else
		TriggerClientEvent('esx:showNotification', offering, _U('error'))
		TriggerClientEvent('esx:showNotification', playerId, _U('error'))
	end
end)

RegisterServerEvent('flux_garages:offerDeclined')
AddEventHandler('flux_garages:offerDeclined', function(target)
	local playerId = source
	TriggerClientEvent('esx:showNotification', target, _U('offer_declined'))
	TriggerClientEvent('esx:showNotification', playerId, _U('offer_declined'))
end)

parkAllOwnedVehicles()

RegisterCommand('_givecar', function(source, args)
    if source == 0 then		
		if args[2] ~= nil then
			local sourceID = args[2]
			local playerName = GetPlayerName(sourceID)
			TriggerClientEvent('esx_giveownedcar:spawnVehicle',sourceID,args[1],args[2],playerName,'console')			
		else
			print('ERROR: you need type playerID')			
		end				
	end
end)

RegisterServerEvent('esx_giveownedcar:setVehicle')
AddEventHandler('esx_giveownedcar:setVehicle', function (vehicleProps, playerID)
	local _source = playerID
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		--['@stored']  = 1
	}, function ()
		if Config.ReceiveMsg then
			TriggerClientEvent('esx:showNotification', _source, _U('received_car', string.upper(vehicleProps.plate)))
		end
	end)
end)