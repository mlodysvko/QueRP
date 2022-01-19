if(globalConf["SERVER"].enableGiveKey)then
    RegisterCommand('dajklucze', function(source, args, rawCommand)
        local src = source
        local identifier = GetPlayerIdentifiers(src)[1]

        if(args[1])then
            local targetId = args[1]
            local targetIdentifier = GetPlayerIdentifiers(targetId)[1]
            if(targetIdentifier)then
                if(targetIdentifier ~= identifier)then
                    if(args[2])then
                        local plate = string.lower(args[2])
                        if(owners[plate])then
                            if(owners[plate] == identifier)then
                                alreadyHas = false
                                for k, v in pairs(secondOwners) do
                                    if(k == plate)then
                                        for _, val in ipairs(v) do
                                            if(val == targetIdentifier)then
                                                alreadyHas = true
                                            end
                                        end
                                    end
                                end

                                if(not alreadyHas)then
                                    TriggerClientEvent("ls:dajklucze", targetIdentifier, plate)
                                    TriggerEvent("ls:addSecondOwner", targetIdentifier, plate)

                                    TriggerClientEvent("esx:showNotification", targetId, "You have been received the keys of vehicle " .. plate .. " by " .. GetPlayerName(src))
                                    TriggerClientEvent("esx:showNotification", src, "You gave the keys of vehicle " .. plate .. " to " .. GetPlayerName(targetId))
                                else
                                    TriggerClientEvent("esx:showNotification", src, "The target already has the keys of the vehicle")
                                    TriggerClientEvent("esx:showNotification", targetId, GetPlayerName(src) .. " tried to give you his keys, but you already had them")
                                end
                            else
                                TriggerClientEvent("esx:showNotification", src, "This is not your vehicle")
                            end
                        else
                            TriggerClientEvent("esx:showNotification", src, "The vehicle with this plate doesn't exist")
                        end
                    else
                        TriggerClientEvent("esx:showNotification", src, "Second missing argument : /givekey <id> <plate>")
                    end
                else
                    TriggerClientEvent("esx:showNotification", src, "You can't target yourself")
                end
            else
                TriggerClientEvent("esx:showNotification", src, "Player not found")
            end
        else
            TriggerClientEvent("esx:showNotification", src, 'First missing argument : /givekey <id> <plate>')
        end

        CancelEvent()
    end)
end
