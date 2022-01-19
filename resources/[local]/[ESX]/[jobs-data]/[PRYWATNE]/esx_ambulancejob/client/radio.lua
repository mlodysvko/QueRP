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

local displayGPS, displayRadio, talkingonradio = false, false, false
CreateThread(function()
	while true do
		Citizen.Wait(1)
		if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then
			displayGPS, displayRadio = true, true
			local screenXG = 0.975
			local screenXR = 0.955
			local screenXRT = 0.955
			if talkingonradio then
				DrawSprite('mpleaderboard', 'leaderboard_audio_2', screenXRT, 0.98, 0.018, 0.0275, 0.0, 1, 252, 251, 255)
			elseif displayRadio then
				DrawSprite('mpleaderboard', 'leaderboard_audio_2', screenXR, 0.98, 0.018, 0.0275, 0.0, 1, 252, 1, 255)
				screenXG = screenXG - 0.015
				screenXR = screenXR - 0.015
				screenXRT = screenXRT - 0.015
			elseif displayGPS then
				DrawSprite('mpleaderboard', 'leaderboard_globe_icon', screenXG, 0.98, 0.015, 0.0275, 0.0, 0, 255, 0, 255)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait( 0 )
		local ped = PlayerPedId()
		if PlayerData.job ~= nil and PlayerData.job.name == 'police' or PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' or PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
			if DoesEntityExist( ped ) and not IsEntityDead( ped ) then
				if not IsPauseMenuActive() then 
					loadAnimDict( "amb@code_human_police_investigate@idle_a" )
					if IsControlJustReleased( 0, 244 ) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
						TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', 0.1)
						ClearPedTasks(ped)
						SetEnableHandcuffs(ped, false)
						talkingonradio = false
					else
						if IsControlJustPressed( 0, 244 ) and not IsPlayerFreeAiming(PlayerId()) and not IsPedInAnyVehicle(ped, true) then 
							talkingonradio = true
							TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
							TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
							SetEnableHandcuffs(ped, true)
						elseif IsControlJustPressed( 0, 244 ) and IsPlayerFreeAiming(PlayerId()) and not IsPedInAnyVehicle(ped, true) then
							talkingonradio = true
							TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
							TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
							SetEnableHandcuffs(ped, true)
						elseif IsControlJustPressed( 0, 244 ) and IsPedInAnyVehicle(ped, true) then
							talkingonradio = true
							TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
							SetEnableHandcuffs(ped, true)
							TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
						end
					end
				end 
			end
		end
	end
end)
function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end
