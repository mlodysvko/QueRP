local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PoliceGUI               = false
local PlayerData              = {}
local CurrentTask             = {}

ESX = nil
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

RegisterNetEvent('tablet_lsc:opentab')
AddEventHandler('tablet_lsc:opentab', function()
	if not PoliceGUI then
		SetNuiFocus(true, true)
		SendNUIMessage({type = 'open'})
		PoliceGUI = true
	end
end)

Citizen.CreateThread(function()	
	while true do
		Citizen.Wait(1)
		if PlayerData.job ~= nil and (PlayerData.job.name == 'mecano' or PlayerData.job.name == 'offmecano') then
			if IsControlJustPressed(0, Keys["-"]) then
				if PlayerData.job.name == 'mecano' then
					if not PoliceGUI then
						SetNuiFocus(true, true)
						SendNUIMessage({type = 'open'})
						PoliceGUI = true
					end
				else
					ESX.ShowNotification("~r~Nie jesteś na służbie!")
				end
			end

			if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
				ESX.ShowNotification('Unieważniłeś/aś zajęcie')
				ESX.ClearTimeout(CurrentTask.Task)
				ClearPedTasks(PlayerPedId())
			
				CurrentTask.Busy = false
			end
		end
	end
end)

RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
	PoliceGUI = false
end)

RegisterNUICallback('mandat', function(data, cb)
	local sender = GetPlayerServerId(player)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		MandatPlayer(GetPlayerServerId(closestPlayer), data.mandatamount, data.mandatreason)
		TriggerEvent('pNotify:SendNotification', {text = "Wpłacono ".. data.mandatamount / 2 ..'$ z Faktury, kase na Twoje konto w banku'})
	end	
end)


function MandatPlayer(player, ilosc, powod)
	TriggerServerEvent("Heli_tabletlsc", player, ilosc, powod)
end