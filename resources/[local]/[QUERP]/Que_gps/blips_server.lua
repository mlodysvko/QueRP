ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

local blips = config.blip_types

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    for k, v in pairs(blips) do
        if not v.members then blips[k].members = { } end
    end
end) 
--[[
RegisterServerEvent('esx:getmyload')
AddEventHandler('esx:getmyload', function()
    for k, v in pairs(blips) do
        if not v.members then blips[k].members = { } end
    end
end)]]

RegisterNetEvent('badBlips:server:registerPlayerBlipGroup')
AddEventHandler('badBlips:server:registerPlayerBlipGroup', function(source, group)
    local xPlayer = ESX.GetPlayerFromId(source)
    local userData = getPlayer(xPlayer.identifier)
    while userData == nil do
        Citizen.Wait(10)
    end

    -- Config sanity checks and new group creation
    if not blips[group] then
        blips[group] = { members = { } }
    end

    doDebug('Registering player blip group for source', source)
    blips[group].members[source] = { is_member = true, data = userData }
end)

RegisterNetEvent('arivi_gps:refreshGPS')
AddEventHandler('arivi_gps:refreshGPS', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    for blip_name, blip in pairs(blips) do
        for member_source, data in pairs(blip.members) do
            if source == member_source then
                blips[blip_name].members[source] = nil
            end
        end
    end
    local group = 'unknown'
    if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'mecano' then
        group = xPlayer.job.name
    end

    if xPlayer ~= nil then
        TriggerEvent('badBlips:server:registerPlayerBlipGroup', source, group)
        TriggerClientEvent('esx:showNotification', _source, '~g~Uruchomiono GPS')
    end
end)

RegisterNetEvent('arivi_gps:destroyGPS')
AddEventHandler('arivi_gps:destroyGPS', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local gpsCount = xPlayer.getInventoryItem('gps').count

    if gpsCount > 0 then
        xPlayer.removeInventoryItem('gps', 1)
        TriggerClientEvent('esx:showNotification', _source, '~r~Zniszczono GPS')
    end
end)

RegisterNetEvent('badBlips:server:removePlayerBlipGroup')
AddEventHandler('badBlips:server:removePlayerBlipGroup', function(source, group)
    if blips[group].members[source] then
        doDebug('Unregistering player blip group for source', source)
        blips[group].members[source] = nil
    end
end)

RegisterNetEvent('badBlips:server:registerPlayerTempBlipGroup')
AddEventHandler('badBlips:server:registerPlayerTempBlipGroup', function(source, group, time)
    TriggerEvent('badBlips:server:registerPlayerBlipGroup', source, 'police')
    SetTimeout(time, function()
        TriggerEvent('badBlips:server:removePlayerBlipGroup', source, 'police')
    end)
end)

-- Remove the player from the blip group
AddEventHandler('playerDropped', function()
    local source = source

    -- Remove the source from the group
    doDebug('Starting loop over groups', json.encode(blips))
    for blip_name, blip in pairs(blips) do
        for member_source, data in pairs(blip.members) do
            if source == member_source then
                blips[blip_name].members[source] = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(config.client_update_interval)

        for blip_name, blip in pairs(blips) do
            local blips_data = { }


            if blip._can_see then
                for _, can_see_group_name in pairs(blip._can_see) do
                    for source, data in pairs(blips[can_see_group_name].members) do
                        if data then
                            local ped = GetPlayerPed(source)
                            if DoesEntityExist(ped) then
                                local pos = GetEntityCoords(ped)
                                blips_data = appendBlipsPacket(blips_data, can_see_group_name, source, pos, blips[can_see_group_name].members[source].data)
                            end
                        end
                    end
                end
            end

            for source, data in pairs(blip.members) do
                if data then
                    local ped = GetPlayerPed(source)
                    if DoesEntityExist(ped) then
                        local pos = GetEntityCoords(ped)
                        blips_data = appendBlipsPacket(blips_data, blip_name, source, pos, blips[blip_name].members[source].data)
                    end
                end
            end

            Citizen.CreateThread(function()
                for source, is_valid_member in pairs(blip.members) do
                    if is_valid_member then
                        TriggerClientEvent('badBlips:client:syncMyBlips', source, blips_data)
                        Citizen.Wait(100)
                    end
                end
            end)

            Citizen.Wait(config.wait_between_group_in_thread)
        end
    end
end)

function appendBlipsPacket(blips_data, blip_name, source, position, userData)
    doDebug('creating blip packet for source', blip_name, source)
    local x, y, z = table.unpack(position)

    local firstname = userData.firstname
    local lastname = userData.lastname
    local plate = userData.number

    table.insert(blips_data, {
        x, -- [1]
        y, -- [2]
        z, -- [3]
        blip_name, -- [4]
        source, -- [5]
        plate, -- [6]
        firstname,
        lastname
    })

    return blips_data
end

function getPlayer(identifier)
    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname, job_id FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
    if result[1] ~= nil then
        local identity = result[1]
        local badge = json.decode(identity['job_id'])
        if badge.id == 0 then
            badge.id = 'Brak'
        end
        return {
            firstname = identity['firstname'],
            lastname = identity['lastname'],
			number = badge.id
        }
    else
        return {
            firstname = 'Brak',
            lastname = 'Brak',
            number = 'Brak',
       }
    end
end

function getID(steamid, callback)
	MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier",
	{
		['@identifier'] = steamid
	}, function(result)
		if result[1] ~= nil then
			local data = {
				identifier	= identifier,
				firstname	= result[1]['firstname'],
				lastname	= result[1]['lastname'],
				badge       = json.decode(result[1]['job_id'])
			}
			
			callback(data)
		else	
			local data = {
				identifier 	= '',
				firstname 	= '',
				lastname 	= '',
				badge       = {}
			}
			
			callback(data)
		end
	end)
end

function doDebug(...)
    if config.debug then
        print(...)
    end
end

AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
    if item == 'gps' and count > 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        local group = 'unknown'

        if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'mechanik' then
            group = xPlayer.job.name
        end

        if xPlayer ~= nil then
            TriggerEvent('badBlips:server:registerPlayerBlipGroup', source, group)
        end

        Citizen.Wait(500)
    end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    if item == 'gps' and count < 1 then
        local xPlayer = ESX.GetPlayerFromId(source)
        for blip_name, blip in pairs(blips) do
            for member_source, data in pairs(blip.members) do
                if source == member_source then
                    blips[blip_name].members[source] = nil
                end
            end
        end
        Citizen.Wait(500)

        if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then
            getID(xPlayer.identifier, function(data)
                if data ~= nil then
                    local xPlayers = exports['esx_scoreboard']:GetPlayers()
                    for k,v in pairs(xPlayers) do
                        if v.job == 'police' or v.job == 'ambulance' then
                            TriggerClientEvent('arivi_gps:lostGPS', v.id, '[' .. data.badge.id .. '] '..data.firstname..' '..data.lastname, xPlayer.getCoords(true))
                        end
                    end
                end
            end)
        end
    end
end)

ESX.RegisterUsableItem('gps', function(source)
	TriggerClientEvent('arivi_gps:openMenu', source)
	Citizen.Wait(100)
end)