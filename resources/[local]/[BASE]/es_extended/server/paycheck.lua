--[[
ESX.StartPayCheck = function()
	function payCheck()
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local job     = xPlayer.job.grade_name
			local praca   = xPlayer.job.label
			local stopien = xPlayer.job.grade_label
			local salary  = xPlayer.job.grade_salary
			if salary > 0 then
				if job == 'unemployed' then
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenie z zasilku:~g~ '..salary..'$', 'CHAR_BANK_FLEECA', 9)
				else
					xPlayer.addAccountMoney('bank', salary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenie z pracy~y~ '..praca..' - '..stopien..':~g~ '..salary..'$', 'CHAR_BANK_FLEECA', 9)	
				end
			end
		end
		SetTimeout(Config.PaycheckInterval, payCheck)
	end
	SetTimeout(Config.PaycheckInterval, payCheck)
end
]]

function sendToDiscord (name,message,color)
    local DiscordWebHook = "https://discord.com/api/webhooks/865305204014579712/uQQ85DiGYIyCA97l-CUHdYzLf6e_UK_JHfh0NoZT1tMNwna_Lt2KjO4MhL4tEwzptvLn"

  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
          ["footer"]=  {
          ["text"]= "minutowka",
         },
      }
  }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('KeKWezzzSKAkogz')
AddEventHandler('KeKWezzzSKAkogz', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local job     = xPlayer.job.name
	local praca   = xPlayer.job.label
	local stopien = xPlayer.job.grade_label
	local salary  = xPlayer.job.grade_salary
	local hiddenjob = xPlayer.hiddenjob.name
	local hiddenpraca = xPlayer.hiddenjob.label
	local hiddensalary = xPlayer.hiddenjob.grade_salary
	local identifier = GetPlayerName(source)
	if salary > 0 then
		if job == 'unemployed' then
			xPlayer.addAccountMoney('bank', salary)
			if hiddenjob ~= 'unemployed' and hiddenjob ~= job then
				xPlayer.addAccountMoney('bank', hiddensalary)
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~Zasiłek: ~g~'..salary..'$\n~y~' .. hiddenpraca .. ':~g~ ' .. hiddensalary .. '$')
				sendToDiscord (('KeKWezzzSKAkogz'), "Gracz " .. identifier .. " dostal minutkowke licka gracza: " .. xPlayer.identifier .. " wynagrodzenie z pracy " ..salary.. " wynagrodzenie z organizacji " ..hiddensalary.. "<< Minutowka ") 
			else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~Zasiłek: ~g~'..salary..'$')
				sendToDiscord (('KeKWezzzSKAkogz'), "Gracz " .. identifier .. " dostal minutkowke licka gracza: " .. xPlayer.identifier .. " wynagrodzenie z pracy " ..salary.. " wynagrodzenie z organizacji " ..hiddensalary.. "<< Minutowka ") 
			end
		else
			xPlayer.addAccountMoney('bank', salary)
			if hiddenjob ~= 'unemployed' and hiddenjob ~= job then
				xPlayer.addAccountMoney('bank', hiddensalary)
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~'..praca..' - '..stopien..':~g~ '..salary..'$\n~y~' .. hiddenpraca .. ':~g~ ' .. hiddensalary .. '$')
				sendToDiscord (('KeKWezzzSKAkogz'), "Gracz " .. identifier .. " dostal minutkowke licka gracza: " .. xPlayer.identifier .. " wynagrodzenie z pracy " ..salary.. " wynagrodzenie z organizacji " ..hiddensalary.. "<< Minutowka ") 
			else
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~'..praca..' - '..stopien..':~g~ '..salary..'$')
				sendToDiscord (('KeKWezzzSKAkogz'), "Gracz " .. identifier .. " dostal minutkowke licka gracza: " .. xPlayer.identifier .. " wynagrodzenie z pracy " ..salary.. " wynagrodzenie z organizacji " ..hiddensalary.. "<< Minutowka ") 
			end
		end
	end
end)