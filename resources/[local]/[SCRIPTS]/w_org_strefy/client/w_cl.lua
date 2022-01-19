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
  local norg = 'brak'
  local ngrade = nil
  local akcja = nil
  local blips = {}
  local isDead = false
  Citizen.CreateThread(function()
	  while ESX == nil do
		  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		  Citizen.Wait(0)
      end
      
      while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
      end

      Citizen.Wait(5000)
    --   while ngrade == nil do
    --   ESX.TriggerServerCallback('w_organizacje:get', function(org, grade)
    --     norg = org
    --     ngrade = grade
    --   end)
    --   Citizen.Wait(1000)
    -- end
    norg = ESX.GetPlayerData().job.name
    ngrade = ESX.GetPlayerData().job.grade
      Citizen.Wait(5000)
      TriggerEvent('w_org_strefy:blip')
  
  end)
  RegisterNetEvent('w_organizacje:ustawprace')
  AddEventHandler('w_organizacje:ustawprace', function(job, grade)
    norg = job
    ngrade = grade
    TriggerEvent('w_org_strefy:blip')
  end)

   RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
    -- job.name
    norg = job.name
    ngrade = job.grade
    -- TriggerEvent('w_4psm:createblip')
        TriggerEvent('w_org_strefy:blip')
  end)

  function msg(text)
    TriggerEvent('chat:addMessage', {
      template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 174, 255, 0.6); border-radius: 3px;"><i class="fa fa-exclamation-triangle"></i> {0}: {1}</div>',
      args = { "STREFY", text }
  })
  end

  AddEventHandler('playerSpawned', function(spawn)
    isDead = false
  end)
  AddEventHandler('esx:onPlayerDeath', function()
    isDead = true
  end)

  RegisterNetEvent('w_org_strefy:warn')
  AddEventHandler('w_org_strefy:warn', function(id, wiad)
    ESX.TriggerServerCallback('w_org_strefy:checkblip', function(check)
      if check == norg then
        for _,v in pairs(Config) do
          if v.id == id then
            if wiad == nil then
              msg("Ktoś przejmuje Twoją strefę: "..v.nazwa)
            else
              msg(wiad)
            end
          end
        end
      end
    end, id)
  end)


  RegisterNetEvent('w_org_strefy:blip')
  AddEventHandler('w_org_strefy:blip', function()
    Citizen.Wait(2000)
    for k, usun in pairs(blips) do
      RemoveBlip(usun)
    end
    if norg ~= 'brak' and norg ~= 'unemployed' then
    for _,v in pairs(Config) do
      ESX.TriggerServerCallback('w_org_strefy:checkblip', function(check)

      blipb = AddBlipForCoord(v.x,  v.y,  v.z)
      SetBlipSprite (blipb, 543)
      SetBlipDisplay(blipb, 4)
      SetBlipScale  (blipb, 0.8)
      
        
      SetBlipAsShortRange(blipb, true)
      BeginTextCommandSetBlipName("STRING")
      
      if norg == check then
        SetBlipColour (blipb, 74)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Strefa: "..v.nazwa.." | Przejęta")
          else
            SetBlipColour (blipb, 76)
            BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Strefa: "..v.nazwa.." | Nieprzejęta")
          end
      EndTextCommandSetBlipName(blipb)

      table.insert(blips, blipb)
      end, v.id)
    end
   
  end


  end)
  
function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  local factor = 0
  SetTextScale(0.50, 0.50)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  if (string.len(text)) < 20 then
      factor = (string.len(text)) / 300
  else
      factor = (string.len(text)) / 250
  end
  DrawRect(_x,_y+0.018, 0.028+factor, 0.03, 0, 0, 0, 68)
end


local zaczete = false
local ped 
local playerPos 
local timer = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
       ped = GetPlayerPed(-1)
       playerPos = GetEntityCoords(ped)
       Citizen.Wait(500)
    end
end)





Citizen.CreateThread(function()
  Citizen.Wait(100)
    while true do
        Citizen.Wait(1)
        if norg ~= 'brak' and norg ~= 'unemployed' then
          
for _,v in pairs(Config) do
   if zaczete == false then
		  if (Vdist(playerPos.x, playerPos.y, playerPos.z, v.x, v.y, v.z) < 5.0) then
        DrawMarker(6, v.x, v.y, v.z-0.05, 0.0, 0.0, 0.0, 90.0, 90.0, 90.0, 1.0, 1.0, 1.0, 0, 174, 255, 100, false, true, 2, false, false, false, false)
		  end
    
  else
    if (Vdist(playerPos.x, playerPos.y, playerPos.z, v.x, v.y, v.z) < 3) then
      DrawText3Ds(v.x, v.y, v.z+1.5, "~r~[~g~"..timer.."%~r~]")
    end
      if (Vdist(playerPos.x, playerPos.y, playerPos.z, v.x, v.y, v.z) < v.rozmiar) then
        DrawMarker(28, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.rozmiar, v.rozmiar, v.rozmiar, 255,0,0, 50, false, true, 2, false, false, false, false)
      end
	
    end
end

else
    Citizen.Wait(1000)
end


end
end)



Citizen.CreateThread(function()
  Citizen.Wait(100)
    while true do
        Citizen.Wait(1)
        for _,v in pairs(Config) do
            if (Vdist(playerPos.x, playerPos.y, playerPos.z, v.x, v.y, v.z) < 2.0) then
                if IsControlJustPressed(0, Keys['E']) then
                  if zaczete == false and not isDead then
                    timer = 0
                    menu(v.id, v.x,v.y,v.z, v.rozmiar)
                  end
                end
            end
        end
end
end)

Items = {
  "water",
  "bread",
}

function RandomItem()
  return Items[math.random(#Items)]
end

function RandomNumber()
	return math.random(2,6)
end

function menu(id, xx,yy,zz,rozmair)

  ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'menu', 
  {
    title    = ('Menu Stref'),
    align = 'center', 
    elements = { 
      {label = ('Przejmij strefę'),     value = 'x1'},
      {label = ('Wypłać pieniądze z konta strefy'),     value = 'x2'},
    }
  },
  function(data, menu) 
    if data.current.value == 'x1' then
      ESX.TriggerServerCallback('w_org_strefy:checkblip', function(check)
        if check == norg then
          menu.close()
          msg("Chcesz przejmować swoją strefę?")
        else
          timer = 0
      menu.close()
      start(id, xx,yy,zz,rozmair)
        end
      end, id)
    elseif data.current.value == 'x2' then
      menu.close()
     TriggerServerEvent('w_org_strefy:addkonto', id, norg)
     xPlayer.addInventoryItem(RandomItem(), RandomNumber())
    end   
  end,
  function(data, menu)
      menu.close() 
  end
)

end


function start(id, xx,yy,zz,rozmair)

  ESX.TriggerServerCallback('w_org_strefy:check', function(decyzja)
    if decyzja then
      zaczete = true

starttimer(xx,yy,zz,rozmair, id)
    end
  end, id)
end

function starttimer(xx,yy,zz,rozmair, id)
  while true do
    Citizen.Wait(1)
    if (Vdist(playerPos.x, playerPos.y, playerPos.z, xx,yy,zz) > rozmair) or isDead then
      zaczete = false
      timer = 0
      TriggerServerEvent('w_org_strefy:przerwij')
    end
 

    if timer >= 100 and zaczete then
      timer = 0
      zaczete = false
      TriggerServerEvent('w_org_strefy:przerwij', true)
      --trigger do wywalenia z tabeli i przejecia strefy
      msg("Udało Ci się przejąć strefę")
      TriggerServerEvent('w_org_strefy:przejmij', id, norg)
      break
    end
    
    timer = timer+1
      Citizen.Wait(CzasPrzejmowania*60000/100)
  end
end

