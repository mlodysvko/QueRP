Config                            = {}
Config.DrawDistance               = 10.0

Config.Blips = {
    ['org1'] = vector3(-1541.8, 126.41, 56.78),
	['org2'] = vector3(715.54, -767.54, 24.76), 
	['org3'] = vector3(-1102.18, -1673.62, 8.41), 
	['org4'] = vector3(185.6, 1248.42, 225.45),
	['org5'] = vector3(59.94, 2791.63, 57.89),
	['org6'] = vector3(1403.75, 1144.55, 114.34),
	['org7'] = vector3(-827.05, 176.07, 70.91),        
	['org8'] = vector3(-2679.11, 1337.34, 152.01),
	['org9'] = vector3(-2585.1, 1873.94, 163.79),  
	['org10'] = vector3(661.31, 6470.99, 32.87), 
	['org11'] = vector3(-2619.9, 1711.71, 146.32), 
	['org12'] = vector3(-1521.36, 830.89, 181.55), 
	['org13'] = vector3(-1476.64, -38.09, 54.61), 
	['org14'] = vector3(-1110.33, 4949.45, 218.45), 
	['org15'] = vector3(-120.86, 984.2, 235.78),
	['org16'] = vector3(-734.89, 508.02, 109.57),
	['org17'] = vector3(394.0, -11.35, 86.67), 
	['org18'] = vector3(817.06, -3087.98, 5.9),   
	['org19'] = vector3(727.07, -1065.77, 28.31),      
	['org20'] = vector3(1990.43 , 3046.75, 47.22),  
	['org21'] = vector3(-1156.68, -1517.35, 10.63),
	['org22'] = vector3(769.55, -1295.78, 26.3), 
	['org23'] = vector3(940.44, -1492.94, 30.08),    
	['org24'] = vector3(2340.86, 3126.53, 48.21),
	['org25'] = vector3(-1569.22, 17.46, 64.62),
	['org26'] = vector3(1444.56, -1492.17, 63.7), 
	['org27'] = vector3(1157.23, -437.29, 62.23),    
	['org28'] = vector3(25.8, 6477.54, 31.88),  
	['org29'] = vector3(-1057.69, 315.11, 66.2),           
	['org30'] = vector3(-718.62, 632.56, 155.18),    
	['org31'] = vector3(1547.84, 2231.76, 77.79),     
	['org32'] = vector3(-1190.45, -1326.53, 5.29), 
	['org33'] = vector3(-8.46, 522.4, 174.63),        
	['org34'] = vector3(977.52, 2071.99, 36.67),  
	['org35'] = vector3(968.67, -1832.02, 36.11),  
	['org36'] = vector3(-1827.84, 4521.87, 5.28),
	['org37'] = vector3(930.76, -1462.17, 33.61),
	['org38'] = vector3(-849.61, -35.41, 44.15),
	['org39'] = vector3(-666.25, -154.49, 43.54),
	['org40'] = vector3(84.38, 2345.31, 86.23),
	['org41'] = vector3(-157.55, -1603.44, 35.04),
	['org42'] = vector3(727.33, 2535.67, 73.51),
	['org43'] = vector3(1157.99, -433.86, 62.23),
	['org44'] = vector3(-330.21, 514.03, 120.16),
	['org45'] = vector3(-1281.27, 492.17, 97.55),
	['org46'] = vector3(-662.38, 878.63, 229.25),
	['org47'] = vector3(-1729.42, 374.76, 89.72),
	['org48'] = vector3(-1825.44, 425.03, 118.35),
	['org49'] = vector3(1011.05, -3234.89, -17.75),
	['org50'] = vector3(745.82, 4181.17, 41.23),
	['org51'] = vector3(-1866.82, 2065.42, 135.43),
}

Config.List = {
	[1] = 'SNS', -- Nazwa Borni (Label - Wyświetlana nazwa) 60k
	[2] = 'snspistol', -- Nazwa Borni (Spawn - Spawn borni) 60k
	[3] = 'SNS MK2', -- Nazwa Borni (Label - Wyświetlana nazwa) 80k
	[4] = 'snspistol_mk2', -- Nazwa Borni (Spawn - Spawn borni) 80k
	[5] = 'Pistolet', -- Nazwa Borni (Label - Wyświetlana nazwa) 90k
	[6] = 'pistol', -- Nazwa Borni (Spawn - Spawn borni) 90k
	[7] = 'Pistolet MK2', -- Nazwa Borni (Label - Wyświetlana nazwa) 100k
	[8] = 'pistol_mk2', -- Nazwa Borni (Spawn - Spawn borni) 100k
	[9] = 'Vintage', -- Nazwa Borni (Label - Wyświetlana nazwa) 120k
	[10] = 'vintagepistol', -- Nazwa Borni (Spawn - Spawn borni) 120k
	[11] = 'machete', -- Nazwa Borni (Spawn - Spawn borni) 15k
	[12] = 'Toporek', -- Nazwa Borni (Spawn - Spawn borni) 15k
	[13] = 'battleaxe', -- Nazwa Borni (Spawn - Spawn borni) 15k
	[14] = 'Kij bejsbolowy', -- Nazwa Borni (Spawn - Spawn borni) 10k
	[15] = 'bat', -- Nazwa Borni (Spawn - Spawn borni) 10k
	[16] = 'Nóż', -- Nazwa Borni (Spawn - Spawn borni) 20k
	[17] = 'knife', -- Nazwa Borni (Spawn - Spawn borni) 20k
}   

Config.Organisations = {
    ['org1'] = {
		Label = 'Secra Corona Unita',
		Cloakroom = {
			coords = vector3(-1534.66, 131.25, 57.37),
		},
		Inventory = {
			coords = vector3(-1517.61, 125.91, 48.65),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1545.89, 137.45, 55.65),
			from = 4 -- grade od ktorego to ma
		},
 	},
	 ['org2'] = {
		Label = 'DDL',
		Cloakroom = {
			coords = vector3(732.82, -795.88, 18.07),
		},
		Inventory = {
			coords = vector3(724.36, -791.24, 16.47),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(739.78, -814.46, 24.27),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(727.38, -791.03, 15.47+0.95),
			from = 0,
			Utils = {
				Label = Config.List[9],
				Weapon = Config.List[10],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org3'] = {
		Label = 'Buldogi',
		Cloakroom = {
			coords = vector3(-1102.18, -1673.62, 8.41),
		},
		Inventory = {
			coords = vector3(-1089.53, -1667.48, 8.41),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1092.23, -1668.93, 8.42),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1089.49, -1661.54, 8.41),
			from = 0,
			Utils = {
				Label = Config.List[1],
				Weapon = Config.List[2],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org4'] = {
		Label = 'UNL',
		Cloakroom = {
			coords = vector3(105.86, 1211.83, 207.17),
		},
		Inventory = {
			coords = vector3(88.55, 1237.07, 207.17),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(107.13, 1205.03, 207.17),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(96.64, 1235.05, 207.17),
			from = 0,
			Utils = {
				Label = Config.List[5],
				Weapon = Config.List[6],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org5'] = {
		Label = 'BRUSH',
		Cloakroom = {
			coords = vector3(44.19, 2793.08, 58.1),
		},
		Inventory = {
			coords = vector3(59.94, 2791.63, 57.89),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(47.14, 2794.27, 58.1),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(54.36, 2793.43, 57.89),
			from = 0,
			Utils = {
				Label = Config.List[3],
				Weapon = Config.List[4],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org6'] = {
		Label = 'F.D.S',
		Cloakroom = {
			coords = vector3(1403.75, 1144.55, 114.34),
		},
		Inventory = {
			coords = vector3(1394.84, 1150.02, 114.34),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(1394.97, 1160.11, 114.34),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(1394.17, 1140.02, 109.75),
			from = 0,
			Utils = {
				Label = Config.List[5],
				Weapon = Config.List[6],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org7'] = {
		Label = 'MLB',
		Cloakroom = {
			coords = vector3(-811.16, 175.21, 76.75),
		},
		Inventory = {
			coords = vector3(-803.54, 185.64, 72.61),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-811.33, 181.29, 76.74),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1856.94, 2055.48, 134.46+0.95),
			from = 0,
			Utils = {
				Label = Config.List[9],
				Weapon = Config.List[10],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org8'] = {
		Label = 'Zimny Łokieć',
		Cloakroom = {
			coords = vector3(-2676.99, 1310.34, 152.01),
		},
		Inventory = {
			coords = vector3(-2679.52, 1328.32, 144.26),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-2679.11, 1337.34, 152.01),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-2679.04, 1327.79, 140.88),
			from = 0,
			Utils = {
				Label = Config.List[3],
				Weapon = Config.List[4],
				Account = 'money',
				Price = 150000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org10'] = {
		Label = 'KDB',
		Cloakroom = {
			coords = vector3(464.05, 6525.93, 13.74),
		},
		Inventory = {
			coords = vector3(460.44, 6530.57, 13.74),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(500.43, 6538.34, 13.73),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(463.28, 6530.66, 12.74+0.95),
			from = 0,
			Utils = {
				Label = Config.List[9],
				Weapon = Config.List[10],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org9'] = {
		Label = 'Bomba Squad',
		Cloakroom = {
			coords = vector3(-2585.1, 1873.94, 163.79),
		},
		Inventory = {
			coords = vector3(-2574.54, 1868.18, 163.79),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-2581.22, 1868.23, 163.79),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-2603.68, 1922.22, 167.3),
			from = 0,
			Utils = {
				Label = Config.List[9],
				Weapon = Config.List[10],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org11'] = {
		Label = 'R.M.B',
		Cloakroom = {
			coords = vector3(-2619.9, 1711.71, 146.32),
		},
		Inventory = {
			coords = vector3(-2619.3, 1714.49, 142.37),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-2618.77, 1692.7, 142.37),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-2614.33, 1686.31, 141.87), 
			from = 0,
			Utils = {
				Label = Config.List[9],
				Weapon = Config.List[10],
				Account = 'money',
				Price = 150000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org12'] = {
		Label = 'C.D.S',
		Cloakroom = {
			coords = vector3(-1521.36, 830.89, 181.55),
		},
		Inventory = {
			coords = vector3(-1500.27, 835.73, 178.7),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1525.0, 842.05, 181.55),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1516.49, 830.48, 181.55),
			from = 0,
			Utils = {
				Label = Config.List[3],
				Weapon = Config.List[4],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org13'] = {
		Label = 'G.H.O.S.T',
		Cloakroom = {
			coords = vector3(-1476.64, -38.09, 54.61),
		},
		Inventory = {
			coords = vector3(-1466.81, -44.51, 54.65),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1482.12, -46.02, 54.64),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1481.44, -36.81, 54.61),
			from = 0,
			Utils = {
				Label = Config.List[9],
				Weapon = Config.List[10],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org14'] = {
		Label = 'Sinaloa',
		Cloakroom = {
			coords = vector3(-1110.33, 4949.45, 218.45),
		},
		Inventory = {
			coords = vector3(-1100.67, 4953.46, 218.45),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1113.21, 4941.1, 218.45),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1107.85, 4955.81, 218.46),
			from = 0,
			Utils = {
				Label = Config.List[3],
				Weapon = Config.List[4],
				Account = 'money',
				Price = 150000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org15'] = {
		Label = 'KB',
		Cloakroom = {
			coords = vector3(-90.99, 993.86, 234.56),
		},
		Inventory = {
			coords = vector3(-85.64, 997.31, 230.61),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-60.42, 981.92, 234.58),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-78.30, 1001.67, 230.61),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org16'] = {
		Label = 'Family of 2115',
		Cloakroom = {
			coords = vector3(-742.99, 504.25, 109.57),
		},
		Inventory = {
			coords = vector3(-724.96, 507.92, 109.32),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-734.89, 508.02, 109.57),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-717.98, 509.67, 109.32),
			from = 0,
			Utils = {
				Label = Config.List[1],
				Weapon = Config.List[2],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org17'] = {
		Label = 'RZULE',
		Cloakroom = {
			coords = vector3(394.0, -11.35, 86.67),
		},
		Inventory = {
			coords = vector3(389.67, -8.72, 86.67),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(398.24, -19.93, 91.94),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(412.4, 7.55, 84.92), 
			from = 0,
			Utils = {
				Label = Config.List[3],
				Weapon = Config.List[4],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org18'] = {
		Label = 'Y.C.B',
		Cloakroom = {
			coords = vector3(922.66, -3198.59, -17.31),
		},
		Inventory = {
			coords = vector3(924.73, -3199.54, -17.31),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(927.71, -3158.99, -17.34),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(919.7, -3192.31, -17.31),
			from = 0,
			Utils = {
				Label = Config.List[1],
				Weapon = Config.List[1],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org19'] = {
		Label = 'Śródmieście',
		Cloakroom = {
			coords = vector3(728.51, -1063.81, 22.17),
		},
		Inventory = {
			coords = vector3(737.75, -1078.19, 22.17),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(725.52, -1071.29, 28.31),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(727.07, -1065.77, 28.31),
			from = 0,
			Utils = {
				Label = Config.List[9],
				Weapon = Config.List[10],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org20'] = {
		Label = 'G.M.F',
		Cloakroom = {
			coords = vector3(1994.6, 3043.61, 47.21),
		},
		Inventory = {
			coords = vector3(1985.47, 3048.66, 47.22),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(1984.41, 3054.71, 47.22),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(1990.58, 3049.96, 47.22),
			from = 0,
			Utils = {
				Label = Config.List[3],
				Weapon = Config.List[4],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org21'] = {
		Label = 'S.G.D',
		Cloakroom = {
			coords = vector3(-1145.35, -1514.42, 10.63),
		},
		Inventory = {
			coords = vector3(-1152.81, -1516.38, 10.63),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1156.68, -1517.35, 10.63),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1156.71, -1524.95, 10.63), 
			from = 0,
			Utils = {
				Label = Config.List[3],
				Weapon = Config.List[4],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org22'] = {
		Label = 'Sinaloa',
		Cloakroom = {
			coords = vector3(769.55, -1295.78, 26.3),
		},
		Inventory = {
			coords = vector3(752.9, -1299.06, 26.3),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(736.44, -1298.55, 26.3),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(755.11, -1298.97, 26.3),
			from = 0,
			Utils = {
				Label = Config.List[1],
				Weapon = Config.List[2],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org23'] = {
		Label = 'M.F.G',
		Cloakroom = {
			coords = vector3(932.47, -1462.09, 33.61),
		},
		Inventory = {
			coords = vector3(942.9, -1473.32, 30.1),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(946.52, -1463.36, 33.61),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(947.35, -1462.16, 29.4+0.95),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org24'] = {
		Label = 'O.T.F',
		Cloakroom = {
			coords = vector3(2347.84, 3128.41, 48.21),
		},
		Inventory = {
			coords = vector3(2344.74, 3129.23, 48.21),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(2340.86, 3126.53, 48.21),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(2350.88, 3118.55, 48.21),
			from = 0,
			Utils = {
				Label = Config.List[1],
				Weapon = Config.List[2],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org25'] = {
		Label = 'BDS',
		Cloakroom = {
			coords = vector3(-1569.22, 17.46, 64.62),
		},
		Inventory = {
			coords = vector3(-1574.31, 18.33, 64.62),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1586.75, 23.02, 61.21),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1577.97, 15.82, 64.62),
			from = 0,
			Utils = {
				Label = Config.List[5],
				Weapon = Config.List[6],
				Account = 'money',
				Price = 90000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org26'] = {
		Label = 'S.W.D',
		Cloakroom = {
			coords = vector3(1437.47, -1487.28, 63.7),
		},
		Inventory = {
			coords = vector3(1436.1, -1489.02, 66.62),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(1444.56, -1492.17, 63.7),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(1445.41, -1488.38, 66.62),
			from = 0,
			Utils = {
				Label = Config.List[1],
				Weapon = Config.List[2],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org27'] = {
		Label = 'Ballas',
		Cloakroom = {
			coords = vector3(1157.23, -437.29, 62.23),
		},
		Inventory = {
			coords = vector3(118.57, -1963.49, 21.33),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(119.67, -1969.05, 21.33),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(108.18, -1980.19, 20.96),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 100000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	['org28'] = {
		Label = 'M.F.G',
		Cloakroom = {
            coords = vector3(25.8, 6477.54, 31.88),
		},
        Inventory = {
            coords = vector3(36.3, 6471.99, 31.88),
            from = 4, -- grade od ktorego to ma
        },
        BossMenu = {
            coords = vector3(37.29, 6463.68, 32.08),
            from = 4 -- grade od ktorego to ma
        },
        Contract = {
            coords = vector3(29.86, 6480.75 , 30.88+0.95),
			from = 0,
			Utils = {
				Label = Config.List[5],
				Weapon = Config.List[6],
				Account = 'black_money',
				Price = 90000,
				Ammo = {
					Account = 'black_money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org29'] = {
		Label = 'P.M.G',
		Cloakroom = {
            coords = vector3(-1046.93, 309.23, 62.22),
		},	
        Inventory = {
            coords = vector3(-1051.28, 308.71, 62.22),
            from = 4, -- grade od ktorego to ma
        },
        BossMenu = {
            coords = vector3(-1029.37, 306.88, 66.99),
            from = 4, -- grade od ktorego to ma
        },
        Contract = {
            coords = vector3(-1048.5, 298.99, 62.22),
			from = 0,
			Utils = {
				Label = Config.List[5],
				Weapon = Config.List[6],
				Account = 'money',
				Price = 90000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org30'] = {
		Label = 'GFM',
		Cloakroom = {
            coords = vector3(-707.1, 631.15, 159.19),
		},	
        Inventory = {
            coords = vector3(-718.62, 632.56, 155.18),
            from = 4, -- grade od ktorego to ma
        },
        BossMenu = {
            coords = vector3(-717.81, 632.82, 159.19),
            from = 4 -- grade od ktorego to ma
        },
        Contract = {
            coords = vector3(-701.17, 637.27, 155.18),
			from = 0,
			Utils = {
				Label = Config.List[5],
				Weapon = Config.List[6],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	['org31'] = {
		Label = 'Ninja Turtles',
		Cloakroom = {
            coords = vector3(1547.84, 2231.76, 77.79),
		},	
        Inventory = {
            coords = vector3(1537.5, 2228.12, 77.79),
            from = 4, -- grade od ktorego to ma
        },
        BossMenu = {
            coords = vector3(1535.61, 2221.69, 77.26),
            from = 4, -- grade od ktorego to ma
        },
        Contract = {
            coords = vector3(1542.84, 2232.58, 77.79),
			from = 0,
			Utils = {
				Label = Config.List[5],
				Weapon = Config.List[6],
				Account = 'money',
				Price = 250000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	 ['org33'] = {
		Label = 'N.Z.Z',
		Cloakroom = {
            coords = vector3(8.95, 528.95, 170.63),
		},	
        Inventory = {
            coords = vector3(-8.46, 522.4, 174.63),
            from = 4, -- grade od ktorego to ma
        },
        BossMenu = {
            coords = vector3(-3.91, 522.61, 170.63),
            from = 4 -- grade od ktorego to ma
        },
        Contract = {
            coords = vector3(-17.25, 526.41, 170.62),
			from = 0,
			Utils = {
				Label = Config.List[3],
				Weapon = Config.List[4],
				Account = 'money',
				Price = 100000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	},
	['org32'] = {
		Label = 'MGL',
		Cloakroom = {
            coords = vector3(-1214.09, -1303.42, -4.92),
		},	
        Inventory = {
            coords = vector3(-1203.29, -1306.77, -4.92),
            from = 4 -- grade od ktorego to ma
        },
        BossMenu = {
            coords = vector3(-1226.03, -1305.03, -4.92),
            from = 4 -- grade od ktorego to ma
        },
        Contract = {
            coords = vector3(-1205.08, -1308.95, -4.92),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'black_money',
				Price = 120000,
				Ammo = {
					Account = 'black_money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
 	},
	 ['org35'] = {
		Label = 'D.S.W',
		Cloakroom = {
            coords = vector3(968.67, -1832.02, 36.11),
		},	
        Inventory = {
            coords = vector3(965.63, -1836.91, 31.28),
            from = 4 -- grade od ktorego to ma
        },
        BossMenu = {
            coords = vector3(973.92, -1839.23, 36.11),
            from = 4 -- grade od ktorego to ma
        },
        Contract = {
            coords = vector3(970.3, -1852.92, 31.28),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
 	},
	['org34'] = {
		Label = 'TBH',
		Cloakroom = {
            coords = vector3(977.52, 2071.99, 36.67),
		},	
        Inventory = {
            coords = vector3(977.81, 2065.25, 36.67),
            from = 4 -- grade od ktorego to ma
        },
        BossMenu = {
            coords = vector3(939.27, 2074.04, 36.66),
            from = 4 -- grade od ktorego to ma
        },
        Contract = {
            coords = vector3(982.36, 2064.16, 36.67),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org36'] = {
		Label = 'LVN',
		Cloakroom = {
			coords = vector3(-1827.84, 4521.87, 5.28),
		},	
		Inventory = {
			coords = vector3(-1826.68, 4529.86, 5.29),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1823.03, 4509.37, 5.29),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1826.34, 4527.14, 5.29),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org37'] = {
		Label = 'SKY',
		Cloakroom = {
			coords = vector3(930.76, -1462.17, 33.61),
		},	
		Inventory = {
			coords = vector3(947.98, -1475.46, 30.4),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(939.87, -1461.48, 33.61),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(931.07, -1476.13, 30.4),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org38'] = {
		Label = 'CAMMORA',
		Cloakroom = {
			coords = vector3(-849.61, -35.41, 44.15),
		},	
		Inventory = {
			coords = vector3(-846.55, -16.24, 44.15),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-852.54, -28.38, 44.16),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-847.95, -21.51, 44.15),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org39'] = {
		Label = 'I.D.K',
		Cloakroom = {
			coords = vector3(-672.49, -155.85, 43.54),
		},	
		Inventory = {
			coords = vector3(-663.63, -150.76, 43.54),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-669.48, -163.73, 43.54),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-666.25, -154.49, 43.54),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org40'] = {
		Label = '91S',
		Cloakroom = {
			coords = vector3(84.38, 2345.31, 86.23),
		},	
		Inventory = {
			coords = vector3(92.36, 2350.71, 85.83),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(110.67, 2340.96, 89.23),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(115.7, 2343.71, 89.23),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org41'] = {
		Label = 'The Familis',
		Cloakroom = {
			coords = vector3(-151.22, -1589.15, 35.03),
		},	
		Inventory = {
			coords = vector3(-157.55, -1603.44, 35.04),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-155.24, -1593.08, 35.03),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-144.64, -1599.91, 35.07),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org42'] = {
		Label = 'P.S.G',
		Cloakroom = {
			coords = vector3(727.33, 2535.67, 73.51),
		},	
		Inventory = {
			coords = vector3(720.87, 2530.77, 73.51),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(716.51, 2526.86, 73.51),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(726.53, 2525.92, 73.53),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org43'] = {
		Label = 'CEO',
		Cloakroom = {
			coords = vector3(1157.99, -433.86, 62.23),
		},	
		Inventory = {
			coords = vector3(1140.98, -438.59, 62.22),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(1141.89, -440.02, 62.22),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(1157.09, -437.1, 62.23),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org44'] = {
		Label = 'Saint`s Row',
		Cloakroom = {
			coords = vector3(-330.21, 514.03, 120.16),
		},	
		Inventory = {
			coords = vector3(-336.19, 507.37, 120.41),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-341.58, 523.5, 120.16),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-355.78, 522.96, 120.15),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org45'] = {
		Label = 'A.R.K',
		Cloakroom = {
			coords = vector3(-1281.27, 492.17, 97.55),
		},	
		Inventory = {
			coords = vector3(-1297.47, 509.52, 97.35),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1296.9, 522.49, 97.35),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1293.49, 515.98, 97.35),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org46'] = {
		Label = 'T.D.N.P',
		Cloakroom = {
			coords = vector3(-662.38, 878.63, 229.25),
		},	
		Inventory = {
			coords = vector3(-649.09, 860.17, 229.25),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-646.03, 859.58, 229.25),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-652.79, 887.21, 229.25),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org47'] = {
		Label = 'Misie kolorowe',
		Cloakroom = {
			coords = vector3(-1729.42, 374.76, 89.72),
		},	
		Inventory = {
			coords = vector3(-1730.83, 357.14, 89.42),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1724.91, 380.26, 89.72),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1726.21, 375.73, 89.72),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org48'] = {
		Label = 'PFM',
		Cloakroom = {
			coords = vector3(-1825.44, 425.03, 118.35),
		},	
		Inventory = {
			coords = vector3(-1822.36, 425.04, 118.35),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1819.2, 430.45, 118.37),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1821.56, 430.85, 118.37),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org49'] = {
		Label = '07',
		Cloakroom = {
			coords = vector3(1011.05, -3234.89, -17.75),
		},	
		Inventory = {
			coords = vector3(1012.24, -3247.59, -17.75),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(1013.16, -3238.14, -17.75),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(1013.27, -3242.79, -17.75),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org50'] = {
		Label = 'Wadowice',
		Cloakroom = {
			coords = vector3(749.84, 4172.57, 41.23),
		},	
		Inventory = {
			coords = vector3(745.82, 4181.17, 41.23),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(746.45, 4171.0, 41.23),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(743.54, 4183.53, 41.23),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
	['org51'] = {
		Label = 'THC',
		Cloakroom = {
			coords = vector3(-1866.82, 2065.42, 135.43),
		},	
		Inventory = {
			coords = vector3(-1870.25, 2059.11, 135.44),
			from = 4 -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-1865.95, 2061.17, 135.43),
			from = 4 -- grade od ktorego to ma
		},
		Contract = {
			coords = vector3(-1861.83, 2054.78, 135.46),
			from = 0,
			Utils = {
				Label = Config.List[7],
				Weapon = Config.List[8],
				Account = 'money',
				Price = 120000,
				Ammo = {
					Account = 'money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		},
	},
}

Config.Interactions = {
    ['org1'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org2'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org3'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org4'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org5'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org6'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org7'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org8'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org9'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org1'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org10'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org11'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org12'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org1'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org13'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org14'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org15'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org16'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org17'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org18'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org19'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org20'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org21'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org22'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org23'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org24'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org25'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org26'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org27'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org28'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org29'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org30'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org31'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org32'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org33'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org34'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org35'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org36'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org37'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org38'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org39'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org40'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org41'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org42'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org43'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org44'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org45'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org46'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org47'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org48'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org49'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org50'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
	['org51'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	},
}

Config.BlipTime = 300 -- W sekundach
Config.Cooldown = 300 -- W sekundach

Config.Jobs = {
	'org2',
	'org3',
	'org4',
	'org5',
	'org6',
	'org7',
	'org8',
	'org9',
	'org10',
	'org11',
	'org12',
	'org13',
	'org14',
	'org15',
	'org16',
	'org17',
	'org18',
	'org19',
	'org20',
	'org21',
	'org22',
	'org23',
	'org24',
	'org25',
	'org26',
	'org27',
	'org28',
	'org29',
	'org30',
	'org31',
	'org32',
	'org33',
	'org34',
	'org35',
	'org36',
	'org37',
	'org38',
	'org39',
	'org40',
	'org41',
	'org42',
	'org43',
	'org44',
	'org45',
	'org46',
	'org47',
	'org48',
	'org49',
	'org50',
	'org51',
}