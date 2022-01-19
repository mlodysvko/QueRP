ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local Text               = {}
local BanList            = {}
local BanListLoad        = false
local BanListHistory     = {}
local BanListHistoryLoad = false
if Config.Lang == "en" then 
	Text = Config.TextEn 
else 
	print("FIveM-BanSql : Invalid Config.Lang") 
end

CreateThread(function()
	while true do
		Wait(1000)
        if BanListLoad == false then
			loadBanList()
			if BanList ~= {} then
				print(Text.banlistloaded)
				BanListLoad = true
			else
				print(Text.starterror)
			end
		end
		if BanListHistoryLoad == false then
			loadBanListHistory()
            if BanListHistory ~= {} then
				print(Text.historyloaded)
				BanListHistoryLoad = true
			else
				print(Text.starterror)
			end
		end
	end
end)

CreateThread(function()
	while Config.MultiServerSync do
		Wait(30000)
		MySQL.Async.fetchAll(
		'SELECT * FROM banlist',
		{},
		function (data)
			if #data ~= #BanList then
			  BanList = {}

			  for i=1, #data, 1 do
				table.insert(BanList, {
					license    = data[i].license,
					identifier = data[i].identifier,
					liveid     = data[i].liveid,
					xblid      = data[i].xblid,
					discord    = data[i].discord,
					reason     = data[i].reason,
					added      = data[i].added,
					expiration = data[i].expiration,
					permanent  = data[i].permanent
				  })
			  end
			loadBanListHistory()
			TriggerClientEvent('BanSql:Respond', -1)
			end
		end
		)
	end
end)

function DiscordHookreload(hook,message,color)
    local msg19 = 'https://discord.com/api/webhooks/924476283839213588/TaxM9LgjjPg1dYhxz-Mc5KQ-k45d9M3vliTvEr0y4jGFtJ6yAt5P4XJPyLcAeAknFK77'
    local embeds = {
                {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
				["text"] = 'QueRP'
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(msg19, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end


--TriggerEvent('es:addGroupCommand', 'sqlbanreload', Config.permission, function (source)
RegisterCommand('sqlbanreload', function(source, id, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'moderator') then
		local xPlayer = ESX.GetPlayerFromId(source)
		local steamid = xPlayer.identifier
		local name = GetPlayerName(source)
		wiadomosc = name.." | BANY \n[RELOAD BAN LISTY WYKONAŁ ADMIN]: \n[ID: "..source.." | Nazwa: "..name.." | SteamID: "..steamid.." ]" 
		DiscordHookreload('QueRP.pl', wiadomosc, 11750815)	
		BanListLoad        = false
		BanListHistoryLoad = false
		Wait(5000)
		if BanListLoad == true then
			TriggerEvent('bansql:sendMessage', source, Text.banlistloaded)
			if BanListHistoryLoad == true then
				TriggerEvent('bansql:sendMessage', source, Text.historyloaded)	
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.loaderror)
		end
	else
		xPlayer.showNotification('Nie posiadasz permisji')
	end
end, false)

RegisterCommand('sqlbanhistory', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.group == 'best' or xPlayer.group == 'superadmin') then
			if args[1] and BanListHistory then
			local nombre = (tonumber(args[1]))
			local name   = table.concat(args, " ",1)
			if name ~= "" then

					if nombre and nombre > 0 then
							local expiration = BanListHistory[nombre].expiration
							local timeat     = BanListHistory[nombre].timeat
							local calcul1    = expiration - timeat
							local calcul2    = calcul1 / 86400
							local calcul2 	 = math.ceil(calcul2)
							local resultat   = tostring(BanListHistory[nombre].targetplayername.." , "..BanListHistory[nombre].sourceplayername.." , "..BanListHistory[nombre].reason.." , "..calcul2..Text.day.." , "..BanListHistory[nombre].added)
							
							TriggerEvent('bansql:sendMessage', source, (nombre .." : ".. resultat))
					else
							for i = 1, #BanListHistory, 1 do
								if (tostring(BanListHistory[i].targetplayername)) == tostring(name) then
									local expiration = BanListHistory[i].expiration
									local timeat     = BanListHistory[i].timeat
									local calcul1    = expiration - timeat
									local calcul2    = calcul1 / 86400
									local calcul2 	 = math.ceil(calcul2)					
									local resultat   = tostring(BanListHistory[i].targetplayername.." , "..BanListHistory[i].sourceplayername.." , "..BanListHistory[i].reason.." , "..calcul2..Text.day.." , "..BanListHistory[nombre].added)

									TriggerEvent('bansql:sendMessage', source, (i .." : ".. resultat))
								end
							end
					end
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidname)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.cmdhistory)
		end
	else
		xPlayer.showNotification('Nie posiadasz permisji')
	end
end, false)
RegisterCommand('sqlunban', function(source, args, user)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if source ~= 0 then
		if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'moderator') then
			if args[1] then
				local target = table.concat(args, " ")
				MySQL.Async.fetchAll('SELECT * FROM banlist WHERE targetplayername like @playername', 
				{
					['@playername'] = ("%"..target.."%")
				}, function(data)
					if data[1] then
						if #data > 1 then
							TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
							for i=1, #data, 1 do
								TriggerEvent('bansql:sendMessage', source, data[i].targetplayername)
							end
						else
							MySQL.Async.execute(
							'DELETE FROM banlist WHERE targetplayername = @name',
							{
							['@name']  = data[1].targetplayername
							},
								function ()
								loadBanList()
								if Config.EnableDiscordLink then
									local sourceplayername = GetPlayerName(source)
									local message = (data[1].targetplayername .. Text.isunban .." ".. Text.by .." ".. sourceplayername)
									sendToDiscord(Config.webhookunban, message)
								end
								TriggerEvent('bansql:sendMessage', source, data[1].targetplayername .. Text.isunban)
							end)
						end
					else
						TriggerEvent('bansql:sendMessage', source, Text.invalidname)
					end

				end)
			else
				TriggerEvent('bansql:sendMessage', source, Text.cmdunban)
			end
		else
			xPlayer.showNotification('Nie posiadasz permisji!')
		end
	elseif source == 0 then
			if args[1] then
				local target = table.concat(args, " ")
				MySQL.Async.fetchAll('SELECT * FROM banlist WHERE targetplayername like @playername', 
				{
					['@playername'] = ("%"..target.."%")
				}, function(data)
					if data[1] then
						if #data > 1 then
							TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
							for i=1, #data, 1 do
								TriggerEvent('bansql:sendMessage', source, data[i].targetplayername)
							end
						else
							MySQL.Async.execute(
							'DELETE FROM banlist WHERE targetplayername = @name',
							{
							['@name']  = data[1].targetplayername
							},
								function ()
								loadBanList()
								if Config.EnableDiscordLink then
									local sourceplayername = GetPlayerName(source)
									local message = (data[1].targetplayername .. Text.isunban .." ".. Text.by .." ".. sourceplayername)
									sendToDiscord(Config.webhookunban, message)
								end
								TriggerEvent('bansql:sendMessage', source, data[1].targetplayername .. Text.isunban)
							end)
						end
					else
						TriggerEvent('bansql:sendMessage', source, Text.invalidname)
					end

				end)
			else
				TriggerEvent('bansql:sendMessage', source, Text.cmdunban)
			end
	end
end, false)

RegisterCommand('sqlban', function(source, args, user)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'moderator') then
	local license,identifier,liveid,xblid,discord
	local target    = tonumber(args[1])
	local duree     = tonumber(args[2])
	local reason    = table.concat(args, " ",3)

		if args[1] then		
			if reason == "" then
				reason = Text.noreason
			end
			if target and target > 0 then
				local ping = GetPlayerPing(target)
			
				if ping and ping > 0 then
					if duree and duree < 365 then
						local sourceplayername = GetPlayerName(source)
						local targetplayername = GetPlayerName(target)
							for k,v in ipairs(GetPlayerIdentifiers(target))do
								if string.sub(v, 1, string.len("license:")) == "license:" then
									license = v
								elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
									identifier = v
								elseif string.sub(v, 1, string.len("live:")) == "live:" then
									liveid = v
								elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
									xblid  = v
								elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
									discord = v
								end
							end
							for _, foundID in ipairs(GetPlayerIdentifiers(source)) do
								if string.match(foundID, "license:") then
									licenserc = string.sub(foundID, 9)
							  elseif string.match(foundID, "discord:") then
								discordid = string.sub(foundID, 9)
								end
							end
						if duree > 0 then
							ban(source,license,identifier,liveid,xblid,discord,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
							DropPlayer(target, Text.yourban .. reason)
							local banroom_embed = 
							{
								{
									["title"]= "QueRP",
									["color"] = "1242520",
									["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
									["fields"] = {
										{
											["name"]= "Osoba Zbanowana",
											["value"]= targetplayername,
											["inline"] = true
										},
										{
											["name"]= "Osoba Banujaca",
											["value"]= '<@'..discordid..'>',
											["inline"] = false
										},                      
							
										{
										  ["name"]= "Długość Bana",
										  ["value"]= duree..' Dni',
										  ["inline"] = false
									  },
										{
											["name"]= "Powód Bana",
											["value"]= reason,
											["inline"] = false
										},                   
									},
									["footer"] = {
										["text"] = "QueRP Banroom | mlodyszef",
									},
								},
							}
							PerformHttpRequest("https://discord.com/api/webhooks/930124795855646810/1zVjQ78WLvCA9b5neDiixs5XtUi8ciQ0Bs7t3kvcLkXLfBm4oOUHVocZFCIX9vb3zCu1", function(err, text, headers) end, 'POST', json.encode({username = "QueRP", embeds = banroom_embed}), { ['Content-Type'] = 'application/json' })
				  
						else
							ban(source,license,identifier,liveid,xblid,discord,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
							DropPlayer(target, Text.yourpermban .. reason)
							local banroom_embed = 
							{
								{
									["title"]= "QueRP",
									["color"] = "1242520",
									["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
									["fields"] = {
										{
											["name"]= "Osoba Zbanowana",
											["value"]= targetplayername,
											["inline"] = true
										},
										{
											["name"]= "Osoba Banujaca",
											["value"]= '<@'..discordid..'>',
											["inline"] = false
										},                      
							
										{
										  ["name"]= "Długość Bana",
										  ["value"]= 'PERM',
										  ["inline"] = false
									  },
										{
											["name"]= "Powód Bana",
											["value"]= reason,
											["inline"] = false
										},                   
									},
									["footer"] = {
										["text"] = "QueRP Banroom | mlodyszef",
									},
								},
							}
							PerformHttpRequest("https://discord.com/api/webhooks/930124795855646810/1zVjQ78WLvCA9b5neDiixs5XtUi8ciQ0Bs7t3kvcLkXLfBm4oOUHVocZFCIX9vb3zCu1", function(err, text, headers) end, 'POST', json.encode({username = "QueRP", embeds = banroom_embed}), { ['Content-Type'] = 'application/json' })
				  
						end
					
					else
						TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
					end	
				else
					TriggerEvent('bansql:sendMessage', source, Text.invalidid)
				end
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidid)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.cmdban)
		end
	else
		xPlayer.showNotifcation('Nie posiadasz permisji!')
	end
end, false)

function Webhookbanroom(hook,message,color)
    local embeds = {
                {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
				["text"] = 'QueRP'
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest('https://discord.com/api/webhooks/930124795855646810/1zVjQ78WLvCA9b5neDiixs5XtUi8ciQ0Bs7t3kvcLkXLfBm4oOUHVocZFCIX9vb3zCu1', function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('BanSql:ICheat')
AddEventHandler('BanSql:ICheat', function(reason,servertarget)
	local license,identifier,liveid,xblid,discord,target
	local duree     = 0
	local reason    = reason

	if not reason then reason = "Auto Anti-Cheat" end

	if tostring(source) == "" then
		target = tonumber(servertarget)
	else
		target = source
	end

	if target and target > 0 then
		local ping = GetPlayerPing(target)
	
		if ping and ping > 0 then
			if duree and duree < 365 then
				local sourceplayername = "Anti-Cheat-System"
				local targetplayername = GetPlayerName(target)
					for k,v in ipairs(GetPlayerIdentifiers(target))do
						if string.sub(v, 1, string.len("license:")) == "license:" then
							license = v
						elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
							identifier = v
						elseif string.sub(v, 1, string.len("live:")) == "live:" then
							liveid = v
						elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
							xblid  = v
						elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
							discord = v
						end
					end
			
					for _, foundID in ipairs(GetPlayerIdentifiers(source)) do
						if string.match(foundID, "license:") then
							licenserc = string.sub(foundID, 9)
					  elseif string.match(foundID, "discord:") then
						discordid = string.sub(foundID, 9)
						end
					end
				if duree > 0 then
					ban(source,license,identifier,liveid,xblid,discord,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
					DropPlayer(target, Text.yourban .. reason)
					local banroom_embed = 
					{
						{
							["title"]= "QueRP",
							["color"] = "1242520",
							["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
							["fields"] = {
								{
									["name"]= "Osoba Zbanowana",
									["value"]= targetplayername,
									["inline"] = true
								},
								{
									["name"]= "Osoba Banujaca",
									["value"]= '<@'..discordid..'>',
									["inline"] = false
								},                      
					
								{
								  ["name"]= "Długość Bana",
								  ["value"]= duree..' Dni',
								  ["inline"] = false
							  },
								{
									["name"]= "Powód Bana",
									["value"]= reason,
									["inline"] = false
								},                   
							},
							["footer"] = {
								["text"] = "QueRP Banroom | mlodyszef",
							},
						},
					}
					PerformHttpRequest("https://discord.com/api/webhooks/930124795855646810/1zVjQ78WLvCA9b5neDiixs5XtUi8ciQ0Bs7t3kvcLkXLfBm4oOUHVocZFCIX9vb3zCu1", function(err, text, headers) end, 'POST', json.encode({username = "QueRP", embeds = banroom_embed}), { ['Content-Type'] = 'application/json' })
		  
				else
					ban(source,license,identifier,liveid,xblid,discord,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
					DropPlayer(target, Text.yourpermban .. reason)
					local banroom_embed = 
					{
						{
							["title"]= "QueRP",
							["color"] = "1242520",
							["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
							["fields"] = {
								{
									["name"]= "Osoba Zbanowana",
									["value"]= targetplayername,
									["inline"] = true
								},
								{
									["name"]= "Osoba Banujaca",
									["value"]= '<@'..discordid..'>',
									["inline"] = false
								},                      
					
								{
								  ["name"]= "Długość Bana",
								  ["value"]= 'PERM',
								  ["inline"] = false
							  },
								{
									["name"]= "Powód Bana",
									["value"]= reason,
									["inline"] = false
								},                   
							},
							["footer"] = {
								["text"] = "QueRP Banroom | mlodyszef",
							},
						},
					}
					PerformHttpRequest("https://discord.com/api/webhooks/930124795855646810/1zVjQ78WLvCA9b5neDiixs5XtUi8ciQ0Bs7t3kvcLkXLfBm4oOUHVocZFCIX9vb3zCu1", function(err, text, headers) end, 'POST', json.encode({username = "QueRP", embeds = banroom_embed}), { ['Content-Type'] = 'application/json' })
		  
				end
			
			else
				print("BanSql Error : Auto-Cheat-Ban time invalid.")
			end	
		else
			print("BanSql Error : Auto-Cheat-Ban target are not online.")
		end
	else
		print("BanSql Error : Auto-Cheat-Ban have recive invalid id.")
	end
end)

RegisterCommand('sqlsearch', function(source, args, user)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if source ~= 0 then
		if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'moderator') then
			if args ~= "" then
				local target = table.concat(args, " ")
				if target ~= "" then
					MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE playername like @playername', 
					{
						['@playername'] = ("%"..target.."%")
					}, function(data)
						if data[1] then
							if #data < 50 then
								for i=1, #data, 1 do
									TriggerEvent('bansql:sendMessage', source, data[i].id.." "..data[i].playername)
								end
							else
								TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
							end
						else
							TriggerEvent('bansql:sendMessage', source, Text.invalidname)
						end
					end)
				else
					TriggerEvent('bansql:sendMessage', source, Text.invalidname)
				end
			else
				TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
			end
		else
			xPlayer.showNotification('Nie posiadasz permisji!')
		end
	elseif source == 0 then 
		if args ~= "" then
			local target = table.concat(args, " ")
			if target ~= "" then
				MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE playername like @playername', 
				{
					['@playername'] = ("%"..target.."%")
				}, function(data)
					if data[1] then
						if #data < 50 then
							for i=1, #data, 1 do
								TriggerEvent('bansql:sendMessage', source, data[i].id.." "..data[i].playername)
							end
						else
							TriggerEvent('bansql:sendMessage', source, Text.toomanyresult)
						end
					else
						TriggerEvent('bansql:sendMessage', source, Text.invalidname)
					end
				end)
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidname)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
		end
	end
end, false)
RegisterCommand('sqlbanoffline', function(source, args, user)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'moderator') then
		if args ~= "" then
			local target           = tonumber(args[1])
			local duree            = tonumber(args[2])
			local reason           = table.concat(args, " ",3)
			local sourceplayername = GetPlayerName(source)

			if duree ~= "" then
				if target ~= "" then
					MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE id = @id', 
					{
						['@id'] = target
					}, function(data)
						if data[1] then
							if duree and duree < 365 then
								if reason == "" then
									reason = Text.noreason
								end
								if duree > 0 then --Here if not perm ban
									ban(source,data[1].license,data[1].identifier,data[1].liveid,data[1].xblid,data[1].discord,data[1].playername,sourceplayername,duree,reason,0) --Timed ban here
								else --Here if perm ban
									ban(source,data[1].license,data[1].identifier,data[1].liveid,data[1].xblid,data[1].discord,data[1].playername,sourceplayername,duree,reason,1) --Perm ban here
								end
							else
								TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
							end
						else
							TriggerEvent('bansql:sendMessage', source, Text.invalidid)
						end
					end)
				else
					TriggerEvent('bansql:sendMessage', source, Text.invalidname)
				end
			else
				TriggerEvent('bansql:sendMessage', source, Text.invalidtime)
				TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
			end
		else
			TriggerEvent('bansql:sendMessage', source, Text.cmdbanoff)
		end
	else
		xPlayer.showNotification('Nie posiadasz permisji')
	end
end, false)
AddEventHandler('bansql:sendMessage', function(source, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1Banlist ', message } } )
	else
		print('SqlBan: ' .. message)
	end
end)

AddEventHandler('playerConnecting', function (playerName,setKickReason)
	local license,steamID,liveid,xblid,discord  = "n/a","n/a","n/a","n/a","n/a"

	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		end
	end

	--Si Banlist pas chargée
	if (Banlist == {}) then
		Citizen.Wait(1000)
	end

    if steamID == "n/a" and Config.ForceSteam then
		setKickReason(Text.invalidsteam)
		CancelEvent()
    end

	for i = 1, #BanList, 1 do
		if 
			  ((tostring(BanList[i].license)) == tostring(license) 
			or (tostring(BanList[i].identifier)) == tostring(steamID) 
			or (tostring(BanList[i].liveid)) == tostring(liveid) 
			or (tostring(BanList[i].xblid)) == tostring(xblid) 
			or (tostring(BanList[i].discord)) == tostring(discord)) 
		then

			if (tonumber(BanList[i].permanent)) == 1 then

				setKickReason(Text.yourpermban .. BanList[i].reason)
				CancelEvent()
				break

			elseif (tonumber(BanList[i].expiration)) > os.time() then

				local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = (day - math.floor(day)) * 24
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day ..txthrs .. Text.hour ..txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = tempsrestant / 60
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				elseif tempsrestant < 60 then
					local txtday     = 0
					local txthrs     = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
						CancelEvent()
						break
				end

			elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

				deletebanned(license)
				break
			end
		end
	end
end)

AddEventHandler('esx:playerLoaded',function(source)
	CreateThread(function()
	Wait(5000)
		local license,steamID,liveid,xblid,discord
		local playername = GetPlayerName(source)

		for k,v in ipairs(GetPlayerIdentifiers(source))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			end
		end

		MySQL.Async.fetchAll('SELECT * FROM `baninfo` WHERE `license` = @license', {
			['@license'] = license
		}, function(data)
		local found = false
			for i=1, #data, 1 do
				if data[i].license == license then
					found = true
				end
			end
			if not found then
				MySQL.Async.execute('INSERT INTO baninfo (license,identifier,liveid,xblid,discord,playername) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playername)', 
					{ 
					['@license']    = license,
					['@identifier'] = steamID,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playername'] = playername
					},
					function ()
				end)
			else
				MySQL.Async.execute('UPDATE `baninfo` SET `identifier` = @identifier, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playername` = @playername WHERE `license` = @license', 
					{ 
					['@license']    = license,
					['@identifier'] = steamID,
					['@liveid']     = liveid,
					['@xblid']      = xblid,
					['@discord']    = discord,
					['@playername'] = playername
					},
					function ()
				end)
			end
		end)
		if Config.MultiServerSync then
			doublecheck(source)
		end
	end)
end)


RegisterServerEvent('BanSql:CheckMe')
AddEventHandler('BanSql:CheckMe', function()
	doublecheck(source)
end)


function sendToDiscord(canal,message)
	local DiscordWebHook = canal
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

function ban(source,license,identifier,liveid,xblid,discord,targetplayername,sourceplayername,duree,reason,permanent)
--calcul total expiration (en secondes)
	local expiration = duree * 86400
	local timeat     = os.time()
	local added      = os.date()

	if expiration < os.time() then
		expiration = os.time()+expiration
	end
	
		table.insert(BanList, {
			license    = license,
			identifier = identifier,
			liveid     = liveid,
			xblid      = xblid,
			discord    = discord,
			reason     = reason,
			expiration = expiration,
			permanent  = permanent
          })

		MySQL.Async.execute(
                'INSERT INTO banlist (license,identifier,liveid,xblid,discord,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                { 
				['@license']          = license,
				['@identifier']       = identifier,
				['@liveid']           = liveid,
				['@xblid']            = xblid,
				['@discord']          = discord,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = expiration,
				['@timeat']           = timeat,
				['@permanent']        = permanent,
				},
				function ()
		end)

		if permanent == 0 then
			TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.during .. duree .. Text.forr .. reason))
		else
			TriggerEvent('bansql:sendMessage', source, (Text.youban .. targetplayername .. Text.permban .. reason))
		end

		if Config.EnableDiscordLink then
			local license1,identifier1,liveid1,xblid1,discord1,targetplayername1,sourceplayername1,message
			if not license          then license1          = "N/A" else license1          = license          end
			if not identifier       then identifier1       = "N/A" else identifier1       = identifier       end
			if not liveid           then liveid1           = "N/A" else liveid1           = liveid           end
			if not xblid            then xblid1            = "N/A" else xblid1            = xblid           end
			if not discord          then discord1          = "N/A" else discord1          = discord          end
			if not targetplayername then targetplayername1 = "N/A" else targetplayername1 = targetplayername end
			if not sourceplayername then sourceplayername1 = "N/A" else sourceplayername1 = sourceplayername end
			if permanent == 0 then
				message = (targetplayername1..Text.isban.." "..duree..Text.forr..reason.." "..Text.by.." "..sourceplayername1.."```"..identifier1.."\n"..license1.."\n"..liveid1.."\n"..xblid1.."\n"..discord1.."```")
			else
				message = (targetplayername1..Text.isban.." "..Text.permban..reason.." "..Text.by.." "..sourceplayername1.."```"..identifier1.."\n"..license1.."\n"..liveid1.."\n"..xblid1.."\n"..discord1.."```")
			end
			sendToDiscord(Config.webhookban, message)
		end

		MySQL.Async.execute(
                'INSERT INTO banlisthistory (license,identifier,liveid,xblid,discord,targetplayername,sourceplayername,reason,added,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@targetplayername,@sourceplayername,@reason,@added,@expiration,@timeat,@permanent)',
                { 
				['@license']          = license,
				['@identifier']       = identifier,
				['@liveid']           = liveid,
				['@xblid']            = xblid,
				['@discord']          = discord,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@added']            = added,
				['@expiration']       = expiration,
				['@timeat']           = timeat,
				['@permanent']        = permanent,
				},
				function ()
		end)
		
		BanListHistoryLoad = false
end

function loadBanList()
	MySQL.Async.fetchAll(
		'SELECT * FROM banlist',
		{},
		function (data)
		  BanList = {}

		  for i=1, #data, 1 do
			table.insert(BanList, {
				license    = data[i].license,
				identifier = data[i].identifier,
				liveid     = data[i].liveid,
				xblid      = data[i].xblid,
				discord    = data[i].discord,
				reason     = data[i].reason,
				expiration = data[i].expiration,
				permanent  = data[i].permanent
			  })
		  end
    end)
end

function loadBanListHistory()
	MySQL.Async.fetchAll(
		'SELECT * FROM banlisthistory',
		{},
		function (data)
		  BanListHistory = {}

		  for i=1, #data, 1 do
			table.insert(BanListHistory, {
				license          = data[i].license,
				identifier       = data[i].identifier,
				liveid           = data[i].liveid,
				xblid            = data[i].xblid,
				discord          = data[i].discord,
				targetplayername = data[i].targetplayername,
				sourceplayername = data[i].sourceplayername,
				reason           = data[i].reason,
				added            = data[i].added,
				expiration       = data[i].expiration,
				permanent        = data[i].permanent,
				timeat           = data[i].timeat
			  })
		  end
    end)
end

function deletebanned(license) 
	MySQL.Async.execute(
		'DELETE FROM banlist WHERE license=@license',
		{
		  ['@license']  = license
		},
		function ()
			loadBanList()
	end)
end

function doublecheck(player)
	if GetPlayerIdentifiers(player) then
		local license,steamID,liveid,xblid,discord  = "n/a","n/a","n/a","n/a","n/a"

		for k,v in ipairs(GetPlayerIdentifiers(player))do
			if string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			end
		end

		for i = 1, #BanList, 1 do
			if 
				  ((tostring(BanList[i].license)) == tostring(license) 
				or (tostring(BanList[i].identifier)) == tostring(steamID) 
				or (tostring(BanList[i].liveid)) == tostring(liveid) 
				or (tostring(BanList[i].xblid)) == tostring(xblid) 
				or (tostring(BanList[i].discord)) == tostring(discord))
			then

				if (tonumber(BanList[i].permanent)) == 1 then
					DropPlayer(player, Text.yourban .. BanList[i].reason)
					break

				elseif (tonumber(BanList[i].expiration)) > os.time() then

					local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
					if tempsrestant > 0 then
						DropPlayer(player, Text.yourban .. BanList[i].reason)
						break
					end

				elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

					deletebanned(license)
					break

				end
			end
		end
	end
end
