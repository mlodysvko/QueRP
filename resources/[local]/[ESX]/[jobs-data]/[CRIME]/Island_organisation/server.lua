ESX = nil
OrganizationsTable = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for job, data in pairs(Config.Organisations) do
	TriggerEvent('esx_society:registerSociety', job, data.Label, 'society_'..job, 'society_'..job, 'society_'..job, {type = 'private'})
end
RegisterServerEvent('Island_organizations:setStockUsed')
AddEventHandler('Island_organizations:setStockUsed', function(name, type, bool)
	for i=1, #OrganizationsTable, 1 do
		if OrganizationsTable[i].name == name and OrganizationsTable[i].type == type then
			OrganizationsTable[i].used = bool
			break
		end
	end
end)

RegisterServerEvent('Island_organizations')
AddEventHandler('Island_organizations', function(klameczka)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local ilemam = xPlayer.getAccount('bank').money
	--print('Wyniki:', ilemam, klameczka)
	if xPlayer.getAccount(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Account).money >= Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Price then
		xPlayer.removeAccountMoney(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Account, Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Price)
		Citizen.Wait(100)
		xPlayer.addInventoryItem(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Weapon, 1)
		xPlayer.showNotification('~o~Zakupiłeś kontrakt na broń: '..Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Label)
	else
		xPlayer.showNotification('~r~Nie posiadasz wystarczającej ilości gotówki')
	end
end)

RegisterServerEvent('Island_stocks:Magazynek')
AddEventHandler('Island_stocks:Magazynek', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
		if xPlayer.getAccount(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Account).money >= Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Price then
			xPlayer.removeAccountMoney(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Account, Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Price)
			Citizen.Wait(100)
			xPlayer.addInventoryItem('pistol_ammo', Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Number)
			xPlayer.showNotification('~o~Zakupiłeś amunicję w ilości: '..Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Number.. ' ~g~za: $'..Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Price)

		else
			xPlayer.showNotification('~r~Nie posiadasz wystarczającej ilości gotówki')
		end
end)


ESX.RegisterServerCallback('Island_organizations:checkStock', function(source, cb, name, type)
	local check, found
	if #OrganizationsTable > 0 then
        for i=1, #OrganizationsTable, 1 do
			if OrganizationsTable[i].name == name and OrganizationsTable[i].type == type then
				check = OrganizationsTable[i].used
				found = true
				break
			end
		end
		if found == true then
			cb(check)
		else
			table.insert(OrganizationsTable, {name = name, type = type, used = true})
			cb(false)
		end
	else
		table.insert(OrganizationsTable, {name = name, type = type, used = true})
		cb(false)
	end
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

RegisterServerEvent('Island_stocks:CheckHeadBag')
AddEventHandler('Island_stocks:CheckHeadBag', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('headbag').count >= 1 then
		TriggerClientEvent('esx_worek:naloz', _source)
	else
		TriggerClientEvent('esx:showNotification', _source, '~o~Nie posiadasz przedmiotu worek przy sobie aby rozpocząć interakcję z workiem.')
	end
end)

RegisterServerEvent("neey_gwizdek:checkUse")
AddEventHandler("neey_gwizdek:checkUse", function(coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k, v in pairs(Config.Jobs) do
        if v == xPlayer.hiddenjob.name then
            TriggerClientEvent('neey_gwizdek:setBlip', -1, coords, xPlayer.hiddenjob.name)
            break
        end
    end
end)