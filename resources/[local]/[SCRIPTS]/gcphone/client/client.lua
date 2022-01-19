--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================
 
-- Configuration
local KeyToucheCloseEvent = {
  { code = 172, event = 'ArrowUp' },
  { code = 173, event = 'ArrowDown' },
  { code = 174, event = 'ArrowLeft' },
  { code = 175, event = 'ArrowRight' },
  { code = 176, event = 'Enter' },
  { code = 177, event = 'Backspace' },
}

local menuIsOpen = false
local contacts = {}
local messages = {}
local myPhoneNumber = ''
local isDead = false
local USE_RTC = false
local useMouse = false
local ignoreFocus = false
local takePhoto = false
local hasFocus = false
local PhoneInCall = {}
local currentPlaySound = false
local soundDistanceMax = 8.0
local firstSpawn = true

AddEventHandler('esx:onPlayerSpawn', function()
	if firstSpawn then
		firstSpawn = false
		CreateThread(function()
			TriggerServerEvent('arivi:activesim')
		end)		
	end
end)

function hasPhone (cb)
  if (ESX == nil) then 
		return cb(0) 
	end
	
  ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
	  cb(qtty > 0)
  end, 'phone')
end

function ShowNoPhoneWarning ()
  if (ESX == nil) then return end
	
	ESX.ShowNotification('~r~Nie posiadasz telefonu')
end


ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

AddEventHandler('esx:onPlayerDeath', function()
  if menuIsOpen then
    menuIsOpen = false
    TriggerEvent('gcPhone:setMenuStatus', false)
    SendNUIMessage({show = false})
    PhonePlayOut()
  end
end)

AddEventHandler('esx:playerLoaded', function()
  ESX.TriggerServerCallback("route68:getSim", function(result2)
    SimTab = result2
  end)
  TriggerServerEvent('gcPhone:allUpdate')
end)

RegisterNetEvent('route68:syncSim')
AddEventHandler('route68:syncSim', function()
    ESX.TriggerServerCallback("route68:getSim", function(result)
        SimTab = result
    end)
end)

RegisterNetEvent("route68:shownotif")
AddEventHandler("route68:shownotif", function(text, color)
	ESX.ShowNotification(text)
end)

RegisterNetEvent('kartasim')
AddEventHandler('kartasim', function()
	ESX.TriggerServerCallback("route68:getSim", function(result2)
		SimTab = result2
		OpenMenu()
	end)
end)

RegisterNetEvent('telefon')
AddEventHandler('telefon', function()
    ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
        if tonumber(myPhoneNumber) ~= nil then
			if qtty > 0 then
				TooglePhone()
			else
				ESX.ShowNotification('~r~Nie posiadasz telefonu')
			end
		else
			ESX.ShowNotification('~r~Nie posiadasz podlaczonej karty sim')
		end
    end, 'phone')
end)

RegisterNetEvent('kartasimsteel')
AddEventHandler('kartasimsteel', function(playerId)
local player, distance = ESX.Game.GetClosestPlayer()
local targetPed = Citizen.InvokeNative(0x43A66C31C68491C0, GetPlayerFromServerId(target))
	if distance ~= -1 and distance <= 3.0 then
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
		TriggerServerEvent('gcphone:zabierz', GetPlayerServerId(closestPlayer))
	else
		ESX.ShowNotification('W poblizu nie ma ~r~zadnego obywatela')
	end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if not menuIsOpen and isDead then
      DisableControlAction(0, 288, true)
    end
    if takePhoto ~= true then
      if IsControlJustPressed(1, Config.KeyOpenClose) then
        ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
          if tonumber(myPhoneNumber) ~= nil then
            if qtty > 0 then
              DeadCheck()
            else
              ESX.ShowNotification('~r~Nie posiadasz telefonu')
            end
          else
            ESX.ShowNotification('~r~Nie posiadasz podlaczonej karty sim')
          end
        end, 'phone')
      end
      if menuIsOpen == true then
        for _, value in ipairs(KeyToucheCloseEvent) do
          if IsControlJustPressed(1, value.code) then
            SendNUIMessage({keyUp = value.event})
          end
        end
        if useMouse == true and hasFocus == ignoreFocus then
          local nuiFocus = not hasFocus
          SetNuiFocus(nuiFocus, nuiFocus)
          hasFocus = nuiFocus
        elseif useMouse == false and hasFocus == true then
          SetNuiFocus(false, false)
          hasFocus = false
        end
      else
        if hasFocus == true then
          SetNuiFocus(false, false)
          hasFocus = false
        end
      end
    end
  end
end)

function DeadCheck() 
  if exports['esx_ambulancejob']:getDeathStatus() or exports['esx_policejob']:isHandcuffed() then 
    DisableControlAction(1, 288, true) -- Disable phone
    TriggerEvent('esx:showNotification', 'Nie możesz wyciągnąć telefonu.')
  else
    TooglePhone()
  end
end

function getMenuIsOpen()
  return menuIsOpen
end
--====================================================================================
--  Active ou Deactive une application (appName => config.json)
--====================================================================================
RegisterNetEvent('gcPhone:setEnableApp')
AddEventHandler('gcPhone:setEnableApp', function(appName, enable)
  SendNUIMessage({event = 'setEnableApp', appName = appName, enable = enable })
end)

--====================================================================================
--  Gestion des appels fixe
--====================================================================================
function startFixeCall (fixeNumber)
  local number = ''
  DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 10)
  while (UpdateOnscreenKeyboard() == 0) do
    DisableAllControlActions(0);
    Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
    number =  GetOnscreenKeyboardResult()
  end
  if number ~= '' then
    TriggerEvent('gcphone:autoCall', number, {
      useNumber = fixeNumber
    })
    PhonePlayCall(true)
  end
end

function TakeAppel (infoCall)
  TriggerEvent('gcphone:autoAcceptCall', infoCall)
end

Citizen.CreateThread(function ()
  local mod = 0
  while true do 
    local playerPed   = PlayerPedId()
    local coords      = GetEntityCoords(playerPed)
    local inRangeToActivePhone = false
    local inRangedist = 0
    for i, _ in pairs(PhoneInCall) do 
        local dist = GetDistanceBetweenCoords(
          PhoneInCall[i].coords.x, PhoneInCall[i].coords.y, PhoneInCall[i].coords.z,
          coords.x, coords.y, coords.z, 1)
        if (dist <= soundDistanceMax) then
          DrawMarker(1, PhoneInCall[i].coords.x, PhoneInCall[i].coords.y, PhoneInCall[i].coords.z,
              0,0,0, 0,0,0, 0.1,0.1,0.1, 0,255,0,255, 0,0,0,0,0,0,0)
          inRangeToActivePhone = true
          inRangedist = dist
          if (dist <= 1.5) then 
            SetTextComponentFormat("STRING")
            AddTextComponentString(_U('key_answer'))
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustPressed(1, Config.KeyTakeCall) then
              PhonePlayCall(true)
              TakeAppel(PhoneInCall[i])
              PhoneInCall = {}
              StopSoundJS('ring2.ogg')
            end
          end
          break
        end
    end
    if inRangeToActivePhone == true and currentPlaySound == false then
      PlaySoundJS('ring2.ogg', 0.2 + (inRangedist - soundDistanceMax) / -soundDistanceMax * 0.8 )
      currentPlaySound = true
    elseif inRangeToActivePhone == true then
      mod = mod + 1
      if (mod == 15) then
        mod = 0
        SetSoundVolumeJS('ring2.ogg', 0.2 + (inRangedist - soundDistanceMax) / -soundDistanceMax * 0.8 )
      end
    elseif inRangeToActivePhone == false and currentPlaySound == true then
      currentPlaySound = false
      StopSoundJS('ring2.ogg')
    end
    Citizen.Wait(0)
  end
end)

function PlaySoundJS (sound, volume)
  SendNUIMessage({ event = 'playSound', sound = sound, volume = volume })
end

function SetSoundVolumeJS (sound, volume)
  SendNUIMessage({ event = 'setSoundVolume', sound = sound, volume = volume})
end

function StopSoundJS (sound)
  SendNUIMessage({ event = 'stopSound', sound = sound})
end

RegisterNetEvent("gcPhone:forceOpenPhone")
AddEventHandler("gcPhone:forceOpenPhone", function(_myPhoneNumber)
  if menuIsOpen == false then
    TooglePhone()
  end
end)
 
--====================================================================================
--  Events
--====================================================================================
RegisterNetEvent("gcPhone:myPhoneNumber")
AddEventHandler("gcPhone:myPhoneNumber", function(_myPhoneNumber)
  myPhoneNumber = _myPhoneNumber
  SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})
end)

RegisterNetEvent("route68:UpdateNumber")
AddEventHandler("route68:UpdateNumber", function(_myPhoneNumber)
  myPhoneNumber = _myPhoneNumber
  TriggerServerEvent("gcPhone:allUpdate")
  SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})
end)

RegisterNetEvent("gcPhone:contactList")
AddEventHandler("gcPhone:contactList", function(_contacts)
  SendNUIMessage({event = 'updateContacts', contacts = _contacts})
  contacts = _contacts
end)

RegisterNetEvent("gcPhone:allMessage")
AddEventHandler("gcPhone:allMessage", function(allmessages)
  SendNUIMessage({event = 'updateMessages', messages = allmessages})
  messages = allmessages
end)

RegisterNetEvent("gcPhone:getBourse")
AddEventHandler("gcPhone:getBourse", function(bourse)
  SendNUIMessage({event = 'updateBourse', bourse = bourse})
end)

RegisterNetEvent("gcPhone:receiveMessage")
AddEventHandler("gcPhone:receiveMessage", function(message, sender, skin)
  SendNUIMessage({event = 'newMessage', message = message})
  table.insert(messages, message)
  
  if message.owner == 0 then
		ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
			if qtty > 0 then
				CreateThread(function()
					PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
					Citizen.Wait(300)
					PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
					Citizen.Wait(300)
					PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)

					local sourceKnown = nil
					
					for _, contact in pairs(contacts) do
						if contact.number == message.transmitter then
							sourceKnown = contact.display
							break
						end
					end

					local transmitter = 'Anonim'
					if message.transmitter ~= 'Anonim' then
						transmitter = tonumber(message.transmitter)
					end	

					local pic = 'CHAR_BLIMP'
					
					if not transmitter then
						return nil
					elseif sourceKnown then
						transmitter = message.transmitter
						
						if not skin then
							ESX.TriggerServerCallback('skinchanger:cache', function(cache)
								if cache then
									ESX.Game.Utils.RenderHeadshotCached(GetEntityCoords(PlayerPedId(), false), sender, cache, function(pic)
										TriggerEvent("FeedM:showAdvancedNotification", '#' .. message.transmitter, sourceKnown, message.message:len() > 35 and message.message:sub(1,35) .. '...' or message.message, pic, 5000)
									end)	
								end
							end, sender)	
						else
							if sender then
                ESX.Game.Utils.RenderHeadshotInternal(GetEntityCoords(PlayerPedId(), false), skin, function(handle, txd)
									TriggerEvent("FeedM:showAdvancedNotification", '#' .. message.transmitter, sourceKnown, message.message:len() > 35 and message.message:sub(1,35) .. '...' or message.message, txd, 5000, nil, function()
										UnregisterPedheadshot(handle)
									end)
								end)	
							else
								TriggerEvent("FeedM:showAdvancedNotification", '#' .. message.transmitter, sourceKnown, message.message:len() > 35 and message.message:sub(1,35) .. '...' or message.message, 'CHAR_HUMANDEFAULT', 5000)
							end
						end
					else
						TriggerEvent("FeedM:showAdvancedNotification", '#' .. message.transmitter, sourceKnown, message.message:len() > 35 and message.message:sub(1,35) .. '...' or message.message, 'CHAR_HUMANDEFAULT', 5000)
					end
				end)
			end
		end, 'phone')
	end
end)

--====================================================================================
--  Function client | Contacts
--====================================================================================
function addContact(display, num) 
    TriggerServerEvent('gcPhone:addContact', display, num)
end

function deleteContact(num) 
    TriggerServerEvent('gcPhone:deleteContact', num)
end
--====================================================================================
--  Function client | Messages
--====================================================================================
function sendMessage(num, message)
  TriggerServerEvent('gcPhone:sendMessage', num, message)
end

function deleteMessage(msgId)
  TriggerServerEvent('gcPhone:deleteMessage', msgId)
  for k, v in ipairs(messages) do 
    if v.id == msgId then
      table.remove(messages, k)
      SendNUIMessage({event = 'updateMessages', messages = messages})
      return
    end
  end
end

function deleteMessageContact(num)
  TriggerServerEvent('gcPhone:deleteMessageNumber', num)
end

function deleteAllMessage()
  TriggerServerEvent('gcPhone:deleteAllMessage')
end

function setReadMessageNumber(num)
  TriggerServerEvent('gcPhone:setReadMessageNumber', num)
  for k, v in ipairs(messages) do 
    if v.transmitter == num then
      v.isRead = 1
    end
  end
end

function requestAllMessages()
  TriggerServerEvent('gcPhone:requestAllMessages')
end

function requestAllContact()
  TriggerServerEvent('gcPhone:requestAllContact')
end



--====================================================================================
--  Function client | Appels
--====================================================================================
local aminCall = false
local inCall = false

RegisterNetEvent("gcPhone:waitingCall")
AddEventHandler("gcPhone:waitingCall", function(infoCall, initiator)
  if initiator then
		SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
		PhonePlayCall()
	elseif initiator == nil then
		menuIsOpen = false
		SendNUIMessage({show = false})
		PhonePlayOut()
	else
		ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
			if qtty > 0 then
				SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
			end
		end, 'phone')
	end
end)

RegisterNetEvent("gcPhone:acceptCall")
AddEventHandler("gcPhone:acceptCall", function(infoCall, initiator)
  if inCall == false and USE_RTC == false then
    inCall = true
    if Config.Mumble then
      exports["mumble-voip"]:SetCallChannel(infoCall.id+1)
    else
      NetworkSetVoiceChannel(infoCall.id + 1)
      NetworkSetTalkerProximity(0.0)
    end
  end
  if menuIsOpen == false then 
    TooglePhone()
  end
  PhonePlayCall()
  SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
end)

RegisterNetEvent("gcPhone:rejectCall")
AddEventHandler("gcPhone:rejectCall", function(infoCall)
  if inCall == true then
    inCall = false
    if Config.Mumble then
      exports["mumble-voip"]:SetCallChannel(0)
    else
      Citizen.InvokeNative(0xE036A705F989E049)
      NetworkSetTalkerProximity(2.5)
    end
  end
  PhonePlayText()
  SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
end)


RegisterNetEvent("gcPhone:historiqueCall")
AddEventHandler("gcPhone:historiqueCall", function(historique)
  SendNUIMessage({event = 'historiqueCall', historique = historique})
end)


function startCall (phone_number, rtcOffer, extraData)
  if rtcOffer == nil then
    rtcOffer = ''
  end
  TriggerServerEvent('gcPhone:startCall', phone_number, rtcOffer, extraData)
end

function acceptCall (infoCall, rtcAnswer)
  TriggerServerEvent('gcPhone:acceptCall', infoCall, rtcAnswer)
end

function rejectCall(infoCall)
  TriggerServerEvent('gcPhone:rejectCall', infoCall)
end

function ignoreCall(infoCall)
  TriggerServerEvent('gcPhone:ignoreCall', infoCall)
end

function requestHistoriqueCall() 
  TriggerServerEvent('gcPhone:getHistoriqueCall')
end

function appelsDeleteHistorique (num)
  TriggerServerEvent('gcPhone:appelsDeleteHistorique', num)
end

function appelsDeleteAllHistorique ()
  TriggerServerEvent('gcPhone:appelsDeleteAllHistorique')
end
  

--====================================================================================
--  Event NUI - Appels
--====================================================================================

RegisterNUICallback('startCall', function (data, cb)
  startCall(data.numero, data.rtcOffer, data.extraData)
  cb()
end)

RegisterNUICallback('acceptCall', function (data, cb)
  acceptCall(data.infoCall, data.rtcAnswer)
  cb()
end)
RegisterNUICallback('rejectCall', function (data, cb)
  rejectCall(data.infoCall)
  cb()
end)

RegisterNUICallback('ignoreCall', function (data, cb)
  ignoreCall(data.infoCall)
  cb()
end)

RegisterNUICallback('notififyUseRTC', function (use, cb)
  USE_RTC = use
  if USE_RTC == true and inCall == true then
    inCall = false
    Citizen.InvokeNative(0xE036A705F989E049)
      NetworkSetTalkerProximity(2.5)
  end
  cb()
end)


RegisterNUICallback('onCandidates', function (data, cb)
  TriggerServerEvent('gcPhone:candidates', data.id, data.candidates)
  cb()
end)

RegisterNetEvent("gcPhone:candidates")
AddEventHandler("gcPhone:candidates", function(candidates)
  SendNUIMessage({event = 'candidatesAvailable', candidates = candidates})
end)



RegisterNetEvent('gcphone:autoCall')
AddEventHandler('gcphone:autoCall', function(number, extraData)
  if number ~= nil then
    SendNUIMessage({ event = "autoStartCall", number = number, extraData = extraData})
  end
end)

RegisterNetEvent('gcphone:autoCallNumber')
AddEventHandler('gcphone:autoCallNumber', function(data)
  TriggerEvent('gcphone:autoCall', data.number)
end)

RegisterNetEvent('gcphone:autoAcceptCall')
AddEventHandler('gcphone:autoAcceptCall', function(infoCall)
  SendNUIMessage({ event = "autoAcceptCall", infoCall = infoCall})
end)

--====================================================================================
--  Gestion des evenements NUI
--==================================================================================== 
RegisterNUICallback('log', function(data, cb)
  cb()
end)
RegisterNUICallback('focus', function(data, cb)
  cb()
end)
RegisterNUICallback('blur', function(data, cb)
  cb()
end)
RegisterNUICallback('reponseText', function(data, cb)

    local params = {

        limit = data.limit or 1000,

        value = data.text or '',

        type = 'text'

    }

    if data.evt == 'message' then

        params.title = 'Wpisz wiadomość:'

        params.type = 'textarea'

    elseif data.evt == 'darkchat' then

        params.title = 'Wpisz nazwę kanału:'

    elseif data.evt == 'contact' then

        params.title = 'Wpisz nazwę kontaktu:'

    elseif data.evt == 'number' then

        params.title = 'Wpisz numer:'

    end



    TriggerEvent('async:keyboard', function(value)

        if data.evt == 'darkchat' then

            local channel = value or ''

            if channel ~= '' then

                TriggerEvent('async:keyboard', function(value)

                    if value then

                        ESX.TriggerServerCallback('gcPhone:tchat_join', function(status)

                            if status then

                                cb(json.encode({text = channel}))

                            else

                                ESX.ShowNotification('~r~Niepoprawne hasło kanału')

                            end

                        end, channel, value or '')

                    end

                end, {

                    title = 'Wpisz hasło (może być puste):',

                    type = 'password',

                    limit = 32

                })

            else

                ESX.ShowNotification('~y~Musisz wpisać nazwę kanału')

            end

        else

            cb(json.encode({text = value or ''}))

        end

    end, params)

end)
--====================================================================================
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
  cb(json.encode(messages))
end)
RegisterNUICallback('sendMessage', function(data, cb)
  if data.message == '%pos%' then
    local myPos = GetEntityCoords(PlayerPedId())
    data.message = 'GPS: ' .. string.format("%.2f", myPos.x) .. ', ' .. string.format("%.2f", myPos.y)
  end
  TriggerServerEvent('gcPhone:sendMessage', data.phoneNumber, data.message)
end)
RegisterNUICallback('deleteMessage', function(data, cb)
  deleteMessage(data.id)
  cb()
end)
RegisterNUICallback('deleteMessageNumber', function (data, cb)
  deleteMessageContact(data.number)
  cb()
end)
RegisterNUICallback('deleteAllMessage', function (data, cb)
  deleteAllMessage()
  cb()
end)
RegisterNUICallback('setReadMessageNumber', function (data, cb)
  setReadMessageNumber(data.number)
  cb()
end)
--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb) 
  if data.display == nil then
    ESX.ShowNotification("~r~Musisz nazwać kontakt!")
  elseif data.phoneNumber == nil then
    ESX.ShowNotification("~r~Wpisz numer zanim zapiszesz kontakt!")
  elseif not tonumber(data.phoneNumber) then
    ESX.ShowNotification("~r~Numer musi być liczbą!")
  else
    TriggerServerEvent('gcPhone:addContact', data.display, data.phoneNumber)
  end
end)

RegisterNUICallback('updateContact', function(data, cb)
  TriggerServerEvent('gcPhone:updateContact', data.id, data.display, data.phoneNumber)
end)
RegisterNUICallback('deleteContact', function(data, cb)
  TriggerServerEvent('gcPhone:deleteContact', data.id)
end)
RegisterNUICallback('getContacts', function(data, cb)
  cb(json.encode(contacts))
end)
RegisterNUICallback('setGPS', function(data, cb)
  SetNewWaypoint(tonumber(data.x), tonumber(data.y))
  cb()
end)

-- Add security for event (leuit#0100)
RegisterNUICallback('callEvent', function(data, cb)
  local eventName = data.eventName or ''
    if data.data ~= nil then 
      TriggerEvent(data.eventName, data.data)
    else
      TriggerEvent(data.eventName)
    end
  cb()
end)
RegisterNUICallback('useMouse', function(um, cb)
  useMouse = um
end)
RegisterNUICallback('deleteALL', function(data, cb)
  TriggerServerEvent('gcPhone:deleteALL')
  cb()
end)

function openphonedziwko()
		ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
			if tonumber(myPhoneNumber) ~= nil then
				if qtty > 0 then
					TooglePhone()
					TriggerServerEvent("gcPhone:allUpdate")
				else
					ESX.ShowNotification('~r~Nie posiadasz telefonu')
				end
			else
				ESX.ShowNotification('~r~Nie posiadasz podlaczonej karty sim')
			end
		end, 'phone')
end

function TooglePhone() 
  menuIsOpen = not menuIsOpen
  SendNUIMessage({show = menuIsOpen})
  if menuIsOpen == true then 
    PhonePlayIn()
    TriggerEvent('gcPhone:setMenuStatus', true)
  else
    PhonePlayOut()
    TriggerEvent('gcPhone:setMenuStatus', false)
  end
end
RegisterNUICallback('faketakePhoto', function(data, cb)
  menuIsOpen = false
  TriggerEvent('gcPhone:setMenuStatus', false)
  SendNUIMessage({show = false})
  cb()
  TriggerEvent('camera:open')
end)

RegisterNUICallback('closePhone', function(data, cb)
  menuIsOpen = false
  TriggerEvent('gcPhone:setMenuStatus', false)
  SendNUIMessage({show = false})
  PhonePlayOut()
  cb()
end)




----------------------------------
---------- GESTION APPEL ---------
----------------------------------
RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
  appelsDeleteHistorique(data.numero)
  cb()
end)
RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
  appelsDeleteAllHistorique(data.infoCall)
  cb()
end)


----------------------------------
---------- GESTION VIA WEBRTC ----
----------------------------------
AddEventHandler('onClientResourceStart', function(res)
  DoScreenFadeIn(300)
  if res == "gcphone" then
    TriggerServerEvent('gcPhone:allUpdate')
    -- Try again in 2 minutes (Recovers bugged phone numbers)
    Citizen.Wait(120000)
    TriggerServerEvent('gcPhone:allUpdate')
  end
end)


RegisterNUICallback('setIgnoreFocus', function (data, cb)
  ignoreFocus = data.ignoreFocus
  cb()
end)

RegisterNUICallback('takePhoto', function(data, cb)
  CreateMobilePhone(1)
  CellCamActivate(true, true)
  takePhoto = true
  ESX.UI.HUD.SetDisplay(0.0)
	TriggerEvent('es:setMoneyDisplay', 0.0)
	TriggerEvent('esx_status:setDisplay', 0.0)
	TriggerEvent('esx_voice:setDisplay', 0.0)
	TriggerEvent('radar:setHidden', true)
	TriggerEvent('chat:display', false)
	TriggerEvent('carhud:display', false)
  Citizen.Wait(0)
  if hasFocus == true then
    SetNuiFocus(false, false)
    hasFocus = false
  end
  while takePhoto do
    Citizen.Wait(0)

    if IsControlJustPressed(1, 27) then -- Toogle Mode
      frontCam = not frontCam
      CellFrontCamActivate(frontCam)
    elseif IsControlJustPressed(1, 177) then -- CANCEL
      DestroyMobilePhone()
      CellCamActivate(false, false)
      cb(json.encode({ url = nil }))
      takePhoto = false
      ESX.UI.HUD.SetDisplay(1.0)
			TriggerEvent('es:setMoneyDisplay', 1.0)
			TriggerEvent('esx_status:setDisplay', 1.0)
			TriggerEvent('esx_voice:setDisplay', 1.0)
			TriggerEvent('radar:setHidden', false)
			TriggerEvent('chat:display', true)
			TriggerEvent('carhud:display', true)
      break
    elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
      exports['screenshot-basic']:requestScreenshotUpload(data.url, data.field, function(data)
        local resp = json.decode(data)
        DestroyMobilePhone()
        CellCamActivate(false, false)
        cb(json.encode({ url = resp.url }))
        ESX.UI.HUD.SetDisplay(1.0)
        TriggerEvent('es:setMoneyDisplay', 1.0)
        TriggerEvent('esx_status:setDisplay', 1.0)
        TriggerEvent('esx_voice:setDisplay', 1.0)
        TriggerEvent('radar:setHidden', false)
        TriggerEvent('chat:display', true)
        TriggerEvent('carhud:display', true)
      end)
      takePhoto = false
    end
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(19)
    HideHudAndRadarThisFrame()
  end
  Citizen.Wait(1000)
  PhonePlayAnim('text', false, true)
end)

function openPhone()
	if menuIsOpen == false then
		ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
			if tonumber(myPhoneNumber) ~= nil then
				if qtty > 0 then
					TooglePhone()
					TriggerServerEvent("gcPhone:allUpdate")
				else
					ESX.ShowNotification('~r~Nie posiadasz telefonu')
				end
			else
				ESX.ShowNotification('~r~Nie posiadasz podlaczonej karty sim')
			end
		end, 'phone')
	end
end

function ShowAdvancedNotification(title, subject, msg, icon, iconType)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    SetNotificationMessage(icon, icon, false, iconType, title, subject)
    DrawNotification(false, false)
end


RegisterNetEvent('gcphone:komunikat')
AddEventHandler('gcphone:komunikat', function(tresc)
  ESX.ShowNotification(tresc, 5000)
end)