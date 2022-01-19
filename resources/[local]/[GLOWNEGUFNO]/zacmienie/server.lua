ESX = nil
local webhook = "https://discord.com/api/webhooks/928390178949693560/ftoEGlO5YjipF1ZC22itL7E2BT8MZQjXzOZ5CtjviIeyEZ7_48oAN-NILw-a4I9DGzDx"

local zacmienie = false

-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



ESX.RegisterCommand('zacmienie', 'admin', function(xPlayer, args, showError)

	TriggerClientEvent('ntrp_zacmienie', -1, args.czas)
	sendWebhook("Zacmienie odbędzie się za **" .. args.czas .. " minut/y!**")
	zacmienie = true

	end, true, {help = "Ustawia zacmienie", validate = true, arguments = {
	{name = 'czas', help = 'Czas do zacmienia', type = 'number'}
}})

ESX.RegisterCommand('zacmieniestop', 'admin', function(xPlayer, args, showError)

	TriggerClientEvent('ntrp_zacmieniestop', -1)
	sendWebhook("**Zacmienie zostało odwołane!**")
	zacmienie = false

	end, true, {help = "Ustawia zacmienie", validate = true
})

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	else
		SetTimeout(20000, function()
			sendWebhook("**🌞 QueRP wraca po restarcie.** \n \n\n Automatyczne Restarty: \n - 00:00 \n - 6:00 \n - 12:00 \n - 18:00 \n - 24:00 \n\n `Naciśnij F8 i połącz się za pomocą: connect querp.eu`")
		end)
	end
end)

function sendWebhook(message)
	PerformHttpRequest(
		webhook, 
		function(err, text, headers) end, 
		'POST', json.encode({
		username = "QueRP-Restart", 
		embeds = {{
			["description"] = "".. message .."",
		}}, avatar_url = "https://cdn.discordapp.com/attachments/899528875783094272/931279944548507648/Nowe_logo_V2_QUE_alfa.png"}), { ['Content-Type'] = 'application/json' 
	})
end

exports('trwaZacmienie', function()
	return zacmienie
end)

