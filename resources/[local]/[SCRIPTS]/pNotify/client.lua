--[ FeedM - edited by szymczakovv & elfeedo ]--
-- Name: FeedM-Reworked
-- Author: szymczakovv#1937, elfeedoo#6093
-- Date: 05/01/2021
-- Version: 0.1.6



local MESSAGES    = {}
local WAITTIME    = 200
local COUNTER     = 1
local CANQUEUE    = Config.Queue > 0
local QUEUE       = 0
local QUEUED      = {}
local POSITION    = Config.Positions[Config.Position]
local TOP         = string.match(Config.Position, "top") or POSITION.y < 0.5
local HALTED      = false


--====================================================================================================================
--                                                    THREADS                                                      --
--====================================================================================================================

function InitThreads()

    --==================================================================================
    -- MAIN RENDER THREAD
    --==================================================================================
    Citizen.CreateThread(function()
		RequestStreamedTextureDict('CHAR_BANK_MAZE')
		while not HasStreamedTextureDictLoaded('CHAR_BANK_MAZE') do
			Citizen.Wait(0)
		end
		RequestStreamedTextureDict('police')
		while not HasStreamedTextureDictLoaded('police') do
			Citizen.Wait(0)
		end
		RequestStreamedTextureDict('ems')
		while not HasStreamedTextureDictLoaded('ems') do
			Citizen.Wait(0)
		end
		RequestStreamedTextureDict('taxi')
		while not HasStreamedTextureDictLoaded('taxi') do
			Citizen.Wait(0)
		end
		RequestStreamedTextureDict('mecano')
		while not HasStreamedTextureDictLoaded('mecano') do
			Citizen.Wait(0)
		end
        while true do
			local PosX = POSITION.x - (Config.Width / 2)
			local PosY = 0

			local X1 = PosX + Config.Padding
			local X2 = (POSITION.x + (Config.Width / 2)) - Config.Padding

			local MALFORMED = {}
			for i = 1, #MESSAGES, 1 do
				local Message = MESSAGES[i]
				xpcall(function()
					if not Message.Hidden then

						--==================================================================================
						-- WAIT FOR THE SET INTERVAL TO BEGIN THE FADEOUT ANIMATION
						--==================================================================================
						if not Message.Ready then
							local now = GetGameTimer()
							if not Message.Rebuilding then
								Message.Ready = now
								if Message.Advanced and Message.Message then
									PlaySoundFrontend(table.unpack(Config.Sound))
								end
							else
								Message.Ready = Message.Rebuilding
							end

							Citizen.CreateThread(function()
								local t = 10000
								if Message.Ready ~= now then
									t = t - (now - Message.Ready)
								end

								Citizen.Wait(math.max(0, t))
								--==================================================================================
								-- FLAG MESSAGE FOR FADEOUT
								--==================================================================================                            
								Message.StartHiding = true
							end)
						end

						--==================================================================================
						-- MESSAGE IS FLAGGED FOR FADEOUT
						--==================================================================================  
						if Message.StartHiding then
							if Config.Animation then
								Message.Opacity.Box.Current = math.ceil(Message.Opacity.Box.Current - Message.Opacity.Box.Increment)
								Message.Opacity.Text.Current = math.ceil(Message.Opacity.Text.Current - Message.Opacity.Text.Increment)

								if Message.Opacity.Box.Current <= 0 or Message.Opacity.Text.Current <= 0 then
									Message.Opacity.Box.Current = 0
									Message.Opacity.Text.Current = 0

									Message.Hidden = true
								end
							else
								Message.Hidden = true
							end                           
						end

						Message.Offset = Message.y + PosY

						--==================================================================================
						-- STACKING
						--==================================================================================  
						if Config.Animation then
							if TOP then
								if Message.ny <= Message.Offset then
									Message.ny = Message.ny + 0.008
								end

								if Message.ny > Message.Offset then
									Message.ny = Message.Offset
								end
							else
								if Message.ny >= Message.Offset then
									Message.ny = Message.ny - 0.008
								end
			
								if Message.ny < Message.Offset then
									Message.ny = Message.Offset
								end
							end
						else
							Message.ny = Message.Offset
						end                   
	  
						--==================================================================================
						-- RENDER THE MESSAGE
						--==================================================================================  
						if Message.Advanced then -- ADVANCED NOTIFICATION   

							--==================================================================================
							-- RENDER THE BACKGROUND
							--==================================================================================  
							if Message.BG.d then
								DrawSprite(
									Message.BG.d, 
									Message.BG.s, 
									POSITION.x, 
									Message.ny, 
									Config.Width, 
									Message.BoxHeight, 
									0.0, 255, 255, 255, 
									Message.Opacity.Box.Current
								)
							else
								DrawRect(POSITION.x, Message.ny, Config.Width, Message.BoxHeight,
									Message.BG.r, Message.BG.g, Message.BG.b, Message.Opacity.Box.Current)
							end
							
							--==================================================================================
							-- RENDER THE ICON
							--==================================================================================                          
							if Message.Icon.Ready then               
								-- DRAW ICON
								DrawSprite(
									Message.Icon.Thumb,
									Message.Icon.Thumb,
									PosX + (Message.Icon.W / 2), 
									Message.ny - (Message.BoxHeight / 2) + (Message.Icon.H / 2), 
									Message.Icon.W, 
									Message.Icon.H, 
									0.0, 255, 255, 255, Message.Opacity.Text.Current
								)
							end                       
								
							--==================================================================================
							-- RENDER THE TITLE
							--================================================================================== 
							RenderText(Message.Title.Text,
								(Config.Padding + POSITION.x - (Config.Width / 2)) + Message.Icon.W,
								(Message.ny - (Message.BoxHeight / 2) + Config.Padding) - 0.004,
								Message.Opacity.Text.Current, 
								X1 + Message.Icon.W, 
								X2,
								Message.Title.Scale
							)   

							--==================================================================================
							-- RENDER THE SUBJECT
							--==================================================================================
							RenderText(Message.Subject.Text,
								(Config.Padding + POSITION.x - (Config.Width / 2)) + Message.Icon.W,
								((Message.ny - (Message.BoxHeight / 2) + Config.Padding) - 0.004) + TitleTextHeight,
								Message.Opacity.Text.Current, 
								X1 + Message.Icon.W, 
								X2,
								Message.Subject.Scale
							)                       

							--==================================================================================
							-- RENDER THE MESSAGE
							--==================================================================================   
							RenderText(Message.Message,
								Config.Padding + POSITION.x - (Config.Width / 2),
								(Message.ny - (Message.BoxHeight / 2)) + Message.Icon.H + Config.Padding - 0.0025,
								Message.Opacity.Text.Current, 
								X1, 
								X2,
								Config.Scale
							)    

							--==================================================================================
							-- OFFSET THE POSITION BY THE MESSAGE HEIGHT
							--==================================================================================   
							if TOP then
								PosY = PosY + Message.BoxHeight + Config.Spacing
							else
								PosY = PosY - Message.BoxHeight - Config.Spacing
							end

						else  -- STANDARD NOTIFICATION
							
							--==================================================================================
							-- RENDER THE BACKGROUND
							--==================================================================================  
							if Message.BG.d then
								DrawSprite(
									Message.BG.d,
									Message.BG.s,
									POSITION.x, 
									Message.ny, 
									Config.Width, 
									Message.BoxHeight, 
									0.0, 255, 255, 255,
									Message.Opacity.Box.Current
								)
							else
								DrawRect(POSITION.x, Message.ny, Config.Width, Message.Height,
									Message.BG.r, Message.BG.g, Message.BG.b, Message.Opacity.Box.Current)
							end                    

							--==================================================================================
							-- RENDER THE MESSAGE
							--==================================================================================  
							RenderText(Message.Message,
								Config.Padding + POSITION.x - (Config.Width / 2),
								((Message.ny - (Message.Height / 2)) + Config.Padding) - 0.004,
								Message.Opacity.Text.Current, 
								X1, 
								X2,
								Config.Scale
							)
							
							--==================================================================================
							-- OFFSET THE POSITION BY THE MESSAGE HEIGHT
							--==================================================================================   
							if TOP then
								PosY = PosY + Message.Height + Config.Spacing
							else
								PosY = PosY - Message.Height - Config.Spacing
							end
						end

						--==================================================================================
						-- FLAG MESSAGE FOR REMOVAL
						--==================================================================================   
						if Message.Hidden then
							Citizen.CreateThread(function()
								Citizen.Wait(1000)
								Message.Remove = true
							end)
						end                
					end
				end, function(e)
					Citizen.Trace(e)
					table.insert(MALFORMED, i)
				end)
            end

			for _, i in ipairs(MALFORMED) do
				local cb = MESSAGES[i].OnFinish
				if cb then
					cb()
				end

				table.remove(MESSAGES, i)
			end

            Citizen.Wait(WAITTIME)
        end
    end)

    --==================================================================================
    -- CLEAN-UP THREAD
    --==================================================================================
	--local MESSAGES = nil
	if MESSAGES == nil then
		MESSAGES = 'X'
	else
		MESSAGES = MESSAGES
	end
    Citizen.CreateThread(function()
        while true do
			if not HALTED then
				local removing = {}
				for i = 1, #MESSAGES, 1 do
					local Message = MESSAGES[i]
					if Message.Hidden and Message.Remove then
						--==================================================================================
						-- UPDATE QUEUE
						--==================================================================================
						QUEUE = QUEUE - 1

						--==================================================================================
						-- REMOVE THE MESSAGE
						--==================================================================================
						table.insert(removing, i)
						if Message.OnFinish then
							Message.OnFinish()
						end
					end
				end

				for _, i in ipairs(removing) do
					table.remove(MESSAGES, i)
				end

				--==================================================================================
				-- INCREASE WAIT TIME IF NO MESSAGES ARE ACTIVE
				--==================================================================================
				if #MESSAGES > 0 then
					WAITTIME = 0
				else
					WAITTIME = 200
				end
			else
				WAITTIME = 200
				for i,Message in ipairs(MESSAGES) do
					if Message.OnFinish then
						Message.OnFinish()
					end
				end

				MESSAGES = {}
				QUEUE = 0
			end

            Citizen.Wait(50)
        end
	end)
	
	if Config.RadarMod then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(200)

                local update = false
                if IsRadarHidden() == 1 then
                    if Config.Position ~= "bottomLeft" then
                        Config.Position = "bottomLeft"
                        QUOTA = Config.Queue
                        update = true
                    end
                elseif IsBigmapActive() then
                    if Config.Position ~= "bottomLeftBig" then
                        Config.Position = "bottomLeftBig"
                        QUOTA = Config.QueueBig
                        update = true
                    end
                elseif Config.Position ~= "bottomLeftRadar" then
                    Config.Position = "bottomLeftRadar"
                    QUOTA = Config.QueueRadar
                    update = true
                end

                if update then
                    local d = {}
                    for i = #MESSAGES, 1, -1 do
                        if not MESSAGES[i].Hidden and not MESSAGES[i].Remove then
                            table.insert(d, MESSAGES[i])
                        else
                            local cb = MESSAGES[i].OnFinish
                            if cb then
                                cb()
                            end
                        end
                    end

                    POSITION = Config.Positions[Config.Position]
                    MESSAGES = {}
                    for i, Message in ipairs(d) do
                        AddMessage(Message.Message, Message.Interval, Message.BG, Message.Advanced, Message.Title, Message.Subject, Message.Icon.Thumb, Message.Ready, Message.OnFinish)
                    end
                end
            end
        end)
    end

	Citizen.CreateThread(function()
        while true do
			if not HALTED then
				local removing = {}
				for i = 1, #QUEUED, 1 do
					local Message = QUEUED[i]
					if QUEUE < QUOTA then
						xpcall(function()
							BuildMessage(Message.Message, Message.Interval, Message.Type, Message.Advanced, Message.Title, Message.Subject, Message.Icon, Message.OnFinish)
						end, function(e)
							Citizen.Trace(e)
						end)

						table.insert(removing, i)
					end
				end

				for _, i in ipairs(removing) do
					table.remove(QUEUED, i)
				end
			end

            Citizen.Wait(50)
        end
    end)    

    --==================================================================================
    -- QUEUE THREAD
    --==================================================================================
    Citizen.CreateThread(function()
        while true do
			if not HALTED then
				local removing = {}
				for i = 1, #QUEUED, 1 do
					local Message = QUEUED[i]
					if QUEUE < Config.Queue then
						xpcall(function()
							BuildMessage(Message.Message, 10000, Message.Type, Message.Advanced, Message.Title, Message.Subject, Message.Icon, Message.OnFinish)
						end, function(e)
							Citizen.Trace(e)
						end)

						table.insert(removing, i)
					end
				end

				for _, i in ipairs(removing) do
					table.remove(QUEUED, i)
				end
			end

            Citizen.Wait(50)
        end
    end)    
end

--==================================================================================
-- START THREADS IF ENABLED
--==================================================================================
if Config.Enabled then
    InitThreads()
end


--====================================================================================================================
--                                                   FUNCTIONS                                                      --
--====================================================================================================================

function BuildMessage(Message, Interval, Type, Advanced, Title, Subject, Icon, OnFinish)

	if not Advanced and Message == nil then
		Message = '~r~ERROR~s~: The text of the notification is nil.'
	end

	if not Title then
		--
	elseif type(Title) ~= "string" and type(Title) ~= "number" then
		return false
	end

	if not Subject then
		--
	elseif type(Subject) ~= "string" and type(Subject) ~= "number" then
		return false
	end

	if not Message then
		--
	elseif type(Message) ~= "string" and type(Message) ~= "number" then
		return false
	end

    --==================================================================================
    -- DUPLICATE CHECK
    --==================================================================================
    if Config.FilterDuplicates then
        for k, v in ipairs(MESSAGES) do
            if Advanced then
                if v.Title == Title and v.Message == Message and v.Subject == Subject and v.Icon.Thumb == Icon then
                    return false
                end
            else
                if v.Message == Message then
                    return false
                end
            end
        end    
    end    

    WAITTIME = 0

    Interval = Interval or 10000

    local BG = Config.Types.primary
    if not Type then
		--
	elseif type(Type) == 'table' then
		BG = Type
	else
        local t = Config.Types[Type]
        if t then
			BG = t
        end
    end    

    if type(Icon) == "number" then
        -- User player headshot as icon
        Citizen.CreateThread(function()
            local hs = RegisterPedheadshot(Icon)
			while not IsPedheadshotReady(hs) do
                Citizen.Wait(0)
            end

            AddMessage(Message, Interval, BG, Advanced, Title, Subject, GetPedheadshotTxdString(hs), nil, function()
				UnregisterPedheadshot(hs)
				if OnFinish then
					OnFinish()
				end
			end)
        end)
    else
        AddMessage(Message, Interval, BG, Advanced, Title, Subject, Icon, nil, OnFinish) 
    end
end

function QueueMessage(Message, Interval, Type, Advanced, Title, Subject, Icon, OnFinish)
    table.insert(QUEUED, {
        Title = Title, Subject = Subject, Icon = Icon, Message = Message, Interval = Interval, Type = Type, Advanced = Advanced, OnFinish = OnFinish
    })
end

function AddMessage(Message, Interval, BG, Advanced, Title, Subject, Icon, Rebuilding, OnFinish)

    local Data = {
        Advanced = Advanced,
        Icon = {
            Thumb = Icon,
            Ready = false,
            W = 0,
            H = 0
        },
        Index = COUNTER,
		Title = Title,
		Subject = Subject,
        Message = Message,
        Interval = Interval,
        BG = BG,
        Hiding = false,
        y = POSITION.y,
        ny = POSITION.y,
        Opacity = {
            Text = { Current = 255, Increment = 255 / 20},
            Box = { Current = BG.a, Increment = BG.a / 20},
        },
		Rebuilding = Rebuilding,
		OnFinish = OnFinish
    }

	if type(Data.Title) ~= 'table' then
        Data.Title = {
			Text = Data.Title,
			Scale = Config.TitleScale
		}
	end

	if type(Data.Subject) ~= 'table' then
        Data.Subject = {
			Text = Data.Subject,
			Scale = Config.SubjectScale
		}
	end

    -- GET MESSAGE HEIGHT
    Data.Height, Data.Lines = GetMessageHeight(Message, Config.Padding + POSITION.x - (Config.Width / 2), POSITION.y)   

    -- ADVANCED NOTIFICATION ICON
    if Advanced then
        local width, height = GetActiveScreenResolution()
        local size = 0.028

        Data.Icon.W = (size * width) / width
        Data.Icon.H = (size * width) / height 
        
        Data.BoxHeight = Data.Icon.H + Data.Height + Config.Padding

        -- LOAD TEXTURE DICTIONARY
        if not HasStreamedTextureDictLoaded(Icon) then
            RequestStreamedTextureDict(Icon)
            while not HasStreamedTextureDictLoaded(Icon) do
                Citizen.Wait(1)
            end
        end

        Data.Icon.Ready = true

        if TOP then
            Data.y = Data.y + (Data.BoxHeight / 2)
            Data.ny = Data.ny + (Data.BoxHeight / 2)
        else
            Data.y = Data.y - (Data.BoxHeight / 2)
            Data.ny = Data.ny - (Data.BoxHeight / 2)
        end

		-- DYNAMICALLY RECALCULATE TITLE FONT SCALE FOR LONG TEXT - WE WANT TITLE IN 1 LINE LIKE NATIVELY
		if Data.Title.Text then
			size = Config.TitleScale
			while GetLineCount(Data.Title.Text,
				(Config.Padding + POSITION.x - (Config.Width / 2)) + Data.Icon.W,
				(Data.ny - (Data.BoxHeight / 2) + Config.Padding) - 0.004,
				((Config.Padding + POSITION.x - (Config.Width / 2)) + Data.Icon.W) + Config.Padding + Data.Icon.W,
				(POSITION.x + (Config.Width / 2)) - Config.Padding,
				size
			) > 1 and size > 0.0 do
				size = size - 0.01
				Citizen.Wait(0)
			end

			if size ~= Config.TitleScale then
				Data.Title.Scale = size
			end
		end

		-- DYNAMICALLY RECALCULATE SUBJECT FONT SCALE FOR LONG TEXT - WE WANT SUBJECT IN 1 LINE LIKE NATIVELY
		if Data.Subject.Text then
			size = Config.SubjectScale
			while GetLineCount(Data.Subject.Text,
				(Config.Padding + POSITION.x - (Config.Width / 2)) + Data.Icon.W,
				((Data.ny - (Data.BoxHeight / 2) + Config.Padding) - 0.004) + TitleTextHeight,
				((Config.Padding + POSITION.x - (Config.Width / 2)) + Data.Icon.W) + Config.Padding + Data.Icon.W,
				(POSITION.x + (Config.Width / 2)) - Config.Padding,
				size
			) > 1 and size > 0.0 do
				size = size - 0.01
				Citizen.Wait(0)
			end

			if size ~= Config.SubjectScale then
				Data.Subject.Scale = size
			end
		end
    elseif TOP then
        Data.y = Data.y + (Data.Height / 2)
        Data.ny = Data.ny + (Data.Height / 2)
    else
        Data.y = Data.y - (Data.Height / 2)
        Data.ny = Data.ny - (Data.Height / 2)

    end


    -- ENABLE MESSAGE DISPLAY
    table.insert(MESSAGES, 1, Data)

    -- UPDATE QUEUE
    QUEUE = QUEUE + 1

    -- UPDATE COUNTER
    COUNTER = COUNTER + 1    
end

function ShowNotification(Message, Interval, Type)
    if Config.Enabled then
        if HALTED and CANQUEUE and QUEUE > Config.Queue - 1 then
            QueueMessage(Message, Interval, Type, false)
        else
			xpcall(function()
				BuildMessage(Message, Interval, Type, false)
			end, function(e)
				Citizen.Trace(e)
			end)
        end
    end
end

function ShowAdvancedNotification(Title, Subject, Message, Icon, Interval, Type, OnFinish)
    if Config.Enabled then
        if not Icon then
            Icon = 'CustomLogo'
        end
        if HALTED and CANQUEUE and QUEUE > Config.Queue - 1 then
            QueueMessage(Message, Interval, Type, true, Title, Subject, Icon, OnFinish)
        else
			xpcall(function()
				BuildMessage(Message, Interval, Type, true, Title, Subject, Icon, OnFinish)
			end, function(e)
				Citizen.Trace(e)
			end)
        end        
    end
end

--====================================================================================================================
--                                                    EXPORTS                                                      --
--====================================================================================================================

exports('ShowNotification', ShowNotification)
exports('ShowAdvancedNotification', ShowAdvancedNotification)

--====================================================================================================================
--                                                     EVENTS                                                      --
--====================================================================================================================

RegisterNetEvent('FeedM:showNotification')
AddEventHandler("FeedM:showNotification", function(Message, Interval, Type)
    ShowNotification(Message, Interval, Type)
end)

RegisterNetEvent('FeedM:showTitledNotification')
AddEventHandler("FeedM:showTitledNotification", function(Title, Subject, Message)
	if Message == true then
		Message = Subject
		Subject = nil
	end

    ShowAdvancedNotification(Title, Subject, Message)
end)

RegisterNetEvent('FeedM:showAdvancedNotification')
AddEventHandler("FeedM:showAdvancedNotification", function(Title, Subject, Message, Icon, Interval, Type, OnFinish)
    ShowAdvancedNotification(Title, Subject, Message, Icon, Interval, Type, OnFinish)
end)

RegisterNetEvent('FeedM:halt')
AddEventHandler("FeedM:halt", function(s)
	HALTED = s
end)