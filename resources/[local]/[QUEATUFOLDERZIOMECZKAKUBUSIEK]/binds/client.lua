ESX = nil
local settings = {
    cache = {},
    cache_used = {},
    hide = false,
    timer = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0, 
        [6] = 0,
        [7] = 0,
    }
}

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end	
	Wait(5000)
	PlayerData = ESX.GetPlayerData()
    TriggerServerEvent("binds:LoadSlots")
    Wait(5000)
    ESX.TriggerServerCallback('packv6:getBinds', function(a,b,c,d,e)
        if a ~= 'Brak' and a ~= nil then
            SendNUIMessage({action = "img1", img1 = "img/"..a..".png" })
        else
            SendNUIMessage({action = "delimg1"})
        end
        if b ~= 'Brak' and b ~= nil then
            SendNUIMessage({action = "img2", img2 = "img/"..b..".png" })
        else
            SendNUIMessage({action = "delimg2"})
        end
        if c ~= 'Brak' and c ~= nil then
            SendNUIMessage({action = "img3", img3 = "img/"..c..".png" })
        else
            SendNUIMessage({action = "delimg3"})
        end
        if d ~= 'Brak' and d ~= nil then
            SendNUIMessage({action = "img4", img4 = "img/"..d..".png" })
        else
            SendNUIMessage({action = "delimg4"})
        end
        if e ~= 'Brak' and e ~= nil then
            SendNUIMessage({action = "img5", img5 = "img/"..e..".png" })
        else
            SendNUIMessage({action = "delimg5"})
        end
    end)
end)

CreateThread(function()
	while true do
		Wait(1000)
		TriggerEvent('packv6:bindHud', true)
		break
	end
end)

RegisterCommand('bindmanage', function()
	openBindManage()
end)

RegisterCommand('bindui', function()
	if settings.hide == false then
		CreateThread(function()
			while true do 
				Wait(1000)
				TriggerEvent('packv6:bindHud', false)
				settings.hide = true
				break
			end
		end)
	elseif settings.hide == true then
		CreateThread(function()
			while true do 
				Wait(1000)
				TriggerEvent('packv6:bindHud', true)
				settings.hide = false
				break
			end
		end)
	end
end)

RegisterNetEvent('packv6:IsWeapon')
AddEventHandler('packv6:IsWeapon', function(item)
    if GetGameTimer() > settings.timer[1] then
        settings.timer[1] = GetGameTimer() + 350   
        local weapon = 'weapon_'..item
        local weaponHash = GetHashKey(weapon)
        local playerPed = PlayerPedId()
        if GetSelectedPedWeapon(playerPed) == weaponHash then
            Citizen.InvokeNative(0xADF692B254977C0C, playerPed, GetHashKey('WEAPON_UNARMED'), true)
            TriggerServerEvent("binds:notify2", item)
        else
            Citizen.InvokeNative(0xADF692B254977C0C, playerPed, weaponHash, true)
            TriggerServerEvent("binds:notify", item)
        end
    end
end)

for i=1, 5, 1 do
    RegisterCommand('+-slot'..i, function()    
        if i == tonumber(1) then
            Select('first', 1)
        elseif i == tonumber(2) then
            Select('second', 2)
        elseif i == tonumber(3) then
            Select('third', 3)
        elseif i == tonumber(4) then
            Select('fourth', 4)
        elseif i == tonumber(5) then
            Select('fifth', 5)
        end
    end)
    RegisterKeyMapping('+-slot'..i, 'slot '..i, 'keyboard', i)
end

RegisterNetEvent('packv6:useItem')
AddEventHandler('packv6:useItem', function(item)
    if not exports['esx_ambulancejob']:getDeathStatus() and not exports['esx_policejob']:isHandcuffed() then
	if GetGameTimer() > settings.timer[2] then
	    settings.timer[2] = GetGameTimer() + 250    
	    TriggerServerEvent('esx:useItem', item)
    end
	end
end)

Select = function(who, val)
    TriggerServerEvent('packv6:UseItemFromBind', who)
end

openBindManage = function()
    ESX.UI.Menu.CloseAll()

    local elements = {}
    ESX.TriggerServerCallback('packv6:getBinds', function(a,b,c,d,e)
        if a ~= 'Brak' and a ~= nil then
            table.insert(elements, { label = '[1] '..tostring(a)..' - Naciśnij aby usunąć', value = '1' })
        else
            table.insert(elements, { label = '[1] Brak przypisanego klawisza pod item'})
        end
        if b ~= 'Brak' and b ~= nil then
            table.insert(elements, { label = '[2] '..tostring(b)..' - Naciśnij aby usunąć', value = '2' })
        else
            table.insert(elements, { label = '[2] Brak przypisanego klawisza pod item'})
        end
        if c ~= 'Brak' and c ~= nil then
            table.insert(elements, { label = '[3] '..tostring(c)..' - Naciśnij aby usunąć', value = '3' })
        else
            table.insert(elements, { label = '[3] Brak przypisanego klawisza pod item'})
        end
        if d ~= 'Brak' and d ~= nil then
            table.insert(elements, { label = '[4] '..tostring(d)..' - Naciśnij aby usunąć', value = '4' })
        else
            table.insert(elements, { label = '[4] Brak przypisanego klawisza pod item'})
        end
        if e ~= 'Brak' and e ~= nil then
            table.insert(elements, { label = '[5] '..tostring(e)..' - Naciśnij aby usunąć', value = '5'})
        else
            table.insert(elements, { label = '[5] Brak przypisanego klawisza pod item'})
        end
    end)


    Wait(500)

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'bagol',
        {
            title    = "Zarządzanie Ekwipunkiem",
            align     = "bottom-right",
            elements = elements
        }, function(data, menu)
            local value = data.current.value
            if value == '1' then
                data_value = 'first'
            elseif value == '2' then
                data_value = 'second'
            elseif value == '3' then
                data_value = 'third'
            elseif value == '4' then
                data_value = 'fourth'
            elseif value == '5' then
                data_value = 'fifth'
            end
            TriggerServerEvent('packv6:deleteBind', data_value)
            openBindManage()
        end,

    function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('packv6:bindHud')
AddEventHandler('packv6:bindHud', function(boolean)
    SendNUIMessage({
        type = "open",
        display = boolean,
    })
end)

RegisterNetEvent('packv6:updatebinds')
AddEventHandler('packv6:updatebinds', function(awsd)
    local data = awsd
    if data.first ~= 'Brak' and data.first ~= nil then
        SendNUIMessage({action = "img1", img1 = "img/"..data.first..".png" })
    else
        SendNUIMessage({action = "delimg1"})
    end
    if data.second ~= 'Brak' and data.second ~= nil then
        SendNUIMessage({action = "img2", img2 = "img/"..data.second..".png" })
    else
        SendNUIMessage({action = "delimg2"})
    end
    if data.third ~= 'Brak' and data.third ~= nil then
        SendNUIMessage({action = "img3", img3 = "img/"..data.third..".png" })
    else
        SendNUIMessage({action = "delimg3"})
    end
    if data.fourth ~= 'Brak' and data.fourth ~= nil then
        SendNUIMessage({action = "img4", img4 = "img/"..data.fourth..".png" })
    else
        SendNUIMessage({action = "delimg4"})
    end
    if data.fifth ~= 'Brak' and data.fifth ~= nil then
        SendNUIMessage({action = "img5", img5 = "img/"..data.fifth..".png" })
    else
        SendNUIMessage({action = "delimg5"})
    end
end)
