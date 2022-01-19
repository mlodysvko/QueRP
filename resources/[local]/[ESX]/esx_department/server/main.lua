ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function sendToDiscord (name,message,color)
    local DiscordWebHook = "https://discord.com/api/webhooks/869330145427746837/U4fHnBEU88sC2GCV8ITNilltf1EjX_Shh41HT0l6Q4fotCUOwP5yCkY1G8o5Upeg5Q-E"

  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
          ["footer"]=  {
          ["text"]= "Zatrudnianie poprzez urzad pracy",
         },
      }
  }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('esx_department:getJobsList', function(source, cb)
	MySQL.Async.fetchAll(
		'SELECT * FROM jobs WHERE whitelisted = false',
		{},
		function(result)
			local data = {}
			for i=1, #result, 1 do
				table.insert(data, {
					value   = result[i].name,
					label   = result[i].label
				})
			end
			cb(data)
		end
	)
end)

RegisterServerEvent('esx_jk_jobs:setJobt')
AddEventHandler('esx_jk_jobs:setJobt', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = GetPlayerName(source)
	xPlayer.setJob("unemployed", 0)
	sendToDiscord (('esx_department:setJob'), "Gracz [".. source .."] " .. identifier .. " licka gracza: " .. xPlayer.identifier .. " otrzymal joba Bezrobotnego ")
	TriggerClientEvent('esx:showNotification', source, 'Zwolniles sie z pracy i zostales~g~ Bezrobotny')
end)

RegisterServerEvent('esx_jk_jobs:setJobp')
AddEventHandler('esx_jk_jobs:setJobp', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = GetPlayerName(source)
	xPlayer.setJob("taxi", 0)
	sendToDiscord (('esx_department:setJob'), "Gracz [".. source .."] " .. identifier .. " licka gracza: " .. xPlayer.identifier .. " otrzymal joba Taxi ")
	TriggerClientEvent('esx:showNotification', source, 'Zostałeś zatrudniony przez~g~ Taxi')
end)

RegisterServerEvent('esx_jk_jobs:setJobn')
AddEventHandler('esx_jk_jobs:setJobn', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = GetPlayerName(source)
	xPlayer.setJob("kawiarnia", 0)
	sendToDiscord (('esx_department:setJob'), "Gracz [".. source .."] " .. identifier .. " licka gracza: " .. xPlayer.identifier .. " otrzymal joba Kawiarni ")
	TriggerClientEvent('esx:showNotification', source, 'Zostałeś zatrudniony przez~g~ Kawiarnie')	
end)