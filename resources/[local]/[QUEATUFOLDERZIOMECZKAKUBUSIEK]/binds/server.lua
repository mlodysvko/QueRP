ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local InventorySlots = {}

local settings = {
	cache = {},
    cache_used = {},
	timer = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
	},
    weapons = {
		'KNIFE',
		'NIGHTSTICK',
		'HAMMER',
		'BAT',
		'GOLFCLUB',
		'CROWBAR' ,
		'PISTOL',
		'COMBATPISTOL',
		'APPISTOL',
		'PISTOL50',
		'MICROSMG',
		'SMG',
		'ASSAULTSMG' ,
		'ASSAULTRIFLE',
		'CARBINERIFLE',
		'ADVANCEDRIFLE',
		'MG',
		'COMBATMG',
		'PUMPSHOTGUN', 
		'SAWNOFFSHOTGUN', 
		'ASSAULTSHOTGUN', 
		'BULLPUPSHOTGUN',
		'STUNGUN',
		'SNIPERRIFLE', 
		'HEAVYSNIPER', 
		'REMOTESNIPER', 
		'GRENADELAUNCHER',
		'RPG',
		'STINGER',
		'MINIGUN',
		'GRENADE',
		'STICKYBOMB',
		'SMOKEGRENADE',
		'BZGAS',
		'MOLOTOV',
		'FIREEXTINGUISHER',
		'PETROLCAN',
		'DIGISCANNER',
		'BALL',
		'SNSPISTOL',
		'BOTTLE',
		'GUSENBERG',
		'SPECIALCARBINE',
		'HEAVYPISTOL',
		'BULLPUPRIFLE',
		'DAGGER',
		'VINTAGEPISTOL',
		'FIREWORK',
		'MUSKET',
		'HEAVYSHOTGUN',
		'MARKSMANRIFLE',
		'HOMINGLAUNCHER',
		'PROXMINE',
		'SNOWBALL',
		'FLAREGUN',
		'GARBAGEBAG',
		'COMBATPDW',
		'MARKSMANPISTOL',
		'KNUCKLE',
		'HATCHET',
		'RAILGUN',
		'MACHETE',
		'MACHINEPISTOL',
		'SWITCHBLADE',
		'REVOLVER',
		'DBSHOTGUN',
		'COMPACTRIFLE',
		'AUTOSHOTGUN',
		'BATTLEAXE',
		'COMPACTLAUNCHER',
		'MINISMG',
		'PIPEBOMB',
		'POOLCUE',
		'WRENCH',
		'FLASHLIGHT',
		'FLARE',
		'SNSPISTOL_MK2',
		'REVOLVER_MK2',
		'DOUBLEACTION',
		'SPECIALCARBINE_MK2',
		'BULLPUPRIFLE_MK2',
		'PUMPSHOTGUN_MK2',
		'MARKSMANRIFLE_MK2',
		'ASSAULTRIFLE_MK2',
		'CARBINERIFLE_MK2',
		'COMBATMG_MK2',
		'HEAVYSNIPER_MK2',
		'PISTOL_MK2',
		'SMG_MK2'
    }
}

LoadSlots = function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local PreSlots = {}
	
	MySQL.Async.fetchAll("SELECT identifier, slots FROM users WHERE identifier = @identifier", {
		["@identifier"] = xPlayer.getIdentifier()
	}, function(result)

		if result[1].slots ~= nil then
			local data = json.decode(result[1].slots)
			table.insert(PreSlots , {
				identifier = tostring(result[1].identifier),
				first = tostring(data.first),
				second = tostring(data.second),
				third = tostring(data.third),
				fourth = tostring(data.fourth),
				fifth = tostring(data.fifth),
			})
			table.insert(InventorySlots , {
				identifier = tostring(result[1].identifier),
				first = tostring(data.first),
				second = tostring(data.second),
				third = tostring(data.third),
				fourth = tostring(data.fourth),
				fifth = tostring(data.fifth),
			})
		else
			table.insert(PreSlots , {
				identifier = tostring(result[1].identifier),
				first = tostring("Brak"),
				second = tostring("Brak"),
				third = tostring("Brak"),
				fourth = tostring("Brak"),
				fifth = tostring("Brak"),
			})
			table.insert(InventorySlots , {
				identifier = tostring(result[1].identifier),
				first = tostring("Brak"),
				second = tostring("Brak"),
				third = tostring("Brak"),
				fourth = tostring("Brak"),
				fifth = tostring("Brak"),
			})
		end
	end)
	return PreSlots
end

RegisterNetEvent("binds:LoadSlots")
AddEventHandler("binds:LoadSlots", function()
	local _source = source
	local slots = LoadSlots(_source)

	Wait(2000)
	TriggerClientEvent("packv6:updatebinds", _source, slots)
end)



SelectSlot = function(identifier)
	local toreturn
	for i=1, #InventorySlots, 1 do
		local slot = InventorySlots[i]
		if (tostring(slot.identifier) == tostring(identifier)) then 
			toreturn = slot
		end
	end
	return toreturn
end

CheckWeapons = function(item)
	local send = false	
	for i=1, #settings.weapons, 1 do
		if (string.lower(item) == string.lower(settings.weapons[i])) then
			send = true 
		end
	end
	return send
end

CanUse = function(source, identifier, itemName, data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if (itemName == tostring('Brak') or itemName == nil) then
        xPlayer.showNotification('Brak przypisanego klawisza')
    else
        if CheckWeapons(itemName) == true then
            local count = xPlayer.getInventoryItem(itemName).count
            if count > 0 then
				TriggerClientEvent('packv6:IsWeapon', _source, itemName)
            else
                xPlayer.showNotification("Nie posiadasz tego przedmiotu! - Usunięto wpis z bazy danych")
                DeleteFromSlot(source, identifier, data)
            end
        else
            local count = xPlayer.getInventoryItem(itemName).count
            if count > 0 then
                return true
            else
                xPlayer.showNotification("Nie posiadasz tego przedmiotu! - Usunięto wpis z bazy danych")
                DeleteFromSlot(source, identifier, data)
            end
        end
    end
end

UseSlot = function(source, identifier, slot_out)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #InventorySlots, 1 do
		if ((tostring(InventorySlots[i].identifier)) == tostring(identifier)) then 
			local sloty = InventorySlots[i]
			local data = slot_out
			if data == 'first' then
				to_use = sloty.first
			elseif data == 'second' then
				to_use = sloty.second
			elseif data == 'third' then
				to_use = sloty.third
			elseif data == 'fourth' then
				to_use = sloty.fourth
			elseif data == 'fifth' then
				to_use = sloty.fifth
			end
			if CanUse(_source, identifier, to_use, data) == true then
				TriggerClientEvent('packv6:useItem', _source, to_use)
			end
		end
	end
end

RegisterItemToSlot = function(source, slot_out, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #InventorySlots, 1 do
		local sloty = InventorySlots[i]
		if ((tostring(sloty.identifier)) == tostring(xPlayer.getIdentifier())) then
			local data = slot_out
			if data == 'first' then
				sloty.first = item
			elseif data == 'second' then
				sloty.second = item
			elseif data == 'third' then
				sloty.third = item
			elseif data == 'fourth' then
				sloty.fourth = item
			elseif data == 'fifth' then
				sloty.fifth = item
			end

			UpdateSlotsDB(sloty, item, xPlayer.getIdentifier(), _source)
		end
	end
end

DeleteFromSlot = function(source, identifier, slot_out)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #InventorySlots, 1 do
		local sloty = InventorySlots[i]
		if ((tostring(sloty.identifier)) == tostring(identifier)) then 
			local data = slot_out
			if data == 'first' then
				sloty.first = "Brak"
			elseif data == 'second' then
				sloty.second = "Brak"
			elseif data == 'third' then
				sloty.third = "Brak"
			elseif data == 'fourth' then
				sloty.fourth = "Brak"
			elseif data == 'fifth' then
				sloty.fifth = "Brak"
			end
			UpdateSlotsDB(sloty, item, xPlayer.getIdentifier(), _source)
		end
	end	
end

UpdateSlotsDB = function(sloty, item, identifier, source)
	local _source = source
	TriggerClientEvent("packv6:updatebinds", _source, sloty)
	MySQL.Async.execute('UPDATE users SET slots = @sloty WHERE identifier = @license',
	{
		['@sloty'] = json.encode(sloty),
		['@license'] = identifier
	})
end

RegisterServerEvent('packv6:RegisterItemToSlot')
AddEventHandler('packv6:RegisterItemToSlot', function(itemnum, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	RegisterItemToSlot(_source, itemnum, item)
end)

RegisterServerEvent('packv6:UseItemFromBind')
AddEventHandler('packv6:UseItemFromBind', function(num)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	UseSlot(_source, xPlayer.getIdentifier(), num)
end)

RegisterServerEvent('packv6:deleteBind')
AddEventHandler('packv6:deleteBind', function(num)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	DeleteFromSlot(_source, xPlayer.getIdentifier(), num)
end)

RegisterNetEvent("binds:notify")
AddEventHandler("binds:notify", function(item)
	local playerId = source
	local sourceXPlayer = ESX.GetPlayerFromId(playerId)
	local sourceItem = sourceXPlayer.getInventoryItem(item)
	sourceXPlayer.showNotification('Wyciągnąłeś/aś ~g~' ..sourceItem.label.. '')
end)
RegisterNetEvent("binds:notify2")
AddEventHandler("binds:notify2", function(item)
	local playerId = source
	local sourceXPlayer = ESX.GetPlayerFromId(playerId)
	local sourceItem = sourceXPlayer.getInventoryItem(item)
	sourceXPlayer.showNotification('Schowałeś/aś ~r~' ..sourceItem.label.. '')
end)

ESX.RegisterServerCallback('packv6:getBinds', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local data = SelectSlot(GetPlayerIdentifiers(source)[1])
	if data ~= nil then
		cb(data.first, data.second, data.third, data.fourth, data.fifth)
	else
		cb("Brak","Brak","Brak","Brak","Brak")
	end
end)