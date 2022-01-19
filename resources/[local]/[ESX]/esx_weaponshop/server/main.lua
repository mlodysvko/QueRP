ESX = nil
local shopItems = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_weaponshop:buyLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.LicensePrice then
		xPlayer.removeMoney(Config.LicensePrice)

		TriggerEvent('esx_license:addLicense', source, 'weapon', function()
			cb(true)
		end)
	else
		cb(false)
		TriggerClientEvent('esx:showNotification', source, _U('not_enough'))
	end
end)


RegisterServerEvent('weaponshop:buypistol')
AddEventHandler('weaponshop:buypistol', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local steamid21 = xPlayer.identifier
	local name33 = GetPlayerName(source)
	if xPlayer.getMoney() >= Config.Prices[1] then
		xPlayer.removeAccountMoney('money', Config.Prices[1])
		xPlayer.addInventoryItem('pistol', 1)
		xPlayer.showNotification('Zakupiłeś pistolet za:~o~ $'..Config.Prices[1])
		wiadomosc = name33.." | Sklepy \n[ ZAKUPIONY PRZDMIOT: Pistolet | KOSZT: "..Config.Prices[1].." ] \n[ID: "..source.." | Nazwa: "..name33.." | SteamID: "..steamid21.." ]" 
		DiscordHook3('QueRP | mlodyszef', wiadomosc, 11750815)
	else
		xPlayer.showNotification('Nie posiadasz przy sobie wystarczającej ilości gotówki')
	end
end)

RegisterServerEvent('weaponshop:buyvintagepistol')
AddEventHandler('weaponshop:buyvintagepistol', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= Config.Prices[2] then
		xPlayer.removeAccountMoney('money', Config.Prices[2])
		xPlayer.addInventoryItem('vintagepistol', 1)
		xPlayer.showNotification('Kupiłeś vintka dla szefitka | mlody szef, Kupiony za:~o~ $'..Config.BlackPrices[2])
	else
		xPlayer.showNotification('Nie posiadasz przy sobie wystarczającej ilości gotówki')
	end
end)

RegisterServerEvent('weaponshop:buySCYZORYK')
AddEventHandler('weaponshop:buySCYZORYK', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local steamid21 = xPlayer.identifier
	local name33 = GetPlayerName(source)
	if xPlayer.getMoney() >= Config.Prices[3] then
		xPlayer.removeAccountMoney('money', Config.Prices[3])
		xPlayer.addInventoryItem('switchblade', 1)
		xPlayer.showNotification('Zakupiłeś Scyzoryk za:~o~ $'..Config.Prices[3])
		wiadomosc = name33.." | Sklepy \n[ ZAKUPIONY PRZDMIOT: Scyzoryk | KOSZT: "..Config.Prices[3].." ] \n[ID: "..source.." | Nazwa: "..name33.." | SteamID: "..steamid21.." ]" 
		DiscordHook3('IslandRP.pl', wiadomosc, 11750815)
	else
		xPlayer.showNotification('Nie posiadasz przy sobie wystarczającej ilości gotówki')
	end
end)
--[[
RegisterServerEvent('weaponshop:buynoz')
AddEventHandler('weaponshop:buynoz', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= Config.Prices[4] then
		xPlayer.removeAccountMoney('money', Config.Prices[4])
		xPlayer.addInventoryItem('knife', 1)
		xPlayer.showNotification('Zakupiłeś Nóż za:~o~ $'..Config.Prices[4])
	else
		xPlayer.showNotification('Nie posiadasz przy sobie wystarczającej ilości gotówki')
	end
end)
]]
RegisterServerEvent('weaponshop:buymagazynek')
AddEventHandler('weaponshop:buymagazynek', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local steamid21 = xPlayer.identifier
	local name33 = GetPlayerName(source)
	if xPlayer.getMoney() >= Config.Prices[5] then
		xPlayer.removeAccountMoney('money', Config.Prices[5])
		xPlayer.addInventoryItem('pistol_ammo', 25)
		xPlayer.showNotification('Zakupiłeś Magazynek za:~o~ $'..Config.Prices[5])
		wiadomosc = name33.." | Sklepy \n[ ZAKUPIONY PRZDMIOT: Magazynek | KOSZT: "..Config.Prices[5].." ] \n[ID: "..source.." | Nazwa: "..name33.." | SteamID: "..steamid21.." ]" 
		DiscordHook3('IslandRP.pl', wiadomosc, 11750815)
	else
		xPlayer.showNotification('Nie posiadasz przy sobie wystarczającej ilości gotówki')
	end
end)
--[[
RegisterServerEvent('weaponshop:buylornetka')
AddEventHandler('weaponshop:buylornetka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= Config.Prices[6] then
		xPlayer.removeAccountMoney('money', Config.Prices[6])
		xPlayer.addInventoryItem('binoculars', 1)
		xPlayer.showNotification('Zakupiłeś Lornetkę za:~o~ $'..Config.Prices[6])
	else
		xPlayer.showNotification('Nie posiadasz przy sobie wystarczającej ilości gotówki')
	end
end)
RegisterServerEvent('weaponshop:buylatarka')
AddEventHandler('weaponshop:buylatarka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= Config.Prices[7] then
		xPlayer.removeAccountMoney('money', Config.Prices[7])
		xPlayer.addInventoryItem('flashlight', 1)
		xPlayer.showNotification('Zakupiłeś Latarkę za:~o~ $'..Config.Prices[7])
	else
		xPlayer.showNotification('Nie posiadasz przy sobie wystarczającej ilości gotówki')
	end
end)
RegisterServerEvent('weaponshop:buybutelka')
AddEventHandler('weaponshop:buybutelka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= Config.BlackPrices[7] then
		xPlayer.removeAccountMoney('money', Config.BlackPrices[7])
		xPlayer.addInventoryItem('bottle', 1)
		xPlayer.showNotification('Zakupiłeś Butelkę za:~o~ $'..Config.BlackPrices[7])
	else
		xPlayer.showNotification('Nie posiadasz przy sobie wystarczającej ilości gotówki')
	end
end)
]]
RegisterServerEvent('esx_weashop:buyItem')
AddEventHandler('esx_weashop:buyItem', function(itemName, price, zone)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	
	if zone=="BlackWeashop" then
		if account.money >= price then
			xPlayer.removeAccountMoney('black_money', price)
			xPlayer.addInventoryItem(ItemName, 32)
			TriggerClientEvent('esx:showNotification', _source, _U('buy') .. ESX.GetItemLabel(itemName))
			local steamid21 = xPlayer.identifier
			local name33 = GetPlayerName(source)
			wiadomosc = name33.." | Sklepy \n[ ZAKUPIONY PRZDMIOT: "..itemName.." | KOSZT: "..price.." ] \n[ID: "..source.." | Nazwa: "..name33.." | SteamID: "..steamid21.." ]" 
			DiscordHook3('IslandRP.pl', wiadomosc, 11750815)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_black'))
		end
	else
		if xPlayer.get('money') >= price then
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(ItemName, 32)
			TriggerClientEvent('esx:showNotification', _source, _U('buy') .. ESX.GetItemLabel(itemName))
			local steamid21 = xPlayer.identifier
			local name33 = GetPlayerName(source)
			wiadomosc = name33.." | Sklepy \n[ ZAKUPIONY PRZDMIOT: "..itemName.." | KOSZT: "..price.." ] \n[ID: "..source.." | Nazwa: "..name33.." | SteamID: "..steamid21.." ]" 
			DiscordHook3('IslandRP.pl', wiadomosc, 11750815)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
		end
	end
end)

function DiscordHook3(hook,message,color)
    local msg222 = 'https://discord.com/api/webhooks/864999938597715968/YqdxnrPN0YxM3kV-7i8C3mRrTDE8B8wZsiGAnSginywCg98Xgba1xFXqPk6K6cOfmvtG'
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
    PerformHttpRequest(msg222, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end


