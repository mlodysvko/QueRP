ESX						= nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function sendToDiscord (name,message,color)
    local DiscordWebHook = "https://discord.com/api/webhooks/870839061831614525/A-0AhbWbuza6isSVK1aRuP4kHSPMd2mZY_vf9vhxv3k14qmp0oDn1Rqs_ZpuFOqWELZ2"

  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
          ["footer"]=  {
          ["text"]= "Wygrana w zdrapkach",
         },
      }
  }

    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('kurwachuj:wygranko1')
AddEventHandler('kurwachuj:wygranko1', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = GetPlayerName(source)
	local WygranaGotowka = 250000
	TriggerClientEvent('esx:showNotification', source, '~b~Brawo! ~g~wygrałeś '.. WygranaGotowka..'$ !')
    xPlayer.addMoney(WygranaGotowka)
	sendToDiscord (('kurwachuj:wygranko'), "Gracz [".. _source .."] " .. identifier .. "  licka gracza: " .. xPlayer.identifier .. " Wygral w zdrapce: [".. WygranaGotowka .."] ") 
	Wait(500)
end)
RegisterServerEvent('kurwachuj:wygranko2')
AddEventHandler('kurwachuj:wygranko2', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = GetPlayerName(source)
	local WygranaGotowka = 500000
	TriggerClientEvent('esx:showNotification', source, '~b~Brawo! ~g~wygrałeś '.. WygranaGotowka..'$ !')
    xPlayer.addMoney(WygranaGotowka)
	sendToDiscord (('kurwachuj:wygranko'), "Gracz [".. _source .."] " .. identifier .. "  licka gracza: " .. xPlayer.identifier .. " Wygral w zdrapce: [".. WygranaGotowka .."] ") 
	Wait(500)
end)
RegisterServerEvent('kurwachuj:wygranko3')
AddEventHandler('kurwachuj:wygranko3', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = GetPlayerName(source)
	local WygranaGotowka = 750000
	TriggerClientEvent('esx:showNotification', source, '~b~Brawo! ~g~wygrałeś '.. WygranaGotowka..'$ !')
    xPlayer.addMoney(WygranaGotowka)
	sendToDiscord (('kurwachuj:wygranko'), "Gracz [".. _source .."] " .. identifier .. "  licka gracza: " .. xPlayer.identifier .. " Wygral w zdrapce: [".. WygranaGotowka .."] ") 
	Wait(500)
end)
RegisterServerEvent('kurwachuj:wygranko4')
AddEventHandler('kurwachuj:wygranko4', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = GetPlayerName(source)
	local WygranaGotowka = 1000000
	TriggerClientEvent('esx:showNotification', source, '~b~Brawo! ~g~wygrałeś '.. WygranaGotowka..'$ !')
    xPlayer.addMoney(WygranaGotowka)
	sendToDiscord (('kurwachuj:wygranko'), "Gracz [".. _source .."] " .. identifier .. "  licka gracza: " .. xPlayer.identifier .. " Wygral w zdrapce: [".. WygranaGotowka .."] ") 
	Wait(500)
end)
ESX.RegisterUsableItem('zdrapkap', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('zdrapkap', 1)
	TriggerClientEvent("kurwachuj:zdrapuj", source)
	Wait(500)
end)