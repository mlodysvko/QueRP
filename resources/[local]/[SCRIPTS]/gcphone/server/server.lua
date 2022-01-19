--====================================================================================
-- #Author: Jonathan D @Gannon
-- #Version 2.0
--====================================================================================
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

math.randomseed(os.time()) 

--- Pour les numero du style XXX-XXXX
function getPhoneRandomNumber()
    local numBase0 = math.random(10000,99999)
    local numBase1 = math.random(0,999)
    local num = string.format("%03d-%04d", numBase0, numBase1 )
	return num
end

RegisterServerEvent('arivi:activesim')
AddEventHandler('arivi:activesim', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		MySQL.Async.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1] then
				local numer = result[1].phone_number
				if numer ~= nil then			  
					phoneNumber = numer
					TriggerClientEvent("gcPhone:myPhoneNumber",_source, numer)
					TriggerClientEvent("route68:UpdateNumber",_source, numer)
				end
			end
		end)
	end
end)

ESX.RegisterServerCallback('gcphone:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer ~= nil then
		local items = xPlayer.getInventoryItem(item)
		
		if items == nil then
			cb(0)
		else
			cb(items.count)
		end
	end
end)

RegisterServerEvent('route68:SetNumber')
AddEventHandler('route68:SetNumber', function(numb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
    }, function(result)
        if tonumber(result[1].phone_number) == tonumber(numb) then
			TriggerClientEvent("gcPhone:myPhoneNumber",_source,nil)
			TriggerClientEvent("route68:UpdateNumber",_source,nil)
			MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
			{
				['@identifier']   = xPlayer.identifier,
				['@phone_number'] = nil
			})
			
			TriggerClientEvent('gcphone:komunikat', _source, "~p~Dezaktywowano kartę SIM: ~g~" .. numb)
		else
			phoneNumber = numb
			TriggerClientEvent("gcPhone:myPhoneNumber", _source, numb)
			TriggerClientEvent("route68:UpdateNumber", _source, numb)
		  
			MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
			{
				['@identifier']   = xPlayer.identifier,
				['@phone_number'] = phoneNumber
			})
			TriggerClientEvent('gcphone:komunikat', _source, "~p~Aktywowano kartę SIM: ~g~" .. tostring(phoneNumber))
		end
    end)	
end)

RegisterServerEvent('route68:SetNumberWejscie')
AddEventHandler('route68:SetNumberWejscie', function(numb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  
	local text = ''
	phoneNumber = numb
	TriggerClientEvent("gcPhone:myPhoneNumber",_source,numb)
	TriggerClientEvent("route68:UpdateNumber",_source,numb)
end)

ESX.RegisterServerCallback('route68:getTargetSim', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM user_sim WHERE user = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(results)
		cb(results)
	end)
  
end)

ESX.RegisterServerCallback('route68:getSim', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT * FROM user_sim WHERE user = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(results)
		cb(results)
	end)
  
end)

ESX.RegisterServerCallback('route68:getSimWczytana', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
    }, function(result)
        cb(result)
    end)
  
end)

RegisterServerEvent('route68:Throw')
AddEventHandler('route68:Throw', function(number)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('UPDATE user_sim SET user = NULL WHERE number = @number',
	{
		['@number'] = number
	})
	MySQL.Async.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1].phone_number == number then
			MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier', {
				['@identifier']   = xPlayer.identifier,
				['@phone_number'] = nil,
			})
			TriggerClientEvent("gcPhone:myPhoneNumber",_source, nil)
			TriggerClientEvent("route68:UpdateNumber",_source, nil)
		end
	end)
	TriggerClientEvent('gcphone:komunikat', _source, "Wyrzucono karte SIM: ~g~" .. number)
	--TriggerClientEvent('sendProximityMessageDo', -1, _source, _source, "Obywatel: upuścił na ziemię kartę SIM: "..number)
	TriggerClientEvent('esx_inventoryhud:getOwnedSim', _source)
end)

RegisterServerEvent('route68:off')
AddEventHandler('route68:off', function(number,data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
	{
		['@identifier']   = xPlayer.identifier,
		['@phone_number'] = nil
	})
	TriggerClientEvent("gcPhone:myPhoneNumber",_source,nil)
	TriggerClientEvent("route68:UpdateNumber",_source,nil)
	TriggerClientEvent('gcphone:komunikat', source, "~p~Odpieto karte SIM: ~g~" .. phoneNumber)
end)

function GenerateUniquePhoneNumber()
    local running = true
    local phone = nil
    while running do
        local rand = '' .. math.random(1111,9999)
        local count = MySQL.Sync.fetchScalar("SELECT COUNT(number) FROM user_sim WHERE number = @phone_number", { ['@phone_number'] = rand })
        if count < 1 then
            phone = rand
            running = false
        end
    end
    return phone
end

function getPhoneNumber(source, callback) 
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer == nil then
      callback(nil)
    end
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
      ['@identifier'] = xPlayer.identifier
    }, function(result)
      callback(result[1].phone_number)
    end)
end


function GetCharacterPhone(source)
	local result = MySQL.Sync.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].phone_number then
		return result[1].phone_number
	else
		return nil
	end
end

RegisterServerEvent('route68:useSim')
AddEventHandler('route68:useSim', function(number)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent("gcPhone:myPhoneNumber",_source,number)
	TriggerClientEvent("route68:UpdateNumber",_source,number)
	
	MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
	{
		['@identifier']   = xPlayer.identifier,
		['@phone_number'] = number
	})
end)

RegisterServerEvent('gcphone:zabierz')
AddEventHandler('gcphone:zabierz', function(target, number)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('gcphone:zajebkarte', targetPlayer.source, source, number)
end)

RegisterServerEvent('gcphone:putSimInStock')
AddEventHandler('gcphone:putSimInStock', function(number, name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.execute('UPDATE user_sim SET user = NULL, house = @name WHERE number = @number',
	{
		['@name'] = name,
		['@number'] = number
	})
	MySQL.Async.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1].phone_number == number then
			MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier', {
				['@identifier']   = xPlayer.identifier,
				['@phone_number'] = nil,
			})
			TriggerClientEvent("gcPhone:myPhoneNumber",_source, nil)
			TriggerClientEvent("route68:UpdateNumber",_source, nil)
		end
	end)
	TriggerClientEvent('gcphone:komunikat', _source, "Włożyłeś kartę SIM: ~g~" .. number)
	TriggerClientEvent('esx_inventoryhud:getOwnedSim', _source)
end)

RegisterServerEvent('gcphone:getSimFromStock')
AddEventHandler('gcphone:getSimFromStock', function(number, name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.execute('UPDATE user_sim SET user = @user, house = @name WHERE number = @number',
	{
		['@user'] = xPlayer.identifier,
		['@name'] = 'Brak',
		['@number'] = number
	})
	TriggerClientEvent('gcphone:komunikat', _source, "Wyciągnąłeś kartę SIM: ~g~" .. number)
	TriggerClientEvent('esx_inventoryhud:getOwnedSim', _source)
end)

ESX.RegisterServerCallback('gcphone:getSimsInStock', function(source, cb, name)
	local _source = source
	local Sims = {}
	local xPlayer = ESX.GetPlayerFromId(source)
	
	Sims = MySQL.Sync.fetchAll('SELECT * FROM user_sim WHERE house = @house', {
		['@house'] = name,
	})
	
	cb(Sims)
end)

RegisterServerEvent('route68:TakeNumber')
AddEventHandler('route68:TakeNumber', function(target, number)
	local _source = source
	local _target = target
	local tPlayer = ESX.GetPlayerFromId(_target)
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.execute('UPDATE user_sim SET user = @user WHERE number = @number',
	{
		['@user'] = xPlayer.identifier,
		['@number'] = number
	})
	MySQL.Async.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = tPlayer.identifier
	}, function(result)
		if result[1].phone_number == number then
			MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier', {
				['@identifier']   = tPlayer.identifier,
				['@phone_number'] = nil,
			})
			TriggerClientEvent("gcPhone:myPhoneNumber", _target, nil)
			TriggerClientEvent("route68:UpdateNumber", _target, nil)
		end
	end)
	TriggerClientEvent('gcphone:komunikat', _source, "Zabrałeś kartę sim SIM #~r~" .. number)
	TriggerClientEvent('gcphone:komunikat', _target, "Zabrano Ci kartę SIM #~g~" .. number)
	TriggerClientEvent('esx_inventoryhud:getOwnedSim', _source)
	TriggerClientEvent('esx_inventoryhud:getOwnedSim', _target)

end)

RegisterServerEvent('route68:GiveNumber')
AddEventHandler('route68:GiveNumber', function(target, number)
	local _source = source
	local tPlayer = ESX.GetPlayerFromId(target)
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.execute('UPDATE user_sim SET user = @user WHERE number = @number',
	{
		['@user'] = tPlayer.identifier,
		['@number'] = number
	})
	MySQL.Async.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1].phone_number == number then
			MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier', {
				['@identifier']   = xPlayer.identifier,
				['@phone_number'] = nil,
			})
			TriggerClientEvent("gcPhone:myPhoneNumber",_source, nil)
			TriggerClientEvent("route68:UpdateNumber",_source, nil)
		end
	end)
	TriggerClientEvent('gcphone:komunikat', _source, "Przekazałeś kartę SIM #~r~" .. number)
	TriggerClientEvent('gcphone:komunikat', target, "Otrzymałeś kartę SIM #~g~" .. number)
	TriggerClientEvent('esx_inventoryhud:getOwnedSim', _source)
	TriggerClientEvent('esx_inventoryhud:getOwnedSim', target)

end)
--====================================================================================
--  Utils
--====================================================================================
function getSourceFromIdentifier(identifier, cb)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if(xPlayer.identifier ~= nil and xPlayer.identifier == identifier) or (xPlayer.identifier == identifier) then
			cb(xPlayer.source)
			return
		end
	end
	cb(nil)
end

function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number) 
    local result = MySQL.Sync.fetchAll("SELECT users.identifier FROM users WHERE users.phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return nil
end

function getIdByPhoneNumber(phone_number) 
    local result = MySQL.Sync.fetchAll("SELECT identifier FROM user_sim WHERE number = @phone_number", {
        ['@phone_number'] = phone_number
    })
	if result[1] ~= nil then
		return result[1].identifier
    end
    return nil
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function getOrGeneratePhoneNumber (identifier, cb)
    --[[local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        MySQL.Async.insert("UPDATE users SET phone_number = @myPhoneNumber WHERE identifier = @identifier", { 
            ['@myPhoneNumber'] = myPhoneNumber,
            ['@identifier'] = identifier
        }, function ()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end]]
end
--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier)
    local phone_number = MySQL.Sync.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier,
	})
	
	if phone_number[1] == nil then return end
	
	local result = MySQL.Sync.fetchAll("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.ownernumber = @ownernumber", {
		['@ownernumber'] = phone_number[1].phone_number
	})
	
    return result
end

function addContact(source, identifier, number, display)
    local sourcePlayer = tonumber(source)
	local phone_number = MySQL.Sync.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier,
	})
	
    MySQL.Async.insert("INSERT INTO phone_users_contacts (`ownernumber`, `number`,`display`) VALUES(@ownernumber, @number, @display)", {
		['@ownernumber'] = phone_number[1].phone_number,
        ['@number'] = number,
        ['@display'] = display,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end

function updateContact(source, identifier, id, number, display)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id", { 
        ['@number'] = number,
        ['@display'] = display,
        ['@id'] = id,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end

function deleteContact(source, identifier, id)
    local sourcePlayer = tonumber(source)
	local phone_number = MySQL.Sync.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier,
	})
	
    MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `ownernumber` = @ownernumber AND `id` = @id", {
        ['@ownernumber'] = phone_number[1].phone_number,
        ['@id'] = id,
    })
    notifyContactChange(sourcePlayer, identifier)
end

function deleteAllContact(identifier)
    MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier", {
        ['@identifier'] = identifier
    })
end

function notifyContactChange(source, identifier)
    local sourcePlayer = tonumber(source)
    local identifier = identifier
    if sourcePlayer ~= nil then 
        TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(identifier))
    end
end

RegisterServerEvent('gcPhone:addContact')
AddEventHandler('gcPhone:addContact', function(display, phoneNumber)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    addContact(sourcePlayer, identifier, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:updateContact')
AddEventHandler('gcPhone:updateContact', function(id, display, phoneNumber)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    updateContact(sourcePlayer, identifier, id, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:deleteContact')
AddEventHandler('gcPhone:deleteContact', function(id)
    local _source = source
    local sourcePlayer = tonumber(_source)
	xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteContact(sourcePlayer, identifier, id)
end)

--====================================================================================
--  Messages
--====================================================================================
function getMessages(identifier)
    local result = MySQL.Sync.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {
         ['@identifier'] = identifier
    })
    return result
    --return MySQLQueryTimeStamp("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {['@identifier'] = identifier})
end

RegisterServerEvent('gcPhone:_internalAddMessage')
AddEventHandler('gcPhone:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function _internalAddMessage(transmitter, receiver, message, owner)
    local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);"
    local Query2 = 'SELECT * from phone_messages WHERE `id` = @id;'
	local Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    }
    local id = MySQL.Sync.insert(Query, Parameters)
    return MySQL.Sync.fetchAll(Query2, {
        ['@id'] = id
    })[1]
end

function addMessage(source, identifier, phone_number, message)
    local sourcePlayer = tonumber(source)
    local otherIdentifier = getIdByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)
    local otherPhone = getNumberPhone(otherIdentifier)

    local memess = _internalAddMessage(phone_number, myPhone, message, 1)
    TriggerClientEvent("gcPhone:receiveMessage", sourcePlayer, memess)

    if otherIdentifier ~= nil then 
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
        local player = ESX.GetPlayerFromIdentifier(otherIdentifier)
        if player ~= nil then
            if player.source ~= source and otherPhone == phone_number then
                TriggerEvent('ReturnSkin', sourcePlayer, function(data)
					local currentSkin = data
					TriggerClientEvent("gcPhone:receiveMessage", player.source, tomess, sourcePlayer, currentSkin)
				end)
            end
        end
    end
end

function setReadMessageNumber(identifier, num)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", { 
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
end

function deleteMessage(msgId)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
    local source = source
    local identifier = identifier
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number})
end

function deleteAllMessage(identifier)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
end

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(phoneNumber, message)
    local _source = source
    local sourcePlayer = tonumber(_source)
	xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    addMessage(sourcePlayer, identifier, phoneNumber, message)
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = GetPlayerName(source)
    wiadomoscxD = "WYSŁANA WIADOMOSĆ: "..message.." DO: "..phoneNumber.."\n[ID: "..source.." | Nazwa Steam: "..name.." | ROCKSTAR: "..identifier.." ]" 
    wiadomosci('QueRP', wiadomoscXD, 11750815)
    xPlayer.removeAccountMoney('bank', Config.sms)
	TriggerClientEvent('gcphone:komunikat', sourcePlayer, 'Pobrano za SMS: ~g~'..Config.sms..'$')
end)


function wiadomosci(hook,message,color)
    local msg22 = 'https://discord.com/api/webhooks/848660580746526732/Z3-ySBbge2749aEY2j3HlYdHD7lOb5_zv5d-f9uxlSSRp5NkdoOHqMEtvUtVNQrqKkXV'
    local embeds = {
                {
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
				["text"] = ''
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(msg22, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds, message = message}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('gcPhone:deleteMessage')
AddEventHandler('gcPhone:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('gcPhone:deleteMessageNumber')
AddEventHandler('gcPhone:deleteMessageNumber', function(number)
    local _source = source
    local sourcePlayer = tonumber(_source)
    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteAllMessageFromPhoneNumber(sourcePlayer,identifier, number)
    -- TriggerClientEvent("gcphone:allMessage", sourcePlayer, getMessages(identifier))
end)

RegisterServerEvent('gcPhone:deleteAllMessage')
AddEventHandler('gcPhone:deleteAllMessage', function()
    local _source = source
	xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteAllMessage(identifier)
end)

RegisterServerEvent('gcPhone:setReadMessageNumber')
AddEventHandler('gcPhone:setReadMessageNumber', function(num)
    local _source = source
	xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('gcPhone:deleteALL')
AddEventHandler('gcPhone:deleteALL', function()
    local _source = source
    local sourcePlayer = tonumber(_source)
	xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    deleteAllMessage(identifier)
    deleteAllContact(identifier)
    appelsDeleteAllHistorique(identifier)
    TriggerClientEvent("gcPhone:contactList", sourcePlayer, {})
    TriggerClientEvent("gcPhone:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall (num)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall (src, num) 
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('gcPhone:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.transmitter_num,
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            num = "###-####"
        end
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('gcPhone:getHistoriqueCall')
AddEventHandler('gcPhone:getHistoriqueCall', function()
    local _source = source
    local sourcePlayer = tonumber(_source)
	xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    local srcPhone = getNumberPhone(identifier)
    sendHistoriqueCall(sourcePlayer, num)
end)

RegisterServerEvent('gcPhone:register_FixePhone')
AddEventHandler('gcPhone:register_FixePhone', function(phone_number, coords)
	Config.FixePhone[phone_number] = {name = _U('phone_booth'), coords = {x = coords.x, y = coords.y, z = coords.z}}
	TriggerClientEvent('gcPhone:register_FixePhone', -1, phone_number, Config.FixePhone[phone_number])
end)

RegisterServerEvent('gcPhone:internal_startCall')
AddEventHandler('gcPhone:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    if Config.FixePhone[phone_number] ~= nil then
        onCallFixePhone(source, phone_number, rtcOffer, extraData)
        return
    end
    
    local rtcOffer = rtcOffer
	local id = nil
	local found = false
	local zajete = false
    if phone_number == nil or phone_number == '' then 
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
    local srcIdentifier = xPlayer.identifier

    local srcPhone = ''
	if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
	else
		srcPhone = getNumberPhone(srcIdentifier)
    end
    local destPlayer = getIdentifierByPhoneNumber(phone_number)
    local is_valid = destPlayer ~= nil and destPlayer ~= srcIdentifier
    
    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = destPlayer ~= nil,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData
    }

    if is_valid == true then		
        local player = ESX.GetPlayerFromIdentifier(destPlayer)
        if player ~= nil then
            if player.source ~= source then
                AppelsEnCours[indexCall].receiver_src = player.source
                TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
                TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                TriggerClientEvent('gcPhone:waitingCall', player.source, AppelsEnCours[indexCall], false)
                found = true
            end
        end
        
        if not found then
            TriggerClientEvent('gcphone:komunikat', sourcePlayer, '~r~Abonent jest czasowo niedostępny')
        end
    else
        TriggerClientEvent('gcphone:komunikat', sourcePlayer, '~r~Numer jest nieprawidłowy lub nie istnieje ')
    end
end)

RegisterServerEvent('gcphone:bill')
AddEventHandler('gcphone:bill', function(czas)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ile = math.floor(Config.call * czas / 4)
	xPlayer.removeAccountMoney('bank', ile)
	TriggerClientEvent('gcphone:komunikat', source, 'Koszt połączenia: ~g~'..ile..'$')
end)

RegisterServerEvent('gcPhone:startCall')
AddEventHandler('gcPhone:startCall', function(phone_number, rtcOffer, extraData)
    local _source = source
    TriggerEvent('gcPhone:internal_startCall',_source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('gcPhone:candidates')
AddEventHandler('gcPhone:candidates', function (callId, candidates)
    -- print('send cadidate', callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local _source = source
        local to = AppelsEnCours[callId].transmitter_src
        if _source == to then 
            to = AppelsEnCours[callId].receiver_src
        end
        -- print('TO', to)
        TriggerClientEvent('gcPhone:candidates', to, candidates)
    end
end)

RegisterServerEvent('gcPhone:acceptCall')
AddEventHandler('gcPhone:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	    SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	    end)
            saveAppels(AppelsEnCours[id])
        end
    end
end)

RegisterServerEvent('gcPhone:rejectCall')
AddEventHandler('gcPhone:rejectCall', function (infoCall)
    local _source = source
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then 
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('gcPhone:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('gcPhone:appelsDeleteHistorique')
AddEventHandler('gcPhone:appelsDeleteHistorique', function (numero)
    local _source = source
    local sourcePlayer = tonumber(_source)
	local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    local srcPhone = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(srcIdentifier)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
end

RegisterServerEvent('gcPhone:appelsDeleteAllHistorique')
AddEventHandler('gcPhone:appelsDeleteAllHistorique', function ()
    local _source = source
    local sourcePlayer = tonumber(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    appelsDeleteAllHistorique(identifier)
end)

--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler('esx:playerLoaded',function(playerId, xPlayer)
    local sourcePlayer = playerId
    local identifier = xPlayer.identifier
    local num = getNumberPhone(identifier)

	getOrGeneratePhoneNumber(identifier, function (myPhoneNumber)
        TriggerClientEvent('gcPhone:myPhoneNumber', sourcePlayer, myPhoneNumber)
        TriggerClientEvent('gcPhone:contactList', sourcePlayer, getContacts(identifier))
        TriggerClientEvent('gcPhone:allMessage', sourcePlayer, getMessages(identifier))
        TriggerClientEvent('gcPhone:getBourse', sourcePlayer, getBourse())
        sendHistoriqueCall(sourcePlayer, num)
    end)
end)

RegisterServerEvent('gcPhone:allUpdate')
AddEventHandler('gcPhone:allUpdate', function()
    local _source = source
    local sourcePlayer = tonumber(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)
    while xPlayer == nil do
        xPlayer = ESX.GetPlayerFromId(_source)
        Citizen.Wait(10000)
    end
    local identifier = xPlayer.identifier
    local num = getNumberPhone(identifier)
    TriggerClientEvent("gcPhone:myPhoneNumber", sourcePlayer, num)
    TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(identifier))
    TriggerClientEvent("gcPhone:allMessage", sourcePlayer, getMessages(identifier))
    TriggerClientEvent('gcPhone:getBourse', sourcePlayer, getBourse())
    sendHistoriqueCall(sourcePlayer, num)
end)

--[[ AddEventHandler('onMySQLReady', function ()
    MySQL.Async.fetchAll("DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)")
end) --]]

--====================================================================================
--  App bourse
--====================================================================================
function getBourse()
    local result = {
        {
            libelle = 'Google',
            price = 125.2,
            difference =  -12.1
        },
        {
            libelle = 'Microsoft',
            price = 132.2,
            difference = 3.1
        },
        {
            libelle = 'Amazon',
            price = 120,
            difference = 0
        }}
    return result
end

--====================================================================================
--  App ... WIP
--====================================================================================
-- SendNUIMessage('ongcPhoneRTC_receive_offer')
-- SendNUIMessage('ongcPhoneRTC_receive_answer')

-- RegisterNUICallback('gcPhoneRTC_send_offer', function (data)

-- end)

-- RegisterNUICallback('gcPhoneRTC_send_answer', function (data)

-- end)

function onCallFixePhone (source, phone_number, rtcOffer, extraData)
    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end
    local sourcePlayer = tonumber(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = '###-####' -- This change was made for public phones without phone number reading in mind
    end

    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = false,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData,
        coords = Config.FixePhone[phone_number].coords
    }
    
    PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

    TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end

function onAcceptFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    
    AppelsEnCours[id].receiver_src = source
    if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
        AppelsEnCours[id].is_accepts = true
        AppelsEnCours[id].forceSaveAfter = true
        AppelsEnCours[id].rtcAnswer = rtcAnswer
        PhoneFixeInfo[id] = nil
        TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
        TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
        SetTimeout(1000, function() -- change to +1000, if necessary.
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
        end)
        saveAppels(AppelsEnCours[id])
    end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    PhoneFixeInfo[id] = nil
    TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
    if AppelsEnCours[id].is_accepts == false then
        saveAppels(AppelsEnCours[id])
    end
    AppelsEnCours[id] = nil 
end

RegisterServerEvent('gcPhone:buySimKarta')
AddEventHandler('gcPhone:buySimKarta', function(type)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    phoneNumber = GenerateUniquePhoneNumber()
    
	MySQL.Async.fetchAll('SELECT * FROM user_sim WHERE identifier = @identifier',
	{
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if #result >= 5 then
			TriggerClientEvent('gcphone:komunikat', _source, "~r~Posiadasz już maksymalną ilość kart SIM")
		else
			if type == 'proste' then		
				MySQL.Async.execute('INSERT INTO user_sim (identifier,user,number,label,house) VALUES(@identifier,@user,@number,@label,@house)', {
					['@identifier']   = xPlayer.identifier,
					['@user']   	  = xPlayer.identifier,
					['@phone_number'] = phoneNumber,
					['@label']        = "SIM #"..phoneNumber
				})
				TriggerClientEvent('gcphone:komunikat', _source, "~p~Kupiłeś nowy starter ~g~#" .. phoneNumber)
				TriggerClientEvent('esx_inventoryhud:getOwnedSim', _source)
			end	
		end
	end)
end)

ESX.RegisterServerCallback('gcPhone:getAdministrators', function(source, cb, number)
	MySQL.Async.fetchAll('SELECT * FROM user_sim WHERE number = @number', 
	{
		['@number'] = number
	}, function(result)
		local resultTable = {}
		local found, found2 = false, false
		if result[1].admin1 ~= nil then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM characters WHERE identifier = @identifier',
			{
				['@identifier'] = result[1].admin1
			}, function(result2)
				table.insert(resultTable, {label = result2[1].firstname .. " " .. result2[1].lastname, value = 1})
				found = true
			end)
		else
			found = true
		end
		if result[1].admin2 ~= nil then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM characters WHERE identifier = @identifier',
			{
				['@identifier'] = result[1].admin2
			}, function(result2)
				table.insert(resultTable, {label = result2[1].firstname .. " " .. result2[1].lastname, value = 2})
				found2 = true
			end)
		else
			found2 = true
		end
		while not found or not found2 do
			Citizen.Wait(200)
		end
		cb(resultTable)
	end)
end)

RegisterServerEvent('gcPhone:removeAdministrator')
AddEventHandler('gcPhone:removeAdministrator', function(number, id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() < 5000 then
		xPlayer.showNotification('~r~Nie masz wystarczająco pieniędzy przy sobie')
		return
	end

	MySQL.Async.execute('UPDATE user_sim SET admin' .. id .. ' = NULL WHERE number = @number',
	{
		['@number'] = number
	})
	xPlayer.removeMoney(5000)
	xPlayer.showNotification('~g~Usunięto~w~ wybranego administratora numeru ~y~' .. number)
end)

RegisterServerEvent('gcPhone:addAdministrator')
AddEventHandler('gcPhone:addAdministrator', function(number, target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local tPlayer = ESX.GetPlayerFromId(target)

	if xPlayer.getMoney() < 10000 then
		xPlayer.showNotification('~r~Nie masz wystarczająco pieniędzy przy sobie')
		return
	end

	local thisNumber = MySQL.Sync.fetchAll('SELECT * FROM user_sim WHERE number = @number', { ['@number'] = number })

	if thisNumber[1].admin1 ~= nil and thisNumber[1].admin2 ~= nil then
		xPlayer.showNotification('Ten numer posiada już ~r~maksymalną ilość~w~ administratorów')
	elseif thisNumber[1].admin1 == nil then
		MySQL.Async.execute('UPDATE user_sim SET admin1 = @admin WHERE number = @number', {
			['@number'] = number,
			['@admin'] = tPlayer.identifier
		})
		xPlayer.showNotification('~g~Nadano administratora~w~ numeru ~y~' .. number .. '~w~ dla ' .. target)
		tPlayer.showNotification('~g~Zostałeś administratorem~w~ numeru ~y~' .. number)
		xPlayer.removeMoney(10000)
	elseif thisNumber[1].admin2 == nil then
		MySQL.Async.execute('UPDATE user_sim SET admin2 = @admin WHERE number = @number', {
			['@number'] = number,
			['@admin'] = tPlayer.identifier
		})
		xPlayer.showNotification('~g~Nadano administratora~w~ numeru ~y~' .. number .. '~w~ dla ' .. target)
		tPlayer.showNotification('~g~Zostałeś administratorem~w~ numeru ~y~' .. number)
		xPlayer.removeMoney(10000)
	else
		xPlayer.showNotification('~r~Wystąpił błąd. Spróbuj jeszcze raz')
	end
end)

RegisterServerEvent('gcPhone:zastrzezSIM')
AddEventHandler('gcPhone:zastrzezSIM', function(numerek)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getMoney() >= Config.zastrzezSIM then
		xPlayer.removeMoney(Config.zastrzezSIM)
		MySQL.Async.fetchAll('SELECT * FROM user_sim WHERE number = @numerek',
		{
			['@numerek'] = numerek
		}, function(result)
			local currentUser = result[1].user
			local tPlayer = ESX.GetPlayerFromIdentifier(currentUser)
			if tPlayer then
                MySQL.Async.execute('UPDATE `user_sim` SET user = NULL, house = "Brak" WHERE `number` = @numerek', {
                    ['@numerek'] 	= numerek,
                })
                MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
                {
                    ['@identifier'] = tPlayer.identifier,
                }, function(result)
                    if result[1].phone_number == numerek then
                        TriggerClientEvent("gcPhone:myPhoneNumber",tPlayer.source,nil)
                        TriggerClientEvent("route68:UpdateNumber",tPlayer.source,nil)
                        MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
                        {
                            ['@identifier']   = tPlayer.identifier,
                            ['@phone_number'] = nil
                        })
                    end
                end)
                TriggerClientEvent('esx_inventoryhud:getOwnedSim', tPlayer.source)
			else
				MySQL.Async.execute('UPDATE `user_sim` SET user = NULL, house = "Brak" WHERE `number` = @numerek', {
					['@numerek'] 	= numerek,
				})
				MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
				{
					['@identifier'] = currentUser
				}, function(result)
					if result[1].phone_number == numerek then
						MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier',
						{
							['@identifier']   = currentUser,
							['@phone_number'] = nil
						})
					end
				end)
				MySQL.Async.fetchAll('SELECT * FROM characters WHERE identifier = @identifier',
				{
					['@identifier'] = currentUser
				}, function(result)
					if result[1].phone_number == numerek then
						MySQL.Async.execute('UPDATE characters SET phone_number = @phone_number WHERE identifier = @identifier',
						{
							['@identifier']   = currentUser,
							['@phone_number'] = nil
						})
					end
				end)
			end
		end)
		TriggerClientEvent('gcphone:komunikat', _source, '~p~Karta SIM ~g~#'..numerek..' ~p~została zastrzeżona!')
	else
		TriggerClientEvent('gcphone:komunikat', _source, '~r~Nie posiadasz wystarczająco pieniędzy')
	end 
end)

RegisterServerEvent('gcPhone:duplikatSIM')
AddEventHandler('gcPhone:duplikatSIM', function(numerek)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getMoney() >= Config.duplikatSIM then
		MySQL.Async.fetchAll('SELECT * FROM user_sim WHERE number = @number',
		{
			['number'] = numerek
		}, function(result)
			if result[1].user == nil and result[1].house == 'Brak' then
				MySQL.Async.execute('UPDATE user_sim SET user = @user WHERE number = @number',
				{
					['@user'] = xPlayer.identifier,
					['@number'] = numerek
				})
				xPlayer.removeMoney(Config.duplikatSIM)
				TriggerClientEvent('gcphone:komunikat', _source, "~p~Zapłacono za kartę: ~g~"..Config.duplikatSIM.."\n~p~Zduplikowano kartę z numerem: ~g~"..numerek)
				TriggerClientEvent('esx_inventoryhud:getOwnedSim', _source)
			else
				TriggerClientEvent('gcphone:komunikat', _source, "~p~Karta SIM ~g~#"..numerek.." ~p~nie może zostać zduplikowana ponieważ jest już aktywna")
			end
		end)
	else
		TriggerClientEvent('gcphone:komunikat', _source, '~r~Nie posiadasz wystarczająco pieniędzy')
	end
end)
