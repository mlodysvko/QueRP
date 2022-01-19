ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
RegisterServerEvent('duty:police')
AddEventHandler('duty:police', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == 'police' and xPlayer.job.grade == 0 then
            xPlayer.setJob('offpolice', 0)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 1 then
        xPlayer.setJob('offpolice', 1)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 2 then
        xPlayer.setJob('offpolice', 2)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 3 then
        xPlayer.setJob('offpolice', 3)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 4 then
        xPlayer.setJob('offpolice', 4)
		    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 5 then
        xPlayer.setJob('offpolice', 5)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 6 then
        xPlayer.setJob('offpolice', 6)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 7 then
        xPlayer.setJob('offpolice', 7)
		    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 8 then
        xPlayer.setJob('offpolice', 8)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 9 then
        xPlayer.setJob('offpolice', 9)
    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 10 then
        xPlayer.setJob('offpolice', 10)
		    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 11 then
        xPlayer.setJob('offpolice', 11)
		    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 12 then
        xPlayer.setJob('offpolice', 12)
		    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 13 then
        xPlayer.setJob('offpolice', 13)
		    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 14 then
        xPlayer.setJob('offpolice', 14)
		    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 15 then
        xPlayer.setJob('offpolice', 15)
		    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 16 then
        xPlayer.setJob('offpolice', 16)
				    elseif xPlayer.job.name == 'police' and xPlayer.job.grade == 17 then
        xPlayer.setJob('offpolice', 17)
    end
    if xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 0 then
        xPlayer.setJob('police', 0)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 1 then
        xPlayer.setJob('police', 1)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 2 then
        xPlayer.setJob('police', 2)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 3 then
        xPlayer.setJob('police', 3)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 4 then
        xPlayer.setJob('police', 4)
		    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 5 then
        xPlayer.setJob('police', 5)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 6 then
        xPlayer.setJob('police', 6)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 7 then
        xPlayer.setJob('police', 7)
		    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 8 then
        xPlayer.setJob('police', 8)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 9 then
        xPlayer.setJob('police', 9)
    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 10 then
        xPlayer.setJob('police', 10)
		    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 11 then
        xPlayer.setJob('police', 11)
		    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 12 then
        xPlayer.setJob('police', 12)
		    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 13 then
        xPlayer.setJob('police', 13)
		    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 14 then
        xPlayer.setJob('police', 14)
		    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 15 then
        xPlayer.setJob('police', 15)
		    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 16 then
        xPlayer.setJob('police', 16)
				    elseif xPlayer.job.name == 'offpolice' and xPlayer.job.grade == 17 then
        xPlayer.setJob('police', 17)
    end
end)


RegisterServerEvent('duty:ambulance')
AddEventHandler('duty:ambulance', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 0 then
        xPlayer.setJob('offambulance', 0)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 1 then
        xPlayer.setJob('offambulance', 1)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 2 then
        xPlayer.setJob('offambulance', 2)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 3 then
        xPlayer.setJob('offambulance', 3)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 4 then
        xPlayer.setJob('offambulance', 4)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 5 then
        xPlayer.setJob('offambulance', 5)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 6 then
        xPlayer.setJob('offambulance', 6)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 7 then
        xPlayer.setJob('offambulance', 7)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 8 then
        xPlayer.setJob('offambulance', 8)
    elseif xPlayer.job.name == 'ambulance' and xPlayer.job.grade == 9 then
        xPlayer.setJob('offambulance', 9)
    end

    if xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 0 then
        xPlayer.setJob('ambulance', 0)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 1 then
        xPlayer.setJob('ambulance', 1)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 2 then
        xPlayer.setJob('ambulance', 2)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 3 then
        xPlayer.setJob('ambulance', 3)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 4 then
        xPlayer.setJob('ambulance', 4)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 5 then
        xPlayer.setJob('ambulance', 5)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 6 then
        xPlayer.setJob('ambulance', 6)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 7 then
        xPlayer.setJob('ambulance', 7)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 8 then
        xPlayer.setJob('ambulance', 8)
    elseif xPlayer.job.name == 'offambulance' and xPlayer.job.grade == 9 then
        xPlayer.setJob('ambulance', 9)
    end
end)

function sendNotification(xSource, message, messageType, messageTimeout)
    TriggerClientEvent("pNotify:SendNotification", xSource, {
        text = message,
        type = messageType,
        queue = "qalle",
        timeout = messageTimeout,
        layout = "bottomCenter"
    })
end