
ESX = nil
local PlayersTransforming  = {}
local PlayersSelling       = {}
local PlayersHarvesting = {}
local kawa = 1
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'kawiarnia', Config.MaxInService)
end

function sendToDiscord (name,message,color)
    local DiscordWebHook = "https://discord.com/api/webhooks/859385892032741386/UOLvu6NDc2YCIWCCPDp9GMaYut6bCtKLr-dkqvhhksItCeFzF2kSHPUnd7ALo9k0gOie"

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

TriggerEvent('esx_society:registerSociety', 'kawiarnia', 'kawiarnia', 'society_kawiarnia', 'society_kawiarnia', 'society_kawiarnia', {type = 'public'})

RegisterServerEvent('esx_kawiarnia:startHarvest')
AddEventHandler('esx_kawiarnia:startHarvest', function(zone)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local itemQuantity = xPlayer.getInventoryItem('ziarnakawy123').count
	
	if itemQuantity == 40 or itemQuantity > 40 then
		TriggerClientEvent("pNotify:SendNotification", _source, {
            text = 'Nie masz już miejsca w torbie na ziaren kawy',
            type = "error",
            timeout = 3000,
            layout = "centerLeft"
        })
	return
	end
	
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx_kawiarnia:startHarvest2', source)
			end)




RegisterServerEvent('esx_kawiarnia:startHarvest3')
AddEventHandler('esx_kawiarnia:startHarvest3', function(zone)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local itemQuantity = xPlayer.getInventoryItem('ziarnakawy123').count
	
			Citizen.Wait(10000)
			xPlayer.addInventoryItem('ziarnakawy123', 10)
	end)



RegisterServerEvent('esx_kawiarnia:startTransform2')
AddEventHandler('esx_kawiarnia:startTransform2', function(zone)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local ziarnakawy123 = xPlayer.getInventoryItem('ziarnakawy123').count
	local zmielonakawa123 = xPlayer.getInventoryItem('zmielonakawa123').count
		
		
	if ziarnakawy123 < 10 then
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = 'Masz niewystarczającą ilość ziaren kawy',
			type = "error",
			timeout = 3000,
			layout = "centerLeft"
		})

	elseif zmielonakawa123 == 80 or zmielonakawa123 > 80 then

		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = 'Masz za duzo ziaren kawy przy sobie',
			type = "error",
			timeout = 3000,
			layout = "centerLeft"
		})

	return
	else

		PlayersHarvesting[_source]=true
			TriggerClientEvent('esx_kawiarnia:startTransform3', source)
end
			end)
	
			


RegisterServerEvent('esx_kawiarnia:startTransform4')
AddEventHandler('esx_kawiarnia:startTransform4', function(zone)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

		
	
			Citizen.Wait(10000)
			xPlayer.removeInventoryItem('ziarnakawy123', 10)
			xPlayer.addInventoryItem('zmielonakawa123', 20)
	end)

RegisterServerEvent('esx_kawiarnia:startTransform5')
AddEventHandler('esx_kawiarnia:startTransform5', function(zone)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local zmielonakawa123 = xPlayer.getInventoryItem('zmielonakawa123').count
	local kawa1231231 = xPlayer.getInventoryItem('kawa123123').count

		
	if zmielonakawa123 < 20 then
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = 'Masz niewystarczającą ilość zmielonej kawy',
			type = "error",
			timeout = 3000,
			layout = "centerLeft"
		})

	elseif kawa1231231 == 20 or kawa1231231 > 20 then
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = 'Posiadasz za duzo zapakowanych kawa przy sobie',
			type = "error",
			timeout = 3000,
			layout = "centerLeft"
		})


	return
	else

		PlayersHarvesting[_source]=true
		    TriggerClientEvent('esx_kawiarnia:startTransform6', source)
			end
			end)

RegisterServerEvent('esx_kawiarnia:startTransform7')
AddEventHandler('esx_kawiarnia:startTransform7', function(zone)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

		

			Citizen.Wait(10000)
			xPlayer.removeInventoryItem('zmielonakawa123', 20)
			xPlayer.addInventoryItem('kawa123123', 5)
			end)

RegisterServerEvent('esx_kawiarnia:stopHarvest')
AddEventHandler('esx_kawiarnia:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false

	end
end)

RegisterServerEvent('esx_kawiarnia:stopTransform')
AddEventHandler('esx_kawiarnia:stopTransform', function()

	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		
	else
		PlayersTransforming[_source]=true
		
	end
end)


	RegisterServerEvent('esx_kawiarnia:startSell')
	AddEventHandler('esx_kawiarnia:startSell', function(zone)
		local _source = source
		local xPlayer  = ESX.GetPlayerFromId(source)
		local zmielonakawa123 = xPlayer.getInventoryItem('zmielonakawa123').count
		local kawa1231231 = xPlayer.getInventoryItem('kawa123123').count
		
	if kawa1231231 < 10 then
		TriggerClientEvent("pNotify:SendNotification", _source, {
			text = 'Masz niewystarczającą ilość zapakowanej kawy',
			type = "error",
			timeout = 3000,
			layout = "centerLeft"
		})



	return
		end

		
				PlayersHarvesting[_source]=true
				TriggerClientEvent('esx_kawiarnia:startSell2', source)

		end)


	RegisterServerEvent('esx_kawiarnia:startSell3')
	AddEventHandler('esx_kawiarnia:startSell3', function(zone)
		local _source = source
		local xPlayer  = ESX.GetPlayerFromId(source)
		local identifier = GetPlayerName(source)
		local societyAccount = nil

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_kawiarnia', function(account)
			societyAccount = account
		end)
		if societyAccount ~= nil then
			societyAccount.addMoney(25500)
		end
		
				Citizen.Wait(10000)
				xPlayer.removeInventoryItem('kawa123123', 20)
				xPlayer.addMoney(82500)
				xPlayer.addInventoryItem('paragonkawiarnia', 1)
			
			sendToDiscord (('esx_kawiarnia:startSell3'), "Gracz [".. _source .."] " .. identifier .. " sprzedal kawe licka gracza: " .. xPlayer.identifier .. " i zarobil i przy okazji otrzymal fakture kawiarni ") 
		end)