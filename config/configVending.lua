-- =========================================================================
-- VENDING MACHINES & TRASH BINS CONFIGURATION
-- =========================================================================
Config = Config or {}

-- Vending Machine World Object Models
Config.VendingObjects = {
    "prop_vend_snak_01",
    -654402915,
    -1034034125
}

Config.VendingDrinksObjects = {
    "prop_vend_soda_01",
    "prop_vend_soda_02",
    "prop_vend_water_01"
}

Config.VendingCoffeeObjects = {
    690372739
}

Config.BinObjects = {
    "prop_bin_05a",
}

-- Vending Machine Snack Food Items
Config.VendingFoods = {
    [1] = {
        name = "twerks_candy",
        price = 4,
        amount = 50,
        info = {},
        type = "item",
        slot = 1,
    },
    [2] = {
        name = "snikkel_candy",
        price = 4,
        amount = 50,
        info = {},
        type = "item",
        slot = 2,
    },
}

-- Vending Machine Cold Drinks
Config.VendingDrinks = {
    [1] = {
        name = "kurkakola",
        price = 4,
        amount = 50,
        info = {},
        type = "item",
        slot = 1,
    },
    [2] = {
        name = "water_bottle",
        price = 4,
        amount = 50,
        info = {},
        type = "item",
        slot = 2,
    },
}

-- Vending Machine Hot Coffee
Config.VendingCoffee = {
    [1] = {
        name = "coffee",
        price = 4,
        amount = 50,
        info = {},
        type = "item",
        slot = 1,
    },
}
