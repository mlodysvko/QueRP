Config = {}
Config.DrawDistance = 100.0
Config.nameJob = "spawacz"
Config.nameJobLabel = "Spawacz podwodny"
Config.platePrefix = "Spaw"
Config.Locale = 'pl'

Config.Blip = {
  Sprite = 385,
  Color = 5
}

Config.Vehicles = {
  Truck = {
    Spawner = 1,
    Label = 'Łódź służbowa',
    Hash = "dinghy",
    Livery = 0,
    Trailer = "none",
  }
}

Config.Zones = {

  Cloakroom = {
    Pos = {x = -331.2, y = -2779.02, z = 4.14},
    Size = {x = 1.5, y = 1.5, z = 0.6},
    Color = {r = 250, g = 250, b = 0},
    Type = 1,
    BlipSprite = 404,
    BlipColor = 5,
    BlipName = "Zakład spawalniczy",
    hint = 'Wciśnij ~INPUT_CONTEXT~ aby uzyskać dostęp do szatni',
  },

  VehicleSpawner = {
    Pos = {x = -289.93, y = -2769.18, z = 1.25},
    Size = {x = 1.5, y = 1.5, z = 0.6},
    Color = {r = 0, g = 250, b = 0},
    Type = 27,
    BlipSprite = 404,
    BlipColor = 5,
    BlipName = "Zakład spawalniczy : Łódź",
    hint = 'Wciśnij ~INPUT_CONTEXT~ aby uzyskać dostęp do łodzi',
  },

  VehicleSpawnPoint = {
    Pos = {x = -285.01, y = -2767.15, z = 0.35},
    Size = {x = 3.0, y = 3.0, z = 1.0},
    Type = -1,
    Heading = 269.32,
  },

  VehicleDeleter = {
    Pos = {x = -299.52, y = -2766.38, z = 1.10},
    Size = {x = 3.0, y = 3.0, z = 0.9},
    Color = {r = 255, g = 0, b = 0},
    Type = 27,
    BlipSprite = 404,
    BlipColor = 5,
    BlipName = "Zakład spawalniczy : Zwrot łodzi",
    hint = 'Wciśnij ~INPUT_CONTEXT~ aby zwrócić łódź',
  },

  Vente = {
    Pos = {x = -331.02, y = -2786.0, z = 4.20},
    Size = {x = 5.0, y = 5.0, z = 1.0},
    Color = {r = 250, g = 250, b = 0},
    Type = 27,
    BlipSprite = 404,
    BlipColor = 5,
    BlipName = "Zakład spawalniczy : Spawacz",

    ItemTime = 500,
    ItemDb_name = "zdjecie",
    ItemName = "Zdjecie spawu",
    ItemMax = 100,
    ItemAdd = 1,
    ItemRemove = 1,
    ItemRequires = "zdjecie",
    ItemRequires_name = "Zdjecie spawu",
    ItemDrop = 100,
    hint = 'Wciśnij ~INPUT_CONTEXT~ aby oddać zdjęcia spawów',
  },

}

Config.Spawanie = {

  { ['x'] = -161.19, ['y'] = -2857.25, ['z'] = -14.33 },
  { ['x'] = -178.48, ['y'] = -2856.54, ['z'] = -13.90 },
  { ['x'] = 624.38, ['y'] = -3168.44, ['z'] = -6.31 },
  { ['x'] = 870.4, ['y'] = -3461.56, ['z'] = -15.92 },
  { ['x'] = 1372.6, ['y'] = -3359.77, ['z'] = -18.46 },
  { ['x'] = 1248.55, ['y'] = -3027.22, ['z'] = -5.03 },
  
}

for i = 1, #Config.Spawanie, 1 do

  Config.Zones['Spawanie' .. i] = {
    Pos = Config.Spawanie[i],
    Size = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 250, g = 250, b = 0},
    Type = -1
  }

end

Config.Uniforms = {

  job_wear = {
    male = {
      ['tshirt_1'] = 15, ['tshirt_2'] = 0,
      ['torso_1'] = 243, ['torso_2'] = 13,
      ['decals_1'] = 0, ['decals_2'] = 0,
      ['arms'] = 16,
      ['pants_1'] = 94, ['pants_2'] = 13,
      ['shoes_1'] = 67, ['shoes_2'] = 13,
      ['helmet_1'] = -1, ['helmet_2'] = 0,
      ['chain_1'] = 0, ['chain_2'] = 0,
      ['ears_1'] = -1, ['ears_2'] = 0,
      ['bproof_1'] = 0, ['bproof_2'] = 0,
      ['mask_1'] = 36, ['mask_2'] = 0,
      ['glasses_1'] = 26
    },
    female = {
      ['tshirt_1'] = 58, ['tshirt_2'] = 0,
      ['torso_1'] = 123, ['torso_2'] = 3,
      ['decals_1'] = 0, ['decals_2'] = 0,
      ['arms'] = 72,
      ['pants_1'] = 25, ['pants_2'] = 6,
      ['shoes_1'] = 56, ['shoes_2'] = 2,
      ['helmet_1'] = -1, ['helmet_2'] = 0,
      ['chain_1'] = 0, ['chain_2'] = 0,
      ['ears_1'] = -1, ['ears_2'] = 0
    }
  },
}
