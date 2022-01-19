ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

CreateThread(function() while true do Citizen.Wait(1) HideHudComponentThisFrame(14) HideHudComponentThisFrame(1) HideHudComponentThisFrame(2) HideHudComponentThisFrame(3) HideHudComponentThisFrame(4) HideHudComponentThisFrame(5) HideHudComponentThisFrame(6) HideHudComponentThisFrame(7) HideHudComponentThisFrame(8) HideHudComponentThisFrame(9) HideHudComponentThisFrame(13) HideHudComponentThisFrame(17) N_0x4757f00bc6323cfe(-1553120962, 0.0) end end)
CreateThread(function() while true do Citizen.Wait(1) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_PISTOL'), 0.54) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_UNARMED'), 0.65) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_COMBATPISTOL'), 0.54) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_COMPACTRIFLE'), 0.55) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_PISTOL_MK2'), 0.48) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_SNSPISTOL_MK2'), 0.43)N_0x4757f00bc6323cfe(GetHashKey('WEAPON_HEAVYPISTOL'), 0.70) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_VINTAGEPISTOL'), 0.54) N_0x4757f00bc6323cfe(GetHashKey('WEAPON_SNSPISTOL'), 0.45) end end)
CreateThread(function()
	local hour, minute = 0, 0
	while true do
		Citizen.Wait(0)
		AllowPauseMenuWhenDeadThisFrame()

		N_0x7669f9e39dc17063()
		for _, iter in ipairs({1, 2, 3, 4, 6, 7, 8, 9, 13, 17, 18}) do -- 6
			HideHudComponentThisFrame(iter)
		end

		local ped = PlayerPedId()
		if IsPedBeingStunned(ped) then
			SetPedMinGroundTimeForStungun(ped, 6000)
		end

		local show = nil
		local pid = PlayerId()

		local status, weapon = GetCurrentPedWeapon(ped, true)
		if status == 1 and IsPlayerFreeAiming(pid) then
			if Config.DisplayCrosshair[weapon] then
				show = true
			elseif not Config.Melees[weapon] then
				show = false
			end
		end

		local inVehicle = IsPedInAnyVehicle(ped, false)
		if not show then
			HideHudComponentThisFrame(14)
			if show ~= nil and not inVehicle then
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 142, true)
				DisableControlAction(0, 257, true)
				DisableControlAction(0, 263, true)
				DisableControlAction(0, 264, true)
			end

			if Config.FirstPersonShoot then
				local aiming, shooting = IsControlPressed(0, 25), IsPedShooting(ped)
				if aiming or shooting then
					if shooting and not aiming then
						isShooting = true
						aimTimer = 0
					else
						isShooting = false
					end

					if not isAiming then
						isAiming = true

						lastCamera = GetFollowPedCamViewMode()
						if lastCamera ~= 4 then
							SetFollowPedCamViewMode(4)
						end
					elseif GetFollowPedCamViewMode() ~= 4 then
						SetFollowPedCamViewMode(4)
					end
					
					if status == 1 and shooting then
						local maxMul, curMul = (Config.Weapons[weapon] or 1.0), GetPlayerWeaponDamageModifier(pid)
						if curMul > maxMul then
							local jaki = curMul
							TriggerServerEvent('Island:FuckniggaCheaters', jaki)
						end
					end
				elseif isAiming then
					local off = true
					if isShooting then
						off = false

						aimTimer = aimTimer + 20
						if aimTimer == 3000 then
							isShooting = false
							aimTimer = 0
							off = true
						end
					end

					if off then
						isAiming = false
						if lastCamera ~= 4 then
							SetFollowPedCamViewMode(lastCamera)
						end
					end
				elseif not inVehicle then
					DisableControlAction(0, 24, true)
					DisableControlAction(0, 140, true)
				end
			end
		end
    end
end)
--[[
AddEventHandler('Island:loading', function(cb)
	cb(loadingStatus)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	print('[Island] Postać załadowana')
	if not loadingPosition then
		loadingStatus = 1
		ESX.UI.HUD.SetDisplay(0.0)
		loadingPosition = (xPlayer.lastPosition or {x = -1044.5974, y = -2749.9673, z = 20.4134})

		SetPlayerInvincible(PlayerId(), true)
		SetEntityVisible(ped, false)

		FreezeEntityPosition(ped, true)
		SetEntityCoords(ped, -1427.299, -245.1012, 16.8039)
		print('[Island] Przeniesiono do poczekalni')
	end
end)

AddEventHandler('skinchanger:modelLoaded', function()
	print('[Island] Model załadowany')
	ModelLoaded()
end)

AddEventHandler('Island:passthrough', function()
	print('[Island] Nowy gracz, ładowanie')
	ModelLoaded()
end)

function ModelLoaded()
	if loadingStatus < 2 then
		Citizen.CreateThreadNow(function()
			print('[Island] Oczekiwanie na załadowanie postaci')
			while not loadingPosition do
				Citizen.Wait(0)
			end

			Citizen.Wait(1000)
			loadingStatus = 2
			SendLoadingScreenMessage(json.encode({allow = true}))
			print('[Island] Odblokowano wejście (LPM)')
		end)
	end
end

Citizen.CreateThread(function()
	SetManualShutdownLoadingScreenNui(true)
	StartAudioScene("MP_LEADERBOARD_SCENE")
	SendLoadingScreenMessage(json.encode({ready = true}))

	TriggerEvent('chat:display', false)
	while true do
		Citizen.Wait(0)
		if loadingStatus == 2 and IsControlJustPressed(0, 18) then
			StartWyspa()
			break
		end
	end
end)

RegisterCommand('play', function(source, args, raw)
	if loadingStatus == 2 then
		Citizen.CreateThreadNow(StartWyspa)
	else
		awayTimer = 0
		if awayThread then
			TerminateThread(awayThread)
			awayThread = nil
		end
	end
end, false)

function StartWyspa()
	_in(0xABA17D7CE615ADBF, "FMMC_STARTTRAN")
	_in(0xBD12F8228410D9B4, 4)
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

	local ped = PlayerPedId()
	SetEntityCoords(ped, loadingPosition.x, loadingPosition.y, loadingPosition.z)
	Citizen.Wait(0)

	ped = PlayerPedId()
	if loadingPosition.heading then
		SetEntityHeading(ped, loadingPosition.heading)
	end

	FreezeEntityPosition(ped, false)
	SetEntityVisible(ped, true)
	SetPlayerInvincible(PlayerId(), false)
	SetPedMaxHealth(ped, 200)

	DoScreenFadeOut(0)
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()

	loadingStatus = 3
	StopAudioScene("MP_LEADERBOARD_SCENE")
	Citizen.Wait(1000)

	DoScreenFadeIn(1000)
	while IsScreenFadingIn() do
		Citizen.Wait(0)
	end

	ESX.UI.HUD.SetDisplay(1.0)
	TriggerEvent('chat:display', true)
	TriggerEvent('chat:clear')

	Citizen.Wait(1000)
	_in(0x10D373323E5B9C0D)
end]]