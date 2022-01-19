Config = {}
Config.Locale = 'pl'

Config.Price = 500

Config.DrawDistance = 100.0
Config.MarkerSize   = {x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor                = { r = 0, g = 130, b = 204 }
Config.MarkerType   = 1
--[[Config.List = {
    [1] = 'hydra',
    [2] = 'CB',
    [3] = 'ODV',
    [4] = 'DKP',
    [5] = 'Cis',
    [6] = 'LCN',
    [7] = 'TPC',
    [8] = 'THC',
    [9] = '750',
    [10] = 'FDS',
    [11] = 'TFM',
    [12] = 'quindical',
    [13] = 'KRM',
    [14] = 'DSF',
    [15] = '666',
    [16] = '60',
    [17] = 'OIOM',
    [18] = 'Arabs',
    [19] = 'The Red Family',
    [20] = 'Bloods',
    [21] = 'Crips',
    [22] = 'KSF',
    [23] = 'Ballas',
    [24] = 'police',
    [25] = 'ambulance',
    [26] = 'mecano',
}]]

Config.RemoveList = {
    [1] = {['tshirt_1'] = 57},
    [2] = {['helmet_1'] = -1},
    [3] = {['torso_1'] = 53},
    [4] = {['ears_1'] = -1},
    [5] = {['mask_1'] = -1},
    [6] = {['glasses_1'] = 0},
}
Config.Zones = {}

Config.Shops = {
    {x=-896.07,    y=38.34, z=48.14},
    {x=-1729.64,    y=375.4, z=88.72},
	{x=72.254,    y=-1399.102, z=28.376},
	{x=-703.776,  y=-152.258,  z=36.415},
	{x=-167.863,  y=-298.969,  z=38.733},
	{x=428.694,   y=-800.106,  z=28.491},
	{x=-829.413,  y=-1073.710, z=10.328},
	{x=-1447.797, y=-242.461,  z=48.820},
	{x=11.632,    y=6514.224,  z=30.877},
	{x=123.646,   y=-219.440,  z=53.557},
	{x=1696.291,  y=4829.312,  z=41.063},
	{x=618.093,   y=2759.629,  z=41.088},
	{x=1190.550,  y=2713.441,  z=37.222},
	{x=-1193.429, y=-772.262,  z=16.324},
	{x=-3172.496, y=1048.133,  z=19.863},
	{x=-1108.441, y=2708.923,  z=18.107},
	{x=-1088.04, y=-2737.11,  z=13.61},
    {x=9.38,  y=529.07,  z=170.64-0.90},
    {x=-1821.87,  y=4523.44,  z=5.28-0.90},   
    {x=299.65,  y=-595.08,  z=43.28-0.90}, 
}

for i=1, #Config.Shops, 1 do
	Config.Zones['Shop_' .. i] = {
		Pos   = Config.Shops[i],
		Size  = Config.MarkerSize,
		Color = Config.MarkerColor,
		Type  = Config.MarkerType
	}
end