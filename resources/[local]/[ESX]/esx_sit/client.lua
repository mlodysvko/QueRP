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

ESX = nil

local sitting = false
local lastPos = nil
local currentSitObj = nil
local currentScenario = nil

local debugProps = {}

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

SitGetClosestObject = function(filter, coords)
  local objects = ESX.Game.GetObjects()
  local closestDistance = -1
  local closestObject   = -1
  local filter  = filter
  local coords = coords

  if type(filter) == 'string' then
    if filter ~= '' then
      filter = {filter}
    end
  end

  if coords == nil then
    local playerPed = PlayerPedId()
    coords = GetEntityCoords(playerPed)
  end

  for i = 1, #objects, 1 do
    local foundObject = false
    if filter == nil or (type(filter) == 'table' and #filter == 0) then
      foundObject = true
    else
      local objectModel = GetEntityModel(objects[i])
      for j = 1, #filter, 1 do
        local model = tonumber(filter[j])
        if not model then
          model = GetHashKey(filter[j])
        end

        if objectModel == model then
          foundObject = true
        end
      end
    end

    if foundObject then
      local objectCoords = GetEntityCoords(objects[i])

      local distance = GetDistanceBetweenCoords(objectCoords.x, objectCoords.y, objectCoords.z, coords.x, coords.y, coords.z, true)
      if closestDistance == -1 or closestDistance > distance then
        closestObject   = objects[i]
        closestDistance = distance
      end
    end
  end

  return closestObject, closestDistance
end

CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
			wakeup(playerPed)
		end

		if IsControlPressed(0, Keys['LEFTSHIFT']) then
			DisableControlAction(2, Keys['F'], true)
			if IsDisabledControlJustReleased(2, Keys['F']) and not IsPedInAnyVehicle(playerPed, true) then
				if sitting then
					wakeup(playerPed)
				else
					local object, distance = SitGetClosestObject(Config.Interactables)
					if distance < 1.5 then
						local hash = GetEntityModel(object)
						for k, v in pairs(Config.Sitable) do
							local model = tonumber(k)
							if not model then
								model = GetHashKey(k)
							end

							if model == hash then
								sit(playerPed, object, v)
								break
							end
						end
					end
				end
			end
		end
	end
end)

function sit(playerPed, object, data)
	local pos = GetEntityCoords(object)

	local id = pos.x .. ';' .. pos.y .. ';' .. pos.z
	ESX.TriggerServerCallback('esx_interact:getPlace', function(occupied)
		if occupied then
			ESX.ShowNotification("To miejsce jest już zajęte...")
		else
			lastPosition = GetEntityCoords(playerPed)
			currentObject = id
			currentScenario = data.scenario

			FreezeEntityPosition(object, true)
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z - data.verticalOffset, GetEntityHeading(object) + 180.0, 200, (data.sitting and 1 or 0), true)
			sitting = false
			Citizen.Wait(500)
			sitting = true
		end
	end, id)
end

function wakeup(playerPed)
	sitting = nil
	ClearPedTasks(playerPed)

	SetEntityCoords(playerPed, lastPosition)
	FreezeEntityPosition(playerPed, false)
	FreezeEntityPosition(currentObject, false)

	TriggerServerEvent('esx_interact:leavePlace', currentObject)
	currentObject = nil
	currentScenario = nil
end
