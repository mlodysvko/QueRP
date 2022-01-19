ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("jail", function(src, args, raw)

	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local jailPlayer = args[1]
		local jailTime = tonumber(args[2])
		local jailReason = args[3]

		if GetPlayerName(jailPlayer) ~= nil then

			if jailTime ~= nil then
				JailPlayer(jailPlayer, jailTime)

				TriggerClientEvent("esx:showNotification", src, GetPlayerName(jailPlayer) .. " Wyrok: " .. jailTime .. " minut")

				if args[3] ~= nil then
					GetRPName(jailPlayer, function(Firstname, Lastname)
						--TriggerClientEvent('chat:addMessage', -1, { args = { "JUDGE",  Firstname .. " " .. Lastname .. " Is now in jail for the reason: " .. args[3] }, color = { 249, 166, 0 } })
						TriggerClientEvent('chat:addMessage', -1, {
						template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(90, 0, 0, 0.9); border-radius: 3px;"><i class="fas fa-gavel"></i> {0}: <br>{1}</div>',
						args = { 'Weazel News  informuje', Firstname .. " " .. Lastname ..' trafił/a do Więzienia Stanowego na ' .. jailTime .. ' miesięcy! Powód: '.. args[3] }
						})
					end)
				end
			else
				TriggerClientEvent("esx:showNotification", src, "Nieprawidłowy czas!")
			end
		else
			TriggerClientEvent("esx:showNotification", src, "Gracz jest offline!")
		end
	else
		TriggerClientEvent("esx:showNotification", src, "Nie możesz tego zrobić!")
	end
end)

RegisterCommand("unjail", function(src, args)

	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local jailPlayer = args[1]

		if GetPlayerName(jailPlayer) ~= nil then
			UnJail(jailPlayer)
		else
			TriggerClientEvent("esx:showNotification", src, "Gracz jest offline!")
		end
	else
		TriggerClientEvent("esx:showNotification", src, "Nie możesz tego zrobić!")
	end
end)

RegisterServerEvent("route68jail:jailPlayerRoute68")
AddEventHandler("route68jail:jailPlayerRoute68", function(targetSrc, jailTime, jailReason)
	local src = source
	local targetSrc = tonumber(targetSrc)
	local oficerIDN = ESX.GetPlayerFromId(source).identifier
	local skazanyIDN = ESX.GetPlayerFromId(targetSrc).identifier
	local oficer = 'Nieznany'
	local skazany = 'Nieznany'

	MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE @identifier = identifier', {
		['@identifier'] = oficerIDN
	}, function(result)
		if result[1] then
			local imie = result[1].firstname
			local nazwisko = result[1].lastname
			oficer = imie..' '..nazwisko
		end
	end)
	MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE @identifier = identifier', {
		['@identifier'] = skazanyIDN
	}, function(result)
		if result[1] then
			local imie = result[1].firstname
			local nazwisko = result[1].lastname
			skazany = imie..' '..nazwisko
		end
	end)

	JailPlayer(targetSrc, jailTime)

	GetRPName(targetSrc, function(Firstname, Lastname)
		--TriggerClientEvent('chat:addMessage', -1, { args = { "JUDGE",  Firstname .. " " .. Lastname .. " Is now in jail for the reason: " .. jailReason }, color = { 249, 166, 0 } })
		TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(90, 0, 0, 0.9); border-radius: 3px;"><i class="fas fa-gavel"></i> {0}: <br>{1}</div>',
		args = { 'Weazel News  informuje', Firstname .. " " .. Lastname ..' trafił/a do Więzienia Stanowego na ' .. jailTime .. ' tygodni! Powód: '.. jailReason }
		})
	end)

	TriggerClientEvent("esx:showNotification", src, GetPlayerName(targetSrc) .. " Wyrok: " .. jailTime .. " minut")

	Citizen.Wait(5000)

	MySQL.Async.execute("INSERT INTO `jailhistory` (officer, skazany, reason, wyrok) VALUES (@oficer, @skazany, @reason, @wyrok)",
		{
			['@oficer'] = oficer,
			['@skazany'] = skazany,
			['@reason'] = jailReason,
			['@wyrok'] = jailTime
		}
	)
end)

RegisterServerEvent("esx-qalle-jail:unJailPlayer")
AddEventHandler("esx-qalle-jail:unJailPlayer", function(targetIdentifier)
	local src = source
	local xPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)

	if xPlayer ~= nil then
		UnJail(xPlayer.source)
	else
		MySQL.Async.execute(
			"UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
			{
				['@identifier'] = targetIdentifier,
				['@newJailTime'] = 0
			}
		)
	end

	TriggerClientEvent("esx:showNotification", src, "Ułaskawiono gracza "..xPlayer.name)
end)

RegisterServerEvent("esx-qalle-jail:updateJailTime")
AddEventHandler("esx-qalle-jail:updateJailTime", function(newJailTime)
	local src = source

	EditJailTime(src, newJailTime)
end)

RegisterServerEvent("esx-qalle-jail:prisonWorkReward")
AddEventHandler("esx-qalle-jail:prisonWorkReward", function()
	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.addMoney(15)

	TriggerClientEvent("esx:showNotification", src, "Ok, masz tu trochę gotówki! $15")
end)

function JailPlayer(jailPlayer, jailTime)
	TriggerClientEvent("route68jail:jailPlayerRoute68Client", jailPlayer, jailTime)

	EditJailTime(jailPlayer, jailTime)
end

function UnJail(jailPlayer)
	TriggerClientEvent("esx-qalle-jail:unJailPlayer", jailPlayer)

	EditJailTime(jailPlayer, 0)
end

function EditJailTime(source, jailTime)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier

	MySQL.Async.execute(
       "UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
        {
			['@identifier'] = Identifier,
			['@newJailTime'] = tonumber(jailTime)
		}
	)
end

function GetRPName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end

ESX.RegisterServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(source, cb)

	local jailedPersons = {}

	MySQL.Async.fetchAll("SELECT name, jail, identifier FROM users WHERE jail > @jail", { ["@jail"] = 0 }, function(result)

		for i = 1, #result, 1 do
			table.insert(jailedPersons, { name = result[i].name, jailTime = result[i].jail, identifier = result[i].identifier })
		end

		cb(jailedPersons)
	end)
end)

ESX.RegisterServerCallback("esx-qalle-jail:retrieveJailTime", function(source, cb)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier


	MySQL.Async.fetchAll("SELECT jail FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		local JailTime = tonumber(result[1].jail)

		if JailTime > 0 then

			cb(true, JailTime)
		else
			cb(false, 0)
		end

	end)
end)
