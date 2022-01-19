ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-------------------- Mandat --------------------

RegisterNetEvent('tablet:wystawMandat')
AddEventHandler('tablet:wystawMandat', function(target, fp, reason, fine, name, odznaka)
	local _source = source
	
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local name = GetCharacterName(target)
	local mandat = tonumber(fine)
	
	targetXPlayer.removeAccountMoney('bank', mandat)
	sourceXPlayer.addAccountMoney('bank', math.floor(mandat * Config.officerReward))
	
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
			account.addMoney(mandat * (1 - Config.officerReward))
	end)
	
	
	TriggerClientEvent('chat:addMessage', -1, {args = {_U('mandat'), _U('mandat_msg', name, mandat, reason, fp)}, color = {0, 153, 204}})

	if Config.useWebhooks then
		mandatWebhook(fp, fine, name, reason, _source)
	end
end)

-------------------- Więzienie --------------------

RegisterNetEvent('tablet:wyslijDoPaki')
AddEventHandler('tablet:wyslijDoPaki', function(target, fp, reason, fine, years, name, odznaka)
	local _source = source
	
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local name = GetCharacterName(target)
	local mandat = tonumber(fine)
	
	targetXPlayer.removeAccountMoney('bank', mandat)
	sourceXPlayer.addAccountMoney('bank', math.floor(mandat * Config.officerReward))
	
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
			account.addMoney(mandat * (1 - Config.officerReward))
	end)
	
	TriggerEvent(Config.jailTriggerName, target, years, reason, mandat, fp)
	
	if Config.useWebhooks then
		jailWebhook(fp, fine, name, reason, years, _source)
	end
end)

-------------------- Kartoteka --------------------

--Pobieranie danych

RegisterServerEvent('tablet:checkKarto')
AddEventHandler('tablet:checkKarto', function(firstname, lastname)
	local _source = source
	
	local basic = MySQL.Sync.fetchAll('SELECT * FROM users WHERE firstname = @firstname AND lastname = @lastname', {
		['@firstname'] = firstname,
		['@lastname'] = lastname,
	})
	
	if basic[1] then
		local id = basic[1].identifier
		
		local kartoteka = MySQL.Sync.fetchAll('SELECT * FROM user_kartoteka WHERE identifier = @identifier', {
			['@identifier'] = id,
		})
		
		local poszukiwania = MySQL.Sync.fetchAll('SELECT * FROM user_poszukiwania WHERE identifier = @identifier', {
			['@identifier'] = id,
		})
		
		local licenses = MySQL.Sync.fetchAll('SELECT * FROM user_licenses WHERE owner = @identifier', {
			['@identifier'] = id,
		})
		
		local cars = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', {
			['@identifier'] = id,
		})
		
		local notatki = MySQL.Sync.fetchAll('SELECT * FROM kartoteka_notatki WHERE identifier = @identifier', {
			['@identifier'] = id,
		})
		
			
		TriggerClientEvent('tablet:insertKarto', _source, basic, kartoteka, poszukiwania, licenses, cars, notatki)
	else
		TriggerClientEvent('sendBrakUzytkownika', _source)
	end
	
end)

RegisterServerEvent('tablet:insertNewAvatar')
AddEventHandler('tablet:insertNewAvatar', function(id, url, fp, target)
	local _source = source
	
	MySQL.Sync.fetchAll('UPDATE users SET kartoteka_avatar = @url WHERE identifier = @identifier',
	{
		['@identifier'] = id,
		['@url'] = url,
	})
	if Config.useWebhooks then
		changeAvatarWebhook(name, target, url, _source)
	end
end)

-- HISTORIA

RegisterServerEvent('tablet:removeKartoteka')
AddEventHandler('tablet:removeKartoteka', function(id, czas, name, target, reason, fine, jail)
	local _source = source
	
	MySQL.Sync.fetchAll('DELETE FROM user_kartoteka WHERE identifier = @identifier AND data = @data',
	{
		['@identifier'] = id,
		['@data'] = czas,
	})
	
	if Config.useWebhooks then
		removeKartotekaWebhook(name, target, reason, fine, jail, _source)
	end
	
end)

RegisterServerEvent('tablet:addKartoteka')
AddEventHandler('tablet:addKartoteka', function(id, fp, reason, fine, years)

	local identifier = GetPlayerIdentifier(id, 0)
	
	MySQL.Sync.fetchAll('INSERT INTO user_kartoteka (identifier, policjant, powod, grzywna, ilosc_lat) VALUES (@identifier, @policjant, @powod, @grzywna, @ilosc_lat) ',
	{
		['@identifier'] = identifier,
		['@policjant'] = fp,
		['@powod'] = reason,
		['@grzywna'] = fine,
		['@ilosc_lat'] = years,
	})
	
end)

-- Poszukiwania

RegisterServerEvent('tablet:poszukiwaniaDodaj')
AddEventHandler('tablet:poszukiwaniaDodaj', function(identifier, policjant, powod, pojazd, data, target)
	local _source = source
	MySQL.Sync.fetchAll('INSERT INTO user_poszukiwania (identifier, policjant, powod, pojazd, data) VALUES (@identifier, @policjant, @powod, @pojazd, @data) ',
	{
		['@identifier'] = identifier,
		['@policjant'] = policjant,
		['@powod'] = powod,
		['@pojazd'] = pojazd,
		['@data'] = data,
	})
	
	if Config.useWebhooks then
		addSuspectWebhook(policjant, pojazd, target, powod, _source)
	end
	
end)

RegisterServerEvent('tablet:removePoszukiwania')
AddEventHandler('tablet:removePoszukiwania', function(id, czas, target, policjant)
	local _source = source

	MySQL.Sync.fetchAll('DELETE FROM user_poszukiwania WHERE identifier = @identifier AND data = @data',
	{
		['@identifier'] = id,
		['@data'] = czas,
	})
	
	if Config.useWebhooks then
		removeSuspectWebhook(policjant, target, _source)
	end
end)

-- Notatki

RegisterServerEvent('tablet:removeKartotekaNotatka')
AddEventHandler('tablet:removeKartotekaNotatka', function(id, czas, fp, target, text)
	local _source = source
	
	MySQL.Sync.fetchAll('DELETE FROM kartoteka_notatki WHERE identifier = @identifier AND data = @data',
	{
		['@identifier'] = id,
		['@data'] = czas,
	})
	
	if Config.useWebhooks then
		removeNoteWebhook(fp, target, text, _source)
	end
	
end)

RegisterServerEvent('tablet:kartotekaNotatkaDodaj')
AddEventHandler('tablet:kartotekaNotatkaDodaj', function(id, fp, notatka, data, target)
	local _source = source

	MySQL.Sync.fetchAll('INSERT INTO kartoteka_notatki (identifier, note, policjant, data) VALUES (@identifier, @note, @policjant, @data)',
	{
		['@identifier'] = id,
		['@note'] = notatka,
		['@policjant'] = fp,
		['@data'] = data,
	})
	
	if Config.useWebhooks then
		addNoteWebhook(fp, target, notatka, _source)
	end
end)

-- Licencje

RegisterServerEvent('tablet:licencjaUsun')
AddEventHandler('tablet:licencjaUsun', function(id, typ, fp, target)
	local _source = source
	MySQL.Sync.fetchAll('DELETE FROM user_licenses WHERE owner = @identifier AND type = @type',
	{
		['@identifier'] = id,
		['@type'] = typ,
	})
	
	if Config.useWebhooks then
		removedLicenseWebhook(fp, typ, target, _source)
	end
	
end)

RegisterServerEvent('tablet:licencjaDodaj')
AddEventHandler('tablet:licencjaDodaj', function(id, typ, fp, target)
	local _source = source
	MySQL.Sync.fetchAll('INSERT INTO user_licenses (owner, type) VALUES (@identifier, @type)',
	{
		['@identifier'] = id,
		['@type'] = typ,
	})
	
	if Config.useWebhooks then
		addLicenseWebhook(fp, typ, target, _source)
	end
end)

-------------------- Notatnik --------------------

RegisterServerEvent('tablet:getNotepad')
AddEventHandler('tablet:getNotepad', function(id)
	local _source = source
	
	local notepad = MySQL.Sync.fetchAll('SELECT * FROM tablet_notatki WHERE identifier = @identifier', {
		['@identifier'] = id,
	})
	
	if notepad[1] then
		TriggerClientEvent('tablet:sendNotepad', _source, notepad)
	else
		MySQL.Sync.fetchAll('INSERT INTO tablet_notatki (identifier) VALUES (@identifier) ',
		{
			['@identifier'] = id,
		})
	end
	
end)

RegisterServerEvent('tablet:saveNotepad')
AddEventHandler('tablet:saveNotepad', function(id, notatka)

	MySQL.Sync.fetchAll('UPDATE tablet_notatki SET notatka = @notatka WHERE identifier = @identifier',
	{
		['@identifier'] = id,
		['@notatka'] = notatka,
	})
	
end)

-------------------- Ogłoszenia --------------------

RegisterServerEvent('tablet:getAnnouncements')
AddEventHandler('tablet:getAnnouncements', function()
	local _source = source
	
	local ogloszenia = MySQL.Sync.fetchAll('SELECT * FROM tablet_ogloszenia')
	
	TriggerClientEvent('tablet:sendAnnouncements', _source, ogloszenia)
end)


RegisterServerEvent('tablet:ogloszenieDodaj')
AddEventHandler('tablet:ogloszenieDodaj', function(fp, ogloszenie, data)
	local _source = source
	MySQL.Sync.fetchAll('INSERT INTO tablet_ogloszenia (ogloszenie, policjant, data) VALUES (@ogloszenie, @policjant, @data)',
	{
		['@ogloszenie'] = ogloszenie,
		['@policjant'] = fp,
		['@data'] = data,
	})
	
	
	TriggerClientEvent('tablet:sendNewAnnouncement', -1, ogloszenie, fp, data)
	
	if Config.useWebhooks then
		announcementWebhook(fp, ogloszenie, _source)
	end
	
end)

RegisterServerEvent('tablet:ogloszeniePowiadomienie')
AddEventHandler('tablet:ogloszeniePowiadomienie', function()
	local _source = source
	
	local identifier = GetPlayerIdentifier(_source, 0)
	
	local result = MySQL.Sync.fetchAll('SELECT seen FROM tablet_ogloszenia_seen WHERE identifier = @identifier', 
	{
		['@identifier'] = identifier,
	})
		
		if result[1] then
			MySQL.Sync.fetchAll('UPDATE tablet_ogloszenia_seen SET seen = @seen WHERE identifier = @identifier',
				{
					['@identifier'] = identifier,
					['@seen'] = 0,
				})
		else
			MySQL.Sync.fetchAll('INSERT INTO tablet_ogloszenia_seen (identifier, seen) VALUES (@identifier, @seen)',
			{
				['@identifier'] = identifier,
				['@seen'] = 0,
			})
		end
end)

ESX.RegisterServerCallback('glibcat_mdt:ogloszeniePowiadomienieSprawdz', function(source, cb)	
	local _source = source
	
	MySQL.Async.fetchAll('SELECT seen FROM tablet_ogloszenia_seen WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifier(_source, 0),
	}, function (result)
		if result[1] then
			cb(result)
		end
	end)

end)

RegisterServerEvent('tablet:ogloszeniePowiadomienieWyswietlone')
AddEventHandler('tablet:ogloszeniePowiadomienieWyswietlone', function(identifier)
	
	MySQL.Sync.fetchAll('UPDATE tablet_ogloszenia_seen SET seen = @seen WHERE identifier = @identifier',
		{
			['@identifier'] = identifier,
			['@seen'] = 1,
		})

end)


RegisterServerEvent('tablet:removeOgloszenie')
AddEventHandler('tablet:removeOgloszenie', function(czas,name,text)
	local _source = source
	MySQL.Sync.fetchAll('DELETE FROM tablet_ogloszenia WHERE data = @data',
	{
		['@data'] = czas,
	})
	
	if Config.useWebhooks then
		removeAnnouncementWebhook(name, text, _source)
	end
end)

-------------------- Raporty --------------------

RegisterServerEvent('tablet:raportDodaj')
AddEventHandler('tablet:raportDodaj', function(identifier, fp, raport, data)
	local _source = source
	
	MySQL.Sync.fetchAll('INSERT INTO tablet_raporty (identifier, raport, policjant, data) VALUES (@identifier, @raport, @policjant, @data)',
	{
		['@identifier'] = identifier,
		['@raport'] = raport,
		['@policjant'] = fp,
		['@data'] = data,
	})
	
	TriggerClientEvent('tablet:syncRaports', -1, raport, data, fp)
	
	if Config.useWebhooks then
		raportWebhook(fp, raport, _source)
	end
	
end)

RegisterServerEvent('tablet:raportUsun')
AddEventHandler('tablet:raportUsun', function(czas,name,text)
	local _source = source
	MySQL.Sync.fetchAll('UPDATE tablet_raporty SET status = @status WHERE data = @data',
	{
		['@data'] = czas,
		['@status'] = 1,
	})
end)

RegisterServerEvent('tablet:openRaports')
AddEventHandler('tablet:openRaports', function(identifier)
	local _source = source

	local raports = MySQL.Sync.fetchAll('SELECT * FROM tablet_raporty WHERE identifier = @identifier',{
		['@identifier'] = identifier,
	})
	
	TriggerClientEvent('tablet:sendRaports', _source, raports)
end)

RegisterServerEvent('tablet:openAllRaports')
AddEventHandler('tablet:openAllRaports', function()
	local _source = source

	local raports = MySQL.Sync.fetchAll('SELECT * FROM tablet_raporty')
	
	TriggerClientEvent('tablet:sendRaports', _source, raports)
end)

ESX.RegisterServerCallback('glibcat_mdt:unseenRaport', function(source, cb)	
	local _source = source
	
	MySQL.Async.fetchAll('SELECT status FROM tablet_raporty WHERE status = @status', {
		['@status'] = 0,
	}, function (result)
		if result[1] then
			cb(result)
		end
	end)

end)

-------------------- Sprawdź pojazd --------------------

RegisterServerEvent('tablet:checkVehicle')
AddEventHandler('tablet:checkVehicle', function(plate)
	local _source = source
	
	local car = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate,
	})
	
	if car[1] then
		local name = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
		{
			['@identifier'] = car[1].owner
		})
		
		local playerName = name[1].firstname .. ' ' .. name[1].lastname
		
		TriggerClientEvent('sendCheckVehicle', _source, car, playerName)
	else
		TriggerClientEvent('sendBrakPojazdu', _source)
	end
	
end)

-------------------- Inne --------------------

function GetCharacterName(source)
	local _source = source
	
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = GetPlayerIdentifier(_source, 0)
	})
	
	if result[1] ~= nil and result[1].firstname ~= nil and result[1].lastname ~= nil then
		return result[1].firstname .. ' ' .. result[1].lastname
	else
		return GetPlayerName(_source)
	end
end

RegisterServerEvent('tablet:bridge')
AddEventHandler('tablet:bridge', function()
	local _source = source
	TriggerClientEvent('tablet:nearbyPlayers', _source, _source)
end)


-- pobieranie odznaki i imienia

RegisterServerEvent('tablet:GetCharacterName')
AddEventHandler('tablet:GetCharacterName', function(jobgrade)
	local _source = source
	
	name = GetCharacterName(_source)	
	id = GetPlayerIdentifier(_source, 0)
	
	
	if Config.useBadges then

		local odznaka = MySQL.Sync.fetchAll('SELECT odznaka FROM police_odznaki WHERE identifier = @identifier',
		{
			['@identifier'] = id
		})
		
		if odznaka[1] then
		
			if odznaka[1].odznaka < 10 then
                odznaka[1].odznaka = "0" .. odznaka[1].odznaka
            end
                
            odznaka[1].odznaka = _U(jobgrade, odznaka[1].odznaka)
	
			TriggerClientEvent('tablet:sendPlayerName', _source, name, id, odznaka[1].odznaka)
			
		else
				
			TriggerClientEvent('tablet:sendPlayerName', _source, name, id)
		end
		
	else
			
		TriggerClientEvent('tablet:sendPlayerName', _source, name, id)
		
	end

end)

--zapisywanie czasu
ESX.RegisterServerCallback('glibcat_mdt:getTime', function(source, cb)
	
	result = os.time()
	cb(result)

end)

-------------------- ODZNAKI --------------------


RegisterServerEvent('tablet:odznakaDodaj')
AddEventHandler('tablet:odznakaDodaj', function(id, odznaka)
	
	if Config.useBadges then
		MySQL.Sync.fetchAll('INSERT INTO police_odznaki (identifier, odznaka) VALUES (@identifier, @odznaka)',
		{
			['@identifier'] = id,
			['@odznaka'] = odznaka,
		})
	end

end)

RegisterServerEvent('tablet:odznakaUsun')
AddEventHandler('tablet:odznakaUsun', function(id)

	if Config.useBadges then
		MySQL.Sync.fetchAll('DELETE FROM police_odznaki WHERE identifier = @identifier',
		{
			['@identifier'] = id,
		})
	end
	
end)

RegisterServerEvent('tablet:odznakaZmien')
AddEventHandler('tablet:odznakaZmien', function(id, odznaka)

	if Config.useBadges then
		MySQL.Sync.fetchAll('UPDATE police_odznaki SET odznaka = @odznaka WHERE identifier = @identifier',
		{
			['@identifier'] = id,
			['@odznaka'] = odznaka,
		})
	end
	
end)


-------------------- WEBHOOOOOOOOOOOOKI --------------------


function sendWebhook(message, color, channel)
	PerformHttpRequest(
		Config.webhooks[channel], 
		function(err, text, headers) end, 
		'POST', json.encode({
		username = Config.username, 
		embeds = {{
			["color"] = color, 
			["author"] = {["name"] = Config.fractionName,
			["icon_url"] = Config.fractionLogo}, 
			["description"] = "".. message .."",
			["footer"] = {["text"] = os.date("%Y-%m-%d %X"),},}}, avatar_url = Config.avatar}), { ['Content-Type'] = 'application/json' 
		})
end

-- LICENSES

function removedLicenseWebhook(name, typ, target, source)
	local _source = source
	
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	sendWebhook('**' .. target .. '** traci ' .. changekLicenseName(typ) .. funkcjonariusz .. '' .. discordID, Config.removeLicense, 'licencja')
end


function addLicenseWebhook(name, typ, target, source)
	local _source = source

	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	sendWebhook('**' .. target  .. '** otrzymuje ' .. changekLicenseName(typ) .. funkcjonariusz .. '' .. discordID, Config.addLicense, 'licencja')
end

-- MANDAT

function mandatWebhook(name, fine, target, reason, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	local powod = "\n**Powód: **" .. reason
	sendWebhook('**' .. target  .. '** otrzymuje mandat w wysokosci $' .. fine .. powod ..funkcjonariusz .. '' .. discordID, Config.mandatColor, 'mandat')
end

-- JAIL

function jailWebhook(name, fine, target, reason, years, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	local powod = "\n**Powod: **" .. reason
	local grzywna = "\n**Grzywna: **" .."$" .. fine 
	sendWebhook('**' .. target  .. '** trafia do wiezienia na ' .. years .. " lat" .. powod .. grzywna .. funkcjonariusz .. '' .. discordID, Config.jailColor, 'mandat')
end

-- ANNOUNCEMENT

function announcementWebhook(name, text)
	local tresc = "\n**Treść: **" .. text
	sendWebhook('**' .. name  .. '** dodał ogłoszenie ' .. tresc, Config.announcementColor, 'ogloszenia')
end

-- RAPORTY

function raportWebhook(name, text, source)
	local _source = source
	
	
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local tresc = "\n**Treść: **" .. text
	
	sendWebhook('**' .. name  .. '** dodał raport ' .. tresc .. discordID, Config.raportColor, 'raport')
end

-- SUSPECT

function addSuspectWebhook(name, car, target, reason, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	local powod = "\n**Powód: **" .. reason
	local auto = "\n**Pojazd: **" .. car
	sendWebhook('**' .. target  .. '** jest poszukiwany' .. powod .. auto ..funkcjonariusz .. '' .. discordID, Config.suspectAddColor, 'poszukiwani')
end

function removeSuspectWebhook(name, target, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local funkcjonariusz = "\n**Podpis: **" .. name
	sendWebhook('**' .. target  .. '** nie jest już poszukiwany'..funkcjonariusz .. '' .. discordID, Config.suspectRemoveColor, 'poszukiwani')
end

-- LOGS

function removeNoteWebhook(name, target, text, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local tresc= "\n**Treść: **" .. text
	sendWebhook('**' .. name  .. '** usunal notatke, w kartotece obywatela: ' .. target .. tresc .. discordID, Config.logColor, 'logs')
end

function addNoteWebhook(name, target, text, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local tresc= "\n**Treść: **" .. text
	sendWebhook('**' .. name  .. '** dodaje notatke, w kartotece obywatela: ' .. target .. tresc .. discordID, Config.logColor, 'logs')
end

function removeKartotekaWebhook(name, target, reason, fine, jail, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local tresc = "\n**Powód: **" .. reason
	local grzywna = "\n**Grzywna: **" .. fine
	local wiezienie = "\n**Więzienie: **" .. jail
	sendWebhook('**' .. name  .. '** usunal wpis z kartoteki obywatela: ' .. target .. tresc .. grzywna .. wiezienie .. discordID, Config.logColor, 'logs')
end

function removeAnnouncementWebhook(name, text, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local tresc = "\n**Treść: **" .. text
	sendWebhook('**' .. name  .. '** usunal ogloszenie:' .. tresc .. discordID, Config.logColor, 'logs')
end

function changeAvatarWebhook(name, target, avatarUrl, source)
	local _source = source
	if Config.discordTag then
		local identifiers = getIdentifiers(_source)
		discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
	else
		discordID = ""
	end
	
	local avatar = "\n**Zdjecie: **" .. avatarUrl

	sendWebhook('**' .. name  .. '** zmienil zdjecie obywatela: ' .. target .. avatar .. discordID, Config.logColor, 'logs')
end


function getIdentifiers(player)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(player) - 1 do
        local raw = GetPlayerIdentifier(player, i)
        local tag, value = raw:match("^([^:]+):(.+)$")
        if tag and value then
            identifiers[tag] = value
        end
    end
    return identifiers
end



function changekLicenseName(licencja)
	local name = "";
	if(licencja == "drive_bike" ) then
		name = "prawo jazdy kat. A"
		return name
	elseif (licencja == "drive" ) then
		name = "prawo jazdy kat. B"
		return name
	elseif (licencja == "drive_truck" ) then
		name = "prawo jazdy kat. C"
		return name
	elseif (licencja == "weapon" ) then
		name = "licencję na broń krótką"
		return name
	elseif (licencja == "weapon_long") then
		name = "licencję na broń długą"
		return name
	end
end