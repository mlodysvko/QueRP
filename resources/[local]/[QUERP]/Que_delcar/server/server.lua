--------------------------------------
------Created By Whit3Xlightning------
--https://github.com/Whit3XLightning--
--------------------------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand(Config.commandName, function(source, args, rawCommand) TriggerClientEvent("wld:delallveh", -1) end, Config.restricCommand)