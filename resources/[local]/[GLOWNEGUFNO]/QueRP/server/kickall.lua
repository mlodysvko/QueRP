ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand('kickall', function(source, args, rawCommand)
    kickPl()
end, true)

function kickPl ()
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        xPlayer.kick("🏝 QueRP: Zacmienie wyspy zapraszamy za chwile!")
        sendToDiscord("https://discord.com/api/webhooks/846834509135085608/ltvUJOowFDVzetC2icO1dcLL5w1LTiOsw9JyVkXGGUI5qfenE9QUUsmQ_pgr7TQgg3VF", "Kickall", "Wyrzucono wszystkich poprawnie!", 56108)
    end
end

function sendToDiscord (canal, name, message, color)
local DiscordWebHook = canal
local embeds = {
    {
        ["title"]= "Some text",
        ["type"]= "rich",
        ["color"] = color,
        ["description"]= message,
        ["footer"]= {
        ["text"]= "Footer",
        ["icon_url"]= "https://i.imgur.com/70Y8AF4.png",
       },
    }
}

  if message == nil or message == '' then return FALSE end
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end
