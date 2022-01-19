-- Variable to check if native has already been run
local Ran = false

-- Wait until client is loaded into the map
--[[
AddEventHandler("playerSpawned", function ()
	if not Ran then
		SendLoadingScreenMessage(json.encode({stop = true}))
		Ran = true
	end
end)]]


AddEventHandler('loadstop', function()
	if not Ran then
		SendLoadingScreenMessage(json.encode({stop = true}))
		Ran = true
	end
end)
RegisterNUICallback('hidels', function(data, cb)
	Citizen.Wait(5000)
	ShutdownLoadingScreenNui()
end)