local chatInputActive = false
local chatInputActivating = false
local chatHidden = true
local chatLoaded = false
local template = 'default'

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

AddEventHandler('chat:display', function(status)
  SendNUIMessage({
      type = (status and 'show' or 'hide')
  })
end)


--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
	local args = { text }

	if author ~= "" then
		table.insert(args, 1, author)
	end

	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = {
			color = color,
			multiline = true,
			args = args
		}
	})

end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      templateId = 'print',
      multiline = true,
      args = { msg }
    }
  })
end)

AddEventHandler('chat:addMessage', function(message)
	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = {
			templateId = template,
			args = message.args
		}
	})
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    suggestion = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end)

AddEventHandler('chat:addSuggestions', function(suggestions)
  for _, suggestion in ipairs(suggestions) do
    SendNUIMessage({
      type = 'ON_SUGGESTION_ADD',
      suggestion = suggestion
    })
  end
end)

AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)

AddEventHandler('chat:addTemplate', function(id, html)
  SendNUIMessage({
    type = 'ON_TEMPLATE_ADD',
    template = {
      id = id,
      html = html
    }
  })
end)

AddEventHandler('chat:clear', function(name)
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

RegisterNUICallback('chatResult', function(data, cb)
  chatInputActive = false
  SetNuiFocus(false)
  TriggerServerEvent('chat:displaydots', false)
  Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
    if data.message ~= nil then
    end
  end)
  if not data.canceled then
    local id = PlayerId()
    
    --deprecated
    local r, g, b = 0, 0x99, 255
    if data.message:sub(1, 1) == '/' then
      ExecuteCommand(data.message:sub(2))
    else
      TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
    end
  end

  cb('ok')
end)

local function refreshCommands()
  if GetRegisteredCommands then
    local registeredCommands = GetRegisteredCommands()

    local suggestions = {}

    for _, command in ipairs(registeredCommands) do
        if IsAceAllowed(('command.%s'):format(command.name)) then
            table.insert(suggestions, {
                name = '/' .. command.name,
                help = ''
            })
        end
    end

    TriggerEvent('chat:addSuggestions', suggestions)
  end
end

local function refreshThemes()
  local themes = {}

  for resIdx = 0, GetNumResources() - 1 do
    local resource = GetResourceByFindIndex(resIdx)

    if GetResourceState(resource) == 'started' then
      local numThemes = GetNumResourceMetadata(resource, 'chat_theme')

      if numThemes > 0 then
        local themeName = GetResourceMetadata(resource, 'chat_theme')
        local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')

        if themeName and themeData then
          themeData.baseUrl = 'nui://' .. resource .. '/'
          themes[themeName] = themeData
        end
      end
    end
  end

  SendNUIMessage({
    type = 'ON_UPDATE_THEMES',
    themes = themes
  })
end

RegisterCommand('czat1', function(source, args, rawcommand)
  template = 'default'
end, false)

RegisterCommand('czat2', function(source, args, rawcommand)
  template = 'pixel'
end, false)

AddEventHandler('onClientResourceStart', function(resName)
  Wait(500)

  refreshCommands()
  refreshThemes()
end)

AddEventHandler('onClientResourceStop', function(resName)
  Wait(500)

  refreshCommands()
  refreshThemes()
end)

RegisterNUICallback('loaded', function(data, cb)
  TriggerServerEvent('chat:init');

  refreshCommands()
  refreshThemes()

  chatLoaded = true

  cb('ok')
end)

local text = '💬'
local playerdisplaying = {}

Citizen.CreateThread(function()
  while true do
    Wait(0)
    local sleep = true
    for k, v in pairs(playerdisplaying) do
      local mePlayer = GetPlayerFromServerId(k)
      if PlayerId() ~= mePlayer then
        local ped = GetPlayerPed(mePlayer)
        local coordsMe = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 0x796E))
        local coords = GetEntityCoords(PlayerPedId())
        if IsEntityVisible(ped) then
          local dist = Vdist2(GetEntityCoords(GetPlayerPed(PlayerId())), GetEntityCoords(ped))
          if dist ~= 0.0 then
            if dist <= 10.0 then
              sleep = false
              DrawText3D(coordsMe.x, coordsMe.y, coordsMe.z+0.4, text, { 255, 255, 255 }, 0.4, {0.003, 0.02, 325})
            end
          end
        end
      end
    end
    if sleep then
      Wait(500)
    end
  end
end)

RegisterNetEvent('chat:displaydotsC')
AddEventHandler('chat:displaydotsC', function(value, source)
  if value then
    playerdisplaying[source] = true
  else
    if playerdisplaying[source] then
      playerdisplaying[source] = nil
    end
  end
end)

function DrawText3D(x, y, z, text, color, size, rect)
	size = size or 0.4
	rect = rect or {0.005, 0.03, 250}

	SetTextScale(size, size)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(color[1], color[2], color[3], 215)
	SetTextCentre(1)

  SetTextEntry("STRING")
  AddTextComponentString(text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  DrawText(_x,_y)
end

Citizen.CreateThread(function()
	SetTextChatEnabled(false)
	SetNuiFocus(false)

	while true do
		Wait(0)

    if not chatInputActive then
			if IsControlPressed(0, 245) then
				chatInputActive = true
        chatInputActivating = true

				SendNUIMessage({
					type = 'ON_OPEN'
        })
        TriggerServerEvent('chat:displaydots', true)
			end
		end

		if chatInputActivating then
			if not IsControlPressed(0, 245) then
				SetNuiFocus(true)

				chatInputActivating = false
			end
		end

		if chatLoaded then
			local shouldBeHidden = false

				if IsScreenFadedOut() or IsPauseMenuActive() then
				shouldBeHidden = true
				end

			if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
				chatHidden = shouldBeHidden

				SendNUIMessage({
					type = 'ON_SCREEN_STATE_CHANGE',
					shouldHide = shouldBeHidden
				})
			end
		end
	end
end)
