Config              = {}
Config.MarkerType   = 1
Config.DrawDistance = 10.0
Config.ZoneSize     = {x = 3.0, y = 3.0, z = 2.5}
Config.MarkerColor  = {r = 0, g = 196, b = 255}
Config.ShowBlips   = false  --markers visible on the map? (false to hide the markers on the map)

Config.RequiredCopsMorf  = 0

Config.TimeToFarm    = 1 * 1000
Config.TimeToProcess = 1 * 1000
Config.TimeToSell    = 1  * 1000

Config.Locale = 'en'

Config.Zones = {
	MorfField =			{x = 1894.44,	y = 3887.88,	z = 31.81,	name = _U('opium_field'),		sprite = 51,	color = 60},
	MorfProcessing =	{x = 2506.55,	y = 4210.58,	z = 38.92,	name = _U('opium_processing'),	sprite = 51,	color = 60},
	--MorfDealer =		{x = 2331.08,	y = 2570.22,	z = 45.30,	name = _U('opium_dealer'),		sprite = 500,	color = 75}
}
