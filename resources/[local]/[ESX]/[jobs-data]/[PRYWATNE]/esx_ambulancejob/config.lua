Config                            = {}

Config.DrawDistance							= 100.0
Config.MarkerColor							= { r = 102, g = 0, b = 102 }
Config.MarkerSize							= { x = 1.5, y = 1.5, z = 1.0 }
Config.DeleteMarkerSize						= { x = 3.0, y = 3.0, z = 1.0 }
Config.DeathCameraRadius					= 1.5
Config.ReviveReward							= 10000  -- revive reward, set to 0 if you don't want it enabled
Config.EnableSocietyOwnedVehicles	= false
Config.AntiCombatLog						= true -- enable anti-combat logging?
Config.Locale										= 'pl'
Config.EnablePeds = true
Config.DoctorLimit = true
Config.maxDoctor = 2
Config.doctorPrice = 2500

Config.Doctor = {
    {x = -677.76, y = 337.54, z = 83.12, heading = 313.19, type = 'legal'},
	{x = 318.99, y = -588.9, z = 43.28, heading = 160.22, type = 'legal'},
	{x = 1832.58, y = 3675.29, z = 34.27, heading = 234.39, type = 'legal'}

}

Config.RespawnToHospitalDelay		= 300000
Config.RemoveWeaponsAfterRPDeath	= true
Config.RemoveCashAfterRPDeath		= false
Config.RemoveItemsAfterRPDeath		= true

Config.Blips = {
    {
        Pos     = { x = 304.90, y = -586.41, z = 42.31 },
        Sprite  = 61,
        Display = 4,
        Scale   = 0.8,
        Colour  = 2,
        Label = _U('hospital')
    },
    {
        Pos     = { x = 1828.92, y = 3664.19, z = 32.96 },
        Sprite  = 61,
        Display = 4,
        Scale   = 0.8,
        Colour  = 2,
        Label = _U('hospital')
    },
    {
        Pos     = { x = -247.74, y = 6312.35, z = 38.8 },
        Sprite  = 61,
        Display = 4,
        Scale   = 0.8,
        Colour  = 2,
        Label = _U('hospital')
    },
}

Config.DeathPosition = {
	x = -682.66, y = 312.04, z = 83.08, heading = 257.48
}

Config.AuthorizedVehicles = {
	{
		grade = 0,
		model = 'ms_charger',
		label = 'Dodge Charger 2019',
		livery = 0,
		extras = {
			[1] = 1,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
	{
		grade = 0,
		model = 'ms_coach',
		label = 'Autobus Medyczny',
		livery = 0,
		extras = {
			[1] = 1,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
	{
		grade = 0,
		model = 'ms_explorer',
		label = 'Ford Explorer',
		livery = 0,
		extras = {
			[1] = 1,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
	{
		grade = 0,
		model = 'ms_fusion16',
		label = 'Fuion 2016',
		livery = 2,
		extras = {
			[1] = 1,
			[2] = 1,
			[3] = 1,
			[4] = 1,
			[5] = 1,
			[6] = 1,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
	{
		grade = 0,
		model = 'ms_impala',
		label = 'Impala',
		livery = 2,
		extras = {
			[1] = 1,
			[2] = 1,
			[3] = 1,
			[4] = 1,
			[5] = 1,
			[6] = 1,
			[7] = 1,
			[8] = 1,
			[9] = 1,
			[10] = 1,
			[11] = 1,
			[12] = 1,
		}
	},
	{
		grade = 0,
		model = 'ms_jeep',
		label = 'Jeep',
		livery = 2,
		extras = {
			[1] = 1,
			[2] = 1,
			[3] = 1,
			[4] = 1,
			[5] = 1,
			[6] = 1,
			[7] = 1,
			[8] = 1,
			[9] = 0,
			[10] = 1,
			[11] = 1,
			[12] = 1,
		}
	},
	{
		grade = 0,
		model = 'ms_m5',
		label = 'BMW m5',
		livery = 2,
		extras = {
			[1] = 1,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
	{
		grade = 0,
		model = 'r1custom',
		label = 'Yamaha R1',
		livery = 0,
		extras = {
			[1] = 1,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
	{
		grade = 0,
		model = 'ms_ram19',
		label = 'Ram 2019',
		livery = 2,
		extras = {
			[1] = 1,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
	{
		grade = 0,
		model = 'ms_ramambo',
		label = 'Karetka #2',
		livery = 2,
		extras = {
			[1] = 1,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
	{
		grade = 0,
		model = 'ms_tahoe',
		label = 'Tahoe',
		livery = 2,
		extras = {
			[1] = 1,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
	{
		grade = 0,
		model = 'ms_tahoe21',
		label = 'Tahoe 2021',
		livery = 2,
		extras = {
			[1] = 1,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
	{
		grade = 0,
		model = 'ms_transformer',
		label = 'Karetka #3',
		livery = 2,
		extras = {
			[1] = 1,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
	{
		grade = 0,
		model = 'ms_tundra',
		label = 'Karetka #4',
		livery = 2,
		extras = {
			[1] = 1,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0,
			[9] = 0,
			[10] = 0,
			[11] = 0,
			[12] = 0,
		}
	},
}


Config.Zones = {
	HospitalInteriorElevator1 = { 
		Pos	= { x = 380.63, y = -15.6, z = 82.0 },
		Teleport = { x = 380.63, y = -15.6, z = 82.0, heading = 34.32 },
		Type = 1
	},

	HospitalInteriorElevator2 = {
		Pos	= { x = 414.94, y = -15.14, z = 98.65 },
		Teleport = { x = 414.94, y = -15.14, z = 99.65, heading = 99.65 },
		Type = 1
	},

	--[[HospitalInteriorElevator3 = {
		Pos	= { x = 335.8353, y = -580.11, z = 47.2909 },
		Teleport = { x = 335.2168, y = -581.7358, z = 47.2742, heading = 162.76 },
		Type = 1
	},

	HospitalInteriorElevator4 = {
		Pos	= { x = 335.8838, y = -579.9323, z = 73.1204 },
		Teleport = { x = 335.2468, y = -581.6038, z = 73.1188, heading = 156.18 },
		Type = 1
	},

	HospitalInteriorEntering1 = { -- Pillbox second elevator
		Pos	= { x = 331.0914, y = -593.0497, z = 27.9511 },
		Teleport = { x = 331.8472, y = -591.3918, z = 42.332, heading = 341.5 },
		Type = 1
	},

	HospitalInteriorExit1 = {
		Pos	= { x = 331.064, y = -593.1516, z = 42.332 },
		Teleport = { x = 331.8382, y = -591.4169, z = 27.9511, heading = 340.78 },
		Type = 1
	},

	HospitalInteriorEntering2 = { -- LSFD floor
		Pos	= { x = 1128.2247, y = -1510.0708, z = 38.7765 },
		Teleport = { x = 1121.6097, y = -1516.8363, z = 29.725, heading = 327.27 },
		Type = 1
	},

	HospitalInteriorExit2 = {
		Pos	= { x = 1121.6097, y = -1516.8363, z = 29.725 },
		Teleport = { x = 1128.2247, y = -1510.0708, z = 38.7765, heading = 269.64 },
		Type = 1
	},

	HospitalInteriorEntering3 = { -- LSFD back
		Pos	= { x = 1102.2629, y = -1528.6625, z = 34.0826 },
		Teleport = { x = 1175.8319, y = -1556.2474, z = 29.5386, heading = 321.82 },
		Type = 1
	},

	HospitalInteriorExit3 = {
		Pos	= { x = 1175.8319, y = -1556.2474, z = 29.5386 },
		Teleport = { x = 1102.2629, y = -1528.6625, z = 34.0826, heading = 176.2 },
		Type = 1
	},]]

	HospitalInteriorEntering4 = { -- WEJSCIE NA HELIPAD ECLIPS
		Pos	= { x = -668.6606, y = 350.3919, z = 82.2046 },
		Teleport = { x = -719.17, y = 337.23, z = 91.48, heading = 19.14 },
		Type = 1
	},

	HospitalInteriorExit4 = { -- ZEJSCIE Z HELIPADA ECLIPS
		Pos	= { x = -716.69, y = 336.47, z = 90.48 },
		Teleport = { x = -672.6, y = 348.87, z = 82.12, heading = 101.28 },
		Type = 1
	},

	--ECLIPSE
	AmbulanceActions = {
		Pos	= { x = 298.80, y = -598.29, z = 42.33},
		Type = 1
	},

	Pharmacy = {
		Pos	= { x = 311.35, y = -563.36, z = 42.43},
		Type = 1
	},

	BossActions = {
		Pos	= { x = -682.46, y = 358.25, z = 82.12 },
		Type = 1
	},

	VehicleSpawner = {
		Pos	= { x = 293.24, y = -598.26, z = 43.29-0.90},
		Type = 1
	},

	VehicleSpawnPoint = {
		Pos	= { x = 288.42, y = -596.62, z = 43.29-0.90 },
		Heading = 173.99,
		Type = -1
	},

	VehicleDeleter = {
		Pos	= { x = 288.42, y = -596.62, z = 43.29-0.90 },
		Type = 1
	},

	HeliDeleter = {
		Pos	= { x = -701.48, y = 351.39, z = 92.2 },
		Type = 1
	},

	HeliSpawner = {
		Pos	= { x = -712.9, y = 343.52, z = 90.32 },
		Type = 1
	},

	HeliSpawnPoint = {
		Pos	= { x = -701.48, y = 351.39, z = 93.2 },
		Heading = 265.2,
		Type = -1
	},

	--SANDY
	AmbulanceActions2 = {
		Pos	= { x = 1825.18, y = 3674.97, z = 33.27 },
		Type = 1
	},

	Pharmacy2 = {
		Pos	= { x = 1843.61, y = 3681.47, z = 33.27 },
		Type = 1
	},

	BossActions2 = {
		Pos	= { x = 1839.89, y = 3686.69, z = 34.27 },
		Type = 1
	},

	VehicleSpawner2 = {
		Pos	= { x = 1817.74, y = 3651.31, z = 33.80 },
		Type = 1
	},

	VehicleSpawnPoint2 = {
		Pos	= { x = 1817.74, y = 3651.31, z = 33.24 },
		Heading = 341.2,
		Type = -1
	},

	VehicleDeleter2 = {
		Pos	= { x = 1827.18, y = 3693.6, z = 33.22 },
		Type = 1
	},

	--[[HeliDeleter2 = {
		Pos	= { x = 1826.54, y = 3656.83, z = 33.05},
		Type = 1
	},

	HeliSpawner2 = {
		Pos	= { x = 1817.74, y = 3651.31, z = 33.24 },
		Type = 1
	},

	HeliSpawnPoint2 = {
		Pos	= { x = 1817.74, y = 3651.31, z = 33.24 },
		Heading = 248.17,
		Type = -1
	},--]]

	--PLAETO
	AmbulanceActions3 = {
		Pos	= { x = -260.15, y = 6318.75, z = 31.43 },
		Type = 1
	},

	Pharmacy3 = {
		Pos	= { x = -250.34, y = 6311.53, z = 31.43 },
		Type = 1
	},

	BossActions3 = {
		Pos	= { x = -256.74, y = 6306.47, z = 31.43 },
		Type = 1
	},

	VehicleSpawner3 = {
		Pos	= { x = -244.0, y = 6339.05, z = 31.35 },
		Type = 1
	},

	VehicleSpawnPoint3 = {
		Pos	= { x = -244.0, y = 6339.05, z = 31.35 },
		Heading = 341.2,
		Type = -1
	},

	VehicleDeleter3 = {
		Pos	= { x = -237.31, y = 6332.31, z = 31.36 },
		Type = 1
	},

	HeliDeleter3 = {
		Pos	= { x = -249.97, y = 6317.4, z = 38.66 },
		Type = 1
	},

	HeliSpawner3 = {
		Pos	= { x = -255.43, y = 6323.24, z = 38.66  },
		Type = 1
	},

	HeliSpawnPoint3 = {
		Pos	= { x = -255.43, y = 6323.24, z = 38.66  },
		Heading = 248.17,
		Type = -1
	}
}