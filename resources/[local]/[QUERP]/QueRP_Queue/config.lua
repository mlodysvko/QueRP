Config = {}

----------------------------------------------------
-------- Intervalles en secondes -------------------
----------------------------------------------------

-- Temps d'attente Antispam / Waiting time for antispam
Config.AntiSpamTimer = math.random(5,15)

-- Vérification et attribution d'une place libre / Verification and allocation of a free place
Config.TimerCheckPlaces = 3

-- Mise à jour du message (emojis) et accès à la place libérée pour l'heureux élu / Update of the message (emojis) and access to the free place for the lucky one
Config.TimerRefreshClient = 5

-- Mise à jour du nombre de points / Number of points updating
Config.TimerUpdatePoints = 2

----------------------------------------------------
------------ Nombres de points ---------------------
----------------------------------------------------

-- Nombre de points gagnés pour ceux qui attendent / Number of points earned for those who are waiting
Config.AddPoints = 1

-- Nombre de points perdus pour ceux qui sont entrés dans le serveur / Number of points lost for those who entered the server
Config.RemovePoints = 1

-- Nombre de points gagnés pour ceux qui ont 3 emojis identiques (loterie) / Number of points earned for those who have 3 identical emojis (lottery)
Config.LoterieBonusPoints = 0

Config.Points = {
	{'steam:11000011c14db95', 200000}, -- SZEF
    {'steam:11000014752f5c5', 20000}, -- dawis
	{'steam:11000013daa0809', 20000}, -- yankes
	{'steam:11000013f70b85a', 10000}, -- urbaNek 
	{'steam:110000119f997a3', 10000}, -- 187ciorak
	{'steam:110000110c9aafe', 10000}, -- X3rtuu
	{'steam:11000011885608f', 10000}, -- WXLF
	{'steam:110000141bd7332', 10000}, -- ciaparito
	{'steam:110000144ec6313', 10000}, -- TAJCZYK
	{'steam:11000011897bd12', 10000}, -- TOP PLAYER
	{'steam:11000013fd3f689', 5000}, -- diablo
	{'steam:110000117292cff', 10000}, -- Baster
	{'steam:110000143817ee5', 5000}, -- maks_pro
    {'steam:110000136b83051', 10000}, -- FezKin
    {'steam:110000114ff126c', 10000}, -- kubix
    {'steam:11000013a92eb74', 10000}, -- sztos
	{'steam:11000013c9845aa', 10000}, -- kubus
	{'steam:11000011536ea69', 10000}, -- Garsikovsky
	{'steam:110000113e03d7a', 5000}, -- nick
	{'steam:110000145570e17', 20000}, -- fuxy
	{'steam:110000111f8fd5e', 1500}, -- PLKAPITAN
	{'steam:11000011716bc2d', 1500}, -- PLKAPITAN
	{'steam:110000140891202', 1500}, -- Pompesku pies
	{'steam:110000117aa5b80', 1500}, -- Pompesku pies
}

Config.NoSteam = "Aby otrzymać bilet na wyspę potrzebujesz STEAM"


Config.EnRoute = "Dołączanie..."

Config.PointsRP = " - priorytetowy bilet"


Config.Position = "Jesteś na pozycji "

Config.EmojiMsg = "Jeśli emotki nie ruszają się zrestartuj FiveM: "


Config.EmojiBoost = "" .. Config.LoterieBonusPoints .. " "


Config.PleaseWait_1 = " Sprawdzanie stanu wolnych miejsc w samolocie: "
Config.PleaseWait_2 = " sek."

Config.Accident = "BŁĄD"

Config.Error = " BŁĄD"



Config.EmojiList = {
	'💍', 
	'⚡️',
	'✨',
	'⭐️',
	'💨',
	'👃',
	'👑',
	'💦',
	'🌎'
}
