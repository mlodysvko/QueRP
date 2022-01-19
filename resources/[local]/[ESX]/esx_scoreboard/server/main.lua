ESX = nil
local connectedPlayers = {}

function GetPlayers()
	return connectedPlayers
end


local ActiveJobs = {}




TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



Citizen.CreateThread(function()
	Citizen.Wait(2000)
CountCops()
end)

function CountCops()
	Wait(5000)
	local xPlayers = ESX.GetPlayers()

	local police = 0
	local ambulance = 0 
	local mecano = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			police = police + 1
		elseif  xPlayer.job.name == 'ambulance' then
			ambulance = ambulance + 1
		elseif xPlayer.job.name == 'mecano' then
			mecano = mecano + 1
		end
		-- print(xPlayer.name)
		Wait(250)
	end
	ActiveJobs["police"] = police
	ActiveJobs["ambulance"] = ambulance
	ActiveJobs["mecano"] = mecano
	-- print('Refresh jobów, '..police.." "..ambulance.." "..mecano)
	SetTimeout(60000 * 1000 * 5, CountCops)
end


function getJobsW(job)
	-- print(ActiveJobs[job].." SCOREBOARD")
	return ActiveJobs[job]
end



ESX.RegisterServerCallback('esx_scoreboard:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers)
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name

	TriggerClientEvent('esx_scoreboard:counter', -1, connectedPlayers)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	AddPlayerToScoreboard(xPlayer, true)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil

	TriggerClientEvent('esx_scoreboard:counter', -1, connectedPlayers)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			local players = ESX.GetPlayers()
			
			for _, player in ipairs(players) do
				local xPlayer = ESX.GetPlayerFromId(player)
				AddPlayerToScoreboard(xPlayer)
			end	
			
			--[[for i = 1, 256, 1 do
				connectedPlayers[i] = {}
				connectedPlayers[i].id = i
				connectedPlayers[i].identifier = 'hexik'..i
				connectedPlayers[i].name = 'nick'..i
				connectedPlayers[i].job = 'ambulance'
				connectedPlayers[i].group = 'user'			
			end]]
		end)
	end
end)

function AddPlayerToScoreboard(xPlayer, update)
	local playerId = xPlayer.source

	connectedPlayers[playerId] = {}
	connectedPlayers[playerId].id = playerId
	connectedPlayers[playerId].identifier = xPlayer.identifier
	connectedPlayers[playerId].name = xPlayer.getName()
	connectedPlayers[playerId].job = xPlayer.job.name
	connectedPlayers[playerId].hiddenjob = xPlayer.hiddenjob.name
	connectedPlayers[playerId].group = xPlayer.group

	if update then
		TriggerClientEvent('esx_scoreboard:counter', -1, connectedPlayers)
	end
end

RegisterServerEvent('esx_scoreboard:players')
AddEventHandler('esx_scoreboard:players', function()
	TriggerClientEvent('esx_scoreboard:players', source, connectedPlayers)
end)

RegisterServerEvent('esx_scoreboard:Show')
AddEventHandler('esx_scoreboard:Show', function(text)
	local _source = source
	TriggerClientEvent("sendProximityMessageMe", -1, _source, _source, text)
end)