ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

isAdmin = false
showLicenses = false
RedM = false

settings = {
	button = 289,
	forceShowGUIButtons = false,
}


-- generate "slap" table once
local SlapAmount = {}
for i=1,20 do
	table.insert(SlapAmount,i)
end

function handleOrientation(orientation)
	if orientation == "right" then
		return 1320
	elseif orientation == "middle" then
		return 730
	elseif orientation == "left" then
		return 0
	end
end

playlist = nil

RegisterCommand('easyadmin', function(source, args)
		CreateThread(function()
			if not RedM then
				playerlist = nil
				TriggerServerEvent("EasyAdmin:GetInfinityPlayerList") -- shitty fix for bigmode
				repeat
					Wait(100)
				until playerlist
			end

			if strings then
				banLength = {
					{label = "Permamentnie", time = 10444633200},
					{label = "1H", time = 3600},
					{label = "2H", time = 7200},
					{label = "3H", time = 10800},
					{label = "6H", time = 21600},
					{label = "12H", time = 43200},
					{label = "1Dzień", time = 86400},
					{label = "2Dni", time = 172800},
					{label = "3Dni", time = 259200},
					{label = "Tydzień", time = 518400},
					{label = "2Tygodnie", time = 1123200},
					{label = "Miesiąc", time = 2678400},
					{label = "Rok", time = 31536000},
				}
				if mainMenu:Visible() then
					mainMenu:Visible(false)
					_menuPool:Remove()
					collectgarbage()
				else
					GenerateMenu()
					mainMenu:Visible(true)
				end
			else
				TriggerServerEvent("EasyAdmin:amiadmin")
			end
		end)
end)

Citizen.CreateThread(function()
	if CompendiumHorseObserved then -- https://www.youtube.com/watch?v=r7qovpFAGrQ
		RedM = true
		settings.button = "PhotoModePc"
	end
	repeat
		Wait(100)
	until NativeUI
	_menuPool = NativeUI.CreatePool()
	TriggerServerEvent("EasyAdmin:amiadmin")
	TriggerServerEvent("EasyAdmin:requestBanlist")
	TriggerServerEvent("EasyAdmin:requestCachedPlayers")

	if not GetResourceKvpString("ea_menuorientation") then
		SetResourceKvp("ea_menuorientation", "right")
		SetResourceKvpInt("ea_menuwidth", 0)
		menuWidth = 0
		menuOrientation = handleOrientation("right")
	else
		menuWidth = GetResourceKvpInt("ea_menuwidth")
		menuOrientation = handleOrientation(GetResourceKvpString("ea_menuorientation"))
	end 
	mainMenu = NativeUI.CreateMenu("QueRP-Admin", "~o~ ∑ QueRPRP.pl", menuOrientation, 0)
	
	_menuPool:Add(mainMenu)
	
	mainMenu:SetMenuWidthOffset(menuWidth)	
	_menuPool:ControlDisablingEnabled(false)
	_menuPool:MouseControlsEnabled(false)
	
	while true do
		if _menuPool then
			_menuPool:ProcessMenus()
		end
		if (RedM and IsControlJustReleased(0, Controls[settings.button]) ) or (not RedM and IsControlJustReleased(0, tonumber(settings.button)) and GetLastInputMethod( 0 )) then
			-- clear and re-create incase of permission change+player count change
			if not isAdmin == true then
				TriggerServerEvent("EasyAdmin:amiadmin")
				local waitTime = 0

				repeat 
					Wait(100)
					waitTime=waitTime+1
				until (isAdmin or waitTime==60)
				if not isAdmin then
				end
			end
			

			
			if not RedM and isAdmin then
				playerlist = nil
				TriggerServerEvent("EasyAdmin:GetInfinityPlayerList") -- shitty fix for bigmode
				repeat
					Wait(100)
				until playerlist
			end

			if strings and isAdmin then
				banLength = {
					{label = "Permamentnie", time = 10444633200},
					{label = "1H", time = 3600},
					{label = "2H", time = 7200},
					{label = "3H", time = 10800},
					{label = "6H", time = 21600},
					{label = "12H", time = 43200},
					{label = "1Dzień", time = 86400},
					{label = "2Dni", time = 172800},
					{label = "3Dni", time = 259200},
					{label = "Tydzień", time = 518400},
					{label = "2Tygodnie", time = 1123200},
					{label = "Miesiąc", time = 2678400},
					{label = "Rok", time = 31536000},
				}
				if mainMenu:Visible() then
					mainMenu:Visible(false)
					_menuPool:Remove()
					collectgarbage()
				else
					GenerateMenu()
					mainMenu:Visible(true)
				end
			else
				TriggerServerEvent("EasyAdmin:amiadmin")
			end
		end
		
		Citizen.Wait(1)
	end
end)

function DrawPlayerInfo(target)
	drawTarget = target
	drawInfo = true
end

function StopDrawPlayerInfo()
	drawInfo = false
	drawTarget = 0
end
noClipSpeeds =  "noclip speeds"


Citizen.CreateThread(function()
	while true do
		if noClip then
			local noclipEntity = PlayerPedId()
			if IsPedInAnyVehicle(noclipEntity, false) then
				local vehicle = GetVehiclePedIsIn(noclipEntity, false)
				if GetPedInVehicleSeat(vehicle, -1) == noclipEntity then
					noclipEntity = vehicle
				else
					noclipEntity = nil
				end
			end

			FreezeEntityPosition(noclipEntity, true)
			SetEntityInvincible(noclipEntity, true)

			DisableControlAction(0, 31, true)
			DisableControlAction(0, 30, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 20, true)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 33, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 35, true)

			local yoff = 0.0
			local zoff = 0.0
			if IsControlJustPressed(0, 21) then
				noClipSpeed = noClipSpeed + 1
				if noClipSpeed > #noClipSpeeds then
					noClipSpeed = 1
				end

			end

			if IsDisabledControlPressed(0, 32) then
				yoff = 0.25;
			end

			if IsDisabledControlPressed(0, 33) then
				yoff = -0.25;
			end

			if IsDisabledControlPressed(0, 34) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 2.0)
			end

			if IsDisabledControlPressed(0, 35) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 2.0)
			end

			if IsDisabledControlPressed(0, 44) then
				zoff = 0.1;
			end

			if IsDisabledControlPressed(0, 20) then
				zoff = -0.1;
			end

			local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (noClipSpeed + 0.3), zoff * (noClipSpeed + 0.3))

			local heading = GetEntityHeading(noclipEntity)
			SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
			SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
			SetEntityHeading(noclipEntity, heading)

			SetEntityCollision(noclipEntity, false, false)
			SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)
			Citizen.Wait(0)

			FreezeEntityPosition(noclipEntity, false)
			SetEntityInvincible(noclipEntity, false)
			SetEntityCollision(noclipEntity, true, true)
		else
			Citizen.Wait(200)
		end
	end
end)
noClip = false
noClipSpeed = 1
noClipLabel = nil

function NoClip()
	return noClip == true
end

local banlistPage = 1
function GenerateMenu() -- this is a big ass function
	TriggerServerEvent("EasyAdmin:requestCachedPlayers")
	_menuPool:Remove()
	_menuPool = NativeUI.CreatePool()
	collectgarbage()
	if not GetResourceKvpString("ea_menuorientation") then
		SetResourceKvp("ea_menuorientation", "right")
		SetResourceKvpInt("ea_menuwidth", 0)
		menuWidth = 0
		menuOrientation = handleOrientation("right")
	else
		menuWidth = GetResourceKvpInt("ea_menuwidth")
		menuOrientation = handleOrientation(GetResourceKvpString("ea_menuorientation"))
	end 
	
	mainMenu = NativeUI.CreateMenu("QueRP-Admin", "~o~ ∑ QueRP.pl", menuOrientation, 0)
	_menuPool:Add(mainMenu)
	
		mainMenu:SetMenuWidthOffset(menuWidth)	
	_menuPool:ControlDisablingEnabled(false)
	_menuPool:MouseControlsEnabled(false)
	
	playermanagement = _menuPool:AddSubMenu(mainMenu, "Gracze", "",true)
	settingsMenu = _menuPool:AddSubMenu(mainMenu, "Ustawienia","",true)
	servermanagement = _menuPool:AddSubMenu(mainMenu, "Inne","",true)

	mainMenu:SetMenuWidthOffset(menuWidth)	
	playermanagement:SetMenuWidthOffset(menuWidth)	
	servermanagement:SetMenuWidthOffset(menuWidth)	
	settingsMenu:SetMenuWidthOffset(menuWidth)	

	-- util stuff
	players = {}
	local localplayers = {}

	if not RedM then
		local localplayers = playerlist
		local temp = {}
		--table.sort(localplayers)
		for i,thePlayer in pairs(localplayers) do
			table.insert(temp, thePlayer.id)
		end
		table.sort(temp)
		for i, thePlayerId in pairs(temp) do
			for _, thePlayer in pairs(localplayers) do
				if thePlayerId == thePlayer.id then
					players[i] = thePlayer
				end
			end
		end
		temp=nil
	else
		for i = 0, 128 do
			if NetworkIsPlayerActive( i ) then
			  table.insert( localplayers, GetPlayerServerId(i) )
			end
		end
		table.sort(localplayers)
		for i,thePlayer in ipairs(localplayers) do
			table.insert(players,GetPlayerFromServerId(thePlayer))
		end
	end


	for i,thePlayer in pairs(players) do
		if RedM then
			thePlayer = {
				id = GetPlayerServerId(thePlayer), 
				name = GetPlayerName(thePlayer)
			}
		end
		thisPlayer = _menuPool:AddSubMenu(playermanagement,"["..thePlayer.id.."] "..thePlayer.name,"",true)

		thisPlayer:SetMenuWidthOffset(menuWidth)
		-- generate specific menu stuff, dirty but it works for now
		if permissions["kick"] then
			local thisKickMenu = _menuPool:AddSubMenu(thisPlayer,GetLocalisedText("kickplayer"),"",true)
			thisKickMenu:SetMenuWidthOffset(menuWidth)
			
			local thisItem = NativeUI.CreateItem(GetLocalisedText("reason"),GetLocalisedText("kickreasonguide"))
			thisKickMenu:AddItem(thisItem)
			KickReason = GetLocalisedText("noreason")
			thisItem:RightLabel(KickReason)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128 + 1)
				
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 0 )
				end
				
				local result = GetOnscreenKeyboardResult()
				
				if result and result ~= "" then
					KickReason = result
					thisItem:RightLabel(result) -- this is broken for now
				else
					KickReason = GetLocalisedText("noreason")
				end
			end
			
			local thisItem = NativeUI.CreateItem(GetLocalisedText("confirmkick"),GetLocalisedText("confirmkickguide"))
			thisKickMenu:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				if KickReason == "" then
					KickReason = GetLocalisedText("noreason")
				end
				TriggerServerEvent("EasyAdmin:kickPlayer", thePlayer.id, KickReason)
				BanTime = 1
				BanReason = ""
				_menuPool:CloseAllMenus()
				Citizen.Wait(800)
				GenerateMenu()
				playermanagement:Visible(true)
			end	
		end
		
		if permissions["ban"] then
			local thisBanMenu = _menuPool:AddSubMenu(thisPlayer,GetLocalisedText("banplayer"),"",true)
			thisBanMenu:SetMenuWidthOffset(menuWidth)
			
			local thisItem = NativeUI.CreateItem(GetLocalisedText("reason"),GetLocalisedText("banreasonguide"))
			thisBanMenu:AddItem(thisItem)
			BanReason = GetLocalisedText("noreason")
			thisItem:RightLabel(BanReason)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128 + 1)
				
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait( 0 )
				end
				
				
				local result = GetOnscreenKeyboardResult()
				
				if result and result ~= "" then
					BanReason = result
					thisItem:RightLabel(result) -- this is broken for now
				else
					BanReason = GetLocalisedText("noreason")
				end
			end
			local bt = {}
			for i,a in ipairs(banLength) do
				table.insert(bt, a.label)
			end
			
			local thisItem = NativeUI.CreateListItem(GetLocalisedText("banlength"),bt, 1,GetLocalisedText("banlengthguide") )
			thisBanMenu:AddItem(thisItem)
			local BanTime = 1
			thisItem.OnListChanged = function(sender,item,index)
				BanTime = index
			end
		
			local thisItem = NativeUI.CreateItem(GetLocalisedText("confirmban"),GetLocalisedText("confirmbanguide"))
			thisBanMenu:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				if BanReason == "" then
					BanReason = GetLocalisedText("noreason")
				end
				TriggerServerEvent("EasyAdmin:banPlayer", thePlayer.id, BanReason, banLength[BanTime].time, thePlayer.name )
				BanTime = 1
				BanReason = ""
				_menuPool:CloseAllMenus()
				Citizen.Wait(800)
				GenerateMenu()
				playermanagement:Visible(true)
			end	
			
		end

		if permissions["spectate"] then
			local thisItem = NativeUI.CreateItem(GetLocalisedText("spectateplayer"), "")
			thisPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:requestSpectate",thePlayer.id)
			end
		end
		
		if permissions["teleport.player"] then
			local thisItem = NativeUI.CreateItem(GetLocalisedText("teleporttoplayer"),"")
			thisPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				if not RedM then
					TriggerServerEvent('EasyAdmin:TeleportAdminToPlayer', thePlayer.id)
				else
					local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(thePlayer.id)),true))
					local heading = GetEntityHeading(GetPlayerPed(player))
					SetEntityCoords(PlayerPedId(), x,y,z,0,0,heading, false)
				end
			end
		end
		
		if permissions["teleport.player"] then
			local thisItem = NativeUI.CreateItem(GetLocalisedText("teleportplayertome"),"")
			thisPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				local coords = GetEntityCoords(PlayerPedId(),true)
				TriggerServerEvent("EasyAdmin:TeleportPlayerToCoords", thePlayer.id, coords)
			end
		end
		
		if permissions["slap"] then
			local thisItem = NativeUI.CreateSliderItem(GetLocalisedText("slapplayer"), SlapAmount, 20, false, false)
			thisPlayer:AddItem(thisItem)
			thisItem.OnSliderSelected = function(index)
				TriggerServerEvent("EasyAdmin:SlapPlayer", thePlayer.id, index*10)
			end
		end

		if permissions["freeze"] and not RedM then
			local sl = {GetLocalisedText("on"), GetLocalisedText("off")}
			local thisItem = NativeUI.CreateListItem(GetLocalisedText("setplayerfrozen"), sl, 1)
			thisPlayer:AddItem(thisItem)
			thisPlayer.OnListSelect = function(sender, item, index)
					if item == thisItem then
							i = item:IndexToItem(index)
							if i == GetLocalisedText("on") then
								TriggerServerEvent("EasyAdmin:FreezePlayer", thePlayer.id, true)
							else
								TriggerServerEvent("EasyAdmin:FreezePlayer", thePlayer.id, false)
							end
					end
			end
		end
	
		if permissions["screenshot"] then
			local thisItem = NativeUI.CreateItem(GetLocalisedText("takescreenshot"),"")
			thisPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				TriggerServerEvent("EasyAdmin:TakeScreenshot", thePlayer.id)
			end
		end
		
		_menuPool:ControlDisablingEnabled(false)
		_menuPool:MouseControlsEnabled(false)
	end
	
	local coordsVisible = false

	function DrawGenericText(text)
		SetTextColour(255, 186, 186, 255)
		SetTextFont(7)
		SetTextScale(1.0, 1.0)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 200, 200, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(0.40, 0.00)
	end
	
	Citizen.CreateThread(function()
		while true do
			local sleepThread = 250
			
			if coordsVisible then
				sleepThread = 5
	
				local playerPed = PlayerPedId()
				local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
				local playerH = GetEntityHeading(playerPed)
	
				DrawGenericText(("~g~X~w~: %s ~g~Y~w~: %s ~g~Z~w~: %s ~g~H~w~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))
			end
	
			Citizen.Wait(sleepThread)
		end
	end)

	function tpm()
		local WaypointHandle = GetFirstBlipInfoId(8)

		if DoesBlipExist(WaypointHandle) then
			local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

			for height = 1, 1000 do
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

				if foundGround then
					SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

					break
				end

				Citizen.Wait(5)
			end

			TriggerEvent("esx:showNotification","Przeteleportowano.")
		else
			TriggerEvent("esx:showNotification","Zaznacz na mapie teleport.")
		end
	end

	function getmyposXD()
		local ped = GetPlayerPed(PlayerId())
		local coords = GetEntityCoords(ped, false)
		local heading = GetEntityHeading(ped)
		TriggerEvent("chatMessage", tostring("X: " .. coords.x .. " Y: " .. coords.y .. " Z: " .. coords.z .. " HEADING: " .. heading))
	end
	
	function daojosdinpatpemata()
		local ax = GetPlayerPed(-1)
		local ay = GetVehiclePedIsIn(ax, true)
		if
			IsPedInAnyVehicle(GetPlayerPed(-1), 0) and
				GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)
		 then
			SetVehicleOnGroundProperly(ay)
			TriggerEvent('esx:showNotification', '~g~Pojazd obrócony')
		else
			TriggerEvent('esx:showNotification', '~b~Nie jesteś w pojeździe')
		end
	end
	
	function FormatCoord(coord)
		if coord == nil then
			return "unknown"
		end
	
		return tonumber(string.format("%.2f", coord))
	end	

	function ToggleCoords()
		coordsVisible = not coordsVisible
	end
	
	if permissions["unban"] then
		local twojstary = _menuPool:AddSubMenu(servermanagement, "Pogoda", "", true)
		twojstary:SetMenuWidthOffset(menuWidth)	
		
		if permissions["unban"] then
			local thisItem = NativeUI.CreateItem("Zatrzymaj Czas", "")
			twojstary:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				ExecuteCommand('freezetime')
				what = "zatrzymał czas"
				TriggerServerEvent("essential:EasyAdmin", what)
			end
		end

		if permissions["unban"] then
			local thisItem = NativeUI.CreateItem("Zatrzymaj Pogodę", "")
			twojstary:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				ExecuteCommand('freezeweather')
				what = "zatrzymał pogodę"
				TriggerServerEvent("essential:EasyAdmin", what)
			end
		end

		
		if permissions["unban"] then
			local thisItem = NativeUI.CreateItem("Wyczyść Pogodę", "")
			twojstary:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				ExecuteCommand('weather clear')
				what = "wyczyścił pogodę"
				TriggerServerEvent("essential:EasyAdmin", what)
			end
		end

		if permissions["unban"] then
			local thisItem = NativeUI.CreateItem("Dzień", "")
			twojstary:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				ExecuteCommand('morning')
				what = "ustawił dzień"
				TriggerServerEvent("essential:EasyAdmin", what)
			end
		end

		if permissions["unban"] then
			local thisItem = NativeUI.CreateItem("Noc", "")
			twojstary:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				ExecuteCommand('night')
				what = "ustawił noc"
				TriggerServerEvent("essential:EasyAdmin", what)
			end
		end

		if permissions["unban"] then
			local thisItem = NativeUI.CreateItem("Południe", "")
			twojstary:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				ExecuteCommand('noon')
				what = "ustawił południe"
				TriggerServerEvent("essential:EasyAdmin", what)
			end
		end

		if permissions["unban"] then
			local thisItem = NativeUI.CreateItem("Wieczór", "")
			twojstary:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				ExecuteCommand('evening')
				what = "ustawił wieczór"
				TriggerServerEvent("essential:EasyAdmin", what)
			end
		end

	end

	if permissions["unban"] then
	
		local twojstarydev = _menuPool:AddSubMenu(servermanagement, "Dev", "", true)
		twojstarydev:SetMenuWidthOffset(menuWidth)	

	if permissions["unban"] then
		local thisItem = NativeUI.CreateCheckboxItem('Coords', "")
		twojstarydev:AddItem(thisItem)
		thisItem.CheckboxEvent = function(sender, item, status)
			if item == thisItem then
				ToggleCoords()
				else
				print('xd')
			end
		end
	end

	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Coords Chat", "")
		twojstarydev:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			getmyposXD()
		end
	end
		
		--[[

			Pojazdy

	]]--

	if permissions["unban"] then
		
		local twojstaryauta = _menuPool:AddSubMenu(servermanagement, "Auta", "", true)
		twojstaryauta:SetMenuWidthOffset(menuWidth)	


	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Napraw pojazd", "")
		twojstaryauta:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			TriggerEvent('esx:showNotification', 'Naprawiono pojazd!')
			what = "naprawił pojazd"
			TriggerServerEvent("essential:EasyAdmin", what)
		end
	end
	
	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Police Extras Menu", "")
		twojstaryauta:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			_menuPool:CloseAllMenus()
			TriggerEvent('esx:showNotification', 'Otworzyełeś Menu Extrasów Policji')
			Citizen.Wait(300)
			exports['esx_policejob']:OpenMainMenu()
			what = "otworzył menu Policejob Extras menu"
			TriggerServerEvent("essential:EasyAdmin", what)

		end
	end

	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Tuninguj", "")
		twojstaryauta:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			_menuPool:CloseAllMenus()
			TriggerEvent('esx:showNotification', 'Otworzyełeś Tuningowanie pojazdów')
			Citizen.Wait(300)
			exports['esx_lscustomsV2']:DriveInGarage()
			what = "otworzył menu tuningowania"
			TriggerServerEvent("essential:EasyAdmin", what)
		end
	end

	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Obróć pojazd", "")
		twojstaryauta:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			daojosdinpatpemata()
			what = "obrócił pojazd"
			TriggerServerEvent("essential:EasyAdmin", what)
		end
	end

	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Usuń pojazd", "")
		twojstaryauta:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerEvent('esx:deleteVehicle')
			TriggerEvent('esx:showNotification', 'Usunięto pojazd!')
			TriggerServerEvent("logMenuAdmin", '\n- Usunięto pojazd!')
		end
	end
	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Dodaj auto (SaveCar)", "")
		twojstaryauta:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			local vehicle = GetVehiclePedIsUsing(PlayerPedId())
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			TriggerServerEvent("esx_vehicleshop:setVehicleOwned", vehicleProps)
			TriggerServerEvent('garages:savecarlog')
		end
	end
end
	

	--[[

			Ambulance System itp

	]]--
	if permissions["unban"] then
		
		local ambulancegarnuch = _menuPool:AddSubMenu(servermanagement, "Ambulance", "", true)
		ambulancegarnuch:SetMenuWidthOffset(menuWidth)	


	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Dodaj Armor", "")
		ambulancegarnuch:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			SetPedArmour(PlayerPedId(), 200)
			TriggerEvent('esx:showNotification', 'Dodałeś aromor!')
			what = "Dodano armor"
			TriggerServerEvent("essential:EasyAdmin", what)
		end
	end

	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Zabij się", "")
		ambulancegarnuch:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			SetEntityHealth(PlayerPedId(), 0)
			TriggerEvent('esx:showNotification', 'Zabiłeś się!')
			what = "zabił się"
			TriggerServerEvent("essential:EasyAdmin", what)
		end
	end
	
	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Revive", "")
		ambulancegarnuch:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerEvent('esx_ambulancejob:revive', source)
			TriggerEvent('esx:showNotification', 'Uzdrowiłeś się!')
			what = "Uleczył się (revive)"
			TriggerServerEvent("essential:EasyAdmin", what)
		end
	end

	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Ulecz", "")
		ambulancegarnuch:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerEvent('esx_basicneeds:healPlayer', source)
			TriggerEvent('esx:showNotification', 'Uleczyłeś się!')
			what = "Uleczył się"
			TriggerServerEvent("essential:EasyAdmin", what)
		end
	end
end
if permissions["unban"] then
		
	local krzysiubazatykurwogarnuch = _menuPool:AddSubMenu(servermanagement, "System", "", true)
	krzysiubazatykurwogarnuch:SetMenuWidthOffset(menuWidth)	

	-- whitelsity
	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Przeładuj Whitelist", "")
		krzysiubazatykurwogarnuch:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			ExecuteCommand('wlrefresh')
			TriggerEvent('esx:showNotification', 'Whitelist przeładowana')
		end
	end
	-- bany
	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem("Przeładuj Ban Listę (SQLBAN COMMAND)", "")
		krzysiubazatykurwogarnuch:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			ExecuteCommand('sqlbanreload')
			TriggerEvent('esx:showNotification', 'Lista banów przeładowana')
		end
	end

	if permissions["unban"] then
		unbanPlayer = _menuPool:AddSubMenu(krzysiubazatykurwogarnuch,GetLocalisedText("unbanplayer"),"",true)
		unbanPlayer:SetMenuWidthOffset(menuWidth)
		local reason = ""
		local identifier = ""

		local thisItem = NativeUI.CreateItem("Wyszukaj osobę", "")
		unbanPlayer:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			-- TODO
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128 + 1)
				
			while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
				Citizen.Wait( 0 )
			end
			
			local result = GetOnscreenKeyboardResult()
			local foundBan = false
			if result then
				for i,theBanned in ipairs(banlist) do
					if foundBan then
						break
					end
					if theBanned.banid == result then
						foundBan=true
						foundBanid=i
						break
					end 
					if theBanned.name then
						if string.find(theBanned.name, result) then
							foundBan=true
							foundBanid=i
							break
						end
					end
					if string.find((theBanned.reason or "No Reason"), result) then
						foundBan=true
						foundBanid=i
						break
					end
					for _, identifier in pairs(theBanned.identifiers) do
						if string.find(identifier, result) then
							foundBan=true
							foundBanid=i
							break
						end
					end
				end
			end
			_menuPool:CloseAllMenus()
			Citizen.Wait(300)
			if foundBan then
				_menuPool:Remove()
				_menuPool = NativeUI.CreatePool()
				collectgarbage()
				if not GetResourceKvpString("ea_menuorientation") then
					SetResourceKvp("ea_menuorientation", "right")
					SetResourceKvpInt("ea_menuwidth", 0)
					menuWidth = 0
					menuOrientation = handleOrientation("right")
				else
					menuWidth = GetResourceKvpInt("ea_menuwidth")
					menuOrientation = handleOrientation(GetResourceKvpString("ea_menuorientation"))
				end 
				
				mainMenu = NativeUI.CreateMenu("EasyAdmin", "~b~Ban Infos", menuOrientation, 0)
				_menuPool:Add(mainMenu)
				
					mainMenu:SetMenuWidthOffset(menuWidth)	
				_menuPool:ControlDisablingEnabled(false)
				_menuPool:MouseControlsEnabled(false)


				
				local thisItem = NativeUI.CreateItem(GetLocalisedText("reason"),banlist[foundBanid].reason)
				mainMenu:AddItem(thisItem)
				thisItem.Activated = function(ParentMenu,SelectedItem)
					--nothing
				end	

				if banlist[foundBanid].name then
					local thisItem = NativeUI.CreateItem("Name: "..banlist[foundBanid].name)
					mainMenu:AddItem(thisItem)
					thisItem.Activated = function(ParentMenu,SelectedItem)
						--nothing
					end	
				end
				
				for _, identifier in pairs(banlist[foundBanid].identifiers) do
					local thisItem = NativeUI.CreateItem(string.format(GetLocalisedText("identifier"), string.split(identifier, ":")[1]),identifier)
					mainMenu:AddItem(thisItem)
					thisItem.Activated = function(ParentMenu,SelectedItem)
						--nothing
					end	
				end

				local thisItem = NativeUI.CreateItem(GetLocalisedText("unbanplayer"), GetLocalisedText("unbanplayerguide"))
				mainMenu:AddItem(thisItem)
				thisItem.Activated = function(ParentMenu,SelectedItem)
					TriggerServerEvent("EasyAdmin:unbanPlayer", banlist[foundBanid].banid)
					TriggerServerEvent("EasyAdmin:requestBanlist")
					_menuPool:CloseAllMenus()
					Citizen.Wait(800)
					GenerateMenu()
					unbanPlayer:Visible(true)
				end	


				mainMenu:Visible(true)
			else
				ShowNotification(GetLocalisedText("searchbansfail"))
				GenerateMenu()
				unbanPlayer:Visible(true)
			end

		end	

		for i,theBanned in ipairs(banlist) do
			if i<(banlistPage*10)+1 and i>(banlistPage*10)-10 then
				if theBanned then
					reason = theBanned.reason or "No Reason"
					local thisItem = NativeUI.CreateItem(reason, GetLocalisedText("unbanplayerguide"))
					unbanPlayer:AddItem(thisItem)
					thisItem.Activated = function(ParentMenu,SelectedItem)
						TriggerServerEvent("EasyAdmin:unbanPlayer", theBanned.banid)
						TriggerServerEvent("EasyAdmin:requestBanlist")
						_menuPool:CloseAllMenus()
						Citizen.Wait(800)
						GenerateMenu()
						unbanPlayer:Visible(true)
					end	
				end
			end
		end


		if #banlist > (banlistPage*10) then 
			local thisItem = NativeUI.CreateItem(GetLocalisedText("lastpage"), "")
			unbanPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				banlistPage = math.ceil(#banlist/10)
				_menuPool:CloseAllMenus()
				Citizen.Wait(300)
				GenerateMenu()
				unbanPlayer:Visible(true)
			end	
		end

		if banlistPage>1 then 
			local thisItem = NativeUI.CreateItem(GetLocalisedText("firstpage"), "")
			unbanPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				banlistPage = 1
				_menuPool:CloseAllMenus()
				Citizen.Wait(300)
				GenerateMenu()
				unbanPlayer:Visible(true)
			end	
			local thisItem = NativeUI.CreateItem(GetLocalisedText("previouspage"), "")
			unbanPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				banlistPage=banlistPage-1
				_menuPool:CloseAllMenus()
				Citizen.Wait(300)
				GenerateMenu()
				unbanPlayer:Visible(true)
			end	
		end
		if #banlist > (banlistPage*10) then
			local thisItem = NativeUI.CreateItem(GetLocalisedText("nextpage"), "")
			unbanPlayer:AddItem(thisItem)
			thisItem.Activated = function(ParentMenu,SelectedItem)
				banlistPage=banlistPage+1
				_menuPool:CloseAllMenus()
				Citizen.Wait(300)
				GenerateMenu()
				unbanPlayer:Visible(true)
			end	
		end 


	end
	
	CachedList = _menuPool:AddSubMenu(krzysiubazatykurwogarnuch,GetLocalisedText("cachedplayers"),"",true)
	CachedList:SetMenuWidthOffset(menuWidth)
	if permissions["ban"] then
		for i, cachedplayer in pairs(cachedplayers) do
			if cachedplayer.droppedTime and not cachedplayer.immune then
				thisPlayer = _menuPool:AddSubMenu(CachedList,"["..cachedplayer.id.."] "..cachedplayer.name,"",true)
				thisPlayer:SetMenuWidthOffset(menuWidth)
				local thisBanMenu = _menuPool:AddSubMenu(thisPlayer,GetLocalisedText("banplayer"),"",true)
				thisBanMenu:SetMenuWidthOffset(menuWidth)
				
				local thisItem = NativeUI.CreateItem(GetLocalisedText("reason"),GetLocalisedText("banreasonguide"))
				thisBanMenu:AddItem(thisItem)
				BanReason = GetLocalisedText("noreason")
				thisItem:RightLabel(BanReason)
				thisItem.Activated = function(ParentMenu,SelectedItem)
					DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128 + 1)
					
					while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
						Citizen.Wait( 0 )
					end
					
					local result = GetOnscreenKeyboardResult()
					
					if result and result ~= "" then
						BanReason = result
						thisItem:RightLabel(result) -- this is broken for now
					else
						BanReason = GetLocalisedText("noreason")
					end
				end
				local bt = {}
				for i,a in ipairs(banLength) do
					table.insert(bt, a.label)
				end
				
				local thisItem = NativeUI.CreateListItem(GetLocalisedText("banlength"),bt, 1,GetLocalisedText("banlengthguide") )
				thisBanMenu:AddItem(thisItem)
				local BanTime = 1
				thisItem.OnListChanged = function(sender,item,index)
					BanTime = index
				end
			
				local thisItem = NativeUI.CreateItem(GetLocalisedText("confirmban"),GetLocalisedText("confirmbanguide"))
				thisBanMenu:AddItem(thisItem)
				thisItem.Activated = function(ParentMenu,SelectedItem)
					if BanReason == "" then
						BanReason = GetLocalisedText("noreason")
					end
					TriggerServerEvent("EasyAdmin:offlinebanPlayer", cachedplayer.id, BanReason, banLength[BanTime].time, cachedplayer.name)
					BanTime = 1
					BanReason = ""
					_menuPool:CloseAllMenus()
					Citizen.Wait(800)
					GenerateMenu()
					playermanagement:Visible(true)
				end	
			end
		end
	end
	
end

if permissions["unban"] then
	local thisItem = NativeUI.CreateCheckboxItem('Nie widoczność', not IsEntityVisible(GetPlayerPed(-1)), "")
	twojstarydev:AddItem(thisItem)
	thisItem.CheckboxEvent = function(sender, item, status)
		if item == thisItem then
			local pid = PlayerPedId()
			SetEntityVisible(pid, not IsEntityVisible(pid))
			TriggerEvent('esx:showNotification', 'Jesteś niewidoczny!')
			what = "włączył niewidoczność"
			TriggerServerEvent("essential:EasyAdmin", what)
			else
			TriggerEvent('esx:showNotification', 'Jesteś widoczny!')
		end
	end
end
if permissions["unban"] then
	local thisItem = NativeUI.CreateCheckboxItem('GodMode', not IsEntityVisible(GetPlayerPed(-1)), "")
	twojstarydev:AddItem(thisItem)
	thisItem.CheckboxEvent = function(sender, item, status)
		if item == thisItem then
			local pid = PlayerPedId()
			SetPlayerInvincible(pid, not GetPlayerInvincible(pid))
			TriggerEvent('esx:showNotification', 'Godmode włączony!')
			what = "włączył godmode"
			TriggerServerEvent("essential:EasyAdmin", what)
			else
			TriggerEvent('esx:showNotification', 'Godmode wyłączony!')
		end
	end
end

if permissions["unban"] then

	local thisItem = NativeUI.CreateCheckboxItem("Noclip ", noClip, "")
	twojstarydev:AddItem(thisItem)

	thisItem.CheckboxEvent = function(sender, item, status)
		if item == thisItem then
			noClip = not noClip
			if not noClip then
				noClipSpeed = 1
			end
		end
	end
end

if permissions["unban"] then
	local thisItem = NativeUI.CreateItem("Save All Players", "")
	twojstarydev:AddItem(thisItem)
	thisItem.Activated = function(ParentMenu,SelectedItem)
		TriggerServerEvent('SavellPlayer')
		TriggerEvent('esx:showNotification', 'Saved all players!')
		what = "wykonał save all players"
		TriggerServerEvent("essential:EasyAdmin", what)
	end
end

if permissions["unban"] then
	local thisItem = NativeUI.CreateItem("Teleportuj do znacznika", "")
	twojstarydev:AddItem(thisItem)
	thisItem.Activated = function(ParentMenu,SelectedItem)
		tpm()
		what = "wykomał funkcję TPM"
		TriggerServerEvent("essential:EasyAdmin", what)
	end
end

end

	if permissions["unban"] then
		local sl = {GetLocalisedText("unbanreasons"), GetLocalisedText("unbanlicenses")}
		local thisItem = NativeUI.CreateListItem(GetLocalisedText("banlistshowtype"), sl, 1,GetLocalisedText("banlistshowtypeguide"))
		settingsMenu:AddItem(thisItem)
		settingsMenu.OnListChange = function(sender, item, index)
				if item == thisItem then
						i = item:IndexToItem(index)
						if i == GetLocalisedText(unbanreasons) then
							showLicenses = false
						else
							showLicenses = true
						end
				end
		end
	end
	
	
	if permissions["unban"] then
		local thisItem = NativeUI.CreateItem(GetLocalisedText("refreshbanlist"), GetLocalisedText("refreshbanlistguide"))
		settingsMenu:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:updateBanlist")
		end
	end

	if permissions["ban"] then
		local thisItem = NativeUI.CreateItem(GetLocalisedText("refreshcachedplayers"), GetLocalisedText("refreshcachedplayersguide"))
		settingsMenu:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent("EasyAdmin:requestCachedPlayers")
		end
	end
	
	local thisItem = NativeUI.CreateItem(GetLocalisedText("refreshpermissions"), GetLocalisedText("refreshpermissionsguide"))
	settingsMenu:AddItem(thisItem)
	thisItem.Activated = function(ParentMenu,SelectedItem)
		TriggerServerEvent("EasyAdmin:amiadmin")
	end
	
	local sl = {GetLocalisedText("left"), GetLocalisedText("middle"), GetLocalisedText("right")}
	local thisItem = NativeUI.CreateListItem(GetLocalisedText("menuOrientation"), sl, 1, GetLocalisedText("menuOrientationguide"))
	settingsMenu:AddItem(thisItem)
	settingsMenu.OnListChange = function(sender, item, index)
			if item == thisItem then
					i = item:IndexToItem(index)
					if i == GetLocalisedText("left") then
						SetResourceKvp("ea_menuorientation", "left")
					elseif i == GetLocalisedText("middle") then
						SetResourceKvp("ea_menuorientation", "middle")
					else
						SetResourceKvp("ea_menuorientation", "right")
					end
			end
	end
	local sl = {}
	for i=0,150,10 do
		table.insert(sl,i)
	end
	local thisi = 0
	for i,a in ipairs(sl) do
		if menuWidth == a then
			thisi = i
		end
	end
	local thisItem = NativeUI.CreateSliderItem(GetLocalisedText("menuOffset"), sl, thisi, GetLocalisedText("menuOffsetguide"), false)
	settingsMenu:AddItem(thisItem)
	thisItem.OnSliderSelected = function(index)
		i = thisItem:IndexToItem(index)
		SetResourceKvpInt("ea_menuwidth", i)
		menuWidth = i
	end
	thisi = nil
	sl = nil


	local thisItem = NativeUI.CreateItem(GetLocalisedText("resetmenuOffset"), "")
	settingsMenu:AddItem(thisItem)
	thisItem.Activated = function(ParentMenu,SelectedItem)
		SetResourceKvpInt("ea_menuwidth", 0)
		menuWidth = 0
	end
	_menuPool:ControlDisablingEnabled(false)
	_menuPool:MouseControlsEnabled(false)
	
	_menuPool:RefreshIndex() -- refresh indexes
end


Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		if drawInfo then
			local text = {}
			-- cheat checks
			local targetPed = GetPlayerPed(drawTarget)
			local targetGod = GetPlayerInvincible(drawTarget)
			if targetGod then
				table.insert(text,GetLocalisedText("godmodedetected"))
			else
				table.insert(text,GetLocalisedText("godmodenotdetected"))
			end
			if not CanPedRagdoll(targetPed) and not IsPedInAnyVehicle(targetPed, false) and (GetPedParachuteState(targetPed) == -1 or GetPedParachuteState(targetPed) == 0) and not IsPedInParachuteFreeFall(targetPed) then
				table.insert(text,GetLocalisedText("antiragdoll"))
			end
			-- health info
			table.insert(text,GetLocalisedText("health")..": "..GetEntityHealth(targetPed).."/"..GetEntityMaxHealth(targetPed))
			table.insert(text,GetLocalisedText("armor")..": "..GetPedArmour(targetPed))
			-- misc info
			table.insert(text,GetLocalisedText("wantedlevel")..": "..GetPlayerWantedLevel(drawTarget))
			table.insert(text,GetLocalisedText("exitspectator"))
			
			for i,theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7+(i/30))
			end
			
			if (not RedM and IsControlJustPressed(0,103) or (RedM and IsControlJustReleased(0, Controls["VehExit"]))) then
				local targetPed = PlayerPedId()
				local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
	
				spectatePlayer(GetPlayerPed(PlayerId()),GetPlayerFromServerId(PlayerId()),GetPlayerName(PlayerId()))
				TriggerEvent('EasyAdmin:FreezePlayer', false)
				--SetEntityCoords(PlayerPedId(), oldCoords.x, oldCoords.y, oldCoords.z, 0, 0, 0, false)
				if not RedM then
					TriggerEvent('EasyAdmin:FreezePlayer', false)
				end
	
				StopDrawPlayerInfo()
				ShowNotification(GetLocalisedText("stoppedSpectating"))
			end
			
		end
	end
end)
