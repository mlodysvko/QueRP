
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('scriptmanager_blackout:dzwon')
AddEventHandler('scriptmanager_blackout:dzwon', function(list, damage, code)	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.protect ~= code then
		-- banujesz
	end
	for k,v in pairs(list) do
		TriggerClientEvent('scriptmanager_blackout:dzwon', v, damage)
	end
	
	TriggerClientEvent('scriptmanager_blackout:dzwon', _source, damage)
end)

RegisterServerEvent('scriptmanager_blackout:impact')
AddEventHandler('scriptmanager_blackout:impact', function(list, speedBuffer, velocityBuffer)
	local _source = source
	for k,v in pairs(list) do
		TriggerClientEvent('scriptmanager_blackout:impact', v, speedBuffer, velocityBuffer)
	end
	
	TriggerClientEvent('scriptmanager_blackout:impact', _source, speedBuffer, velocityBuffer)
end)
