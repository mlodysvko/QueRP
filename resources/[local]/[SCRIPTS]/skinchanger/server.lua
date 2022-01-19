ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local cached = {}

RegisterServerEvent('ReturnSkin')
AddEventHandler('ReturnSkin', function(target, cb)
    local xPlayer = ESX.GetPlayerFromId(target)
    if cached[target] then
        cb(cached[target])
    else
        MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(users)
            local user, skin = users[1]
            
            if user ~= nil then
                if user.skin then
                    skin = json.decode(user.skin)
                end
                
                cb(skin)
            end
        end)
    end
end)