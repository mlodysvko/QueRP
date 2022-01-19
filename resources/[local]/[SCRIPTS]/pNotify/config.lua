Config = {}

Config.Enabled          = true      -- Enable / disable
Config.RadarMod         = true

-- Text Options
Config.Font             = 0         -- Font family (https://gtaforums.com/topic/794014-fonts-list/)
Config.Scale            = 0.22      -- Font size
Config.TitleScale       = 0.3       -- Title font size
Config.SubjectScale     = 0.22      -- Subject font size

-- Box Dimensions
Config.Width            = 0.1405     -- Box width
Config.Spacing          = 0.005     -- Box margin / seperation
Config.Padding          = 0.006

Config.Queue            = 3         -- Message queue limit
Config.QueueRadar       = 3
Config.QueueBig         = 2
Config.FilterDuplicates = true      -- Enable / disable filtering of duplicate notifications
Config.Animation        = true      -- Enable / disable animation

Config.Sound            = { -1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 }

Config.Position         = "bottomLeft"      -- Position

-- Message Positions
Config.Positions = { -- https://github.com/Mobius1/FeedM#positioning
	bottomLeft      = { x = 0.08,  y = 0.95 },
    bottomLeftRadar = { x = 0.085,  y = 0.61 },
	bottomLeftBig   = { x = 0.08,  y = 0.50 },
    bottomRight     = { x = 0.915,  y = 0.98 },
    topLeft         = { x = 0.085,  y = 0.02 },
    topRight        = { x = 0.915,  y = 0.02 },
    bottomCenter    = { x = 0.5,    y = 0.98 }
}

-- Message Types
Config.Types = {
    primary = { r = 0,      g = 0,      b = 0,      a = 145 },
    success = { r = 100,    g = 221,    b = 23,     a = 145 },
    warning = { r = 255,    g = 196,    b = 0,      a = 145 },
    danger  = { r = 211,    g = 47,     b = 47,     a = 145 },
    extra   = { r = 0,      g = 245,    b = 106,    a = 145 }, 
    dowod   = { r = 11,     g = 153,    b = 134,    a = 145 },

	male   =  { r = 139,    g = 192,    b = 247,    a = 145 },
	female =  { r = 238,    g = 160,    b = 241,    a = 145 }
}