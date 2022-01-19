ESX = nil
mandatAmount = nil
TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

function sendToDiscord (name,message,color)
    local DiscordWebHook = "https://discord.com/api/webhooks/863502998158966794/B_Twn3avC2CssOOZrSwnyBqhTEtUkwiuWQBY9lDMglxBGxwN184jK-UYnYmvO31Z9jJy"

  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
          ["footer"]=  {
              ["text"]= "TABLET EMS",
         },
      }
  }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('tablet_skaems:SendMessage')
AddEventHandler('tablet_skaems:SendMessage', function(target, mandatAmount, mandatReason)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local identifier = targetXPlayer.getIdentifier()
	local policjant = GetCharacterName(_source)
	local policee = policjant.." (".. sourceXPlayer.getName() ..")"
	local name = GetCharacterName(target)
	-- local imie = GetImie(target)
	-- local nazwisko = GetNazwisko(target)
	local mandat = tonumber(mandatAmount)
	targetXPlayer.removeAccountMoney('bank', mandat)
	sourceXPlayer.addAccountMoney('bank', mandat / 2)
    TriggerClientEvent('chatMessage', -1, _U('mandat'), { 147, 196, 109 }, _U('mandat_msg', name, mandat, mandatReason))
	sendToDiscord (('tablet_skaems:SendMessage'), "Gracz [".. _source .."] " .. policjant .. " " .. " wystawil fakture ems graczu ".. name .." licka gracza: ".. identifier .. " w wysokosci " .. mandat .. "$") 
end)

function GetCharacterName(source)
	-- local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	-- {
	-- 	['@identifier'] = GetPlayerIdentifiers(source)[1]
	-- })

	-- if result[1] ~= nil and result[1].firstname ~= nil and result[1].lastname ~= nil then
	-- 	return result[1].firstname .. ' ' .. result[1].lastname
	-- else
		return GetPlayerName(source)
	-- end
end
function GetImie(source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] ~= nil and result[1].firstname ~= nil then
		return result[1].firstname
	else
		return GetPlayerName(source)
	end
end
function GetNazwisko(source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
	{
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] ~= nil and result[1].lastname ~= nil then
		return result[1].lastname
	else
		return GetPlayerName(source)
	end
end