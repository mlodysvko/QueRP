local Log = 'https://discord.com/api/webhooks/915625654769287218/DOQJm71Dp1QsI1PZctgAM61-5QCFp7XX3ci-UU58MZ511MESv6eKNugueZ_kR1Z5o7Fc'

RegisterServerEvent('Fuckmedaddy:log')
AddEventHandler('Fuckmedaddy:log', function(pedId)
    local _source = source
    local name = GetPlayerName(_source)
    local targetName = GetPlayerName(pedId)
    PerformHttpRequest(Log, function(err, text, headers) end, 'POST', json.encode({embeds={{title="__**Aim Logi**__",description="\nPlayer name: "..name.. "`[".._source.."]`\nIs aiming: "..targetName.." `["..pedId.."]`",color=16711680}}}), { ['Content-Type'] = 'application/json' })
end)

