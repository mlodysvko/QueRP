-----------------------------------------
-- Created Mr Dawid#7841
-----------------------------------------
ESX = nil
local PlayersTransforming, PlayersSelling, PlayersHarvesting = {}, {}, {}
local kekw, kek = 1, 1

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'psm', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'psm', '4PSM', 'society_psm', 'society_psm', 'society_psm', {type = 'private'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "Material" then
			local itemQuantity = xPlayer.getInventoryItem('4psm_material').count
			if itemQuantity >= 20 then
				return
			else
				SetTimeout(Config.Czasmaterial, function()
					xPlayer.addInventoryItem('4psm_material', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_psm:startHarvest')
AddEventHandler('esx_psm:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		Harvest(_source,zone)
	end
end)

RegisterServerEvent('esx_psm:stopHarvest')
AddEventHandler('esx_psm:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
	end
end)

local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "Szycie" then
			local itemQuantity = xPlayer.getInventoryItem('4psm_material').count

			if itemQuantity <= 0 then
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(Config.Czasszycie, function()
						xPlayer.removeInventoryItem('4psm_material', 1)
						xPlayer.addInventoryItem('4psm_ubrania', 1)
						Transform(source, zone)
					end)
				else
					SetTimeout(Config.Czasszycie, function()
						xPlayer.removeInventoryItem('4psm_material', 1)
						xPlayer.addInventoryItem('4psm_ubrania', 1)
				
						Transform(source, zone)
					end)
				end
			end
		elseif zone == "Pakowanie" then
			local itemQuantity = xPlayer.getInventoryItem('4psm_ubrania').count
			if itemQuantity <= 0 then
				return
			else
				SetTimeout(Config.Czaspako, function()
					xPlayer.removeInventoryItem('4psm_ubrania', 1)
					xPlayer.addInventoryItem('4psm_paczkaubran', 1)
		  
					Transform(source, zone)	 
			                SeedTest() 
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_psm:startTransform')
AddEventHandler('esx_psm:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_psm:stopTransform')
AddEventHandler('esx_psm:stopTransform', function()
	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false		
	else
	   PlayersTransforming[_source]=true
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('4psm_paczkaubran').count <= 0 then
				kekw = 0
			else
				kekw = 1
			end
		
			if kekw == 0 then
				return
			elseif xPlayer.getInventoryItem('4psm_paczkaubran').count <= 0 then
				kekw = 0
				return
			else
				if (kek == 1) then
					SetTimeout(Config.Czasoddam, function()
						local wyp1 = Config.Wyplata1
						local wyp2 = Config.Wyplata2
						local wypfirma1 = Config.WypFirma1
						local wypfirma2 = Config.WypFirma2
						local wypsuma = math.random(wyp1,wyp2)
						local wypsumafir = math.random(wypfirma1,wypfirma2)

                        xPlayer.addMoney(wypsuma)
	 					xPlayer.removeInventoryItem('4psm_paczkaubran', 20)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_psm', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(wypsumafir)
						end
						Sell(source,zone)
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx_psm:startSell')
AddEventHandler('esx_psm:startSell', function(zone)
	local _source = source

	if PlayersSelling[_source] == false then
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		Sell(_source, zone)
	end
end)

RegisterServerEvent('esx_psm:stopSell')
AddEventHandler('esx_psm:stopSell', function()
	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		
	else
		PlayersSelling[_source]=true
	end
end)

RegisterServerEvent('esx_psm:getStockItem')
AddEventHandler('esx_psm:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_psm', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end

		xPlayer.showNotification('Włożyłeś x' .. count .. ' ' .. item.label)
	end)
end)

ESX.RegisterServerCallback('esx_psm:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_psm', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_psm:putStockItems')
AddEventHandler('esx_psm:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_psm', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end

		xPlayer.showNotification('Wyciągłeś x' .. count .. ' ' .. item.label)
	end)
end)

ESX.RegisterServerCallback('esx_psm:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})
end)