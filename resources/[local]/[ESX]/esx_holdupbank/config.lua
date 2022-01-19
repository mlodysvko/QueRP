Config = {}
Config.Locale = 'pl'

Config.PoliceNumberRequired = 3
Config.TimerBeforeNewRob = 172800



Banks = {
    ["blainecounty_savings"] = {
        position = { ['x'] = -107.06505584717, ['y'] = 6474.8012695313, ['z'] = 31.62670135498 },
        reward = math.random(190000,290000),
        nameofbank = "Blaine County",
        secondsRemaining = 1, -- seconds
        lastrobbed = 0,
	humane = ""
    },
	["fleecahighway_savings"] = {
        position = { ['x'] = -2957.6674804688, ['y'] = 481.45776367188, ['z'] = 15.697026252747 },
        reward = math.random(190000,290000),
        nameofbank = "Fleeca \"Autostrada\"",
        secondsRemaining = 1, -- seconds
        lastrobbed = 0,
	humane = ""
    },
    ["skarbiec"] = {
        position = { ['x'] = 265.273529, ['y'] = 214.122116, ['z'] = 101.683456 },
        reward = math.random(300000,470000),
        nameofbank = "Skarbiec \"Centrum Miasta\"",
        secondsRemaining = 1, -- seconds
        lastrobbed = 0,
	humane = ""
    },
	["fleecacentre_savings"] = {
        position = { ['x'] =  147.04908752441, ['y'] = -1044.9448242188, ['z'] = 29.36802482605},
        reward = math.random(190000,290000),
        nameofbank = "Fleeca \"Centrum Miasta\"",
        secondsRemaining = 1, -- seconds
        lastrobbed = 0,
	    humane = ""
    }
}
