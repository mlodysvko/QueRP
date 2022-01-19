---======================---
---Written by Tościk#9715---
---======================---
local potrzebniPolicjanci = 1 		--<< potrzebni policjanci do aktywacji misji
local CenaNadajnika = 1500

-----------------------------------
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('tostauto:przerobilSkasujitem')
AddEventHandler('tostauto:przerobilSkasujitem', function(rodzaj)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if rodzaj == 'farba' then
		xPlayer.removeInventoryItem('tostfarba', 1)
	elseif rodzaj == 'nadajnik' then
		xPlayer.removeInventoryItem('tostnadajnik', 1)
	elseif rodzaj == 'tablica' then
		xPlayer.removeInventoryItem('tostrej', 1)
	elseif rodzaj == 'dok' then
		xPlayer.removeInventoryItem('tostdok', 1)
	end


end)


RegisterServerEvent('tostauto:zawiadompsy')
AddEventHandler('tostauto:zawiadompsy', function(x, y, z) 
    TriggerClientEvent('tostauto:kradziezLspd', -1, x, y, z)
end)

RegisterServerEvent('tostauto:zawiadompsy2')
AddEventHandler('tostauto:zawiadompsy2', function(x, y, z, plate, klasa, car) 
    TriggerClientEvent('tostauto:kradziezLspd2', -1, x, y, z, plate, klasa, car)
end)

RegisterServerEvent('tostauto:zawiadompsy3')
AddEventHandler('tostauto:zawiadompsy3', function(x, y, z) 
    TriggerClientEvent('tostauto:kradziezLspd3', -1, x, y, z)
end)

RegisterServerEvent('tostauto:sprawdzLspdNaKoniec')
AddEventHandler('tostauto:sprawdzLspdNaKoniec', function()
local policja = CheckCops()

		if policja then
		TriggerClientEvent('tostauto:pozwolWykonacKradziezKoncowa', source)
		else
		TriggerClientEvent('esx:showNotification', source, '~r~Potrzeba przynajmniej ~g~'..potrzebniPolicjanci.. '~r~ LSPD aby aktywować misję.')
		end
end)

RegisterServerEvent('tostukrad:ukonczonoetap')
AddEventHandler('tostukrad:ukonczonoetap', function(etap)
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
local policja = CheckCops()
local blackMoney = xPlayer.getAccount('black_money').money


	if etap == 'etap1' then
	xPlayer.addInventoryItem('tostrej', 1)
	xPlayer.addInventoryItem('tostdok', 1)
	Wait(500)
	elseif etap == 'etap2' then
		if policja then
		xPlayer.addInventoryItem('tostfarba', 1)
		TriggerClientEvent('esx:showNotification', source, '~g~Ukradłeś farbę.')
		Wait(500)
		else
		TriggerClientEvent('esx:showNotification', source, '~r~Potrzeba przynajmniej ~g~'..potrzebniPolicjanci.. '~r~ LSPD aby to wykonać.')
		end
	elseif etap == 'etap21' then
		if blackMoney <= CenaNadajnika then
		TriggerClientEvent('esx:showNotification', source, '~y~Potrzebujesz '..CenaNadajnika..'$ brudnej gotówki aby zakupić nadajnik.')
		else
		xPlayer.removeAccountMoney('black_money', CenaNadajnika)
		xPlayer.addInventoryItem('tostnadajnik', 1)
		TriggerClientEvent('esx:showNotification', source, '~g~Zakupiłeś nowy nadajnik.')
		TriggerClientEvent("tostauto:udanyZakupNadajnika", _source)
		Wait(500)
		end
	end
	
end)

function CheckCops()
	local copsOnDuty = 0
	local Players = ESX.GetPlayers()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	for i = 1, #Players do
        local xPlayer = ESX.GetPlayerFromId(Players[i])
        if xPlayer["job"]["name"] == "police" then
            copsOnDuty = copsOnDuty + 1
        end
    end
	
	if copsOnDuty >= potrzebniPolicjanci then
		return true
    else
		return false
    end
	
end




