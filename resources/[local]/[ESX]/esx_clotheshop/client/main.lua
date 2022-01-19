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

ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasPayed                = false
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end 
    PlayerData = ESX.GetPlayerData()
    while ESX.GetPlayerData().hiddenjob == nil do
        Citizen.Wait(10)
    end
end)


Citizen.CreateThread(function()
    while true do
    Citizen.Wait(1000)
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.mask_1 == 20 or skin.mask_1 == 100 or skin.mask_1 == 103 or skin.mask_1 == 131 or skin.mask_1 == 136 or skin.mask_1 == 137 or skin.mask_1 == 138 or skin.mask_1 == 142 or skin.mask_1 == 143 or skin.mask_1 == 144 or skin.mask_1 == 147 or skin.mask_1 == 149 or skin.mask_1 == 150 or skin.mask_1 == 151 or skin.mask_1 == 153 or skin.mask_1 == 154 or skin.mask_1 == 155 or skin.mask_1 == 156 or skin.mask_1 == 157 or skin.mask_1 == 158 or skin.mask_1 == 162 or skin.mask_1 == 163 or skin.mask_1 == 173 or skin.mask_1 == 177 then
                TriggerEvent('skinchanger:loadClothes', skin, Config.RemoveList[5])
                ESX.ShowNotification("Nie możesz ubrać tej maski - Zbugowane HitBoxy")
            end 
        end)
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.helmet_1 == 116 or skin.helmet_1 == 112 or skin.helmet_1 == 84 or skin.helmet_1 == 85 or  skin.helmet_1 == 90 or  skin.helmet_1 == 57 or  skin.helmet_1 == 89 or skin.helmet_1 == 86 or skin.helmet_1 == 87 or skin.helmet_1 == 88 or skin.helmet_1 == 117 or skin.helmet_1 == 134 or skin.helmet_1 == 133 or skin.helmet_1 == 147 or skin.helmet_1 == 148 or skin.helmet_1 == 150 or skin.helmet_1 == 157 or skin.helmet_1 == 159 or skin.helmet_1 == 184 or skin.helmet_1 == 185 or skin.helmet_1 == 186 or skin.helmet_1 == 187 or skin.helmet_1 == 189 or skin.helmet_1 == 111 or skin.helmet_1 == 115 then 
				TriggerEvent('skinchanger:loadClothes', skin, Config.RemoveList[2])
				ESX.ShowNotification("Nie możesz ubrać tego nakrycia głowy - Zbugowane HitBoxy")
			end
		end)
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.glasses_1 == 27 then 
				TriggerEvent('skinchanger:loadClothes', skin, Config.RemoveList[6])
				ESX.ShowNotification("Nie możesz ubrać tych okularow - Zbugowane HitBoxy")
			end
		end)
    end
end)

function OpenFirstMenu()

  ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'fajnysklep',
        {
			align    = 'center',
            title    = 'Sklep z Ubraniami',
            elements = {
				{label = 'Sklep Odzieżowy - $500 za Strój', value = 'pal'},
				{label = 'Wybierz Strój - Garderoba', value = 'gume'},
				{label = 'Usuń Strój - Garderoba', value = 'ziomek'},
            }
        },
        function(data, menu)
          if data.current.value == 'pal' then
				OpenShopMenu()
		  elseif data.current.value == 'gume' then
				ESX.TriggerServerCallback('Island_stocks:getPlayerDressing', function(dressing)
						local elements = {}
		
						for i=1, #dressing, 1 do
							table.insert(elements, {
								label = dressing[i],
								value = i
							})
						end

		
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
							title = 'Prywatna Garderoba',	
							align    = 'center',
							elements = elements
						}, function(data2, menu2)
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('Island_stocks:getPlayerOutfit', function(clothes)
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
		
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
								end, data2.current.value)
							end)
						end, function(data2, menu2)
							menu2.close()
						end)
					end)
		  elseif data.current.value == 'ziomek' then
			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title    = 'Prywatna Garderoba',	
					align    = 'center',
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('esx_property:removeOutfit', data2.current.value)
					ESX.ShowNotification('Usunąłeś ubranie z prywatnej garderoby.')
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		  end
        end,
        function(data, menu)
             menu.close()
        end
    )
end

function OpenShopMenu()

	HasPayed = false

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop_confirm',
			{
				title = _U('valid_this_purchase'),
				align = 'center',
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			},
			function(data, menu)

				menu.close()

				if data.current.value == 'yes' then

					ESX.TriggerServerCallback('esx_clotheshop:buyClothes', function(bought)
						
						if bought then

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)

							TriggerServerEvent('esx_clotheshop:pay')

							HasPayed = true

							ESX.TriggerServerCallback('esx_clotheshop:checkPropertyDataStore', function(foundStore)

								if foundStore then

									ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'save_dressing',
										{
											title = _U('save_in_dressing'),
											align = 'center',
											elements = {
												{label = _U('yes'), value = 'yes'},
												{label = _U('no'),  value = 'no'},
											}
										},
										function(data2, menu2)

											menu2.close()

											if data2.current.value == 'yes' then

												ESX.UI.Menu.Open(
													'dialog', GetCurrentResourceName(), 'outfit_name',
													{
														title = _U('name_outfit'),
													},
													function(data3, menu3)

														menu3.close()

														TriggerEvent('skinchanger:getSkin', function(skin)
															TriggerServerEvent('esx_clotheshop:saveOutfit', data3.value, skin)
														end)

														ESX.ShowNotification(_U('saved_outfit'))

													end,
													function(data3, menu3)
														menu3.close()
													end
												)

											end

										end
									)

								end

							end)

						else

							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(_U('not_enough_money'))

						end

					end)

				end

				if data.current.value == 'no' then

					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)

				end

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}

			end,
			function(data, menu)

				menu.close()

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}

			end
		)

	end, function(data, menu)

			menu.close()

			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {}

	end, {
		'chain_1',
		'chain_2',
		'mask_1',
		'mask_2',
		'tshirt_1',
		'tshirt_2',
		'torso_1',
		'torso_2',
		'decals_1',
		'decals_2',
		'arms',
		'pants_1',
		'pants_2',
		'shoes_1',
		'shoes_2',
		'chain_1',
		'chain_2',
                'watches_1',
                'watches_2',
		'helmet_1',
		'helmet_2',
		'glasses_1',
		'glasses_2',
                'bags_1',
                'bags_2',
	})

end

AddEventHandler('esx_clotheshop:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {}
end)

AddEventHandler('esx_clotheshop:hasExitedMarker', function(zone)
	
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil

	if not HasPayed then

		TriggerEvent('esx_skin:getLastSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)

	end

end)


-- Display markers
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
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
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_clotheshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_clotheshop:hasExitedMarker', LastZone)
		end

	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(10)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustReleased(0, Keys['E']) then

				if CurrentAction == 'shop_menu' then
					--OpenShopMenu()
					OpenFirstMenu()
				end

				CurrentAction = nil

			end

		else
			Citizen.Wait(500)
		end

	end
end)
