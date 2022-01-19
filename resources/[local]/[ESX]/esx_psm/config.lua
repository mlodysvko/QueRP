Config                            = {}
--Widocznoœæ markerów (wszystikch)
Config.DrawDistance               = 20.0
--Zbêdne 
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.MaxInService               = -1
Config.Locale                     = 'en'
--Markery Firmowe (szatnia,bossmenu)
Config.MarkerType                 = 1 --Rodzaj markeru firmowego
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 } --Wielkoœæ markeru firmowego
Config.MarkerColor                = { r = 102, g = 0, b = 102 } --Kolor markeru firmowego 

--Blipy
Config.Blipikon                   = 366  --Tutaj ustawiamy ikonke blipów
Config.Blipwielkosc               = 1.0  --Tutaj ustawiamy wielkoœæ blipów
Config.Blipkolor                  = 4 --Tutaj ustawiamy kolor blipów

---Zarobki
Config.Wyplata1                   = 2000 --Tutaj ustawiamy minimaln¹ wyp³ate dla pracownika
Config.Wyplata2                   = 2599 --Tutaj ustawiamy maksymaln¹ wyp³atê dla pracownika
Config.WypFirma1                  = 3999 --Tutaj ustawiamy minimanln¹ wyp³ate dla firmy
Config.WypFirma2                  = 5000 --Tutaj ustawiamy maksymaln¹ wyp³ate dla firmy 

--Czasy Czynnoœci
Config.Czasprzebierania           = 2 --Tutaj ustawiamy czas animacji przebierania
Config.Czasmaterial               = 4000 --Tutaj ustawiamy czas zbierania materia³u
Config.Czasszycie                 = 4000 --Tutaj ustawiamy czas szycia 
Config.Czaspako                   = 4000 --Tutaj ustawiamy czas pakowania
Config.Czasoddam                  = 180000 --Tutaj ustawiamy czas sprzeda¿y

Config.Zones = {

	Material = {
		Pos   = {x = 1215.183, y = -3289.9932, z = 4.5535}, --Kordy zbierania materia³u
		Size  = {x = 3.0, y = 3.0, z = 1.0}, --Wielkoœæ markeru zbierania materia³u
		Color = {r = 204, g = 204, b = 0}, --Kolor markeru zbierania materia³u
		Name  = "#1 Pakowanie materiaÅ‚u do szycia", --Nazwa blipa
		Type  = 1
	},


	Szycie = {
		Pos   = {x = 713.0502, y = -969.2859, z = 29.4453}, --Kordy szycia
                Size  = {x = 6.0, y = 6.0, z = 1.0}, --Wielkoœæ markeru szycia
                Color = {r = 204, g = 204, b = 0}, --Kolor markeru szycia
		Name  = "#2 Szycie ubraÅ„", --Nazwa blipa
		Type  = 1
	},

	Pakowanie = {
		Pos   = {x = 707.2742, y = -960.6641, z = 29.4453}, --Kordy pakowania
		Size  = {x = 6.0, y = 6.0, z = 1.0}, --Wielkoœc markeru pakowania
		Color = {r = 204, g = 204, b = 0}, -- Kolor markeru pakowania
		Name  = "#3 Pakowanie ubraÅ„ do opakowania", --Nazwa blipa
		Type  = 1
	},
	
	SellFarm = {
		Pos   = {x = 1199.2568, y = -3308.47, z = 4.5535}, --Kordy oddawania
		Size  = {x = 5.0, y = 5.0, z = 1.0}, --Wielkoœæ markeru oddawania
		Color = {r = 204, g = 204, b = 0}, --Kolor markeru oddawania
		Name  = "#4 Oddawanie opakowaÅ„ z ubraniami", --Nazwa Blipa
		Type  = 1
	},

}

Config.PSM = {
	PSM = {
		Vehicles = {
			{
				Spawner    = { x = 1214.509, y = -3247.9119, z = 4.5535 },
				SpawnPoint = { x = 1219.0378, y =  -3246.8081, z = 4.5535 },
				Heading    = 355.75
			}
		},

		PsmActions = {
			{ x = 1203.5027, y = -3257.2488, z = 6.1188},
		 },
	
		Cloakrooms = {
			{ x = 1202.6379, y = -3259.6841, z = 4.5535},
		},

		VehicleDeleters = {
			{ x = 1226.5609, y = -3246.7087, z = 4.5535},
		},
	}
}

Config.AuthorizedVehicles = {
	{
		grade = 0,
		model = 'velapsm',               
		label = 'Range Rover' ,
	},
	{
		grade = 0,
		model = 'gtpsm',               
		label = 'Nissan GTR' ,
	},
	{

		grade = 1,
		model = 'mercpsm',               
		label = 'Mercedes' ,
	},
}

