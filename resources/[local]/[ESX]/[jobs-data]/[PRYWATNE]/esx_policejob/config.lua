Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 0, g = 130, b = 204 }
Config.Marker 			 		  = {Type = 27, r = 0, g = 127, b = 22}
Config.EnableArmoryManagement     = true
Config.EnableLicenses             = true
Config.EnableHandcuffTimer        = true
Config.HandcuffTimer              = 15 * 60000
Config.MaxInService               = -1
Config.Locale                     = 'pl'
Config.ReceiveAmmo = 250
Config.Colors = {
	{ label = _U('black'), value = 'black'},
	{ label = _U('white'), value = 'white'},
	{ label = _U('grey'), value = 'grey'},
	{ label = _U('red'), value = 'red'},
	{ label = _U('pink'), value = 'pink'},
	{ label = _U('blue'), value = 'blue'},
	{ label = _U('yellow'), value = 'yellow'},
	{ label = _U('green'), value = 'green'},
	{ label = _U('orange'), value = 'orange'},
	{ label = _U('brown'), value = 'brown'},
	{ label = _U('purple'), value = 'purple'}
}

Config.License = {
	'SWAT',
	'SEU',
	'FTO',
	'AIAD',
}

Config.PoliceStations = {

	MissionRow = {
			Cloakrooms = {
				{ x = 460.83, y = -996.35, z = 29.69 }, 
			},


			Armories = {
				{ x = 482.68, y = -996.13, z = 29.69}, 
			},

			Vehicles = {
				{
					Spawner    = { x = 427.63, y = -986.49, z = 24.70 },
					SpawnPoint = { x = 431.54, y = -985.44, z = 24.7 },
					Heading    = 176.53
				},
				{
					Spawner    = { x = 459.35, y = -986.60, z = 24.70 },
					SpawnPoint = { x = 454.26, y = -985.44, z = 24.7 },
					Heading    = 176.53
				},
			},
			VehicleDeleters = {
				{ x = 450.26, y = -976.03, z = 24.7 },
				{ x = 435.39, y = -976.1, z = 24.7 },
				{ x = 475.92, y = -1023.64, z = 27.0 },
			},

			BossActions = {
				{ x = 460.5, y = -985.33, z = 29.50 },
			},
	},
	VineWood = {
			Cloakrooms = {
				{ x = 618.75, y = 14.67, z = 81.78 }, 
			},


			Armories = {
				{ x = 624.19, y = -27.61, z = 81.78}, 
			},

			Vehicles = {
				{
					Spawner    = { x = 625.07, y = 20.28, z = 86.95 },
					SpawnPoint = { x = 620.83, y = 26.59, z = 87.45 },
					Heading    = 249.89
				},
			},
			VehicleDeleters = {
				{ x = 617.01, y = 28.18, z = 87.85 },
			},

			BossActions = {
				{ x = 629.56, y = -8.86, z = 81.78 },
			},
	},
	Davis = {
			Cloakrooms = {
				{ x = -382.51, y = -1609.79, z = 28.29 }, 
			},


			Armories = {
				{ x = 368.35, y = -1600.08, z = 28.29 },  
			},

			Vehicles = {
				{
					Spawner    = { x = 373.47, y = -1617.33, z = 28.29 },
					SpawnPoint = { x = 378.51, y = -1630.51, z = 27.31},
					Heading    = 317.52
				},
			},
			VehicleDeleters = {
				{ x = 386.46, y = -1635.47, z = 28.29 },
			},

			BossActions = {
				{ x = 388.54, y = -1601.39, z = 28.29 },
			},
	},	
	Sandy = {
			Cloakrooms = {
				{ x = 1849.11, y = 3695.73, z = 33.27}, 
			},


			Armories = {
				{ x = 1842.0, y = 3691.04, z = 33.27},  
			},

			Vehicles = {
				{
					Spawner    = { x = 1855.64, y = 3702.24, z = 33.27 },
					SpawnPoint = { x = 1861.7, y = 3704.48, z = 32.45},
					Heading    = 214.57
				},
			},
			VehicleDeleters = {
				{ x = 1867.28, y = 3694.59, z = 32.65},
			},

			BossActions = {
				{ x = 1861.89, y = 3689.17, z = 33.27},
			},
	},
	Paleto = {
			Cloakrooms = {
				{ x = -453.07, y = 6013.78, z = 30.72}, 
			},


			Armories = {
				{ x = -437.03, y = 5997.43, z = 30.72},  
			},

			Vehicles = {
				{
					Spawner    = { x = -457.35, y = 6018.48, z = 30.49 },
					SpawnPoint = { x = -462.22, y = 6020.98, z = 30.34},
					Heading    = 318.17
				},
			},
			VehicleDeleters = {
				{ x = -471.27, y = 6010.99, z = 30.34},
			},

			BossActions = {
				{ x = -447.16, y = 6014.29, z = 35.51},
			},
	}

}

Config.Dzwonek = {
    MissionRowPD = {
        Coords = { x = 441.29, y = -981.81, z = 31.99 },
    },
}

Config.ClothesZone = {
	{x = 462.89, y = -996.45, z = 29.69}, --MR
}

Config.Ilosc = {
	{x = 439.36, y = -985.48, z = 30.89},
}

Config.RepairVeh = {
	{x = 426.66, y = -979.40, z =  24.46}, --MR

}
 
Config.HeliZones = {
	PoliceHeliGarage = {
		Pos = {
			{x = 448.65,  y = -981.25, z = 43.69}, --MR
		}
	}
}
Config.BoatZones = {
	PoliceBoatGarage = {
		Pos = {
			{x = 1538.69,  y = 3901.5, z = 30.35},
			{x = 2000.42,  y = 4500, z = 33.437}
		}
	}
}

Config.ExtraZones = {
	ExtraPositions = {
		Pos = {
			{x = 436.76,  y = -994.22, z = 25.7}, --MR
			{x = 445.93,  y = -994.23, z = 25.7}, --MR
		}
	}
}

Config.Helicopters = {
	{ model = 'polmav', label = 'Police Maverick', livery = 2 }
}
Config.Boats = {
	{ model = 'predator', label = 'Police Predator', livery = 0 }
}

Config.VehicleGroups = {
	'ADAM', -- 1
	'MARY', -- 2
	'OFF-ROAD', -- 3
	'TASK', -- 4
	'EDWARD', -- 5
	'UNMARKED', -- 6
	'SERT', -- 7

}

Config.LodzieGroups = {
	'Łodzie', -- 1
	'Pościgowe', -- 2
}

-- https://wiki.rage.mp/index.php?title=Vehicles
Config.AuthorizedVehicles = {
	
		--- ADAM ---
		{
			grade = 0,
			model = 'pd_96cv',
			label = 'Crown Victoria 1996',
			groups = {1},
			livery = 0,
			extrason = {},
			extrasoff = {},
		},

		{
			grade = 3,
			model = 'pd_charger18',
			label = 'Dodge Charger 2018',
			groups = {1},
			livery = 0,
			extrason = {1,2,3,4,5,6,7},
			extrasoff = {},
		},
				
			--- MARY ---

		{
			grade = 1,
			model = 'policecross',
			label = 'Cross',
			groups = {2},
			livery = 0,
			extrason = {},
			extrasoff = {},
		},

		{
			grade = 1,
			model = 'pd_outlander',
			label = 'Quad',
			groups = {2},
			livery = 0,
			extrason = {},
			extrasoff = {},
		},
		
			--- BOY ---
	
		{
			grade = 1,
			model = 'f250lib',
			label = 'Ford F350 2017',
			groups = {3},
			livery = 0,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
			offroad = false
		},

		{
			grade = 1,
			model = 'pd_everest14',
			label = 'Ford Everest 2014',
			groups = {3},
			livery = 0,
			extrason = {1,2,3,4,5,6},
			extrasoff = {},
			--offroad = true
		},

		{
			grade = 2,
			model = '20silvbb',
			label = 'Chevrolet Silverado 2020',
			groups = {3},
			livery = 0,
			extrason = {1,2,3,4,5,6,7,8},
			extrasoff = {9},
			offroad = true
		},

		{
			grade = 6,
			model = 'fj',
			label = 'Toyota FJ Cruiser',
			groups = {3},
			livery = 0,
			extrason = {1,2,3,4,5,6,7,10,11},
			extrasoff = {},
			offroad = false
		},

		{
			grade = 7,
			model = 'pd_tahoe21',
			label = 'Chevrolet Tahoe 2021',
			groups = {3},
			livery = 0,
			extrason = {1,2,3,4,5,6,7,8},
			extrasoff = {},
			--offroad = false
		},

		{
			grade = 8,
			model = '18srt',
			label = 'Dodge Durango 2018',
			groups = {3},
			livery = 0,
			extrason = {1,2,3,4,5,6,7,8,9,10,11},
			extrasoff = {},
			offroad = false
		},

		{
			grade = 9,
			model = 'pd_bronco',
			label = 'Ford Bronco',
			groups = {3},
			livery = 0,
			extrason = {1,4,5,6},
			extrasoff = {3},
			--offroad = true
		},
	
			--- TASK ---

		{
			grade = 1,
			model = 'riot',
			label = 'Riot',
			groups = {4},
			livery = 0,
			extrason = {1},
			extrasoff = {},
			offroad = true
		},

		{
			grade = 1,
			model = 'pbus',
			label = 'Autobus',
			groups = {4},
			livery = 0,
			extrason = {},
			extrasoff = {},
		},

			--- UNMARKED ---
		{
			grade = 0,
			model = 'hellcatum',
			label = 'Dodge Charger Hellcat',
			groups = {6},
			livery = 0,
			extrason = {},
			extrasoff = {1,2,3,4,5,6},
		},

		{
			grade = 0,
			model = 'challengerum',
			label = 'Dodge Challenger',
			groups = {6},
			livery = 0,
			extrason = {},
			extrasoff = {1},
		},

		{
			grade = 0,
			model = 'ngt19',
			label = 'Nissan gtr',
			groups = {6},
			livery = 0,
			extrason = {1,2},
			extrasoff = {3},
		},

		{
			grade = 0,
			model = '19mustang',
			label = 'Ford Mustang Shelby',
			groups = {6},
			livery = 0,
			extrason = {},
			extrasoff = {1,2,3,4,5,6,7,8,9},
		},

		{
			grade = 0,
			model = 'unmar2020',
			label = 'Ford explorer',
			groups = {6},
			livery = 0,
			extrason = {},
			extrasoff = {},
		},
	
		{
			grade = 0,
			model = '19sierra',
			label = 'GMC Sierra',
			groups = {6},
			livery = 0,
			extrason = {},
			extrasoff = {1,2,3,4},
		},

		{
			grade = 0,
			model = 'uctaxi',
			label = 'Ford Crown Victoria',
			groups = {6},
			livery = 0,
			extrason = {},
			extrasoff = {1},
		},

		{
			grade = 0,
			model = 'pd_300',
			label = 'Crysler 300',
			groups = {6},
			livery = 0,
			extrason = {},
			extrasoff = {1,2,3},
		},

			--- EDWARD ---
		{
			grade = 3,
			model = 'charglibk9',
			label = 'Dodge Charger K9 2018',
			groups = {5},
			livery = 0,
			extrason = {2,5,6,9},
			extrasoff = {1,3,7,8,10,11,12},
		},

		{
			grade = 3,
			model = 'policeb2',
			label = 'Ścigacz Policyjny',
			groups = {5},
			livery = 0,
			extrason = {1},
			extrasoff = {},
		},

		{
			grade = 4,
			model = 'polgs350',
			label = 'Lexus GS350',
			groups = {5},
			livery = 0,
			extrason = {1,2},
			extrasoff = {},
		},

		{
			grade = 4,
			model = 'ramlib',
			label = 'Dodge Ram 2500 2017',
			groups = {5},
			livery = 0,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
			offroad = true
		},

		{
			grade = 5,
			model = 'pd_kawasaki',
			label = 'Ścigacz Kawasaki',
			groups = {5},
			livery = 0,
			extrason = {1,2,3,4},
			extrasoff = {5,6},
		},

		{
			grade = 6,
			model = 'mustang19',
			label = 'Ford Mustang 2019',
			groups = {5},
			livery = 0,
			extrason = {1,2,3,4,5,6,7,8,9},
			extrasoff = {},
		},

		{
			grade = 8,
			model = '1raptor',
			label = 'Ford Raptor',
			groups = {5},
			livery = 0,
			extrason = {3,4,5,6,7,8,9},
			extrasoff = {1,2},
		},

		{
			grade = 9,
			model = 'zr1RB',
			label = 'Chevrolet Corvette ZR1',
			groups = {5},
			livery = 0,
			extrason = {1,2,3,4,5},
			extrasoff = {},
		},

		{
			grade = 9,
			model = 'pd_titan17',
			label = 'Nissan Titan',
			groups = {5},
			livery = 0,
			extrason = {1,2},
			extrasoff = {3},
		},

		{
			grade = 10,
			model = 'jeep',
			label = 'Jeep Grand Cherokee',
			groups = {5},
			livery = 0,
			extrason = {2,3,4,5,6,7,8},
			extrasoff = {9,10},
		},

		{
			grade = 10,
			model = 'pd_c8',
			label = 'Chevrolet Corvette C8',
			groups = {5},
			livery = 0,
			extrason = {1,2,3,4,5,6},
			extrasoff = {7,8,9},
		},

		{
			grade = 11,
			model = 'pd_camaro',
			label = 'Chevrolet Camaro',
			groups = {5},
			livery = 0,
			extrason = {1,2,3,4},
			extrasoff = {5,6,7,8,9},
		},

		{
			grade = 12,
			model = 'pd_charger69',
			label = 'Dodge Charger 1969',
			groups = {5},
			livery = 0,
			extrason = {1,3},
			extrasoff = {2},
		},
		{
			grade = 12,
			model = 'pd_rangerover',
			label = 'Range Rover',
			groups = {5},
			livery = 0,
			extrason = {1,2,3,4,5,6,7,8},
			extrasoff = {},
		},

		{
			grade = 12,
			model = 'pd_tesla',
			label = 'Tesla Model S',
			groups = {5},
			livery = 0,
			extrason = {1,2},
			extrasoff = {},
		},

		{
			hidden = true,
			grade = 3,
			model = 'charglibk9',
			label = '[SASD] Dodge Charger K9 2018',
			groups = {5},
			livery = 1,
			extrason = {2,5,6,9},
			extrasoff = {1,3,7,8,10,11,12},
		},

		{
			hidden = true,
			grade = 4,
			model = 'polgs350',
			label = '[SASD] Lexus GS350',
			groups = {5},
			livery = 2,
			extrason = {1,2},
			extrasoff = {},
		},

		{
			hidden = true,
			grade = 4,
			model = 'ramlib',
			label = '[SASD] Dodge Ram 2500 2017',
			groups = {5},
			livery = 1,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
			offroad = true
		},
		{
			hidden = true,
			grade = 6,
			model = 'mustang19',
			label = '[SASD] Ford Mustang 2019',
			groups = {5},
			livery = 1,
			extrason = {1,2,3,4,5,6,7,8,9},
			extrasoff = {},
		},
		{
			hidden = true,
			grade = 8,
			model = '1raptor',
			label = '[SASD] Ford Raptor',
			groups = {5},
			livery = 1,
			extrason = {3,4,5,6,7,8,9},
			extrasoff = {1,2},
		},
		{
			hidden = true,
			grade = 9,
			model = 'pd_titan17',
			label = '[SASD] Nissan Titan',
			groups = {5},
			livery = 1,
			extrason = {1,2},
			extrasoff = {3},
		},
		{
			hidden = true,
			grade = 10,
			model = 'jeep',
			label = '[SASD] Jeep Grand Cherokee',
			groups = {5},
			livery = 1,
			extrason = {2,3,4,5,6,7,8},
			extrasoff = {9,10},
		},
		
		--- SERT ---

		{
			grade = 3,
			model = 'charglibk9',
			label = '[SEU] Charger 2018',
			groups = {7},
			livery = 2,
			extrason = {2,5,6,9},
			extrasoff = {1,3,4,7,8,10,11,12},
			offroad = false,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 4,
			model = 'sub',
			label = 'Chevrolet Suburban',
			groups = {7},
			livery = 0,
			extrason = {2,3,4,5,6,7,10,11},
			extrasoff = {8,12},
			--offroad = true,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 4,
			model = 'NYFPIU',
			label = 'Ford Explorer',
			groups = {7},
			livery = 0,
			extrason = {1},
			extrasoff = {},
			--offroad = true,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 4,
			model = 'pd_gwagon',
			label = 'Mercedes G Class',
			groups = {7},
			livery = 0,
			extrason = {2,11},
			extrasoff = {3,6,7},
			--offroad = true,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 5,
			model = 'pd_escalader',
			label = 'Cadillac Escalade',
			groups = {7},
			livery = 0,
			extrason = {2,3,4,5},
			extrasoff = {},
			--offroad = true,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 5,
			model = 'h1',
			label = 'Hummer H1',
			groups = {7},
			livery = 0,
			extrason = {1,2,3,5,6,7,8,9},
			extrasoff = {},
			offroad = false,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 6,
			model = 'h2',
			label = 'Hummer H2',
			groups = {7},
			livery = 0,
			extrason = {},
			extrasoff = {12},
			--offroad = true,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 6,
			model = 'pd_sprinter',
			label = 'Sprinter',
			groups = {7},
			livery = 0,
			extrason = {1},
			extrasoff = {},
			--offroad = true,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 8,
			model = 'survivor',
			label = 'Survivor',
			groups = {7},
			livery = 0,
			extrason = {10},
			extrasoff = {},
			offroad = true,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 8,
			model = 'pd_insurgent',
			label = 'Insurgent',
			groups = {7},
			livery = 0,
			extrason = {1,2,3,4},
			extrasoff = {},
			--offroad = true,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 9,
			model = 'jeeppol',
			label = 'Jeep Wrangler',
			groups = {7},
			livery = 2,
			extrason = {1,2,3,4,5,6,7,8,9,10,12},
			extrasoff = {},
			--offroad = true,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 10,
			model = 'pd_hummerSU',
			label = 'Hummer H1 Alpha',
			groups = {7},
			livery = 1,
			extrason = {2,3,9},
			extrasoff = {1},
			--offroad = true,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 11,
			model = 'camarorb',
			label = 'Chevrolet Camaro',
			groups = {7},
			livery = 1,
			extrason = {2,3,4,5,6,7,8,9,10,11,12},
			extrasoff = {1},
			--offroad = true,
			bulletproof = true,
			tint = 1
		},

		{
			grade = 12,
			model = 'pd_entry',
			label = 'Łazik SWAT',
			groups = {7},
			livery = 0,
			extrason = {1,2,5,10},
			extrasoff = {3},
			--offroad = true,
			bulletproof = true,
			tint = 1
		},

		-- SHERIFF
		{
			hidden = true,
			grade = 0,
			model = 'cvpilib',
			label = '[SASD] Crown Victoria 2011',
			groups = {8},
			livery = 1,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
		},
		{
			hidden = true,
			grade = 1,
			model = 'charglib3',
			label = '[SASD] Dodge Charger 2010',
			groups = {8},
			livery = 1,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
		},
		
		{
			hidden = true,
			grade = 2,
			model = 'charglib2',
			label = '[SASD] Dodge Charger 2014',
			groups = {8},
			livery = 1,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
		},
		{
			hidden = true,
			grade = 2,
			model = '20silvbb',
			label = '[SASD] Chevrolet Silverado 2020',
			groups = {8},
			livery = 1,
			extrason = {1,2,3,4,5,6,7,8},
			extrasoff = {9},
			offroad = true
		},
	
		{
			hidden = true,
			grade = 3,
			model = 'pd_charger18',
			label = '[SASD] Dodge Charger 2018',
			groups = {8},
			livery = 2,
			extrason = {1,2,3,4,5,6,7},
			extrasoff = {},
		},
		{
			hidden = true,
			grade = 3,
			model = 'tarlib',
			label = '[SASD] Ford Taurus 2013',
			groups = {8},
			livery = 1,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
		},
		{
			hidden = true,
			grade = 3,
			model = 'taholib',
			label = '[SASD] Chevy Tahoe 2016',
			groups = {8},
			livery = 1,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
			offroad = true
		},
		{
			hidden = true,
			grade = 5,
			model = 'sierralib',
			label = '[SASD] GMC Sierra 2015',
			groups = {8},
			livery = 1,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
			offroad = true
		},
		{
			hidden = true,
			grade = 6,
			model = 'fj',
			label = '[SASD] Toyota FJ Cruiser',
			groups = {8},
			livery = 2,
			extrason = {1,2,3,4,5,6,7,10,11},
			extrasoff = {},
		},

		{
			hidden = true,
			grade = 6,
			model = 'silvlib',
			label = '[SASD] Chevrolet Silverado 2017',
			groups = {8},
			livery = 1,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
			offroad = true
		},
		{
			hidden = true,
			grade = 7,
			model = 'explib3',
			label = '[SASD] Ford Explorer 2020',
			groups = {8},
			livery = 1,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
			offroad = true
		},
		{
			hidden = true,
			grade = 8,
			model = '17zr2bb',
			label = '[SASD] Chevrolet Colorado',
			groups = {8},
			livery = 1,
			extrason = {1,2,3,4,5,6},
			extrasoff = {},
			offroad = false
		},
		{
			hidden = true,
			grade = 8,
			model = '18srt',
			label = '[SASD] Dodge Durango 2018',
			groups = {8},
			livery = 2,
			extrason = {1,2,3,4,5,6,7,8,9,10,11},
			extrasoff = {},
			offroad = false
		},

		{
			hidden = true,
			grade = 13,
			model = 'pd_rangerover', 
			label = '[SASD] Range Rover',
			groups = {8},
			livery = 0,
			extrason = {1,2,3,4,5,6,7,8},
			extrasoff = {},
		},
		
		{
			hidden = true,
			grade = 13,
			model = 'pd_charger69', 
			label = '[SASD] Dodge Charger 1969',
			groups = {8},
			livery = 0,
			extrason = {1,3},
			extrasoff = {2},
		},


		---USMS---

        {
			grade = 1,
			model = 'van',
			label = 'Chevrolet Express [Bus transportowy]',
			groups = {9},
			livery = 0,
			extrason = {},
			extrasoff = {},
			offroad = false
		},
		{
			grade = 1,
			model = 'f250lib',
			label = 'Ford F350 2017',
			groups = {9},
			livery = 3,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
			offroad = false
		},
		{
			grade = 2,
			model = '20silvbb',
			label = 'Chevrolet Silverado 2020',
			groups = {9},
			livery = 3,
			extrason = {1,2,3,4,5,6,7,8},
			extrasoff = {9},
			offroad = true
		},
		{
			grade = 2,
			model = 'charglib2',
			label = 'Dodge Charger 2014',
			groups = {9},
			livery = 3,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
		},
		{
			grade = 3,
			model = 'pd_charger18',
			label = 'Dodge Charger 2018',
			groups = {9},
			livery = 3,
			extrason = {1,2,3,4,5,6,7},
			extrasoff = {},
		},
		{
			grade = 3,
			model = 'pd_fusion16',
			label = 'Ford Fusion 2016',
			groups = {9},
			livery = 2,
			extrason = {1,2,3,4,5,7,8,9,10,11,12},
			extrasoff = {6},
		},
		{
			grade = 7,
			model = 'pd_tahoe21',
			label = 'Chevrolet Tahoe 2021',
			groups = {9},
			livery = 2,
			extrason = {1,2,3,4,5,6,7,8},
			extrasoff = {},
			--offroad = false
		},
		{
			grade = 8,
			model = '18srt',
			label = 'Dodge Durango 2018',
			groups = {9},
			livery = 3,
			extrason = {1,2,3,4,5,6,7,8,9,10,11},
			extrasoff = {},
			offroad = false
		},
		{
			grade = 4,
			model = 'ramlib',
			label = '[SEU] Dodge Ram 2500 2017',
			groups = {9},
			livery = 3,
			extrason = {1,2,3,5,6,7,8,9,10,11,12},
			extrasoff = {},
			offroad = true
		},
		{
			grade = 6,
			model = 'mustang19',
			label = '[SEU] Ford Mustang 2019',
			groups = {9},
			livery = 3,
			extrason = {1,2,3,4,5,6,7,8,9},
			extrasoff = {},
		},
		{
			grade = 8,
			model = '1raptor',
			label = '[SEU] Ford Raptor',
			groups = {9},
			livery = 3,
			extrason = {3,4,5,6,7,8,9},
			extrasoff = {1,2},
		},

	}
	
	Config.AuthorizedLodzie = {
		{
			grade = 1,
			model = 'pd_boat1',
			label = 'Ponton',
			groups = {1},
			livery = 0
		},
		{
			grade = 1,
			model = 'pd_boat2',
			label = 'Transportowa',
			groups = {1},
			livery = 0
		},
		{
			grade = 1,
			model = 'pd_boat3',
			label = 'Skuter Wodny',
			groups = {1},
			livery = 0
		},
	}

Config.Uniforms = {
	-- PODSTAWOWE STROJE 
	kadet = {
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
                        ['torso_1'] = 319,  ['torso_2'] = 0,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] =  11,   
                        ['pants_1'] = 35,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,      ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['bproof_1'] = 58,     ['bproof_2'] = 0,
                        ['mask_1'] = 0,      ['mask_2'] = 0,
                        ['ears_1'] = 46,     ['ears_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['glass_1'] = 5,     ['glass_2'] = 3		},
	  	female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 322,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 30,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 134,  ['helmet_2'] = 1,
			['bproof_1'] = 0,     ['bproof_2'] = 0,
			['mask_1'] = 121,      ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		}
	},
	oficershort = {
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
                        ['torso_1'] = 422,  ['torso_2'] = 0,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] =  6,   
                        ['pants_1'] = 31,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,      ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['bproof_1'] = 92,     ['bproof_2'] = 0,
                        ['mask_1'] = 0,      ['mask_2'] = 0,
                        ['ears_1'] = 46,     ['ears_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['glass_1'] = 5,     ['glass_2'] = 3
		},
		female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 328,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 30,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 134,  ['helmet_2'] = 1,
			['bproof_1'] = 0,     ['bproof_2'] = 0,
			['mask_1'] = 121,      ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		}
	},
	sierzantshort = {
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
                        ['torso_1'] = 423,  ['torso_2'] = 0,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] =  11,   
                        ['pants_1'] = 31,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,      ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['bproof_1'] = 89,     ['bproof_2'] = 0,
                        ['mask_1'] = 0,      ['mask_2'] = 0,
                        ['ears_1'] = 46,     ['ears_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['glass_1'] = 5,     ['glass_2'] = 3
		},
		female = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
                        ['torso_1'] = 316,  ['torso_2'] = 2,
                        ['decals_1'] = 2,   ['decals_2'] = 0,
                        ['arms'] =  6,   
                        ['pants_1'] = 35,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,      ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['bproof_1'] = 38,     ['bproof_2'] = 0,
                        ['mask_1'] = 0,      ['mask_2'] = 0,
                        ['ears_1'] = 46,     ['ears_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['glass_1'] = 5,     ['glass_2'] = 3
		}
	},
	sierzantboj = {
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
                        ['torso_1'] = 316,  ['torso_2'] = 2,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] =  6,   
                        ['pants_1'] = 35,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,      ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['bproof_1'] = 38,     ['bproof_2'] = 0,
                        ['mask_1'] = 0,      ['mask_2'] = 0,
                        ['ears_1'] = 46,     ['ears_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['glass_1'] = 5,     ['glass_2'] = 3
	   },
	   female = {
		   ['tshirt_1'] = 152,  ['tshirt_2'] = 0,
		   ['torso_1'] = 328,   ['torso_2'] = 0,
		   ['decals_1'] = 0,   ['decals_2'] = 0,
		   ['arms'] = 44,
		   ['pants_1'] = 30,   ['pants_2'] = 0,
		   ['shoes_1'] = 25,   ['shoes_2'] = 0,
		   ['helmet_1'] = 134,  ['helmet_2'] = 1,
		   ['bproof_1'] = 0,     ['bproof_2'] = 0,
		   ['mask_1'] = 121,      ['mask_2'] = 0,
		   ['chain_1'] = 0,    ['chain_2'] = 0,
		   ['ears_1'] = -1,     ['ears_2'] = 0
	   }
   },
	porucznikshort = {
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
                        ['torso_1'] = 423,  ['torso_2'] = 0,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] =  11,   
                        ['pants_1'] = 31,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,      ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['bproof_1'] = 87,     ['bproof_2'] = 0,
                        ['mask_1'] = 0,      ['mask_2'] = 0,
                        ['ears_1'] = 46,     ['ears_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['glass_1'] = 5,     ['glass_2'] = 3
		},
		female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 328,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 30,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 134,  ['helmet_2'] = 1,
			['bproof_1'] = 0,     ['bproof_2'] = 0,
			['mask_1'] = 121,      ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		}
	},
	porucznikboj = {    
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
                        ['torso_1'] = 316,  ['torso_2'] = 4,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] =  6,   
                        ['pants_1'] = 35,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,      ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['bproof_1'] = 38,     ['bproof_2'] = 0,
                        ['mask_1'] = 0,      ['mask_2'] = 0,
                        ['ears_1'] = 46,     ['ears_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['glass_1'] = 5,     ['glass_2'] = 3
	   },
	   female = {
		   ['tshirt_1'] = 152,  ['tshirt_2'] = 0,
		   ['torso_1'] = 328,   ['torso_2'] = 1,
		   ['decals_1'] = 0,   ['decals_2'] = 0,
		   ['arms'] = 44,
		   ['pants_1'] = 30,   ['pants_2'] = 0,
		   ['shoes_1'] = 25,   ['shoes_2'] = 0,
		   ['helmet_1'] = 134,  ['helmet_2'] = 1,
		   ['bproof_1'] = 0,     ['bproof_2'] = 0,
		   ['mask_1'] = 121,      ['mask_2'] = 0,
		   ['chain_1'] = 0,    ['chain_2'] = 0,
		   ['ears_1'] = -1,     ['ears_2'] = 0
	   }
   },
	kapitanshort = {
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
                        ['torso_1'] = 423,  ['torso_2'] = 0,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] =  11,   
                        ['pants_1'] = 31,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,      ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['bproof_1'] = 82,     ['bproof_2'] = 0,
                        ['mask_1'] = 0,      ['mask_2'] = 0,
                        ['ears_1'] = 46,     ['ears_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['glass_1'] = 5,     ['glass_2'] = 3
		},
		female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 324,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 130,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['mask_1'] = 0,  	['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	kapitanboj = {
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
                        ['torso_1'] = 316,  ['torso_2'] = 8,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] =  6,   
                        ['pants_1'] = 35,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,      ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['bproof_1'] = 38,     ['bproof_2'] = 0,
                        ['mask_1'] = 0,      ['mask_2'] = 0,
                        ['ears_1'] = 46,     ['ears_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['glass_1'] = 5,     ['glass_2'] = 3
	   },
	   female = {
		   ['tshirt_1'] = 152,  ['tshirt_2'] = 0,
		   ['torso_1'] = 328,   ['torso_2'] = 1,
		   ['decals_1'] = 0,   ['decals_2'] = 0,
		   ['arms'] = 44,
		   ['pants_1'] = 30,   ['pants_2'] = 0,
		   ['shoes_1'] = 25,   ['shoes_2'] = 0,
		   ['helmet_1'] = 134,  ['helmet_2'] = 1,
		   ['bproof_1'] = 0,     ['bproof_2'] = 0,
		   ['mask_1'] = 121,      ['mask_2'] = 0,
		   ['chain_1'] = 0,    ['chain_2'] = 0,
		   ['ears_1'] = -1,     ['ears_2'] = 0
	   }
   },
	commandershort = {
		male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
                        ['torso_1'] = 423,  ['torso_2'] = 0,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] =  11,   
                        ['pants_1'] = 31,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,      ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['bproof_1'] = 87,     ['bproof_2'] = 0,
                        ['mask_1'] = 0,      ['mask_2'] = 0,
                        ['ears_1'] = 46,     ['ears_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['glass_1'] = 5,     ['glass_2'] = 3
		},
		female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 328,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 30,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 134,  ['helmet_2'] = 1,
			['bproof_1'] = 0,     ['bproof_2'] = 0,
			['mask_1'] = 121,      ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		}
	},
	commanderlong = {
		male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
                        ['torso_1'] = 305,  ['torso_2'] = 1,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] =  4,   
                        ['pants_1'] = 31,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,      ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['bproof_1'] = 93,     ['bproof_2'] = 0,
                        ['mask_1'] = 0,      ['mask_2'] = 0,
                        ['ears_1'] = 46,     ['ears_2'] = 0,
                        ['bags_1'] = 0,     ['bags_2'] = 0,
                        ['glass_1'] = 5,     ['glass_2'] = 3
		},
		female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 328,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 30,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 134,  ['helmet_2'] = 1,
			['bproof_1'] = 0,     ['bproof_2'] = 0,
			['mask_1'] = 121,      ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		}
	},
	galowy = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 111,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 24,   ['pants_2'] = 2,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,      ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['bproof_1'] = 0,     ['bproof_2'] = 0,
			['mask_1'] = 0,      ['mask_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bags_1'] = 0,     ['bags_2'] = 0,
			['glass_1'] = 5,     ['glass_2'] = 3
		},
		female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 324,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 130,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['mask_1'] = 0,  	['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	motocykl = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 294,   ['torso_2'] = 1,
			['decals_1'] = 0,  ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 131,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['bproof_1'] = 0,   ['bproof_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bags_1'] = 0, 	['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 324,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 130,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['mask_1'] = 0,  	['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	aiad = {
		male = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0,
			['torso_1'] = 294,   ['torso_2'] = 1,
			['decals_1'] = 0,  ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 131,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['bproof_1'] = 0,   ['bproof_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,     ['mask_2'] = 0,
			['bags_1'] = 0, 	['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 324,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 130,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['mask_1'] = 0,  	['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	swatalways = {
		male = {
			['tshirt_1'] = 1,  ['tshirt_2'] = 0,
			['torso_1'] = 394,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 33,
			['pants_1'] = 31,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 119,      ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['bproof_1'] = 28,     ['bproof_2'] = 0,
			['mask_1'] = 104,      ['mask_2'] = 25,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bags_1'] = 0,     ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 324,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 130,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['bproof_1'] = 40,     ['bproof_2'] = 0,
			['mask_1'] = 0,      ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	swatlight = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 98,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 35,
			['pants_1'] = 88,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 119,      ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['bproof_1'] = 79,     ['bproof_2'] = 0,
			['mask_1'] = 104,      ['mask_2'] = 25,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bags_1'] = 0,     ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 324,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 130,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['bproof_1'] = 40,     ['bproof_2'] = 0,
			['mask_1'] = 0,      ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	swatheavy = {
		male = {
			['tshirt_1'] = 97,  ['tshirt_2'] = 3,
			['torso_1'] = 324,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 35,
			['pants_1'] = 84,   ['pants_2'] = 0,
			['shoes_1'] = 60,   ['shoes_2'] = 0,
			['helmet_1'] = 119,      ['helmet_2'] = 0,
			['chain_1'] = -1,    ['chain_2'] = 0,
			['bproof_1'] = 44,     ['bproof_2'] = 2,
			['mask_1'] = 104,      ['mask_2'] = 25,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bags_1'] = 0,     ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 152,  ['tshirt_2'] = 0,
			['torso_1'] = 324,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 14,
			['pants_1'] = 130,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 0,
			['bproof_1'] = 40,     ['bproof_2'] = 0,
			['mask_1'] = 0,      ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	-- KAMIZELKI
	kadet2 = {
		male = {
			['bproof_1'] = 58, ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 12, ['bproof_2'] = 0
		}
	},
	oficer2 = {
		male = {
			['bproof_1'] = 85, ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 17, ['bproof_2'] = 0
		}
	},
	sierzant2 = {
		male = {
			['bproof_1'] = 82,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 7,  ['bproof_2'] = 0
		}
	},
	porucznik2 = {
		male = {
			['bproof_1'] = 87,  ['bproof_2'] = 1
		},
		female = {
			['bproof_1'] = 12,  ['bproof_2'] = 1
		}
	},
	kapitan2 = {
		male = {
			['bproof_1'] = 87,  ['bproof_2'] = 4
		},
		female = {
			['bproof_1'] = 12,  ['bproof_2'] = 4
		}
	},	
	aiad2 = {
		male = {
			['bproof_1'] = 57,  ['bproof_2'] = 4
		},
		female = {
			['bproof_1'] = 7,  ['bproof_2'] = 4
		}
	},	
	swat2 = {
		male = {
			['bproof_1'] = 87,  ['bproof_2'] = 4
		},
		female = {
			['bproof_1'] = 7,  ['bproof_2'] = 4
		}
	},	
	swm2 = {
		male = {
			['bproof_1'] = 7,  ['bproof_2'] = 4
		},
		female = {
			['bproof_1'] = 7,  ['bproof_2'] = 4
		}
	}
}