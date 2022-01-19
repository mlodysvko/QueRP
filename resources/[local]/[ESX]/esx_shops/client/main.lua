ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local PlayerData              = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('esx_shops:requestDBItems', function(ShopItems)
		for k,v in pairs(ShopItems) do
			Config.Zones[k].Items = v
		end
	end)
end)

function OpenShopMenu(zone)
	PlayerData = ESX.GetPlayerData()

	local elements = {}
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		if item.limit == -1 then
			item.limit = 100
		end

		table.insert(elements, {
			label      = item.label .. ' - <span style="color: green;">$' .. item.price .. '</span>',
			label_real = item.label,
			item       = item.item,
			price      = item.price,

			-- menu properties
			value      = 1,
			type       = 'slider',
			min        = 1,
			max        = item.limit
		})
	end

	if zone == 'Multimedialny' then
		table.insert(elements, {label = 'Zastrzeż kartę <span style="color: #7cfc00;">$2500</span>', value = 'zastrzez'})
		table.insert(elements, {label = 'Wyrób duplikat <span style="color: #7cfc00;">$2500</span>', value = 'duplikat'})
		table.insert(elements, {label = 'Zarządzaj numerem', value = 'administrator'})
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = _U('shop'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'zastrzez' then
			menu.close()
			OpenZastrzeganieMenu()
		elseif data.current.value == 'duplikat' then
			menu.close()
			OpenDuplikatMenu()
		elseif data.current.value == 'administrator' then
			menu.close()
			OpenAdministratorMenu()
		else
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
				title    = 'Wybierz formę płatności za: '..data.current.label,
				align    = 'center',
				elements = {
					{label = 'Gotówka',  value = 'gotowka'},
					{label = 'Karta', value = 'karta'},
					{label = 'Anuluj zakupy', value = 'niechce'},
				}
			}, function(data2, menu2)
				if data2.current.value == 'gotowka' then
					TriggerServerEvent('adolfhiteler2wojnanazisci', data.current.item, data.current.value, zone)
				elseif data2.current.value == 'karta' then
					TriggerServerEvent('adolfhiteler2wojnanazisci2', data.current.item, data.current.value, zone)
				elseif data2.current.value == 'niechce' then
					menu2.close()
					menu.open()
				end
				menu2.close()
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {zone = zone}
	end)
end

AddEventHandler('esx_shops:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {zone = zone}
end)

AddEventHandler('esx_shops:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)


-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
					DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x) then
					isInMarker  = true
					ShopItems   = v.Items
					currentZone = k
					LastZone    = k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_shops:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_shops:hasExitedMarker', LastZone)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustReleased(0, 38) then

				if CurrentAction == 'shop_menu' then
					OpenShopMenu(CurrentActionData.zone)
				end

				CurrentAction = nil

			end

		else
			Citizen.Wait(500)
		end
	end
end)

CreateThread(function()
	for k,v in pairs(Config.Zones) do
	if v.Blips then
		for i = 1, #v.Pos, 1 do
			local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)

			SetBlipSprite (blip, v.Blip.Sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.8)
			SetBlipColour (blip, v.Blip.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.Blip.Name)
			EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

function OpenDuplikatMenu()
	local elements = {}
	ESX.TriggerServerCallback('gcPhone:getHasSims', function(cards)
	  table.insert(elements, {label = '== Wybierz kartę sim, której chcesz wyrobić duplikat ==', value = 'duplikat'})
		  for _,v in pairs(cards) do
		local cardNumber = v.number
		local lejbel = 'Karta SIM #'..cardNumber
		table.insert(elements, {label = lejbel , value = v})
	  end
	  
	  table.insert(elements, {label = '== Pamiętaj kartę SIM możesz zduplikować tylko raz! ==', value = 'duplikat'})
  
		  ESX.UI.Menu.Open(
		  'default', GetCurrentResourceName(), 'duplikat',
		  {
			  title    = 'Wyrób Duplikat',
			  align    = 'center',
			  elements = elements,
		  },
		  function(data, menu)
		menu.close()
		TriggerServerEvent('gcPhone:duplikatSIM', data.current.value.number)
		  end,
		  function(data, menu)
			  menu.close()
		  end
	  )	
	  end)
  end

  function OpenZastrzeganieMenu()
  local elements = {}
  local cards = {}
  ESX.TriggerServerCallback('gcPhone:getSimShop', function(cards)
    table.insert(elements, {label = '== Wybierz kartę sim, którą chcesz zastrzec ==', value = 'zastrzez'})
	for _,v in pairs(cards) do
		local cardNummer = v.numer
    	local lejbel = 'Karta SIM #' .. cardNummer
      table.insert(elements, {label = lejbel , value = v})
    end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'zastrzez',
		{
			title    = 'Zastrzeż Kartę',
			align    = 'center',
			elements = elements,
		},
		function(data, menu)
		menu.close()
          TriggerServerEvent('gcPhone:zastrzezSIM', data.current.value.numer, PlayerData.protect)
		end,
		function(data, menu)
			menu.close()
		end
	)	
	end, GetPlayerServerId(player))
end

function OpenAdministratorMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {}
  	ESX.TriggerServerCallback('gcPhone:getHasSims', function(cards)
    	table.insert(elements, {label = '== Wybierz kartę sim, którą chcesz zarządzać ==', value = 'empty'})
		
		for _,v in pairs(cards) do
			local cardNumber = v.number
			local lejbel = 'Karta SIM #'..cardNumber
			table.insert(elements, {label = lejbel , value = cardNumber})
		end
	
		table.insert(elements, {label = '== Możesz posiadać maksymalnie 2 administratorów ==', value = 'empty'})

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'administrator',
		{
			title    = 'Wybierz numer',
			align    = 'center',
			elements = elements,
		},	function(data, menu)
			local currentNumber = data.current.value
			if currentNumber ~= 'empty' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'administrator2',
				{
					title = 'Wybierz opcje',
					align = 'center',
					elements = {
						{label = "Dodaj administratora <span style='color: #7cfc00;'>$10 000</span>", value = 'add_admin'},
						{label = "Usuń administratora <span style='color: #7cfc00;'>$5 000</span>", value = 'remove_admin'}
					},
				},	function(data2, menu2)
					if data2.current.value == 'add_admin' then
						local playerCoords = GetEntityCoords(PlayerPedId())
						local playersInArea = ESX.Game.GetPlayersInArea(playerCoords, 5.0)
						local elements2      = {}
						for i=1, #playersInArea, 1 do
							if playersInArea[i] ~= PlayerId() then
								table.insert(elements2, {label = GetPlayerServerId(playersInArea[i]), value = GetPlayerServerId(playersInArea[i])})
							end
						end
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'administrator3',
						{
							title    = "Osoby w pobliżu",
							align    = 'center',
							elements = elements2,
						}, function(data3, menu3)
							ESX.UI.Menu.CloseAll()
							
							TriggerServerEvent('gcPhone:addAdministrator', currentNumber, data3.current.value)
							Wait(500)
							OpenAdministratorMenu()
						end, function(data3, menu3)
							menu3.close()
						end)
					elseif data2.current.value == 'remove_admin' then
						ESX.TriggerServerCallback('gcPhone:getAdministrators', function(admins)
							if admins[1] == nil then
								ESX.ShowNotification("~b~Ten numer nie posiada administratorów")
							else
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'administrator3',
								{
									title    = "Administratorzy",
									align    = 'center',
									elements = admins,
								}, function(data3, menu3)
									local id = data3.current.value
									ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'administrator4',
									{
										title    = "Czy na pewno chcesz usunąć administratora?",
										align    = 'center',
										elements = {
											{label = 'Nie', value = 'no'},
											{label = 'Tak', value = 'yes'}
										}, 
									}, function(data4, menu4)
										if data4.current.value == 'no' then
											menu4.close()
										elseif data4.current.value == 'yes' then
											ESX.UI.Menu.CloseAll()
											TriggerServerEvent('gcPhone:removeAdministrator', currentNumber, id)
											Wait(500)
											OpenAdministratorMenu()
										end
									end, function(data4, menu4)
										menu4.close()
									end)
								end, function(data3, menu3)
									menu3.close()
								end)
							end
						end, currentNumber)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)	
	end)
end