
local alertsCount = 0

local actAlert = {
	number = nil,
	message = '',
	coords = nil
}

function getIdentity(license)
	local identifier = license
	local result = MySQL.Sync.fetchAll("SELECT firstname, lastname, job, job_grade, job_id FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]
		local badge = json.decode(identity.job_id)

		return {
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			job = identity['job'],
			job_grade = identity['job_grade'],
			badge = {
				label = badge.name,
				number = badge.id
			}

                        
		}
	else
		return nil
	end
end

RegisterServerEvent('arivi-alert:acceptedAlert')
AddEventHandler('arivi-alert:acceptedAlert', function(dt, aO)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local deta = dt
	local num = deta.number
	local name = getIdentity(xPlayer.identifier)
	local xPlayers = ESX.GetPlayers()
	local badgeFull = 'Brak odznaki'
	if name.badge.number ~= 0 then 
		badgeFull = name.badge.label .. ' ' .. name.badge.number
	end
	if num == 'police' then
		local notif = ('~b~'..name.firstname..' '..name.lastname..' ['..badgeFull..'] ~w~zaakceptował zgłoszenie.')
	
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('esx:showNotification', xPlayer.source, notif)
			end
		end
	elseif num == 'ambulance' then
		local notif = ('~r~'..GetCharacterName(_source)..' ~w~zaakceptował zgłoszenie.')
	
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'ambulance' then
				TriggerClientEvent('esx:showNotification', xPlayer.source, notif)
			end
		end
	elseif num == 'mecano' then
		local notif = ('~g~'..GetCharacterName(_source)..' ~w~zaakceptował zgłoszenie.')
	
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'mecano' then
				TriggerClientEvent('esx:showNotification', xPlayer.source, notif)
			end
		end
	elseif num == 'taxi' then
		local notif = ('~y~'..GetCharacterName(_source)..' ~w~zaakceptował zgłoszenie.')
	
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'taxi' then
				TriggerClientEvent('esx:showNotification', xPlayer.source, notif)
			end
		end
	end
	
	if actAlert.oneAccept == false then
		TriggerClientEvent('esx:showNotification', aO, 'Twoje zgłoszenie zostało odebrane.')
		actAlert.oneAccept = true
		TriggerClientEvent('arivi-alert:accepted', aO)
	end
end)

RegisterServerEvent('arivi-alert:startCall')
AddEventHandler('arivi-alert:startCall', function(number, message, coords, player)
	local source = source
	local xPlayers = ESX.GetPlayers()
	 
	-- if number == 'police' then
	
	-- 	actAlert = {
	-- 		number = number,
	-- 		message = message,
	-- 		coords = coords,
	-- 		oneAccept = false,
	-- 		player = player
	-- 	}
	
	-- 	alertsCount = alertsCount + 1
		
	-- 	for i=1, #xPlayers, 1 do
	-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
	-- 		if xPlayer.job.name == 'police' then
	-- 			TriggerClientEvent('arivi-alert:sendAlert', xPlayer.source, actAlert, player)

	-- 			notifyAlertSMS(xPlayer.source, actAlert)
	-- 		end
	-- 	end
		
	-- elseif number == 'ambulance' then
	
	-- 	actAlert = {
	-- 		number = number,
	-- 		message = message,
	-- 		coords = coords,
	-- 		oneAccept = false
	-- 	}
	
	-- 	alertsCount = alertsCount + 1
		
	-- 	for i=1, #xPlayers, 1 do
	-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
	-- 		if xPlayer.job.name == 'ambulance' then
	-- 			TriggerClientEvent('arivi-alert:sendAlert', xPlayer.source, actAlert, player)

	-- 			notifyAlertSMS(xPlayer.source, actAlert)
	-- 		end
	-- 	end
		
	-- elseif number == 'mecano' then
	
	-- 	actAlert = {
	-- 		number = number,
	-- 		message = message,
	-- 		coords = coords,
	-- 		oneAccept = false
	-- 	}
	
	-- 	alertsCount = alertsCount + 1
		
	-- 	for i=1, #xPlayers, 1 do
	-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
	-- 		if xPlayer.job.name == 'mecano' then
	-- 			TriggerClientEvent('arivi-alert:sendAlert', xPlayer.source, actAlert, player)

	-- 			notifyAlertSMS(xPlayer.source, actAlert)
	-- 		end
	-- 	end
		
	-- elseif number == 'taxi' then
	
	-- 	actAlert = {
	-- 		number = number,
	-- 		message = message,
	-- 		coords = coords,
	-- 		oneAccept = false
	-- 	}
	
	-- 	alertsCount = alertsCount + 1
		
	-- 	for i=1, #xPlayers, 1 do
	-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
	-- 		if xPlayer.job.name == 'taxi' then
	-- 			TriggerClientEvent('arivi-alert:sendAlert', xPlayer.source, actAlert, player)

	-- 			notifyAlertSMS(xPlayer.source, actAlert)
	-- 		end
	-- 	end
	-- end
end)

function GetCharacterName(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})

	if result[1] and result[1].firstname and result[1].lastname then
			return ('%s %s'):format(result[1].firstname, result[1].lastname)
	else
		return GetPlayerName(source)
	end
end

function GetCharacterPhone(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll('SELECT number FROM user_sim WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})

	if result[1] and result[1].number then
		return result[1].number
	else
		return nil
	end
end

function notifyAlertSMS(sors, alert)
	local playerNumber = GetCharacterPhone(sors)
	local mess = '!ALERT! Dyspozytornia: ' .. alert.message
	if alert.coords ~= nil then
		mess = mess .. ' | GPS: ' .. alert.coords.x .. ', ' .. alert.coords.y 
	end

	if playerNumber ~= nil then

		TriggerEvent('gcPhone:_internalAddMessage', alert.number, sors, mess, 0, function (smsMess)
			TriggerClientEvent("gcPhone:receiveMessage", sors, smsMess)
		end)
	end
end