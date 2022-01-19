ESX				= nil
local DoorInfo	= {}
local doors = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_doorlock:updateState')
AddEventHandler('esx_doorlock:updateState', function(id, state)
	local xPlayer = ESX.GetPlayerFromId(source)
	doors[id].locked = state 
	TriggerClientEvent('esx_doorlock:update', -1, id, state)
end)

ESX.RegisterServerCallback('esx_door:get', function(source, cb)
	doors = {

	-- KOMENDA MISSON ROW
	[1] = { objects = {
		[1] = {
			object = 'gabz_mrpd_reception_entrancedoor',
			x = 434.7444, 
			y = -980.7556, 
			z = 30.8153
		},
		[2] = {
			object = 'gabz_mrpd_reception_entrancedoor',
			x = 434.7444, 
			y = -983.0781, 
			z = 30.8153
		},
	},
	position = vector3(434.7548, -981.9033, 30.88926),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = true,},locked = false,distance = 1.45,size = 0.6, can = false, draw = true},


	[2] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_05',
			x = 440.5201, 
			y = -986.2335, 
			z = 30.82319
		},
	},
	position = vector3(441.7201, -986.2335, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},

	[3] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_04',
			x = 440.5201, 
			y = -977.6011,
			z = 30.82319
		},
	},
	position = vector3(441.5201, -977.6011, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},	

	[4] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_04',
			x = 445.4067, 
			y = -984.2014,
			z = 30.82319
		},
	},
	position = vector3(445.4067, -983.2014, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},		

	[5] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_01',
			x = 438.1971, 
			y = -993.9113,
			z = 30.82319
		},
		[2] = {
			object = 'gabz_mrpd_door_01',
			x = 438.1971, 
			y = -996.3167,
			z = 30.82319
		},
	},
	position = vector3(438.1971, -995.1113, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},
	
	[6] = { objects = {
		[1] = {
			object = 'gabz_mrpd_reception_entrancedoor',
			x = 440.7392,
			y = -998.7462,
			z = 30.8153
		},
		[2] = {
			object = 'gabz_mrpd_reception_entrancedoor',
			x = 443.0618,
			y = -998.7462,
			z = 30.8153
		},
	},
	position = vector3(441.9392, -998.7462, 30.8753),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},

	[7] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_05',
			x = 452.2663,
			y = -995.5254,
			z = 30.82319
		},
	},
	position = vector3(453.0863, -996.3454, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},	
	
	[8] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_02',
			x = 458.0894,
			y = -995.5247,
			z = 30.82319
		},
	},
	position = vector3(457.2894, -996.3247, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},

	[9] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_05',
			x = 458.6543,
			y = -990.6498,
			z = 30.82319
		},
	},
	position = vector3(458.6543, -989.5498, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},

	[10] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_04',
			x = 458.6543,
			y = -976.8864,
			z = 30.82319
		},
	},
	position = vector3(458.6543, -977.9864, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},

	[11] = { objects = {
		[1] = {
			object = 'gabz_mrpd_reception_entrancedoor',
			x = 455.8862,
			y = -972.2543,
			z = 30.81531
		},
		[2] = {
			object = 'gabz_mrpd_reception_entrancedoor',
			x = 458.2087,
			y = -972.2543,
			z = 30.81531
		},
	},
	position = vector3(457.0562, -972.2543, 30.87531),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},

	[12] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_01',
			x = 469.4406,
			y = -985.0313,
			z = 30.82319
		},
		[2] = {
			object = 'gabz_mrpd_door_01',
			x = 469.4406,
			y = -987.4377,
			z = 30.82319
		},
	},

	position = vector3(469.4406, -986.2477, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},

	[13] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_02',
			x = 472.9781,
			y = -984.3722,
			z = 30.82319
		},
		[2] = {
			object = 'gabz_mrpd_door_02',
			x = 475.3837,
			y = -984.3722,
			z = 30.82319
		},
	},
	position = vector3(474.1781, -984.3722, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,},locked = true,distance = 1.45,size = 0.6, can = false, draw = true},	
	
	[14] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_04',
			x = 475.3837,
			y = -989.8247,
			z = 30.82319
		},
		[2] = {
			object = 'gabz_mrpd_door_05',
			x = 472.9777,
			y = -989.8247,
			z = 30.82319
		},
	},
	position = vector3(474.1877, -989.8247, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[15] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_04',
			x = 476.7512,
			y = -999.6307,
			z = 30.82319
		},
	},
	position = vector3(476.7512, -998.5307, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},	
	
	[16] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_03',
			x = 479.7507,
			y = -999.629,
			z = 30.78917
		},
	},
	position = vector3(479.7507, -998.5307, 30.86917),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},	

	[17] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_03',
			x = 487.4378,
			y = -1000.189,
			z = 30.78697
		},
	},
	position = vector3(486.2378, -1000.189, 30.86697),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},	
	
	[18] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_03',
			x = 488.0184,
			y = -1002.902,
			z = 30.78697
		},
		[2] = {
			object = 'gabz_mrpd_door_03',
			x = 485.6133,
			y = -1002.902,
			z = 30.78697
		},
	},
	position = vector3(486.8133, -1002.902, 30.86697),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[19] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_04',
			x = 479.7534,
			y = -986.2151,
			z = 30.82319
		},
		[2] = {
			object = 'gabz_mrpd_door_05',
			x = 479.7534,
			y = -988.6204,
			z = 30.82319
		},
	},
	position = vector3(479.7534, -987.4151, 30.88319),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[20] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_01',
			x = 469.9274,
			y = -1000.544,
			z = 26.40548
		},
		[2] = {
			object = 'gabz_mrpd_door_01',
			x = 467.5222,
			y = -1000.544,
			z = 26.40548
		},
	},
	position = vector3(468.7274, -1000.544, 26.48548),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
	
	[21] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_02',
			x = 471.3679,
			y = -1007.7930,
			z = 26.40548
		},
		[2] = {
			object = 'gabz_mrpd_door_02',
			x = 471.3758,
			y = -1010.198,
			z = 26.40548
		},
	},
	position = vector3(471.3679, -1008.9930, 26.48548),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[22] = { objects = {
		[1] = {
			object = 'gabz_mrpd_cells_door',
			x = 476.6157,
			y = -1008.875,
			z = 26.48005
		},
	},
	position = vector3(476.6157, -1007.6750, 26.56005),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[23] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_01',
			x = 475.9539, 
			y = -1006.938,
			z = 26.40639
		},
	},
	position = vector3(474.7539, -1006.938, 26.48639),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[24] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_04',
			x = 475.9539,
			y = -1010.819,
			z = 26.40639
		},
	},
	position = vector3(474.7539, -1010.819, 26.48639),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[25] = { objects = {
		[1] = {
			object = 'gabz_mrpd_cells_door',
			x = 477.9126, 
			y = -1012.189,
			z = 26.48005
		},
	},
	position = vector3(476.7126, -1012.189, 26.56005),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[26] = { objects = {
		[1] = {
			object = 'gabz_mrpd_cells_door',
			x = 480.9128, 
			y = -1012.189,
			z = 26.48005
		},
	},
	position = vector3(479.7128, -1012.189, 26.56005),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
	
	[27] = { objects = {
		[1] = {
			object = 'gabz_mrpd_cells_door',
			x = 483.9127, 
			y = -1012.189,
			z = 26.48005
		},
	},
	position = vector3(482.7127, -1012.189, 26.56005),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
	
	[28] = { objects = {
		[1] = {
			object = 'gabz_mrpd_cells_door',
			x = 486.9131, 
			y = -1012.189,
			z = 26.48005
		},
	},
	position = vector3(485.7137, -1012.189, 26.56005),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
	
	[29] = { objects = {
		[1] = {
			object = 'gabz_mrpd_cells_door',
			x = 484.1764, 
			y = -1007.734,
			z = 26.48005
		},
	},
	position = vector3(485.3764, -1007.734, 26.56005),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
	
	[30] = { objects = {
		[1] = {
			object = 'gabz_mrpd_cells_door',
			x = 481.0084,
			y = -1004.118,
			z = 26.48005
		},
	},
	position = vector3(482.2084, -1004.118, 26.56005),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
	
	[31] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_01',
			x = 479.0600, 
			y = -1003.173,
			z = 26.4065
		},
	},
	position = vector3(479.0600, -1001.973, 26.48650),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[31] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_02',
			x = 479.6638,
			y = -997.91,
			z = 26.4065,
		},
		[2] = {
			object = 'gabz_mrpd_door_02',
			x = 482.0686,
			y = -997.91,
			z = 26.4065,
		}
	},
	position = vector3(480.8638, -997.91, 26.4865),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
	
	[32] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_04',
			x = 482.6703,
			y = -995.7285,
			z = 26.40548
		},
	},
	position = vector3(482.6703, -996.9285, 26.48548),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
	
	[33] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_04',
			x = 482.6699,
			y = -992.2991,
			z = 26.40548 
		},
	},
	position = vector3(482.6703, -993.4991, 26.48548),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[34] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_04',
			x = 482.6701, 
			y = -987.5792,
			z = 26.40548
		},
	},
	position = vector3(482.6701, -988.7792, 26.48548),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[35] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_04',
			x = 482.6701, 
			y = -983.9868,
			z = 26.40548
		},
	},
	position = vector3(482.6701, -985.1868, 26.48548),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[36] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_02',
			x = 479.0624, 
			y = -985.0323,
			z = 26.40548
		},
		[2] = {
			object = 'gabz_mrpd_door_02',
			x = 479.0624, 
			y = -987.4376,
			z = 26.40548
		},
	},
	position = vector3(479.0624, -986.2376, 26.48548),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
	
	[37] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_03',
			x = 475.8323,
			y = -990.4839,
			z = 26.40548
		},
	},
	position = vector3(475.0323, -989.6839, 26.48548),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},	

	[38] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_02',
			x = 478.2892,
			y = -997.9101,
			z = 26.40548
		},
	},
	position = vector3(477.0892, -997.9101, 26.48548),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[39] = { objects = {
		[1] = {
			object = 'gabz_mrpd_door_05',
			x = 471.3753,
			y = -987.4374,
			z = 26.40548
		},
		[2] = {
			object = 'gabz_mrpd_door_04',
			x = 471.3753,
			y = -985.0319,
			z = 26.40548 
		},
	},
	position = vector3(471.3753, -986.2319, 26.48548),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[40] = { objects = {
		[1] = {
			object = 'gabz_mrpd_room13_parkingdoor',
			x = 464.1566,
			y = -997.5093,
			z = 26.3707
		},
	},
	position = vector3(464.1566, -996.3093, 26.4507),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[41] = { objects = {
		[1] = {
			object = 'gabz_mrpd_room13_parkingdoor',
			x = 464.1591,
			y = -974.6656,
			z = 26.3707 
		},
	},
	position = vector3(464.1591, -975.8656, 26.4507),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	[42] = { objects = { 
		[1] = {
			object = 'gabz_mrpd_garage_door',
			x = 452.3005,
			y = -1000.772,
			z = 26.69661
		} 
	},
	position = vector3(452.3005, -1000.772, 26.69661),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = true,}, locked = true, distance = 4.00,size = 1.5, can = false, draw = true, gate = true},


[43] = { objects = { 
	[1] = {
		object = 'gabz_mrpd_bollards2',
		x = 410.0258,
		y = -1032.423,
		z = 29.25253
	},
	[2] = {
		object = 'gabz_mrpd_bollards1',
		x = 410.0258,
		y = -1024.226,
		z = 29.22022
	} 
},
position = vector3(411.48, -1024.27, 29.46),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = true,}, locked = true, distance = 8.00,size = 1.5, can = false, draw = true, gate = true},

[44] = { objects = { 
	[1] = {
		object = 'gabz_mrpd_garage_door',
		x = 452.3005,
		y = -1000.772,
		z = 26.69661
	} 
},
position = vector3(452.3005, -1000.772, 26.69661),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = true,}, locked = true, distance = 4.00,size = 1.5, can = false, draw = true, gate = true},

[45] = { objects = { 
	[1] = {
		object = 'gabz_mrpd_garage_door',
		x = 431.4119,
		y = -1000.772,
		z = 26.69661
	} 
},
position = vector3(431.4119, -1000.772, 26.69661),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = true,}, locked = true, distance = 4.00,size = 1.5, can = false, draw = true, gate = true},

[46] = { objects = { 
	[1] = {
		object = 'gabz_mrpd_bollards1',
		x = 466.6598,
		y = -1028.592,
		z = 28.11831
	} 
},
position = vector3(466.48, -1024.53, 28.27),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = true,}, locked = true, distance = 4.00,size = 1.5, can = false, draw = true, gate = true},

[47] = { objects = {
	[1] = {
		object = 'gabz_mrpd_door_03',
		x = 469.7743,
		y = -1014.406,
		z = 26.48382
	},
	[2] = {
		object = 'gabz_mrpd_door_03',
		x = 467.3686,
		y = -1014.406,
		z = 26.48382
	}
},
position = vector3(468.5743, -1014.406, 26.56382),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[48] = { objects = {
	[1] = {
		object = 'gabz_mrpd_door_05',
		x = 459.9454,
		y = -990.7053,
		z = 35.10398
	},
},
position = vector3(458.7454, -990.7053, 35.18398),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[49] = { objects = {
	[1] = {
		object = 'gabz_mrpd_door_04',
		x = 459.9454,
		y = -981.0742,
		z = 35.10398
	},
},
position = vector3(458.7454, -981.0742, 35.18398),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[50] = { objects = {
	[1] = {
		object = 'gabz_mrpd_door_04',
		x = 448.9868,
		y = -990.2007,
		z = 35.18376
	},
},
position = vector3(449.7868, -989.4007, 35.18376),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[51] = { objects = {
	[1] = {
		object = 'gabz_mrpd_door_05',
		x = 448.9868,
		y = -981.5785,
		z = 35.10376
	},
},
position = vector3(449.7868, -982.3785, 35.18376),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[52] = { objects = {
	[1] = {
		object = 'gabz_mrpd_door_05',
		x = 448.9846,
		y = -995.5264,
		z = 35.10376
	},
},
position = vector3(449.7846, -996.3264, 35.18376),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[53] = { objects = {
	[1] = {
		object = 'gabz_mrpd_door_03',
		x = 464.3086,
		y = -984.5284,
		z = 43.77124
	},
},
position = vector3(464.3086, -983.3284, 43.85124),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[54] = { objects = { 
	[1] = {
		object = 'hei_prop_station_gate',
		x = 488.8948,
		y = -1017.212,
		z = 27.14935
	} 
},
position = vector3(488.47, -1019.89, 28.89),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = true,}, locked = true, distance = 4.00,size = 1.5, can = false, draw = true, gate = true},
--Komenda Davis
[55] = { objects = {
	[1] = {
		object = 'v_ilev_ph_door01',
		x = 252.4464,
		y = -1596.647,
		z = 31.68372
	},
	[2] = {
		object = 'v_ilev_ph_door01',
		x = 250.4625,
		y = -1594.97,
		z = 31.68372
	},
},
position = vector3(251.45, -1595.78, 31.53),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[56] = { objects = {
	[1] = {
		object = 'v_ilev_lssddoor',
		x = 368.2126,
		y = -1608.242,
		z = 29.43038
	},
	[2] = {
		object = 'v_ilev_lssddoor',
		x = 369.8871,
		y = -1606.262,
		z = 29.43038
	},
},
position = vector3(369.15, -1607.23, 29.29),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[57] = { objects = {
	[1] = {
		object = 'v_ilev_lssddoor',
		x = 362.182,
		y = -1584.057,
		z = 29.44576
	},
	[2] = {
		object = 'v_ilev_lssddoor',
		x = 360.5164,
		y = -1586.044,
		z = 29.44938
	},
},
position = vector3(361.3, -1585.06, 29.29),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[58] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 353.0617,
		y = -1597.84,
		z =  29.44279
	},
},
position = vector3(352.51, -1597.25, 29.29),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[59] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 355.4299,
		y =  -1599.832,
		z =  29.44279
	},
},
position = vector3(354.81, -1599.21, 29.29),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[60] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 366.6983,
		y =  -1609.282,
		z =  29.44279
	},
},
position = vector3(366.11, -1608.72, 29.29),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[61] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 364.3318,
		y =  -1607.284,
		z =  29.44279
	},
},
position = vector3(363.79, -1606.7, 29.29),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[62] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 349.9471,
		y = -1601.55,
		z = 29.44209
	},
},
position = vector3(349.41, -1601.16, 29.29),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[63] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 352.3263,
		y = -1603.537,
		z = 29.44209
	},
},
position = vector3(351.8, -1603.19, 29.29),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[64] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 361.2002,
		y = -1611.01,
		z = 29.44209
	},
},
position = vector3(360.63, -1610.59, 29.29),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[65] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 363.5703,
		y = -1613.007,
		z = 29.44209
	},
},
position = vector3(362.95, -1612.59, 29.29),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
--Komenda Paleto
[66] = { objects = {
	[1] = {
		object = 'v_ilev_shrf2door',
		x = -442.6569,
		y = 6015.222,
		z = 31.86523
	},
	[2] = {
		object = 'v_ilev_shrf2door',
		x = -444.5057,
		y = 6017.056,
		z = 31.86523
	},
	
},
position = vector3(-443.56, 6016.23, 31.71),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[67] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate1',
		x = -444.3682,
		y = 6012.223,
		z = 28.13558
	},
},
position = vector3(-444.81, 6011.80, 27.99),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[68] = { objects = {
	[1] = {
		object = 'v_ilev_rc_door2',
		x = -450.9664,
		y = 6006.086,
		z = 31.99004
	},
},
position = vector3(-451.4, 6006.59, 31.84),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[69] = { objects = {
	[1] = {
		object = 'v_ilev_rc_door2',
		x = -447.2363,
		y = 6002.317,
		z = 31.84003
	},
},
position = vector3(-446.79, 6001.61, 31.69),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
--Komenda Sandy
[70] = { objects = {
	[1] = {
		object = 'v_ilev_shrfdoor',
		x = 1855.709,
		y = 3683.933,
		z = 34.59364
	},
},
position = vector3(1855.06, 3683.56, 34.27),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[71] = { objects = {
	[1] = {
		object = 'v_ilev_rc_door2',
		x = 1851.288,
		y = 3681.87,
		z = 34.41656
	},
	[2] = {
		object = 'v_ilev_rc_door2',
		x = 1849.982,
		y = 3684.115,
		z = 34.41656
	},
},
position = vector3(1850.58, 3682.93, 34.27),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[72] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 1858.998,
		y = 3694.937,
		z = 30.40922
	},
},
position = vector3(1858.68, 3695.55, 30.26),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[73] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 1860.898,
		y = 3691.643,
		z = 30.40922
	},
},
position = vector3(1860.60, 3692.3, 30.26),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[74] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 1862.763,
		y = 3688.414,
		z = 30.40922
	},
},
position = vector3(1862.33, 3689.02, 30.26),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[75] = { objects = {
	[1] = {
		object = 'v_ilev_rc_door2',
		x = 1850.982,
		y = 3681.609,
		z = 30.40699
	},
	[2] = {
		object = 'v_ilev_rc_door2',
		x = 1849.679,
		y = 3683.854,
		z = 30.41207
	},
},
position = vector3(1850.18, 3682.71, 30.26),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
--Komenda  VineWood
[76] = { objects = {
	[1] = {
		object = 'int_vinewood_police_maindoor',
		x = 637.1759,
		y = 0.7189798,
		z = 83.00891
	},
	[2] = {
		object = 'int_vinewood_police_maindoor',
		x = 638.143,
		y = 3.354939,
		z = 83.00891
	},
},
position = vector3(637.65, 2.05, 82.79),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[77] = { objects = {
	[1] = {
		object = 'int_vinewood_police_door_l',
		x = 621.1563,
		y = 16.03793,
		z = 88.646
	},
	[2] = {
		object = 'int_vinewood_police_door_l',
		x = 618.1277,
		y = 17.18625,
		z = 88.646
	},
},
position = vector3(619.66, 16.40, 87.82),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[78] = { objects = {
	[1] = {
		object = 'v_ilev_roc_door2',
		x = 619.5421,
		y =  3.72195,
		z =  82.92089
	},
},
position = vector3(619.51, 4.48, 82.78),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[79] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 614.6944,
		y = -2.389629,
		z = 82.93158
	},
},
position = vector3(613.98, -2.19, 82.78),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[80] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 611.9668,
		y = -11.26786,
		z = 82.92802
	},
},
position = vector3(612.65, -11.35, 82.78),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[81] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 608.1331,
		y = -9.864241,
		z = 82.92802
	},
},
position = vector3(608.80, -9.95, 82.78),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[82] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 604.2855,
		y = -8.464458,
		z = 82.92802
	},
},
position = vector3(604.90, -8.73, 82.78),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[83] = { objects = {
	[1] = {
		object = 'v_ilev_ph_cellgate',
		x = 600.4366,
		y = -7.060292,
		z = 82.92802
	},
},
position = vector3(601.05, -7.25, 82.78),jobs = { ['sheriff'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
--DOJ
[84] = { objects = {
	[1] = {
		object = 'q_jud_door',
		x = 244.6178,
		y = -1074.643,
		z = 29.55341
	},
	[2] = {
		object = 'q_jud_door',
		x = 242.2193,
		y = -1074.643,
		z = 29.55341
	},
},
position = vector3(243.53, -1074.48, 29.29),jobs = { ['doj'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},
--Eclipse
[85] = { objects = {
	[1] = {
		object = 'gabz_pillbox_doubledoor_l',
		x = -681.1106,
		y =  319.3031,
		z = 83.27218
	},
	[2] = {
		object = 'gabz_pillbox_doubledoor_r',
		x = -680.8856,
		y =  321.8675,
		z =  83.27218
	},
},
position = vector3(-680.96, 320.63, 83.12),jobs = { ['ambulance'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = false, distance = 1.45,size = 0.6, can = false, draw = true},

[86] = { objects = {
	[1] = {
		object = 'gabz_pillbox_doubledoor_l',
		x = -693.2321,
		y =  325.5818,
		z = 83.27218
	},
	[2] = {
		object = 'gabz_pillbox_doubledoor_r',
		x = -693.0077,
		y =  328.1463,
		z =  83.27218
	},
},
position = vector3(-693.12, 326.81, 83.12),jobs = { ['ambulance'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = false, distance = 1.45,size = 0.6, can = false, draw = true},

[87] = { objects = {
	[1] = {
		object = 'gabz_pillbox_doubledoor_l',
		x = -692.6906,
		y =  331.7703,
		z = 83.27218
	},
	[2] = {
		object = 'gabz_pillbox_doubledoor_r',
		x = -692.4662,
		y =  334.3347,
		z =  83.27218
	},
},
position = vector3(-692.44, 333.04, 83.12),jobs = { ['ambulance'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = false, distance = 1.45,size = 0.6, can = false, draw = true},

[88] = { objects = {
	[1] = {
		object = 'gabz_pillbox_doubledoor_l',
		x = -692.1902,
		y =  337.4896,
		z = 83.27218
	},
	[2] = {
		object = 'gabz_pillbox_doubledoor_r',
		x = -691.9659,
		y =  340.0541,
		z =  83.27218
	},
},
position = vector3(-691.75, 338.7, 83.12),jobs = { ['ambulance'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = false, distance = 1.45,size = 0.6, can = false, draw = true},

[89] = { objects = {
	[1] = {
		object = 'gabz_pillbox_doubledoor_l',
		x = -690.5253,
		y =  341.365,
		z = 83.27218
	},
	[2] = {
		object = 'gabz_pillbox_doubledoor_r',
		x = -687.9609,
		y =  341.1406,
		z =  83.27218
	},
},
position = vector3(-689.3, 341.17, 83.12),jobs = { ['ambulance'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = false, distance = 1.45,size = 0.6, can = false, draw = true},

[90] = { objects = {
	[1] = {
		object = 'gabz_pillbox_doubledoor_l',
		x = -687.2908,
		y =  333.8819,
		z = 83.27218
	},
	[2] = {
		object = 'gabz_pillbox_doubledoor_r',
		x = -687.5152,
		y =   331.3175,
		z =  83.27218
	},
},
position = vector3(-687.38, 332.61, 83.12),jobs = { ['ambulance'] = true, ['offsheriff'] = true, ['police'] = true, ['offpolice'] = true, ['offpolice'] = false,}, locked = false, distance = 1.45,size = 0.6, can = false, draw = true},
--MAFIA
[91] = { objects = {
	[1] = {
		object = 'prop_lrggate_02_ld',
		x = -1474.129,
		y =  68.38937,
		z =  52.52709
	},
},	
position = vector3(-1470.82, 68.6, 53.31),jobs = { ['org37'] = true, }, locked = true, distance = 4.0,size = 0.6, can = false, draw = true, gate = true},

[92] = { objects = {
	[1] = {
		object = 'prop_lrggate_02_ld',
		x = -1616.232,
		y =  79.7792,
		z =  60.7787
	},
},	
position = vector3(-1613.64, 78.16, 61.58),jobs = { ['org37'] = true, }, locked = true, distance = 4.0,size = 0.6, can = false, draw = true, gate = true},

[93] = { objects = {
	[1] = {
		object = 'bh1_36_gate_iref',
		x = -1578.371,
		y =  153.207,
		z =  58.96855
	},
},	
position = vector3(-1579.38, 152.72, 58.68),jobs = { ['org37'] = true, }, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[94] = { objects = {
	[1] = {
		object = 'bh1_36_gate_iref',
		x = -1434.006,
		y =  235.013,
		z =  60.3711
	},
},	
position = vector3(-1434.45, 235.68, 59.65),jobs = { ['org37'] = true, }, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[95] = { objects = {
	[1] = {
		object = 'bh1_36_gate_iref',
		x = -1441.727,
		y =  171.9104,
		z =  56.06494
	},
},	
position = vector3(-1441.2, 172.75, 55.83),jobs = { ['org37'] = true, }, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

[96] = { objects = {
	[1] = {
		object = 'prop_door6',
		x = -1527.376,
		y =  136.4792,
		z =   49.62372
	},
	[2] = {
		object = 'prop_door5',
		x = -1529.019,
		y =  134.7629,
		z =  49.63172
	},	
},	
position = vector3(-1528.19, 135.65, 49.45),jobs = { ['org37'] = true, }, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},

	-- blackrose

[97] = { objects = {
	[1] = {
		object = 'apa_p_mp_Yacht_Door_01',
		x = -112.40,
		y = 986.22,
		z = 235.78
	},
},
	
position  = vector3(-112.40, 986.22, 235.78),jobs = {['org15'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

[98] = { objects = {
	[1] = {
		object = 'apa_p_mp_Yacht_Door_01',
		x = -62.30,
		y = 998.40,
		z = 234.75
	},
},
	
position  = vector3(-62.30, 998.40, 234.75),jobs = {['org15'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

[99] = { objects = {
	[1] = {
		object = 'apa_p_mp_Yacht_Door_01',
		x = -76.05,
		y = 994.694,
		z = 234.50
	},
},
	
position  = vector3(-76.05, 994.694, 234.50),jobs = {['org15'] = true,},locked = true, distance = 1.5,size = 0.6, can = false, draw = true},

[100] = { objects = {
	[1] = {
		object = 'prop_lrggate_01c_r',
		x = -132.7885,
		y =  971.5002,
		z =  236.1143
	},
	[2] = {
		object = 'prop_lrggate_01c_l',
		x =  -137.7991,
		y =  973.7089,
		z =  236.1143
	},	
},	
position = vector3(-135.3, 972.85, 236.21),jobs = { ['org15'] = true, }, locked = true, distance = 1.45,size = 0.6, can = false, draw = true},


}


	cb(doors)
end)

function IsAuthorized(jobName, doorID)
	for i=1, #doorID.authorizedJobs, 1 do
		if doorID.authorizedJobs[i] == jobName then
			return true
		end
	end
	return false
end
-- gabz_pillbox_bulletin_board_01