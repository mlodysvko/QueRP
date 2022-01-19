ESX                           = nil
local PlayerData                = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

AddEventHandler("onClientMapStart", function()
	TriggerEvent("chat:addSuggestion", "/10-13", "10-13")
end)

RegisterCommand("10-13", function()
	ESX.TriggerServerCallback('esx_policejob:10-13:checkjob', function(ils1)
		if ils1 == true then
			if ESX.GetPlayerData().job.name == 'police' then
				--SendSignal()
				TriggerServerEvent('esx_policejob:checkmyitem')
			end
		else
			ESX.ShowNotification('Nie jestes w SAST')
		end
	end)
end)

function SendSignal10()
	while PlayerData == nil do
		Citizen.Wait(100)
	end
	if PlayerData.job.name == 'police' then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
		local data = {
			number = 'police',
			message = '10-13 - Uwaga Ranny Funkcjonariusz'
		}
			TriggerEvent('arivi-alert:callNumberD', data)
	end
end

RegisterNetEvent('imusingnow')
AddEventHandler('imusingnow', function()
	-- bolek i lolek byl by dumny
	SendSignal10()
end)