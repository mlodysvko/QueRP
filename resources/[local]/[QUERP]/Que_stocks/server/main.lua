ESX                = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Items = {}
local PlayerMoney = {}
local PlayerItems = {}
local PlayerWeapons = {}

MySQL.ready(function()
	local items = MySQL.Sync.fetchAll('SELECT * FROM items')
	for i=1, #items, 1 do
		Items[items[i].name] = items[i].label
	end
end)

function getItemInStock(source, count, item_name, inventory_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if item_name == 'black_money' then
		local check = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data where account_name = @inventory_name',
		{['@inventory_name']=inventory_name})
		local newQty = check[1].cash - count
		if newQty >= 0 then
			MySQL.Async.execute('UPDATE addon_account_data SET cash = @cash WHERE account_name = @inventory_name',
			{
				['@inventory_name'] = inventory_name,
				['@cash']          = newQty
			})
			xPlayer.addAccountMoney(item_name, count)
			xPlayer.showNotification("Wypłaciłeś ~g~" .. count .. "$ ~w~nieopodatkowanej gotówki")
		else
			xPlayer.showNotification("~r~Za duża kwota!")
		end
	else
		local check = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items where inventory_name = @inventory_name AND name = @item_name',
		{['@inventory_name']=inventory_name,['@item_name']=item_name})
		local newQty = check[1].count - count
		if newQty >= 0 then
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name', 
			{
				['@inventory_name'] = inventory_name,
				['@item_name']      = item_name,
				['@count']          = newQty
			})
			xPlayer.addInventoryItem(item_name, count)
			xPlayer.showNotification("Wyciągnąłeś ~g~" .. count .. "  ~w~".. xPlayer.getInventoryItem(item_name).label)
		else
			xPlayer.showNotification("~r~Nie masz wystarczająco ".. xPlayer.getInventoryItem(item_name).label .. " w szafce")
		end
	end
end

function getWeaponInStock(source, itemTable, inventory_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local check = MySQL.Sync.fetchAll('SELECT * FROM datastore_data where name = @inventory_name',
	{['@inventory_name']=inventory_name})
	local dbTable = {}
	dbTable = json.decode(check[1].data)
	for i=1, #dbTable, 1 do
		if dbTable[i].name == itemTable.name and dbTable[i].ammo == itemTable.ammo then
			table.remove(dbTable, i)
			break
		end
	end
	MySQL.Async.execute('UPDATE datastore_data SET data = @data WHERE name = @inventory_name', 
	{
		['@inventory_name'] = inventory_name,
		['@data']			= json.encode(dbTable)
	})
	xPlayer.addWeapon(itemTable.name, itemTable.ammo)
	local weaponLabel = ESX.GetWeaponLabel(itemTable.name)
	TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', itemTable.ammo, weaponLabel))
end


RegisterServerEvent('Island_stocks:getItemInStock')
AddEventHandler('Island_stocks:getItemInStock', function(type, item, count, name)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	getItemInStock(_source, count, item, name)
	local steamid = xPlayer.identifier
	local name2 = GetPlayerName(source)
	wiadomosc = "WYCIĄGNĄŁ Z SZAFKI \n[ITEM: "..item.." | ILOSC: x"..count.."] \n[ID: "..source.." | Nazwa: "..name2.." | SteamID: "..steamid.."]" 
	DiscordHookwyciaganie3('IslandRP.pl', wiadomosc, 11750815)
end)

RegisterServerEvent('Island_stocks:getWeaponInStock')
AddEventHandler('Island_stocks:getWeaponInStock', function(item, count, name)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local steamid = xPlayer.identifier
	local name2 = GetPlayerName(source)
	getWeaponInStock(_source, {name=item, ammo=count}, name)
	wiadomosc = name2.." WYCIĄGNĄŁ Z SZAFKI \n[Broń: "..item.." | ILOSC: x"..count.."] \n[ID: "..source.." | Nazwa: "..name2.." | SteamID: "..steamid.." ]" 
	DiscordHookwyciaganie('IslandRP.pl', wiadomosc, 11750815)
end)

function getMoney(source, owner, count, item_name, inventory_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local check = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data where owner = @owner AND account_name = @inventory_name',
	{['@inventory_name']=inventory_name, ['@owner']=owner})
	
	if check[1] ~= nil then
		local pMoney = check[1].money
		if count <= pMoney then
			pMoney = pMoney - count
			MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @inventory_name AND owner = @owner', 
			{
				['@inventory_name'] = inventory_name,
				['@money']			= pMoney,
				['@owner']          = owner
			})
			xPlayer.addAccountMoney(item_name, count)
			TriggerClientEvent('esx:showNotification', _source, "Wyciągnąłeś ~g~$" .. count .. " ~w~nieopodatkowanej gotówki")
		end
	end
end

function getWeapon(source, owner, itemTable, inventory_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local check = MySQL.Sync.fetchAll('SELECT * FROM datastore_data where owner = @owner AND name = @inventory_name',
	{['@inventory_name']=inventory_name,['@owner']=owner})
	local dbTable = {}
	dbTable = json.decode(check[1].data)
	for i=1, #dbTable, 1 do
		if dbTable[i].name == itemTable.name and dbTable[i].ammo == itemTable.ammo then
			table.remove(dbTable, i)
			break
		end
	end
	MySQL.Async.execute('UPDATE datastore_data SET data = @data WHERE name = @inventory_name AND owner = @owner', 
	{
		['@inventory_name'] = inventory_name,
		['@data']			= json.encode(dbTable),
		['@owner']          = owner
	})
	xPlayer.addWeapon(itemTable.name, itemTable.ammo)
	local weaponLabel = ESX.GetWeaponLabel(itemTable.name)
	local xPlayer = ESX.GetPlayerFromId(source)
	local steamid = xPlayer.identifier
	local name3 = GetPlayerName(source)
	TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', itemTable.ammo, weaponLabel))
end

function getItem(source, owner, count, item_name, inventory_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local check = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items where owner = @owner AND inventory_name = @inventory_name AND name = @item_name',
	{['@inventory_name']=inventory_name,['@item_name']=item_name,['@owner']=owner})
	
	local newQty = check[1].count - count
	
	if newQty >= 0 then
		MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name AND owner = @owner', 
		{
			['@inventory_name'] = inventory_name,
			['@item_name']      = item_name,
			['@count']          = newQty,
			['@owner']          = owner
		})
		xPlayer.addInventoryItem(item_name, count)
		TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, xPlayer.getInventoryItem(item_name).label))
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_property'))
	end
end

RegisterServerEvent('Island_stocks:getItemInJob')
AddEventHandler('Island_stocks:getItemInJob', function(type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	
	if type == 'item_standard' then
		getItem(_source, xPlayer.identifier, count, item, 'property', 'job')
	elseif type == 'item_account' then
		getMoney(_source, xPlayer.identifier, count, item, 'property_' .. item, 'job')
	elseif type == 'item_weapon' then
		getWeapon(_source, xPlayer.identifier, {name=item,ammo=count}, 'property', 'job')
	end
end)

RegisterServerEvent('Island_stocks:getItem')
AddEventHandler('Island_stocks:getItem', function(owner, type, item, count, property)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local pName = 'property_' .. property.name
	
	if type == 'item_standard' then
		getItem(_source, owner, count, item, pName)
	elseif type == 'item_account' then
		getMoney(_source, owner, count, item, pName .. '_' .. item)
	elseif type == 'item_weapon' then
		getWeapon(_source, owner, {name=item,ammo=count}, pName)
	end
end)


function putItemInStock(source, count, item_name, inventory_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if item_name == nil or count == nil then
		xPlayer.showNotification("~r~Nie udało umieścić się przedmiotu w szafce")
		return
	end
	if item_name == 'black_money' then
		local check = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data where account_name = @account_name',
		{['@account_name']=inventory_name})
		
		if check[1] ~= nil then
			local itemQty = check[1].cash
			local newQty = count + check[1].cash
			MySQL.Async.execute('UPDATE addon_account_data SET cash = @cash WHERE account_name = @account_name', 
			{
				['@account_name'] = inventory_name,
				['@cash']          = newQty
			})
			xPlayer.removeAccountMoney('black_money', count)
			xPlayer.showNotification("Wpłaciłeś ~g~" .. count .. "$ ~w~nieopodatkowanej gotówki")
		else
			MySQL.Async.execute('INSERT INTO addon_account_data (account_name, cash) VALUES (@account_name, @cash)',
			{
				['@account_name'] = inventory_name,
				['@cash']          = count
			})
			xPlayer.removeAccountMoney(item_name, count)
			xPlayer.showNotification("Wpłaciłeś ~g~" .. count .. "$ ~w~nieopodatkowanej gotówki")
		end
		
	else
		local check = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items where inventory_name = @inventory_name AND name = @item_name',
		{['@inventory_name']=inventory_name,['@item_name']=item_name})
		
		if check[1] ~= nil then
			local itemQty = check[1].count
			local newQty = count + check[1].count
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name', 
			{
				['@inventory_name'] = inventory_name,
				['@item_name']      = item_name,
				['@count']          = newQty
			})
			xPlayer.removeInventoryItem(item_name, count)
			xPlayer.showNotification("Włożyłeś ~g~" .. count .. " ~w~" .. xPlayer.getInventoryItem(item_name).label)
			local steamid = xPlayer.identifier
			local name2 = GetPlayerName(source)
			wiadomosc = "WŁOŻYŁ do SZAFKI \n[ITEM: "..item_name.." | ILOSC: x"..count.."] \n[ID: "..source.." | Nazwa: "..name2.." | SteamID: "..steamid.."]" 
			DiscordHookwyciaganie3('IslandRP.pl', wiadomosc, 11750815)
		else
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count) VALUES (@inventory_name, @item_name, @count)',
			{
				['@inventory_name'] = inventory_name,
				['@item_name']      = item_name,
				['@count']          = count
			})
			xPlayer.removeInventoryItem(item_name, count)
			xPlayer.showNotification("Włożyłeś ~g~" .. count .. " ~w~" .. xPlayer.getInventoryItem(item_name).label)
			local steamid = xPlayer.identifier
			local name2 = GetPlayerName(source)
			wiadomosc = "WŁOŻYŁ do SZAFKI \n[ITEM: "..item_name.." | ILOSC: x"..count.."] \n[ID: "..source.." | Nazwa: "..name2.." | SteamID: "..steamid.."]" 
			DiscordHookwyciaganie3('IslandRP.pl', wiadomosc, 11750815)
		end
	end
end

function putWeaponInStock(source, itemTable, inventory_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if itemTable == nil then
		xPlayer.showNotification("~r~Nie udało umieścić się przedmiotu w szafce")
		return
	end

	local check = MySQL.Sync.fetchAll('SELECT * FROM datastore_data where name = @inventory_name',
	{['@inventory_name']=inventory_name})
	
	if check[1] ~= nil then
		local dbTable = json.decode(check[1].data)
		table.insert(dbTable, {name=itemTable.name, ammo=itemTable.ammo})
		
		MySQL.Async.execute('UPDATE datastore_data SET data = @data WHERE name = @inventory_name', 
		{
			['@inventory_name'] = inventory_name,
			['@data']           = json.encode(dbTable)
		})
		xPlayer.removeWeapon(itemTable.name, itemTable.ammo)
		local weaponLabel = ESX.GetWeaponLabel(itemTable.name)
		TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', itemTable.ammo, weaponLabel))
	else
		local dbTable = {}
		table.insert(dbTable, {name=itemTable.name, ammo=itemTable.ammo})
		MySQL.Async.execute('INSERT INTO datastore_data (name, data, owner) VALUES (@inventory_name, @data, NULL)',
		{
			['@inventory_name'] = inventory_name,
			['@data']           = json.encode(dbTable)
		})
		xPlayer.removeWeapon(itemTable.name, itemTable.ammo)
		local weaponLabel = ESX.GetWeaponLabel(itemTable.name)
		TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', itemTable.ammo, weaponLabel))
	end
end

RegisterServerEvent('Island_stocks:buyItemToStock')
AddEventHandler('Island_stocks:buyItemToStock', function(type, item, count, name)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	if item == nil or count == nil then
		xPlayer.showNotification("~r~Nie udało umieścić się przedmiotu w szafce")
		return
	end
	
	putItemInStock(_source, count, item, name)
end)

RegisterServerEvent('Island_stocks:putItemInStock')
AddEventHandler('Island_stocks:putItemInStock', function(type, item, count, name)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	if item == nil or count == nil then
		xPlayer.showNotification("~r~Nie udało umieścić się przedmiotu w szafce")
		return
	end
	local playerItemCount
	if type == 'item_account' then
		playerItemCount = xPlayer.getAccount('black_money').money
	elseif type == 'item_standard' then
		playerItemCount = xPlayer.getInventoryItem(item).count
	end
	
	if playerItemCount >= count and count > 0 then
		putItemInStock(_source, count, item, name)
		-- local xPlayer = ESX.GetPlayerFromId(_source)
		local steamid2 = xPlayer.identifier
		local name2 = GetPlayerName(source)
		putWeaponInStock(_source, {name=item, ammo=count}, name)
		wiadomosc = name2.." WSADZIŁ DO SZAFKI \n[ITEM: "..item.." | ILOSC: x"..count.."] \n[ID: "..source.." | Nazwa: "..name2.." | SteamID: "..steamid2.." ]" 
		DiscordHookwkladanie2('IslandRP.pl', wiadomosc, 11750815)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
	end
end)

RegisterServerEvent('Island_stocks:putWeaponInStock')
AddEventHandler('Island_stocks:putWeaponInStock', function(item, count, name)
	local _source      = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local steamid = xPlayer.identifier
	local name2 = GetPlayerName(source)
	putWeaponInStock(_source, {name=item, ammo=count}, name)
	wiadomosc = name2.." WSADZIŁ DO SZAFKI \n[Broń: "..item.." | ILOSC: x"..count.."] \n[ID: "..source.." | Nazwa: "..name2.." | SteamID: "..steamid.." ]" 
	DiscordHookwkladanie('IslandRP.pl', wiadomosc, 11750815)
end)

function putMoney(source, owner, count, item, inventory_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if item == nil or count == nil then
		xPlayer.showNotification("~r~Nie udało umieścić się przedmiotu w szafce")
		return
	end
	
	local check = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data where owner = @owner AND account_name = @inventory_name',
	{['@inventory_name']=inventory_name,['@owner']=owner})
	
	if check[1] ~= nil then
		local pMoney = tonumber(check[1].money)
		pMoney = pMoney + count
		
		MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @inventory_name AND owner = @owner', 
		{
			['@inventory_name'] = inventory_name,
			['@money']          = tonumber(pMoney),
			['@owner']          = owner
		})
		xPlayer.removeAccountMoney(item, count)
		TriggerClientEvent('esx:showNotification', source, _U('have_deposited', count, "nieopodatkowanej gotówki"))
	else
		local pMoney = count
		MySQL.Async.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@inventory_name, @money, @owner)',
		{
			['@inventory_name'] = inventory_name,
			['@money']          = tonumber(pMoney),
			['@owner']          = owner
		})
		xPlayer.removeAccountMoney(item, count)
		TriggerClientEvent('esx:showNotification', source, _U('have_deposited', count, "nieopodatkowanej gotówki"))
	end
end

function putWeapon(source, owner, itemTable, inventory_name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local itemName = itemTable.name
	local itemAmmo = itemTable.ammo
	if itemTable == nil then
		xPlayer.showNotification("~r~Nie udało umieścić się przedmiotu w szafce")
		return
	end
	
	local check = MySQL.Sync.fetchAll('SELECT * FROM datastore_data where owner = @owner AND name = @inventory_name',
	{['@inventory_name']=inventory_name,['@owner']=owner})
	
	if check[1] ~= nil then
		local dbTable = json.decode(check[1].data)
		table.insert(dbTable, {name=itemName, ammo=itemAmmo})
		
		MySQL.Async.execute('UPDATE datastore_data SET data = @data WHERE name = @inventory_name AND owner = @owner', 
		{
			['@inventory_name'] = inventory_name,
			['@data']           = json.encode(dbTable),
			['@owner']          = owner
		})
		xPlayer.removeWeapon(itemName, itemAmmo)
		local weaponLabel = ESX.GetWeaponLabel(itemName)
		TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', itemAmmo, weaponLabel))
	else
		local dbTable = {}
		table.insert(dbTable, {name=itemName, ammo=itemAmmo})
		MySQL.Async.execute('INSERT INTO datastore_data (name, data, owner) VALUES (@inventory_name, @data, @owner)',
		{
			['@inventory_name'] = inventory_name,
			['@data']           = json.encode(dbTable),
			['@owner']          = owner
		})
		Wait(100)
		xPlayer.removeWeapon(itemName, itemAmmo)
		local weaponLabel = ESX.GetWeaponLabel(itemName)
		TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', itemAmmo, weaponLabel))
	end
end

function putItem(source, owner, count, item_name, inventory_name, canRent)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local weight = count
	local propertyWeight = 0
	local limit = 0

	if item_name == nil or count == nil then
		xPlayer.showNotification("~r~Nie udało umieścić się przedmiotu w szafce")
		return
	end
	
	if canRent then
		limit = 200
	else
		limit = 800
	end
	
	local checkPropertyWeight = MySQL.Sync.fetchAll('SELECT count FROM addon_inventory_items where owner = @owner AND inventory_name = @inventory_name',
	{
		['@inventory_name']=inventory_name,['@item_name']=item_name,['@owner']=owner
	})
	
	for i=1, #checkPropertyWeight, 1 do
		propertyWeight = propertyWeight + checkPropertyWeight[i].count
	end
	
	local check = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items where owner = @owner AND inventory_name = @inventory_name AND name = @item_name',
	{['@inventory_name']=inventory_name,['@item_name']=item_name,['@owner']=owner})
	
	if check[1] ~= nil then
		local itemQty = check[1].count
		local newQty = count + check[1].count
		if weight + propertyWeight <= limit then
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name AND owner = @owner', 
			{
				['@inventory_name'] = inventory_name,
				['@item_name']      = item_name,
				['@count']          = newQty,
				['@owner']          = owner
			})
			xPlayer.removeInventoryItem(item_name, count)
			TriggerClientEvent('esx:showNotification', source, _U('have_deposited', count, xPlayer.getInventoryItem(item_name).label))
		else
			TriggerClientEvent('esx:showNotification', source, "~r~Nie masz wystarczająco miejsca w swoim mieszkaniu")
		end
	else
		if weight + propertyWeight <= limit then
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count, owner) VALUES (@inventory_name, @item_name, @count, @owner)',
			{
				['@inventory_name'] = inventory_name,
				['@item_name']      = item_name,
				['@count']          = count,
				['@owner']          = owner
			})
			xPlayer.removeInventoryItem(item_name, count)
			TriggerClientEvent('esx:showNotification', source, _U('have_deposited', count, xPlayer.getInventoryItem(item_name).label))
		else
			TriggerClientEvent('esx:showNotification', source, "~r~Nie masz wystarczająco miejsca w swoim mieszkaniu")
		end
	end
end

RegisterServerEvent('Island_stocks:putItemInJob')
AddEventHandler('Island_stocks:putItemInJob', function(type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)

	if item == nil or count == nil then
		xPlayer.showNotification("~r~Nie udało umieścić się przedmiotu w szafce")
		return
	end
	
	if type == 'item_standard' then
		local playerItemCount = xPlayer.getInventoryItem(item).count
		if playerItemCount >= count and count > 0 then
			putItem(_source, xPlayer.identifier, count, item, 'property', 'job')
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
		end

	elseif type == 'item_account' then
		local playerAccountMoney = xPlayer.getAccount(item).money
		if playerAccountMoney >= count and count > 0 then
			putMoney(_source, xPlayer.identifier, count, item, 'property_' .. item, property)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
		end
	elseif type == 'item_weapon' then
		putWeapon(_source, xPlayer.identifier, {name=item, ammo=count}, 'property', 'job')
	end
end)

RegisterServerEvent('Island_stocks:putItem')
AddEventHandler('Island_stocks:putItem', function(owner, type, item, count, property)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local pName = 'property_' .. property.name

	if type == 'item_standard' then
		local playerItemCount = xPlayer.getInventoryItem(item).count
		if playerItemCount >= count and count > 0 then
			print(property.canRent)
			putItem(_source, owner, count, item, pName, property.canRent)
			
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
		end

	elseif type == 'item_account' then
		local playerAccountMoney = xPlayer.getAccount(item).money	
		if playerAccountMoney >= count and count > 0 then
			putMoney(_source, owner, count, item, pName .. '_' .. item)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
		end
	elseif type == 'item_weapon' then
		if xPlayer.hasWeapon(item) then
			putWeapon(_source, owner, {name=item, ammo=count}, pName)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
		end
	end
end)


function getSharedInventory(name)
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items WHERE inventory_name = @inventory_name', 
	{['@inventory_name']=name})
	local items = {}
	
	for i=1,#result,1 do
		local itemName  = result[i].name
		local itemCount = result[i].count
		table.insert(items, {
			name  = itemName,
			count = itemCount,
			label = Items[itemName]
		})
	end
	return items
end

function getSharedAccount(name)
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @inventory_name', 
	{['@inventory_name']=name})
	if result[1] == nil then
		local blackMoney = 0
		return blackMoney
	else
		local blackMoney = result[1].cash
		return blackMoney
	end
end

function getAccounts(owner, name)
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE owner = @owner AND account_name = @inventory_name', 
	{['@owner']=owner,['@inventory_name']=name})
	if result[1] == nil then
		local blackmoney = 0
		return blackmoney
	else
		local blackmoney = result[1].money
		return blackmoney
	end
end

function getWeapons(owner, name)
	local result = MySQL.Sync.fetchAll('SELECT * FROM datastore_data WHERE owner = @owner AND name = @inventory_name', 
	{['@owner']=owner,['@inventory_name']=name})
	if result[1] == nil then
		local weapons = {}
		return weapons
	else
		local weapons = {}
		local dbTable = {}
		dbTable = json.decode(result[1].data)
		for i=1, #dbTable, 1 do
			local weaponName = dbTable[i].name
			local weaponAmmo = dbTable[i].ammo
			table.insert(weapons, {
				name = weaponName,
				ammo = weaponAmmo
			})
		end
		return weapons
	end
end

function getInventory(owner, name)
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items WHERE owner = @owner AND inventory_name = @inventory_name', 
	{['@owner']=owner,['@inventory_name']=name})
	local items = {}
	
	for i=1,#result,1 do
		local itemName  = result[i].name
		local itemCount = result[i].count
		table.insert(items, {
			name  = itemName,
			count = itemCount,
			label = Items[itemName]
		})
	end
	return items
end

function getStockAccounts(society)
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @inventory_name', 
	{['@inventory_name']=society})

	if result[1] == nil then
		local blackmoney = 0
		return blackmoney
	else
		local blackmoney = result[1].money
		return blackmoney
	end
end

function getStockWeapons(society)
	local result = MySQL.Sync.fetchAll('SELECT * FROM datastore_data WHERE name = @inventory_name', 
	{['@inventory_name']=society})
	if result[1] == nil then
		local weapons = {}
		return weapons
	else
		local weapons = {}
		local dbTable = {}
		dbTable = json.decode(result[1].data)
		for i=1, #dbTable, 1 do
			local weaponName = dbTable[i].name
			local weaponAmmo = dbTable[i].ammo
			table.insert(weapons, {
				name = weaponName,
				ammo = weaponAmmo
			})
		end
		return weapons
	end
end

function getStockInventory(society)
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items WHERE inventory_name = @inventory_name', 
	{['@inventory_name']=society})
	local items = {}
	
	for i=1,#result,1 do
		local itemName  = result[i].name
		local itemCount = result[i].count
		table.insert(items, {
			name  = itemName,
			count = itemCount,
			label = Items[itemName]
		})
	end
	return items
end

ESX.RegisterServerCallback('Island_stocks:getSharedInventoryInJob', function(source, cb, name)
	local items      = {}
	
	items = getSharedInventory(name)
	
	cb({ items = items })
end)

ESX.RegisterServerCallback('Island_stocks:getPropertyInventoryInJob', function(source, cb)
	local _source = source
	local xPlayer    = ESX.GetPlayerFromId(_source)
	local blackMoney = 0
	local items      = {}
	local weapons    = {}
	
	blackMoney = getAccounts(xPlayer.identifier, 'property_black_money')
	weapons = getWeapons(xPlayer.identifier, 'property', 'job')
	items = getInventory(xPlayer.identifier, 'property', 'job')
	
	cb({
		blackMoney = blackMoney,
		items      = items,
		weapons    = weapons
	})
end)

ESX.RegisterServerCallback('Island_stocks:getPropertyInventory', function(source, cb, owner, property)
	local _source = source
	local blackMoney = 0
	local items      = {}
	local weapons    = {}
	local pName = 'property_' .. property.name
		
	blackMoney = getAccounts(owner, pName .. '_black_money')
	weapons = getWeapons(owner, pName)
	items = getInventory(owner, pName)
	cb({
		blackMoney = tonumber(blackMoney),
		items      = items,
		weapons    = weapons
	})
end)

ESX.RegisterServerCallback('Island_stocks:getStock', function(source, cb, society)
	local _source = source
	local xPlayer    = ESX.GetPlayerFromId(_source)
	local blackMoney = 0
	local items      = {}
	local weapons    = {}
	
	blackMoney = getStockAccounts(society)
	weapons = getStockWeapons(society)
	items = getStockInventory(society)
	
	cb({
		blackMoney = blackMoney,
		items      = items,
		weapons    = weapons
	})
end)


ESX.RegisterServerCallback('Island_stocks:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	local money      = xPlayer.getMoney()
	local items      = xPlayer.inventory

	cb({
		blackMoney = blackMoney,
		money = money,
		items  = items
	})
end)

ESX.RegisterServerCallback('Island_stocks:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}
		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('Island_stocks:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier,  function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('Island_stocks:removeOutfit')
AddEventHandler('Island_stocks:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier,  function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)

-- funkcja;
function DiscordHookwkladanie(hook,message,color)
    local wkladanie = 'https://discord.com/api/webhooks/849019882916937799/QTBj24fvr5FWal1W3NQPcBw_wOlxS4ZCjXHsAbGRo8tLE9J5a-hYMHe3wh-UWdCAK9Xx'
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
    PerformHttpRequest(wkladanie, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function DiscordHookwkladanie2(hook,message,color)
    local wkladanie22 = 'https://discord.com/api/webhooks/849019882916937799/QTBj24fvr5FWal1W3NQPcBw_wOlxS4ZCjXHsAbGRo8tLE9J5a-hYMHe3wh-UWdCAK9Xx'
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
    PerformHttpRequest(wkladanie22, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function DiscordHookwyciaganie(hook,message,color)
    local wyciaganie = 'https://discord.com/api/webhooks/849019939591422002/BQcnGA5BuIp6Hj0wXKsb3uNSLn2val8RSx_QeOzkfIyh3e3STsdo4j_JiBWAyDnr55lU'
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
    PerformHttpRequest(wyciaganie, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function DiscordHookwyciaganie3(hook,message,color)
    local wyciaganie44 = 'https://discord.com/api/webhooks/849019939591422002/BQcnGA5BuIp6Hj0wXKsb3uNSLn2val8RSx_QeOzkfIyh3e3STsdo4j_JiBWAyDnr55lU'
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
    PerformHttpRequest(wyciaganie44, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end
