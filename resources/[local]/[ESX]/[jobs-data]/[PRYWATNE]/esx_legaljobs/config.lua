Config                            = {}
Config.DrawDistance               = 10.0

Config.Organisations = {
    ['doj'] = {
		Label = 'Department Of Justice',
		--HandcuffsRestrictAction = true,
		Cloakroom = {
			coords = vector3(238.35, -1094.91, 35.13+0.95),
		},
		Inventory = {
			coords = vector3(238.56, -1099.97, 35.15+0.95),
			from = 0, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(241.91, -1097.97, 35.13+0.95),
			from = 3 -- grade od ktorego to ma
		}
 	},
	['psycholog'] = {
		Label = 'Psycholog',
		--HandcuffsRestrictAction = true,
		Cloakroom = {
			coords = vector3(-250.65, -914.81, 32.31),
		},
		Inventory = {
			coords = vector3(-252.21, -919.23, 32.31),
			from = 0, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(-235.55, -923.17, 32.31),
			from = 3 -- grade od ktorego to ma
		}
 	},
	['cardealer'] = {
        Label = 'Broker',
        Cloakroom = {
            coords = vector3(144.28, -165.72, 59.49),
        },
        Inventory = {
            coords = vector3(116.4, -132.82, 59.49),
            from = 0, -- grade od ktorego to ma
        },
        BossMenu = {
            coords = vector3(120.0, -122.53, 59.49),
            from = 4 -- grade od ktorego to ma
        }
    }
}

Config.Interactions = {
    ['doj'] = {
		repair = 0,
	},
	['psycholog'] = {
		repair = 0,
	},
	['cardealer'] = {
		repair = 0,
	},
}