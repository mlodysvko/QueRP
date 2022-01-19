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

local CruisedSpeed = 0
local CruisedSpeedKm = 0
local CruisedThread = nil

ESX = nil
Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(0, Keys["~"]) then
      local playerPed = PlayerPedId()
	    local vehicle = GetVehicle(playerPed)
	    if vehicle and GetPedInVehicleSeat(vehicle, -1) == playerPed then
	      if CruisedThread then
		    TerminateThread(CruisedThread)
		    CruisedThread = nil
	    end

        TriggerCruiseControl(playerPed, vehicle)
      end
    end
  end
end)

function GetVehicle(ped)
  local vehicle = GetVehiclePedIsIn(ped, false)
  if vehicle and vehicle ~= 0 then
    local model = GetEntityModel(vehicle)
    if IsThisModelACar(model) or IsThisModelABike(model) then
      return vehicle
    end
  end
end

function TriggerCruiseControl(ped, vehicle)
  if CruisedSpeed == 0 and IsPedInAnyVehicle(ped, false) then
    local speed = GetVehicleSpeed(vehicle)
    if speed > 0 then
      CruisedSpeed = speed
      CruisedSpeedKm = TransformToKm(CruisedSpeed)

      ESX.ShowNotification('Włączono tempomat: ~b~' .. CruisedSpeedKm .. ' km/h')
      Citizen.CreateThread(function()
	    CruisedThread = GetIdOfThisThread()
        while CruisedSpeed > 0 and GetPedInVehicleSeat(vehicle, -1) == ped do
          Citizen.Wait(0)
          if not GetIsVehicleEngineRunning(vehicle) then
            CruisedSpeed = 0
            break
          end

		  speed = GetVehicleSpeed(vehicle)
          if not IsControlPressed(2, 76) and not IsControlPressed(2, 63) and not IsControlPressed(2, 64) then
            if speed < (CruisedSpeed - 5.0) then
              CruisedSpeed = 0
              ESX.ShowNotification('Wyłączono tempomat')
              Citizen.Wait(2000)
              break
            end

            if IsVehicleOnAllWheels(vehicle) and speed < CruisedSpeed then
              SetVehicleForwardSpeed(vehicle, CruisedSpeed)
            end
          end

          if IsControlJustPressed(0, Keys["~"]) then
            CruisedSpeed = speed
            CruisedSpeedKm = TransformToKm(CruisedSpeed)
          end

          if IsControlJustPressed(2, 72) then
            CruisedSpeed = 0
            ESX.ShowNotification('Wyłączono tempomat')
            Citizen.Wait(2000)
            break
          end
        end

		CruisedThread = nil
      end)
    end
  end
end

function GetVehicleSpeed(vehicle)
  local speed = GetEntitySpeed(vehicle)
  return GetVehicleCurrentGear(vehicle) > 0 and speed or (speed * -1)
end

function TransformToKm(speed)
  return math.floor(speed * 3.6 + 0.5)
end

function IsEnabled()
	return CruisedSpeed > 0
end