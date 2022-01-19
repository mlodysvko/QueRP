radioConfig = {
    Controls = {
        Activator = { -- Open/Close Radio
            Name = "INPUT_FRONTEND_RRIGHT", -- Control name
            Key = 194, -- BACKSPACE
        },
        Toggle = { -- Toggle radio on/off
            Name = "INPUT_CONTEXT", -- Control name
            Key = 51, -- E
        },
        Input = { -- Choose Frequency
            Name = "INPUT_FRONTEND_ACCEPT", -- Control name
            Key = 201, -- Enter
            Pressed = false,
        },
        ToggleClicks = { -- Toggle radio click sounds
            Name = "INPUT_SELECT_WEAPON", -- Control name
            Key = 37, -- Tab
        }
    },
    Frequency = {
        Private = { -- List of private frequencies
            [1] = true
        },
        Current = 1, -- Don't touch
        CurrentIndex = 1, -- Don't touch
        Min = 1, -- Minimum frequency
        Max = 100, -- Max number of frequencies
        List = {}, -- Frequency list, Don't touch
        Access = {
            [1] = {'police'},
            [2] = {'police'},
            [3] = {'police'},
            [4] = {'ambulance'},
            [5] = {'ambulance'},
            [6] = {'ambulance'},
            [7] = {'mecano'},
            [8] = {'mecano'},
            [9] = {'mecano'},
            [10] = {'org2'}, -- DDL
            [11] = {'org3'}, -- Buldogi
            [12] = {'org4'}, -- LIMON
            [13] = {'org5'}, -- L.E
            [14] = {'org6'}, -- G.O.K
            [15] = {'org7'}, -- BLACK
            [16] = {'org8'}, -- Zimny Lokiec
            [17] = {'org9'}, -- WIP
            [18] = {'org10'}, -- KDB
            [19] = {'org11'}, -- T.R.W
            [20] = {'org12'}, -- A.C.E
            [21] = {'org13'}, -- T.H.C
            [22] = {'org15'}, -- BOYS SANTOS
            [23] = {'org19'}, -- The Families
            [24] = {'org24'}, -- BALLASI
            [25] = {'org25'}, -- CRIPS
            [26] = {'org14'}, -- Marcinki
            [27] = {'org16'}, -- COD
            [28] = {'org18'}, -- Y.C.B
            [29] = {'org22'}, -- T.I.T.A.N
            [30] = {'org17'}, -- ARAB
            [31] = {'org34'}, -- TBH
            [32] = {'org33'}, -- NZZ
            [33] = {'org29'}, -- PTC
            [34] = {'org36'}, -- S.P.C.G
            [35] = {'org37'}, -- FlameForces
            [36] = {'org35'}, -- D.S.W
            [37] = {'org25'}, -- MTS
            [38] = {'org13'}, -- SNW
            [39] = {'org17'}, -- RZULE
            [40] = {'org19'}, -- Srodmiescie
            [41] = {'org24'}, -- B.B.G
            [42] = {'org26'}, -- Mara Salvatrucha
            [43] = {'org30'}, -- GFM
            [44] = {'org32'}, -- 112
            [45] = {'org31'}, -- Ninja Turtles
            [47] = {'org21'}, -- S.G.D
        }
    },
    AllowRadioWhenClosed = true -- Allows the radio to be used when not open (uses police radio animation) 
}