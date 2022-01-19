local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)


RegisterServerEvent('whistle:Get')
AddEventHandler('whistle:Get', function(event,targetID)
	TriggerClientEvent("whistle:Status",targetID,event,source)
end)

RegisterServerEvent('whistle:Send')
AddEventHandler('whistle:Send', function(event,targetID,whistle)
	TriggerClientEvent(event,targetID,whistle)
end)

RegisterServerEvent('whistle:Hands')
AddEventHandler('whistle:Hands', function(event,targetID,whistle)
	TriggerClientEvent(event,targetID,whistle)
end)

RegisterServerEvent('esx_animations:save')
AddEventHandler('esx_animations:save', function(binds)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	MySQL.Async.execute('UPDATE users SET animacje = @animacje WHERE identifier = @identifier',
	{
		['@animacje'] = json.encode(binds),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_animations:load')
AddEventHandler('esx_animations:load', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local bindy = nil
	
	if xPlayer ~= nil then
		MySQL.Async.fetchAll('SELECT animacje FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1].animacje then
				TriggerClientEvent('esx_animations:bind', _source, json.decode(result[1].animacje))
			else
				TriggerClientEvent('esx_animations:bind', _source, {})
			end
		end)
	end
end)



--User

RegisterServerEvent('route68_animacje:powitajSynchroS')
AddEventHandler('route68_animacje:powitajSynchroS', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

	xTarget.showNotification('Naciśnij [Y] aby przywitać się z ['..xPlayer.source..'] (5 sekund)')
	xPlayer.showNotification('Wysłano propozycję przywitania do ['..xTarget.source..']')
	TriggerClientEvent('route68_animacje:powitajSynchroC', xTarget.source, xPlayer.source)
end)

RegisterServerEvent('route68_animacje:OdpalAnimacje')
AddEventHandler('route68_animacje:OdpalAnimacje', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

    TriggerClientEvent('route68_animacje:PrzywitajTarget', xTarget.source, source)
	TriggerClientEvent('route68_animacje:PrzywitajSource', source)
end)

RegisterServerEvent('route68_animacje:przytulSynchroS')
AddEventHandler('route68_animacje:przytulSynchroS', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

	xTarget.showNotification('Naciśnij [Y] aby przytulić się z ['..xPlayer.source..'] (5 sekund)')
	xPlayer.showNotification('Wysłano propozycję przytulenia do ['..xTarget.source..']')
	TriggerClientEvent('route68_animacje:przytulSynchroC', xTarget.source, xPlayer.source)
end)

RegisterServerEvent('route68_animacje:OdpalAnimacje3')
AddEventHandler('route68_animacje:OdpalAnimacje3', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

    TriggerClientEvent('route68_animacje:PrzytulTarget', xTarget.source, source)
	TriggerClientEvent('route68_animacje:PrzytulSource', source)
end)

RegisterServerEvent('route68_animacje:pocalujSynchroS')
AddEventHandler('route68_animacje:pocalujSynchroS', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	
	xTarget.showNotification('Naciśnij [Y] aby pocałować się z ['..xPlayer.source..'] (5 sekund)')
	xPlayer.showNotification('Wysłano propozycję pocałunku do ['..xTarget.source..']')
	TriggerClientEvent('route68_animacje:pocalujSynchroC', xTarget.source, xPlayer.source)
end)

RegisterServerEvent('route68_animacje:OdpalAnimacje2')
AddEventHandler('route68_animacje:OdpalAnimacje2', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

    TriggerClientEvent('route68_animacje:PocalujTarget', xTarget.source, source)
	TriggerClientEvent('route68_animacje:PocalujSource', source)
end)

RegisterServerEvent('route68_animacje:OdpalAnimacje4')
AddEventHandler('route68_animacje:OdpalAnimacje4', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	
	xTarget.showNotification('Naciśnij [Y] aby zostać noszonym przez ['..xPlayer.source..'] (5 sekund)')
	xPlayer.showNotification('Wysłano propozycję noszenia ['..xTarget.source..']')
	TriggerClientEvent('route68_animacje:przytulSynchroC2', xTarget.source, xPlayer.source)
end)

RegisterServerEvent('route68_animacje:OdpalAnimacje5')
AddEventHandler('route68_animacje:OdpalAnimacje5', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

	TriggerClientEvent('cmg2_animations:startMenu2', xTarget.source)
end)

RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(target)
	local xTarget = ESX.GetPlayerFromId(target)
	if xTarget ~= nil then
		TriggerClientEvent('cmg2_animations:cl_stop', xTarget.source)
	end
end)
