ESX                           = nil
local GUI                     = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local PlayerData              = {}
local CurrentAction           = nil
local IsInShopMenu            = false
GUI.Time                      = 0

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

local blips = {
     {title="Schowek", colour=2, id=55878, x = 285.0463, y = -1004.6004, z = 29.3406},
  }

local DrawDistance = 100.0
local MarkerSize = {x = 2.0, y = 2.0, z = 2.0}
local MarkerColor  = {r = 0, g = 255, b = 0}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    PlayerData = ESX.GetPlayerData()
end)

local cache = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		for _, data in ipairs(cache) do
      local playerPed = GetPlayerPed(-1)
      local pCoords = GetEntityCoords(playerPed)
			if(GetDistanceBetweenCoords(pCoords, data.coords.x, data.coords.y, data.coords.z, true) < DrawDistance) then
				DrawMarker(data.marker, data.coords.x, data.coords.y, data.coords.z, 0.0, 0.0, 0.0, data.offset.x, data.offset.y, data.offset.z, data.size.x, data.size.y, data.size.z, data.color.r, data.color.g, data.color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
  while true do
	  Citizen.Wait(600)
	  cache = {}
    local isInMarker  = false
    local currentZone = nil
	  local playerPed = GetPlayerPed(-1)
    local pCoords = GetEntityCoords(playerPed)
    for i=1, #Config.Vault, 1 do
      if(GetDistanceBetweenCoords(pCoords, Config.Vault[i].Marker, true) < DrawDistance) then
        if Config.Vault[i].Hex[1] ~= nil then
					for j=1, #Config.Vault[i].Hex, 1 do
						if hex == Config.Vault[i].Hex[j] then
              table.insert(cache, {
                marker = 1,
                coords  = Config.Vault[i].Marker,
                offset = {x = 0.0, y = 0.0, z = 0.0},
                size = {x = 2.0, y = 2.0, z = 0.5},
                color = {r = 17, g = 255, b = 0}
              })
              if(GetDistanceBetweenCoords(pCoords, Config.Vault[i].Marker, true) < MarkerSize.x) then
                  isInMarker = true
                  currentZone = 'schowek_open'
              end
            end
					end
        else
          table.insert(cache, {
            marker = 1,
            coords  = Config.Vault[i].Marker,
            offset = {x = 0.0, y = 0.0, z = 0.0},
            size = {x = 2.0, y = 2.0, z = 0.5},
            color = {r = 0, g = 255, b = 0}
          })
          if(GetDistanceBetweenCoords(pCoords, Config.Vault[i].Marker, true) < MarkerSize.x) then
              isInMarker = true
              currentZone = 'schowek_open'
          end
        end
      end
    end

    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
        HasAlreadyEnteredMarker = true
        LastZone = currentZone
      TriggerEvent('woro_schowek:hasEnteredMarker', currentZone)
      end
      if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('woro_schowek:hasExitedMarker', LastZone)
     end
  end
end)

function DisplayHelpText(str)
  SetTextComponentFormat('STRING')
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

AddEventHandler('woro_schowek:hasEnteredMarker', function (zone)
	if zone == 'schowek_open' then
		CurrentAction = 'schowekmenu'
	end
end)

AddEventHandler('woro_schowek:hasExitedMarker', function (zone)
  if IsInShopMenu then
    IsInShopMenu = false
  end
  if not IsInShopMenu then
	ESX.UI.Menu.CloseAll()
  end
  CurrentAction = nil
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(5)
		if CurrentAction ~= nil then
      if CurrentAction ~= nil then
        if CurrentAction == 'schowekmenu' then
          DisplayHelpText('Naciśnij ~INPUT_CONTEXT~, aby otworzyć schowek')
        end
        if IsControlJustReleased(0, 38) and (GetGameTimer() - GUI.Time) > 120 then

          ESX.TriggerServerCallback('schowek:makupione', function(posiadane)


            local testy = "chuj"


            if posiadane.schowek == testy then
                OpenDepositInventoryMenu()
            else

              ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'person_menu',
                {
                    title    = 'Woro Schowki',
                    elements = {
                        {label = 'Kup schowek', value = 'Kup schowek'},
                    }
                },
                function(data, menu)
                  TriggerServerEvent('schowek:kup')
                  Citizen.Wait(100)
                  menu.close()
                  Citizen.Wait(100)
                  if CurrentAction == 'schowekmenu' then
                    OpenDepositInventoryMenu()
                  end
                end,
                function(data, menu)
                    menu.close()
                end
              )

            end
              
        end)
          
    

        end
      end
    end
  end
end)

OpenDepositInventoryMenu = function(owner)
    local elements = {}
    table.insert(elements, {label = 'Wyjmij przedmioty',  value = 'room_inventory'})
    table.insert(elements, {label = 'Włóż przedmioty', value = 'player_inventory'})

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room', {
    title    = 'Schowek - Przedmioty',
    align    = 'center',
    elements = elements
    }, function(data, menu)
        menu.close()
    if data.current.value == 'room_inventory' then
      OpenRoomInventoryMenu()
    elseif data.current.value == 'player_inventory' then
      OpenPlayerInventoryMenu()
        end
    end, function(data, menu)
    menu.close()
  end)
end

function OpenRoomInventoryMenu()
	ESX.TriggerServerCallback('schowek:getPropertyInventory', function(inventory)
		local elements = {}

		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = '<font color=red>Nieopodatkowane pieniądze:</font> '..inventory.blackMoney..'$',
				type = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_inventory', {
			title    = 'Wyciąganie przedmiotu',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.type == 'item_weapon' then
				menu.close()
        chowanieanim()
				TriggerServerEvent('schowek:getItem', data.current.type, data.current.value, data.current.index)
				ESX.SetTimeout(300, function()
					OpenRoomInventoryMenu()
				end)
			else
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_item_count', {
					title = 'Ilość'
				}, function(data2, menu)

					local quantity = tonumber(data2.value)
					if quantity == nil then
						ESX.ShowNotification('Niepoprawna ilość.')
					else
						menu.close()
            chowanieanim()
						TriggerServerEvent('schowek:getItem', data.current.type, data.current.value, quantity)
						ESX.SetTimeout(300, function()
							OpenRoomInventoryMenu()
						end)
					end
				end, function(data2,menu)
					menu.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, owner)
end

function OpenPlayerInventoryMenu()
	ESX.TriggerServerCallback('schowek:getPlayerInventory', function(inventory)
		local elements = {}

        if inventory.blackMoney > 0 then
        table.insert(elements, {
        label = '<font color=red>Nieopodatkowane pieniądze:</font> '..inventory.blackMoney..'$',
        type = 'item_account',
        value = 'black_money'
      })
    end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_inventory', {
			title    = 'Deponowanie przedmiotu',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.type == 'item_weapon' then
				menu.close()
				TriggerServerEvent('schowek:putItem', owner, data.current.type, data.current.value, data.current.ammo)
        chowanieanim()
				ESX.SetTimeout(300, function()
					OpenPlayerInventoryMenu()
				end)
			else
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_count', {
					title = 'Ilość'
				}, function(data2, menu2)
					local quantity = tonumber(data2.value)
					if quantity == nil then
						ESX.ShowNotification('Niepoprawna ilość.')
					else
						menu2.close()
           chowanieanim()
						TriggerServerEvent('schowek:putItem', data.current.type, data.current.value, tonumber(data2.value))
						ESX.SetTimeout(300, function()
							OpenPlayerInventoryMenu()
						end)
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


Citizen.CreateThread(function()
    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 1.0)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	    BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
      Citizen.Wait(25)
    end
end)

function chowanieanim()
	RequestAnimDict("mp_common")
	while (not HasAnimDictLoaded("mp_common")) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, 3.0, 2000, 48, 1, false, false, false)
end