-- =========================================================================
-- NOPIXEL 5.0 DECAY & SPOILAGE CONFIGURATION
-- =========================================================================
Config = Config or {}

Config.EnableDecay = true

Config.DecayItems = {
    ['burger']         = { decayTime = 48 * 3600, spoiledItem = "rotten_food" }, -- 48 saat
    ['twerks_candy']   = { decayTime = 72 * 3600, spoiledItem = "rotten_food" },
    ['snikkel_candy']  = { decayTime = 72 * 3600, spoiledItem = "rotten_food" },
    ['sandwich']       = { decayTime = 36 * 3600, spoiledItem = "rotten_food" },
    ['water_bottle']   = { decayTime = 96 * 3600, spoiledItem = nil },
    ['kurkakola']      = { decayTime = 96 * 3600, spoiledItem = nil },
    ['coffee']         = { decayTime = 24 * 3600, spoiledItem = nil }
}
