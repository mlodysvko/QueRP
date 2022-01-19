local crosshands = false
CreateThread(function()
	while not HasAnimDictLoaded("amb@world_human_hang_out_street@female_arms_crossed@enter") do
		RequestAnimDict("amb@world_human_hang_out_street@female_arms_crossed@enter")
		Citizen.Wait(0)
	end

	while not HasAnimDictLoaded("amb@world_human_hang_out_street@female_arms_crossed@base") do
		RequestAnimDict("amb@world_human_hang_out_street@female_arms_crossed@base")
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(0)
		if Ped.Active then
			local status = true
			if Ped.Available and not Ped.InVehicle and Ped.Visible and Ped.Collection then
				status = false
				if not IsEntityPlayingAnim(Ped.Id, "amb@world_human_hang_out_street@female_arms_crossed@base", "base", 3) then
					crosshands = false
				end

				if IsControlJustPressed(1, Config.Gesty.crosshands) then
					crosshands = not crosshands
					if not crosshands then
						ClearPedSecondaryTask(Ped.Id)
					else
						TaskPlayAnim(Ped.Id, "amb@world_human_hang_out_street@female_arms_crossed@enter", "enter", 8.0, 8.0, -1, 16, 0, false, false, false)
						Citizen.Wait(2000)
						TaskPlayAnim(Ped.Id, "amb@world_human_hang_out_street@female_arms_crossed@base", "base", 8.0, 8.0, -1, 49, 0, false, false, false)
					end
				end
			end

			if status and crosshands then
				crosshands = false
				if not Ped.Locked then
					ClearPedSecondaryTask(Ped.Id)
				end
			end
		elseif crosshands then
			crosshands = false
			if Ped.Available then
				ClearPedSecondaryTask(Ped.Id)
			end
		end
	end
end)