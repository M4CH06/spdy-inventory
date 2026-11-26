-- =========================================================================
-- NOPIXEL 5.0 LIVE CLOTHING & ACCESSORIES SYNC CONFIGURATION
-- =========================================================================
Config = Config or {}

Config.ClothingSync = {
    Enabled = true,
    -- Ped bileşen / prop ID eşleştirmeleri
    Components = {
        ['mask']    = { type = 'component', id = 1, defaultDrawable = 0, defaultTexture = 0 },
        ['armor']   = { type = 'component', id = 9, defaultDrawable = 0, defaultTexture = 0 },
        ['hat']     = { type = 'prop', id = 0 },
        ['glasses'] = { type = 'prop', id = 1 }
    }
}
