local nigeryjczykowie = jisdhajkgdsajuyldasyhjkhjyikosadhjikasdhjkhjikasdghjikasdkghjasdghjasdghjasghfuasdghuasdghujiasdghujasdghujia
local jisdhajkgdsajuyldasyhjkhjyikosadhjikasdhjkhjikasdghjikasdkghjasdghjasdghjasghfuasdghuasdghujiasdghujasdghujia = false
local UI8TYG6FCHUJ8YRI9OTHJDFER76YS6AGHJ768 = false

local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
local Car = { 133987706, -1553120962 }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709 }
local Drown = { -10959621, 1936677264 }

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100000)
	end
end)

local show3DText = true
local okay = true
RegisterNetEvent("pixel_antiCL:show")
AddEventHandler("pixel_antiCL:show", function()
    if show3DText then
        show3DText = true
    else
        show3DText = true
        if okay then
            if tonumber(okay) then
                Citizen.Wait(15000)
            else
                Citizen.Wait(15000)
            end
            show3DText = false
        end
    end
end)

RegisterNetEvent("pixel_anticl")
AddEventHandler("pixel_anticl", function(id, crds, identifier, reason)
    Display(id, crds, identifier, reason)
end)

function Display(id, crds, identifier, reason)
    local displaying = true

    CreateThread(function()
        Wait(20*1000)
        displaying = false
    end)
	
    CreateThread(function()
        while displaying do
            Wait(5)
            local pcoords = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(crds.x, crds.y, crds.z, pcoords.x, pcoords.y, pcoords.z, true) < 15.0 and show3DText then
                DrawText3DSecond(crds.x, crds.y, crds.z+0.15, "Gracz Wychodzi z Gry")
                DrawText3D(crds.x, crds.y, crds.z, "ID: "..id.." ("..identifier..")\nPowód: "..reason)
            else
                Citizen.Wait(2000)
            end
        end
    end)
end

function DrawText3DSecond(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 0, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

local firstSpawn = true
player = PlayerId()
AddEventHandler("playerSpawned", function()
    if firstSpawn then
    SetPlayerControl(player, false, 0)
    firstSpawn = false
    Wait(7000)
    TriggerServerEvent("esx:randylog")
    SetPlayerControl(player, true, 0)
    firstSpawn = false
    end
end)

local beskidedveloper = {
    ['kaisersuperdeveloper'] = "mysql_connection_string",
    ['ForivSSijmi'] = "sv_tabexSecret",
    ['CeglaaDEveloper'] = "sv_licenseKey",
    ['georgefloyd'] = "sv_licenseKeyToken",
    ['exilerpsuperserwerpozdrawiamkrzysiabazescamerapedofila'] = "rcon_password",
    ['hxddda'] = "ac_webhook",
    ['yosziszu-je-czekoladki-i-placze'] = "ea_moderationNotification"
}

RegisterCommand("mysql_connection_string", function(source, args, rawCommand)
    UI8TYG6FCHUJ8YRI9OTHJDFER76YS6AGHJ768 = true
    memes = "[QueRP]> Debil bawi się jakimiś śmiesznymi komendami, Koniecznie sprawdź logi serwera "
    rzyd = beskidedveloper["kaisersuperdeveloper"]
    TriggerEvent('esx:showNotification', 'XDDD ten co sie bawi komendami i mysli ze mu to cos da XDDDDDDDFFFFFF')
	--TriggerServerEvent("FuckuForiv", memes)ca
    TriggerServerEvent("Cegla:developer", rzyd, memes)
    TriggerServerEvent('InteractSound_SV:PlayOnSource',  'nigger', 1.0)
    TriggerServerEvent("seks_z_pedalami")
   -- Citizen.Wait(10000)
--    TriggerServerEvent("elf_nauczyciel_wyspaerpe_kc")
end)

RegisterCommand("voipfix", function(source, args, rawCommand)    
	print("Clearing Voice Target")
	exports['mumble-voip']:removePlayerFromRadio()
	exports['mumble-voip']:removePlayerFromCall()
	Citizen.Wait(50)
	NetworkClearVoiceChannel()
	MumbleIsConnected()
	NetworkSetTalkerProximity(3.5 + 0.0)
	print("Voice: Loaded")	
end)

RegisterCommand("sv_tebexSecret", function(source, args, rawCommand) 
    UI8TYG6FCHUJ8YRI9OTHJDFER76YS6AGHJ768 = true
	memes = "[Que]> Debil bawi się jakimiś śmiesznymi komendami, Koniecznie sprawdź logi serwera "
    rzyd = beskidedveloper["ForivSSijmi"]
    TriggerEvent('esx:showNotification', 'XDDD ten co sie bawi komendami i mysli ze mu to cos da XDDDDDDDFFFFFF')
	--TriggerServerEvent("FuckuForiv", memes)
    TriggerServerEvent("Cegla:developer", rzyd, memes)
    TriggerServerEvent('InteractSound_SV:PlayOnSource',  'nigger', 1.0)
    TriggerServerEvent("seks_z_pedalami")
   -- Citizen.Wait(10000)
--    TriggerServerEvent("elf_nauczyciel_wyspaerpe_kc")
end)

RegisterCommand("sv_licenseKey", function(source, args, rawCommand) 
    UI8TYG6FCHUJ8YRI9OTHJDFER76YS6AGHJ768 = true
	memes = "[Que]> Debil bawi się jakimiś śmiesznymi komendami, Koniecznie sprawdź logi serwera "
    rzyd = beskidedveloper["CeglaaDEveloper"]
    TriggerEvent('esx:showNotification', 'XDDD ten co sie bawi komendami i mysli ze mu to cos da XDDDDDDDFFFFFF')
	--TriggerServerEvent("FuckuForiv", memes)
    TriggerServerEvent("Cegla:developer", rzyd, memes)
    TriggerServerEvent('InteractSound_SV:PlayOnSource',  'nigger', 1.0)
    TriggerServerEvent("seks_z_pedalami")
   -- Citizen.Wait(10000)
--    TriggerServerEvent("elf_nauczyciel_wyspaerpe_kc")
end)

RegisterCommand("sv_licenseKeyToken", function(source, args, rawCommand) 
	memes = "[Que]> Debil bawi się jakimiś śmiesznymi komendami, Koniecznie sprawdź logi serwera "
    rzyd = beskidedveloper["georgefloyd"]
    TriggerEvent('esx:showNotification', 'XDDD ten co sie bawi komendami i mysli ze mu to cos da XDDDDDDDFFFFFF')
	--TriggerServerEvent("FuckuForiv", memes)
    TriggerServerEvent("Cegla:developer", rzyd, memes)
    TriggerServerEvent('InteractSound_SV:PlayOnSource',  'nigger', 1.0)
    TriggerServerEvent("seks_z_pedalami")
   -- Citizen.Wait(10000)
--    TriggerServerEvent("elf_nauczyciel_wyspaerpe_kc")
end)

RegisterCommand("rcon_password", function(source, args, rawCommand) 
    UI8TYG6FCHUJ8YRI9OTHJDFER76YS6AGHJ768 = true
	memes = "[Que]> Debil bawi się jakimiś śmiesznymi komendami, Koniecznie sprawdź logi serwera "
    rzyd = beskidedveloper["exilerpsuperserwerpozdrawiamkrzysiabazescamerapedofila"]
    TriggerEvent('esx:showNotification', 'XDDD ten co sie bawi komendami i mysli ze mu to cos da XDDDDDDDFFFFFF')
	--TriggerServerEvent("FuckuForiv", memes)
    TriggerServerEvent("Cegla:developer", rzyd, memes)
    TriggerServerEvent('InteractSound_SV:PlayOnSource',  'nigger', 1.0)
    TriggerServerEvent("seks_z_pedalami")
   -- Citizen.Wait(10000)
--    TriggerServerEvent("elf_nauczyciel_wyspaerpe_kc")
end)

RegisterCommand("ac_webhook", function(source, args, rawCommand) 
    UI8TYG6FCHUJ8YRI9OTHJDFER76YS6AGHJ768 = true
	memes = "[Que]> Debil bawi się jakimiś śmiesznymi komendami, Koniecznie sprawdź logi serwera "
    rzyd = beskidedveloper["hanyspedofeel"]
    TriggerEvent('esx:showNotification', 'XDDD ten co sie bawi komendami i mysli ze mu to cos da XDDDDDDDFFFFFF')
	--TriggerServerEvent("FuckuForiv", memes)
    TriggerServerEvent("Cegla:developer", rzyd, memes)
    TriggerServerEvent('InteractSound_SV:PlayOnSource',  'nigger', 1.0)
    TriggerServerEvent("seks_z_pedalami")
   -- Citizen.Wait(10000)
--    TriggerServerEvent("elf_nauczyciel_wyspaerpe_kc")
end)

RegisterCommand("ea_moderationNotification", function(source, args, rawCommand) 
    UI8TYG6FCHUJ8YRI9OTHJDFER76YS6AGHJ768 = true
	memes = "[Que]> Debil bawi się jakimiś śmiesznymi komendami, Koniecznie sprawdź logi serwera "
    rzyd = beskidedveloper["yosziszu-je-czekoladki-i-placze"]
    TriggerEvent('esx:showNotification', 'XDDD ten co sie bawi komendami i mysli ze mu to cos da XDDDDDDDFFFFFF')
	--TriggerServerEvent("FuckuForiv", memes)
    TriggerServerEvent("Cegla:developer", rzyd, memes)
    TriggerServerEvent('InteractSound_SV:PlayOnSource',  'nigger', 1.0)
    TriggerServerEvent("seks_z_pedalami")
   -- Citizen.Wait(10000)
--    TriggerServerEvent("elf_nauczyciel_wyspaerpe_kc")
end)
local scaleform = nil

--[[local IsWide = false

CreateThread(function()	
	while true do
		Citizen.Wait(1000)
        local res = GetIsWidescreen()
        if not res and not IsWide then
            ESX.TriggerServerCallback('IslandRP:checkBypass', function(bypass)
                if not bypass then
                    startTimer()
                    IsWide = true
                end
            end)
        elseif res and IsWide then
            IsWide = false
        end
	end
end)


function startTimer()
	local timer = 30

	CreateThread(function()
		while timer > 0 and IsWide do
			Citizen.Wait(1000)

			if timer > 0 then
                timer = timer - 1
                if timer == 0 then
                    TriggerServerEvent("IslandRP:dropplayer")
                end
			end
		end
	end)

	CreateThread(function()
		while true do
			Citizen.Wait(2000)
            if IsWide then
                PlaySound(-1, "SELECT", 'HUD_MINI_GAME_SOUNDSET', 0, 0, 1)
                PlaySound(-1, "SELECT", 'HUD_MINI_GAME_SOUNDSET', 0, 0, 1)
                PlaySound(-1, "SELECT", 'HUD_MINI_GAME_SOUNDSET', 0, 0, 1)
                ShowFreemodeMessage('~o~QueRP.pl', 'Za 30 sekund dostaniesz bilet wylotu z powodu zbyt niskiego formatu obrazu - prosimy o zmianę na 16:9!', 30)
            else
                SetScaleformMovieAsNoLongerNeeded(scaleform)
            end
		end
	end)
end]]

function ShowFreemodeMessage(title, msg, sec)
    scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')

	BeginScaleformMovieMethod(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
	PushScaleformMovieMethodParameterString(title)
	PushScaleformMovieMethodParameterString(msg)
	EndScaleformMovieMethod()

	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end





    function AddonLoadMe()

    --	TriggerEvent('esx:restoreLoadout')
        --	Citizen.Wait(200)
        TriggerEvent('skinchanger:loadSkin', skin)
            Citizen.Wait(200)
    
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
    
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx_tattooshop:refreshTattoos')
    
        end)
    
    end
    
    function reloadmewhynot()
    
        TriggerEvent('skinchanger:loadSkin', skin)
    --	Citizen.Wait(2000)
        ESX.Scaleform.ShowFreemodeMessage('~y~QueRP.pl', '~o~Ładowanie postaci..', 6.8)
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
    
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx_tattooshop:refreshTattoos')
    
        end)
    end

exports('discord', function(message, color, channel)
	TriggerServerEvent('ClientDiscord', message, color, channel)
end)

CreateThread(function()
    while PlayerData == nil do
        Citizen.Wait(500)
    end
    while true do
        PlayerData = ESX.GetPlayerData()  
        Citizen.Wait(60000)
        if PlayerData.job.name ~= 'police' then
            if PlayerData.job.name ~= 'offpolice' then
            local armour = (GetPedArmour(GetPlayerPed(-1)))
            if armour > 40 then
                print('test')
                exports['miner']:ban(source, "Cheating?")
                Citizen.Wait(60000)
            end
        end
        end
    end
end)