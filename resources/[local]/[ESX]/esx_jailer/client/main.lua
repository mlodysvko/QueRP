local JailTime = 0
local JailLocation = Config.JailLocation
local SpawnedPeds = {}

local isCutscene = false
local jobDestination = nil
local CurrentAction = nil
local hasAlreadyEnteredMarker = false
local jobBlip = nil
local jobNumber = nil
local isWorking = false
local working = false

function getJailStatus()
	return JailTime > 0
end

ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

function LoadModel(model)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
end

function LoadAnim(animDict)
	RequestAnimDict(animDict)

	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

local isHandcuffed = false
local HandcuffProp = nil

function SpawnCam(cam)
	RenderScriptCams(false, false, 0, true, true)

	local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(camera, cam.coord.x, cam.coord.y, cam.coord.z)
	SetCamRot(camera, cam.rot.x, cam.rot.y, cam.rot.z)

	RenderScriptCams(true, false, 0, true, true)
end

function CuffAnim()
	isHandcuffed = not isHandcuffed

	local playerPed = PlayerPedId()

	if isHandcuffed then
		RequestAnimDict('rcmme_amanda1')

		while not HasAnimDictLoaded('rcmme_amanda1') do
			Citizen.Wait(100)
		end

		TaskPlayAnim(playerPed, 'rcmme_amanda1', 'stand_loop_ama', 8.0, 3.0, -1, 50, 0, 0, 0, 0)

		if not DoesEntityExist(HandcuffProp) then
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			HandcuffProp = Citizen.InvokeNative(0x509D5878EB39E842, `p_cs_cuffs_02_s`, x, y, z,  true,  true, true)
			AttachEntityToEntity(HandcuffProp, playerPed, GetPedBoneIndex(playerPed, 60309), -0.0302, 0.0, 0.070, 110.0, 90.0, 100.0, 1, 0, 0, 0, 0, 1)
		end

		SetEnableHandcuffs(playerPed, true)
		DisablePlayerFiring(playerPed, true)
		SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true) -- unarm player
		SetPedCanPlayGestureAnims(playerPed, false)
		DisplayRadar(false)
	else
		if DoesEntityExist(HandcuffProp) then
			DeleteEntity(HandcuffProp)
			HandcuffProp = nil
		end
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true) -- unarm player
		SetPedCanPlayGestureAnims(playerPed, true)
	end
end

RegisterNetEvent('esx_jailer:afterConnect')
AddEventHandler('esx_jailer:afterConnect', function(jailTime)
	if JailTime > 0 then
		return
	end

	JailTime =  math.floor(jailTime)
	local sourcePed = PlayerPedId()
	SetCanAttackFriendly(sourcePed, false, false)
	NetworkSetFriendlyFireOption(false)
	SetRelationshipBetweenGroups(1, `PRISONER`, `PLAYER`)
	
	if DoesEntityExist(sourcePed) then
	
		CreateThread(function()
			SetEntityCoords(sourcePed, 1759.31,  2513.23,  45.76)
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].female)
				end
			end)
			
			SetEveryoneIgnorePlayer(PlayerId(), true)
			
			while JailTime > 0 do
				sourcePed = PlayerPedId()
				Citizen.InvokeNative(0x4899CB088EDF59B8, sourcePed, true)
				if IsPedInAnyVehicle(sourcePed, false) then
					Citizen.InvokeNative(0xAAA34F8A7CB32098, sourcePed)
				end

				if JailTime % 90 == 0 then
					TriggerServerEvent('esx_jailer:updateRemaining', JailTime)
				end

				for i = 1, 10 do
					JailTime = JailTime - 1
					Citizen.Wait(1000)
				end

				if #(GetEntityCoords(sourcePed) - vec3(JailLocation.x, JailLocation.y, JailLocation.z)) > 250.0 then
					SetEntityCoords(sourcePed, JailLocation.x, JailLocation.y, JailLocation.z)					
					TriggerEvent('chatMessage', _U('judge'), { 147, 196, 109 }, _U('escape_attempt'))
				end
			end

			TriggerServerEvent('esx_jailer:unjailTime', -1)
			
			
		end)
		
	end
end)

RegisterNetEvent('esx_jailer:unjailAfterChange')
AddEventHandler('esx_jailer:unjailAfterChange', function()
	SetEntityCoords(PlayerPedId(), Config.JailBlip.x, Config.JailBlip.y, Config.JailBlip.z)
	JailTime = 0

	working = false
	RemoveBlip(jobBlip)
	jobNumber = nil
	jobDestination = nil
	
	SetCanAttackFriendly(PlayerPedId(), true, false)
	NetworkSetFriendlyFireOption(true)	
	SetRelationshipBetweenGroups(3, `PRISONER`, `PLAYER`)

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end)

RegisterNetEvent('esx_jailer:pierdl')
AddEventHandler('esx_jailer:pierdl', function(jailTime)
	if JailTime > 0 then
		return
	end

	JailTime = jailTime
	local sourcePed = PlayerPedId()
	SetCanAttackFriendly(sourcePed, false, false)
	NetworkSetFriendlyFireOption(false)
	SetRelationshipBetweenGroups(1, `PRISONER`, `PLAYER`)
	
	if DoesEntityExist(sourcePed) then
		CreateThread(function()
			isCutscene = true
		
			Citizen.InvokeNative(0xCEA04D83135264CC, sourcePed, 0)
			ClearPedBloodDamage(sourcePed)
			ResetPedVisibleDamage(sourcePed)
			ClearPedLastWeaponDamage(sourcePed)
			ResetPedMovementClipset(sourcePed, 0)
			
			local PlayerConfig = Config.ArrestedCutScene.Player
			DoScreenFadeOut(50)

			RequestModel(`s_m_m_prisguard_01`)

			while not HasModelLoaded(`s_m_m_prisguard_01`) do
				Citizen.Wait(1)
			end

			SetEntityCoords(PlayerPedId(), PlayerConfig.coord.x, PlayerConfig.coord.y, PlayerConfig.coord.z-0.95)
			SetEntityHeading(PlayerPedId(), PlayerConfig.head)

			Citizen.InvokeNative(0x4899CB088EDF59B8, PlayerPedId(), true)

			for i=1, #Config.ArrestedCutScene.NPC, 1 do
				local guardConfig = Config.ArrestedCutScene.NPC[i]		

				local gurad = Citizen.InvokeNative(0xD49F9B0955C367DE, 5, GetHashKey(guardConfig.ped), guardConfig.coord.x, guardConfig.coord.y, guardConfig.coord.z, guardConfig.head, true)

				Citizen.InvokeNative(0xBF0FD6E56C964FCB, gurad, `WEAPON_CARBINERIFLE`, 100, true, true)
				TaskGoToCoordAnyMeans(gurad, guardConfig.dest.x, guardConfig.dest.y, guardConfig.dest.z, 0.7, false, false, 786603, 1.0)
				table.insert(SpawnedPeds, {e = gurad, c = guardConfig})
			end

			TaskGoToCoordAnyMeans(PlayerPedId(), PlayerConfig.dest.x, PlayerConfig.dest.y, PlayerConfig.dest.z, 0.15, false, false, 786603, 1.0)
			SetEntityMaxSpeed(PlayerPedId(), 1.6)
			CuffAnim()
			
			TriggerEvent('route68:kino_state', true)
			
			SpawnCam(Config.ArrestedCutScene.Cams["Cam0"])
			Citizen.Wait(2500)
			DoScreenFadeIn(450)
			Citizen.Wait(2500)
			SpawnCam(Config.ArrestedCutScene.Cams["Cam1"])
			Citizen.Wait(5000)
			SpawnCam(Config.ArrestedCutScene.Cams["Cam2"])
			Citizen.Wait(6000)
			SetEntityMaxSpeed(PlayerPedId(), 100.6)
			DoScreenFadeOut(1800)
			Citizen.Wait(2000)
			RenderScriptCams(false,  false,  0,  true,  true)

			for i=1, #SpawnedPeds, 1 do
				DeleteEntity(SpawnedPeds[i].e)
			end	

			SetEntityCoords(PlayerPedId(), Config.PrisonZones["SPos"].coord.x, Config.PrisonZones["SPos"].coord.y, Config.PrisonZones["SPos"].coord.z-0.95)
			SetEntityHeading(PlayerPedId(), Config.PrisonZones["SPos"].heading)
			Citizen.Wait(500)
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].female)
				end
			end)
			DoScreenFadeIn(450)
			--------------- NEXT STAGE
			TaskGoToCoordAnyMeans(PlayerPedId(), 1757.14,  2513.82,  45.57, 1.0, false, false, 786603, 1.0)
			
			local guardConfig = Config.PrisonZones["9AB"].peds

			local gurad = Citizen.InvokeNative(0xD49F9B0955C367DE, 5, GetHashKey(guardConfig.ped), guardConfig.coord.x, guardConfig.coord.y, guardConfig.coord.z, guardConfig.head, true)

			FreezeEntityPosition(gurad, true)
			Citizen.InvokeNative(0xBF0FD6E56C964FCB, gurad, `WEAPON_CARBINERIFLE`, 100, true, true)

			SetFollowPedCamViewMode(4)
			Citizen.Wait(26000)
			SpawnCam(Config.ArrestedCutScene.Cams["Cam3"])
			TaskGoToCoordAnyMeans(PlayerPedId(), 1759.31,  2513.23,  45.76, 1.0, false, false, 786603, 1.0)
			Citizen.Wait(1000)	
			FreezeEntityPosition(gurad, false)
			RequestAnimDict("mp_arresting")
			Citizen.Wait(1000)
			SetCurrentPedWeapon(gurad, `WEAPON_UNARMED`, true) -- unarm player
			TaskPlayAnim(gurad, "mp_arresting", "a_uncuff", 8.0, 3.0, 2000, 26, 1, 0, 0, 0)
			Citizen.Wait(2000)
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'uncuff', 0.3)
			CuffAnim()
			ClearPedSecondaryTask(PlayerPedId())
			RenderScriptCams(false,  false,  0,  true,  true)
			
			TriggerEvent('route68:kino_state', false)
			
			SetFollowPedCamViewMode(1)
			DoScreenFadeOut(200)
			Citizen.Wait(500)
			DeleteEntity(gurad)
			Citizen.Wait(1500)
			DoScreenFadeIn(800)
			SetEveryoneIgnorePlayer(PlayerId(), true)
			
			isCutscene = false
			
			while JailTime > 0 do
				sourcePed = PlayerPedId()
				Citizen.InvokeNative(0x4899CB088EDF59B8, sourcePed, true)
				if IsPedInAnyVehicle(sourcePed, false) then
					Citizen.InvokeNative(0xAAA34F8A7CB32098, sourcePed)
				end

				if JailTime % 90 == 0 then
					TriggerServerEvent('esx_jailer:updateRemaining', JailTime)
				end

				for i = 1, 10 do
					JailTime = JailTime - 1
					Citizen.Wait(1000)
				end

				if #(GetEntityCoords(sourcePed) - vec3(JailLocation.x, JailLocation.y, JailLocation.z)) > 250.0 then
					SetEntityCoords(sourcePed, JailLocation.x, JailLocation.y, JailLocation.z)
					TriggerEvent('chatMessage', _U('judge'), { 147, 196, 109 }, _U('escape_attempt'))
				end
			end

			TriggerServerEvent('esx_jailer:unjailTime', -1)
		end)
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(5000)
		
		if JailTime > 0 then	
			ClearAreaOfPeds(JailLocation.x, JailLocation.y, JailLocation.z, 400.0, 1)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if JailTime > 0 and not isCutscene then			
			draw2dText(_U('remaining_msg', ESX.Round(JailTime)), { 0.275, 0.955 } )	
		else
			Citizen.Wait(1000)
		end
	end
end)

function draw2dText(text, pos)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(table.unpack(pos))
end

RegisterNetEvent('esx_jailer:unjail')
AddEventHandler('esx_jailer:unjail', function()
	SetEntityCoords(PlayerPedId(), Config.JailBlip.x, Config.JailBlip.y, Config.JailBlip.z)
	JailTime = 0

	working = false
	RemoveBlip(jobBlip)
	jobNumber = nil
	jobDestination = nil
	
	SetCanAttackFriendly(PlayerPedId(), true, false)
	NetworkSetFriendlyFireOption(true)	
	SetRelationshipBetweenGroups(3, `PRISONER`, `PLAYER`)

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(spawn)
	local status = 0
	while true do
		if status == 0 then
			status = 1
			TriggerEvent('misiaczek:load', function(result)
				if result == 3 then
					status = 2
				else
					status = 0
				end
			end)
		end
		
		Citizen.Wait(200)
		if status == 2 then
			break
		end
	end
	
	TriggerServerEvent('esx_jailer:checkJail')
end)

CreateThread(function()
	local blip = AddBlipForCoord(Config.JailBlip.x, Config.JailBlip.y, Config.JailBlip.z)
	SetBlipSprite(blip, 237)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 1.5)
	SetBlipColour(blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(_U('blip_name'))
	EndTextCommandSetBlipName(blip)
	
	Citizen.Wait(5000)
	
	TriggerServerEvent('esx_jailer:checkJail')
end)

--jobBlip

CreateThread(function()
	while true do
		Citizen.Wait(1)
		if JailTime > 0 and not isCutscene then
			if not working then
				CreateJob()
			else
				local isInMarker = false
				local coords = GetEntityCoords(PlayerPedId())	
				if #(coords - vec3(jobDestination.Pos.x, jobDestination.Pos.y, jobDestination.Pos.z)) < 100 then
					DrawMarker(0, jobDestination.Pos.x, jobDestination.Pos.y, jobDestination.Pos.z + 3.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 173, 255, 153, 165, false, true, 2, false, false, false, false)
					if #(coords - vec3(jobDestination.Pos.x, jobDestination.Pos.y, jobDestination.Pos.z)) < 1.5 then
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby rozpocząć ~y~pracę~s~')
						if IsControlJustReleased(0, 38) and not isWorking then
							StartWork()
						end
					end
				end
			end			
		end
	end
end)

function CreateJob()
	local newJob
	repeat
		newJob = math.random(1, #Config.Jobs.List)
		Citizen.Wait(1)
	until newJob ~= jobNumber

	working = true
	if jobBlip then
		RemoveBlip(jobBlip)
	end
	
	jobNumber = newJob
	jobDestination = Config.Jobs.List[jobNumber]
	jobBlip = AddBlipForCoord(jobDestination.Pos.x, jobDestination.Pos.y, jobDestination.Pos.z)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Praca więzienna ' .. jobDestination.Name)
	EndTextCommandSetBlipName(jobBlip)
end

function StartWork()
	isWorking = true
	local delay = math.random(5000, 10000)
	ESX.ShowAdvancedNotification('Wiezienie', 'Praca', 'Pracowanie...')
	FreezeEntityPosition(PlayerPedId(), true)

	CreateThread(function()
		Citizen.Wait(delay)
		isWorking = false
		FreezeEntityPosition(PlayerPedId(), false)
		if JailTime == 0 then
			return
		end
		local minusTime = math.random(15,30)
		ESX.ShowAdvancedNotification('Wiezienie', 'Praca', 'Od twojej odsiadki odjeto ~g~' .. minusTime .. ' ~w~dni!')
		JailTime = JailTime - minusTime
		CreateJob()
	end)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.001+ factor, 0.03, 41, 11, 41, 90)
end