Locales = {}
--[[
CreateThread(function()
	while str == nil do
		str = 'Nie istnieje, Sprawdź f8'
		str = ''
		print('Nie istnieje Locale "PL" w tym pliku lecz jest on zdefiniowany w ten sposób\n Sprawdź: '..GetCurrentResourceName())
	end
	while Locales[Config.Locale] == nil do
		Locales[Config.Locale] = ''
		Locales[Config.Locale] = 'Nie istnieje, Sprawdź f8'
		print('Nie istnieje Locale "'..Locales[Config.Locale]..'"  w tym pliku lecz jest on zdefiniowany w ten sposób\n Sprawdź: '..GetCurrentResourceName())
	end
end)]]

function _(str, ...)  -- Translate string

	if Locales[Config.Locale] ~= nil then

		if Locales[Config.Locale][str] ~= nil then
			return string.format(Locales[Config.Locale][str], ...)
		else
			return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
		end
		if Locales[Config.Locale] == nil then
			Locales[Config.Locale] = ''
		end
		if str == nil then 
			str = ''
		end
	else
		return 'Locale [' .. Config.Locale .. '] does not exist'
	end

end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(_(str, ...):gsub("^%l", string.upper))
end
