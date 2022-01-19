local rob = false
local robbers = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('esx_holdup_bank:toofar')
AddEventHandler('esx_holdup_bank:toofar', function(robb)
    local source = source
    local xPlayers = ESX.GetPlayers()
    rob = false
    for i=1, #xPlayers, 1 do
         local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
         if xPlayer.job.name == 'police' then
            TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled_at') .. Banks[robb].nameofbank)
            TriggerClientEvent('esx_holdup_bank:killblip', xPlayers[i])
        end
    end
    if(robbers[source])then
        TriggerClientEvent('esx_holdup_bank:toofarlocal', source)
        robbers[source] = nil
        TriggerClientEvent('esx:showNotification', source, _U('robbery_has_cancelled') .. Banks[robb].nameofbank)
    end
end)


RegisterServerEvent('esx_holdup_bank:welost')
AddEventHandler('esx_holdup_bank:welost', function(robb)
    local source = source
    local xPlayers = ESX.GetPlayers()
    rob = false
    for i=1, #xPlayers, 1 do
         local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
         if xPlayer.job.name == 'police' then
            TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled_at') .. Banks[robb].nameofbank)
            TriggerClientEvent('esx_holdup_bank:killblip', xPlayers[i])
        end
    end

    Banks[robb].lastrobbed = os.time()
end)

RegisterServerEvent('canwerob')
AddEventHandler('canwerob', function(robb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local bank = Banks[robb]
    local drill = xPlayer.getInventoryItem('drill')
    local xPlayers = ESX.GetPlayers()
    if (os.time() - bank.lastrobbed) < Config.TimerBeforeNewRob and bank.lastrobbed ~= 0 then
        TriggerClientEvent('esx:showNotification', source, _U('already_robbed') .. (Config.TimerBeforeNewRob - (os.time() - bank.lastrobbed)) .. _U('seconds'))
        return
    else
        if drill.count >= 1 then
            local cops = 0
            for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer.job.name == 'police' then
                    cops = cops + 1
                end
            end
            if(cops >= Config.PoliceNumberRequired)then
                TriggerClientEvent('esx:showNotification', source, _U('alarm_triggered'))
                TriggerClientEvent('wecanrob', source, robb) 
                xPlayer.removeInventoryItem('drill', 1)
            else
                TriggerClientEvent('esx:showNotification', source, _U('min_police') .. Config.PoliceNumberRequired .. _U('in_city'))
            end
        else
            TriggerClientEvent('esx:showNotification', source, ('~r~Nie masz wiertła'))
        end
    end
end)


RegisterServerEvent('policeblip')
AddEventHandler('policeblip', function(robb)
    local source = source
    local xPlayers = ESX.GetPlayers()
    local bank = Banks[robb]
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('esx:showNotification', xPlayers[i], _U('rob_in_prog') .. bank.nameofbank)
            TriggerClientEvent('esx_holdup_bank:setblip', xPlayers[i], Banks[robb].position)
       end
   end
end)

RegisterServerEvent('esx_holdup_bank:rob')
AddEventHandler('esx_holdup_bank:rob', function(robb)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    if Banks[robb] then
        local bank = Banks[robb]
        if rob == false then
              if 2 > 1 then
                rob = true
                TriggerClientEvent('esx:showNotification', source, _U('alarm_triggered'))
                TriggerClientEvent('esx_holdup_bank:currentlyrobbing', source, robb)
                TriggerClientEvent('esx_holdup_bank:starttimer', source)
                Banks[robb].lastrobbed = os.time()
                robbers[source] = robb
                local savedSource = source
                SetTimeout(bank.secondsRemaining*1000, function()
                    if(robbers[savedSource])then
                        rob = false
                        TriggerClientEvent('esx_holdup_bank:robberycomplete', savedSource, job)
                        if(xPlayer)then
                            TriggerClientEvent('koniecnapadu', source)
                            Wait(5200)
                            xPlayer.addAccountMoney('black_money', bank.reward / 2)
                            TriggerClientEvent('esx:showNotification', source, ('~w~Zebrales~r~ '..bank.reward / 2 ..'$ ~w~zostalo jeszcze ~r~'.. bank.reward / 2 ..'$~w~ do wzięcia'))
                            Wait(5200)
                            xPlayer.addAccountMoney('black_money', bank.reward / 2)
                            TriggerClientEvent('esx:showNotification', source, ('~w~Zebrales~r~ '..bank.reward / 2 ..'.~w~ Zebrales w sumie ~r~'.. bank.reward..'$'))
							local xPlayers = ESX.GetPlayers()
                            for i=1, #xPlayers, 1 do
                                 local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                                 if xPlayer.job.name == 'police' then
									TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_complete_at') .. bank.nameofbank)
									TriggerClientEvent('esx_holdup_bank:killblip', xPlayers[i])
                                end
                            end
                        end
                    end
                end)
         else
            return
       end
        else
            TriggerClientEvent('esx:showNotification', source, _U('robbery_already'))
        end
    end
end)