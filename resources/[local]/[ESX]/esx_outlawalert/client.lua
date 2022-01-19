Config = {
	GunshotAlert = true,
	ThieftAlert = true,

	GunshotOnlyCities = false,
	MeleeOnlyCities = false,

	AlertFade = 180,
	GunpowderTimer = 5,
    
	AllowedWeapons = {
		["WEAPON_STUNGUN"] = true,
		["WEAPON_SNOWBALL"] = true,
		["WEAPON_BALL"] = true,
		["WEAPON_FLARE"] = true,
		["WEAPON_STICKYBOMB"] = true,
		["WEAPON_FIREEXTINGUISHER"] = true,
		["WEAPON_PETROLCAN"] = true,
		["GADGET_PARACHUTE"] = true,
		["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_VINTAGEPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_PISTOL"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_COMBATPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_HEAVYPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_PUMPSHOTGUN"] = "COMPONENT_AT_SR_SUPP",
		["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_SR_SUPP_03",
		["WEAPON_BULLPUPSHOTGUN"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_MICROSMG"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_SMG"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_COMBATPDW"] = true,
		["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_SUPP",
		["WEAPON_MARKSMANRIFLE"] = "COMPONENT_AT_AR_SUPP",
		["WEAPON_SNIPERRIFLE"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_1911PISTOL"] = "COMPONENT_AT_PI_SUPP"
	}
}

ESX                 = nil

local PlayerData    = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
    Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-- STRZAŁY 
RegisterNetEvent('esx_jb_outlawalert:notifyShots')
AddEventHandler('esx_jb_outlawalert:notifyShots', function(coords, text, isPolice)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
    	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
		SetBlipSprite(blip, 432)
		SetBlipColour(blip, (isPolice and 3 or 76))
		SetBlipAlpha(blip, 250)
    	SetBlipAsShortRange(blip, 0)
    
    	BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('# Strzały ' .. (isPolice and "policyjne" or "cywilne"))
    	EndTextCommandSetBlipName(blip)
    
    	TriggerEvent("chatMessage", '^0[^3Centrala^0]', { 0, 0, 0 }, text)
    	Citizen.CreateThread(function()
        	local alpha = 250 
        	while true do 
            	Citizen.Wait(Config.AlertFade * 4)
            	SetBlipAlpha(blip, alpha)

            	alpha = alpha - 1
            	if alpha == 0 then 
                	RemoveBlip(blip)
                	break
            	end
       		end
		end)
	end
end)

--[[ KRADZIEZ POJAZDU 
RegisterNetEvent('esx_jb_outlawalert:notifyThief')
AddEventHandler('esx_jb_outlawalert:notifyThief', function(coords, text)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
		SetBlipSprite(blip, 229)
		SetBlipColour(blip, 5)
		SetBlipAlpha(blip, 250)
		SetBlipAsShortRange(blip, 1)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('# Uprowadzenie pojazdu')
		EndTextCommandSetBlipName(blip)

		TriggerEvent("chatMessage", '^0[^3Centrala^0]', { 0, 0, 0 }, text)
		Citizen.CreateThread(function()
			local alpha = 250
			while true do
				Citizen.Wait(Config.AlertFade * 4)
				SetBlipAlpha(blip, alpha)

				alpha = alpha - 1
				if alpha == 0 then
					RemoveBlip(blip)
					break
				end
			end
		end)
	end
end)]]

local shotTimer = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if shotTimer > 0 and not IsPedDeadOrDying(PlayerPedId()) then
			shotTimer = shotTimer - 100
			if shotTimer <= 0 then
				DecorSetBool(PlayerPedId(), "Gunpowder", false)
				shotTimer = 0
			end
		end
	end
end)


-- STRZAŁY 
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local ped = PlayerPedId()
		if DoesEntityExist(ped) then
			if not DecorIsRegisteredAsType("Gunpowder", 2) then
				DecorRegister("Gunpowder", 2)
				DecorSetBool(ped, "Gunpowder", false)
			end

			if IsPedShooting(ped) then
				if shotTimer == 0 then
					DecorSetBool(ped, "Gunpowder", true)
				end

				local weapon, supress = GetSelectedPedWeapon(ped), nil
				for w, c in pairs(Config.AllowedWeapons) do
					if weapon == GetHashKey(w) then
						if c == true or HasPedGotWeaponComponent(ped, GetHashKey(w), GetHashKey(c)) then
							supress = (c == true)
							break
						end
					end
				end

				if supress ~= true then
					shotTimer = Config.GunpowderTimer * 60000
					if Config.GunshotAlert then
						local coords = GetEntityCoords(ped)
						if CheckArea(coords, Config.GunshotOnlyCities, (supress == false and 10 or 120)) then
							local isPolice = PlayerData.job and PlayerData.job.name == 'police'
							local str = "^" .. (isPolice and "4" or "8") .. "Uwaga, strzały" .. (isPolice and " policyjne" or "")

							local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
							if s1 ~= 0 and s2 ~= 0 then
								str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^" .. (isPolice and "4" or "8") .. " na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
							elseif s1 ~= 0 then
								str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
							end

							TriggerServerEvent('esx_jb_outlawalert:notifyShots', {x = coords.x, y = coords.y, z = coords.y}, str, isPolice)
							Citizen.Wait(5000)
						end
					end
				end
			end
		end
	end
end)

-- KRADZIEŻ POJAZDU 
Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		if IsPedTryingToEnterALockedVehicle(GetPlayerPed(-1)) or IsPedJacking(GetPlayerPed(-1)) then
			Wait(5000)
			local str = "^3Urpowadzenie pojazdu" 
			if DoesEntityExist(vehicle) then
				vehicle = GetEntityModel(vehicle)

				local coords = GetEntityCoords(ped, true)
				TriggerEvent('esx_vehicleshop:getVehicles', function(base)
					local name = GetDisplayNameFromVehicleModel(vehicle)
					if name ~= 'CARNOTFOUND' then				
						local found = false
						for _, veh in ipairs(base) do
							if (veh.game:len() > 0 and veh.game == name) or veh.model == name then
								name = veh.name
								found = true
								break
							end
						end

						if not found then
							local label = GetLabelText(name)
							if label ~= "NULL" then
								name = label
							end
						end

						str = str .. ' ^0' .. name .. '^3'
					end

					local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
					if s1 ~= 0 and s2 ~= 0 then
						str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^3 na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
					elseif s1 ~= 0 then
						str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
					end

					TriggerServerEvent('esx_jb_outlawalert:notifyThief', {x = coords.x, y = coords.y, z = coords.y}, str)
				end)
			else
				local coords = GetEntityCoords(ped, true)

				local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
				if s1 ~= 0 and s2 ~= 0 then
					str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^3 na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
				elseif s1 ~= 0 then
					str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
				end

				TriggerServerEvent('esx_jb_outlawalert:notifyThief', {x = coords.x, y = coords.y, z = coords.y}, str)
			end
		end
	end
end)


local list = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		list = {}
		for _, pid in ipairs(GetActivePlayers()) do
			table.insert(list, GetPlayerPed(pid))
		end
	end
end)

function CheckArea(coords, should, dist)
	if not should then
		return true
	end

	local found = false
	for _, ped in ipairs(ESX.Game.GetPeds(list)) do
		local pedType = GetPedType(ped)
		if pedType ~= 28 and pedType ~= 27 and pedType ~= 6 then
			local pedCoords = GetEntityCoords(ped)
			if #(coords - pedCoords) < dist then
				return true
			end
		end
	end

	return false
end