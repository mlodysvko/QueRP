local holdingup = false
local bank = ""
local blipRobbery = nil
local isRobber = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('esx_holdup_bank:currentlyrobbing')
AddEventHandler('esx_holdup_bank:currentlyrobbing', function(robb)
    holdingup = true
    bank = robb
end)

RegisterNetEvent('esx_holdup_bank:killblip')
AddEventHandler('esx_holdup_bank:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('esx_holdup_bank:setblip')
AddEventHandler('esx_holdup_bank:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
end)

RegisterNetEvent('esx_holdup_bank:toofarlocal')
AddEventHandler('esx_holdup_bank:toofarlocal', function(robb)
    holdingup = false
    ESX.ShowNotification(_U('robbery_cancelled'))
    robbingName = ""
    incircle = false
end)


RegisterNetEvent('esx_holdup_bank:robberycomplete')
AddEventHandler('esx_holdup_bank:robberycomplete', function(robb)
    holdingup = false
    bank = ""
    incircle = false
end)


RegisterNetEvent('esx_holdup_bank:starttimer')
AddEventHandler('esx_holdup_bank:starttimer', function(source)
    timer = Banks[bank].secondsRemaining
    Citizen.CreateThread(function()
        while timer > 0 do
            Citizen.Wait(0)
            Citizen.Wait(1000)
            if(timer > 0)then
                timer = timer - 1
            end
        end
    end)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if holdingup  then
                drawTxt(0.66, 1.44, 1.0,1.0,0.4, _U('robbery_of') .. timer .. _U('seconds_remaining'), 255, 255, 255, 255)
            end
        end
    end)
end)


Citizen.CreateThread(function()
    for k,v in pairs(Banks)do
        local ve = v.position
        local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
        SetBlipSprite(blip, 156)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(_U('bank_robbery'))
        EndTextCommandSetBlipName(blip)
    end
end)
incircle = false


Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        for k,v in pairs(Banks)do
            local pos2 = v.position
            if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
                if not holdingup then
                    DrawMarker(27, v.position.x, v.position.y, v.position.z - 0.9, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 1555, 0, 0,255, 0, 0, 0,0)
                    if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
                        if (incircle == false) then
                            DisplayHelpText(_U('press_to_rob') .. v.nameofbank)
                        end
                        incircle = true
                        if IsControlJustReleased(1, 51) then
							Citizen.Wait(200)
							TriggerServerEvent('canwerob', k)
                        end
                    elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
                        incircle = false
                    end
                end
            end
        end
        if holdingup then
            local pos2 = Banks[bank].position
            if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 13)then
                TriggerServerEvent('esx_holdup_bank:toofar', bank)
            end
        end
        Citizen.Wait(5)
    end
end)

RegisterNetEvent('wecanrob')
AddEventHandler('wecanrob', function()
    TriggerEvent('smerfiwiertlo:open')
    local pos = GetEntityCoords(PlayerPedId(), true)
    for k,v in pairs(Banks)do
        local pos2 = v.position
        if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
            if not holdingup then
                TriggerServerEvent('policeblip', k)
            end
        end
    end
end)

RegisterNetEvent('welost')
AddEventHandler('welost', function()
    local pos = GetEntityCoords(PlayerPedId(), true)
    for k,v in pairs(Banks)do
        local pos2 = v.position
        if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
            if not holdingup then
                TriggerServerEvent('esx_holdup_bank:welost', k)
            end
        end
    end
end)

RegisterNetEvent('wewin')
AddEventHandler('wewin', function()
    local pos = GetEntityCoords(PlayerPedId(), true)
    for k,v in pairs(Banks)do
        local pos2 = v.position
        if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
            if not holdingup then
                TriggerServerEvent('esx_holdup_bank:rob', k)
            end
        end
    end
end)
    


RegisterNetEvent('koniecnapadu')
AddEventHandler('koniecnapadu', function()
    TriggerEvent('koniecnapadu5')
    ESX.Streaming.RequestAnimDict('anim@heists@ornate_bank@grab_cash', function()
        TaskPlayAnim(PlayerPedId(), 'anim@heists@ornate_bank@grab_cash', 'grab', 8.0, -8.0, -1, 2, 0, false, false, false)
    end)
    Wait(10000)
    ClearPedTasks(PlayerPedId())
end)
RegisterNetEvent('koniecnapadu5')
AddEventHandler('koniecnapadu5', function()
    procent = 0
    while procent <= 1000 do
     ESX.Game.Utils.DrawText3D(GetEntityCoords(PlayerPedId()), "Zbieranie " .. math.ceil(tonumber(procent * 0.1)) ..'%', 0.4)
        Wait(0)
        procent = procent + 1.28
    end
end)