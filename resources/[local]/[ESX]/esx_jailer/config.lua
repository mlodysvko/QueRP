Config              = {}
Config.Locale       = 'pl'

Config.JailBlip     = {x = 1855.00, y = 2605.00, z = 45.64}
Config.JailLocation = {x = 1664.64, y = 2534.08, z = 45.56}

Config.ArrestedCutScene = {
	Player = {coord = vector3(1817.81, 2593.97, 45.62), head = 91.55, dest = vector3(1791.79, 2593.74, 45.8)},

	NPC = {
		{coord = vector3(1818.24, 2595.68, 45.72), head = 91.55, dest = vector3(1792.56, 2595.48, 45.8), dhead = 350.66, ped = "s_m_m_prisguard_01"},
		{coord = vector3(1818.22, 2592.58, 45.72), head = 91.55, dest = vector3(1792.54, 2592.55, 45.8), dhead = 350.60, ped = "s_m_m_prisguard_01"}
	},

	Cams = {
		["Cam0"] = {
			coord = vector3(1813.53, 2592.08, 44.86),
			rot = vector3(0, 0, 0)
		},

		["Cam1"] = {
			coord = vector3(1803.19, 2594.77, 45.8),
			rot = vector3(0, 0, -90)
		},

		["Cam2"] = {
			coord = vector3(1800.04, 2596.17, 45.8),
			rot = vector3(0, 0, 140)
		},

		["Cam3"] = {
			coord = vector3(1757.1, 2510.36, 45.57),
			rot = vector3(0, 0, -17)
		},
	},
}

Config.PrisonZones = {
	["SPos"] = {
		coord = vector3(1775.54, 2552.04, 45.57),
		heading = 93.0
	},

	["9AB"] = {
		coord = vector3(1760.02, 2513.09, 45.81),
		peds = {coord = vector3(1760.02, 2513.09, 45.81-0.95), head = 76.42,	ped = "s_m_m_prisguard_01"}
	}
}

Config.Jobs = {
	Marker = {
		Color = {r = 204, g = 204, b = 0},
		Size  = {x = 3.0, y = 3.0, z = 1.0}, 
		Type  = 1
	},
	List = {
		{
			Pos = {x = 1689.326, y = 2551.525, z = 44.564},
			Name = '#1'
		},
		{
			Pos = {x = 1700.200, y = 2474.780, z = 44.564},
			Name = '#2'
		},
		{
			Pos = {x = 1609.010, y = 2566.986, z = 44.564},
			Name = '#3'
		},
		{
			Pos = {x = 1717.449, y = 2567.409, z = 44.564},
			Name = '#4'
		},
		{
			Pos = {x = 1772.111, y = 2546.052, z = 44.586},
			Name = '#5'
		}
	}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {
	prison_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 146, ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 0,   ['pants_1']  = 3,
			['pants_2']  = 7,   ['shoes_1']  = 12,
			['shoes_2']  = 12,  ['chain_1']  = 50,
			['chain_2']  = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1']  = 38,  ['torso_2']  = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 2,   ['pants_1']  = 3,
			['pants_2']  = 15,  ['shoes_1']  = 66,
			['shoes_2']  = 5,   ['chain_1']  = 0,
			['chain_2']  = 2
		}
	}
}
