ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx:discardInventoryItem')
AddEventHandler('esx:discardInventoryItem', function(item, count)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

  xPlayer.removeInventoryItem(item, count, true)

end)

RegisterServerEvent('esx:modelChanged')
AddEventHandler('esx:modelChanged', function(id)
	TriggerClientEvent('esx:modelChanged', id)
end)

ESX.RegisterUsableItem('pistol_ammo_box', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('pistol_ammo_box', 1)
	xPlayer.addInventoryItem('pistol_ammo', 24)
end)

ESX.RegisterUsableItem('smg_ammo_box', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('smg_ammo_box', 1)
	xPlayer.addInventoryItem('smg_ammo', 30)
end)

ESX.RegisterUsableItem('rifle_ammo_box', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('rifle_ammo_box', 1)
	xPlayer.addInventoryItem('rifle_ammo', 30)
end)

ESX.RegisterUsableItem('shotgun_ammo_box', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('shotgun_ammo_box', 1)
	xPlayer.addInventoryItem('shotgun_ammo', 16)
end)

local checkload, checkload2, checkload3 = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  if checkload == false then
    print('[ScriptHandler] Restoring guns and ammo')
    Wait(6500)
    checkload = true
    if checkload == true then
      RebuildLoadout()
      print('[ScriptHandler] Restored guns and ammo ended')
      Wait(100)
      checkload = false
    end
  end
end)

RegisterNetEvent('esx:modelChanged')
AddEventHandler('esx:modelChanged', function()
  if checkload2 == false then
    print('[ScriptHandler] Restoring guns and ammo')
    Wait(6500)
    checkload2 = true
    if checkload2 == true then
      RebuildLoadout()
      print('[ScriptHandler] Restored guns and ammo ended')
      Wait(100)
      checkload2 = false
    end
  end
end)

AddEventHandler('skinchanger:modelLoaded', function()
  if checkload3 == false then
    print('[ScriptHandler] Restoring guns and ammo')
    Wait(6500)
    checkload3 = true
    if checkload3 == true then
      RebuildLoadout()
      print('[ScriptHandler] Restored guns and ammo ended')
      Wait(100)
      checkload3 = false
    end
  end
end)