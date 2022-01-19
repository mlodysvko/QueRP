ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
local drapie = false
RegisterNetEvent('kurwachuj:zdrapuj')
AddEventHandler('kurwachuj:zdrapuj', function()
if drapie == false then
    ESX.ShowNotification('~p~Zdrapywanko....')
    SetNuiFocus(false,false)
    drapie = true
	local wynik = math.random(1,27)
	TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_PARKING_METER", 0, false)
	Citizen.Wait(4000)
	if wynik == 1 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		TriggerServerEvent("kurwachuj:wygranko1")
		SendNUIMessage({type = 'openGeneral3'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll3'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 2   then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		TriggerServerEvent("kurwachuj:wygranko4")
		SendNUIMessage({type = 'openGeneral1'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll1'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 3 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		TriggerServerEvent("kurwachuj:wygranko2")
		SendNUIMessage({type = 'openGeneral4'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll4'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 4  or wynik == 16 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		TriggerServerEvent("kurwachuj:wygranko3")
		SendNUIMessage({type = 'openGeneral5'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll5'})
		ClearPedTasksImmediately(GetPlayerPed(-1))
		
	elseif wynik == 17  or wynik == 5 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Bieda incoming...')
		SendNUIMessage({type = 'openGeneral6'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll6'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 15  or wynik == 19 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Przykro mi...')
		SendNUIMessage({type = 'openGeneral7'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll7'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 6 or wynik == 20 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~Glupio wyszlo...')
		SendNUIMessage({type = 'openGeneral8'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll8'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 8  or wynik == 21 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~No niestety...')
		SendNUIMessage({type = 'openGeneral2'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll2'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 9  or wynik == 22 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~No niestety...')
		SendNUIMessage({type = 'openGeneral2'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll2'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 10  or wynik == 23 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~No niestety...')
		SendNUIMessage({type = 'openGeneral2'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll2'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 11  or wynik == 24 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~No niestety...')
		SendNUIMessage({type = 'openGeneral2'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll2'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 12  or wynik == 7 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~No niestety...')
		SendNUIMessage({type = 'openGeneral2'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll2'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 13  or wynik == 26 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~No niestety...')
		SendNUIMessage({type = 'openGeneral2'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll2'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 14  or wynik == 27 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~No niestety...')
		SendNUIMessage({type = 'openGeneral2'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll2'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 16 then
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		drapie = false
		ESX.ShowNotification('~r~No niestety...')
		SendNUIMessage({type = 'openGeneral2'})
		Citizen.Wait(4500)
		SendNUIMessage({type = 'closeAll2'})
		ClearPedTasksImmediately(GetPlayerPed(-1))

	elseif wynik == 18 then
	PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
	drapie = false
	ESX.ShowNotification('~r~No niestety...')
	SendNUIMessage({type = 'openGeneral2'})
	Citizen.Wait(4500)
	SendNUIMessage({type = 'closeAll2'})
	ClearPedTasksImmediately(GetPlayerPed(-1))

end
else
ESX.ShowNotification('~r~Nie zdrapuj wszystkiego na raz!')
end
	
end)