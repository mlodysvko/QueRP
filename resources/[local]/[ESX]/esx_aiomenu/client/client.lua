AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if window then
			SetNuiFocus(false, false)
		end
	end
end)

local lastGameTimerId = 0
local lastGameTimerPhone = 0
local lastGameTimerpsychol = 0
local lastGameTimerdoj = 0
local PlayerData = {}
local isDead = false
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
  end
  
  while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
	if window then
		reopenWindow()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)


RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
  PlayerData.hiddenjob = hiddenjob
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 10) and not IsPedInFlyingVehicle(PlayerPedId()) and not exports['esx_ambulancejob']:getDeathStatus() and not exports['esx_policejob']:isHandcuffed() then
			window = true
			openGeneral()
		end
        
		if window and IsControlJustPressed(1, 322) then
			window = false
			SendNUIMessage({type = 'close'})
		end
	end
end)

RegisterNUICallback('NUIFocusOff', function(data, cb)
	window = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
	cb('ok')
end)

RegisterCommand('menu', function(...)
	if not window then
		window = true
		openGeneral()
	else
		openGeneral(true)
	end
end)

function reopenWindow()
	if window then
		openGeneral(true)
	end
end

function openGeneral(reopen)
	reopen = reopen or false
	if not reopen then
		SetNuiFocus(true, true)
	end
	SendNUIMessage({type = 'openGeneral', job = (PlayerData.job and PlayerData.job.label .. ' - ' .. PlayerData.job.grade_label or '-')})
	SendNUIMessage({type = 'openGeneral', hiddenjob = (PlayerData.hiddenjob and PlayerData.hiddenjob.label .. ' - ' .. PlayerData.hiddenjob.grade_label or '-')})
	if not isDead then
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			SendNUIMessage({type = 'showVehicleButton'})
		else
			SendNUIMessage({type = 'hideVehicleButton'})
		end

		SendNUIMessage({type = 'showLockButton'})
		SendNUIMessage({type = 'showEsxButton'})
		if PlayerData.job and PlayerData.job.name == 'police' then
			SendNUIMessage({type = 'showPoliceButton'})
			SendNUIMessage({type = 'hideAmbulanceButton'})
			SendNUIMessage({type = 'hideMechanicButton'})
      SendNUIMessage({type = 'hidePsychologButton'})
      SendNUIMessage({type = 'hideDojButton'})

		elseif PlayerData.job and PlayerData.job.name == 'ambulance' then
			SendNUIMessage({type = 'showAmbulanceButton'})
			SendNUIMessage({type = 'hidePoliceButton'})
			SendNUIMessage({type = 'hideMechanicButton'})
      SendNUIMessage({type = 'hidePsychologButton'})
      SendNUIMessage({type = 'hideDojButton'})

    elseif PlayerData.job and PlayerData.job.name == 'psycholog' then
      SendNUIMessage({type = 'hidePoliceButton'})
			SendNUIMessage({type = 'hideAmbulanceButton'})
			SendNUIMessage({type = 'hideMechanicButton'})
      SendNUIMessage({type = 'showPsychologButton'})
      SendNUIMessage({type = 'hideDojButton'})

    elseif PlayerData.job and PlayerData.job.name == 'doj' then
      SendNUIMessage({type = 'hidePoliceButton'})
			SendNUIMessage({type = 'hideAmbulanceButton'})
			SendNUIMessage({type = 'hideMechanicButton'})
      SendNUIMessage({type = 'hidePsychologButton'})
      SendNUIMessage({type = 'dojodznaka'})
		elseif PlayerData.job and PlayerData.job.name == 'mecano' then
			SendNUIMessage({type = 'showMechanicButton'})
			SendNUIMessage({type = 'hidePoliceButton'})
			SendNUIMessage({type = 'hideAmbulanceButton'})
      SendNUIMessage({type = 'hidePsychologButton'})
      SendNUIMessage({type = 'hideDojButton'})
		else
			SendNUIMessage({type = 'hidePoliceButton'})
			SendNUIMessage({type = 'hideAmbulanceButton'})
			SendNUIMessage({type = 'hideMechanicButton'})
      SendNUIMessage({type = 'hidePsychologButton'})
      SendNUIMessage({type = 'hideDojButton'})

		end
	else
		SendNUIMessage({type = 'hidePoliceButton'})
		SendNUIMessage({type = 'hideAmbulanceButton'})
		SendNUIMessage({type = 'hideMechanicButton'})
    SendNUIMessage({type = 'hidePsychologButton'})
    SendNUIMessage({type = 'hideDojButton'})


		SendNUIMessage({type = 'hideVehicleButton'})
		SendNUIMessage({type = 'hideLockButton'})
		SendNUIMessage({type = 'hideEsxButton'})
	end
end

--===============================================
--== Show ID                                   ==
--===============================================
RegisterCommand('dowod', function(...)
  if GetGameTimer() > lastGameTimerId then
    TriggerServerEvent('dowod')
		lastGameTimerId = GetGameTimer() + 10000
	else
		TriggerEvent("chatMessage", "^1[QueRP]> ", {255, 255, 0}, "Nie możesz tak często wyciągać dowodu!")
	end
end)

RegisterNUICallback('toggleid', function(data)
  if GetGameTimer() > lastGameTimerId then
    TriggerServerEvent('dowod')
		lastGameTimerId = GetGameTimer() + 10000
	else
		TriggerEvent("chatMessage", "^1[QueRP]> ", {255, 255, 0}, "Nie możesz tak często wyciągać dowodu!")
	end
end)

RegisterNUICallback('psychologodznaka', function(...)
  if PlayerData.job.name == 'psycholog' then
    if GetGameTimer() > lastGameTimerpsychol then
      TriggerServerEvent('psychologodznaka')
      SetNuiFocus(false,false)
      lastGameTimerpsychol = GetGameTimer() + 10000
    else
      TriggerEvent("chatMessage", "^1[QueRP]> ", {255, 255, 0}, "Nie możesz tak często wyciągać legitymacji!")
      SetNuiFocus(false,false)
    end
  end
end)

RegisterNUICallback('dojodznaka', function(...)
  if PlayerData.job.name == 'doj' then
    if GetGameTimer() > lastGameTimerdoj then
      TriggerServerEvent('dojodznaka')
      SetNuiFocus(false,false)
      lastGameTimerdoj = GetGameTimer() + 10000
    else
      TriggerEvent("chatMessage", "^1[QueRP]> ", {255, 255, 0}, "Nie możesz tak często wyciągać legitymacji!")
      SetNuiFocus(false,false)
    end
  end
end)

RegisterNUICallback('togglenumer', function(data)
    TriggerServerEvent('accounttest')
end)


--===============================================
--== Show Phone Number                         ==
--===============================================
RegisterCommand('wizytowka', function(...)
  if GetGameTimer() > lastGameTimerPhone then
	  TriggerServerEvent('wizytowka')
		lastGameTimerPhone = GetGameTimer() + 10000
	else
		TriggerEvent("chatMessage", "^1[QueRP]> ", {255, 255, 0}, "Nie możesz tak często wyciągać wizytówki!")
  end
end)

RegisterNUICallback('togglephone', function(data)
  if GetGameTimer() > lastGameTimerPhone then
	  TriggerServerEvent('wizytowka')
		lastGameTimerPhone = GetGameTimer() + 10000
	else
		TriggerEvent("chatMessage", "^1[QueRP]> ", {255, 255, 0}, "Nie możesz tak często wyciągać wizytówki!")
  end
end)

--===============================================
--== Engine On/Off                             ==
--===============================================
RegisterNUICallback('toggleEngineOnOff', function()
  TriggerEvent('EngineToggle:Engine')
end)

--===============================================
--== Toggle Door Locks                         ==
--===============================================
RegisterNUICallback('toggleVehicleLocks', function()
  TriggerEvent('IslandRP:Lock')
end)

--===============================================
--== Show ID                                   ==
--===============================================
RegisterNUICallback('showCharacters', function(data)
	TriggerServerEvent('menu:characters', data)
	cb(data)
end)

--================================================================================================
--==                                  ESX Actions GUI                                           ==
--================================================================================================
RegisterNUICallback('NUIESXActions', function(data)
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openESX'})
  SendNUIMessage({type = 'showInventoryButton'})
  SendNUIMessage({type = 'showPhoneButton'})
  SendNUIMessage({type = 'showBillingButton'})
  SendNUIMessage({type = 'showAnimationsButton'})
  
end)

--===============================================
--== NUIopenInventory                          ==
--===============================================
RegisterNUICallback('NUIopenInventory', function()
	TriggerEvent('es_extended:showINV')
end)

--===============================================
--== NUIopenPhone                              ==
--===============================================
RegisterNUICallback('NUIopenPhone', function()
	exports['gcphone']:openphonedziwko()
end)

--===============================================
--== NUIopenAnimations                         ==
--===============================================
RegisterNUICallback('NUIopenAnimations', function()
	exports['esx_animations']:OpenAnimationsMenu()
end)

--================================================================================================
--==                                  Job Actions GUI                                           ==
--================================================================================================
RegisterNUICallback('NUIJobActions', function(data)
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openJobs'})
  local job = tostring(exports['esx_policejob']:getJob())
  if job == 'police' then
      SendNUIMessage({type = 'showPoliceOdznaka'})
      SendNUIMessage({type = 'showPoliceButton'})
      SendNUIMessage({type = 'hideAmbulanceButton'})
      SendNUIMessage({type = 'hideTaxiButton'})
      SendNUIMessage({type = 'hideMechanicButton'})
	  SendNUIMessage({type = 'hideFireButton'})
  elseif job == 'ambulance' then
      SendNUIMessage({type = 'showAmbulanceButton'})
      SendNUIMessage({type = 'hidePoliceButton'})
      SendNUIMessage({type = 'hideTaxiButton'})
      SendNUIMessage({type = 'hideMechanicButton'})
	  SendNUIMessage({type = 'hideFireButton'})
  elseif job == 'taxi' then
      SendNUIMessage({type = 'showTaxiButton'})
      SendNUIMessage({type = 'hidePoliceButton'})
      SendNUIMessage({type = 'hideAmbulanceButton'})
      SendNUIMessage({type = 'hideMechanicButton'})
	  SendNUIMessage({type = 'hideFireButton'})
  elseif job == 'mecano' then
      SendNUIMessage({type = 'showMechanicButton'})
      SendNUIMessage({type = 'hidePoliceButton'})
      SendNUIMessage({type = 'hideAmbulanceButton'})
      SendNUIMessage({type = 'hideTaxiButton'})
	  SendNUIMessage({type = 'hideFireButton'})
  elseif job == 'fire' then
	  SendNUIMessage({type = 'showFireButton'})  
      SendNUIMessage({type = 'hideMechanicButton'})
      SendNUIMessage({type = 'hidePoliceButton'})
      SendNUIMessage({type = 'hideAmbulanceButton'})
      SendNUIMessage({type = 'hideTaxiButton'})
  else
    SendNUIMessage({type = 'hidePoliceButton'})
    SendNUIMessage({type = 'hideAmbulanceButton'})
    SendNUIMessage({type = 'hideTaxiButton'})
    SendNUIMessage({type = 'hideMechanicButton'})
	SendNUIMessage({type = 'hideFireButton'})
  end
end)

--===============================================
--== NUIopenAmbulanceActions                   ==
--===============================================
RegisterNUICallback('NUIopenAmbulance', function()
  if PlayerData.job.name == 'ambulance' then
  	exports['esx_ambulancejob']:OpenMobileAmbulanceActionsMenu()
  else
    TriggerServerEvent('IslandRP:BanAio')
  end
end)
RegisterNUICallback('NUIopenAmbulanceOdznaka', function()
  if PlayerData.job.name == 'ambulance' then
    TriggerServerEvent('emsodznaka')
  else
    TriggerServerEvent('IslandRP:BanAio')
  end
  SetNuiFocus(false,false)
end)

--===============================================
--== NUIopenPoliceActions                      ==
--===============================================
RegisterNUICallback('NUIopenPolice', function()
  if PlayerData.job.name == 'police' then
	  exports['esx_policejob']:OpenPoliceActionsMenu()
  else
    TriggerServerEvent('IslandRP:BanAio')
  end
end)

RegisterNUICallback('NUIopenPoliceOdznaka', function()
  if PlayerData.job.name == 'police' then
    TriggerServerEvent('odznaka')
  else
    TriggerServerEvent('IslandRP:BanAio')
  end
  SetNuiFocus(false,false)
end)

--===============================================
--== NUIopenMechanicActions                    ==
--===============================================
RegisterNUICallback('NUIopenMechanic', function()
  if PlayerData.job.name == 'mecano' then
  	exports['esx_mecanojob']:OpenMobileMecanoActionsMenu()
  else
    TriggerServerEvent('IslandRP:BanAio')
  end
end)

RegisterNUICallback('NUIopenMecanoOdznaka', function()
  TriggerServerEvent('lscodznaka')
  SetNuiFocus(false,false)
end)

--===============================================
--== NUIopenMechanicActions                    ==
--===============================================
RegisterNUICallback('NUIopenTaxi', function()
  if PlayerData.job.name == 'taxi' then
	exports['esx_taxijob']:OpenMobileTaxiActionsMenu()
  else
    TriggerServerEvent('IslandRP:BanAio')
  end
end)

--================================================================================================
--==                                 Vehicles Actions GUI                                        ==
--================================================================================================
RegisterNUICallback('NUIVehicleActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openVehicles'})
end)

--================================================================================================
--==                                   Door Actions GUI                                         ==
--================================================================================================
RegisterNUICallback('NUIDoorActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openDoorActions'})
end)

RegisterNUICallback('toggleFrontLeftDoor', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 0, false)            
       else
         SetVehicleDoorOpen(playerVeh, 0, false)             
      end
   end
end)

RegisterNUICallback('toggleFrontRightDoor', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 1) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 1, false)            
       else
         SetVehicleDoorOpen(playerVeh, 1, false)             
      end
   end
end)

RegisterNUICallback('toggleBackLeftDoor', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 2) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 2, false)            
       else
         SetVehicleDoorOpen(playerVeh, 2, false)             
      end
   end
end)

RegisterNUICallback('toggleBackRightDoor', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 3) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 3, false)            
       else
         SetVehicleDoorOpen(playerVeh, 3, false)             
      end
   end
end)

RegisterNUICallback('toggleHood', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 4) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 4, false)            
       else
         SetVehicleDoorOpen(playerVeh, 4, false)             
      end
   end
end)

RegisterNUICallback('toggleTrunk', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 5) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 5, false)            
       else
         SetVehicleDoorOpen(playerVeh, 5, false)             
      end
   end
end)

RegisterNUICallback('toggleWindowsUp', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
	 RollUpWindow(playerVeh, 0)
	 RollUpWindow(playerVeh, 1)
	 RollUpWindow(playerVeh, 2)
	 RollUpWindow(playerVeh, 3)
   end
end)

RegisterNUICallback('toggleWindowsDown', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
	 RollDownWindow(playerVeh, 0)
	 RollDownWindow(playerVeh, 1)
	 RollDownWindow(playerVeh, 2)
	 RollDownWindow(playerVeh, 3)
   end
end)

--================================================================================================
--==                                Windows Actions GUI                                         ==
--================================================================================================
RegisterNUICallback('NUIWindowActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openWindows'})
end)

--================================================================================================
--==                               Character Actions GUI                                        ==
--================================================================================================
RegisterNUICallback('NUICharActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openCharacters'})
end)

RegisterNetEvent("menu:setCharacters")
AddEventHandler("menu:setCharacters", function(identity)
  myIdentity = identity
end)

RegisterNetEvent("menu:setIdentifier")
AddEventHandler("menu:setIdentifier", function(data)
  myIdentifiers = data
end)

RegisterNetEvent("menu:getSteamIdent")
AddEventHandler("menu:getSteamIdent", function(identity)
  if myIdentifiers.steamidentifier then
    TriggerEvent("chatMessage", "^1[IDENTITY]", {255, 255, 0}, "Your steam identifier is:" .. myIdentifiers.steamidentifier)
  else
    TriggerEvent("chatMessage", "^1[IDENTITY]", {255, 255, 0}, "Your steam identifier is nil. Please use /getID")
  end
end)


--===============================================
--== Button Events for List Characters         ==
--===============================================
RegisterNUICallback('NUIlistCharacters', function(data)
  TriggerServerEvent('menu:setChars', myIdentifiers)
  Wait(1000)
  SetNuiFocus(true, true)
  local bt  = myIdentity.character1 --- Character 1 ---
  local bt2 = myIdentity.character2 --- character 2 ---
  local bt3 = myIdentity.character3 --- character 3 ---
  
  SendNUIMessage({
  type = "listCharacters",
  char1    = bt,
  char2    = bt2,
  char3    = bt3,
  backBtn  = "Back",
  exitBtn  = "Exit"
}) 
end)

--===============================================
--== Button Events for Change Characters       ==
--===============================================
RegisterNUICallback('NUIchangeCharacters', function(data)
  TriggerServerEvent('menu:setChars', myIdentifiers)
  Wait(1000)
  SetNuiFocus(true, true)
  local bt  = myIdentity.character1 --- Character 1 ---
  local bt2 = myIdentity.character2 --- character 2 ---
  local bt3 = myIdentity.character3 --- character 3 ---
  
  SendNUIMessage({
  type = "changeCharacters",
  char1    = bt,
  char2    = bt2,
  char3    = bt3,
  backBtn  = "Back",
  exitBtn  = "Exit"
}) 
end)

RegisterNUICallback('NUISelChar1', function(data)
  TriggerServerEvent('menu:selectChar1', myIdentifiers, data)
  cb(data)
end)

RegisterNUICallback('NUISelChar2', function(data)
    TriggerServerEvent('menu:selectChar2', myIdentifiers, data)
    cb(data)
end)

RegisterNUICallback('NUISelChar3', function(data)
    TriggerServerEvent('menu:selectChar3', myIdentifiers, data)
    cb(data)
end)

--===============================================
--== Button Events for Delete Characters       ==
--===============================================
RegisterNUICallback('NUIdeleteCharacters', function(data)
  TriggerServerEvent('menu:setChars', myIdentifiers)
  Wait(1000)
  SetNuiFocus(true, true)
  local bt  = myIdentity.character1 --- Character 1 ---
  local bt2 = myIdentity.character2 --- character 2 ---
  local bt3 = myIdentity.character3 --- character 3 ---
  
  SendNUIMessage({
  type = "deleteCharacters",
  char1    = bt,
  char2    = bt2,
  char3    = bt3,
  backBtn  = "Back",
  exitBtn  = "Exit"
}) 
end)
