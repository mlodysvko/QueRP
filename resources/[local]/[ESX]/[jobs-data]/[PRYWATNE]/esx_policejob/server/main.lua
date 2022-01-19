ESX = nil
local CachedPedState = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'police', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

RegisterServerEvent('esx_policejob:giveWeapon')
AddEventHandler('esx_policejob:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_policejob:pay')
AddEventHandler('esx_policejob:pay', function(amount, target, charge, itsJail, jailtime)
    amount = tonumber(amount)
    local xPlayer = ESX.GetPlayerFromId(target)
    xPlayer.removeAccountMoney('bank', amount)

    if itsJail then
        GetRPName(target, function(firstname, lastname)
            TriggerClientEvent('chat:addMessage', -1, { args = { "[SĘDZIA]",  "^4" .. firstname .. " " .. lastname .. "^7 otrzymał mandat w wysokości ^4" .. amount .. "$^7 za ^4" .. charge}, color = { 255, 166, 0 } })
        end)
    else
        GetRPName(target, function(firstname, lastname)
            TriggerClientEvent('chat:addMessage', -1, { args = { "[SĘDZIA]",  "^4" .. firstname .. " " .. lastname .. "^7 otrzymał karę więzenia: ^4".. jailtime.. " miesięcy ^7za ^4" .. charge .. "^7 oraz karę o wartości: ^4" .. amount.. '$'}, color = { 255, 166, 0 } })
        end)
    end
end)

function GetRPName(playerId, data)
    local Identifier = ESX.GetPlayerFromId(playerId).identifier
    MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
        data(result[1].firstname, result[1].lastname)
    end)
end
RegisterServerEvent('radar:checkVehicle')
AddEventHandler('radar:checkVehicle', function(plate, model)
	local _source = source
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, 
	function (result)
		if result[1] ~= nil then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
				['@identifier'] = result[1].owner
			}, 
			function (result2)
				TriggerClientEvent('esx:showNotification', _source, 'Tablice: ' .. plate .. '\nWłaściciel: ' .. result2[1].firstname .. ' ' .. result2[1].lastname .. '\nModel: ' .. model)
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Pojazd o numerze rejestracyjnym ' .. plate ..' jest niezarejestrowany!' )
		end
	end)
end)

RegisterServerEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if targetItem.count > 0 and targetItem.count <= amount then
		
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, 300)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)

RegisterServerEvent('esx_policejob:notify')
AddEventHandler('esx_policejob:notify', function(target)
  local _source = source
  TriggerClientEvent('esx:showNotification', target, _('bodysearching') .. '~b~' .. _source .. '...')
end)

RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target)
  TriggerClientEvent('esx_policejob:handcuff', target)
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_policejob:drag', target, _source)
end)
RegisterServerEvent('esx_policejob:przeszukaj')
AddEventHandler('esx_policejob:przeszukaj', function()
	local _source = source
  TriggerClientEvent('esx_policejob:przeszukaj', _source)
end)
RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
  TriggerClientEvent('esx_policejob:putInVehicle', target)
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
    TriggerClientEvent('esx_policejob:OutVehicle', target)
end)

RegisterServerEvent('esx_policejob:giveItem')
AddEventHandler('esx_policejob:giveItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'police' then
		print(('esx_policejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	elseif (itemName ~= 'gps') and (itemName ~= 'fixkit') and (itemName ~= 'panicbutton') and (itemName ~= 'binoculars') and (itemName ~= 'pistol') then
		print(('esx_policejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	end

	local xItem = xPlayer.getInventoryItem(itemName)
	local count = 1

	if xItem.limit ~= 1 then
		count = xItem.limit - xItem.count
	end

	if xItem.count < xItem.limit then
		xPlayer.addInventoryItem(itemName, count)
	else
		TriggerClientEvent('esx:showNotification', source, _U('max_item'))
	end
end)

RegisterServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk')
AddEventHandler('esx_policejob:skldaknnjdmljsaujhdahjk', function(data)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local ilemam = xPlayer.getInventoryItem(data).count
  if xPlayer.job.name == 'police' then
    if ilemam <= 0 then
      xPlayer.addInventoryItem(data, 1)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Posiadasz już przy sobie wystarczającą ilość tego przedmiotu')
    end
  end
end)
RegisterServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk22')
AddEventHandler('esx_policejob:skldaknnjdmljsaujhdahjk22', function(data)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  if xPlayer.job.name == 'police' then
      xPlayer.addInventoryItem(data, 100)
  end
end)

RegisterServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk1')
AddEventHandler('esx_policejob:skldaknnjdmljsaujhdahjk1', function(data)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local ilemam = xPlayer.getInventoryItem(data).count
  if xPlayer.job.name == 'police' then
    if ilemam <= 0 then
      xPlayer.addInventoryItem(data, 1)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Posiadasz już przy sobie wystarczającą ilość tego przedmiotu')
    end
  end
end)
RegisterServerEvent('esx_policejob:skldaknnjdmljsaujhdahjk221')
AddEventHandler('esx_policejob:skldaknnjdmljsaujhdahjk221', function(data)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  if xPlayer.job.name == 'police' then
      xPlayer.addInventoryItem(data, 1)
  end
end)

ESX.RegisterServerCallback('esx_policejob:getPlayerDressing', function(source, cb)

  local xPlayer  = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)

    local count    = store.count('dressing')
    local labels   = {}

    for i=1, count, 1 do
      local entry = store.get('dressing', i)
      table.insert(labels, entry.label)
    end

    cb(labels)

  end)

end)

ESX.RegisterServerCallback('esx_policejob:getPlayerOutfit', function(source, cb, num)

  local xPlayer  = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
    local outfit = store.get('dressing', num)
    cb(outfit.skin)
  end)

end)


RegisterServerEvent('esx_policejob:getStockItem')
AddEventHandler('esx_policejob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)

	if notify then
		xPlayer.showNotification(_U('being_searched'))
	end

	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_label,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}

		if Config.EnableESXIdentity then
			data.dob = xPlayer.get('dateofbirth')
			data.height = xPlayer.get('height')

			if xPlayer.get('sex') == 'm' then data.sex = 'male' else data.sex = 'female' end
		end

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = ESX.Math.Round(status.percent)
			end
		end)

		if Config.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end
	end
end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)

  MySQL.Async.fetchAll(
    'SELECT * FROM fine_types WHERE category = @category',
    {
      ['@category'] = category
    },
    function(fines)
      cb(fines)
    end
  )

end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('esx_policejob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE plate = @plate', 
		{
			['@plate'] = plate
		},
		function(result)
			if result[1] ~= nil then
				local playerName = ESX.GetPlayerFromIdentifier(result[1].owner).name
				cb(playerName, true)
			else
				cb('unknown', false)
			end
		end
	)
end)

ESX.RegisterServerCallback('esx_policejob:getArmoryWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_policejob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

  local xPlayer = ESX.GetPlayerFromId(source)

  if removeWeapon then
   xPlayer.removeWeapon(weaponName)
  end

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_policejob:removeArmoryWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)
  TriggerEvent('szymczakovv:policeArmoryLog',source,'police',weaponName,1)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_police', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)


ESX.RegisterServerCallback('esx_policejob:buy', function(source, cb, amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			cb(false)
		end
	end)

end)

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)

AddEventHandler('playerDropped', function()
	local _source = source
	
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)
		
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
			Citizen.Wait(5000)
			TriggerClientEvent('esx_policejob:updateBlip', -1)
		end
	end	
end)

RegisterServerEvent('esx_policejob:spawned')
AddEventHandler('esx_policejob:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'police' then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_policejob:updateBlip', -1)
	end
end)

RegisterServerEvent('esx_policejob:forceBlip')
AddEventHandler('esx_policejob:forceBlip', function()
	TriggerClientEvent('esx_policejob:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_policejob:updateBlip', -1)
	end
end)

RegisterServerEvent('esx_policejob:message')
AddEventHandler('esx_policejob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

RegisterServerEvent('esx_policejob:DajLicencje')
AddEventHandler('esx_policejob:DajLicencje', function (target)
      local xPlayer = ESX.GetPlayerFromId(source)
      local tPlayer = ESX.GetPlayerFromId(target)
      local steamid = xPlayer.identifier
      local name = GetPlayerName(source)
      TriggerClientEvent('esx:showNotification', target, 'Otrzymałeś licencję na borń od: '..source)
      wiadomosc = "NADANO LICENCJE DLA: "..target.."\n[ID: "..source.." | Nazwa Steam: "..name.." | ROCKSTAR: "..steamid.." ]" 
      givelicka('IslandRP.pl', wiadomosc, 11750815)
      local result = MySQL.Sync.fetchAll(
          'SELECT type, owner FROM user_licenses WHERE owner = @owner AND type = @type',
          {
            ['@type'] = 'weapon',
            ['@owner'] = tPlayer.identifier,
          })
        if result[1] == nil then
            MySQL.Async.execute(
            'INSERT INTO user_licenses (type, owner, label) VALUES (@type, @owner, @label)',
            {
            ['@type'] = 'weapon',
            ['@owner']   = tPlayer.identifier,
            ['@label'] = 'Licencja Broń',
            },
            function (rowsChanged)
            end)
        end
end)

function givelicka(hook,message,color)
    local gigafajnywebhook22 = 'https://discord.com/api/webhooks/847549639301267506/Y7lQtALINYpFc9sURHP8pgc1fetRHlhZ0cV1jVrLmg06uQlGKCdxjBtK2BcfrJXMFP0W'
    local embeds = {
                {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
                ["text"] = 'IslandRP.pl'
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(gigafajnywebhook22, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function getIdentity(identifier)
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			name = identity['name'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end

ESX.RegisterUsableItem('binoculars', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_policejob:binoculars', source)
end)

ESX.RegisterServerCallback('esx_policejob:badgeList', function(source, cb, job)
  local xPlayer = ESX.GetPlayerFromId(source)
  local identifier = xPlayer.identifier
  local data = {}
  MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, job_id FROM users WHERE job = @job ORDER BY firstname ASC',
  {
    ['@job'] = job,
    ['@job2'] = 'off'..job
  }, function(results)
    for i=1, #results, 1 do
      local badge = json.decode(results[i].job_id)
      local name = results[i].firstname .. ' ' .. results[i].lastname

      if badge == nil then
        
      else
      table.insert(data, {
        identifier = results[i].identifier,
        name = results[i].firstname .. ' ' .. results[i].lastname,
        badge = {
          label        = badge.name,
					number       = badge.id
        },
      })
    end
    end
    cb(data)
  end)
end)

RegisterServerEvent('esx_policejob:setBadge')
AddEventHandler('esx_policejob:setBadge', function(identifier, copName, badgeNumber, badgeName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == "police" then
			if badgeNumber ~= nil and badgeName ~= nil then
				MySQL.Async.execute('UPDATE users SET job_id = @newbadge WHERE identifier = @identifier', {
          ['@newbadge'] = json.encode({name = tostring(badgeName), id = tonumber(badgeNumber)}),
          ['@identifier'] = identifier
        }, function (onRowChange)
          local tPlayer = ESX.GetPlayerFromIdentifier(identifier)

				  TriggerClientEvent('esx:showNotification', _source, '~b~Zaktualizowałeś/aś odznakę ' .. copName .. ' ~o~[ '..  badgeName .. ' ' .. badgeNumber .. ' ]~b~!')		
          if tPlayer then
            TriggerClientEvent('esx:showNotification', tPlayer.source, '~b~Aktualizacja odznaki ~o~[ '..  badgeName .. ' ' .. badgeNumber .. ' ]~b~!')
          end
        end)
			end
	end
end)

RegisterServerEvent('esx_policejob:removeBadge')
AddEventHandler('esx_policejob:removeBadge', function(identifier, copName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == "police" then
      MySQL.Async.execute('UPDATE users SET job_id = @newbadge WHERE identifier = @identifier', {
        ['@newbadge'] = json.encode({name = 'nojob', id = 0}),
        ['@identifier'] = identifier
      }, function (onRowChange)
        local tPlayer = ESX.GetPlayerFromIdentifier(identifier)
        TriggerClientEvent('esx:showNotification', _source, '~b~Zabrano odznakę ~o~' .. copName)
        if tPlayer then
          TriggerClientEvent('esx:showNotification', tPlayer.source, '~b~Zabrano ci odznakę!')
        end
      end)
    end
end)