webhook = {
	itemy = 'https://discord.com/api/webhooks/924673353409757184/5VTRRPQk-3CXuXaUigtvcKD-NCV2Jkj5cY-SdTfEXleVihQDAafjZrFnXvEeJvsXWMa-',
	kasa = 'https://discord.com/api/webhooks/924673353409757184/5VTRRPQk-3CXuXaUigtvcKD-NCV2Jkj5cY-SdTfEXleVihQDAafjZrFnXvEeJvsXWMa-',
    bron = 'https://discord.com/api/webhooks/924673353409757184/5VTRRPQk-3CXuXaUigtvcKD-NCV2Jkj5cY-SdTfEXleVihQDAafjZrFnXvEeJvsXWMa-'
}



ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('Tomci0:ZabierzPrzedmiot')
AddEventHandler('Tomci0:ZabierzPrzedmiot', function(target, itemType, itemName, amount)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	local SsteamId  = false
	local Slicense = false
    local Sdiscord  = false

    for k,v in pairs(GetPlayerIdentifiers(source)) do
        
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            SsteamId = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            Slicense = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            Sdiscord = v
        end 
	end
	
	local TsteamId  = false
	local Tlicense = false
    local Tdiscord  = false

    for k,v in pairs(GetPlayerIdentifiers(target)) do
        
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            TsteamId = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            Tlicense = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            Tdiscord = v
        end 
    end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then

			-- can the player carry the said amount of x item?
			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem(itemName, amount)
				TriggerClientEvent("FeedM:showNotification", source, 'Zabrano ~g~x' ..amount.. ' | ' ..sourceItem.label.. ' | ' ..target, 4000, 'primary')
				TriggerClientEvent("FeedM:showNotification", target, 'Zabrano ci ~g~x' ..amount.. ' | ' ..sourceItem.label.. ' | ' ..source, 4000, 'primary')
				item('**Gracz** `' ..GetPlayerName(source).. '` **skonfiskował obywatelowi** `' ..GetPlayerName(target).. '`\n\nKto:\n```Nick: ' ..GetPlayerName(source).. '\nID: ' ..source.. '\nHEX: ' ..SsteamId.. '\nDiscord: ' ..Sdiscord.. '\nRockstar: ' ..Slicense.. '```\n\nKomu: \n```Nick: ' ..GetPlayerName(target).. '\nHEX: ' ..TsteamId.. '\nDiscord: ' ..Tdiscord.. '\nRockstar: ' ..Tlicense.. '```\n\nCo zabrał: ```x' ..amount.. ' ' ..sourceItem.label.. ' (' ..sourceItem.name.. ')```')

			else
				TriggerClientEvent("FeedM:showNotification", source, 'Nie masz miejsca!', 4000, 'primary')
			end
		else
			TriggerClientEvent("FeedM:showNotification", source, 'Obywatel nie posiada tyle tego przedmiotu!', 4000, 'primary')
		end

	elseif itemType == 'item_account' then
		if targetXPlayer.getAccount('money').money >= amount then
			targetXPlayer.removeAccountMoney(itemName, amount)
			sourceXPlayer.addAccountMoney   (itemName, amount)

			TriggerClientEvent("FeedM:showNotification", source, 'Zabrano ~g~x' ..amount.. ' | ' ..itemName.. ' | ' ..target, 4000, 'primary')
			TriggerClientEvent("FeedM:showNotification", target, 'Zabrano ci ~g~x' ..amount.. ' | ' ..itemName.. ' | ' ..source, 4000, 'primary')
			kasa('**Gracz** `' ..GetPlayerName(source).. '` **skonfiskował od gracza** `' ..GetPlayerName(target).. '`\n\nKto:\n```Nick: ' ..GetPlayerName(source).. '\nID: ' ..source.. '\nHEX: ' ..SsteamId.. '\nDiscord: ' ..Sdiscord.. '\nRockstar: ' ..Slicense.. '```\n\nKomu: \n```Nick: ' ..GetPlayerName(target).. '\nHEX: ' ..TsteamId.. '\nDiscord: ' ..Tdiscord.. '\nRockstar: ' ..Tlicense.. '```\n\nCo zabrał: ```$' ..amount.. ' \nKonto: ' ..itemName.. '```')
		else
			TriggerClientEvent("FeedM:showNotification", source, 'Obywatel nie posiada tyle pieniędzy!', 4000, 'primary')
		end
    elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end

		-- does the target player have weapon?
		if targetXPlayer.hasWeapon(itemName) then
			targetXPlayer.removeWeapon(itemName, amount)
			sourceXPlayer.addWeapon   (itemName, amount)

			sourceXPlayer.showNotification(_U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
			targetXPlayer.showNotification(_U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
            TriggerClientEvent("FeedM:showNotification", source, 'Zabrano ~g~' ..ESX.GetWeaponLabel(itemName).. ' | x' ..amount.. ' | ' ..target, 4000, 'primary')
			TriggerClientEvent("FeedM:showNotification", target, 'Zabrano ci ~g~' ..ESX.GetWeaponLabel(itemName).. ' | ' ..amount.. ' | ' ..source, 4000, 'primary')
            kasa('**Gracz** `' ..GetPlayerName(source).. '` **skonfiskował od gracza** `' ..GetPlayerName(target).. '`\n\nKto:\n```Nick: ' ..GetPlayerName(source).. '\nID: ' ..source.. '\nHEX: ' ..SsteamId.. '\nDiscord: ' ..Sdiscord.. '\nRockstar: ' ..Slicense.. '```\n\nKomu: \n```Nick: ' ..GetPlayerName(target).. '\nHEX: ' ..TsteamId.. '\nDiscord: ' ..Tdiscord.. '\nRockstar: ' ..Tlicense.. '```\n\nCo zabrał: ```' ..ESX.GetWeaponLabel(itemName).. '(' ..itemName.. ') \nAmmo: ' ..amount.. '```')
		else
			sourceXPlayer.showNotification('Obywatel nie posiada takiej broni!')
		end
	end
end)

RegisterNetEvent('Tomci0:zakuj')
AddEventHandler('Tomci0:zakuj', function(target)
	TriggerClientEvent("FeedM:showNotification", source, 'Rozkułeś/Zakułeś obywatela ' ..target, 4000, 'primary')
	TriggerClientEvent("FeedM:showNotification", target, 'Zostałeś rozkuty/zakuty przez obywatela ' ..source, 4000, 'primary')
	TriggerClientEvent('Tomci0:Zakuj', target)
end)

RegisterNetEvent('Tomci0:PodPache')
AddEventHandler('Tomci0:PodPache', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('Tomci0:PodPache', target, source)
end)

RegisterNetEvent('Tomci0:doPojazdu')
AddEventHandler('Tomci0:doPojazdu', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('Tomci0:doPojazdu', target)
end)

RegisterNetEvent('Tomci0:zPojazdu')
AddEventHandler('Tomci0:zPojazdu', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('Tomci0:zPojazdu', target)
end)

ESX.RegisterUsableItem('handcuffs', function(source)
	TriggerClientEvent('Tomci0:OtworzKajdanki', source)
end)

ESX.RegisterServerCallback('Tomci0:GetKajdanki', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.getInventoryItem(item)
	
	cb(items.count)

end)

RegisterNetEvent('Tomci0:Powiadomienie')
AddEventHandler('Tomci0:Powiadomienie', function(target, msg)
	TriggerClientEvent("FeedM:showNotification", target, msg, 4000, 'primary')
end)


function item(message)
    
    local date = os.date('*t')
            
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')

    local connect = {
          {
              ["color"] = 9240428,
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Made by Tomci0 | " ..date,
              },
          }
      }
    PerformHttpRequest(webhook.itemy, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
end

function kasa(message)
    
    local date = os.date('*t')
            
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')

    local connect = {
          {
              ["color"] = 9240428,
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "QueRP mlodyszef | " ..date,
              },
          }
      }
    PerformHttpRequest(webhook.kasa, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
end

function bron(message)
    
    local date = os.date('*t')
            
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')

    local connect = {
          {
              ["color"] = 9240428,
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "QueRP mlodyszef | " ..date,
              },
          }
      }
    PerformHttpRequest(webhook.bron, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('Tomci0:GetInfo', function(source, cb, target, notify)
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
            weapons = xPlayer.getLoadout()
        }
        cb(data)
    end
end)