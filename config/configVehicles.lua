-- =========================================================================
-- VEHICLES, STASH LIMITS & AMMO CAPACITY CONFIGURATION
-- =========================================================================
Config = Config or {}

-- Araç motorunun arkada olduğu (Bagajın önde açıldığı) araç modelleri
BackEngineVehicles = {
    [`ninef`] = true,
    [`adder`] = true,
    [`vagner`] = true,
    [`t20`] = true,
    [`infernus`] = true,
    [`zentorno`] = true,
    [`reaper`] = true,
    [`comet2`] = true,
    [`comet3`] = true,
    [`jester`] = true,
    [`jester2`] = true,
    [`cheetah`] = true,
    [`cheetah2`] = true,
    [`prototipo`] = true,
    [`turismor`] = true,
    [`pfister811`] = true,
    [`ardent`] = true,
    [`nero`] = true,
    [`nero2`] = true,
    [`tempesta`] = true,
    [`vacca`] = true,
    [`bullet`] = true,
    [`osiris`] = true,
    [`entityxf`] = true,
    [`turismo2`] = true,
    [`fmj`] = true,
    [`re7b`] = true,
    [`tyrus`] = true,
    [`italigtb`] = true,
    [`penetrator`] = true,
    [`monroe`] = true,
    [`ninef2`] = true,
    [`stingergt`] = true,
    [`surfer`] = true,
    [`surfer2`] = true,
    [`gp1`] = true,
    [`autarch`] = true,
    [`tyrant`] = true
}

-- Araç sınıflarına göre bagaj (Trunk) kapasiteleri (Ağırlık gram cinsindendir)
Config.TrunkClasses = {
    [0]  = { maxweight = 300000,  slots = 20 }, -- Compacts
    [1]  = { maxweight = 450000,  slots = 25 }, -- Sedans
    [2]  = { maxweight = 650000,  slots = 40 }, -- SUVs
    [3]  = { maxweight = 500000,  slots = 25 }, -- Coupes
    [4]  = { maxweight = 450000,  slots = 25 }, -- Muscle
    [5]  = { maxweight = 200000,  slots = 20 }, -- Sports Classics
    [6]  = { maxweight = 200000,  slots = 20 }, -- Sports
    [7]  = { maxweight = 150000,  slots = 15 }, -- Super
    [8]  = { maxweight = 0,       slots = 0  }, -- Motorcycles
    [9]  = { maxweight = 1000000, slots = 50 }, -- Off-road
    [10] = { maxweight = 1500000, slots = 50 }, -- Industrial
    [11] = { maxweight = 500000,  slots = 30 }, -- Utility
    [12] = { maxweight = 750000,  slots = 40 }, -- Vans
    [13] = { maxweight = 0,       slots = 0  }, -- Cycles
    [14] = { maxweight = 650000,  slots = 40 }, -- Boats
    [15] = { maxweight = 120000,  slots = 50 }, -- Helicopters
    [16] = { maxweight = 120000,  slots = 50 }, -- Planes
    [17] = { maxweight = 400000,  slots = 30 }, -- Service
    [18] = { maxweight = 600000,  slots = 35 }, -- Emergency
    [19] = { maxweight = 600000,  slots = 35 }, -- Military
    [20] = { maxweight = 1200000, slots = 50 }, -- Commercial
    default = { maxweight = 60000, slots = 35 }
}

-- Araç torpido (Glovebox) kapasiteleri
Config.GloveboxClasses = {
    [2] = { maxweight = 60000, slots = 5 }, -- SUV
    default = { maxweight = 50000, slots = 5 }
}

-- Silah türlerine göre taşınabilecek maksimum mermi değerleri
Config.MaximumAmmoValues = {
    ["pistol"] = 250,
    ["smg"] = 250,
    ["shotgun"] = 200,
    ["rifle"] = 250,
}
