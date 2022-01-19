ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_policejob:10-13:checkjob', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
 	if xPlayer.job.name == 'police' then
		cb(true)
	else
		cb(false)
	end
end)

RegisterNetEvent('esx_policejob:checkmyitem')
AddEventHandler('esx_policejob:checkmyitem', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'police' and xPlayer.getInventoryItem('panicbutton').count >= 1 then 
		TriggerClientEvent('imusingnow', source)
	else
		TriggerClientEvent('esx:showNotification', source, 'Nie posiadasz przedmiotu "Panic Button"')
	end
end)