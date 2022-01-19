Config = {}
-- MORE AVAILABLE ON 5MSCRIPTS.COM
Config.UserLicense = "None"
Config["image_source"] = "nui://esx_inventoryhud/html/img/items/"
Config.CloseInventoryHudTrigger = "esx_inventoryhud:closeInventory"

Config["chance"] = {
	[1] = { name = "Common", rate = 50 },
	[2] = { name = "Rare", rate = 40 },
	[3] = { name = "Epic", rate = 8 },
	[4] = { name = "Unique", rate = 1.7} ,
	[5] = { name = "Legendary", rate = 0.1 },
}

Config["broadcast"] = true 
Config["broadcast_tier"] = {
	[1] = false,
	[2] = false,
	[3] = false,
	[4] = false,
	[5] = false,
}

Config["5mscriptscom"] = {
	["csgocase"] = {
		name = "Zwykła skrzynka",
		list = {
			{ item = "redbull", amount=5 , tier = 2 },
			{ money = 100000000, tier = 3 },
			{ money = 100000000, tier = 3 },
			{ item = "pistol_ammo", amount=200, tier = 4 },
			{ item = "vintagepistol", amount=1, tier = 1 },
			{ item = "heavypistol", amount=1, tier = 1 },
		}
	},
	
-- MORE AVAILABLE ON 5MSCRIPTS.COM

	["csgocase2"] = {
		name = "Diamentowa Skrzynka",
		list = {
			{ item = "redbull", amount=5 , tier = 2 },
			{ money = 100000000, tier = 3 },
			{ money = 100000000, tier = 3 },
			{ item = "pistol_ammo", amount=200, tier = 4 },
			{ item = "vintagepistol", amount=1, tier = 1 },
			{ item = "smg", amount=1, tier = 1 },
			{ item = "smg_ammo", amount=300, tier = 1 }
		}
	},
}