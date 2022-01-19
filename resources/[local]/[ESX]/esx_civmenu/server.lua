ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local katb = false
local kata = false
local katc = false
local jestb = 'nil'
local jestzdrowie = nil
local jestoc = nil
function getIdentity(license)
	local identifier = license
	local result = MySQL.Sync.fetchAll("SELECT firstname, lastname, dateofbirth, phone_number, job, job_grade, job_id, account_number FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]
		local badge = json.decode(identity.job_id)

		return {
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			phone_number = identity['phone_number'],
			job = identity['job'],
			job_grade = identity['job_grade'],
			account_number = identity['account_number'],
			badge = {
				label = badge.name,
				number = badge.id
			}

                        
		}
	else
		return nil
	end
end

function getlicenseA(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner",
    {
      ['@owner']   = xPlayer.identifier,
      ['@type'] = 'drive_bike'

    })
	if result[1] ~= nil then
        jesta = '~h~~g~A ~s~'
	else
		jesta = '~h~~r~A ~s~'
	end
end

function getlicenseB(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner",
    {
      ['@owner']   = xPlayer.identifier,
      ['@type'] = 'drive'

    })
	if result[1] ~= nil then
        jestb = '~h~~g~B ~s~'
	else
		jestb = '~h~~r~B ~s~'
	end
end

function getlicenseC(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner",
    {
      ['@owner']   = xPlayer.identifier,
      ['@type'] = 'drive_truck'

    })
	if result[1] ~= nil then 
        jestc = '~h~~g~C~n~ ~s~'
	else
		jestc = '~h~~r~C ~n~~s~'
	end
end

function getlicenseW(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner and label = @label",
    {
		['@type'] = 'weapon',
		['@owner']   = xPlayer.identifier,
		['@label'] = 'Licencja Broń',
    })
	if result[1] ~= nil then
        jestw = '~g~Tak~n~ ~s~'
	else
		jestw = '~r~Nie~n~ ~s~'
	end
end

RegisterServerEvent('dowod')
AddEventHandler('dowod', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local lickaB = getlicenseB(_source)
	local lickaA = getlicenseA(_source)
	local lickaC = getlicenseC(_source)
	local lickaW = getlicenseW(_source)
	local lickaZdrowie = getlicenseZdrowie(_source)
	local lickaOC = getlicenseOC(_source)
	local name = getIdentity(xPlayer.identifier)
	
	if name.firstname == nil then
		name.firstname = 'X'
	elseif name.lastname == nil then
		name.lastname = 'X'
	elseif name.dateofbirth == nil then
		name.dateofbirth = 'X'
	end

	TriggerClientEvent('esx:dowod_pokazdowod', -1,_source,  name.firstname..' '..name.lastname, 'Data urodzin: ~y~' ..name.dateofbirth, '~s~Licencja: '..jestw.. 'Prawo Jazdy: '..jesta..' '..jestb..' '..jestc.. 'Ubezp: ' ..jestzdrowie.. ' ' ..jestoc) 
	TriggerClientEvent("pokazujedowod", -1, _source, name.firstname .. " ".. name.lastname)
end)

function getlicenseZdrowie(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner",
    {
      ['@owner']   = xPlayer.identifier,
	  ['@type'] = 'ems_insurance',

    })


	if result[1] ~= nil then

ubeznw = true
jestzdrowie = '~g~NW~s~'
	else
		jestzdrowie = '~r~NW~s~'
	end
end

function GetCharacterName(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
	['@identifier'] = xPlayer.identifier
	})
	return result[1].firstname .. ' ' .. result[1].lastname
end

function getlicenseOC(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner",
    {
      ['@owner']   = xPlayer.identifier,
      ['@type'] = 'oc_insurance'

    })


if result[1] ~= nil then
	ubezoc = true
	jestoc = '~g~OC~s~'
	else
		jestoc = '~r~OC~s~'
	end
end

RegisterServerEvent('wizytowka')
AddEventHandler('wizytowka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)	
	local name = getIdentity(xPlayer.identifier)
		if name.phone_number == nil then 
			name.phone_number = "XXXXXX" 
		end
		
	TriggerClientEvent('esx:dowod_wiz', -1,_source, name.firstname.. ' ' ..name.lastname, ' Praca: ~y~'..xPlayer.job.label, 'Numer Telefonu: ~y~'..name.phone_number)
	TriggerClientEvent("pokazujewiz", -1, _source, name.firstname .. " - ".. name.phone_number)
end)

RegisterServerEvent('accounttest')
AddEventHandler('accounttest', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)	
	local name = getIdentity(xPlayer.identifier)
	if name.account_number == nil then
		name.account_number = "XXXXXX"
	end
	TriggerClientEvent('esx:dowod_account', -1,_source, name.firstname.. ' ' ..name.lastname,' ','Numer Konta: ~y~' ..name.account_number)
end)


RegisterServerEvent('odznaka')
AddEventHandler('odznaka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = getIdentity(xPlayer.identifier)
	local imie = name.firstname .. ' ' .. name.lastname
	local job = xPlayer.job
	local stopien = job.grade_label
	local badgeFull = 'Brak odznaki'
	if name.badge.number ~= 0 then 
		badgeFull = name.badge.label .. ' ' .. name.badge.number
	end

	local message = '^6Pokazuje odznakę policyjną: '  .. imie .. ' - [' .. badgeFull .. '] ' .. stopien ..''
	local czy_wazna

	if job.name == "police" then
		czy_wazna = "~g~Tak"
	else
		job.grade_label = "~r~Brak informacji"
		czy_wazna = "~r~Nie"
	end

	TriggerClientEvent('esx:dowod_mariuszek', -1,_source, '~w~'..name.firstname..' '..name.lastname,'Stopień: ~b~'..stopien, 'Numer odznaki: ~o~' .. badgeFull .. '~w~~s~\nOdznaka jest ważna: '..czy_wazna)
	TriggerClientEvent('esx_dowod:sendProximityMessage', -1, _source, _source, message)
end)
RegisterServerEvent('emsodznaka')
AddEventHandler('emsodznaka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = getIdentity(xPlayer.identifier)
	local imie = name.firstname .. ' ' .. name.lastname
	local job = xPlayer.job
	local stopien = job.grade_label
	local message = '^6Pokazuje Legitymację EMS ' .. imie .. ' '.. stopien
	local czy_wazna
	if job.name == "ambulance" then
		czy_wazna = "~g~Tak"
	else
		job.grade_label = "~r~Brak informacji"
		czy_wazna = "~r~Nie"
	end
	TriggerClientEvent('esx:dowod_mariuszek', -1,_source, '~h~'..name.firstname..' '..name.lastname,'Legitymacja ~p~SAMS','~w~Stopień: ~b~'..job.grade_label..'~n~~s~Legitymacja jest ważna: '..czy_wazna)
	TriggerClientEvent('esx_dowod:sendProximityMessage', -1, _source, _source, message)
end)

RegisterServerEvent('psychologodznaka')
AddEventHandler('psychologodznaka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = getIdentity(xPlayer.identifier)
	local imie = name.firstname .. ' ' .. name.lastname
	local job = xPlayer.job
	local stopien = job.grade_label
	local message = '^6Pokazuje Legitymację Psychologa ' .. imie .. ' '.. stopien
	local czy_wazna
	if job.name == "psycholog" then
		czy_wazna = "~g~Tak"
	else
		job.grade_label = "~r~Brak informacji"
		czy_wazna = "~r~Nie"
	end
	TriggerClientEvent('esx:dowod_mariuszek', -1,_source, '~h~'..name.firstname..' '..name.lastname,'Legitymacja ~p~Psychologa','~w~Stopień: ~b~'..job.grade_label..'~n~~s~Legitymacja jest ważna: '..czy_wazna)
	TriggerClientEvent('esx_dowod:sendProximityMessage', -1, _source, _source, message)
end)

RegisterServerEvent('dojodznaka')
AddEventHandler('dojodznaka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = getIdentity(xPlayer.identifier)
	local imie = name.firstname .. ' ' .. name.lastname
	local job = xPlayer.job
	local stopien = job.grade_label
	local message = '^6Pokazuje Legitymację DOJ ' .. imie .. ' '.. stopien
	local czy_wazna
	if job.name == "doj" then
		czy_wazna = "~g~Tak"
	else
		job.grade_label = "~r~Brak informacji"
		czy_wazna = "~r~Nie"
	end
	TriggerClientEvent('esx:dowod_mariuszek', -1,_source, '~h~'..name.firstname..' '..name.lastname,'Legitymacja ~p~DOJ','~w~Stopień: ~b~'..job.grade_label..'~n~~s~Legitymacja jest ważna: '..czy_wazna)
	TriggerClientEvent('esx_dowod:sendProximityMessage', -1, _source, _source, message)
end)


RegisterServerEvent('lscodznaka')
AddEventHandler('lscodznaka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = getIdentity(xPlayer.identifier)
	local imie = name.firstname .. ' ' .. name.lastname
	local job = xPlayer.job
	local stopien = job.grade_label
	local message = '^6Pokazuje Plakietkę LSCS ' .. imie .. ' '.. stopien
	local czy_wazna
	if job.name == "mecano" then
		czy_wazna = "~g~Tak"
	else
		job.grade_label = "~r~Brak informacji"
		czy_wazna = "~r~Nie"
	end
	TriggerClientEvent('esx:dowod_mariuszek', -1,_source, '~h~'..name.firstname..' '..name.lastname,'Plakietka ~o~LSCS','Stopień: ~b~'..job.grade_label..'~n~~s~Plakietka jest ważna: '..czy_wazna)
	TriggerClientEvent('esx_dowod:sendProximityMessage', -1, _source, _source, message)
end)