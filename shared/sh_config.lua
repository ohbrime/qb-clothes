Config = {}

Config = {
    MinMoney = 249, 
    Money = 250,
    Debug = true,
    PolyDebug = false,
    
    Locations = {
        ["clothing"] = {
            vector4(77.84, -1396.83, 29.38, 175.46),
            vector4(423.11, -802.18, 29.49, 358.31),
            vector4(124.94, -218.96, 54.56, 157.25),
            vector4(124.94, -218.96, 54.56, 157.25),
            vector4(-709.76, -152.71, 37.42, 128.16),
            vector4(-1450.17, -237.35, 49.81, 37.0),
            vector4(-1194.93, -772.61, 17.32, 133.9),
            vector4(-824.71, -1077.5, 11.33, 127.49),
            vector4(-1206.36, -1458.0, 4.34, 127.49),
            vector4(-3171.45, 1047.85, 20.86, 342.22),
            vector4(616.8, 2759.26, 42.09, 183.11),
            vector4(1192.17, 2708.02, 38.22, 91.01),
            vector4(1690.8, 4826.46, 42.07, 11.44),
            vector4(6.4, 6516.85, 31.88, 319.03),
            vector4(6.4, 6516.85, 31.88, 319.03),
        },
        ["barber"] = {
            vector4(-814.21, -184.35, 37.57, 301.39),
            vector4(136.8, -1708.4, 29.3, 301.39),
            vector4(-1282.56, -1116.79, 6.99, 262.94),
            vector4(1931.53, 3729.7, 32.84, 25.76),
            vector4(1212.8, -472.9, 66.21, 250.87),
            vector4(-33.25, -153.33, 57.08, 153.47),
            vector4(-277.94, 6228.1, 31.7, 225.25),


        },
        ["wardobe"] = {
            vector4(461.4, -998.07, 31.17, 358.63),
            vector4(300.68, -597.73, 43.28, 72.28),
        },
    },

    Wardobe = {
        [1] = {name = "police", coords = vector4(461.4, -998.07, 31.17, 358.63)},
        [2] = {name = "ambulance", coords = vector4(300.68, -597.73, 43.28, 72.28)}
    },

    Outfits = {
        ["police"] = {
            ["male"] = {
                [1] = {
                    outfitLabel = "Recluta",
                    outfitData = {
                        ["arms"]        = { item = 0, texture = 0},  -- Armen
                        ["t-shirt"]     = { item = 66, texture = 0},  -- T Shirt
                        ["torso2"]      = { item = 62, texture = 3},  -- Jas / Vesten
                        ["vest"]        = { item = 23, texture = 0},  -- Body Vest
                        --["decals"]      = { item = 0, texture = 0},  -- Decals
                        --["accessory"]   = { item = 1, texture = 0},  -- Nek / Das
                        ["bag"]         = { item = 0, texture = 0},  -- Tas
                        ["hat"]         = { item = 0, texture = 0},  -- Pet
                        ["pants"]       = { item = 99, texture = 2},  -- Broek
                        ["shoes"]       = { item = 48, texture = 0},  -- Schoenen
                        ["glass"]       = { item = 5, texture = 0},  -- Bril
                        --["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                        ["mask"]        = { item = 0, texture = 0},  -- Masker
                    },
                },
            },
            ["female"] = {
                [1] = {
                    outfitLabel = "Recluta",
                    outfitData = {
                        ["arms"]        = { item = 14, texture = 0},  -- Armen
                        ["t-shirt"]     = { item = 8, texture = 0},  -- T Shirt
                        ["torso2"]      = { item = 211, texture = 1},  -- Jas / Vesten
                        ["vest"]        = { item = 1, texture = 0},  -- Body Vest
                        --["decals"]      = { item = 0, texture = 0},  -- Decals
                        --["accessory"]   = { item = 91, texture = 0},  -- Nek / Das
                        ["bag"]         = { item = 0, texture = 0},  -- Tas
                        ["hat"]         = { item = 0, texture = 0},  -- Pet
                        ["pants"]       = { item = 159, texture = 1},  -- Broek
                        ["shoes"]       = { item = 38, texture = 0},  -- Schoenen
                        ["glass"]       = { item = 5, texture = 0},  -- Bril
                        --["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                        ["mask"]        = { item = 0, texture = 0},  -- Masker
                    },
                },
            },
        },
        
        ["ambulance"] = {
            ["male"] = {
                [1] = {
                    outfitLabel = "Tirocinio",
                    outfitData = {
                        ["pants"]       = { item = 32, texture = 0 },  -- Broek
                        ["arms"]        = { item = 89, texture = 0},  -- Armen
                        ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                        ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                        ["torso2"]      = { item = 439, texture = 0},  -- Jas / Vesten
                        ["shoes"]       = { item = 83, texture = 22},  -- Schoenen
                        --["decals"]      = { item = 0, texture = 0},  -- Decals
                        ["accessory"]   = { item =151, texture = 0},  -- Nek / Das
                        ["bag"]         = { item = 0, texture = 0},  -- Tas
                        ["hat"]         = { item = -1, texture = 0},  -- Pet
                        ["glass"]       = { item = 0, texture = 0},  -- Bril
                        --["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                        ["mask"]        = { item = 0, texture = 0},  -- Masker
                    },
                },
            },
            ["female"] = {
                [1] = {
                    outfitLabel = "Tirocinio",
                    outfitData = {
                        ["pants"]       = { item = 3, texture = 7},  -- Broek
                        ["arms"]        = { item = 113, texture = 0},  -- Armen
                        ["t-shirt"]     = { item = 15, texture = 0},  -- T Shirt
                        ["vest"]        = { item = 0, texture = 0},  -- Body Vest
                        ["torso2"]      = { item = 42, texture = 1},  -- Jas / Vesten
                        ["shoes"]       = { item = 94, texture = 15},  -- Schoenen
                        --["decals"]      = { item = 0, texture = 0},  -- Decals
                        ["accessory"]   = { item = 107, texture = 0},  -- Nek / Das
                        ["bag"]         = { item = 0, texture = 0},  -- Tas
                        ["hat"]         = { item = -1, texture = 0},  -- Pet
                        ["glass"]       = { item = 5, texture = 0},  -- Bril
                        --["ear"]         = { item = 0, texture = 0},  -- Oor accessoires
                        ["mask"]        = { item = 0, texture = 0},  -- Masker
                    },
                },
            },
        },
    }
}
