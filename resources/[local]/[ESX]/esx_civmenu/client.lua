
ESX = nil

local PlayerData = {}

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


RegisterCommand("nui", function(source)

  SetNuiFocus(false,false)

end)



RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
	  PlayerData.name = name
end)



RegisterNetEvent('pokazujedowod')
AddEventHandler('pokazujedowod', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then

    TriggerEvent('chatMessage',"^6Obywatel["  .. id .. "]^0:^6 Pokazuje Dowod Osobisty: " .. name )
  elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.999 then
    if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then    
      TriggerEvent('chatMessage',"^6Obywatel["  .. id .. "]^0:^6 Pokazuje Dowod Osobisty: " .. name )
    end
  end
end)

RegisterNetEvent('pokazujewiz')
AddEventHandler('pokazujewiz', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage',"^6Obywatel["  .. id .. "]^0:^6 Pokazuje Wizytówkę: " .. name )
  elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.999 then
    if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then
      TriggerEvent('chatMessage',"^6Obywatel["  .. id .. "]^0:^6 Pokazuje Wizytówkę: " .. name )
    end
  end
end)

  RegisterNetEvent('esx_dowod:sendProximityMessage')
  AddEventHandler('esx_dowod:sendProximityMessage',function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then 
      TriggerEvent('chat:addMessage', {
       args = {'^6Obywatel[' ..  id .. ']', message }
    })
    elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.999 then
      if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then      
        TriggerEvent('chat:addMessage', {
            args = {'^6Obywatel[' ..  id .. ']', message }
        })
      end
    end
  end)

function MenuObywatela()
        ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'esx_dowod',
      {
          title    = 'Menu Obywatela',
          align    = 'right',
          elements = {
            {label = 'Dokumenty Osobiste', value = 'dokumentyszmato'},
            {label = 'Legitymacje', value = 'ligitkiszmato'},
          }
        
      },
        function(data, menu)
          if data.current.value == 'dokumentyszmato' then
            OpenMenuDokumenty()
        elseif data.current.value == 'ligitkiszmato' then
            OpenMenuLegitymacje()
          end
        end,
        function(data, menu)
          menu.close()
          ESX.UI.Menu.CloseAll()
        end
      )
end

function OpenMenuDokumenty()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'dokumentyszmato',
        {
			align    = 'center',
            title    = 'Dokumenty Osobiste',
            elements = {
              {label = 'Dowód', value = 'dowod'},
              {label = 'Wizytówka', value = 'wiz'},
              {label = 'Ubezpieczenie', value = 'ubezpieczenie'},
            }
        },
        function(data, menu)
      if data.current.value == 'dowod' then
       TriggerServerEvent('dowod')
        ESX.UI.Menu.CloseAll()
      elseif data.current.value == 'ubezpieczenie' then
          ExecuteCommand('ubezpieczenie')
      elseif data.current.value == 'wiz' then
        ExecuteCommand('wizytowka')	
      ESX.UI.Menu.CloseAll()				
            end
        end,
        function(data, menu)
     ESX.UI.Menu.CloseAll()
        end
	)
end
  RegisterNetEvent('esx:dowod_pokazDokument')
  AddEventHandler('esx:dowod_pokazDokument', function(id, imie, data, dodatek)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(pid))
    if pid == myId then
      TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek, 'CHAR_BLANK_ENTRY', 8)
    elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.999 then
      if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then      
        TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek, 'CHAR_BLANK_ENTRY', 8)
      end
    end
    UnregisterPedheadshot(mugshot)
  end)

  function OpenMenuLegitymacje()
  
    local elements = {}
  
        if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
          table.insert(elements,{label = 'Odznaka SAST', value = 'lspd'})
        elseif PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then
          table.insert(elements,{label = 'Legitymacja SAMS', value = 'ems'})
        elseif PlayerData.job ~= nil and PlayerData.job.name == 'police' then
          table.insert(elements,{label = 'Ubezpieczenie Służbowe', value = 'lspdubez'})
        elseif PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
          table.insert(elements,{label = 'Plakietka LSCS', value = 'lscs'})
        elseif PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' then
          table.insert(elements, {label = 'Odznaka SASD', value = 'sasd'})
        end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'dokumentyszmato',
      {
        title    = 'Legitymacje',
        align    = 'center',
        elements = elements
        },
            function(data2, menu2)
                if data2.current.value == 'lspd' then
                 ExecuteCommand('lspd')
                elseif data2.current.value == 'lspdubez' then
                 ExecuteCommand('lspdubez')  
                elseif data2.current.value == 'ems' then 
                  ExecuteCommand('ems')                
                elseif data2.current.value == 'lscs' then
                  ExecuteCommand('lscs')
                elseif data2.current.value == 'sasd' then
                  ExecuteCommand('')
                end
  
            end,
            function(data, menu)
            menu.close()
          end)
  end 

RegisterNetEvent('esx:dowod_pokazdowod')
AddEventHandler('esx:dowod_pokazdowod', function(id, imie, data, dodatek)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(pid))
  if pid == myId then
    SetNotificationBackgroundColor(200)
    TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek, 'CHAR_BLANK_ENTRY')

		chowaniebronianim()
		pokazdowodanim()
		
  elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.999 then
		if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then    
      SetNotificationBackgroundColor(200)
      TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek, 'CHAR_BLANK_ENTRY')
    end
  end
  
  UnregisterPedheadshot(mugshot)

end)



RegisterNetEvent('esx:dowod_wiz')
AddEventHandler('esx:dowod_wiz', function(id, imie, data, dodatek)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(pid))
  if pid == myId then
    SetNotificationBackgroundColor(11)
    TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek, 'CHAR_BLANK_ENTRY')
		chowaniebronianim()
		pokazdowodanim()
		
  elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.999 then
		if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then
      SetNotificationBackgroundColor(11)
      TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek, 'CHAR_BLANK_ENTRY')
    end
  end
  
  UnregisterPedheadshot(mugshot)

end)

RegisterNetEvent('esx:dowod_account')
AddEventHandler('esx:dowod_account', function(id, imie, data, dodatek)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(pid))
  if pid == myId then
    SetNotificationBackgroundColor(11)
    TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek, 'CHAR_BLANK_ENTRY')
		chowaniebronianim()
		pokazdowodanim()
		
  elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.999 then
		if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then
      SetNotificationBackgroundColor(11)
      TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek, 'CHAR_BLANK_ENTRY')
    end
  end
  
  UnregisterPedheadshot(mugshot)

end)

RegisterNetEvent('esx:dowod_xd')
AddEventHandler('esx:dowod_xd', function(id, imie, data, dodatek)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(pid))
  if pid == myId then
    SetNotificationBackgroundColor(11)
    TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek,'CHAR_BLANK_ENTRY')
		chowaniebronianim()
		pokazdowodanim()
		
  elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.999 then
		if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then
      SetNotificationBackgroundColor(11)
      TriggerEvent('esx:showAdvancedNotification', imie, data, dodatek, 'CHAR_BLANK_ENTRY')
    end
  end
  
  UnregisterPedheadshot(mugshot)

end)

RegisterNetEvent('esx:dowod_mariuszek')
AddEventHandler('esx:dowod_mariuszek', function(id, imie, data, dodatek)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(pid))
  if pid == myId then
    SetNotificationBackgroundColor(11)
    TriggerEvent('FeedM:showAdvancedNotification', imie, data, dodatek, 'CHAR_BLANK_ENTRY', 15000, danger)
	  chowaniebronianim()
    pokazblachaanim()
    
  elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.999 then
		if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then
      SetNotificationBackgroundColor(11)
      TriggerEvent('FeedM:showAdvancedNotification', imie, data, dodatek, 'CHAR_BLANK_ENTRY', 15000, danger)
    end
  end
  
  UnregisterPedheadshot(mugshot)

end)

function chowaniebronianim()
  if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedCuffed(PlayerPedId()) then
  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
  Citizen.Wait(1)
  end
  end

  function pokazblachaanim()
  if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedCuffed(PlayerPedId()) then
  RequestAnimDict("random@atm_robbery@return_wallet_male")
  while (not HasAnimDictLoaded("random@atm_robbery@return_wallet_male")) do Citizen.Wait(0) end
  TaskPlayAnim(PlayerPedId(), "random@atm_robbery@return_wallet_male", "return_wallet_positive_a_player", 8.0, 3.0, 1000, 56, 1, false, false, false)
  end
  end
  
  function sraka()
  if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedCuffed(PlayerPedId()) then
  usuwanieprop()
  blacha = CreateObject(GetHashKey('prop_fib_badge'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(blacha, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.03, 0.003, -0.045, 90.0, 0.0, 75.0, 1, 0, 0, 0, 0, 1)
  Citizen.Wait(1000)
  usuwanieprop()
  end
  end
  
  function blachaprop2()
    if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedCuffed(PlayerPedId()) then
    usuwanieprop()
    blacha = CreateObject(GetHashKey('p_ld_id_card_01'), GetEntityCoords(PlayerPedId()), true)-- creates object
    AttachEntityToEntity(blacha, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.03, 0.003, -0.045, 90.0, 0.0, 75.0, 1, 0, 0, 0, 0, 1)
    Citizen.Wait(1000)
    usuwanieprop()
    end
    end
  
  function usuwanieprop()
  DeleteEntity(blacha)
  DeleteEntity(dowod)
  DeleteEntity(portfel)
  end




local LegitModel = "p_ld_id_card_01"
local animDict = "missfbi_s4mop"
local animName = "swipe_card"
local Legit_net = nil

RegisterNetEvent("civmenu:Legitanim")
AddEventHandler("civmenu:Legitanim", function()

  RequestModel(GetHashKey(LegitModel))
  while not HasModelLoaded(GetHashKey(LegitModel)) do
    Citizen.Wait(100)
  end

  RequestAnimDict(animDict)
  while not HasAnimDictLoaded(animDict) do
    Citizen.Wait(100)
  end

  local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
  local Legitspawned = CreateObject(GetHashKey(LegitModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
  Citizen.Wait(1000)
  local netid = ObjToNet(Legitspawned)
  SetNetworkIdExistsOnAllMachines(netid, true)
  SetNetworkIdCanMigrate(netid, false)
  TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0)
  TaskPlayAnim(GetPlayerPed(PlayerId()), animDict, animName, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
  Citizen.Wait(800)
  AttachEntityToEntity(Legitspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
  Legit_net = netid
  Citizen.Wait(3000)
  ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
  DetachEntity(NetToObj(Legit_net), 1, 1)
  DeleteEntity(NetToObj(Legit_net))
  Legit_net = nil
end)




local plateModel2 = "prop_fib_badge"
local animDict2 = "missfbi_s4mop"
local animName2 = "swipe_card"
local plate_net = nil

RegisterNetEvent("civmenu:plateanim")
AddEventHandler("civmenu:plateanim", function()

  RequestModel(GetHashKey(plateModel2))
  while not HasModelLoaded(GetHashKey(plateModel2)) do
    Citizen.Wait(100)
  end

  RequestAnimDict(animDict2)
  while not HasAnimDictLoaded(animDict2) do
    Citizen.Wait(100)
  end

  local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
  local platespawned = CreateObject(GetHashKey(plateModel2), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
  Citizen.Wait(1000)
  local netid = ObjToNet(platespawned)
  SetNetworkIdExistsOnAllMachines(netid, true)
  SetNetworkIdCanMigrate(netid, false)
  TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0)
  TaskPlayAnim(GetPlayerPed(PlayerId()), animDict2, animName2, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
  Citizen.Wait(800)
  AttachEntityToEntity(platespawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
  plate_net = netid
  Citizen.Wait(3000)
  ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
  DetachEntity(NetToObj(plate_net), 1, 1)
  DeleteEntity(NetToObj(plate_net))
  plate_net = nil
end)


function chowaniebronianim()
  if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedCuffed(PlayerPedId()) then
  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
  Citizen.Wait(1)
  end
  end
  
  function pokazdowodanim()
  if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedCuffed(PlayerPedId()) then
  RequestAnimDict("random@atmrobberygen")
  while (not HasAnimDictLoaded("random@atmrobberygen")) do Citizen.Wait(0) end
  TaskPlayAnim(PlayerPedId(), "random@atmrobberygen", "a_atm_mugging", 8.0, 3.0, 2000, 0, 1, false, false, false)
  end
  end
  
  function pokazblachaanim()
  if not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedCuffed(PlayerPedId()) then
  RequestAnimDict("random@atm_robbery@return_wallet_male")
  while (not HasAnimDictLoaded("random@atm_robbery@return_wallet_male")) do Citizen.Wait(0) end
  TaskPlayAnim(PlayerPedId(), "random@atm_robbery@return_wallet_male", "return_wallet_positive_a_player", 8.0, 3.0, 1000, 56, 1, false, false, false)
  end
  end