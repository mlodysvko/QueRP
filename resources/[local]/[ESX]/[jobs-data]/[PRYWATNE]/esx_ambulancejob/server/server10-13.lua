ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("break_10-13srp:request")
AddEventHandler("break_10-13srp:request", function(Officer)
	TriggerClientEvent("break_10-13srp:alert", -1, source, Officer)
end)

ESX.RegisterServerCallback('break_10-13srp:checkjob', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
 	if xPlayer.job.name == 'ambulance' then
		cb(true)
	else
		cb(false)
	end
end)