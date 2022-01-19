local tekst1 = "Automatycznie usunięcie pojazdów nastąpi za 15 minut"
local tekst2 = "Automatycznie usunięcie pojazdów nastąpi za 10 minut"
local tekst3 = "Automatycznie usunięcie pojazdów nastąpi za 5 minut"
local tekst4 =  "Usunięto wszystkie pojazdy na mapie"


RegisterServerEvent("restart:checkreboot")
AddEventHandler('restart:checkreboot', function()
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	if date_local == '23:45:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst1)
	elseif date_local == '23:50:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst2)
	elseif date_local == '23:55:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst3)
	elseif date_local == '00:00:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst4)
		TriggerClientEvent("wld:delallveh", -1)
	elseif date_local == '03:45:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst1)
	elseif date_local == '03:50:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst2)
	elseif date_local == '03:55:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst3)
	elseif date_local == '04:00:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst4)
		TriggerClientEvent("wld:delallveh", -1)
	elseif date_local == '07:45:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst1)
	elseif date_local == '07:50:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst2)
	elseif date_local == '07:55:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst3)
	elseif date_local == '08:00:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst4)
		TriggerClientEvent("wld:delallveh", -1)
	elseif date_local == '11:45:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst1)
	elseif date_local == '11:50:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst2)
	elseif date_local == '11:55:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst3)
	elseif date_local == '12:00:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst4)
		TriggerClientEvent("wld:delallveh", -1)
	elseif date_local == '15:45:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst1)
	elseif date_local == '15:50:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst2)
	elseif date_local == '15:55:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst3)
	elseif date_local == '16:00:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst4)
		TriggerClientEvent("wld:delallveh", -1)
	elseif date_local == '18:55:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst1)
	elseif date_local == '19:50:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst2)
	elseif date_local == '19:55:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst3)
	elseif date_local == '20:00:00' then
		TriggerClientEvent('chatMessage', -1, "QueRP", {255, 0, 0}, tekst4)
		TriggerClientEvent("wld:delallveh", -1)
	end
end)

function zobaczczas()
	SetTimeout(1000, function()
		TriggerEvent('restart:checkreboot')
		zobaczczas()
	end)
end
zobaczczas()
