TextHeight = GetTextScaleHeight(Config.Scale, Config.Font)
TitleTextHeight = GetTextScaleHeight(Config.TitleScale, Config.Font)
SubjectTextHeight = GetTextScaleHeight(Config.SubjectScale, Config.Font)

function GetCharacterCount(str)
    local i = 0
    for c in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do
        i = i + 1
    end

    return i
end

function GetLineCount(Text, X, Y, X1, X2, Scale)
    SetTextFont(Config.Font)
    SetTextScale(Scale, Scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextWrap(X1, X2)

    BeginTextCommandLineCount("STRING")

    local chars = GetCharacterCount(Text)
    if chars < 100 then
        AddTextComponentSubstringPlayerName(Text)
    else
        local j = (chars % 100 == 0) and chars / 100 or (chars / 100) + 1
        for i = 0, j do
            AddTextComponentSubstringPlayerName(string.sub(Text, i * 100, (i * 100) + 100))
        end
    end

    return EndTextCommandGetLineCount(X, Y)
end

function GetMessageHeight(Text, X, Y)
	if not Text then
		return 0
	end

    local count = GetLineCount(Text,
        X,
        Y,
        (Config.Positions[Config.Position].x - (Config.Width / 2)) + Config.Padding, 
        (Config.Positions[Config.Position].x + (Config.Width / 2)) - Config.Padding,
		Config.Scale
    ) 
    return (TextHeight * count) + (Config.Padding * 2), count
end

function RenderText(Text, X, Y, A, X1, X2, Scale)
	if not Text then
		return
	end

    SetTextWrap(X1, X2)
    SetTextFont(Config.Font)
    SetTextProportional(true)
    SetTextScale(Scale, Scale)
    SetTextColour(255, 255, 255, A)
    SetTextDropShadow(0, 0, 0, 0, A)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, A)
    SetTextOutline()

    SetTextEntry("STRING")
    AddTextComponentSubstringPlayerName(Text)
    DrawText(X, Y)
end