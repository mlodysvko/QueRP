ESX             = nil
local ShopItems = {}
local hasSqlRun = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function sendToDiscord (name,message,color)
    local DiscordWebHook = "https://discord.com/api/webhooks/870487931603779624/qkPulqlJF9ZR_HEptktnZb9sVa3aowN7CE9cjP4xgaCJ-FSkXaA7zEhf080Y-xp5n6t_"

  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
          ["footer"]=  {
          ["text"]= "Sprzedaz kawy w island_kawiarnia",
         },
      }
  }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

-- Load items
AddEventHandler('onMySQLReady', function()
	hasSqlRun = true
	LoadShop()
end)

-- extremely useful when restarting script mid-game
Citizen.CreateThread(function()
	Citizen.Wait(2000) -- hopefully enough for connection to the SQL server

	if not hasSqlRun then
		LoadShop()
		hasSqlRun = true
	end
end)


function GenerateUniquePhoneNumber()
    local running = true
    local phone = nil
    while running do
        local rand = '' .. math.random(11111,99999)
        local count = MySQL.Sync.fetchScalar("SELECT COUNT(number) FROM user_sim WHERE number = @phone_number", { ['@phone_number'] = rand })
        if count < 1 then
            phone = rand
            running = false
        end
    end
    return phone
end


function LoadShop()
	local itemResult = MySQL.Sync.fetchAll('SELECT * FROM items')
	local shopResult = MySQL.Sync.fetchAll('SELECT * FROM shops')

	local itemInformation = {}
	for i=1, #itemResult, 1 do

		if itemInformation[itemResult[i].name] == nil then
			itemInformation[itemResult[i].name] = {}
		end

		itemInformation[itemResult[i].name].label = itemResult[i].label
		itemInformation[itemResult[i].name].limit = itemResult[i].limit
	end

	for i=1, #shopResult, 1 do
		if ShopItems[shopResult[i].store] == nil then
			ShopItems[shopResult[i].store] = {}
		end

		table.insert(ShopItems[shopResult[i].store], {
			label = itemInformation[shopResult[i].item].label,
			item  = shopResult[i].item,
			price = shopResult[i].price,
			limit = itemInformation[shopResult[i].item].limit
		})
	end
end

ESX.RegisterServerCallback('esx_shops:requestDBItems', function(source, cb)
	if not hasSqlRun then
		TriggerClientEvent('esx:showNotification', source, 'Baza danych sklepu nie została jeszcze załadowana, spróbuj ponownie za chwilę.')
	end

	cb(ShopItems)
end)

RegisterServerEvent('adolfhiteler2wojnanazisci')
AddEventHandler('adolfhiteler2wojnanazisci', function(itemName, amount, zone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	local identifier = GetPlayerName(source)

	amount = ESX.Round(amount)

	if amount < 0 then
		return
	end

	-- get price
	local price = 0
	local itemLabel = ''

	for i=1, #ShopItems[zone], 1 do
		if ShopItems[zone][i].item == itemName then
			price = ShopItems[zone][i].price
			itemLabel = ShopItems[zone][i].label
			break
		end
	end

	price = price * amount
	phoneNumber = GenerateUniquePhoneNumber()

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then
		if itemName == 'sim' then
			MySQL.Async.fetchAll('SELECT * FROM user_sim WHERE identifier = @identifier',
			{
				['@identifier'] = xPlayer.identifier,
			}, function(result)
				if #result >= 5 then
					TriggerClientEvent('gcphone:komunikat', _source, "Posiadasz już maksymalną ilość kart SIM")
				else
					MySQL.Async.execute('INSERT INTO user_sim (identifier,user,number,label) VALUES(@identifier,@user,@number,@label)',
					{
						['@identifier']   = xPlayer.identifier,
						['@user']   = xPlayer.identifier,
						['@number'] = phoneNumber,
						['@label'] = "SIM #"..phoneNumber,
					})
					TriggerClientEvent('gcphone:komunikat', _source, "Kupiłeś nowy starter #" .. phoneNumber)
					TriggerClientEvent('esx_inventoryhud:getOwnedSim', _source)
					xPlayer.removeMoney(price)
				end
			end)
		else
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			else
				xPlayer.removeMoney(price)
				xPlayer.addInventoryItem(itemName, amount)
				sendToDiscord (('adolfhiteler2wojnanazisci'), "Gracz [".. _source .."] " .. identifier .. " licka gracza: " .. xPlayer.identifier .. " KUPIL: ".. itemName .." ILOSC [ ".. amount .." ] CENA ".. price .."$ ") 
				TriggerClientEvent('esx:showNotification', _source, _U('bought', amount, itemLabel, price))
			end
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough', missingMoney))
	end
end)

RegisterServerEvent('adolfhiteler2wojnanazisci2')
AddEventHandler('adolfhiteler2wojnanazisci2', function(itemName, amount, zone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	local identifier = GetPlayerName(source)

	amount = ESX.Round(amount)

	if amount < 0 then
		return
	end

	-- get price
	local price = 0
	local itemLabel = ''

	for i=1, #ShopItems[zone], 1 do
		if ShopItems[zone][i].item == itemName then
			price = ShopItems[zone][i].price
			itemLabel = ShopItems[zone][i].label
			break
		end
	end

	price = price * amount
	phoneNumber = GenerateUniquePhoneNumber()

	-- can the player afford this item?
	if xPlayer.getAccount('bank').money >= price then
		if itemName == 'sim' then
			MySQL.Async.fetchAll('SELECT * FROM user_sim WHERE identifier = @identifier',
			{
				['@identifier'] = xPlayer.identifier
			}, function(result)
				if #result >= 5 then
					TriggerClientEvent('gcphone:komunikat', _source, "Posiadasz już maksymalną ilość kart SIM")
				else
					MySQL.Async.execute('INSERT INTO user_sim (identifier,user,number,label) VALUES(@identifier,@user,@number,@label)',
					{
						['@identifier']   = xPlayer.identifier,
						['@user']   = xPlayer.identifier,
						['@number'] = phoneNumber,
						['@label'] = "SIM #"..phoneNumber,
					})
					TriggerClientEvent('gcphone:komunikat', _source, "Kupiłeś nowy starter #" .. phoneNumber)
					TriggerClientEvent('esx_inventoryhud:getOwnedSim', _source)
					xPlayer.removeAccountMoney('bank', price)
				end
			end)
		else
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			else
				xPlayer.removeAccountMoney('bank', price)
				xPlayer.addInventoryItem(itemName, amount)
				sendToDiscord (('adolfhiteler2wojnanazisci2'), "Gracz [".. _source .."] " .. identifier .. " licka gracza: " .. xPlayer.identifier .. " KUPIL: ".. itemName .." ILOSC [ ".. amount .." ] CENA ".. price .."$ ") 
				TriggerClientEvent('esx:showNotification', _source, _U('bought', amount, itemLabel, price))
			end
		end
	else
		local missingMoney = price - xPlayer.getAccount('bank').money
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough_bank', missingMoney))
	end
end)

ESX.RegisterServerCallback('gcPhone:getSimShop', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
	local sims = {}

	MySQL.Async.fetchAll("SELECT * FROM user_sim WHERE identifier = @identifier OR admin1 = @identifier OR admin2 = @identifier",
	{
		['@identifier'] = xPlayer.identifier
	}, 
	function(data) 
		for _,v in pairs(data) do
			local number = v.number
			local simz = v.label
			table.insert(sims, {simz = simz, numer = number})
		end
		cb(sims)
	end)
  
end)

ESX.RegisterServerCallback('gcPhone:getHasSims', function(source, cb)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    
  
    MySQL.Async.fetchAll(
      'SELECT * FROM user_sim WHERE `identifier` = @identifier',
      {
		  ['@identifier'] = xPlayer.identifier,
      },
      function(result)
  
        cb(result)
  
    end)
  
end)

ESX.RegisterServerCallback('gcPhone:checkMoney', function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= amount then
        cb(1)
    else
        cb(0)
    end
end)