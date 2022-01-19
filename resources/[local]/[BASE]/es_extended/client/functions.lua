ESX                           = {}
ESX.PlayerData                = {}
ESX.PlayerLoaded              = false
ESX.CurrentRequestId          = 0
ESX.ServerCallbacks           = {}
ESX.TimeoutCallbacks          = {}

ESX.UI                        = {}
ESX.UI.HUD                    = {}
ESX.UI.HUD.RegisteredElements = {}
ESX.UI.Menu                   = {}
ESX.UI.Menu.RegisteredTypes   = {}
ESX.UI.Menu.Opened            = {}

ESX.Game                      = {}
ESX.Game.Utils                = {}
ESX.Game.Utils.HeadshotCache  = {}

ESX.Scaleform                 = {}
ESX.Scaleform.Utils           = {}

ESX.Streaming                 = {}

ESX.SetTimeout = function(msec, cb)
	table.insert(ESX.TimeoutCallbacks, {
		time = GetGameTimer() + msec,
		cb   = cb
	})
	return #ESX.TimeoutCallbacks
end

ESX.ClearTimeout = function(i)
	ESX.TimeoutCallbacks[i] = nil
end

ESX.IsPlayerLoaded = function()
	return ESX.PlayerLoaded
end

ESX.GetPlayerData = function()
	return ESX.PlayerData
end

ESX.SetPlayerData = function(key, val)
	ESX.PlayerData[key] = val
end

ESX.DrawMarker = function(coords)
	if coords then
		DrawMarker(27, coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 56, 197, 201, 175, false, true, 2, true, false, false, false)
	end
end

ESX.DrawBigMarker = function(coords)
	if coords then
		DrawMarker(27, coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 4.0, 4.0, 4.0, 56, 197, 201, 175, false, true, 2, true, false, false, false)
	end
end

ESX.ShowNotification = function(msg)
    TriggerEvent("FeedM:showNotification", msg)
end

ESX.ShowAdvancedNotification = function(title, subject, msg, icon, color)
    TriggerEvent("FeedM:showAdvancedNotification", title, subject, msg, icon, 5000, ((color and tonumber(color)) and 'primary' or color))
end

--[[ESX.ShowHelpNotification = function(msg, thisFrame, beep, duration)
	AddTextEntry('esxHelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('esxHelpNotification', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('esxHelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end]]

ESX.ShowHelpNotification = function(msg)
	--if not IsHelpMessageBeingDisplayed() then
		BeginTextCommandDisplayHelp('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandDisplayHelp(0, false, true, -1)
	--end
end

ESX.ShowFloatingHelpNotification = function(msg, coords)
	AddTextEntry('esxFloatingHelpNotification', msg)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

ESX.TriggerServerCallback = function(name, cb, ...)
	ESX.ServerCallbacks[ESX.CurrentRequestId] = cb

	TriggerServerEvent('esx:triggerServerCallback', name, ESX.CurrentRequestId, ...)

	if ESX.CurrentRequestId < 65535 then
		ESX.CurrentRequestId = ESX.CurrentRequestId + 1
	else
		ESX.CurrentRequestId = 0
	end
end

ESX.UI.HUD.SetDisplay = function(opacity)
	SendNUIMessage({
		action  = 'setHUDDisplay',
		opacity = opacity
	})
end

ESX.UI.HUD.RegisterElement = function(name, index, priority, html, data)
	local found = false

	for i=1, #ESX.UI.HUD.RegisteredElements, 1 do
		if ESX.UI.HUD.RegisteredElements[i] == name then
			found = true
			break
		end
	end

	if found then
		return
	end

	table.insert(ESX.UI.HUD.RegisteredElements, name)

	SendNUIMessage({
		action    = 'insertHUDElement',
		name      = name,
		index     = index,
		priority  = priority,
		html      = html,
		data      = data
	})

	ESX.UI.HUD.UpdateElement(name, data)
end

ESX.UI.HUD.RemoveElement = function(name)
	for i=1, #ESX.UI.HUD.RegisteredElements, 1 do
		if ESX.UI.HUD.RegisteredElements[i] == name then
			table.remove(ESX.UI.HUD.RegisteredElements, i)
			break
		end
	end

	SendNUIMessage({
		action    = 'deleteHUDElement',
		name      = name
	})
end

ESX.UI.HUD.UpdateElement = function(name, data)
	SendNUIMessage({
		action = 'updateHUDElement',
		name   = name,
		data   = data
	})
end

ESX.UI.Menu.RegisterType = function(type, open, close)
	ESX.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

ESX.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close, delete)
	local menu = {}
	menu.type = type
	menu.namespace = namespace
	menu.name = name
	menu.data = data
	menu.submit = submit
	menu.cancel = cancel
	menu.change = change
	menu.delete = delete

	menu.close = function()
		ESX.UI.Menu.RegisteredTypes[type].close(namespace, name)
		for i = 1, #ESX.UI.Menu.Opened, 1 do
			if ESX.UI.Menu.Opened[i] ~= nil then
				if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
					ESX.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close ~= nil then
			close()
		end
	end

	menu.update = function(query, newData)
		for i = 1, #menu.data.elements, 1 do
			local match = true
				for k,v in pairs(query) do
					if menu.data.elements[i][k] ~= v then
						match = false
					end
				end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end
	end

	menu.refresh = function()
		ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	menu.open = function()
		table.insert(ESX.UI.Menu.Opened, menu)
		ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, data)
	end

	table.insert(ESX.UI.Menu.Opened, menu)
	ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, data)
	
	return menu
end

ESX.UI.Menu.Close = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				ESX.UI.Menu.Opened[i].close()
				ESX.UI.Menu.Opened[i] = nil
			end
		end
	end
end

ESX.UI.Menu.CloseAll = function()
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			ESX.UI.Menu.Opened[i].close()
			ESX.UI.Menu.Opened[i] = nil
		end
	end
end

ESX.UI.Menu.GetOpened = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				return ESX.UI.Menu.Opened[i]
			end
		end
	end
end

ESX.UI.Menu.GetOpenedMenus = function()
	return ESX.UI.Menu.Opened
end

ESX.UI.Menu.IsOpen = function(type, namespace, name)
	return ESX.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

ESX.UI.ShowInventoryItemNotification = function(add, item, count)
    if item ~= 'Amunicja Pistolet' then
        SendNUIMessage({
            action = 'inventoryNotification',
            add    = add,
            item   = item,
            count  = count
        })
    end
end

ESX.Game.Utils.RenderHeadshotInternal = function(coords, skin, clbk)
	local ped = Citizen.InvokeNative(0xD49F9B0955C367DE, 3, skin['model'] or (skin['sex'] == 0 and `mp_m_freemode_01` or `mp_f_freemode_01`), coords.x, coords.y, coords.z - 50.0, 0.0, false, false)
	FreezeEntityPosition(ped, true)
	ClearPedDecorations(ped)
	ClearPedFacialDecorations(ped)

	if not skin['face_2'] then
		skin['face_2'] = skin['face']
		skin['face_3'] = skin['face']
		skin['skin_2'] = skin['skin']
		skin['skin_3'] = skin['skin']
		skin['blend_face'] = 10
		skin['blend_skin'] = 10
		skin['blend'] = 10
	end

	SetPedHeadBlendData(ped, skin['face'], skin['face_2'], skin['face_3'], skin['skin'], skin['skin_2'], skin['skin_3'], skin['blend_face'] / 10, skin['blend_skin'] / 10, skin['blend'] / 10, true)
	local decorations = exports['skinchanger']:GetDecorations()
	if skin['hair_3'] and skin['hair_3'] ~= 0 and decorations[skin['sex'] + 1] then
		local decor = decorations[skin['sex'] + 1][skin['hair_3']]
		if decor then
			SetPedFacialDecoration(ped, decor[1], decor[2])
		end
	end

	SetPedHairColor				(ped,			skin['hair_color_1'],		skin['hair_color_2'])					-- Hair Color
	SetPedHeadOverlay			(ped, 3,		skin['age_1'],				(skin['age_2'] / 10) + 0.0)			-- Age + opacity
	SetPedHeadOverlay			(ped, 1,		skin['beard_1'],			(skin['beard_2'] / 10) + 0.0)			-- Beard + opacity
	SetPedEyeColor				(ped,			skin['eye_color'], 0, 1)												-- Eyes color
	SetPedHeadOverlay			(ped, 2,		skin['eyebrows_1'],		(skin['eyebrows_2'] / 10) + 0.0)		-- Eyebrows + opacity
	SetPedHeadOverlay			(ped, 0,		skin['blemishes_1'],		(skin['blemishes_2'] / 10) + 0.0)		-- Blemishes + opacity
	SetPedHeadOverlay			(ped, 4,		skin['makeup_1'],			(skin['makeup_2'] / 10) + 0.0)			-- Makeup + opacity
	SetPedHeadOverlay			(ped, 8,		skin['lipstick_1'],		(skin['lipstick_2'] / 10) + 0.0)		-- Lipstick + opacity
	SetPedComponentVariation	(ped, 2,		skin['hair_1'],			skin['hair_2'], 2)						-- Hair
	SetPedHeadOverlayColor		(ped, 1, 1,	skin['beard_3'],			skin['beard_4'])						-- Beard Color
	SetPedHeadOverlayColor		(ped, 2, 1,	skin['eyebrows_3'],		skin['eyebrows_4'])					-- Eyebrows Color
	SetPedHeadOverlayColor		(ped, 4, 1,	skin['makeup_3'],			skin['makeup_4'])						-- Makeup Color
	SetPedHeadOverlayColor		(ped, 8, 1,	skin['lipstick_3'],		skin['lipstick_4'])					-- Lipstick Color
	SetPedHeadOverlay			(ped, 5,		skin['blush_1'],			(skin['blush_2'] / 10) + 0.0)			-- Blush + opacity
	SetPedHeadOverlayColor		(ped, 5, 2,	skin['blush_3'])														-- Blush Color
	SetPedHeadOverlay			(ped, 6,		skin['complexion_1'],		(skin['complexion_2'] / 10) + 0.0)		-- Complexion + opacity
	SetPedHeadOverlay			(ped, 7,		skin['sun_1'],				(skin['sun_2'] / 10) + 0.0)			-- Sun Damage + opacity
	SetPedHeadOverlay			(ped, 9,		skin['moles_1'],			(skin['moles_2'] / 10) + 0.0)			-- Moles/Freckles + opacity
	SetPedHeadOverlay			(ped, 10,		skin['chest_1'],			(skin['chest_2'] / 10) + 0.0)			-- Chest Hair + opacity
	SetPedHeadOverlayColor		(ped, 10, 1,	skin['chest_3'])														-- Torso Color
	SetPedHeadOverlay			(ped, 11,		skin['bodyb_1'],			(skin['bodyb_2'] / 10) + 0.0)			-- Body Blemishes + opacity

	if skin['ears_1'] == -1 then
		ClearPedProp(ped, 2)
	else
		SetPedPropIndex			(ped, 2,		skin['ears_1'],			skin['ears_2'], 2)						-- Ears Accessories
	end

	SetPedComponentVariation	(ped, 8,		skin['tshirt_1'],			skin['tshirt_2'], 2)					-- Tshirt
	SetPedComponentVariation	(ped, 11,		skin['torso_1'],			skin['torso_2'], 2)					-- torso parts
	SetPedComponentVariation	(ped, 3,		skin['arms'],				skin['arms_2'], 2)						-- Amrs
	SetPedComponentVariation	(ped, 10,		skin['decals_1'],			skin['decals_2'], 2)					-- decals
	SetPedComponentVariation	(ped, 4,		skin['pants_1'],			skin['pants_2'], 2)					-- pants
	SetPedComponentVariation	(ped, 6,		skin['shoes_1'],			skin['shoes_2'], 2)					-- shoes
	SetPedComponentVariation	(ped, 1,		skin['mask_1'],			skin['mask_2'], 2)						-- mask
	SetPedComponentVariation	(ped, 9,		skin['bproof_1'],			skin['bproof_2'], 2)					-- bulletproof
	SetPedComponentVariation	(ped, 7,		skin['chain_1'],			skin['chain_2'], 2)					-- chain
	SetPedComponentVariation	(ped, 5,		skin['bags_1'],			skin['bags_2'], 2)						-- Bag

	if skin['helmet_1'] == -1 then
		ClearPedProp(ped, 0)
	else
		SetPedPropIndex			(ped, 0,		skin['helmet_1'],			skin['helmet_2'], 2)					-- Helmet
	end

	if skin['glasses_1'] == -1 then
		ClearPedProp(ped, 1)
	else
		SetPedPropIndex			(ped, 1,		skin['glasses_1'],			skin['glasses_2'], 2)					-- Glasses
	end

	if skin['watches_1'] == -1 then
		ClearPedProp(ped, 6)
	else
		SetPedPropIndex			(ped, 6,		skin['watches_1'],			skin['watches_2'], 2)					-- Watches
	end

	if skin['bracelets_1'] == -1 then
		ClearPedProp(ped,	7)
	else
		SetPedPropIndex			(ped, 7,		skin['bracelets_1'],		skin['bracelets_2'], 2)				-- Bracelets
	end

	if skin['nose_1'] then
		SetPedFaceFeature(ped, 0, skin['nose_1'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 0, 0.0)
	end

	if skin['nose_2'] then
		SetPedFaceFeature(ped, 1, skin['nose_2'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 1, 0.0)
	end

	if skin['nose_3'] then
		SetPedFaceFeature(ped, 2, skin['nose_3'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 2, 0.0)
	end

	if skin['nose_4'] then
		SetPedFaceFeature(ped, 3, skin['nose_4'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 3, 0.0)
	end

	if skin['nose_5'] then
		SetPedFaceFeature(ped, 4, skin['nose_5'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 4, 0.0)
	end

	if skin['nose_6'] then
		SetPedFaceFeature(ped, 5, skin['nose_6'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 5, 0.0)
	end

	if skin['eyebrow_1'] then
		SetPedFaceFeature(ped, 6, skin['eyebrow_1'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 6, 0.0)
	end

	if skin['eyebrow_2'] then
		SetPedFaceFeature(ped, 7, skin['eyebrow_2'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 7, 0.0)
	end

	if skin['cheeks_1'] then
		SetPedFaceFeature(ped, 8, skin['cheeks_1'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 8, 0.0)
	end

	if skin['cheeks_2'] then
		SetPedFaceFeature(ped, 9, skin['cheeks_2'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 9, 0.0)
	end

	if skin['cheeks_3'] then
		SetPedFaceFeature(ped, 10, skin['cheeks_3'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 10, 0.0)
	end

	if skin['lips'] then
		SetPedFaceFeature(ped, 12, skin['lips'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 12, 0.0)
	end

	if skin['jaw_1'] then
		SetPedFaceFeature(ped, 11, skin['jaw_1'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 11, 0.0)
	end

	if skin['jaw_2'] then
		SetPedFaceFeature(ped, 13, skin['jaw_2'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 13, 0.0)
	end

	if skin['chimp_1'] then
		SetPedFaceFeature(ped, 14, skin['chimp_1'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 14, 0.0)
	end

	if skin['chimp_2'] then
		SetPedFaceFeature(ped, 15, skin['chimp_2'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 15, 0.0)
	end

	if skin['chimp_3'] then
		SetPedFaceFeature(ped, 16, skin['chimp_3'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 16, 0.0)
	end

	if skin['chimp_4'] then
		SetPedFaceFeature(ped, 17, skin['chimp_4'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 17, 0.0)
	end

	if skin['neck'] then
		SetPedFaceFeature(ped, 18, skin['neck'] / 10 - 1.0)
	else
		SetPedFaceFeature(ped, 18, 0.0)
	end

	Citizen.Wait(300)
	clbk(ESX.Game.GetPedMugshot(ped))
	DeletePed(ped)
end

ESX.Game.Utils.RenderHeadshotScoped = function(player, serverId, clbck)
	local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, player)
	local handle, txd = ESX.Game.GetPedMugshot(playerPed)

	local cache = ESX.Game.Utils.HeadshotCache[serverId]
	if cache then
		UnregisterPedheadshot(cache[1])
	end

	ESX.Game.Utils.HeadshotCache[serverId] = {handle, txd}
	clbck(txd)
	return cache ~= nil
end

ESX.Game.Utils.RenderHeadshot = function(c, sid, cb)
	sid = tonumber(sid)
	if sid then
		local sender = GetPlayerFromServerId(sid)
		if sender and sender ~= -1 then
			ESX.Game.Utils.RenderHeadshotScoped(sender, sid, function(txd)
				cb(txd)
			end)
			return true
		end

		ESX.TriggerServerCallback('skinchanger:getSkin', function(data)
			if data then
				ESX.Game.Utils.RenderHeadshotInternal(c, data, function(handle, txd)
					ESX.Game.Utils.HeadshotCache[sid] = {handle, txd}
					cb(txd)
				end)
			else
				cb('CHAR_HUMANDEFAULT')
			end
		end, sid)
		return false
	end

	cb('CHAR_HUMANDEFAULT')
	return true
end

ESX.Game.Utils.RenderHeadshotCached = function(position, target, considerCache, callback)
	target = tonumber(target)

	local cache = ESX.Game.Utils.HeadshotCache[target]
	if cache then
		if considerCache then
			callback(cache[2])
			return true
		end

		if considerCache == nil then
			local sender = GetPlayerFromServerId(target)
			if sender and sender ~= -1 then
				ESX.Game.Utils.RenderHeadshotScoped(sender, target, function(txd)
					callback(txd)
				end)
				return true
			end

			ESX.TriggerServerCallback('skinchanger:skinCache', function(cached)
				if cached then
					callback(cache[2])
				else
					ESX.Game.Utils.RenderHeadshot(position, target, callback)
				end
			end, target)
			return false
		end
	end

	ESX.Game.Utils.RenderHeadshot(position, target, callback)
	return false
end

ESX.Game.GetPedMugshot = function(ped, transparent)
	local mugshot = RegisterPedheadshot(ped)
  	while not IsPedheadshotReady(mugshot) do
    	Citizen.Wait(0)
  	end
  	return mugshot, GetPedheadshotTxdString(mugshot)
end

ESX.Game.Teleport = function(entity, coords, cb)
	if DoesEntityExist(entity) then
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		local timeout = 0

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(entity) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)

		if type(coords) == 'table' and coords.heading then
			SetEntityHeading(entity, coords.heading)
		end
	end

	if cb then
		cb()
	end
end

ESX.Game.SpawnObject = function(model, coords, cb)
	if coords == nil then
		coords = GetEntityCoords(PlayerPedId())
		forward = GetEntityForwardVector(PlayerPedId())
		coords = coords + forward * 1.0
	end
	local model = (type(model) == 'number' and model or GetHashKey(model))

	CreateThread(function()
		ESX.Streaming.RequestModel(model)
		local obj = Citizen.InvokeNative(0x509D5878EB39E842, model, coords.x, coords.y, coords.z, true, false, true)
		SetModelAsNoLongerNeeded(model)

		if cb then
			cb(obj)
		end
	end)
end

ESX.PlayAnim = function(dict, anim, speed, time, flag, freezeafter, checkisplaying)
    ESX.Streaming.RequestAnimDict(dict, function()
        if checkisplaying and ESX.IsPlayingAnim(dict, anim) then
            return
        end
        TaskPlayAnim(PlayerPedId(), dict, anim, speed, speed, time, flag, 1, false, false, false)
        if freezeafter then
            Wait(freezeafter)
            SetEntityAnimSpeed(PlayerPedId(), dict, anim, 0.0)
        end
    end)
end

ESX.Game.SpawnLocalObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	CreateThread(function()
		ESX.Streaming.RequestModel(model)
		local obj = Citizen.InvokeNative(0x509D5878EB39E842, model, coords.x, coords.y, coords.z, false, false, true)
		SetModelAsNoLongerNeeded(model)

		if cb then
			cb(obj)
		end
	end)
end

ESX.Game.DeleteVehicle = function(vehicle)
	SetEntityAsMissionEntity(vehicle, false, true)
	DeleteVehicle(vehicle)
end

ESX.Game.DeleteObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

ESX.Game.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	CreateThread(function()
		ESX.Streaming.RequestModel(model)

		local vehicle = Citizen.InvokeNative(0xAF35D0D2583051B0, model, coords.x, coords.y, coords.z, heading, true, false)
		local networkId = NetworkGetNetworkIdFromEntity(vehicle)
		local timeout = 0

		SetNetworkIdCanMigrate(networkId, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		if cb then
			cb(vehicle)
		end
	end)
end

ESX.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	CreateThread(function()
		ESX.Streaming.RequestModel(model)

		local vehicle = Citizen.InvokeNative(0xAF35D0D2583051B0, model, coords.x, coords.y, coords.z, heading, false, false)
		local timeout = 0

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		if cb then
			cb(vehicle)
		end
	end)
end

ESX.Game.IsVehicleEmpty = function(vehicle)
	local passengers = GetVehicleNumberOfPassengers(vehicle)
	local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

	return passengers == 0 and driverSeatFree
end

ESX.Game.GetObjects = function()
	local objects = {}

	for object in EnumerateObjects() do
		table.insert(objects, object)
	end

	return objects
end

ESX.Game.GetPeds = function(onlyOtherPeds)
	local peds, myPed = {}, PlayerPedId()

	for ped in EnumeratePeds() do
		if ((onlyOtherPeds and ped ~= myPed) or not onlyOtherPeds) then
			table.insert(peds, ped)
		end
	end

	return peds
end

ESX.Game.GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

ESX.Game.GetPlayers = function(onlyOtherPlayers, returnKeyValue, returnPeds)
	local players, myPlayer = {}, PlayerId()

	for k, player in ipairs(GetActivePlayers()) do
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, player)

		if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
			if returnKeyValue then
				players[player] = ped
			else
				table.insert(players, returnPeds and ped or player)
			end
		end
	end

	return players
end

ESX.Game.GetClosestObject = function(coords, modelFilter) return ESX.Game.GetClosestEntity(ESX.Game.GetObjects(), false, coords, modelFilter) end
ESX.Game.GetClosestPed = function(coords, modelFilter) return ESX.Game.GetClosestEntity(ESX.Game.GetPeds(true), false, coords, modelFilter) end
ESX.Game.GetClosestPlayer = function(coords, modelFilter) return ESX.Game.GetClosestEntity(ESX.Game.GetPlayers(true, true), true, coords, modelFilter) end
ESX.Game.GetClosestVehicle = function(coords, modelFilter) return ESX.Game.GetClosestEntity(ESX.Game.GetVehicles(), false, coords, modelFilter) end
ESX.Game.GetPlayersInArea = function(coords, maxDistance) return EnumerateEntitiesWithinDistance(ESX.Game.GetPlayers(true, true), true, coords, maxDistance) end
ESX.Game.GetVehiclesInArea = function(coords, maxDistance) return EnumerateEntitiesWithinDistance(ESX.Game.GetVehicles(), false, coords, maxDistance) end
ESX.Game.IsSpawnPointClear = function(coords, maxDistance) return #ESX.Game.GetVehiclesInArea(coords, maxDistance) == 0 end

ESX.Game.GetRestrictedVehicles = function(ignoreList)
	local ignoreList = ignoreList or {}
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		local found = false
		
		for j=1, #ignoreList, 1 do
			if ignoreList[j] == vehicle then
				found = true
			end
		end
		
		if not found then
			table.insert(vehicles, vehicle)
		end
		
	end

	return vehicles
end

ESX.Game.GetVehicleNearVehicle = function(coords, ignoreList)
	local ignoreList      = ignoreList or {}
	local vehicles        = ESX.Game.GetRestrictedVehicles(ignoreList)
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

ESX.Game.GetClosestEntity = function(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				table.insert(filteredEntities, entity)
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if closestEntityDistance == -1 or distance < closestEntityDistance then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

ESX.Game.GetClosestObject2 = function(filter, coords)
	local objects         = ESX.Game.GetObjects()
	local closestDistance = -1
	local closestObject   = -1
	local filter          = filter
	local coords          = coords

	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #objects, 1 do
		local foundObject = false

		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else
			local objectModel = GetEntityModel(objects[i])

			for j=1, #filter, 1 do
				if objectModel == GetHashKey(filter[j]) then
					foundObject = true
				end
			end
		end

		if foundObject then
			local objectCoords = GetEntityCoords(objects[i])
			local distance     = GetDistanceBetweenCoords(objectCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestObject   = objects[i]
				closestDistance = distance
			end
		end
	end

	return closestObject, closestDistance
end

ESX.Game.GetVehicleInDirection = function()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end

	return nil
end

ESX.Game.GetVehicleProperties = function(vehicle)
	if DoesEntityExist(vehicle) then
		local tyres = {}
		for id = 0, 7 do
			xpcall(function()
				local tyreId = IsVehicleTyreBurst(vehicle, id, false)
				if tyreId then
					tyreId = IsVehicleTyreBurst(vehicle, id, true)
					if tyreId then
						tyres[id] = true
					else
						tyres[id] = false
					end
				end
			end, function() end)
		end

		local windows = {}
		for id = 0, 13 do
			xpcall(function()
				local windowId = Citizen.InvokeNative(0x46E571A0E20D01F1, vehicle, id)
				if windowId == false then
					table.insert(windows, id)
				end
			end, function() end)
		end

		local doors = {}
		for id = 0, 5 do
			xpcall(function()
				if DoesVehicleHaveDoor(vehicle, id) then
					local doorId = IsVehicleDoorDamaged(vehicle, id)
					if doorId then
						table.insert(doors, id)
					end
				end
			end, function() end)
		end

		local model = GetEntityModel(vehicle)
		local color1, color2 = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

		return {
			model            = model,
			name             = GetDisplayNameFromVehicleModel(model),
			plate            = GetVehicleNumberPlateText(vehicle, true):gsub("%s$", ""),
			plateIndex       = GetVehicleNumberPlateTextIndex(vehicle),

			tyres = tyres,
			windows = windows,
			doors = doors,

			health           = GetEntityHealth(vehicle),
			engineHealth     = GetVehicleEngineHealth(vehicle),
			bodyHealth       = GetVehicleBodyHealth(vehicle),
			tankHealth       = GetVehiclePetrolTankHealth(vehicle),
			dirtLevel        = GetVehicleDirtLevel(vehicle),
			oilLevel         = GetVehicleOilLevel(vehicle),

			color1           = color1,
			color2           = color2,
			pearlescentColor = pearlescentColor,
			wheelColor       = wheelColor,
			interiorColor = GetVehicleInteriorColour(vehicle),
			dashboardColor = GetVehicleDashboardColour(vehicle),

			wheels           = GetVehicleWheelType(vehicle),
			windowTint       = GetVehicleWindowTint(vehicle),
			bulletProofTyre = not GetVehicleTyresCanBurst(vehicle),

			neonEnabled      = {
			  IsVehicleNeonLightEnabled(vehicle, 0),
			  IsVehicleNeonLightEnabled(vehicle, 1),
			  IsVehicleNeonLightEnabled(vehicle, 2),
			  IsVehicleNeonLightEnabled(vehicle, 3),
			},
			neonColor        = table.pack(GetVehicleNeonLightsColour(vehicle)),
			tyreSmokeColor   = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			extras           = {
			  (DoesExtraExist(vehicle, 1) and (IsVehicleExtraTurnedOn(vehicle, 1) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 2) and (IsVehicleExtraTurnedOn(vehicle, 2) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 3) and (IsVehicleExtraTurnedOn(vehicle, 3) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 4) and (IsVehicleExtraTurnedOn(vehicle, 4) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 5) and (IsVehicleExtraTurnedOn(vehicle, 5) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 6) and (IsVehicleExtraTurnedOn(vehicle, 6) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 7) and (IsVehicleExtraTurnedOn(vehicle, 7) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 8) and (IsVehicleExtraTurnedOn(vehicle, 8) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 9) and (IsVehicleExtraTurnedOn(vehicle, 9) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 10) and (IsVehicleExtraTurnedOn(vehicle, 10) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 11) and (IsVehicleExtraTurnedOn(vehicle, 11) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 12) and (IsVehicleExtraTurnedOn(vehicle, 12) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 13) and (IsVehicleExtraTurnedOn(vehicle, 13) and 0 or 1) or nil),
			  (DoesExtraExist(vehicle, 14) and (IsVehicleExtraTurnedOn(vehicle, 14) and 0 or 1) or nil)
			},

			modSpoilers      = GetVehicleMod(vehicle, 0),
			modFrontBumper   = GetVehicleMod(vehicle, 1),
			modRearBumper    = GetVehicleMod(vehicle, 2),
			modSideSkirt     = GetVehicleMod(vehicle, 3),
			modExhaust       = GetVehicleMod(vehicle, 4),
			modFrame         = GetVehicleMod(vehicle, 5),
			modGrille        = GetVehicleMod(vehicle, 6),
			modHood          = GetVehicleMod(vehicle, 7),
			modFender        = GetVehicleMod(vehicle, 8),
			modRightFender   = GetVehicleMod(vehicle, 9),
			modRoof          = GetVehicleMod(vehicle, 10),

			modEngine        = GetVehicleMod(vehicle, 11),
			modBrakes        = GetVehicleMod(vehicle, 12),
			modTransmission  = GetVehicleMod(vehicle, 13),
			modHorns         = GetVehicleMod(vehicle, 14),
			modSuspension    = GetVehicleMod(vehicle, 15),
			modArmor         = GetVehicleMod(vehicle, 16),

			modTurbo         = IsToggleModOn(vehicle,  18),
			modSmokeEnabled  = IsToggleModOn(vehicle,  20),
			modXenon         = IsToggleModOn(vehicle,  22),
			modXenonColor    = GetVehicleHeadlightsColour(vehicle),

			modFrontWheels   = GetVehicleMod(vehicle, 23),
			modBackWheels    = GetVehicleMod(vehicle, 24),
			modFrontWheelsCustom = GetVehicleModVariation(vehicle, 23),
			modBackWheelsCustom = GetVehicleModVariation(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA        = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial         = GetVehicleMod(vehicle, 30),
			modDoorSpeaker      = GetVehicleMod(vehicle, 31),
			modSeats        = GetVehicleMod(vehicle, 32),
			modSteeringWheel    = GetVehicleMod(vehicle, 33),
			modShifterLeavers   = GetVehicleMod(vehicle, 34),
			modAPlate       = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk        = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock      = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts       = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB        = GetVehicleMod(vehicle, 44),
			modTank         = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery       = GetVehicleMod(vehicle, 48),
			modLiveryVariant = GetVehicleLivery(vehicle)
		}
	else
		return
	end
end

ESX.Game.SetVehicleProperties = function(vehicle, props, skipKit)
  if not skipKit then
    SetVehicleModKit(vehicle, 0)
  end

  if props.plate ~= nil then
    SetVehicleNumberPlateText(vehicle, props.plate:gsub("%s$", ""))
  end

  if props.plateIndex ~= nil then
    SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
  end

  if props.tyres ~= nil then
	for id, state in pairs(props.tyres) do
		xpcall(function()
			SetVehicleTyreBurst(vehicle, tonumber(id), true, 1000)
		end, function() end)
	end
  end

  if props.doors ~= nil then
	for _, id in ipairs(props.doors) do
		xpcall(function()
			SetVehicleDoorBroken(vehicle, tonumber(id), true)
		end, function() end)
	end
  end

  if props.health ~= nil then
	Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, vehicle,  props.health)
  end

  if props.engineHealth ~= nil then
    SetVehicleEngineHealth(vehicle,  props.engineHealth)
  end

  if props.bodyHealth ~= nil then
    SetVehicleBodyHealth(vehicle,  props.bodyHealth)
  end

  if props.tankHealth ~= nil then
    SetVehiclePetrolTankHealth(vehicle,  props.tankHealth)
  end

  if props.dirtLevel ~= nil then
    SetVehicleDirtLevel(vehicle, props.dirtLevel)
  end

  if props.oilLevel ~= nil then
    SetVehicleOilLevel(vehicle, props.oilLevel)
  end

  local color1, color2 = GetVehicleColours(vehicle)
  if props.color1 ~= nil then
    color1 = props.color1
  end

  if props.color2 ~= nil then
    color2 = props.color2
  end

  local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
  if props.pearlescentColor ~= nil then
    pearlescentColor = props.pearlescentColor
  end

  if props.wheelColor ~= nil then
    wheelColor = props.wheelColor
  end

  SetVehicleColours(vehicle, color1, color2)
  if props.interiorColor ~= nil then
    SetVehicleInteriorColour(vehicle, props.interiorColor)
  end

  SetVehicleExtraColours(vehicle, pearlescentColor, wheelColor)
  if props.dashboardColor ~= nil then
    SetVehicleDashboardColour(vehicle, props.dashboardColor)
  end

  if props.wheels ~= nil then
    SetVehicleWheelType(vehicle, props.wheels)
  end

  if props.windowTint ~= nil then
    SetVehicleWindowTint(vehicle, props.windowTint)
  end

  if props.bulletProofTyre ~= nil then
    SetVehicleTyresCanBurst(vehicle, not props.bulletProofTyre)
  end

  if props.neonEnabled ~= nil then
    for i = 1, 4, 1 do
      SetVehicleNeonLightEnabled(vehicle, i - 1, props.neonEnabled[i])
    end
  end

  if props.extras ~= nil then
    for i = 1, 14, 1 do
      if props.extras[i] ~= nil and DoesExtraExist(vehicle, i) then
        SetVehicleExtra(vehicle, i, props.extras[i])
      end
    end
  end

  if props.neonColor ~= nil then
    SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
  end

  if props.modSmokeEnabled ~= nil then
    ToggleVehicleMod(vehicle, 20, true)
  end

  if props.tyreSmokeColor ~= nil then
    SetVehicleTyreSmokeColor(vehicle,  props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
  end

  if props.modSpoilers ~= nil then
    SetVehicleMod(vehicle, 0, props.modSpoilers, false)
  end

  if props.modFrontBumper ~= nil then
    SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
  end

  if props.modRearBumper ~= nil then
    SetVehicleMod(vehicle, 2, props.modRearBumper, false)
  end

  if props.modSideSkirt ~= nil then
    SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
  end

  if props.modExhaust ~= nil then
    SetVehicleMod(vehicle, 4, props.modExhaust, false)
  end

  if props.modFrame ~= nil then
    SetVehicleMod(vehicle, 5, props.modFrame, false)
  end

  if props.modGrille ~= nil then
    SetVehicleMod(vehicle, 6, props.modGrille, false)
  end

  if props.modHood ~= nil then
    SetVehicleMod(vehicle, 7, props.modHood, false)
  end

  if props.modFender ~= nil then
    SetVehicleMod(vehicle, 8, props.modFender, false)
  end

  if props.modRightFender ~= nil then
    SetVehicleMod(vehicle, 9, props.modRightFender, false)
  end

  if props.modRoof ~= nil then
    SetVehicleMod(vehicle, 10, props.modRoof, false)
  end

  if props.modEngine ~= nil then
    SetVehicleMod(vehicle, 11, props.modEngine, false)
  end

  if props.modBrakes ~= nil then
    SetVehicleMod(vehicle, 12, props.modBrakes, false)
  end

  if props.modTransmission ~= nil then
    SetVehicleMod(vehicle, 13, props.modTransmission, false)
  end

  if props.modHorns ~= nil then
    SetVehicleMod(vehicle, 14, props.modHorns, false)
  end

  if props.modSuspension ~= nil then
    SetVehicleMod(vehicle, 15, props.modSuspension, false)
  end

  if props.modArmor ~= nil then
    SetVehicleMod(vehicle, 16, props.modArmor, false)
  end

  if props.modTurbo ~= nil then
    ToggleVehicleMod(vehicle,  18, props.modTurbo)
  end

  if props.modXenon ~= nil then
    ToggleVehicleMod(vehicle,  22, props.modXenon)
  end

  if props.modXenonColor ~= nil then
    SetVehicleHeadlightsColour(vehicle, props.modXenonColor)
  end

  local bw = -1
  if props.modBackWheels ~= nil then
    bw = props.modBackWheels
  end

  SetVehicleMod(vehicle, 24, bw, props.modBackWheelsCustom)

  local fw = -1
  if props.modFrontWheels ~= nil then
    fw = props.modFrontWheels
  end

  SetVehicleMod(vehicle, 23, fw, props.modFrontWheelsCustom)

  if props.modPlateHolder ~= nil then
    SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
  end

  if props.modVanityPlate ~= nil then
    SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
  end

  if props.modTrimA ~= nil then
    SetVehicleMod(vehicle, 27, props.modTrimA, false)
  end

  if props.modOrnaments ~= nil then
    SetVehicleMod(vehicle, 28, props.modOrnaments, false)
  end

  if props.modDashboard ~= nil then
    SetVehicleMod(vehicle, 29, props.modDashboard, false)
  end

  if props.modDial ~= nil then
    SetVehicleMod(vehicle, 30, props.modDial, false)
  end

  if props.modDoorSpeaker ~= nil then
    SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
  end

  if props.modSeats ~= nil then
    SetVehicleMod(vehicle, 32, props.modSeats, false)
  end

  if props.modSteeringWheel ~= nil then
    SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
  end

  if props.modShifterLeavers ~= nil then
    SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
  end

  if props.modAPlate ~= nil then
    SetVehicleMod(vehicle, 35, props.modAPlate, false)
  end

  if props.modSpeakers ~= nil then
    SetVehicleMod(vehicle, 36, props.modSpeakers, false)
  end

  if props.modTrunk ~= nil then
    SetVehicleMod(vehicle, 37, props.modTrunk, false)
  end

  if props.modHydrolic ~= nil then
    SetVehicleMod(vehicle, 38, props.modHydrolic, false)
  end

  if props.modEngineBlock ~= nil then
    SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
  end

  if props.modAirFilter ~= nil then
    SetVehicleMod(vehicle, 40, props.modAirFilter, false)
  end

  if props.modStruts ~= nil then
    SetVehicleMod(vehicle, 41, props.modStruts, false)
  end

  if props.modArchCover ~= nil then
    SetVehicleMod(vehicle, 42, props.modArchCover, false)
  end

  if props.modAerials ~= nil then
    SetVehicleMod(vehicle, 43, props.modAerials, false)
  end

  if props.modTrimB ~= nil then
    SetVehicleMod(vehicle, 44, props.modTrimB, false)
  end

  if props.modTank ~= nil then
    SetVehicleMod(vehicle, 45, props.modTank, false)
  end

  if props.modWindows ~= nil then
    SetVehicleMod(vehicle, 46, props.modWindows, false)
  end

  if props.modLivery ~= nil then
    SetVehicleMod(vehicle, 48, props.modLivery, false)
  end

  if props.modLiveryVariant ~= nil then
    SetVehicleLivery(vehicle, props.modLiveryVariant)
  end
end

ESX.Game.Utils.DrawText3D = function(coords, text, size, distance, text2, size2)
	local PozycjaGracza = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size           = size
	local size2          = size2

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
	local scale2
	local fov2

	if distance ~= nil then
		scale2 = (size2 / dist) * 2
		fov2   = (1 / GetGameplayCamFov()) * 100
		scale2 = scale2 * fov2
	end

	if onScreen then
		if distance == nil then
			SetTextScale(0.0 * scale, 0.55 * scale)
			SetTextFont(0)
			SetTextProportional(1)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(2, 0, 0, 0, 150)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry('STRING')
			SetTextCentre(1)

			AddTextComponentString(text)
			DrawText(x, y)
		else
			if GetDistanceBetweenCoords(PozycjaGracza, coords.x, coords.y, coords.z, true) <= distance then
				SetTextScale(0.0 * scale, 0.55 * scale)
				SetTextFont(0)
				SetTextProportional(1)
				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(2, 0, 0, 0, 150)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry('STRING')
				SetTextCentre(1)

				AddTextComponentString(text)
				DrawText(x, y)
			elseif GetDistanceBetweenCoords(PozycjaGracza, coords.x, coords.y, coords.z, true) > distance then
				SetTextScale(0.0 * scale2, 0.55 * scale2)
				SetTextFont(0)
				SetTextProportional(1)
				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(2, 0, 0, 0, 150)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry('STRING')
				SetTextCentre(1)

				AddTextComponentString(text2)
				DrawText(x, y)
			end
		end
	end
end


local settings = {
    weapons = {
		'KNIFE',
		'NIGHTSTICK',
		'HAMMER',
		'BAT',
		'GOLFCLUB',
		'CROWBAR' ,
		'PISTOL',
		'COMBATPISTOL',
		'STUNGUN',
		'BALL',
		'SNSPISTOL',
		'BOTTLE',
		'DAGGER',
		'VINTAGEPISTOL',
		'FIREWORK',
		'SNOWBALL',
		'FLAREGUN',
		'KNUCKLE',
		'HATCHET',
		'MACHETE',
		'SWITCHBLADE',
		'BATTLEAXE',
		'POOLCUE',
		'WRENCH',
		'FLASHLIGHT',
		'FLARE',
		'SNSPISTOL_MK2',
		'PISTOL_MK2'
    }
}

CheckWeapons = function(item)
	local send = false	
	for i=1, #settings.weapons, 1 do
		if (string.lower(item) == string.lower(settings.weapons[i])) then
			send = true 
		end
	end
	return send
end

local Result_Sim = {}

RegisterNetEvent("esx_inventoryhud:setOwnedSim")
AddEventHandler("esx_inventoryhud:setOwnedSim", function(result)
    Result_Sim = result
end)

RegisterNetEvent("esx_inventoryhud:getOwnedSim")
AddEventHandler("esx_inventoryhud:getOwnedSim",function()
    TriggerServerEvent("esx_inventoryhud:getOwnedSim")
end)

ESX.ShowInventory = function()
	local playerPed = PlayerPedId()
	local elements, currentWeight = {}, 0

	for k,v in pairs(ESX.PlayerData.accounts) do
		if v.money > 0 and v.name == 'money' then
			local formattedMoney = _U('locale_currency', ESX.Math.GroupDigits(v.money))
			
			table.insert(elements, {
				label = ('%s: %s'):format(v.label, formattedMoney),
				count = v.money,
				type = 'item_account',
				value = v.name,
				usable = false,
				rare = false,
				canRemove = true
			})
		end
	end
	
	for k,v in pairs(ESX.PlayerData.accounts) do
		if v.money > 0 and v.name == 'black_money' then
			local formattedMoney = _U('locale_currency', ESX.Math.GroupDigits(v.money))
			
			table.insert(elements, {
				label = ('%s: <span style="color:red;">%s</span>'):format(v.label, formattedMoney),
				count = v.money,
				type = 'item_account',
				value = v.name,
				usable = false,
				rare = false,
				canRemove = true
			})
		end
	end

	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.count > 0 then
			
			table.insert(elements, {
				label = ('%s x%s'):format(v.label, v.count),
				count = v.count,
				type = 'item_standard',
				value = v.name,
				usable = v.usable,
				rare = v.rare,
				canRemove = v.canRemove
			})
		end
	end
	
		for _, sim in ipairs(Result_Sim) do
			table.insert(elements, {
				label = 'Karta SIM #'..sim.number,
				number = sim.number,
				count = 1,
				type = 'item_sim',
				value = 'sim',
				usable = true,
				rare = false,
				canRemove = true
			})	
		end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory', {
		title    = ('Ekwipunek'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		menu.close()
		local player, distance = ESX.Game.GetClosestPlayer()
		elements = {}

		if data.current.usable then
			table.insert(elements, {label = _U('use'), action = 'use', type = data.current.type, value = data.current.value, number = data.current.number})
		end
		if data.current.usable or CheckWeapons(data.current.value) then
			table.insert(elements, {label = "Bind [1-5]", action = 'bind', type = data.current.type, value = data.current.value, number = data.current.number})
		end
		if data.current.canRemove then
			if player ~= -1 and distance <= 3.0 then
				table.insert(elements, {label = _U('give'), action = 'give', type = data.current.type, value = data.current.value, number = data.current.number})
			end

			if not IsPedInAnyVehicle(playerPed, false) then
				table.insert(elements, {label = _U('remove'), action = 'remove', type = data.current.type, value = data.current.value, number = data.current.number})
			end
		end

		table.insert(elements, {label = _U('return'), action = 'return'})

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_item', {
			title    = data.current.label,
			align    = 'bottom-right',
			elements = elements,
		}, function(data1, menu1)
			local item, type, number = data1.current.value, data1.current.type, data1.current.number
			if data1.current.action == 'bind' then
				openBindsMenu(item)
			end
			if data1.current.action == 'give' then
				local playersNearby = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)

				if #playersNearby > 0 then
					local players = {}
					elements = {}

					for k,playerNearby in ipairs(playersNearby) do
						players[GetPlayerServerId(playerNearby)] = true
					end

					ESX.TriggerServerCallback('esx:getPlayerNames', function(returnedPlayers)
						for playerId,playerName in pairs(returnedPlayers) do
							table.insert(elements, {
								label = 'Obywatel: ['..playerId..']',
								playerId = playerId
							})
						end

						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_item_to', {
							title    = _U('give_to'),
							align    = 'bottom-right',
							elements = elements
						}, function(data2, menu2)
							local selectedPlayer, selectedPlayerId = GetPlayerFromServerId(data2.current.playerId), data2.current.playerId
							playersNearby = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
							playersNearby = ESX.Table.Set(playersNearby)

							if playersNearby[selectedPlayer] then
								local selectedPlayerPed = Citizen.InvokeNative(0x43A66C31C68491C0, selectedPlayer)
								if type == 'item_weapon' then
									if data.current.ammo < 1 then
										TriggerServerEvent('esx:gitestveInventoryItem', selectedPlayerId, type, item, nil)
										startAnim()
										menu2.close()
										menu1.close()
									else
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_remove', {
											title = _U('amount')
										}, function(data3, menu3)
											local quantity = tonumber(data3.value)
											if quantity and quantity > 0 and data.current.ammo >= quantity then
												TriggerServerEvent('esx:gitestveInventoryItem', selectedPlayerId, type, item, quantity)
												startAnim()
												menu3.close()
												menu2.close()
												menu1.close()
											else
												ESX.ShowNotification(_U('amount_invalid'))
											end
										end, function(data3, menu3)
											menu3.close()
										end)
									end
								elseif type == 'item_sim' then
									menu1.close()
									menu2.close()
									TriggerServerEvent('route68:GiveNumber', selectedPlayerId, number, ESX.PlayerData.protect)
									startAnim()
								else
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', {
										title = _U('amount')
									}, function(data3, menu3)
										local quantity = tonumber(data3.value)

										if quantity and quantity > 0 and data.current.count >= quantity then
											TriggerServerEvent('esx:gitestveInventoryItem', selectedPlayerId, type, item, quantity)
											startAnim()
											menu3.close()
											menu2.close()
											menu1.close()
										else
											ESX.ShowNotification(_U('amount_invalid'))
										end
									end, function(data3, menu3)
										menu3.close()
									end)
								end
							else
								ESX.ShowNotification(_U('players_nearby'))
								menu2.close()
							end
						end, function(data2, menu2)
							menu2.close()
						end)
					end, players)
				else
					ESX.ShowNotification(_U('players_nearby'))
				end
			elseif data1.current.action == 'remove' then
				local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
				ESX.Streaming.RequestAnimDict(dict)

				if type == 'item_weapon' then
					if data.current.ammo < 1 then
						menu1.close()
						TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
						Citizen.Wait(1000)
						TriggerServerEvent('esx:removeInventoryItem', type, item, quantity)
					else
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_remove', {
							title = _U('amount')
						}, function(data2, menu2)
							local quantity = tonumber(data2.value)
							if quantity and quantity > 0 and data.current.ammo >= quantity then
								menu1.close()
								menu2.close()
								TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
								Citizen.Wait(1000)
								TriggerServerEvent('esx:removeInventoryItem', type, item, quantity)
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						end, function(data2, menu2)
							menu2.close()
						end)
					end
				elseif type == 'item_sim' then
					menu1.close()
					TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
					Citizen.Wait(1000)
					TriggerServerEvent('route68:Throw', number, ESX.PlayerData.protect)
					TriggerServerEvent('banki:Throw', number, ESX.PlayerData.protect)
				else
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_remove', {
						title = _U('amount')
					}, function(data2, menu2)
						local quantity = tonumber(data2.value)

						if quantity and quantity > 0 and data.current.count >= quantity then
							menu2.close()
							menu1.close()
							TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
							Citizen.Wait(1000)
							TriggerServerEvent('esx:removeInventoryItem', type, item, quantity)
						else
							ESX.ShowNotification(_U('amount_invalid'))
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end
			elseif data1.current.action == 'use' then
				if type == 'item_sim' then
					TriggerServerEvent("route68:SetNumber", number)
				else
					TriggerServerEvent('esx:useItem', item)
				end
			elseif data1.current.action == 'return' then
				ESX.UI.Menu.CloseAll()
				ESX.ShowInventory()
			elseif data1.current.action == 'give_ammo' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				local pedAmmo = GetAmmoInPedWeapon(playerPed, GetHashKey(item))
				if closestPlayer ~= -1 and closestDistance < 3.0 then
					if pedAmmo > 0 then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', {
							title = _U('amountammo')
						}, function(data2, menu2)
							local quantity = tonumber(data2.value)

							if quantity and quantity > 0 then
								if pedAmmo >= quantity then
									TriggerServerEvent('esx:gitestveInventoryItem', GetPlayerServerId(closestPlayer), 'item_ammo', item, quantity)
									menu2.close()
									menu1.close()
								else
									ESX.ShowNotification(_U('noammo'))
								end
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						end, function(data2, menu2)
							menu2.close()
						end)
					else
						ESX.ShowNotification(_U('noammo'))
					end
				else
					ESX.ShowNotification(_U('players_nearby'))
				end
			end
		end, function(data1, menu1)
			ESX.UI.Menu.CloseAll()
			ESX.ShowInventory()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx:serverCallback')
AddEventHandler('esx:serverCallback', function(requestId, ...)
	ESX.ServerCallbacks[requestId](...)
	ESX.ServerCallbacks[requestId] = nil
end)



openBindsMenu = function(datavalue)
	local item = datavalue
	ESX.UI.Menu.CloseAll()

	local elements = {}
	
	ESX.TriggerServerCallback('packv6:getBinds', function(a,b,c,d,e)
		if a ~= 'Brak' and a ~= nil then
			table.insert(elements, { label = '[1] - Przypisany: '..tostring(a), what = 'first' })
		else
			table.insert(elements, { label = '[1] - Wolne', what = 'first' })
		end
		if b ~= 'Brak' and b ~= nil then
			table.insert(elements, { label = '[2] - Przypisany: '..tostring(b), what = 'second' })
		else
			table.insert(elements, { label = '[2] - Wolne', what = 'second' })
		end
		if c ~= 'Brak' and c ~= nil then
			table.insert(elements, { label = '[3] - Przypisany: '..tostring(c), what = 'third' })
		else
			table.insert(elements, { label = '[3] - Wolne', what = 'third' })
		end
		if d ~= 'Brak' and d ~= nil then
			table.insert(elements, { label = '[4] - Przypisany: '..tostring(d), what = 'fourth' })
		else
			table.insert(elements, { label = '[4] - Wolne', what = 'fourth'})
		end
		if e ~= 'Brak' and e ~= nil then
			table.insert(elements, { label = '[5] - Przypisany: '..tostring(e), what = 'fifth'})
		else
			table.insert(elements, { label = '[5] - Wolne', what = 'fifth'})
		end
	end)

	Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'bagol',
		{
			title    = "Zarz¹dzanie Ekwipunkiem",
			align	 = "bottom-right",
			elements = elements
		}, function(data, menu)
			TriggerServerEvent('packv6:RegisterItemToSlot', data.current.what, item)
			openBindsMenu(item)
		end,
	function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', function(msg)
    ESX.ShowNotification(msg)
end)

RegisterNetEvent('esx:showAdvancedNotification')
AddEventHandler('esx:showAdvancedNotification', function(title, subject, msg, invertal, icon, color)
    ESX.ShowAdvancedNotification(title, subject, msg, invertal, icon, color)
end)

RegisterNetEvent('esx:showHelpNotification')
AddEventHandler('esx:showHelpNotification', function(msg, thisFrame, beep, duration)
	ESX.ShowHelpNotification(msg, thisFrame, beep, duration)
end)

-- SetTimeout
CreateThread(function()
	while true do
		Citizen.Wait(0)
		local currTime = GetGameTimer()

		for i=1, #ESX.TimeoutCallbacks, 1 do
			if ESX.TimeoutCallbacks[i] then
				if currTime >= ESX.TimeoutCallbacks[i].time then
					ESX.TimeoutCallbacks[i].cb()
					ESX.TimeoutCallbacks[i] = nil
				end
			end
		end
	end
end)

function startAnim()
	CreateThread(function()
	  RequestAnimDict("mp_common")
	  while not HasAnimDictLoaded("mp_common") do
	    Citizen.Wait(0)
	  end
	  TaskPlayAnim(Citizen.InvokeNative(0x43A66C31C68491C0, -1), "mp_common" ,"givetake2_a" ,8.0, -8.0, -1, 0, 0, false, false, false )
	end)
end

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if Citizen.InvokeNative(0xB8DFD30D6973E135, PlayerId()) then
			xd()
			break
		end
	end
end)

function xd()
	Citizen.Wait(Config.PaycheckInterval)
	TriggerServerEvent('xd')
	xd()
end