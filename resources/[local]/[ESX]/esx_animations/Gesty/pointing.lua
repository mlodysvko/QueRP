CreateThread(function()
    while not HasAnimDictLoaded("anim@mp_point") do
		RequestAnimDict("anim@mp_point")
        Citizen.Wait(0)
    end

	local mp_pointing = false
    while true do
        Citizen.Wait(0)

		local reset = false
		if Ped.Available and not Ped.InVehicle and Ped.Visible and Ped.OnFoot then
			if IsControlJustPressed(1, Config.Gesty.pointing) or IsControlJustPressed(2, Config.Gesty.pointing) and not GetVehiclePedIsIn(PlayerPedId(), true) then
				if not mp_pointing then
					mp_pointing = true
				else
					mp_pointing = false
					reset = true
				end
			end
		elseif mp_pointing then
            mp_pointing = false
			reset = true
        end

        if reset then
			RequestTaskMoveNetworkStateTransition(Ped.Id, "Stop")
			if not IsPedInjured(Ped.Id) then
				ClearPedSecondaryTask(Ped.Id)
			end

			if not IsPedInAnyVehicle(Ped.Id, 1) then
				SetPedCurrentWeaponVisible(Ped.Id, 1, 1, 1, 1)
			end

			SetPedConfigFlag(Ped.Id, 36, 0)
			ClearPedSecondaryTask(Ped.Id)
		elseif mp_pointing then
			if IsTaskMoveNetworkActive(Ped.Id) then
				SetTaskMoveNetworkSignalFloat(Ped.Id, "Pitch", (math.min(42.0, math.max(-70.0, GetGameplayCamRelativePitch())) + 70.0) / 112.0)
				SetTaskMoveNetworkSignalFloat(Ped.Id, "Heading", ((math.min(180.0, math.max(-180.0, GetGameplayCamRelativeHeading())) + 180.0) / 360.0) * -1.0 + 1.0)
				SetTaskMoveNetworkSignalFloat(Ped.Id, "isBlocked", false)
				SetTaskMoveNetworkSignalFloat(Ped.Id, "isFirstPerson", N_0xee778f8c7e1142e2(N_0x19cafa3c87f7c2ff()) == 4)
			else
				SetPedCurrentWeaponVisible(Ped.Id, 0, 1, 1, 1)
				SetPedConfigFlag(Ped.Id, 36, 1)
				TaskMoveNetworkByName(Ped.Id, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
			end
        end
    end
end)