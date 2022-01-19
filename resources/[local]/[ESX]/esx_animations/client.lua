Keys = {
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
ragdoll = false
isDead = false
prop = nil
loop = {
	status = nil,
	current = nil,
	finish = nil,
	delay = 0,
	dettach = false,
	last = 0
}
binds = nil
binding = nil
ESX = nil
local PlayerData = {}

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end


	Citizen.Wait(5000)
    PlayerData = ESX.GetPlayerData()
	if not binds then
		TriggerServerEvent('esx_animations:load')
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

RegisterNetEvent('esx_animations:bind')
AddEventHandler('esx_animations:bind', function(list)
	binds = list
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	isDead = false
end)



RegisterNetEvent('esx_animations:trigger')
AddEventHandler('esx_animations:trigger', function(anim)
	--local ped = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
	--local car = GetVehiclePedIsIn(ped, false)
	--if car then 
		if anim.type == 'ragdoll' then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				ragdoll = true
			end
		elseif anim.type == 'attitude' then
			if anim.data.car == true then
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					startAttitude(anim.data.lib, anim.data.anim)
				end
			else
				if not IsPedInAnyVehicle(PlayerPedId(), false) then
					startAttitude(anim.data.lib, anim.data.anim)
				end
			end
		elseif anim.type == 'scenario' then
			if anim.data.car == true then
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					startScenario(anim.data.anim, anim.data.offset)
				end
			else
				if not IsPedInAnyVehicle(PlayerPedId(), false) then
					startScenario(anim.data.anim, anim.data.offset)
				end
			end
		elseif anim.type == 'anim' then
			if anim.data.car == true then
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					startAnim(anim.data.lib, anim.data.anim, anim.data.mode, anim.data.prop)
				end
			else
				if not IsPedInAnyVehicle(PlayerPedId(), false) then
					startAnim(anim.data.lib, anim.data.anim, anim.data.mode, anim.data.prop)
				end
			end
		elseif anim.type == 'facial' then
			TriggerEvent('esx_voice:facial', anim.data)
		elseif anim.type == 'wspolne' then
			if anim.data.name == 'powitaj' then
			local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
				if not IsPedInAnyVehicle(Gracz, false) then
					local closestPlayer, distance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= nil and distance ~= -1 and distance <= 3.0 then
						TriggerServerEvent('route68_animacje:powitajSynchroS', GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification('~r~Brak obywatela w poblizu')
					end
				end		
			elseif anim.data.name == 'przytul' then
			local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
				if not IsPedInAnyVehicle(Gracz, false) then
					local closestPlayer, distance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= nil and distance ~= -1 and distance <= 3.0 then
						TriggerServerEvent('route68_animacje:przytulSynchroS', GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification('~r~Brak obywatela w poblizu')
					end
				end		
			elseif anim.data.name == 'pocaluj' then
			local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
				if not IsPedInAnyVehicle(Gracz, false) then
				local closestPlayer, distance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= nil and distance ~= -1 and distance <= 3.0 then
						TriggerServerEvent('route68_animacje:pocalujSynchroS', GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification('~r~Brak obywatela w poblizu')
					end
				end		
			elseif anim.data.name == 'przenies' then
			local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
				if not IsPedInAnyVehicle(Gracz, false) then
				local closestPlayer, distance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= nil and distance ~= -1 and distance <= 3.0 then
						TriggerServerEvent('route68_animacje:OdpalAnimacje4', GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification('~r~Brak obywatela w poblizu')
					end
				end		
			end
		else
			if not IsPedInAnyVehicle(PlayerPedId(), false) then
				startAnimLoop(anim.data)
			end
		end
	--else 
		
	--end
	
end)

function startAttitude(lib, anim)
	CreateThread(function()
		RequestAnimSet(anim)
		while not HasAnimSetLoaded(anim) do
			Citizen.Wait(1)
		end

		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startScenario(anim, offset)
	if loop.status == true then
		finishLoop(function()
			startScenario(anim, offset)
		end)
	else
		local ped = PlayerPedId()
		if offset then
			local coords = GetEntityCoords(ped, true)
			TaskStartScenarioAtPosition(ped, anim, coords.x, coords.y, coords.z + offset, GetEntityHeading(ped), 0, true, true)
		else
			TaskStartScenarioInPlace(ped, anim, 0, false)
		end
	end
end

function startAnim(lib, anim, mode, obj)
	if loop.status == true then
		finishLoop(function()
			startAnim(lib, anim, mode, obj)
		end)
	else
		mode = mode or 0
		CreateThread(function()
			RequestAnimDict(lib)
			while not HasAnimDictLoaded(lib) do
				Citizen.Wait(0)
			end

			local ped = PlayerPedId()
			TaskPlayAnim(ped, lib, anim, 8.0, -8.0, -1, mode, 0, false, false, false)
			if obj then
				if type(prop) == 'table' then
					DeleteObject(prop.obj)
				end

				local coords = GetEntityCoords(ped)
				local boneIndex = GetPedBoneIndex(ped, obj.bone)
				ESX.Game.SpawnObject(obj.object, {
					x = coords.x,
					y = coords.y,
					z = coords.z + 2
				}, function(object)
					AttachEntityToEntity(object, ped, boneIndex, obj.offset.x + 0.0, obj.offset.y + 0.0, obj.offset.z + 0.0, obj.rotation.x + 0.0, obj.rotation.y + 0.0, obj.rotation.z + 0.0, true, true, false, true, 1, true)
					prop = {obj = object, lib = lib, anim = anim}
				end)
			end
		end)
	end
end

function startAnimLoop(data)
	if loop.status == true then
		finishLoop(function()
			startAnimLoop(data)
		end)
	else
		CreateThread(function()
			while loop.status ~= nil do
				Citizen.Wait(1)
			end

			RequestAnimDict(data.base.lib)
			while not HasAnimDictLoaded(data.base.lib) do
				Citizen.Wait(1)
			end

			RequestAnimDict(data.idle.lib)
			while not HasAnimDictLoaded(data.idle.lib) do
				Citizen.Wait(1)
			end

			RequestAnimDict(data.finish.lib)
			while not HasAnimDictLoaded(data.finish.lib) do
				Citizen.Wait(1)
			end

			local playerPed = PlayerPedId()
			if data.prop then
				local coords	= GetEntityCoords(playerPed)
				local boneIndex = GetPedBoneIndex(playerPed, data.prop.bone)

				ESX.Game.SpawnObject(data.prop.object, {
					x = coords.x,
					y = coords.y,
					z = coords.z + 2
				}, function(object)
					AttachEntityToEntity(object, playerPed, boneIndex, data.prop.offset.x, data.prop.offset.y, data.prop.offset.z, data.prop.rotation.x, data.prop.rotation.y, data.prop.rotation.z, true, true, false, true, 1, true)
					prop = object
				end)
			end

			TaskPlayAnim(PlayerPedId(), data.base.lib, data.base.anim, 8.0, -8.0, -1, data.mode, 0, false, false, false)
			loop = {status = true, current = nil, finish = data.finish, delay = (GetGameTimer() + 100), last = 0}

			loop.finish.mode = data.mode
			if data.prop then
				loop.dettach = data.prop.dettach
			else
				loop.dettach = false
			end

			Citizen.Wait(data.base.length)
			while loop.status do
				local rng
				repeat
					rng = math.random(0, #data.idle.anims)
				until rng ~= loop.last

				loop.delay = GetGameTimer() + 100
				loop.last = rng
				if rng == 0 then
					TaskPlayAnim(PlayerPedId(), data.base.lib, data.base.anim, 8.0, -8.0, -1, data.mode, 0, false, false, false)
					loop.current = data.base
					Citizen.Wait(data.base.length)
				else
					TaskPlayAnim(PlayerPedId(), data.idle.lib, data.idle.anims[rng][1], 8.0, -8.0, -1, data.mode, 0, false, false, false)
					loop.current = {lib = data.idle.lib, anim = data.idle.anims[rng][1]}
					Citizen.Wait(data.idle.anims[rng][2])
				end
			end
		end)
	end
end

function finishLoop(cb)
	loop.status = false
	CreateThread(function()
		TaskPlayAnim(PlayerPedId(), loop.finish.lib, loop.finish.anim, 8.0, 8.0, -1, loop.finish.mode, 0, false, false, false)

		Citizen.Wait(loop.finish.length)
		if loop.status == false and prop then
			if loop.dettach then
				DetachEntity(prop, true, false)
			else
				DeleteObject(prop)
			end

			prop = nil
		end

		loop.status = nil
		if cb then
			cb()
		end
	end)
end


function OpenAnimationsMenu()

	local elements = {}
	if not binding then
		if binds then
			table.insert(elements, {label = "Ulubione (SHIFT+1-9)", value = "binds"})
		end

		table.insert(elements, {label = "- PRZERWIJ -", value = "cancel"})
	end
	
	for _, group in ipairs(Config.Animations) do
		if not group.resource or GetResourceState(group.resource) == 'started' then
			table.insert(elements, {label = group.label, value = group.name})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'animations', {
		title    = 'Animacje',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'binds' then
			menu.close()
			OpenBindsSubMenu()
		elseif data.current.value ~= 'cancel' then
			menu.close()
			OpenAnimationsSubMenu(data.current.value)
		elseif not exports['esx_policejob']:isHandcuffed() and not exports['IslandRP']:checkInTrunk() then
			clearTask()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBindsSubMenu()
	local elements = {}
	for i = 1, 9 do
		local bind = binds[i]
		if bind then
			table.insert(elements, {label = i .. ' - ' .. bind.label, value = i, assigned = true})
		else
			table.insert(elements, {label = i .. ' - PRZYPISZ', value = i, assigned = false})
		end
	end

	window = ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'animations_binds', {
		title    = 'Animacje - ulubione',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		menu.close()
		window = nil

		local index = tonumber(data.current.value)
		if data.current.assigned then
			binds[index] = nil
			TriggerServerEvent('esx_animations:save', binds)
			OpenBindsSubMenu()
		else
			binding = tonumber(data.current.value)
			OpenAnimationsMenu()
		end
	end, function(data, menu)
		menu.close()
		window = nil
		OpenAnimationsMenu()
	end)
end


function OpenAnimationsSubMenu(menu)
	local title, elements = nil, {}
	for _, group in ipairs(Config.Animations) do
		if group.name == menu then
			for _, item in ipairs(group.items) do
				table.insert(elements, {label = item.label .. (item.keyword and ' <span style="font-size: 11px; color: #fff000;">/e ' .. item.keyword .. '</span>' or ''), short = item.label, type = item.type, data = item.data})
			end

			title = group.label
			break
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'animations_' .. menu, {
		title    = title,
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if binding then
			menu.close()

			window = nil
			if not binds then
				binds = {}
			end

			binds[binding] = {
				label = '[' .. title .. '] ' .. data.current.short,
				type = data.current.type,
				data = data.current.data
			}
			TriggerServerEvent('esx_animations:save', binds)

			binding = nil
			OpenBindsSubMenu()
		else
			TriggerEvent('esx_animations:trigger', data.current)
		end
	end, function(data, menu)
		menu.close()
		OpenAnimationsMenu()
	end)
end

RegisterCommand("e",function(source, args)
	local player = PlayerPedId()
	if tostring(args[1]) == nil then
		return
	else
		if tostring(args[1]) ~= nil then
            local argh = tostring(args[1])
			for _, group in ipairs(Config.Animations) do
				for _, anim in ipairs(group.items) do
					if argh == anim.keyword then
						if anim.type == 'ragdoll' then
							if IsPedInAnyVehicle(PlayerPedId(), false) then
								ragdoll = true
							end
						elseif anim.type == 'attitude' then
							if anim.data.car == true then
								if IsPedInAnyVehicle(PlayerPedId(), false) then
									startAttitude(anim.data.lib, anim.data.anim)
								end
							else
								if not IsPedInAnyVehicle(PlayerPedId(), false) then
									startAttitude(anim.data.lib, anim.data.anim)
								end
							end
						elseif anim.type == 'scenario' then
							if anim.data.car == true then
								if IsPedInAnyVehicle(PlayerPedId(), false) then
									startScenario(anim.data.anim, anim.data.offset)
								end
							else
								if not IsPedInAnyVehicle(PlayerPedId(), false) then
									startScenario(anim.data.anim, anim.data.offset)
								end
							end
						elseif anim.type == 'anim' then
							if anim.data.car == true then
								if IsPedInAnyVehicle(PlayerPedId(), false) then
									startAnim(anim.data.lib, anim.data.anim, anim.data.mode, anim.data.prop)
								end
							else
								if not IsPedInAnyVehicle(PlayerPedId(), false) then
									startAnim(anim.data.lib, anim.data.anim, anim.data.mode, anim.data.prop)
								end
							end
						elseif anim.type == 'wspolne' then
							if anim.data.name == 'powitaj' then
							local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
								if not IsPedInAnyVehicle(Gracz, false) then
									local closestPlayer, distance = ESX.Game.GetClosestPlayer()
									if closestPlayer ~= nil and distance ~= -1 and distance <= 3.0 then
										TriggerServerEvent('route68_animacje:powitajSynchroS', GetPlayerServerId(closestPlayer))
									else
										ESX.ShowNotification('~r~Brak obywatela w poblizu')
									end
								end		
							elseif anim.data.name == 'przytul' then
							local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
								if not IsPedInAnyVehicle(Gracz, false) then
									local closestPlayer, distance = ESX.Game.GetClosestPlayer()
									if closestPlayer ~= nil and distance ~= -1 and distance <= 3.0 then
										TriggerServerEvent('route68_animacje:przytulSynchroS', GetPlayerServerId(closestPlayer))
									else
										ESX.ShowNotification('~r~Brak obywatela w poblizu')
									end
								end		
							elseif anim.data.name == 'pocaluj' then
							local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
								if not IsPedInAnyVehicle(Gracz, false) then
								local closestPlayer, distance = ESX.Game.GetClosestPlayer()
									if closestPlayer ~= nil and distance ~= -1 and distance <= 3.0 then
										TriggerServerEvent('route68_animacje:pocalujSynchroS', GetPlayerServerId(closestPlayer))
									else
										ESX.ShowNotification('~r~Brak obywatela w poblizu')
									end
								end		
							elseif anim.data.name == 'przenies' then
							local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
								if not IsPedInAnyVehicle(Gracz, false) then
								local closestPlayer, distance = ESX.Game.GetClosestPlayer()
									if closestPlayer ~= nil and distance ~= -1 and distance <= 3.0 then
										TriggerServerEvent('route68_animacje:OdpalAnimacje4', GetPlayerServerId(closestPlayer))
									else
										ESX.ShowNotification('~r~Brak obywatela w poblizu')
									end
								end		
							end
						else
							if not IsPedInAnyVehicle(PlayerPedId(), false) then
								startAnimLoop(anim.data)
							end
						end
					end
				end
			end
		end
	end
end)

-- Key Controls
CreateThread(function()
	while true do
		Citizen.Wait(1)

		local ped = PlayerPedId()
		if ragdoll then
			SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
		end

		if loop.status and loop.current and loop.delay < GetGameTimer() and not IsEntityPlayingAnim(ped, loop.current.lib, loop.current.anim, 3) then
			loop.status = nil
			if prop and type(prop) ~= 'table' then
				if loop.dettach then
					DetachEntity(prop, true, false)
				else
					DeleteObject(prop)
				end

				prop = nil
			end
		end

		if type(prop) == 'table' and not IsEntityPlayingAnim(ped, prop.lib, prop.anim, 3) then
			DeleteObject(prop.obj)
			prop = nil
		end
		
		if IsControlPressed(0, Keys['LEFTSHIFT']) and not IsPedSprinting(ped) and not IsPedRunning(ped) then
			local bind = nil
			for i, key in ipairs({157, 158, 160, 164, 165, 159, 161, 162, 163}) do
				DisableControlAction(0, key, true)
				--[[if binds[i] == nil then
					print(binds[i])
				end]]
				if IsDisabledControlJustPressed(0, key) and binds[i] then
					bind = i
					break
				end
			end

			if bind and not exports['esx_ambulancejob']:getDeathStatus() or exports['esx_policejob']:isHandcuffed() and not getCarry() then
				TriggerEvent('esx_animations:trigger', binds[bind])
			end
		end
		
		if IsControlJustPressed(0, Keys['F3']) then
			OpenAnimationsMenu(PlayerPedId())
		elseif IsControlJustReleased(0, Keys['X']) and GetLastInputMethod(2) then		
			clearTask()
		end

	end
end)

RegisterNetEvent('animacje')
AddEventHandler('animacje', function()
	OpenAnimationsMenu(PlayerPedId())
end)

function clearTask()
	if loop.status == true then
		finishLoop()
	elseif ragdoll then
		ragdoll = false
	else
		ClearPedTasks(PlayerPedId())
		if loop.status ~= nil then
			loop.status = nil
			if prop and type(prop) ~= 'table' then
				if loop.dettach then
					DetachEntity(prop, true, false)
				else
					DeleteObject(prop)
				end

				prop = nil
			end
		elseif type(prop) == 'table' then
			DeleteObject(prop.obj)
			prop = nil
		end
	end
end

local Oczekuje = false
local Czas = 7
local wysylajacy = nil

RegisterNetEvent('route68_animacje:powitajSynchroC')
AddEventHandler('route68_animacje:powitajSynchroC', function(target)
	Oczekuje = true
	wysylajacy = target
end)

CreateThread(function()
    while true do
		Citizen.Wait(0)
		if Oczekuje then
			if IsControlJustReleased(0, 246) then
				Oczekuje = false
				Czas = 7
				TriggerServerEvent('route68_animacje:OdpalAnimacje', wysylajacy)
			end
		else
			Citizen.Wait(200)
		end
    end
end)



RegisterNetEvent('route68_animacje:PrzywitajTarget')
AddEventHandler('route68_animacje:PrzywitajTarget', function(target)

	local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
	local targetPed = Citizen.InvokeNative(0x43A66C31C68491C0, GetPlayerFromServerId(target))

	AttachEntityToEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), targetPed, 11816, 0.1, 1.15, 0.0, 0.0, 0.0, 180.0, false, false, false, false, 20, false)
	ESX.Streaming.RequestAnimDict("mp_ped_interaction", function()
		TaskPlayAnim(playerPed, "mp_ped_interaction", "handshake_guy_b", 8.0, -8.0, -1, 0, 0, false, false, false)
	end)

	Citizen.Wait(950)
	DetachEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), true, false)
	Oczekuje = false
	Czas = 7
	wysylajacy = nil
end)

RegisterNetEvent('route68_animacje:PrzywitajSource')
AddEventHandler('route68_animacje:PrzywitajSource', function()
	local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, -1)


	ESX.Streaming.RequestAnimDict("mp_ped_interaction", function()
		TaskPlayAnim(playerPed, "mp_ped_interaction", "handshake_guy_a", 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end)

CreateThread(function()
    while true do
		Citizen.Wait(1000)
		if Oczekuje then
			Czas = Czas - 1
		end
    end
end)

CreateThread(function()
    while true do
		Citizen.Wait(250)
		if Czas < 1 then
			Oczekuje = false
			Czas = 7
			wysylajacy = nil
			ESX.ShowNotification('~r~Anulowano propozycję animacji')
		end
    end
end)

-- pocalowanie

local Oczekuje2 = false
local Czas2 = 7
local wysylajacy2 = nil

RegisterNetEvent('route68_animacje:pocalujSynchroC')
AddEventHandler('route68_animacje:pocalujSynchroC', function(target)
	Oczekuje2 = true
	wysylajacy2 = target
end)

CreateThread(function()
    while true do
		Citizen.Wait(0)
		if Oczekuje2 then 
			if IsControlJustReleased(0, 246) then
				Oczekuje2 = false
				Czas2 = 7
				TriggerServerEvent('route68_animacje:OdpalAnimacje2', wysylajacy2)
			end
		else
			Citizen.Wait(200)
		end
    end
end)

RegisterNetEvent('route68_animacje:PocalujTarget')
AddEventHandler('route68_animacje:PocalujTarget', function(target)

	local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
	local targetPed = Citizen.InvokeNative(0x43A66C31C68491C0, GetPlayerFromServerId(target))

	AttachEntityToEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), targetPed, 11816, 0.0, 1.2, 0.0, 0.0, 0.0, 180.0, false, false, false, false, 20, false)
	ESX.Streaming.RequestAnimDict("mp_ped_interaction", function()
		TaskPlayAnim(playerPed, "mp_ped_interaction", "kisses_guy_a", 8.0, -8.0, -1, 0, 0, false, false, false)
	end)

	Citizen.Wait(950)
	DetachEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), true, false)
	Oczekuje2 = false
	Czas2 = 7
	wysylajacy2 = nil
end)

RegisterNetEvent('route68_animacje:PocalujSource')
AddEventHandler('route68_animacje:PocalujSource', function()
	local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, -1)


	ESX.Streaming.RequestAnimDict("mp_ped_interaction", function()
		TaskPlayAnim(playerPed, "mp_ped_interaction", "kisses_guy_b", 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end)

CreateThread(function()
    while true do
		Citizen.Wait(1000)
		if Oczekuje2 then
			Czas2 = Czas2 - 1
		end
    end
end)

CreateThread(function()
    while true do
		Citizen.Wait(250)
		if Czas2 < 1 then
			Oczekuje2 = false
			Czas2 = 7
			wysylajacy2 = nil
			ESX.ShowNotification('~r~Anulowano propozycję animacji')
		end
    end
end)

-- przytulas 

local Oczekuje3 = false
local Czas3 = 7
local wysylajacy3 = nil

RegisterNetEvent('route68_animacje:przytulSynchroC')
AddEventHandler('route68_animacje:przytulSynchroC', function(target)
	Oczekuje3 = true
	wysylajacy3 = target
end)

CreateThread(function()
    while true do
		Citizen.Wait(0)
		if Oczekuje3 then
			if IsControlJustReleased(0, 246) then
				Oczekuje3 = false
				Czas3 = 7
				TriggerServerEvent('route68_animacje:OdpalAnimacje3', wysylajacy3)
			end
		else
			Citizen.Wait(200)
		end
    end
end)

RegisterNetEvent('route68_animacje:PrzytulTarget')
AddEventHandler('route68_animacje:PrzytulTarget', function(target)

	local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
	local targetPed = Citizen.InvokeNative(0x43A66C31C68491C0, GetPlayerFromServerId(target))

	AttachEntityToEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), targetPed, 11816, -0.05, 0.9, 0.0, 0.0, 0.0, 180.0, false, false, false, false, 20, false)
	ESX.Streaming.RequestAnimDict("mp_ped_interaction", function()
		TaskPlayAnim(playerPed, "mp_ped_interaction", "hugs_guy_a", 8.0, -8.0, -1, 0, 0, false, false, false)
	end)

	Citizen.Wait(950)
	DetachEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), true, false)
	Oczekuje3 = false
	Czas3 = 7
	wysylajacy3 = nil
end)

RegisterNetEvent('route68_animacje:PrzytulSource')
AddEventHandler('route68_animacje:PrzytulSource', function()
	local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, -1)


	ESX.Streaming.RequestAnimDict("mp_ped_interaction", function()
		TaskPlayAnim(playerPed, "mp_ped_interaction", "hugs_guy_a", 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end)

CreateThread(function()
    while true do
		Citizen.Wait(1000)
		if Oczekuje3 then
			Czas3 = Czas3 - 1
		end
    end
end)

CreateThread(function()
    while true do
		Citizen.Wait(250)
		if Czas3 < 1 then
			Oczekuje3 = false
			Czas3 = 7
			wysylajacy3 = nil
			ESX.ShowNotification('~r~Anulowano propozycję animacji')
		end
    end
end)


--Noszenie

local Oczekuje4 = false
local Czas4 = 7
local wysylajacy4 = nil

RegisterNetEvent('route68_animacje:przytulSynchroC2')
AddEventHandler('route68_animacje:przytulSynchroC2', function(target)
	Oczekuje4 = true
	wysylajacy4 = target
end)

CreateThread(function()
    while true do
		Citizen.Wait(1000)
		if Oczekuje4 then
			Czas4 = Czas4 - 1
		end
    end
end)

CreateThread(function()
    while true do
		Citizen.Wait(250)
		if Czas4 < 1 then
			Oczekuje4 = false
			Czas4 = 7
			wysylajacy4 = nil
			ESX.ShowNotification('~r~Anulowano propozycję animacji')
		end
    end
end)

CreateThread(function()
    while true do
		Citizen.Wait(0)
		if Oczekuje4 then
			if IsControlJustReleased(0, 246) then
				Oczekuje4 = false
				Czas4 = 7
				TriggerServerEvent('route68_animacje:OdpalAnimacje5', wysylajacy4)
			end
		else
			Citizen.Wait(200)
		end
    end
end)

local carryingBackInProgress = false
local niesie = false

function getCarry()
	return carryingBackInProgress
end

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if niesie == true then
			local coords = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
			ESX.Game.Utils.DrawText3D(coords, "NACIŚNIJ [~g~L~s~] ABY PUŚCIĆ", 0.45)
			if IsControlJustPressed(0, Keys['L']) then
				local closestPlayer, distance = ESX.Game.GetClosestPlayer()
				local target = GetPlayerServerId(closestPlayer)
				carryingBackInProgress = false
				niesie = false
				ClearPedSecondaryTask(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
				DetachEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), true, false)
				TriggerServerEvent("cmg2_animations:stop", target)
			end
		else
			Citizen.Wait(200)
		end
	end
end)

RegisterNetEvent('cmg2_animations:startMenu2')
AddEventHandler('cmg2_animations:startMenu2', function()  
  local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
	if not IsPedInAnyVehicle(Gracz, false) then
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= nil and distance <= 4 then
			TriggerEvent('cmg2_animations:startMenu', GetPlayerServerId(closestPlayer))
		end
	end
end)

RegisterNetEvent('cmg2_animations:startMenu')
AddEventHandler('cmg2_animations:startMenu', function(obiekt)
	if not carryingBackInProgress then
		niesie = true
		carryingBackInProgress = true
		local player = PlayerPedId()	
		lib = 'missfinale_c2mcs_1'
		anim1 = 'fin_c2_mcs_1_camman'
		lib2 = 'nm'
		anim2 = 'firemans_carry'
		distans = 0.15
		distans2 = 0.27
		height = 0.63
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
		local closestPlayer = Citizen.InvokeNative(0x43A66C31C68491C0, obiekt)
		target = obiekt
		if closestPlayer ~= nil then
			TriggerServerEvent('cmg2_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		end
	else
		carryingBackInProgress = false
		ClearPedSecondaryTask(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
		DetachEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), true, false)
		local closestPlayer = obiekt
		target = GetPlayerServerId(closestPlayer)
		TriggerServerEvent("cmg2_animations:stop",target)
	end
end)

RegisterNetEvent('cmg2_animations:syncTarget')
AddEventHandler('cmg2_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
	local targetPed = Citizen.InvokeNative(0x43A66C31C68491C0, GetPlayerFromServerId(target))
	carryingBackInProgress = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
end)

RegisterNetEvent('cmg2_animations:syncMe')
AddEventHandler('cmg2_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)

	Citizen.Wait(length)
end)

RegisterNetEvent('cmg2_animations:cl_stop')
AddEventHandler('cmg2_animations:cl_stop', function()
	carryingBackInProgress = false
	niesie = false
	ClearPedSecondaryTask(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
	DetachEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), true, false)
end)

function GetPlayers()
  local players = {}
  for _, player in ipairs(GetActivePlayers()) do
    table.insert(players, player)
  end

  return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = Citizen.InvokeNative(0x43A66C31C68491C0, value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

local lockpick = false

RegisterNetEvent('animki:lockpick')
AddEventHandler('animki:lockpick', function(rodzaj)
	if rodzaj == true then
		lockpick = true
	elseif rodzaj == false then
		lockpick = false
	end
end)

--Zakładanie rąk
CreateThread(function()
    local dict = "amb@world_human_hang_out_street@female_arms_crossed@base"
    
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
    local handsup = false
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 47) then --Start holding g
			if not lockpick then
				if not handsup then
					TaskPlayAnim(Citizen.InvokeNative(0x43A66C31C68491C0, -1), dict, "base", 8.0, 8.0, -1, 50, 0, false, false, false)
					handsup = true
				else
					handsup = false
					ClearPedTasks(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
				end
			end
        end
    end
end)


	


