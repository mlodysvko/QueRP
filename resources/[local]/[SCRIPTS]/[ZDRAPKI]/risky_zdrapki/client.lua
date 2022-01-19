ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
local drapie = false
RegisterNetEvent('chujkurwa:zdrapuj')
AddEventHandler('chujkurwa:zdrapuj', function()
if drapie == false then
    ESX.ShowNotification('~p~Zdrapywanko....')
    SetNuiFocus(false,false)
    drapie = true
	local wynik = math.random(1,15)
	TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_PARKING_METER", 0, false)
	Citizen.Wait(4000)
	if wynik == 1 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		TriggerServerEvent("chujkurwa:wygranko1")
		SendNUIMessage({type = 'openGeneral3'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll3'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 2 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Lipton...')
		SendNUIMessage({type = 'openGeneral2'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll2'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 3 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		TriggerServerEvent("chujkurwa:wygranko2")
		SendNUIMessage({type = 'openGeneral4'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll4'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 4 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		TriggerServerEvent("chujkurwa:wygranko3")
		SendNUIMessage({type = 'openGeneral5'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll5'})
		ClearPedTasksImmediately(GetPlayerPed(-1))
		
	elseif wynik == 5 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Bieda incoming...')
		SendNUIMessage({type = 'openGeneral6'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll6'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 6 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Zlomiarz czeka...')
		SendNUIMessage({type = 'openGeneral7'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll7'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 7 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Idz juz do normalnej roboty...')
		SendNUIMessage({type = 'openGeneral8'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll8'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 8 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Bylo blisko... Try Again')
		SendNUIMessage({type = 'openGeneral9'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll9'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 9 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Prawie, ale nadal nic...')
		SendNUIMessage({type = 'openGeneral'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 10 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Prawie, ale nadal nic...')
		SendNUIMessage({type = 'openGeneral'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 11 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Prawie, ale nadal nic...')
		SendNUIMessage({type = 'openGeneral'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 12 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Prawie, ale nadal nic...')
		SendNUIMessage({type = 'openGeneral'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 13 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Prawie, ale nadal nic...')
		SendNUIMessage({type = 'openGeneral'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 14 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Prawie, ale nadal nic...')
		SendNUIMessage({type = 'openGeneral'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 15 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Prawie, ale nadal nic...')
		SendNUIMessage({type = 'openGeneral'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll'})
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end
else
ESX.ShowNotification('~r~Nie zdrapuj wszystkiego na raz!')
end
	
end)

