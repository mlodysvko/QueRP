Config = {}
Config.DrawDistance = 100.0
Config.nameJob = "budowa"
Config.nameJobLabel = "Budowlaniec"
Config.platePrefix = "Budowa"
Config.Locale = 'pl'

Config.Blip = {
  Sprite = 385,
  Color = 5
}

Config.Vehicles = {
  Truck = {
    Spawner = 1,
    Label = 'Pojazd służbowy',
    Hash = "utillitruck3",
    Livery = 0,
    Trailer = "none",
  }
}

Config.Zones = {

  Cloakroom = {
    Pos = {x = 895.08, y = -896.21, z = 26.75},
    Size = {x = 1.5, y = 1.5, z = 0.6},
    Color = {r = 250, g = 250, b = 0},
    Type = 1,
    BlipSprite = 280,
    BlipColor = 5,
    BlipName = "Firma budowlana",
    hint = 'Wciśnij ~INPUT_CONTEXT~ aby uzyskać dostęp do szatni',
  },

  VehicleSpawner = {
    Pos = {x = 892.63, y = -891.69, z = 26.15},
    Size = {x = 1.5, y = 1.5, z = 0.6},
    Color = {r = 0, g = 250, b = 0},
    Type = 27,
    BlipSprite = 280,
    BlipColor = 5,
    BlipName = "Firma budowlana : Garaż",
    hint = 'Wciśnij ~INPUT_CONTEXT~ aby uzyskać dostęp do garażu',
  },

  VehicleSpawnPoint = {
    Pos = {x = 877.79, y = -890.02, z = 26.05},
    Size = {x = 3.0, y = 3.0, z = 1.0},
    Type = -1,
    Heading = 90.09,
  },

  VehicleDeleter = {
    Pos = {x = 892.98, y = -887.31, z = 26.15},
    Size = {x = 3.0, y = 3.0, z = 0.9},
    Color = {r = 255, g = 0, b = 0},
    Type = 27,
    BlipSprite = 280,
    BlipColor = 5,
    BlipName = "Firma budowlana : Zwrot pojazdu",
    hint = 'Wciśnij ~INPUT_CONTEXT~ aby zwrócić pojazd',
  },

  Vente = {
    Pos = {x = 889.5, y = -881.01, z = 25.20},
    Size = {x = 5.0, y = 5.0, z = 1.0},
    Color = {r = 250, g = 250, b = 0},
    Type = 27,
    BlipSprite = 280,
    BlipColor = 5,
    BlipName = "Firma budowlana : Kierownik",

    ItemTime = 500,
    ItemDb_name = "contrat",
    ItemName = "Raport budowlany",
    ItemMax = 400,
    ItemAdd = 2,
    ItemRemove = 2,
    ItemRequires = "contrat",
    ItemRequires_name = "Raport budowlany",
    ItemDrop = 200,
    hint = 'Wciśnij ~INPUT_CONTEXT~ aby oddać raporty budowlane',
  },

}

Config.Budowa = {

  { ['x'] = -174.39, ['y'] = -1063.7, ['z'] = 29.74 },
  { ['x'] = -454.65, ['y'] = -917.4, ['z'] = 29.29 },
  { ['x'] = -501.56, ['y'] = -996.63, ['z'] = 29.03 },
  { ['x'] = -1097.0, ['y'] = -1654.2, ['z'] = 4.3 },
  { ['x'] = 29.3, ['y'] = -385.68, ['z'] = 45.46 },
  
}

for i = 1, #Config.Budowa, 1 do

  Config.Zones['Budowa' .. i] = {
    Pos = Config.Budowa[i],
    Size = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 250, g = 250, b = 0},
    Type = -1
  }

end

Config.Uniforms = {

  job_wear = {
    male = {
      ['tshirt_1'] = 89, ['tshirt_2'] = 0,
      ['torso_1'] = 219, ['torso_2'] = 19,
      ['decals_1'] = 0, ['decals_2'] = 0,
      ['arms'] = 42,
      ['pants_1'] = 52, ['pants_2'] = 3,
      ['shoes_1'] = 35, ['shoes_2'] = 0,
      ['helmet_1'] = 25, ['helmet_2'] = 2,
      ['chain_1'] = 0, ['chain_2'] = 0,
      ['ears_1'] = -1, ['ears_2'] = 0,
      ['bproof_1'] = 3, ['bproof_2'] = 1
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
