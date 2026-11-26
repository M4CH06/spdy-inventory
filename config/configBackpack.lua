-- =========================================================================
-- NOPIXEL 5.0 CONTAINER BACKPACKS & POCKET RESTRICTIONS
-- =========================================================================
Config = Config or {}

-- -------------------------------------------------------------------------
-- 1. TAŞINABİLİR ÇANTA / KONTEYNER MODELLERİ (INCEPTION STASH)
-- -------------------------------------------------------------------------
Config.BackpackItems = {
    ['backpack'] = {
        slots = 15,
        maxweight = 30000,
        label = "Backpack"
    },
    ['backpack_red'] = {
        slots = 15,
        maxweight = 35000,
        label = "Red Backpack"
    },
    ['duffle_bag'] = {
        slots = 20,
        maxweight = 50000,
        label = "Duffle Bag"
    },
    ['briefcase'] = {
        slots = 8,
        maxweight = 15000,
        label = "Briefcase"
    }
}

-- -------------------------------------------------------------------------
-- 2. CEBE / ÇANTAYA BOYUT KISITLAMASI (LARGE ITEM / POCKET RESTRICTIONS)
-- -------------------------------------------------------------------------
-- NoPixel 5.0 kuralı: 1-20 arası yuvalar ceplerdir (Pockets), 21-40 sırt çantasıdır.
-- Büyük ve hacimli eşyalar (tüfekler, ağır silahlar, büyük aletler) ceplere koyulamaz.
Config.MaxPocketSlot = 20
Config.EnforcePocketRestrictions = true

Config.LargeItems = {
    -- Uzun Namlulu & Ağır Ateşli Silahlar
    ['weapon_assaultrifle'] = true,
    ['weapon_carbinerifle'] = true,
    ['weapon_advancedrifle'] = true,
    ['weapon_specialcarbine'] = true,
    ['weapon_bullpuprifle'] = true,
    ['weapon_compactrifle'] = true,
    ['weapon_militaryrifle'] = true,
    ['weapon_heavyrifle'] = true,
    ['weapon_tacticalrifle'] = true,
    ['weapon_pumpshotgun'] = true,
    ['weapon_sawnoffshotgun'] = true,
    ['weapon_assaultshotgun'] = true,
    ['weapon_bullpupshotgun'] = true,
    ['weapon_musket'] = true,
    ['weapon_heavyshotgun'] = true,
    ['weapon_dbshotgun'] = true,
    ['weapon_combatshotgun'] = true,
    ['weapon_sniperrifle'] = true,
    ['weapon_heavysniper'] = true,
    ['weapon_marksmanrifle'] = true,
    ['weapon_precisionrifle'] = true,
    ['weapon_mg'] = true,
    ['weapon_combatmg'] = true,
    ['weapon_gusenberg'] = true,
    ['weapon_rpg'] = true,
    ['weapon_grenadelauncher'] = true,
    ['weapon_minigun'] = true,
    ['weapon_firework'] = true,
    ['weapon_hominglauncher'] = true,
    ['weapon_compactlauncher'] = true,
    -- Büyük / Hacimli Yakın Dövüş Aletleri
    ['weapon_bat'] = true,
    ['weapon_golfclub'] = true,
    ['weapon_crowbar'] = true,
    ['weapon_poolcue'] = true,
    ['weapon_wrench'] = true,
    ['weapon_battleaxe'] = true,
    -- Büyük Ağır Alet ve Ekipmanlar
    ['drill'] = true,
    ['jerrycan'] = true,
    ['scuba_gear'] = true,
    ['oxygen_tank'] = true,
    ['metal_detector'] = true
}

---Eşyanın cebe sığmayacak kadar büyük olup olmadığını kontrol eder
---@param itemName string
---@return boolean isLarge
function IsLargeItem(itemName)
    if not Config.EnforcePocketRestrictions or not itemName then return false end
    itemName = string.lower(itemName)
    if Config.LargeItems[itemName] then return true end
    
    -- Otomatik tüfek, pompalı, roketatar vb. desen kontrolü
    if string.find(itemName, "rifle") or string.find(itemName, "shotgun") or string.find(itemName, "sniper") or string.find(itemName, "launcher") then
        return true
    end
    return false
end

-- -------------------------------------------------------------------------
-- 3. SİLAH MODİFİYE & EKLENTİ UYUMLULUK TABLOSU (WEAPON ATTACHMENTS MAP)
-- -------------------------------------------------------------------------
Config.WeaponAttachmentMap = {
    -- Tabancalar (Pistols)
    ['pistol'] = {
        ['pistol_suppressor'] = { label = "Suppressor", type = "barrel" },
        ['pistol_extendedclip'] = { label = "Extended Magazine", type = "magazine" },
        ['pistol_flashlight'] = { label = "Tactical Flashlight", type = "flash" }
    },
    -- Hafif Makineli (SMG)
    ['smg'] = {
        ['smg_suppressor'] = { label = "Tactical Suppressor", type = "barrel" },
        ['smg_extendedclip'] = { label = "Extended Magazine", type = "magazine" },
        ['smg_drum'] = { label = "Drum Magazine", type = "magazine" },
        ['smg_scope'] = { label = "Reflex / Holographic Scope", type = "optic" },
        ['smg_flashlight'] = { label = "Tactical Flashlight", type = "flash" },
        ['microsmg_extendedclip'] = { label = "Micro SMG Clip", type = "magazine" }
    },
    -- Tüfekler (Rifles)
    ['rifle'] = {
        ['rifle_suppressor'] = { label = "Heavy Suppressor", type = "barrel" },
        ['assaultrifle_extendedclip'] = { label = "Extended Mag", type = "magazine" },
        ['assaultrifle_drum'] = { label = "Drum Magazine", type = "magazine" },
        ['rifle_scope'] = { label = "ACOG / Combat Scope", type = "optic" },
        ['rifle_flashlight'] = { label = "Weapon Light", type = "flash" }
    },
    -- Pompalılar (Shotguns)
    ['shotgun'] = {
        ['shotgun_suppressor'] = { label = "Shotgun Choke / Silencer", type = "barrel" },
        ['shotgun_extendedclip'] = { label = "Extended Tube", type = "magazine" }
    }
}
