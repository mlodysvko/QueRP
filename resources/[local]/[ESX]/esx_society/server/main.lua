ESX                 = nil
local Jobs = {}
local RegisteredSocieties = {}


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function sendToDiscord (name,message,color)
    local DiscordWebHook = "https://discord.com/api/webhooks/915626963463471184/APnx_ES4E2IetKu12BuCaRyOSkGw6h2csdgbI_K2NQwn2ovwUhbtEE2efDXN18vPfzxE"

  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
          ["footer"]=  {
          ["text"]= "Sprzedaz kawy w island_kawiarnia",
         },
      }
  }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end








function GetSociety(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result, 1 do
		Jobs[result[i].name]        = result[i]
		Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2, 1 do
		Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)
function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	if identifier == nil then
		DropPlayer(source, "Wystąpił problem z Twoją postacią. Połącz się z serwerem ponownie lub napisz ticket!")
	else
		local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
		if result[1] ~= nil then
			local identity = result[1]

			return {
				identifier = identity['identifier'],
				firstname = identity['firstname'],
				lastname = identity['lastname'],
				dateofbirth = identity['dateofbirth'],	
				sex = identity['sex'],
				height = identity['height'],
				job = identity['job'],
				hiddenjob = identity['hiddenjob'],
				hiddenjob_grade = identity['hiddenjob_grade']
			}
		else
			return nil
		end
	end
end


function getIdentityGPS(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	if identifier == nil then
		DropPlayer(source, "Wystąpił problem z Twoją postacią. Połącz się z serwerem ponownie lub napisz ticket!")
		return {
				firstname = "off",
				lastname = "off"
			}
	else
		local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
		
		if result[1] ~= nil then
			local identity = result[1]
			return {
				firstname = identity.firstname,
				lastname = identity.lastname
			}
		else
			return {
				firstname = "off",
				lastname = "off"
			}
		end
	end
end


AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data,
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('esx_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterServerEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	local identifier = GetPlayerName(source)
	local _source = source
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_society: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)
			sendToDiscord (('esx_society:depositMoney2'), "Gracz [".. _source .."] " .. identifier .. " Licka gracza: " .. xPlayer.identifier .. " WYCIAGNAL ".. tostring(amount) .." DLA ".. society.account .." ")
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

RegisterServerEvent('esx_society:withdrawMoney2')
AddEventHandler('esx_society:withdrawMoney2', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	local identifier = GetPlayerName(source)
	local _source = source
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.hiddenjob.name ~= society.name then
		--print(('esx_society: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)
			sendToDiscord (('esx_society:depositMoney2'), "Gracz [".. _source .."] " .. identifier .. " Licka gracza: " .. xPlayer.identifier .. " WYCIAGNAL ".. tostring(amount) .." DLA ".. society.account .." ")
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

RegisterServerEvent('esx_society:depositMoney')
AddEventHandler('esx_society:depositMoney', function(society, amount, paying)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	local identifier = GetPlayerName(source)
	local _source = source
	amount = ESX.Math.Round(tonumber(amount))

	if paying == 1 then 
		if amount > 0  then
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				account.addMoney(amount)
				sendToDiscord (('esx_society:depositMoney2'), "Gracz [".. _source .."] " .. identifier .. " Licka gracza: " .. xPlayer.identifier .. " ZDEPONOWAL ".. tostring(amount) .." DLA ".. society.account .." ")
			end)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end

	else
		if amount > 0 and xPlayer.getMoney() >= amount  then

			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				xPlayer.removeMoney(amount)
				account.addMoney(amount)
				sendToDiscord (('esx_society:depositMoney2'), "Gracz [".. _source .."] " .. identifier .. " Licka gracza: " .. xPlayer.identifier .. " ZDEPONOWAL ".. tostring(amount) .." DLA ".. society.account .." ")
			end)

			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', ESX.Math.GroupDigits(amount)))

		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end
	if xPlayer.job.name ~= society.name then
		print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		return
	end

	
end)

RegisterServerEvent('esx_society:depositMoney2')
AddEventHandler('esx_society:depositMoney2', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	local identifier = GetPlayerName(source)
	local _source = source
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.hiddenjob.name ~= society.name then
		--print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		return
	end

	if amount > 0 and xPlayer.getMoney() >= amount  then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
			sendToDiscord (('esx_society:depositMoney2'), "Gracz [".. _source .."] " .. identifier .. " Licka gracza: " .. xPlayer.identifier .. " ZDEPONOWAL ".. tostring(amount) .." DLA ".. society.account .." ")
		end)
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', ESX.Math.GroupDigits(amount)))
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)

RegisterServerEvent('esx_society:washMoney')
AddEventHandler('esx_society:washMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_society: %s attempted to call washMoney!'):format(xPlayer.identifier))
		return
	end

	if amount and amount > 0 and account.money >= amount then
		xPlayer.removeAccountMoney('black_money', amount)

		MySQL.Async.execute('INSERT INTO society_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)', {
			['@identifier'] = xPlayer.identifier,
			['@society']    = society,
			['@amount']     = amount
		}, function(rowsChanged)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have', ESX.Math.GroupDigits(amount)))
		end)

	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end

end)

RegisterServerEvent('esx_society:washMoney2')
AddEventHandler('esx_society:washMoney2', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.hiddenjob.name ~= society.name then
		--print(('esx_society: %s attempted to call washMoney!'):format(xPlayer.identifier))
		return
	end

	if amount and amount > 0 and account.money >= amount then
		local amountToAdd = math.floor(amount*0.9)
		xPlayer.removeAccountMoney('black_money', amount)
		xPlayer.addMoney(amountToAdd)
		TriggerClientEvent('esx:showNotification', xPlayer.source, ("Przeprałeś %s$ i otrzymałeś %s$ czystej gotówki!"):format(amount, amountToAdd))
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)

RegisterServerEvent('esx_society:putVehicleInGarage')
AddEventHandler('esx_society:putVehicleInGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

RegisterServerEvent('esx_society:removeVehicleFromGarage')
AddEventHandler('esx_society:removeVehicleFromGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		for i=1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end

		store.set('garage', garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
	-- local society = GetSociety(societyName)
	--print(societyName, json.encode(society))

	--if society then

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..societyName, function(account)
			cb(account.money)
		end)

	--else
		--cb(0)
	--end
end)

ESX.RegisterServerCallback('esx_society:getEmployees', function(source, cb, society)
	if Config.EnableESXIdentity then

		MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (results)
			local employees = {}

			for i=1, #results, 1 do
				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					job = {
						name        = results[i].job,
						label       = Jobs[results[i].job].label,
						grade       = results[i].job_grade,
						grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
						grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		MySQL.Async.fetchAll('SELECT name, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (result)
			local employees = {}

			for i=1, #result, 1 do
				table.insert(employees, {
					name       = result[i].name,
					identifier = result[i].identifier,
					job = {
						name        = result[i].job,
						label       = Jobs[result[i].job].label,
						grade       = result[i].job_grade,
						grade_name  = Jobs[result[i].job].grades[tostring(result[i].job_grade)].name,
						grade_label = Jobs[result[i].job].grades[tostring(result[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	end
end)

ESX.RegisterServerCallback('esx_society:hiddenjob', function(source, cb)
	local player = getIdentity(source)
	local hiddenjobname = player.hiddenjob

	cb(hiddenjobname)
end)

ESX.RegisterServerCallback('esx_society:getEmployees2', function(source, cb, society)
	if Config.EnableESXIdentity then

		MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, hiddenjob, hiddenjob_grade FROM users WHERE hiddenjob = @hiddenjob ORDER BY hiddenjob_grade DESC', {
			['@hiddenjob'] = society
		}, function (results)
			local employees = {}

			for i=1, #results, 1 do
				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					hiddenjob = results[i].hiddenjob,
					hiddenjob_grade = results[i].hiddenjob_grade
				})
			end

			cb(employees)
		end)
	else
		MySQL.Async.fetchAll('SELECT name, identifier, hiddenjob, hiddenjob_grade FROM users WHERE hiddenjob = @hiddenjob ORDER BY hiddenjob_grade DESC', {
			['@hiddenjob'] = society
		}, function (result)
			local employees = {}

			for i=1, #result, 1 do
				table.insert(employees, {
					name       = result[i].name,
					identifier = result[i].identifier,
					hiddenjob = results[i].hiddenjob,
					hiddenjob_grade = results[i].hiddenjob_grade
				})
			end

			cb(employees)
		end)
	end
end)

ESX.RegisterServerCallback('esx_society:getJob', function(source, cb, society)
	local job    = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)

ESX.RegisterServerCallback('esx_society:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss' or xPlayer.job.grade_name == 'urzednik6' or xPlayer.job.grade_name == 'zcadyrektora' or xPlayer.job.grade_name == 'zcakomenda' or xPlayer.job.grade_name == 'uber' or xPlayer.job.grade_name == 'kierownik' or xPlayer.job.grade_name == 'kapitan3'

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob(job, grade)


			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_hired', job))
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.getJob().label))
			end
			cb()
					else
			MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
				['@job']        = job,
				['@job_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:setHiddenJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromIdentifier(identifier)

	if xTarget then
		xTarget.setHiddenJob(job, grade)

		if xTarget.source then


			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_hired', job))
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.gethiddenjob().label))
			end

			MySQL.Async.execute('UPDATE users SET hiddenjob = @hiddenjob, hiddenjob_grade = @hiddenjob_grade WHERE identifier = @identifier', {
				['@hiddenjob']        = job,
				['@hiddenjob_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)

				cb()
			end)
		else
			MySQL.Async.execute('UPDATE users SET hiddenjob = @hiddenjob, hiddenjob_grade = @hiddenjob_grade WHERE identifier = @identifier', {
				['@hiddenjob']        = job,
				['@hiddenjob_grade']  = grade,
				['@identifier'] 	  = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		MySQL.Async.execute('UPDATE users SET hiddenjob = @hiddenjob, hiddenjob_grade = @hiddenjob_grade WHERE identifier = @identifier', {
			['@hiddenjob']        = job,
			['@hiddenjob_grade']  = grade,
			['@identifier'] 	  = identifier
		}, function(rowsChanged)
			cb()
		end)
	end
end)


ESX.RegisterServerCallback('esx_society:setJobSalary', function(source, cb, job, grade, salary)
	local isBoss = isPlayerBoss(source, job)

	local identifier = GetPlayerIdentifier(source, 0)
	if isBoss then
		if salary <= Config.MaxSalary then
			MySQL.Async.execute('UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade', {
				['@salary']   = salary,
				['@job_name'] = job,
				['@grade']    = grade
			}, function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

 					if xPlayer.job.name == job and xPlayer.job.grade == grade then
						xPlayer.setJob(job, grade)
					end
				end

 				cb()
			end)
		else
			print(('esx_society: %s attempted to setJobSalary over config limit!'):format(identifier))
			cb()
		end
	else
		print(('esx_society: %s attempted to setJobSalary'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)
	-- local xPlayers = ESX.GetPlayers()
	-- local players  = {}
	
	-- for i=1, #xPlayers, 1 do
	-- 	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
	-- 	table.insert(players, {
	-- 		source     = xPlayer.source,
	-- 		identifier = xPlayer.identifier,
	-- 		name       = xPlayer.source,
	-- 		job        = xPlayer.job
	-- 	})
	-- end

	cb({})
end)

ESX.RegisterServerCallback('esx_society:getOnlinePlayersGPS', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		local moreinfo = getIdentityGPS(xPlayers[i])  		-- more info potrzebne do callbacków na GPS, zeby pobrac imie i nazwisko gracza
		if moreinfo ~= nil then
			table.insert(players, {
				source     = xPlayer.source,
				identifier = xPlayer.identifier,
				name       = xPlayer.name,
				firstname  = moreinfo.firstname,
				lastname   = moreinfo.lastname,
				job        = xPlayer.job
			})
		else
			table.insert(players, {
				source     = xPlayer.source,
				identifier = xPlayer.identifier,
				name       = xPlayer.name,
				firstname  = "off",
				lastname   = "off",
				job        = xPlayer.job
			})
		end
		
		
	end
	cb(players)
end)


ESX.RegisterServerCallback('esx_society:getVehiclesInGarage', function(source, cb, societyName)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)

function isPlayerBoss(playerId, job)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' or xPlayer.job.grade_name == 'urzednik6' or xPlayer.job.grade_name == 'zcadyrektora' or xPlayer.job.grade_name == 'zcakomenda' or xPlayer.job.grade_name == 'uber' or xPlayer.job.grade_name == 'kierownik' or xPlayer.job.grade_name == 'kapitan3' then
		return true
	else
		print(('esx_society: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

function WashMoneyCRON(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM society_moneywash', {}, function(result)
		for i=1, #result, 1 do
			local society = GetSociety(result[i].society)
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].identifier)

			-- add society money
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				account.addMoney(result[i].amount)

			end)

			-- send notification if player is online
			if xPlayer then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_laundered', ESX.Math.GroupDigits(result[i].amount)))
			end

			MySQL.Async.execute('DELETE FROM society_moneywash WHERE id = @id', {
				['@id'] = result[i].id
			})
		end
	end)
end

TriggerEvent('cron:runAt', 3, 0, WashMoneyCRON)


ESX.RegisterServerCallback("esx_society:getMeNames",function(source, callback, ids)
	local playerSource = source 
	print(playerSource.. " otwiera zatrudnianie")
    local identities = {}
    for k,v in pairs(ids) do
        local xPlayer = ESX.GetPlayerFromId(v)
		 local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
		       if result[1] ~= nil then
				local identity = result[1]
				identities[v] = identity['firstname'] .." ".. identity['lastname']
				Citizen.Wait(50)
			   end
    end
    callback(identities)
end)


ESX.RegisterServerCallback("esx_society:getMeNames2",function(source, callback, ids)
	local playerSource = source 
	print(playerSource.. " otwiera zatrudnianie hiddenjob")
    local identities = {}
    for k,v in pairs(ids) do
        local xPlayer = ESX.GetPlayerFromId(v)
		 local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
        if result[1] ~= nil then
            local identity = result[1]
      
       
		table.insert(identities, {name = identity['firstname'] .." ".. identity['lastname'], identifier = xPlayer.identifier, id = v})
            -- identities[v] = xPlayer.firstname.." "..xPlayer.lastname
			Citizen.Wait(50)
			 end
    end
    callback(identities)
end)