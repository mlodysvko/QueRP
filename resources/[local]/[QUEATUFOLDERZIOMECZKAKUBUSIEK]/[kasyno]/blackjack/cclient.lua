ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj 
		end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('route68_blackjack:start')
AddEventHandler('route68_blackjack:start', function()
	ESX.TriggerServerCallback('route68_blackjack:check_money', function(quantity)
		if quantity >= 100 then
			SendNUIMessage({
				type = "enableui",
				enable = true,
				coins = quantity
			})
			SetNuiFocus(true, true)
		else
			ESX.ShowNotification('Potrzebujesz conajmniej 100 żetonów aby zagrać!')
		end
	end, '')
	--roulette_menu()
end)

RegisterNUICallback('escape', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "enableui",
		enable = false
	})
end)

RegisterNUICallback('card', function(data, cb)
	cb('ok')
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'PlayCard', 1.0)
end)

RegisterNUICallback('bet', function(data, cb)
	cb('ok')
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'betup', 1.0)
end)

RegisterNUICallback('escape2', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "enableui",
		enable = false
	})
	TriggerEvent('pNotify:SendNotification', {layout = "Centerleft", text = 'Nie posiadasz wystarczającej ilości żetonów na dalszą grę!'})
end)

RegisterNUICallback('WinBet', function(data, cb)
	cb('ok')
	local count = data.bets
	TriggerServerEvent('route68_blackjack:sold', count, 2)
end)

RegisterNUICallback('TieBet', function(data, cb)
	cb('ok')
	local count = data.bets
	TriggerServerEvent('route68_blackjack:sold', count, 1)
end)

RegisterNUICallback('LostBet', function(data, cb)
	cb('ok')
	local count = data.bets
	TriggerEvent('pNotify:SendNotification', {layout = "Centerleft", text = "Straciłeś/aś "..count.." żetonów! Następnym razem się uda!"})
end)

RegisterNUICallback('Status', function(data, cb)
	cb('ok')
	TriggerEvent('pNotify:SendNotification', {layout = "Centerleft", text = data.tekst})
end)

RegisterNUICallback('StartPartia', function(data, cb)
	cb('ok')
	local count = data.bets
	TriggerServerEvent('route68_blackjack:removemoney', count)
end)