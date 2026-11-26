
-- =========================================================================
-- NOPIXEL 5.0 (NOPIXEL V) INVENTORY - CORE CONFIGURATION
-- =========================================================================
-- Modüler sistem ayarları 'config/' klasörü içerisindedir:
--  - config/configCraft.lua    : Üretim masası tarifleri ve silah eklenti tarifleri
--  - config/configVending.lua  : Otomat makineleri, çöp kovaları ve ürün listeleri
--  - config/configBackpack.lua : Gerçek çanta / konteyner (Inception) modelleri
--  - config/configDecay.lua    : Eşya bozulma, çürüme süreleri ve dönüşüm ayarları
--  - config/configClothing.lua : Canlı ped kıyafet ve aksesuar senkronizasyonu
--  - config/configVehicles.lua : Araç sınıfı bagaj/torpido kapasiteleri ve mermi sınırları
-- =========================================================================

Config = Config or {}

-- -------------------------------------------------------------------------
-- 0. DİL VE YERELLEŞTİRME SEÇİMİ (LOCALE / LANGUAGE)
-- -------------------------------------------------------------------------
-- 'tr' : Türkçe  (locales/tr.lua)
-- 'en' : English (locales/en.lua)
-- Sunucu dili buradan tek bir hamleyle seçilebilir.
-- (İsteğe bağlı olarak server.cfg içerisinden 'setr qb_locale "tr"' olarak da ayarlanabilir)
Config.Locale = 'tr'

-- -------------------------------------------------------------------------
-- 1. TEMEL OYUNCU ENVANTER LİMİTLERİ
-- -------------------------------------------------------------------------
Config.MaxInventoryWeight = 250000 -- Oyuncunun taşıyabileceği azami ağırlık (Gram cinsindendir, 250000 = 250 kg)
Config.MaxInventorySlots = 40      -- Toplam envanter slot sayısı (1-20 Cepler / Pockets, 21-40 Çanta / Backpack)

-- -------------------------------------------------------------------------
-- 2. TUŞ VE KONTROL AYARLARI
-- -------------------------------------------------------------------------
Config.OpenKey = 'F2'              -- Varsayılan envanter açma tuşu (Oyuncu GTA ayarlarından değiştirebilir)
Config.HotbarKey = 'Z'             -- Hızlı slot (1-5) HUD çubuğunu açma tuşu

-- -------------------------------------------------------------------------
-- 3. NOPIXEL 5.0 GÖRSEL & ARAYÜZ AYARLARI
-- -------------------------------------------------------------------------
Config.DefaultViewMode = 'auto'    -- 'auto' (Hedef depo varsa Full Stash, yoksa Quick Stash), 'full' veya 'quick'
Config.EnableSoundFX = true        -- Web Audio API prosedürel ses motoru (Fermuar, Kumaş, Tık, Metal, Kağıt)
Config.EnableScreenBlur = true     -- Envanter açıkken arka plan ekran bulanıklaştırma efekti
Config.EnableDurabilityBars = true -- Yuvalarda renkli dayanıklılık ve tazelik çubukları (Yeşil > Sarı > Kırmızı)
Config.DefaultScale = '1.0'        -- Varsayılan UI boyutu ('0.9' = %90, '1.0' = %100, '1.1' = %110)

-- -------------------------------------------------------------------------
-- 4. YERE DÜŞEN EŞYALAR & İŞARETÇİLER (DROPS & GROUND)
-- -------------------------------------------------------------------------
Config.CleanupDropTime = 15 * 60   -- Dokunulmayan yer eşyalarının silinme süresi (Saniye, 15 dakika)
Config.MaxDropViewDistance = 12.5  -- Yerdeki eşya işaretçisinin oyuncuya görünme azami mesafesi
Config.UseItemDrop = false         -- true yapılırsa marker yerine yere 3D çanta/koli modeli spawnlanır
Config.ItemDropObject = `prop_nigel_bag_pickup` -- UseItemDrop aktifken çıkacak dünya modeli

-- Zemin İşaretçisi (Marker) Görünümü
Config.DropMarker = {
    type = 2,                      -- Marker tipi (2 = Ters üçgen ok)
    color = { r = 241, g = 196, b = 15, a = 180 }, -- NoPixel 5.0 altın sarısı rengi
    bobUpAndDown = true,           -- Yukarı aşağı süzülme animasyonu
    rotate = true                  -- Kendi etrafında dönme animasyonu
}

-- -------------------------------------------------------------------------
-- 5. VARSAYILAN ÖZEL DEPO (STASH) KAPASİTESİ
-- -------------------------------------------------------------------------
Config.DefaultStash = {
    maxweight = 1000000,           -- Özel depoların standart ağırlığı (1000 kg)
    slots = 50                     -- Özel depoların standart slot adedi
}

-- -------------------------------------------------------------------------
-- 6. OYUNCU ÜST ARAMA / SOYGUN AYARLARI
-- -------------------------------------------------------------------------
Config.Steal = {
    MaxDistance = 2.5,             -- Üst arama yapılabilecek maksimum mesafe
    RequireHandsUp = true          -- Hedef oyuncunun ellerinin kalkık veya kelepçeli olma şartı
}

-- -------------------------------------------------------------------------
-- 7. DISCORD LOG SİSTEMİ & WEBHOOK AYARLARI
-- -------------------------------------------------------------------------
Config.Logs = {
    Enabled = true,                -- Log sistemi aktif / pasif
    ConsoleLogs = false,           -- Konsola da log yazılsın mı?
    BotName = "NoPixel 5.0 Inventory Logs",
    BotAvatar = "https://i.imgur.com/4A2nKsp.png",
    
    -- Discord Webhook URL'lerinizi ilgili işlemin karşısına giriniz
    Webhooks = {
        ['default']   = "",        -- Genel / varsayılan kanal webhook'u
        ['drop']      = "",        -- Yere eşya atma / yerden alma işlemleri
        ['stash']     = "",        -- Özel depolar (Stash) işlemleri
        ['trunk']     = "",        -- Araç bagajı işlemleri
        ['glovebox']  = "",        -- Torpido işlemleri
        ['give']      = "",        -- Oyuncular arası eşya transferleri
        ['rob']       = "",        -- Üst arama / soygun işlemleri
        ['shop']      = "",        -- Market ve satıcı alışverişleri
        ['craft']     = "",        -- Eşya ve eklenti üretimi (Crafting)
        ['weapons']   = "",        -- Silah çekme / mermi işlemleri
        ['exploit']   = "",        -- Hile, dupe, geçersiz miktar ve güvenlik uyarıları
    },
    
    -- Discord Embed Renkleri (Ondalık / Decimal kodları)
    Colors = {
        ['default']  = 16777215,   -- Beyaz
        ['drop']     = 15158332,   -- Turuncu
        ['stash']    = 3447003,    -- Mavi
        ['trunk']    = 15844367,   -- Altın Sarısı
        ['glovebox'] = 10181046,   -- Mor
        ['give']     = 3066993,    -- Yeşil
        ['rob']      = 12390624,   -- Bordo
        ['shop']     = 5763719,    -- Zümrüt Yeşili
        ['craft']    = 15105570,   -- Koyu Turuncu
        ['weapons']  = 2067276,    -- Lacivert
        ['exploit']  = 16711680,   -- Parlak Kırmızı (Alarm)
    }
}

-- -------------------------------------------------------------------------
-- 7. EŞYA NADİRLİK VE KAÇAK (CONTRABAND) DERECELERİ (NOPIXEL 5.0)
-- -------------------------------------------------------------------------
Config.EnableRarity = true
Config.RarityTiers = {
    contraband = {
        "weed_brick", "weed_baggy", "coke_brick", "coke_baggy", "meth", "oxy",
        "markedbills", "thermite", "trojan_usb", "security_card_01", "security_card_02",
        "weapon_microsmg", "weapon_smg", "weapon_assaultrifle", "weapon_heavysniper",
        "heavyarmor"
    },
    legendary = {
        "goldbar", "diamond", "rolex", "diamond_ring", "weapon_heavypistol"
    },
    rare = {
        "armor", "drill", "electronickit", "lockpick", "advancedlockpick",
        "weapon_combatpistol", "weapon_pistol50", "radio"
    }
}

-- -------------------------------------------------------------------------
-- 8. KORUMALI ÜST ARAMA VE YOKLAMA (FRISK & SEARCH RESTRICTIONS)
-- -------------------------------------------------------------------------
Config.Robbery = {
    requireRestrained = true,     -- Oyuncu kelepçeli, ölü veya elleri havada değilse aranamaz
    enableFrisk = true,           -- Hızlı üst yoklama komutu /frisk ve target seçeneği aktif
    friskDistance = 2.0,          -- Üst yoklama azami mesafesi
    friskDuration = 3000          -- Üst yoklama süresi (Milisaniye)
}
