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
local mikrooo = "Whisper"
local pasy = false
local directions = {
    N = 360, 0,
    NE = 315,
    E = 270,
    SE = 225,
    S = 180,
    SW = 135,
    W = 90,
    NW = 45
}
local directionss = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', } 



function round(value, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end


local table_elements = {
    HUD_VEHICLE_NAME = { id = 6, hidden = true },
    HUD_AREA_NAME = { id = 7, hidden = true },
    HUD_VEHICLE_CLASS = { id = 8, hidden = true },
    HUD_STREET_NAME = { id = 9, hidden = true }
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		for k, v in pairs(table_elements) do
			HideHudComponentThisFrame(v.id)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Wait(400)
        if IsPedInAnyVehicle(PlayerPedId()) and not IsPauseMenuActive() then
            DisplayRadar(true)
            local PedCar = GetVehiclePedIsUsing(PlayerPedId(), false)
            local coords = GetEntityCoords(PlayerPedId())
            local _,lightsOn,highbeamsOn = GetVehicleLightsState(PedCar)
            local lightMode = 1
            local carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
            local carMaxSpeed = math.ceil(GetVehicleEstimatedMaxSpeed(PedCar) * 3.6)
            local carSpeedPercent = carSpeed / carMaxSpeed * 100
            local rpm = GetVehicleCurrentRpm(PedCar) * 100

            if lightsOn == 1 then lightMode = lightMode + 1 end
            if highbeamsOn == 1 then lightMode = lightMode + 1 end

            local pos = GetEntityCoords(PlayerPedId())
            local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))

            for k,v in pairs(directionss)do
                direction = GetEntityHeading(PlayerPedId())
                if(math.abs(direction - k) < 22.5)then
                    direction = v
                    break
                end
            end

            if GetStreetNameFromHashKey(var2) ~= '' then
                streetlabeltosend = GetStreetNameFromHashKey(var1)..', '..GetStreetNameFromHashKey(var2)
            else
                streetlabeltosend = GetStreetNameFromHashKey(var1)
            end

            --  Show hud
            SendNUIMessage({
                showhud = true,
                stylex = 'classic',
                lights = lightMode,
                speedometer = true,
                speed = carSpeed,
                percent = carSpeedPercent,
                tachometer = true,
                direction = direction,
                zonecur = current_zone,
                street = streetlabeltosend,
                rpmx = rpm,
                seatbelt =  pasy
            })
        else
            if exports["gcphone"]:getMenuIsOpen() then
                DisplayRadar(true)
            else
                DisplayRadar(false)
            end
            SendNUIMessage({
                showhud = false
            })
            Citizen.Wait(2000)
        end
    end
end)

-- Status hud update

Citizen.CreateThread(function()
    SendNUIMessage({
        type = 'TOGGLE_HUD'
    })
    while true do
        Wait(2500)
        TriggerEvent('esx_status:getStatus', 'hunger', function(status)
            hunger = status.getPercent()
        end)
        TriggerEvent('esx_status:getStatus', 'thirst', function(status)
            thirst = status.getPercent()
        end)
        local armor = GetPedArmour(PlayerPedId())
        local hp = GetEntityHealth(PlayerPedId()) - 100
        local state = NetworkIsPlayerTalking(PlayerId())
        SendNUIMessage({
            type = 'UPDATE_HUD',
            hunger = hunger,
            thirst = thirst,
            armor = armor,
            nurkowanie = GetPlayerUnderwaterTimeRemaining(PlayerId()),
            inwater = IsPedSwimmingUnderWater(PlayerPedId()),
            zycie = hp,
            isdead = hp <= 0
        })
        SendNUIMessage({
            type = 'UPDATE_VOICE',
            isTalking = state,
            mode = mikrooo
        })
    end
end)

-- voice

function GetProximity(proximity)
    for k,v in pairs(Config.proximityModes) do
        if v[1] == proximity then
            return v[2]
        end
    end
    return 0
end


RegisterNetEvent('hud:talking')
AddEventHandler('hud:talking', function(prox)
	if prox == 33 then
		prox = "Whisper"
	elseif prox == 66 then
		prox = "Normal"
	elseif prox == 99 then 
		prox = "Shouting"
	end

    mikrooo = prox
end)

-- toggle hud

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    SendNUIMessage({
        type = 'TOGGLE_HUD'
    })
end)

RegisterCommand('togglehud', function()
    SendNUIMessage({
        type = 'TOGGLE_HUD'
    })
end, false)


RegisterNetEvent('notrp:togglePaski')
AddEventHandler('notrp:togglePaski', function(toggle)
	if toggle then
		pasy = true
	else
		pasy = false
	end
end)

RegisterKeyMapping('togglehud', 'Toggle Hud', 'mouse_button', 'MOUSE_MIDDLE')


Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, true)
	SetRadarZoom(1200)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
		SetRadarBigmapEnabled(false, true)
		SetRadarZoom(1200)
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

-- hud settings

