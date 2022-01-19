local Instances = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetInstancedPlayers()
	local players = {}

	for k,v in pairs(Instances) do
		for k2,v2 in ipairs(players) do
			players[v2] = true
		end
	end

	return players
end

function CreateInstance(type, player, data)
	Instances[player] = {
		type    = type,
		host    = player,
		players = {},
		data    = data
	}

	TriggerEvent('instance:onCreate', Instances[player])
	TriggerClientEvent('instance:onCreate', player, Instances[player])
	TriggerClientEvent('instance:onInstancedPlayersData', -1, GetInstancedPlayers())
end

function instanceExists(name)
	for k,v in pairs(Instances) do
		if v.data.property == name then
			return v
		end
	end
	return false
end

ESX.RegisterServerCallback("mrp_instance:checkInstance",function(source,cb,name)
	cb(instanceExists(name))
end)

function CloseInstance(instance)
	if Instances[instance] ~= nil then

		for i=1, #Instances[instance].players, 1 do
			TriggerClientEvent('instance:onClose', Instances[instance].players[i])
		end

		Instances[instance] = nil

		TriggerClientEvent('instance:onInstancedPlayersData', -1, GetInstancedPlayers())
		TriggerEvent('instance:onClose', instance)
	end
end

function AddPlayerToInstance(instance, player)
	local found = false

	for i=1, #Instances[instance].players, 1 do
		if Instances[instance].players[i] == player then
			found = true
			break
		end
	end

	if not found then
		table.insert(Instances[instance].players, player)
	end

	TriggerClientEvent('instance:onEnter', player, Instances[instance])

	for i=1, #Instances[instance].players, 1 do
		if Instances[instance].players[i] ~= player then
			TriggerClientEvent('instance:onPlayerEntered', Instances[instance].players[i], Instances[instance], player)
		end
	end

	TriggerClientEvent('instance:onInstancedPlayersData', -1, GetInstancedPlayers())
end

function RemovePlayerFromInstance(instance, player)

	if Instances[instance] ~= nil then

		TriggerClientEvent('instance:onLeave', player, Instances[instance])
		if #Instances[instance].players == 0 then
			Instances[instance].players[1] = nil
			CloseInstance(instance)

		else
			for k,v in pairs(Instances[instance].players) do
				if v ~= player then
					TriggerClientEvent('instance:onPlayerLeft', v, Instances[instance], player)
				end
			end

			for k,v in pairs(Instances[instance].players) do
				if v == player then
					v = nil
				end
			end

		end
		
		TriggerClientEvent('instance:onInstancedPlayersData', -1, GetInstancedPlayers())
	end

end

function findInstance(name)
	for k,v in pairs(Instances) do
		if v.data.property == name then
			return v
		end
	end
	return nil
end

function TriggerForInstance(instance,trigger)
	local inst = findInstance(instance)
	if inst ~= nil then
		for k,v in pairs(inst.players) do
			TriggerClientEvent(trigger, v)
		end	
	end
end


function InvitePlayerToInstance(instance, type, player, data)
	TriggerClientEvent('instance:onInvite', player, instance, type, data)
end

RegisterServerEvent('instance:create')
AddEventHandler('instance:create', function(type, data)
	CreateInstance(type, source, data)
end)

RegisterServerEvent('instance:trigger')
AddEventHandler('instance:trigger', function(instance,trigger)
	TriggerForInstance(instance, trigger)
end)

RegisterServerEvent('instance:close')
AddEventHandler('instance:close', function()
	CloseInstance(source)
end)

RegisterServerEvent('instance:enter')
AddEventHandler('instance:enter', function(instance)
	AddPlayerToInstance(instance, source)
end)

RegisterServerEvent('instance:leave')
AddEventHandler('instance:leave', function(instance)
	RemovePlayerFromInstance(instance, source)
end)

RegisterServerEvent('instance:invite')
AddEventHandler('instance:invite', function(instance, type, player, data)
	InvitePlayerToInstance(instance, type, player, data)
end)
