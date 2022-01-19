
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Island_blackout:dzwon')
AddEventHandler('Island_blackout:dzwon', function(list, damage)	
	local _source = source
	for k,v in pairs(list) do
		TriggerClientEvent('Island_blackout:dzwon', v, damage)
	end
	
	TriggerClientEvent('Island_blackout:dzwon', _source, damage)
end)

RegisterServerEvent('Island_blackout:impact')
AddEventHandler('Island_blackout:impact', function(list, speedBuffer, velocityBuffer)
	local _source = source
	for k,v in pairs(list) do
		TriggerClientEvent('Island_blackout:impact', v, speedBuffer, velocityBuffer)
	end
	
	TriggerClientEvent('Island_blackout:impact', _source, speedBuffer, velocityBuffer)
end)