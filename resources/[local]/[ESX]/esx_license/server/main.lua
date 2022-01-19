ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local licenseslist = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT type, label FROM licenses', {
	
	}, function(result)
		for i=1, #result, 1 do
			table.insert(licenseslist, {
				type  = result[i].type,
				label = result[i].label
			})
		end
	end)
end)

function AddLicense(target, type, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
		['@type']  = type,
		['@owner'] = xPlayer.identifier
	}, function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

function RemoveLicense(target, type, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target)
	local steamid = xPlayer.identifier
	local name = GetPlayerName(source)
	TriggerClientEvent('esx:showNotification', target, 'Otrzymałeś licencję na borń od: '..source)
	wiadomosc = "NADANO LICENCJE DLA: "..target.."\n[ID: "..source.." | Nazwa Steam: "..name.." | ROCKSTAR: "..steamid.." ]" 
	deltelicka('IslandRP.pl', wiadomosc, 11750815)
	MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = xPlayer.identifier
	}, function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

function deltelicka(hook,message,color)
  local gigafajnywebhook223 = 'https://discord.com/api/webhooks/863863494314557501/dP9hEkDhxOQ_HdX7Sz4XGTNQkva7MwCroyFJ9A-HgMZG5kxawhjJgwKDUIFanAiq_ThD'
  local embeds = {
              {
          ["title"] = message,
          ["type"] = "rich",
          ["color"] = color,
          ["footer"] = {
              ["text"] = 'IslandRP.pl'
                  },
              }
          }
  if message == nil or message == '' then return FALSE end
  PerformHttpRequest(gigafajnywebhook223, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function GetLicense(type, cb)
	local data = {}
	for k,v in ipairs(licenseslist) do
		if v.type == type then
			data = {
				type  = v.type,
				label = v.label,
			}
			break
		end
	end
	
	cb(data)
end

function GetLicenses(target, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(result)
		local licenses   = {}
		local asyncTasks = {}

		for i=1, #result, 1 do

			local scope = function(type)
				table.insert(asyncTasks, function(cb)						
					for k,v in ipairs(licenseslist) do
						if v.type == type then
							table.insert(licenses, {
								type = v.type,
								label = v.label
							})
							break
						end
					end
					
					cb()
				end)
			end

			scope(result[i].type)

		end

		Async.parallel(asyncTasks, function(results)
			cb(licenses)
		end)

	end)
end

function CheckLicense(target, type, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = xPlayer.identifier,
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

function GetLicensesList(cb)
	cb(licenseslist)
end

RegisterNetEvent('esx_license:addLicense')
AddEventHandler('esx_license:addLicense', function(target, type, cb)
	AddLicense(target, type, cb)
end)

RegisterNetEvent('esx_license:removeLicense')
AddEventHandler('esx_license:removeLicense', function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicense', function(type, cb)
	GetLicense(type, cb)
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
	GetLicenses(target, cb)
end)

AddEventHandler('esx_license:checkLicense', function(target, type, cb)
	CheckLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, type)
	GetLicense(type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
	GetLicenses(target, cb)
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, type)
	CheckLicense(target, type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicensesList', function(source, cb)
	GetLicensesList(cb)
end)