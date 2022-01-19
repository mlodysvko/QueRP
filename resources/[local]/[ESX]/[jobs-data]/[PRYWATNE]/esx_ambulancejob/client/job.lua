local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["INSERT"] = 121,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData			  = {}
local FirstSpawn			  = true
local IsDead				  = false
local HasAlreadyEnteredMarker = false
local LastZone				= nil
local CurrentAction		   = nil
local CurrentActionMsg		= ''
local CurrentActionData	   = {}
local IsBusy				  = false
local blipsMedics			 = {}
local HasTimer				= false
local TimerThreadId	   = nil
local DistressThreadId	= nil
local CameraThreadId	  = nil
local AwaitHospital		   = false
local Character			   = 0
local CurrentTask			 = {}
local BedCamera = nil
local DeathCamera = nil
local CameraAngleY = 0.0
local CameraAngleZ = 0.0

local Melee = { `WEAPON_UNARMED`, `WEAPON_KNUCKLE`, `WEAPON_BAT`, `WEAPON_FLASHLIGHT`, `WEAPON_HAMMER`, `WEAPON_CROWBAR`, `WEAPON_PIPEWRENCH`, `WEAPON_NIGHTSTICK`, `WEAPON_GOLFCLUB`, `WEAPON_WRENCH` }
local Knife = { `WEAPON_KNIFE`, `WEAPON_DAGGER`, `WEAPON_MACHETE`, `WEAPON_HATCHET`, `WEAPON_SWITCHBLADE`, `WEAPON_BATTLEAXE`, `WEAPON_BATTLEAXE`, `WEAPON_STONE_HATCHET` }
local Bullet = { `WEAPON_SNSPISTOL`, `WEAPON_SNSPISTOL_MK2`, `WEAPON_VINTAGEPISTOL`, `WEAPON_PISTOL`, `WEAPON_PISTOL_MK2`, `WEAPON_DOUBLEACTION`, `WEAPON_COMBATPISTOL`, `WEAPON_HEAVYPISTOL`, `WEAPON_DBSHOTGUN`, `WEAPON_SAWNOFFSHOTGUN`, `WEAPON_PUMPSHOTGUN`, `WEAPON_PUMPSHOTGUN_MK2`, `WEAPON_BULLPUPSHOTGUN`, `WEAPON_MICROSMG`, `WEAPON_SMG`, `WEAPON_SMG_MK2`, `WEAPON_ASSAULTSMG`, `WEAPON_COMBATPDW`, `WEAPON_GUSENBERG`, `WEAPON_COMPACTRIFLE`, `WEAPON_ASSAULTRIFLE`, `WEAPON_CARBINERIFLE`, `WEAPON_MARKSMANRIFLE`, `WEAPON_SNIPERRIFLE`, `WEAPON_1911PISTOL` }
local Electricity = { `WEAPON_STUNGUN` }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709 }
local Drown = { -10959621, 1936677264 }
local Car = { 133987706, -1553120962 }


function checkArray(array, val)
	for _, value in ipairs(array) do
		local v = value
		if type(v) == 'string' then
			v = GetHashKey(v)
		end

		if v == val then
			return true
		end
	end

	return false
end

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

AddEventHandler('esx:onPlayerSpawn', function()
	isDead = false

	if firstSpawn then
		firstSpawn = false

		if Config.AntiCombatLog then
			while not PlayerLoaded do
				Citizen.Wait(5000)
			end

			ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(shouldDie)
				if shouldDie then
					Citizen.Wait(10000)
					SetEntityHealth(PlayerPedId(), 0)
				end
			end)
		end
	end
end)


function SetVehicleMaxMods(vehicle, model, livery, offroad, color, extras)
	local mods = {
		bulletProofTyre = true,
		modTurbo		= true,
		modXenon		= true,
		dirtLevel	   = 0,
		modEngine	   = 3,
		modBrakes	   = 2,
		modTransmission = 2,
		modSuspension   = 3,
		extras		  = {1,1,1,1,1,1,1,1,1,1,1,1}
	}
	if offroad then
		mods.wheels = 4
		mods.modFrontWheels = 10
	end

	if color then
		if type(color) == 'table' then
			mods.color1 = color[1]
			mods.color2 = color[2]
		else
			mods.color1 = color
			mods.color2 = color
		end
	end

	local tmp = true
	if model ~= 'polamb' then
		mods.modArmor = 4
		tmp = false
	elseif livery then
		tmp = false
	end

	if extras then
		for k, v in pairs(extras) do
			mods.extras[tonumber(k)] = tonumber(v)
		end
	end

	ESX.Game.SetVehicleProperties(vehicle, mods, tmp)
	if livery then
		SetVehicleLivery(vehicle, livery)
	end
end

function RespawnPed(ped, coords)
	SetEntityCoords(ped, coords.x, coords.y, coords.z)
	SetEntityHeading(entity, coords.heading)
	if entity == PlayerPedId() then
	  SetGameplayCamRelativeHeading(coords.heading)
	end

	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
	ClearPedBloodDamage(ped)

	SetPlayerInvincible(ped, false)
	ESX.UI.Menu.CloseAll()
end

local timeLeft = nil
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if timeLeft ~= nil then
			local coords = GetEntityCoords(PlayerPedId())	
			DrawText3D(coords.x, coords.y, coords.z + 0.1, timeLeft .. '~g~%', 0.4)
		end
	end
end)

function procent(time, cb)
	if cb ~= nil then
		Citizen.CreateThread(function()
			timeLeft = 0
			repeat
				timeLeft = timeLeft + 1
				Citizen.Wait(time)
			until timeLeft == 100
			timeLeft = nil
			cb()
		end)
	else
		timeLeft = 0
		repeat
			timeLeft = timeLeft + 1
			Citizen.Wait(time)
		until timeLeft == 100
		timeLeft = nil
	end
end

Citizen.CreateThread(function()
   
    while true do
        local sleep = 5000
        local _source = source
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for i = 1, #Config.Doctor, 1 do
            local konum = Config.Doctor[i]
            local userDst = GetDistanceBetweenCoords(pedCoords, konum.x, konum.y, konum.z, true)

            if userDst <= 7 then
                sleep = 2
                if userDst <= 5 then
					ESX.ShowNotification('Naciśnij E aby skorzystać z pomocy lekarza za: $'..Config.doctorPrice)
                    DrawMarker(27, konum.x, konum.y, konum.z-0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, 255, 195, 18, 100, false, true, 2, false, false, false, false)
                    if userDst <= 3.5 then
                        if IsControlJustPressed(0, 38) then
                            
                            ESX.TriggerServerCallback('ali:getEms', function(cb)
                                canEms = cb
                            end, i)
                            while canEms == nil do
                                Wait(0)
							end
									TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, false)
									procent(150, function()
										TriggerEvent('esx:showNotifiaction', 'Lekarz zajmuje się tobą.')
									end)
									Citizen.Wait(15000)
	                            if Config.DoctorLimit then
                                if canEms == true then
                                   -- if not exports['esx_scoreboard']:BierFrakcje('ambulance') >= 5 then
										ESX.TriggerServerCallback('esx_lokalnydoktor:parakontrol', function(hasEnoughMoney)
											if hasEnoughMoney then
												local formattedCoords = {
													x = ESX.Math.Round(pedCoords.x, 1),
													y = ESX.Math.Round(pedCoords.y, 1),
													z = ESX.Math.Round(pedCoords.z, 1)
												}
												TriggerEvent('esx_ambulancejob:revive', target)
												TriggerServerEvent('esx_lokalnydoktor:money')
											else
												TriggerEvent('esx:showNotification', 'Nie masz wystarczająco pieniędzy!')
												ClearPedTasksImmediately(PlayerPedId())
											end
										end)
									--else
									--	TriggerEvent('esx:showNotification','W mieście jest wystarczająco dużo medyków, udaj się do nich!') 
									--	ClearPedTasksImmediately(PlayerPedId())        
									--end                    
                                end 
                            else
                                ESX.TriggerServerCallback('esx_lokalnydoktor:parakontrol', function(hasEnoughMoney)
                                    if hasEnoughMoney then
                                        local formattedCoords = {
                                            x = ESX.Math.Round(pedCoords.x, 1),
                                            y = ESX.Math.Round(pedCoords.y, 1),
                                            z = ESX.Math.Round(pedCoords.z, 1)
										}
										TriggerEvent('esx_ambulancejob:revive', target)
                                        TriggerServerEvent('esx_lokalnydoktor:money')
                                    else
                                        TriggerEvent('esx:showNotification','Nie masz wystarczająco pieniędzy!')
										ClearPedTasksImmediately(PlayerPedId())
                                    end
                                end)
                            end
                        end
                    end
                end
            end

        end

        Citizen.Wait(sleep)
    end
end)



Citizen.CreateThread(function()
    RequestModel(GetHashKey("s_m_m_doctor_01"))
	
    while not HasModelLoaded(GetHashKey("s_m_m_doctor_01")) do
        Wait(1)
    end
	
	if Config.EnablePeds then
        for _, doctor in pairs(Config.Doctor) do
            
			local npc = CreatePed(4, 0xd47303ac, doctor.x, doctor.y, doctor.z-1.0, doctor.heading, false, true)
			
			SetEntityHeading(npc, doctor.heading)
			FreezeEntityPosition(npc, true)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(_type)
	local playerPed = PlayerPedId()

	local maxHealth = GetEntityMaxHealth(playerPed)
	if _type == 'small' then
		SetEntityHealth(playerPed,  math.min(maxHealth , math.floor(GetEntityHealth(playerPed) + maxHealth / 3)))
	elseif _type == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	ESX.ShowNotification(_U('healed'))
end)

function StartDistressSignal()
	if TimerThreadId then
		TerminateThread(DistressThreadId)
	end

	Citizen.CreateThread(function()
		Citizen.Wait(30000)
		DistressThreadId = GetIdOfThisThread()

		local signal = 0
		while IsDead do
			Citizen.Wait(0)
			if signal < GetGameTimer() then
				SetTextFont(4)
				SetTextProportional(1)
				SetTextScale(0.45, 0.45)
				SetTextColour(185, 185, 185, 255)
				SetTextDropShadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()

				BeginTextCommandDisplayText('STRING')
				AddTextComponentSubstringPlayerName(_U('distress_send'))
				EndTextCommandDisplayText(0.175, 0.805)

				if IsControlPressed(0, Keys['G']) then
					SendDistressSignal()
					signal = GetGameTimer() + 120000
				end
			end
		end
	end)
end

function SendDistressSignal()
	exports['gcphone']:hasPhone(function(hasPhone)
		if hasPhone then
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			  local data = {
				number = 'ambulance',
				message = 'Ranny obywatel, potrzebna pilna pomoc medyczna!'
			}
			TriggerEvent('arivi-alert:callNumberD', data)
		else
			ESX.ShowNotification("~r~Nie masz telefonu")
		end
	end)
end

function ShowTimer()
	if TimerThreadId then
		TerminateThread(TimerThreadId)
	end

	Citizen.CreateThread(function()
		HasTimer = true
		TimerThreadId = GetIdOfThisThread()

		local timer = Config.RespawnToHospitalDelay
		while timer > 0 and IsDead do
			local tmp = GetGameTimer()

			local seconds = timer / 1000
			local minutes = tonumber(stringsplit(seconds / 60, ".")[1])
			seconds = tonumber(stringsplit(seconds - (minutes * 60), ".")[1])

			ESX.Scaleform.ShowFreemodeMessage('~r~Obezwładniony', _U('please_wait', minutes, seconds), 0.2)
			Citizen.InvokeNative(0x5F4B6931816E599B)
			timer = timer - (GetGameTimer() - tmp)
		end

		HasTimer = false
		local pressStart = nil
		while IsDead do
			Citizen.Wait(0)

			SetTextFont(4)
			SetTextProportional(0)
			SetTextScale(0.0, 0.5)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextCentre(true)

			BeginTextCommandDisplayText("STRING")
			AddTextComponentSubstringPlayerName(_U('press_respawn'))
			EndTextCommandDisplayText(0.5, 0.8)

			if IsControlPressed(0, Keys['E']) then
				if not pressStart then
					pressStart = GetGameTimer()
				end

				if GetGameTimer() - pressStart > 3000 then
					RemoveItemsAfterRPDeath()
					pressStart = nil
					break
				end
			else
				pressStart = nil
			end
		end
	end)
end

function RunCamera()
	if CameraThreadId then
		EndDeathCam()
		TerminateThread(CameraThreadId)
	end

	Citizen.CreateThread(function()
		CameraThreadId = GetIdOfThisThread()

		StartDeathCam()
		while IsDead and not IsPauseMenuActive() do
			Citizen.Wait(0)
			ProcessCamControls()
		end

		EndDeathCam()
	end)
end

function RemoveItemsAfterRPDeath()
	local ped = PlayerPedId()
	N_0xaab3200ed59016bc(ped, 0, 1)
	ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
		ESX.SetPlayerData('lastPosition', Config.DeathPosition)
		ESX.SetPlayerData('loadout', {})

		TriggerServerEvent('esx:updateLastPosition', Config.DeathPosition)
		RespawnPed(ped, Config.DeathPosition)
		FreezeEntityPosition(ped, true)

		StopScreenEffect('DeathFailOut')
		TriggerEvent('es:setMoneyDisplay', 1.0)
		ESX.UI.HUD.SetDisplay(1.0)

		N_0xd8295af639fd9cb8(ped)
		while not HasCollisionLoadedAroundEntity(ped) do
			Citizen.Wait(0)
		end

		FreezeEntityPosition(ped, false)
	end)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)

end

function StartDeathCam()
	ClearFocus()
	DeathCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(PlayerPedId(), false), 0, 0, 0, GetGameplayCamFov())
	SetCamActive(DeathCamera, true)
	RenderScriptCams(true, true, 1000, true, false)
end

function EndDeathCam()
	ClearFocus()
	RenderScriptCams(false, false, 0, true, false)
	DestroyCam(DeathCamera, false)
	DeathCamera = nil
end

function ProcessCamControls()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed, false)
	DisableFirstPersonCamThisFrame()

	local newPos = ProcessNewPosition(playerCoords)
	SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
	SetCamCoord(DeathCamera, newPos.x, newPos.y, newPos.z)
	PointCamAtCoord(DeathCamera, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end

function ProcessNewPosition(pCoords)
	local mouseX = 0.0
	local mouseY = 0.0
	
	if (IsInputDisabled(0)) then
		mouseX = GetDisabledControlNormal(1, 1) * 8.0
		mouseY = GetDisabledControlNormal(1, 2) * 8.0
	else
		mouseX = GetDisabledControlNormal(1, 1) * 1.5
		mouseY = GetDisabledControlNormal(1, 2) * 1.5
	end

	CameraAngleZ = CameraAngleZ - mouseX
	CameraAngleY = CameraAngleY + mouseY
	if CameraAngleY > 89.0 then
		CameraAngleY = 89.0
	elseif CameraAngleY < -89.0 then
		CameraAngleY = -89.0
	end
	
	local behindCam = {
		x = pCoords.x + ((Cos(CameraAngleZ) * Cos(CameraAngleY)) + (Cos(CameraAngleY) * Cos(CameraAngleZ))) / 2 * (Config.DeathCameraRadius + 0.5),
		y = pCoords.y + ((Sin(CameraAngleZ) * Cos(CameraAngleY)) + (Cos(CameraAngleY) * Sin(CameraAngleZ))) / 2 * (Config.DeathCameraRadius + 0.5),
		z = pCoords.z + ((Sin(CameraAngleY))) * (Config.DeathCameraRadius + 0.5)
	}
	local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
	local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	local maxRadius = Config.DeathCameraRadius
	if (hitBool and #(hitCoords - vec3(pCoords.x, pCoords.y, pCoords.z + 0.5)) < Config.DeathCameraRadius + 0.5) then
		maxRadius = #(hitCoords - vec3(pCoords.x, pCoords.y, pCoords.z + 0.5))
	end

	local offset = {
		x = ((Cos(CameraAngleZ) * Cos(CameraAngleY)) + (Cos(CameraAngleY) * Cos(CameraAngleZ))) / 2 * maxRadius,
		y = ((Sin(CameraAngleZ) * Cos(CameraAngleY)) + (Cos(CameraAngleY) * Sin(CameraAngleZ))) / 2 * maxRadius,
		z = ((Sin(CameraAngleY))) * maxRadius
	}
	return {
		x = pCoords.x + offset.x,
		y = pCoords.y + offset.y,
		z = pCoords.z + offset.z
	}
end

AddEventHandler('esx:playerLoaded', function()
	-- TriggerServerEvent('esx_ambulance:checkmydead')
end)

RegisterNetEvent('esx_ambulance:OnPlayerDeath')
AddEventHandler('esx_ambulance:OnPlayerDeath', function()
	OnPlayerDeath()
end)

function OnPlayerDeath()
	IsDead = true
	take = 1
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', take)

	ShowTimer()
	StartDistressSignal()
	RunCamera()

	ClearPedTasksImmediately(PlayerPedId())
	TriggerEvent('es:setMoneyDisplay', 0.0)
	ESX.UI.HUD.SetDisplay(1.0)

	ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 2.0)
	StartScreenEffect('DeathFailOut', 0, true)
	PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
end

function TeleportFadeEffect(entity, coords)

  Citizen.CreateThread(function()

	DoScreenFadeOut(800)
	while not IsScreenFadedOut() do
	  Citizen.Wait(0)
	end

	ESX.Game.Teleport(entity, coords, function()
	  if coords.heading then
		SetEntityHeading(entity, coords.heading)
		if entity == PlayerPedId() then
		  SetGameplayCamRelativeHeading(coords.heading)
		end
	  end

	  DoScreenFadeIn(800)
	end)

  end)

end

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 270
	DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

function OpenMobileAmbulanceActionsMenu()
	local elements = {}
	if PlayerData.job then
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped, false) then
			if PlayerData.job.name == 'ambulance' then
				table.insert(elements, {label = _U('citizen_interaction'), value = 'citizen_interaction'})
			end

			if PlayerData.job.grade == 2 or PlayerData.job.grade > 3 then
				table.insert(elements, {label = _U('vehicle_interaction'),	value = 'vehicle_interaction'})
			end
		else
			local vehicle = GetVehiclePedIsIn(ped, true)
			if IsVehicleModel(vehicle, `ambflatbed`) then
				table.insert(elements, {label = _U('dep_vehicle'), value = 'dep_vehicle'})
			end
		end
	end


	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title	= _U('ambulance'),
		align	= 'center',
		elements = elements
	}, function(data, menu)	
		if data.current.value == 'citizen_interaction' then
			menu.close()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title	= _U('citizen_interaction'),
				align	= 'center',
				elements = {
					{label = _U('ems_menu_revive'), value = 'revive'},
					{label = 'Zbadaj pacjenta', value = 'test'},
					{label = _U('ems_menu_small'), value = 'small'},
					{label = _U('ems_menu_big'), value = 'big'},
					{label = _U('ems_menu_drag'), value = 'drag'}
				}
			}, function(data2, menu2)
				if IsBusy then return end

				local playerPed = PlayerPedId()
				if IsPedInAnyVehicle(playerPed, false) then
					ESX.ShowNotification("~r~Nie można wykonać w aucie")
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or not IsEntityVisible(GetPlayerPed(closestPlayer)) or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players'))
					elseif data2.current.value == 'revive' then -- revive
						if IsPlayerDead(closestPlayer) then
							IsBusy = true
							ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
								if qtty > 0 then
									ESX.ShowNotification(_U('revive_inprogress'))

									RequestAnimDict('missheistfbi3b_ig8_2')
									while not HasAnimDictLoaded('missheistfbi3b_ig8_2') do
										Citizen.Wait(0)
									end

									local playerPed = PlayerPedId()
									TaskPlayAnim(playerPed, "missheistfbi3b_ig8_2", "cpr_loop_paramedic", 8.0, -8.0, -1, 1, 0, false, false, false)
									Citizen.Wait(7000)

									ClearPedTasks(playerPed)
									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))

									IsBusy = false
									if Config.ReviveReward > 0 then
										ESX.ShowNotification(_U('revive_complete_award', GetPlayerServerId(closestPlayer), Config.ReviveReward))
									else
										ESX.ShowNotification(_U('revive_complete', GetPlayerServerId(closestPlayer)))
									end
								else
									IsBusy = false
									ESX.ShowNotification(_U('not_enough_medikit'))
								end
							end, 'medikit')
						else
							ESX.ShowNotification(_U('player_not_conscious'))
						end
					elseif data2.current.value == 'test' then
						if IsPlayerDead(closestPlayer) then
							menu2.close()

							RequestAnimDict('amb@medic@standing@kneel@base')
							while not HasAnimDictLoaded('amb@medic@standing@kneel@base') do
								Citizen.Wait(0)
							end

							RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
							while not HasAnimDictLoaded('anim@gangops@facility@servers@bodysearch@') do
								Citizen.Wait(0)
							end

							local closestPlayerPed = GetPlayerPed(closestPlayer)
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions_test', {
								title= 'SAMS - Badanie pacjetna',
								align= 'center',
								elements = {
									{label = 'Zbadaj przyczynę utraty przytomności', value = 'death'},
									{label = 'Zbadaj uszkodzenia ciała', value = 'damage'}
								}
							}, function(data3, menu3)
								menu3.close()

								local ac = data3.current.value
								if ac == 'damage' then
									local success, bone = GetPedLastDamageBone(closestPlayerPed)
									if success then
										local x, y, z = table.unpack(GetPedBoneCoords(closestPlayerPed, bone))

										local timestamp = GetGameTimer()
										while (timestamp + 10000) > GetGameTimer() do
											Citizen.Wait(0)
											DrawText3D(x, y, z, '~g~*', 0.6)
										end
									else
										ESX.ShowNotification('Nie jesteś w stanie zbadać, gdzie pacjent doznał obrażeń.')
									end
								elseif ac == 'death' then
									IsBusy = true
									ESX.ShowNotification('Rozpoczynasz badanie pacjenta...')

									local playerPed = PlayerPedId()
									TaskPlayAnim(playerPed, "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
									TaskPlayAnim(playerPed, "anim@gangops@facility@servers@bodysearch@", "player_search", 8.0, -8.0, -1, 48, 0, false, false, false)

									Citizen.Wait(5000)
									ClearPedTasksImmediately(playerPed)
									IsBusy = false

									local d = GetPedCauseOfDeath(closestPlayerPed)
									if checkArray(Melee, d) then
										ESX.ShowNotification(_U('dc_hardmeele'))
									elseif checkArray(Bullet, d) then
										ESX.ShowNotification(_U('dc_bullet'))
									elseif checkArray(Knife, d) then
										ESX.ShowNotification(_U('dc_knifes'))
									elseif checkArray(Electricity, d) then
										ESX.ShowNotification(_U('dc_electricity'))
									elseif checkArray(Animal, d) then
										ESX.ShowNotification(_U('dc_bitten'))
									elseif checkArray(FallDamage, d) then
										ESX.ShowNotification(_U('dc_brokenlegs'))
									elseif checkArray(Explosion, d) then
										ESX.ShowNotification(_U('dc_explosive'))
									elseif checkArray(Gas, d) then
										ESX.ShowNotification(_U('dc_gas'))
									elseif checkArray(Burn, d) then
										ESX.ShowNotification(_U('dc_fire'))
									elseif checkArray(Drown, d) then
										ESX.ShowNotification(_U('dc_drown'))
									elseif checkArray(Car, d) then
										ESX.ShowNotification(_U('dc_caraccident'))
									else
										ESX.ShowNotification(_U('dc_unknown'))
									end
								end
							end, function(data3, menu3)
								menu3.close()
							end)
						else
							ESX.ShowNotification(_U('player_not_conscious'))
						end
					elseif data2.current.value == 'small' then
						if not IsPlayerDead(closestPlayer) then
							IsBusy = true
							ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
								if qtty > 0 then
									ESX.ShowNotification(_U('heal_inprogress'))

									local playerPed = PlayerPedId()
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)

									ClearPedTasks(playerPed)
									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')

									ESX.ShowNotification(_U('heal_complete', GetPlayerServerId(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('not_enough_bandage'))
								end
							end, 'bandage')
						else
							ESX.ShowNotification(_U('player_not_unconscious'))
						end
					elseif data2.current.value == 'big' then
						if not IsPlayerDead(closestPlayer) then
							IsBusy = true
							ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
								if qtty > 0 then
									ESX.ShowNotification(_U('heal_inprogress'))

									local playerPed = PlayerPedId()
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)

									ClearPedTasks(playerPed)
									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')

									ESX.ShowNotification(_U('heal_complete', GetPlayerServerId(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('not_enough_medikit'))
								end
							end, 'medikit')
						else
							ESX.ShowNotification(_U('player_not_unconscious'))
						end
					elseif data2.current.value == 'drag' then
					  if IsPedCuffed(GetPlayerPed(closestPlayer)) or IsPlayerDead(closestPlayer) then
						TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					  else
						ESX.ShowNotification(_U('player_not_unconscious'))
					  end
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements = {
			  {label = _U('pick_lock'), value = 'hijack_vehicle'},
			  {label = 'Napraw pojazd', value = 'fix_vehicle'},
			}

			ESX.UI.Menu.Open(
			  'default', GetCurrentResourceName(), 'vehicle_interaction',
			  {
				title	= _U('vehicle_interaction'),
				align	= 'center',
				elements = elements
			  },
			  function(data2, menu2)
				local playerPed = PlayerPedId()

				local vehicle = nil
				if IsPedInAnyVehicle(playerPed, false) then
					vehicle = GetVehiclePedIsIn(playerPed, false)
				else
					vehicle = ESX.Game.GetVehicleInDirection()
					if not vehicle then
						local coords = GetEntityCoords(playerPed, false)
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
						  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
						end
					end
				end

				local action = data2.current.value
				if vehicle and vehicle ~= 0 then
					if action == 'hijack_vehicle' then
						local playerPed = GetPlayerPed(-1)
						local vehicle   = ESX.Game.GetVehicleInDirection()
						local coords    = GetEntityCoords(playerPed)
				
						if IsPedSittingInAnyVehicle(playerPed) then
							ESX.ShowNotification(_U('inside_vehicle'))
							return
						end
				
						if DoesEntityExist(vehicle) then
							IsBusy = true
							TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
							Citizen.CreateThread(function()
								Citizen.Wait(10000)
				
								SetVehicleDoorsLocked(vehicle, 1)
								SetVehicleDoorsLockedForAllPlayers(vehicle, false)
								ClearPedTasksImmediately(playerPed)
				
								ESX.ShowNotification(_U('vehicle_unlocked'))
								IsBusy = false
							end)
						else
							ESX.ShowNotification(_U('no_vehicle_nearby'))
						end
					elseif action == 'fix_vehicle' then
						menu.close()
						exports['esx_mecanojob']:whyuniggarepairingme()
					elseif action == 'impound_vehicle' or action == 'hold_vehicle' then
						if CurrentTask.Busy then
							return
						end
						local coords    = GetEntityCoords(playerPed)
						
						SetTextComponentFormat('STRING')
						AddTextComponentString(_U('impound_prompt'))
						DisplayHelpTextFromStringLabel(0, 0, 1, -1)
						
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
						
						CurrentTask.Busy = true
						CurrentTask.Task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Citizen.Wait(500) 
						end)
						
						CreateThread(function()
							while CurrentTask.Busy do
								Citizen.Wait(1000)
							
								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and CurrentTask.Busy then
									ESX.ShowNotification(_U('impound_canceled_moved'))
									ESX.ClearTimeout(CurrentTask.Task)
									ClearPedTasks(playerPed)
									CurrentTask.Busy = false
									break
								end
							end
						end)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end
			  end,
			  function(data2, menu2)
				menu2.close()
			  end
			)
		elseif data.current.value == 'dep_vehicle' then
			exports['esx_mecanojob']:OnFlatbedUse(`ambflatbed`)
		end
	end, function(data, menu)
		menu.close()
	end)
end


function ImpoundVehicle(vehicle)
	ESX.Game.DeleteVehicle(vehicle) 
	ESX.ShowNotification(_U('impound_successful'))
	CurrentTask.Busy = false
end


function OpenCloakroomMenu(LSFD)
  local elements = {
	{label = _U('ems_clothes_civil'), value = 'citizen_wear'},
	{label = 'Ubrania Prywatne', value = 'player_dressing' },
	{label = 'Garderoba SAMS', value = 'otwier_dressing'}
  }

  ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'cloakroom', {
	  title	= _U('cloakroom'),
	  align	= 'center',
	  elements = elements
	}, function(data, menu)
	  menu.close()
	  if data.current.value == 'citizen_wear' then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		  TriggerEvent('skinchanger:loadSkin', skin)
		end)
		elseif data.current.value == 'otwier_dressing' then
			otwier_dressing()
		elseif data.current.value == 'player_dressing' then
			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = "Garderoba prywatna",
					align    = 'center',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
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

	  end

	  CurrentAction	 = 'cloak_actions_menu'
	  CurrentActionMsg  = _U('open_menu')
	  CurrentActionData = {LSFD = LSFD}
	end,
	function(data, menu)
	  menu.close()
	end
  )

end


local Clothes = {
	ProfesorMale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 322, ['torso_2'] = 0,
		['decals_1'] = 126, ['decals_2'] = 0,
		['arms'] = 93,
		['pants_1'] = 59, ['pants_2'] = 9,
		['shoes_1'] = 24, ['shoes_2'] = 0,
		['chain_1'] = 127, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 1, ['bproof_2'] = 0,
		['mask_1'] = 169, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	ProfesorFemale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 322, ['torso_2'] = 0,
		['decals_1'] = 126, ['decals_2'] = 0,
		['arms'] = 93,
		['pants_1'] = 59, ['pants_2'] = 9,
		['shoes_1'] = 24, ['shoes_2'] = 0,
		['chain_1'] = 127, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 1, ['bproof_2'] = 0,
		['mask_1'] = 169, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	ChirurgMale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 322, ['torso_2'] = 0,
		['decals_1'] = 126, ['decals_2'] = 0,
		['arms'] = 93,
		['pants_1'] = 59, ['pants_2'] = 9,
		['shoes_1'] = 24, ['shoes_2'] = 0,
		['chain_1'] = 127, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 1, ['bproof_2'] = 0,
		['mask_1'] = 169, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	ChirurgFemale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 322, ['torso_2'] = 0,
		['decals_1'] = 126, ['decals_2'] = 0,
		['arms'] = 93,
		['pants_1'] = 59, ['pants_2'] = 9,
		['shoes_1'] = 24, ['shoes_2'] = 0,
		['chain_1'] = 127, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 1, ['bproof_2'] = 0,
		['mask_1'] = 169, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	DoktorMale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 111, ['torso_2'] = 1,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 90,
		['pants_1'] = 124, ['pants_2'] = 4,
		['shoes_1'] = 10, ['shoes_2'] = 0,
		['chain_1'] = 126, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 1, ['bproof_2'] = 0,
		['mask_1'] = 169, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	DoktorFemale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 111, ['torso_2'] = 1,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 90,
		['pants_1'] = 124, ['pants_2'] = 4,
		['shoes_1'] = 10, ['shoes_2'] = 0,
		['chain_1'] = 126, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 1, ['bproof_2'] = 0,
		['mask_1'] = 169, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	LekarzMale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 111, ['torso_2'] = 1,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 90,
		['pants_1'] = 124, ['pants_2'] = 4,
		['shoes_1'] = 10, ['shoes_2'] = 0,
		['chain_1'] = 126, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 1, ['bproof_2'] = 0,
		['mask_1'] = 169, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	LekarzFemale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 111, ['torso_2'] = 1,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 90,
		['pants_1'] = 124, ['pants_2'] = 4,
		['shoes_1'] = 10, ['shoes_2'] = 0,
		['chain_1'] = 126, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 1, ['bproof_2'] = 0,
		['mask_1'] = 169, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	SpecjalnyMale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 316, ['torso_2'] = 0,
		['decals_1'] = 126, ['decals_2'] = 0,
		['arms'] = 91,
		['pants_1'] = 68, ['pants_2'] = 0,
		['shoes_1'] = 14, ['shoes_2'] = 6,
		['chain_1'] = 126, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	SpecjalnyFemale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 111, ['torso_2'] = 1,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 90,
		['pants_1'] = 124, ['pants_2'] = 4,
		['shoes_1'] = 10, ['shoes_2'] = 0,
		['chain_1'] = 126, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 1, ['bproof_2'] = 0,
		['mask_1'] = 169, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	RatownikMale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 344, ['torso_2'] = 0,
		['decals_1'] = 125, ['decals_2'] = 0,
		['arms'] = 88,
		['pants_1'] = 28, ['pants_2'] = 8,
		['shoes_1'] = 10, ['shoes_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	RatownikFemale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 344, ['torso_2'] = 0,
		['decals_1'] = 125, ['decals_2'] = 0,
		['arms'] = 88,
		['pants_1'] = 28, ['pants_2'] = 8,
		['shoes_1'] = 10, ['shoes_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	PielegniarzMale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 344, ['torso_2'] = 0,
		['decals_1'] = 125, ['decals_2'] = 0,
		['arms'] = 88,
		['pants_1'] = 28, ['pants_2'] = 8,
		['shoes_1'] = 10, ['shoes_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	PielegniarzFemale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 344, ['torso_2'] = 0,
		['decals_1'] = 125, ['decals_2'] = 0,
		['arms'] = 88,
		['pants_1'] = 28, ['pants_2'] = 8,
		['shoes_1'] = 10, ['shoes_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	KlapekMale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 39, ['torso_2'] = 0,
		['decals_1'] = 126, ['decals_2'] = 0,
		['arms'] = 85,
		['pants_1'] = 125, ['pants_2'] = 2,
		['shoes_1'] = 7, ['shoes_2'] = 2,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	KlapekFemale = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 39, ['torso_2'] = 0,
		['decals_1'] = 126, ['decals_2'] = 0,
		['arms'] = 85,
		['pants_1'] = 125, ['pants_2'] = 2,
		['shoes_1'] = 7, ['shoes_2'] = 2,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
}

function otwier_dressing()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'szafka',
        {
			align    = 'center',
            title    = 'Szatnia',
            elements = {
				{label = 'Profesor', value = 'ppal'},
				{label = 'Chirurg', value = 'ggume'},
				{label = 'Doktor', value = 'EO'},
				{label = 'Lekarz', value = 'lekarzynahere'},
				{label = 'Lekarz Specjalista', value = 'specjalny'},
				{label = 'Ratownik Medyczny', value = 'ratowniczek'},
				{label = 'Pielęgniarz', value = 'pielegniazr'},
				{label = 'Rekrut', value = 'klapek'}
            }
        },
		function(data, menu)
			if data.current.value == 'ppal' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.ProfesorMale)
					else
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.ProfesorFemale)
					end
				end)
			elseif data.current.value == 'ggume' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.ChirurgMale)
					else
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.ChirurgFemale)
					end
				end)
			elseif data.current.value == 'EO' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.DoktorMale)
					else
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.DoktorFemale)
					end
				end)
			elseif data.current.value == 'lekarzynahere' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.LekarzMale)
					else
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.LekarzFemale)
					end
				end)	
			elseif data.current.value == 'specjalny' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.SpecjalnyMale)
					else
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.SpecjalnyFemale)
					end
				end)		
			elseif data.current.value == 'ratowniczek' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.RatownikMale)
					else
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.RatownikFemale)
					end
				end)	
			elseif data.current.value == 'klapek' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.KlapekMale)
					else
						TriggerEvent('skinchanger:loadClothes', skin, Clothes.KlapekFemale)
					end
				end)
			end
        end,
        function(data, menu)
			menu.close()
        end
	)
end


function OpenVehicleSpawnerMenu(action)

	ESX.UI.Menu.CloseAll()
	if Config.EnableSocietyOwnedVehicles then

		local elements = {}
		ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)

			for i = 1, #vehicles, 1 do
				table.insert(elements, {label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']', value = vehicles[i]})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
				title	= _U('veh_menu'),
				align	= 'center',
				elements = elements,
			}, function(data, menu)
				menu.close()

				local vehicleProps = data.current.value
				ESX.Game.SpawnVehicle(vehicleProps.model, action.data.Pos, action.data.Heading, function(vehicle)
					DecorSetBool(vehicle, 'isSpawned', true)
					ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

					TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle,  -1)
					--local veh = GetVehiclePedIsUsing(GetPlayerPed(-1))
					local localVehPlate = string.lower(GetVehicleNumberPlateText(veh))
					local localVehLockStatus = GetVehicleDoorLockStatus(veh)
					TriggerEvent("ls:getOwnedVehicle", vehicle, localVehPlate, localVehLockStatus)
					
					
				end)

				TriggerServerEvent('esx_society:removeVehicleFromGarage', 'ambulance', vehicleProps)
			end, function(data, menu)
				menu.close()
				CurrentAction	 = 'vehicle_spawner_menu'
				CurrentActionMsg  = _U('veh_spawn')
				CurrentActionData = action
			end)
		end, 'ambulance')

	else -- not society vehicles
		local elements = {}
		for _, vehicle in ipairs(action.array) do
			if PlayerData.job.grade >= vehicle.grade then
				table.insert(elements, vehicle)
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
			title	= _U('veh_menu'),
			align	= 'center',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.Game.SpawnVehicle(data.current.model, action.data.Pos, action.data.Heading, function(vehicle)
				DecorSetBool(vehicle, 'isSpawned', true)
				SetVehicleNumberPlateText(vehicle, action.plate)
				SetVehicleMaxMods(vehicle, data.current.model, (data.current.livery or false), (data.current.offroad or false), (data.current.color or false), (data.current.extras or nil))

				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				TriggerServerEvent('ls:addOwner', action.plate)

				local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			end)
		end, function(data, menu)
			menu.close()
			CurrentAction	 = 'vehicle_spawner_menu'
			CurrentActionMsg  = _U('veh_spawn')
			CurrentActionData = action
		end)
	end
end


function OpenPharmacyMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {
		title    = _U('pharmacy_menu_title'),
		align    = 'center',
		elements = {
			{label = _U('pharmacy_take') .. ' ' .. _('medikit'), item = 'medikit', type = 'slider', value = 1, min = 1, max = 100},
			{label = _U('pharmacy_take') .. ' ' .. _('bandage'), item = 'bandage', type = 'slider', value = 1, min = 1, max = 100},
			{label = 'Weź GPS', xd = 'gps', item = 'gps', value = 1},
			--{label = 'Weź BodyCam', xd = 'bodycam', item = 'bodycam', value = 1},
			{label = 'Weź Tazer', xd = 'stungun', item = 'stungun', value = 1},
	}}, function(data, menu)
		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.item, data.current.value)
		if data.current.xd == 'stungun' then
			TriggerServerEvent('ambulance:jsdahbdhahudhahudhujashujdhahdhj')
		elseif data.current.xd == 'gps' then
			data = 'gps'
			ile = 1
			TriggerServerEvent('sdjaudajik', data, ile)
		elseif data.current.xd == 'bodycam' then
			data = 'bodycam'
			ile = 1
			TriggerServerEvent('sdjaudajik', data, ile)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenLSFDMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'lsfd',
	{
		title	= _U('lsfd_menu_title'),
		align	= 'center',
		elements = {
			{label = _U('lsfd_take') .. ' ' .. _('stungun'), value = 'WEAPON_STUNGUN', event = 'giveWeapon'},
			{label = _U('lsfd_take') .. ' ' .. _('fireextinguisher'), value = 'WEAPON_FIREEXTINGUISHER', event = 'giveWeapon'},
			{label = _U('lsfd_take') .. ' ' .. _('crowbar'), value = 'WEAPON_CROWBAR', event = 'giveWeapon'},
			{label = _U('lsfd_take') .. ' ' .. _('hatchet'), value = 'WEAPON_HATCHET', event = 'giveWeapon'}
		},
	}, function(data, menu)
		TriggerServerEvent('esx_ambulancejob:' .. data.current.event, data.current.value)
		
	end, function(data, menu)
		menu.close()
		CurrentAction	 = 'lsfd'
		CurrentActionMsg  = _U('open_lsfd')
		CurrentActionData = {}
	end
	)
end


AddEventHandler('playerSpawned', function()
	local ped = PlayerPedId()

	IsDead = false
	if FirstSpawn then
		TriggerServerEvent('esx_ambulancejob:duty', false)
		TriggerServerEvent('esx_ambulancejob:firstSpawn')

		exports.spawnmanager:setAutoSpawn(false) -- disable respawn
		FirstSpawn = false
	end
end)

RegisterNetEvent('esx_ambulancejob:character')
AddEventHandler('esx_ambulancejob:character', function(id)
	Character = id
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	if PlayerData.job and (PlayerData.job.name == 'offambulance' or PlayerData.job.name == 'ambulance') then
		TriggerServerEvent('esx_ambulancejob:character')
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	local lastJob = 'unemployed'
	if PlayerData.job then
		lastJob = PlayerData.job.name
	end

	PlayerData.job = job
	Citizen.Wait(1000)
	if job.name == 'ambulance' or lastJob == 'ambulance' then
		TriggerServerEvent('esx_ambulancejob:forceBlip')
		TriggerServerEvent('esx_policejob:forceBlip')
	end

	if PlayerData.job.name == 'ambulance' then
		SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("ARMY"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("SECURITY_GUARD"), GetHashKey('PLAYER'))
	elseif lastJob == 'ambulance' then
		SetRelationshipBetweenGroups(3, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("ARMY"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("COP"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(3, GetHashKey("SECURITY_GUARD"), GetHashKey('PLAYER'))
	end
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	if ESX.PlayerData and ESX.PlayerData.inventory then
		Citizen.CreateThread(function()
			Citizen.Wait(100)
			ESX.PlayerData = ESX.GetPlayerData()

			local found = false
			for i = 1, #ESX.PlayerData.inventory, 1 do
				if ESX.PlayerData.inventory[i].name == item.name then
					ESX.PlayerData.inventory[i] = item
					found = true
					break
				end
			end

			if not found then
				ESX.TriggerServerCallback('esx:isValidItem', function(status)
					if status then
						table.insert(ESX.PlayerData.inventory, item)
					end
				end, item.name)
			end
		end)
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	if ESX.PlayerData and ESX.PlayerData.inventory then
		Citizen.CreateThread(function()
			Citizen.Wait(100)
			ESX.PlayerData = ESX.GetPlayerData()

			local found = false
			for i = 1, #ESX.PlayerData.inventory, 1 do
				if ESX.PlayerData.inventory[i].name == item.name then
					ESX.PlayerData.inventory[i] = item
					found = true
					break
				end
			end

			if not found then
				ESX.TriggerServerCallback('esx:isValidItem', function(status)
					if status then
						table.insert(ESX.PlayerData.inventory, item)
					end
				end, item.name)
			end
		end)
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	OnPlayerDeath()
	ESX.UI.Menu.CloseAll()
end)

aimwlonczony = false
startcout = false

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(hospital)

  local playerPed = PlayerPedId()
  local coords	= GetEntityCoords(playerPed)
  local heading   = GetEntityHeading(playerPed)
  TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)

  Citizen.CreateThread(function()
	if not hospital then
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
		  Citizen.Wait(0)
		end
	end

	ESX.SetPlayerData('lastPosition', {
	  x = coords.x,
	  y = coords.y,
	  z = coords.z
	})

	TriggerServerEvent('esx:updateLastPosition', {
	  x = coords.x,
	  y = coords.y,
	  z = coords.z
	})

	RespawnPed(playerPed, {
	  x = coords.x,
	  y = coords.y,
	  z = coords.z,
	  heading = heading
	})

	TriggerEvent('es:setMoneyDisplay', 1.0)
	ESX.UI.HUD.SetDisplay(1.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
	IsDead = false
	ESX.ShowNotification("Nie mozesz uzyc broni przez 15sek")
	aimwlonczony = true	
  end)
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		while aimwlonczony do
		Citizen.Wait(5)
		DisableControlAction(0,24,true) -- disable attack
		  DisableControlAction(0,25,true) -- disable aim
		  DisableControlAction(0,37,true) -- disable TAB
		  DisableControlAction(0,47,true) -- disable weapon
		  DisableControlAction(0,58,true) -- disable weapon
		  DisableControlAction(0,263,true) -- disable melee
		  DisableControlAction(0,264,true) -- disable melee
		  DisableControlAction(0,257,true) -- disable melee
		  DisableControlAction(0,140,true) -- disable melee
		  DisableControlAction(0,141,true) -- disable melee
		  DisableControlAction(0,142,true) -- disable melee
		  DisableControlAction(0,143,true) -- disable melee
		  startcout = true
		end
		end
	end)
	
Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5)
			while startcout do
				Citizen.Wait(15000)
					aimwlonczony = false
					DisableControlAction(0,24,false) -- disable attack
					DisableControlAction(0,37,false) -- disable TAB
					DisableControlAction(0,25,false) -- disable aim
					DisableControlAction(0,47,false) -- disable weapon
					DisableControlAction(0,58,false) -- disable weapon
					DisableControlAction(0,263,false) -- disable melee
					DisableControlAction(0,264,false) -- disable melee
					DisableControlAction(0,257,false) -- disable melee
					DisableControlAction(0,140,false) -- disable melee
					DisableControlAction(0,141,false) -- disable melee
					DisableControlAction(0,142,false) -- disable melee
					DisableControlAction(0,143,false) -- disable melee
					startcout = false
					ESX.ShowNotification("Odzyskales sily na trzymanie broni")
			end
		end
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(zone)
  local ped = PlayerPedId()
  if zone == 'HospitalInteriorEntering1' then
	TeleportFadeEffect(ped, Config.Zones.HospitalInteriorEntering1.Teleport)
  elseif zone == 'HospitalInteriorExit1' then
	TeleportFadeEffect(ped, Config.Zones.HospitalInteriorExit1.Teleport)
  elseif zone == 'HospitalInteriorEntering2' then
	TeleportFadeEffect(ped, Config.Zones.HospitalInteriorEntering2.Teleport)
  elseif zone == 'HospitalInteriorExit2' then
	TeleportFadeEffect(ped, Config.Zones.HospitalInteriorExit2.Teleport)
  elseif zone == 'HospitalInteriorEntering3' then
	TeleportFadeEffect(ped, Config.Zones.HospitalInteriorEntering3.Teleport)
  elseif zone == 'HospitalInteriorExit3' then
	TeleportFadeEffect(ped, Config.Zones.HospitalInteriorExit3.Teleport)
  elseif zone == 'HospitalInteriorEntering4' then
	TeleportFadeEffect(ped, Config.Zones.HospitalInteriorEntering4.Teleport)
  elseif zone == 'HospitalInteriorExit4' then
	TeleportFadeEffect(ped, Config.Zones.HospitalInteriorExit4.Teleport)
  elseif zone == 'HospitalInteriorElevator1' or zone == 'HospitalInteriorElevator2' or zone == 'HospitalInteriorElevator3' or zone == 'HospitalInteriorElevator4' then
	CurrentAction	 = 'elevator_actions_menu'
	CurrentActionMsg  = _U('elevator')
	CurrentActionData = {current = tonumber(zone:sub(25, 25))}
  elseif zone == 'AmbulanceActions' or zone == 'AmbulanceActionsAdd' or zone == 'AmbulanceActions2' or zone == 'AmbulanceActions3' or zone == 'AmbulanceActions4' or zone == 'AmbulanceActions5' or zone == 'AmbulanceActions6' then
	CurrentAction	 = 'cloak_actions_menu'
	CurrentActionMsg  = _U('open_menu')
	CurrentActionData = {LSFD = false}
  elseif zone == 'FireActions' or zone == 'FireActions2' or zone == 'FireActions3' or zone == 'FireActions4' then
	CurrentAction	 = 'cloak_actions_menu'
	CurrentActionMsg  = _U('open_menu')
	CurrentActionData = {LSFD = true}
  elseif zone == 'BossActions' or zone == 'BossActions2' or zone == 'BossActions3' or zone == 'BossActions4' or zone == 'BossActions5' or zone == 'BossActions6' then
	CurrentAction	 = 'boss_actions_menu'
	CurrentActionMsg  = _U('open_menu')
	CurrentActionData = {}
  elseif zone == 'BossActionsExtra' or zone == 'BossActionsExtra2' or zone == 'BossActionsExtra3' or zone == 'BossActionsExtra4' then
	CurrentAction	 = 'lsfd_boss'
	CurrentActionMsg  = _U('open_menu')
	CurrentActionData = {}
  elseif zone == 'VehicleSpawner' then
	CurrentAction	 = 'vehicle_spawner_menu'
	CurrentActionMsg  = _U('veh_spawn')
	CurrentActionData = {array = Config.AuthorizedVehicles, data = Config.Zones.VehicleSpawnPoint, plate = "SAMS " .. GetRandomIntInRange(1000,9999)}
  elseif zone == 'VehicleSpawner2' then
	CurrentAction	 = 'vehicle_spawner_menu'
	CurrentActionMsg  = _U('veh_spawn')
	CurrentActionData = {array = Config.AuthorizedVehicles, data = Config.Zones.VehicleSpawnPoint2, plate = "SAMS " .. GetRandomIntInRange(1000,9999)}
  elseif zone == 'VehicleSpawnerExtra' then
	CurrentAction	 = 'vehicle_spawner_menu'
	CurrentActionMsg  = _U('veh_spawn')
	CurrentActionData = {array = Config.AuthorizedVehiclesExtra, data = Config.Zones.VehicleSpawnPointExtra, plate = "LSFD " .. GetRandomIntInRange(100,999)}
  elseif zone == 'VehicleSpawnerExtra2' then
	CurrentAction	 = 'vehicle_spawner_menu'
	CurrentActionMsg  = _U('veh_spawn')
	CurrentActionData = {array = Config.AuthorizedVehiclesExtra, data = Config.Zones.VehicleSpawnPointExtra2, plate = "LSFD " .. GetRandomIntInRange(100,999)}
  elseif zone == 'VehicleSpawnerExtra3' then
	CurrentAction	 = 'vehicle_spawner_menu'
	CurrentActionMsg  = _U('veh_spawn')
	CurrentActionData = {array = Config.AuthorizedVehiclesExtra, data = Config.Zones.VehicleSpawnPointExtra3, plate = "LSFD " .. GetRandomIntInRange(100,999)}
  elseif zone == 'VehicleSpawnerExtra4' then
	CurrentAction	 = 'vehicle_spawner_menu'
	CurrentActionMsg  = _U('veh_spawn')
	CurrentActionData = {array = Config.AuthorizedVehiclesExtra, data = Config.Zones.VehicleSpawnPointExtra4, plate = "LSFD " .. GetRandomIntInRange(100,999)}
  elseif zone == 'VehicleSpawner3' then
	CurrentAction	 = 'vehicle_spawner_menu'
	CurrentActionMsg  = _U('veh_spawn')
	CurrentActionData = {array = Config.AuthorizedVehicles, data = Config.Zones.VehicleSpawnPoint3, plate = "SAMS " .. GetRandomIntInRange(1000,9999)}
  elseif zone == 'VehicleSpawner4' then
	CurrentAction	 = 'vehicle_spawner_menu'
	CurrentActionMsg  = _U('veh_spawn')
	CurrentActionData = {array = Config.AuthorizedVehicles, data = Config.Zones.VehicleSpawnPoint4, plate = "SAMS " .. GetRandomIntInRange(1000,9999)}
  elseif zone == 'VehicleSpawner5' then
	CurrentAction	 = 'vehicle_spawner_menu'
	CurrentActionMsg  = _U('veh_spawn')
	CurrentActionData = {array = Config.AuthorizedVehicles, data = Config.Zones.VehicleSpawnPoint5, plate = "SAMS " .. GetRandomIntInRange(1000,9999)}
  elseif zone == 'VehicleSpawner6' then
	CurrentAction	 = 'vehicle_spawner_menu'
	CurrentActionMsg  = _U('veh_spawn')
	CurrentActionData = {array = Config.AuthorizedVehicles, data = Config.Zones.VehicleSpawnPoint6, plate = "SAMS " .. GetRandomIntInRange(1000,9999)}
  elseif zone == 'HeliSpawner' then
	CurrentAction	 = 'heli_spawner'
	CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby wezwać helikopter'
	CurrentActionData = {array = Config.Zones.HeliSpawnPoint, plate = "SAMS " .. GetRandomIntInRange(1000,9999), livery = 1}
  elseif zone == 'HeliSpawnerExtra' then
	CurrentAction	 = 'heli_spawner'
	CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby wezwać helikopter'
	CurrentActionData = {array = Config.Zones.HeliSpawnPointExtra, plate = "LSFD " .. GetRandomIntInRange(100,999), livery = 1}
  elseif zone == 'HeliSpawner2' then
	CurrentAction	 = 'heli_spawner'
	CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby wezwać helikopter'
	CurrentActionData = {array = Config.Zones.HeliSpawnPoint2, plate = "SAMS " .. GetRandomIntInRange(1000,9999), livery = 1}
  elseif zone == 'HeliSpawner3' then
	CurrentAction	 = 'heli_spawner'
	CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby wezwać helikopter'
	CurrentActionData = {array = Config.Zones.HeliSpawnPoint3, plate = "SAMS " .. GetRandomIntInRange(1000,9999), livery = 1}
  elseif zone == 'HeliSpawner4' then
	CurrentAction	 = 'heli_spawner'
	CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby wezwać helikopter'
	CurrentActionData = {array = Config.Zones.HeliSpawnPoint4, plate = "SAMS " .. GetRandomIntInRange(1000,9999), livery = 1}
  elseif zone == 'HeliSpawner5' then
	CurrentAction	 = 'heli_spawner'
	CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby wezwać helikopter'
	CurrentActionData = {array = Config.Zones.HeliSpawnPoint5, plate = "SAMS " .. GetRandomIntInRange(1000,9999), livery = 1}
  elseif zone == 'Pharmacy' or zone == 'Pharmacy2' or zone == 'Pharmacy3' or zone == 'Pharmacy4' or zone == 'Pharmacy5' or zone == 'Pharmacy6' then
	CurrentAction	 = 'pharmacy'
	CurrentActionMsg  = _U('open_pharmacy')
	CurrentActionData = {}
  elseif zone == 'LSFD' or zone == 'LSFD2' or zone == 'LSFD3' or zone == 'LSFD4' then
	CurrentAction	 = 'lsfd'
	CurrentActionMsg  = _U('open_lsfd')
	CurrentActionData = {}
  elseif zone == 'Schowek' or zone == 'SchowekAdd' or zone == 'Schowek2' or zone == 'SchowekExtra' or zone == 'SchowekExtra2' or zone == 'SchowekExtra3' or zone == 'SchowekExtra4' or zone == 'Schowek3' or zone == 'Schowek4' or zone == 'Schowek5' or zone == 'Schowek6' then
	CurrentAction	 = 'menu_schowek'
	CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby otworzyć schowek'
	CurrentActionData = {}
  elseif zone == 'VehicleDeleter' or zone == 'VehicleDeleter2' or zone == 'VehicleDeleterExtra' or zone == 'VehicleDeleterExtra2' or zone == 'VehicleDeleterExtra3' or zone == 'VehicleDeleterExtra4' or zone == 'VehicleDeleter3' or zone == 'VehicleDeleter4' or zone == 'VehicleDeleter5' or zone == 'VehicleDeleter6' or zone == 'HeliDeleter' or zone == 'HeliDeleterExtra' or zone == 'HeliDeleter2' or zone == 'HeliDeleter3' or zone == 'HeliDeleter4' or zone == 'HeliDeleter5' then
	if IsPedInAnyVehicle(ped, false) then
	  local coords	= GetEntityCoords(ped, true)

	  local vehicle, distance = ESX.Game.GetClosestVehicle({
		x = coords.x,
		y = coords.y,
		z = coords.z
	  })
	  if distance ~= -1 and distance <= 1.0 then
		CurrentAction	 = 'delete_vehicle'
		CurrentActionMsg  = _U('store_veh')
		CurrentActionData = {vehicle = vehicle}
	  end
	end
  end
end)

function getDeathStatus()
	return IsDead
end

function FastTravel(pos)
	TeleportFadeEffect(PlayerPedId(), pos)
end

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(zone)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

-- Create blips
Citizen.CreateThread(function()
  local blip
  for _, it in ipairs(Config.Blips) do
	blip = AddBlipForCoord(it.Pos.x, it.Pos.y, it.Pos.z)
	SetBlipSprite (blip, it.Sprite)
	SetBlipDisplay(blip, it.Display)
	SetBlipScale  (blip, it.Scale)
	SetBlipColour (blip, it.Colour)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(it.Label)
	EndTextCommandSetBlipName(blip)
	Citizen.Wait(0)
  end
end)

local cache = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		cache = {}

		local coords = GetEntityCoords(PlayerPedId(), true)
		for k, v in pairs(Config.Zones) do
			local distance = #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z))
			if distance < Config.DrawDistance then
				v.distance = distance
				cache[k] = v
			end
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
  while true do
	Citizen.Wait(0)
	for k, v in pairs(cache) do
	  if v.Type then
		if PlayerData.job ~= nil and (PlayerData.job.name == 'ambulance' or (PlayerData.job.name == 'offambulance' and PlayerData.job.grade > 3)) then
			local mk = Config.MarkerSize
			if k == 'VehicleDeleter' or k == 'VehicleDeleterExtra' or k == 'VehicleDeleterExtra2' or k == 'VehicleDeleterExtra3' or k == 'VehicleDeleterExtra4' or k == 'VehicleDeleter2' or k == 'VehicleDeleter3' or k == 'VehicleDeleter4' or k == 'VehicleDeleter5' or k == 'VehicleDeleter6' or k == 'HeliDeleter' or k == 'HeliDeleterExtra' or k == 'HeliDeleter2' or k == 'HeliDeleter3' or k == 'HeliDeleter4' or k == 'HeliDeleter5' then
				mk = Config.DeleteMarkerSize
			end

			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, mk.x, mk.y, mk.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
		elseif ((k ~= 'AmbulanceActions' and k ~= 'AmbulanceActionsAdd' and k ~= 'AmbulanceActions2' and k ~= 'AmbulanceActions3' and k ~= 'AmbulanceActions4' and k ~= 'AmbulanceActions5' and k ~= 'AmbulanceActions6' and k ~= 'FireActions' and k ~= 'FireActions2' and k ~= 'FireActions3' and k ~= 'FireActions4' and k ~= 'Schowek' and k ~= 'SchowekAdd' and k ~= 'Schowek2' and k ~= 'SchowekExtra' and k ~= 'SchowekExtra2' and k ~= 'SchowekExtra3' and k ~= 'SchowekExtra4' and k ~= 'Schowek3' and k ~= 'Schowek4' and k ~= 'Schowek5' and k ~= 'Schowek6') or (PlayerData.job ~= nil and PlayerData.job.name == 'offambulance')) and k ~= 'VehicleSpawner' and k ~= 'VehicleSpawnerExtra' and k ~= 'VehicleSpawnerExtra2' and k ~= 'VehicleSpawnerExtra3' and k ~= 'VehicleSpawnerExtra4' and k ~= 'VehicleSpawner2' and k ~= 'VehicleSpawner3' and k ~= 'VehicleSpawner4' and k ~= 'VehicleSpawner5' and k ~= 'VehicleSpawner6' and k ~= 'VehicleDeleter' and k ~= 'VehicleDeleterExtra' and k ~= 'VehicleDeleterExtra2' and k ~= 'VehicleDeleterExtra3' and k ~= 'VehicleDeleterExtra4' and k ~= 'VehicleDeleter2' and k ~= 'VehicleDeleter3' and k ~= 'VehicleDeleter4' and k ~= 'VehicleDeleter5' and k ~= 'VehicleDeleter6' and k ~= 'HeliSpawner' and k ~= 'HeliDeleter' and k ~= 'HeliSpawnerExtra' and k ~= 'HeliDeleterExtra' and k ~= 'HeliSpawner2' and k ~= 'HeliDeleter2' and k ~= 'HeliSpawner3' and k ~= 'HeliDeleter3' and k ~= 'HeliSpawner4' and k ~= 'HeliSpawner5' and k ~= 'HeliDeleter4' and k ~= 'HeliDeleter5' and k ~= 'Pharmacy' and k ~= 'Pharmacy2' and k ~= 'Pharmacy3' and k ~= 'Pharmacy4' and k ~= 'Pharmacy5' and k ~= 'Pharmacy6' and k ~= 'LSFD' and k ~= 'LSFD2' and k ~= 'LSFD3' and k ~= 'LSFD4' and k ~= 'BossActions' and k ~= 'BossActionsExtra' and k ~= 'BossActionsExtra2' and k ~= 'BossActionsExtra3' and k ~= 'BossActionsExtra4' and k ~= 'BossActions2' and k ~= 'BossActions3' and k ~= 'BossActions4' and k ~= 'BossActions5' and k ~= 'BossActions6' then
			DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
		end
	  end
	end
  end
end)

RegisterNetEvent('esx_ambulancejob:notifyDeath')
AddEventHandler('esx_ambulancejob:notifyDeath', function(who)
	ESX.ShowNotification('~r~Użyto panic button (10-13) przy radiu: ~s~' .. who)
	Citizen.CreateThread(function()
		local sound = GetSoundId()
		PlaySoundFrontend(sound, "Start_Squelch", "CB_RADIO_SFX", 1)
		Citizen.Wait(2000)

		StopSound(sound)
		ReleaseSoundId(sound)
	end)
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		
		local isInMarker, currentZone = false, nil
		for k,v in pairs(cache) do
			if PlayerData.job ~= nil and (PlayerData.job.name == 'ambulance' or (PlayerData.job.name == 'offambulance' and PlayerData.job.grade > 3)) then
				local mk = Config.MarkerSize
				if k == 'VehicleDeleter' or k == 'VehicleDeleterExtra' or k == 'VehicleDeleterExtra2' or k == 'VehicleDeleterExtra3' or k == 'VehicleDeleterExtra4' or k == 'VehicleDeleter2' or k == 'VehicleDeleter3' or k == 'VehicleDeleter4' or k == 'VehicleDeleter5' or k == 'VehicleDeleter6' or k == 'HeliDeleter' or k == 'HeliDeleterExtra' or k == 'HeliDeleter2' or k == 'HeliDeleter3' or k == 'HeliDeleter4' or k == 'HeliDeleter5' then
					mk = Config.DeleteMarkerSize
				end

				if(v.distance < mk.x) then
					isInMarker  = true
					currentZone = k
				end
			elseif ((k ~= 'AmbulanceActions' and k ~= 'AmbulanceActionsAdd' and k ~= 'AmbulanceActions2' and k ~= 'AmbulanceActions3' and k ~= 'AmbulanceActions4' and k ~= 'AmbulanceActions5' and k ~= 'AmbulanceActions6' and k ~= 'FireActions' and k ~= 'FireActions2' and k ~= 'FireActions3' and k ~= 'FireActions4' and k ~= 'Schowek' and k ~= 'SchowekAdd' and k ~= 'Schowek2' and k ~= 'SchowekExtra' and k ~= 'SchowekExtra2' and k ~= 'SchowekExtra3' and k ~= 'SchowekExtra4' and k ~= 'Schowek3' and k ~= 'Schowek4' and k ~= 'Schowek5' and k ~= 'Schowek6') or (PlayerData.job ~= nil and PlayerData.job.name == 'offambulance')) and k ~= 'VehicleSpawner' and k ~= 'VehicleSpawnerExtra' and k ~= 'VehicleSpawnerExtra2' and k ~= 'VehicleSpawnerExtra3' and k ~= 'VehicleSpawnerExtra4' and k ~= 'VehicleSpawner2' and k ~= 'VehicleSpawner3' and k ~= 'VehicleSpawner4' and k ~= 'VehicleSpawner5' and k ~= 'VehicleSpawner6' and k ~= 'VehicleDeleter' and k ~= 'VehicleDeleterExtra' and k ~= 'VehicleDeleterExtra2' and k ~= 'VehicleDeleterExtra3' and k ~= 'VehicleDeleterExtra4' and k ~= 'VehicleDeleter2' and k ~= 'VehicleDeleter3' and k ~= 'VehicleDeleter4' and k ~= 'VehicleDeleter5' and k ~= 'VehicleDeleter6' and k ~= 'HeliSpawner' and k ~= 'HeliDeleter' and k ~= 'HeliSpawnerExtra' and k ~= 'HeliDeleterExtra' and k ~= 'HeliSpawner2' and k ~= 'HeliDeleter2' and k ~= 'HeliSpawner3' and k ~= 'HeliDeleter3' and k ~= 'HeliSpawner4' and k ~= 'HeliSpawner5' and k ~= 'HeliDeleter4' and k ~= 'HeliDeleter5' and k ~= 'Pharmacy' and k ~= 'Pharmacy2' and k ~= 'Pharmacy3' and k ~= 'Pharmacy4' and k ~= 'Pharmacy5' and k ~= 'Pharmacy6' and k ~= 'LSFD' and k ~= 'LSFD2' and k ~= 'LSFD3' and k ~= 'LSFD4' and k ~= 'BossActions' and k ~= 'BossActionsExtra' and k ~= 'BossActionsExtra2' and k ~= 'BossActionsExtra3' and k ~= 'BossActionsExtra4' and k ~= 'BossActions2' and k ~= 'BossActions3' and k ~= 'BossActions4' and k ~= 'BossActions5' and k ~= 'BossActions6' then
				if(v.distance < Config.MarkerSize.x) then
					isInMarker  = true
					currentZone = k
				end
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			LastZone				= currentZone
			TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentZone)
		end
		
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_ambulancejob:hasExitedMarker', LastZone)
		end
	end
end)

-- Key Controls
CreateThread(function()
  while true do
	Citizen.Wait(1)
	if CurrentAction ~= nil then
	  SetTextComponentFormat('STRING')
	  AddTextComponentString(CurrentActionMsg)

	  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	  if IsControlJustReleased(0, Keys['E']) then
		if CurrentAction == 'elevator_actions_menu' then
			local elements = {
				{label = "- Zamknij -", value = 0},
				{label = "Garaz", value = 1},
				{label = "Piętro #1", value = 2},
			}
			for i, element in ipairs(elements) do
				if element.value == CurrentActionData.current then
					table.remove(elements, i)
					break
				end
			end

			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_elevator', {
				title = 'Winda',
				align = 'center',
				elements = elements
			}, function (data, menu)
				menu.close()
				if data.current.value ~= 0 then
					TeleportFadeEffect(PlayerPedId(), Config.Zones['HospitalInteriorElevator' .. data.current.value].Teleport)
				end
			end, function (data, menu)
				menu.close()
			end)
		elseif PlayerData.job ~= nil and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offambulance') then
			if CurrentAction == 'cloak_actions_menu' then
			  OpenCloakroomMenu(CurrentActionData.LSFD)
			elseif CurrentAction == 'boss_actions_menu' then
				if PlayerData.job.grade_name == 'boss' then
					TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
						menu.close()
					end)
				end
			end
			if PlayerData.job.name == 'ambulance' or (PlayerData.job.name == 'offambulance' and PlayerData.job.grade > 3) then
			  if CurrentAction == 'vehicle_spawner_menu' then
				OpenVehicleSpawnerMenu(CurrentActionData)
			  end
			  if CurrentAction == 'heli_spawner' then
				if not IsAnyVehicleNearPoint(CurrentActionData.array.Pos.x, CurrentActionData.array.Pos.y, CurrentActionData.array.Pos.z, 3.0)
					and PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then
					ESX.Game.SpawnVehicle('ms_heli', {
						x = CurrentActionData.array.Pos.x,
						y = CurrentActionData.array.Pos.y,
						z = CurrentActionData.array.Pos.z
					}, CurrentActionData.array.Heading, function(vehicle)
						SetVehicleModKit(vehicle, 0)
						SetVehicleLivery(vehicle, CurrentActionData.livery)

						SetVehicleNumberPlateText(vehicle, CurrentActionData.plate)
						TriggerServerEvent('ls:addOwner', CurrentActionData.plate)

						local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
					end)
				end
			  elseif CurrentAction == 'pharmacy' then
				OpenPharmacyMenu()
			  elseif CurrentAction == 'lsfd' then
				OpenLSFDMenu()
			  elseif CurrentAction == 'fast_travel_goto_top' or CurrentAction == 'fast_travel_goto_bottom' then
				FastTravel(CurrentActionData.pos)
			  elseif CurrentAction == 'delete_vehicle' then
				if Config.EnableSocietyOwnedVehicles then
				  local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
				  TriggerServerEvent('esx_society:putVehicleInGarage', 'ambulance', vehicleProps)
				end
				ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
			  end
			end
		end

		CurrentAction = nil
	  end
	end

	if IsControlJustReleased(0, Keys['F6']) and not IsDead and PlayerData.job and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offambulance') then
	  OpenMobileAmbulanceActionsMenu()
	end

	if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy and PlayerData.job and PlayerData.job.name == 'ambulance' and PlayerData.job.grade == 2 and not IsDead then
		ESX.ShowNotification('~r~Zadanie unieważnione')
		ESX.ClearTimeout(CurrentTask.Task)
		ClearPedTasks(PlayerPedId())
		CurrentTask.Busy = false
	end

	if IsControlJustReleased(0, Keys['DELETE']) and PlayerData.job and PlayerData.job.name == 'ambulance' and PlayerData.job.grade == 2 and not IsDead then
		exports['esx_mecanojob']:OnFlatbedWork(`ambflatbed`)
	end
  end
end)

RegisterNetEvent('esx_ambulancejob:requestDeath')
AddEventHandler('esx_ambulancejob:requestDeath', function()
	if Config.AntiCombatLog then
		Citizen.Wait(6000)
		local playerPed = GetPlayerPed(-1)
		Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, playerPed, 0)
		ESX.ShowNotification('~r~Jesteś nieprzytomny/a, ponieważ przed wyjściem z serwera Twoja postać miała BW')
	end
end)

-- String string
function stringsplit(inputstr, sep)
  if sep == nil then
	  sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
	  t[i] = str
	  i = i + 1
  end
  return t
end