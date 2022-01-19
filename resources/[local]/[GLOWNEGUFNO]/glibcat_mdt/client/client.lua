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

local PoliceGUI               = false
local odznaka = nil
local isOpened = false
local isClosed = true
local closedTime = nil
local PlayerData              = {}
local tabletEntity = nil
local tabletModel = "glibcat_mdt_prop"
local tabletDict = "amb@world_human_seat_wall_tablet@female@base"
local tabletAnim = "base"

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
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

Citizen.CreateThread(function()	
	while true do
		Citizen.Wait(1)
		if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice') then
			if IsControlJustPressed(0, Keys["DELETE"]) then
				if PlayerData.job.name == 'police' then
					if not PoliceGUI then
						if isClosed and isOpened then
							ESX.TriggerServerCallback('glibcat_mdt:getTime', function(result)	
								if closedTime + Config.restartTime < result then
									SendNUIMessage({type = 'restart'})
									TriggerServerEvent('tablet:GetCharacterName', PlayerData.job.grade)
								else
									SendNUIMessage({type = 'open'})
								end	
							end, source)
						else
							SendNUIMessage({type = 'open'})
						end

						SetNuiFocus(true, true)
						SetNuiFocusKeepInput(true)
						PoliceGUI = true
						startTabletAnimation()
						DisableMovement()
						
						TriggerServerEvent('tablet:bridge')
						
						if not isOpened then
							SendNUIMessage({
								type = 'variables',
								minJobGrade = Config.minJobGrade,
								ogloszeniaJobGrade = Config.ogloszeniaJobGrade,
								maxTicket = Config.maxTicket,
								maxTariff = Config.maxTariff,
								maxJailTime = Config.maxJailTime,
								raportJobGrade = Config.raportJobGrade,
								serverName = Config.serverName,
								imgurApiKey = Config.imgurApiKey,
								useDispatch = Config.useDispatch,
								dispatchLink = Config.dispatchLink,
								useRaports = Config.useRaports,
							})
							isOpened = true
							checkAnnouncements()
							
							if Config.useRaports then
								checkRaports()
							end
							
							TriggerServerEvent('tablet:GetCharacterName', PlayerData.job.grade)	
						end


						isClosed = false
						
						
					end
				else
					ESX.ShowNotification("~r~Nie jesteś na służbie!")
				end
			end
		end
	end
end)

RegisterNUICallback('NUIFocusOff', function()
	PoliceGUI = false
	isClosed = true

	ESX.TriggerServerCallback('glibcat_mdt:getTime', function(result)	

		closedTime = result	
		
	end, source)
	
	stopTabletAnimation()
	SetNuiFocus(false,false)
	SetNuiFocusKeepInput(false)
	SendNUIMessage({type = 'close'})
end)

RegisterNUICallback('NUIFullFocusOff', function()
	isOpened = false
	isClosed = true
	PoliceGUI = false
	stopTabletAnimation()
	SetNuiFocus(false,false)
	SetNuiFocusKeepInput(false)
	SendNUIMessage({type = 'fullclose'})
end)



RegisterNUICallback('mandat', function(data, cb)
	TriggerServerEvent('tablet:wystawMandat', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, "Brak")
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.mandatgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')		
end)

RegisterNUICallback('mandat1', function(data, cb)
	TriggerServerEvent('tablet:wystawMandat1', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, "Brak")
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.mandatgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')		
end)

RegisterNUICallback('mandat2', function(data, cb)
	TriggerServerEvent('tablet:wystawMandat2', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, "Brak")
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.mandatgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')		
end)

RegisterNUICallback('mandat3', function(data, cb)
	TriggerServerEvent('tablet:wystawMandat3', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, "Brak")
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.mandatgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')		
end)

RegisterNUICallback('mandat4', function(data, cb)
	TriggerServerEvent('tablet:wystawMandat4', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, "Brak")
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.mandatgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')		
end)
RegisterNUICallback('mandat5', function(data, cb)
	TriggerServerEvent('tablet:wystawMandat5', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, "Brak")
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.mandatgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')		
end)
RegisterNUICallback('s341', function(data, cb)
	TriggerServerEvent('tablet:s341', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.mandatreason, data.mandatgrzywna, "Brak")
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.mandatgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')		
end)




RegisterNUICallback('jail', function(data, cb)
	TriggerServerEvent('tablet:wyslijDoPaki', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime)
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.jailgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')
end)
RegisterNUICallback('jail1', function(data, cb)
	TriggerServerEvent('tablet:wyslijDoPaki1', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime)
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.jailgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')
end)
RegisterNUICallback('jail2', function(data, cb)
	TriggerServerEvent('tablet:wyslijDoPaki2', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime)
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.jailgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')
end)
RegisterNUICallback('jail3', function(data, cb)
	TriggerServerEvent('tablet:wyslijDoPaki3', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime)
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.jailgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')
end)
RegisterNUICallback('jail4', function(data, cb)
	TriggerServerEvent('tablet:wyslijDoPaki4', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime)
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.jailgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')
end)
RegisterNUICallback('jail5', function(data, cb)
	TriggerServerEvent('tablet:wyslijDoPaki5', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime)
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.jailgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')
end)
RegisterNUICallback('s321', function(data, cb)
	TriggerServerEvent('tablet:s321', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime, data.name)
	TriggerServerEvent('tablet:addKartoteka', data.targetID, data.fp, data.jailreason, data.jailgrzywna, data.jailtime)
	ESX.ShowNotification('~w~Wpłacono ~g~' .. math.floor(data.jailgrzywna * Config.officerReward) .. '$ ~w~z mandatu na Twoje konto w banku')
end)




RegisterNUICallback('sprawdz', function(data, cb)
	if(data.kartotekafirst == nil or data.kartotekalast == nil) then
		SendNUIMessage({
			type = 'zleDane',
		})
	else
		TriggerServerEvent('tablet:checkKarto', data.kartotekafirst, data.kartotekalast)
	end
end)



RegisterNUICallback('removeKartoteka', function(data, cb)
	TriggerServerEvent('tablet:removeKartoteka', data.id, data.data, data.fp, data.target, data.reason, data.fine, data.jail)
end)



RegisterNUICallback('poszukiwaniaDodaj', function(data, cb)
	TriggerServerEvent('tablet:poszukiwaniaDodaj', data.identifier, data.policjant, data.powod, data.pojazd, data.data, data.target)
end)


RegisterNUICallback('removePoszukiwania', function(data, cb)
	TriggerServerEvent('tablet:removePoszukiwania', data.id, data.data, data.target, data.fp)
end)



RegisterNUICallback('kartotekaNotatkaDodaj', function(data, cb)
	TriggerServerEvent('tablet:kartotekaNotatkaDodaj', data.identifier, data.policjant, data.notatka, data.data, data.target)
end)

RegisterNUICallback('removeKartotekaNotatka', function(data, cb)
	TriggerServerEvent('tablet:removeKartotekaNotatka', data.id, data.data, data.fp, data.target, data.text)
end)



RegisterNUICallback('licencjaDodaj', function(data, cb)
	TriggerServerEvent('tablet:licencjaDodaj', data.identifier, data.licencja, data.fp, data.target)
end)

RegisterNUICallback('licencjaUsun', function(data, cb)
	TriggerServerEvent('tablet:licencjaUsun', data.identifier, data.licencja, data.fp, data.target)
end)



RegisterNUICallback('openAnnouncements', function(data, cb)
	TriggerServerEvent('tablet:getAnnouncements')
end)

RegisterNUICallback('ogloszenieDodaj', function(data, cb)
	TriggerServerEvent('tablet:ogloszenieDodaj', data.policjant, data.announcement, data.data)
end)

RegisterNUICallback('ogloszenieWyswietlone', function(data, cb)
	TriggerServerEvent('tablet:ogloszeniePowiadomienieWyswietlone', data.identifier)
end)

RegisterNUICallback('removeOgloszenie', function(data, cb)
	TriggerServerEvent('tablet:removeOgloszenie', data.data, data.fp, data.text)
end)

RegisterNetEvent('tablet:sendAnnouncements')
AddEventHandler('tablet:sendAnnouncements', function(ogloszenia)

	for i=1, #ogloszenia do
		SendNUIMessage({
			type = 'insertOgloszenia',
			ogloszenie = ogloszenia[i].ogloszenie,
			fp = ogloszenia[i].policjant,
			data = ogloszenia[i].data,
		})
	end
	
end)

RegisterNetEvent('tablet:sendNewAnnouncement')
AddEventHandler('tablet:sendNewAnnouncement', function(ogloszenie, fp, data)

	if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice') then
		if isOpened and not isClosed then
			SendNUIMessage({
				type = 'insertOgloszenia',
				ogloszenie = ogloszenie,
				fp = fp,
				data = data,
			})
		
			SendNUIMessage({
				type = 'newOpenedOgloszenie',
			})
		else
			SendNUIMessage({
				type = 'insertOgloszenia',
				ogloszenie = ogloszenie,
				fp = fp,
				data = data,
			})
			
			SendNUIMessage({
				type = 'newTwojstaryOgloszenie',
			})
			
			TriggerServerEvent('tablet:ogloszeniePowiadomienie')
		end
	end
end)

function checkAnnouncements()
	ESX.TriggerServerCallback('glibcat_mdt:ogloszeniePowiadomienieSprawdz', function(result)
							
		if not result[1].seen then
			SendNUIMessage({
				type = 'newOgloszenie',
			})
								
		end
								
	end, source)
end



RegisterNUICallback('raportDodaj', function(data, cb)
	TriggerServerEvent('tablet:raportDodaj', data.identifier, data.policjant, data.raport, data.data)
end)

RegisterNUICallback('raportUsun', function(data, cb)
	TriggerServerEvent('tablet:raportUsun', data.data, data.fp, data.text)
end)

RegisterNUICallback('openRaports', function(data, cb)
	TriggerServerEvent('tablet:openRaports', data.identifier)
end)

RegisterNUICallback('openAllRaports', function(data, cb)
	TriggerServerEvent('tablet:openAllRaports')
end)

RegisterNetEvent('tablet:sendRaports')
AddEventHandler('tablet:sendRaports', function(raports)

	for i=1, #raports do
		SendNUIMessage({
			type = 'insertRaports',
			raport = raports[i].raport,
			fp = raports[i].policjant,
			data = raports[i].data,
			status = raports[i].status,
		})
	end
	
end)

RegisterNetEvent('tablet:syncRaports')
AddEventHandler('tablet:syncRaports', function(raport, data, fp)

	if PlayerData.job.grade >= Config.raportJobGrade then
		SendNUIMessage({
			type = 'insertSyncRaport',
			raport = raport,
			fp = fp,
			data = data,
			status = 0,
		})
	end
	
end)

function checkRaports()
	ESX.TriggerServerCallback('glibcat_mdt:unseenRaport', function(result)
							
		if not result[1].status and PlayerData.job.grade >= Config.raportJobGrade then
			SendNUIMessage({
				type = 'unseenRaport',
			})
								
		end
								
	end, source)
end



RegisterNUICallback('openNotepad', function(data, cb)
	TriggerServerEvent('tablet:getNotepad', data.identifier)
end)

RegisterNUICallback('saveNotepad', function(data, cb)
	TriggerServerEvent('tablet:saveNotepad', data.identifier, data.notatka)
end)



RegisterNUICallback('sprawdzVehicle', function(data, cb)
	if(data.plate == "") then
		SendNUIMessage({
			type = 'zleDane',
		})
	else
		TriggerServerEvent('tablet:checkVehicle', data.plate)
	end
end)

RegisterNetEvent('sendCheckVehicle')
AddEventHandler('sendCheckVehicle', function(car, playerName)
	SendNUIMessage({
		type = 'showVehicle',
		owner = playerName,
		model = car[1].vehicle,
	})
end)

RegisterNetEvent('sendBrakPojazdu')
AddEventHandler('sendBrakPojazdu', function()
	SendNUIMessage({
		type = 'brakPojazdu',
	})
end)



RegisterNetEvent('tablet:nearbyPlayers')
AddEventHandler('tablet:nearbyPlayers', function(id)
	local myId = id
		for _, player in ipairs(GetActivePlayers()) do
			local pid = GetPlayerServerId(player)
			local ped = GetPlayerPed(player)
			local dist = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),GetEntityCoords(ped), true)
			

				
				if (dist < 10.0) then
					SendNUIMessage({
						type = 'players',
						id = pid,
				   })
				end
		end
end)

RegisterNetEvent('tablet:sendPlayerName')
AddEventHandler('tablet:sendPlayerName', function(name, id, numerOdznaki)

	if numerOdznaki then
		SendNUIMessage({
			type = 'user',
			user = name .. " " .. numerOdznaki,
			identifier = id,
			jobGrade = PlayerData.job.grade,
			minJobGrade = Config.minJobGrade,
			ogloszeniaJobGrade = Config.ogloszeniaJobGrade,
			maxTicket = Config.maxTicket,
			maxTariff = Config.maxTariff,
			raportJobGrade = Config.raportJobGrade,
		})
		
		odznaka = numerOdznaki
	else 
		SendNUIMessage({
			type = 'user',
			user = name,
			identifier = id,
			jobGrade = PlayerData.job.grade,
		})
	end
	
end)

RegisterNetEvent('tablet:insertKarto')
AddEventHandler('tablet:insertKarto', function(basic, kartoteka, poszukiwania, licenses, cars, notatki)

	SendNUIMessage({
		type = 'openKartoteka',
		first = basic[1].firstname,
		last = basic[1].lastname,
		sex = basic[1].sex,
		birthDate = basic[1].dateofbirth,
		id = basic[1].identifier,
		kartoteka_avatar = basic[1].kartoteka_avatar,
	})
	
	
	for i=1, #kartoteka do
		SendNUIMessage({
			type = 'insertKartoteka',
			fp = kartoteka[i].policjant,
			reason = kartoteka[i].powod,
			charge = kartoteka[i].grzywna,
			years = kartoteka[i].ilosc_lat,
			data = kartoteka[i].data,
		})
	end
	
	
	
	for i=1, #poszukiwania do
		SendNUIMessage({
			type = 'insertPoszukiwania',
			fp = poszukiwania[i].policjant,
			reason = poszukiwania[i].powod,
			pojazd = poszukiwania[i].pojazd,
			data = poszukiwania[i].data,
		})
	end
	
	if poszukiwania[1] then
		SendNUIMessage({
			type = 'jestPoszukiwany',
		})
	end
	
	for i=1, #licenses do
		SendNUIMessage({
			type = 'insertLicenses',
			typ = licenses[i].type,
		})
	end
	
	for i=1, #cars do
		SendNUIMessage({
			type = 'insertCars',
			model = cars[i].vehicle,
			plate = cars[i].plate,
		})
	end
	
	for i=1, #notatki do
		SendNUIMessage({
			type = 'insertNotatki',
			note = notatki[i].note,
			policjant = notatki[i].policjant,
			data = notatki[i].data,
		})
	end
	
end)

RegisterNUICallback('insertNewAvatar', function(data, cb)
	TriggerServerEvent('tablet:insertNewAvatar', data.identifier, data.avatarUrl, data.fp, data.target)
end)



RegisterNetEvent('tablet:sendNotepad')
AddEventHandler('tablet:sendNotepad', function(notepad)

	SendNUIMessage({
		type = 'insertNotepad',
		notepad = notepad[1].notatka,
	})
end)

RegisterNetEvent('sendBrakUzytkownika')
AddEventHandler('sendBrakUzytkownika', function(name, id)
	SendNUIMessage({
		type = 'brakUzytkownika',
	})
end)



function DisableMovement()
	Citizen.CreateThread(function()
		while PoliceGUI do
			Citizen.Wait(1)
			DisableAllControlActions(0)
			EnableControlAction(0, 249, true)
		end
	end)
end

function startTabletAnimation()
	Citizen.CreateThread(function()
	  RequestAnimDict(tabletDict)
	  while not HasAnimDictLoaded(tabletDict) do
	    Citizen.Wait(0)
	  end
		attachObject()
		TaskPlayAnim(GetPlayerPed(-1), tabletDict, tabletAnim, 4.0, -4.0, -1, 50, 0, false, false, false)
	end)
end

function attachObject()
	if tabletEntity == nil then
		Citizen.Wait(380)
		RequestModel(tabletModel)
		while not HasModelLoaded(tabletModel) do
			Citizen.Wait(1)
		end
		tabletEntity = CreateObject(GetHashKey(tabletModel), 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(tabletEntity, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.12, 0.10, -0.13, 25.0, 170.0, 160.0, true, true, false, true, 1, true)
	end
end

function stopTabletAnimation()
	if tabletEntity ~= nil then
		StopAnimTask(GetPlayerPed(-1), tabletDict, tabletAnim ,4.0, -4.0, -1, 50, 0, false, false, false)
		DeleteEntity(tabletEntity)
		tabletEntity = nil
	end
end