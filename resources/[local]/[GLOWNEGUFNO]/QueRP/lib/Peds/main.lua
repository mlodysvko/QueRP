--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        SetVehicleDensityMultiplierThisFrame(Config.SetVehicleDensityMultiplierThisFrame)
        SetPedDensityMultiplierThisFrame(Config.SetPedDensityMultiplierThisFrame)
        SetRandomVehicleDensityMultiplierThisFrame(Config.SetRandomVehicleDensityMultiplierThisFrame)
        SetParkedVehicleDensityMultiplierThisFrame(Config.SetParkedVehicleDensityMultiplierThisFrame)
        SetScenarioPedDensityMultiplierThisFrame(Config.SetScenarioPedDensityMultiplierThisFrame)
	end
end)]]

CreateThread(function()
    while true do
    Citizen.Wait(1)
        local playerPed = GetPlayerPed(-1)
        local playerLocalisation = GetEntityCoords(playerPed)
        ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
        for i = 1, 12 do
			EnableDispatchService(i, false)
		end
		SetPlayerWantedLevel(PlayerId(), 0, false)
		SetPlayerWantedLevelNow(PlayerId(), false)
		SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
    end
end)