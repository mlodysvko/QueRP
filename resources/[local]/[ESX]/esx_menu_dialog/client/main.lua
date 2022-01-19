ESX = nil
Citizen.CreateThread(function()
	local GUI = {
		Time = 0
	}
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	local MenuType    = 'dialog'
	local OpenedMenus = {}
	local Timeouts    = {}

	local openMenu = function(namespace, name, data)
		for _, timeout in ipairs(Timeouts) do
			ESX.ClearTimeout(timeout)
		end
		Timeouts = {}

		OpenedMenus[namespace .. '_' .. name] = true
		SendNUIMessage({
			action    = 'openMenu',
			namespace = namespace,
			name      = name,
			data      = data,
		})

		table.insert(Timeouts, ESX.SetTimeout(200, function()
			SetNuiFocus(true, true)
		end))
	end

	local closeMenu = function(namespace, name)
		OpenedMenus[namespace .. '_' .. name] = nil
		SendNUIMessage({
			action    = 'closeMenu',
			namespace = namespace,
			name      = name,
			data      = data,
		})

		local OpenedMenuCount = 0
		for k, v in pairs(OpenedMenus) do
			if v then
				OpenedMenuCount = OpenedMenuCount + 1
			end
		end

		if OpenedMenuCount == 0 then
			SetNuiFocus(false)
		end
	end

	-- discord.gg/RedLeaks

	ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

	RegisterNUICallback('menu_submit', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		if menu.submit ~= nil then
			local post = true

			local v = tonumber(data.value)
			if v ~= nil then
				data.value = round(v)
				if v <= 0 then
					post = false
				end
			end

			if post then
				menu.submit(data, menu)
			else
				ESX.ShowNotification('~p~Błędna wartość!')
			end
		end

		cb('ok')
	end)

	RegisterNUICallback('menu_cancel', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		if menu.cancel ~= nil then
			menu.cancel(data, menu)
		end

		cb('ok')
	end)

	RegisterNUICallback('menu_change', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		if menu.change ~= nil then
			menu.change(data, menu)
		end

		cb('ok')
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			local OpenedMenuCount = 0
			for k,v in pairs(OpenedMenus) do
				if v == true then
					OpenedMenuCount = OpenedMenuCount + 1
				end
			end

			if OpenedMenuCount > 0 then
				DisableControlAction(0, 1,   true) -- LookLeftRight
				DisableControlAction(0, 2,   true) -- LookUpDown
				DisableControlAction(0, 142, true) -- MeleeAttackAlternate
				DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
				DisableControlAction(0, 12, true) -- WeaponWheelUpDown
				DisableControlAction(0, 14, true) -- WeaponWheelNext
				DisableControlAction(0, 15, true) -- WeaponWheelPrev
				DisableControlAction(0, 16, true) -- SelectNextWeapon
				DisableControlAction(0, 17, true) -- SelectPrevWeapon
			end
		end
	end)

	function round(x)
		return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
	end
end)

	-- discord.gg/RedLeaks
