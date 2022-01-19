ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('schowek:kup')
AddEventHandler('schowek:kup', function()
	local xPlayer  = ESX.GetPlayerFromId(source)

	local schowekCena = 1000

	if schowekCena <= xPlayer.getMoney() then
		xPlayer.removeMoney(schowekCena)
		TriggerClientEvent('esx:showNotification', source, "Kupiłeś schowek za 1000$")
		setschowekowned(xPlayer.identifier)
	else
		TriggerClientEvent('esx:showNotification', source, "Nie masz siana na schowek")
	end
end)

function setschowekowned(owner)
	local xPlayer = ESX.GetPlayerFromIdentifier(owner)
	local chuj = "tak"
	

	MySQL.Async.execute('INSERT INTO owned_schowek (owner, posiadanie) VALUES (@owner ,@posiadanie)',
	{

		['@owner']  = owner,
		['@posiadanie']  = chuj	
	}, 
	function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromIdentifier(owner)

		local name = GetPlayerName(source)
		if xPlayer then
			print("Gracz "..owner.." kupil schowek")
		end
	end)
end

ESX.RegisterServerCallback('schowek:makupione', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	

	local test = MySQL.Sync.fetchAll('SELECT owner FROM owned_schowek WHERE owner = @owner',
	{
		['@owner'] = xPlayer.identifier,
	})

		while test == nil do
			Citizen.Wait(100)
		end
	
		if test[1] == nil then
			wynik = "nie"
		else
		
			if test[1].owner == xPlayer.identifier then
				wynik = "chuj"
			end
		end
		
		cb({
			schowek      = wynik,
		})
	


end)


RegisterNetEvent('schowek:getItem')
AddEventHandler('schowek:getItem', function(type, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == 'item_standard' then
		TriggerEvent('esx_addoninventory:getInventory', 'schowek', xPlayer.identifier, function(inventory)
			local inventoryItem = inventory.getItem(item)
			if count > 0 and inventoryItem.count >= count then
				if count > 0 and inventoryItem.count >= count then
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nie możesz posiadać więcej tego przedmiotu!', 5000, 'primary')
				end
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nie posiadasz tyle!', 5000, 'primary')
			end
		end)
	elseif type == 'item_account' then
		TriggerEvent('esx_addonaccount:getAccount', 'schowek_' .. item, xPlayer.identifier, function(account)
			if account.money >= count then
				account.removeMoney(count)
				xPlayer.addAccountMoney(item, count)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nieprawidłowa ilość', 5000, 'primary')
			end
		end)
	end
end)

RegisterNetEvent('schowek:putItem')
AddEventHandler('schowek:putItem', function(type, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	if type == 'item_standard' then
		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			TriggerEvent('esx_addoninventory:getInventory', 'schowek', xPlayer.identifier, function(inventory)
				xPlayer.removeInventoryItem(item, count)
				inventory.addItem(item, count)
			end)
		else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Niepoprawna ilość.', 5000, 'primary')

		end
	elseif type == 'item_account' then
		if xPlayer.getAccount(item).money >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)

			TriggerEvent('esx_addonaccount:getAccount', 'schowek_' .. item, xPlayer.identifier, function(account)
				account.addMoney(count)
			end)
		else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Niepoprawna ilość.', 5000, 'primary')
		end
	end
end)

ESX.RegisterServerCallback('schowek:getPropertyInventory', function(source, cb)
    local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = 0
	local items      = {}
	TriggerEvent('esx_addonaccount:getAccount', 'schowek_black_money', xPlayer.identifier, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('esx_addoninventory:getInventory', 'schowek', xPlayer.identifier, function(inventory)
		items = inventory.items
	end)

	cb({
		blackMoney = blackMoney,
		items      = items,
	})
end)

ESX.RegisterServerCallback('schowek:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	local items      = xPlayer.inventory

	cb({
		blackMoney = blackMoney,
		items      = items,
	})
end)
