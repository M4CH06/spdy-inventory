local Translations = {
    error = {
        item_not_owned = "Bu eşyaya sahip değilsiniz!",
        nobody_nearby = "Yakında kimse yok!",
        action_failed = "İşlem başarısız oldu!",
        action_canceled = "İşlem iptal edildi!",
        vehicle_broken = "Araç ağır hasarlı olduğu için bagaj açılamıyor!",
        vehicle_locked = "Araç kilitli!",
        overweight = "%{item} ağırlık sınırını aştığınız için yere düştü!",
        trunk_overweight = "%{item} bagaj kapasitesi dolduğu için yere düştü!",
        no_item = "Bu eşyaya sahip değilsiniz!",
        not_enough_rep = "Yeterli üretim (craft) tecrübeniz yok!",
        not_enough_materials = "Yeterli üretim malzemeniz bulunmuyor!",
        not_enough_attachment_rep = "Yeterli eklenti üretim tecrübeniz yok!",
        not_accessible = "Bu envantere erişilemez!",
        cant_give_self = "Eşyayı kendinize veremezsiniz!",
        player_not_found = "Oyuncu bulunamadı!",
        too_far_away = "Eşya vermek için oyuncuya çok uzaksınız!",
        item_not_found = "Vermeye çalıştığınız eşya bulunamadı!",
        incorrect_item = "Geçersiz eşya tespit edildi, lütfen tekrar deneyin!",
        invalid_amount = "Geçersiz eşya miktarı!",
        inventory_full = "Envanteriniz tamamen dolu!",
        other_inventory_full = "Diğer oyuncunun envanteri dolu!",
        not_enough_item = "Envanterinizde bu eşyadan yeterli miktarda yok!",
        cant_use_item = "Bu eşyayı şu anda kullanamazsınız!",
        item_decayed = "%{item} bayatlayıp bozuldu!",
        bag_in_bag = "Bir çantayı başka bir çantanın içerisine koyamazsınız!",
        item_too_large_for_pockets = "Bu eşya ceplerinize sığmayacak kadar büyük! Sırt çantası veya bagaj kullanmalısınız.",
        no_attachments_installed = "Bu silaha takılı herhangi bir eklenti bulunmuyor.",
        attachment_already_installed = "Bu tür bir eklenti zaten bu silaha takılı!",
        item_does_not_exist = "Böyle bir eşya mevcut değil!",
        not_enough_cash = "Yeterli nakit paranız bulunmuyor!",
        wrong_items = "Gerekli eşyalara veya malzemelere sahip değilsiniz!",
        invalid_type = "Geçersiz envanter türü!",
        invalid_arguments = "Komut parametreleri eksik veya hatalı girildi!",
        cant_give_item = "Eşya karşı tarafa verilemedi!",
        player_not_online = "Hedef oyuncu şu anda oyunda değil!",
        player_not_cooperative = "Hedef kişi ellerini kaldırmadı, kelepçelenmedi veya etkisiz hale getirilmedi!",
        frisk_too_far = "Üst yoklamak için hedefe daha yakın olmalısınız!",
        frisk_failed = "Üst yoklama işlemi gerçekleştirilemedi!",
        no_vest_equipped = "Üzerinizde plaka takılabilecek bir taktik yelek veya zırh bulunmuyor!",
        plates_full = "Zırh plakaları zaten maksimum seviyede!",
        no_armor_plates = "Envanterinizde seramik zırh plakası (armor_plate) bulunmuyor!"
    },
    success = {
        item_received = "%{player} tarafından %{amount}x %{item} aldınız.",
        item_given = "%{player} kişisine %{amount}x %{item} verdiniz.",
        item_crafted = "%{item} başarıyla üretildi!",
        item_bought = "%{item} başarıyla satın alındı!",
        attachment_detached = "%{attachment} silahtan başarıyla söküldü ve envantere alındı.",
        attachment_attached = "%{attachment} silaha başarıyla monte edildi.",
        decay_checked = "Eşya tazelik kontrolü yapıldı.",
        clothing_synced = "Kıyafet ve aksesuarlar güncellendi.",
        plate_inserted = "Seramik zırh plakası başarıyla takıldı ve zırhınız yenilendi."
    },
    info = {
        inventory = "ENVANTER",
        pockets = "CEPLER",
        backpack = "ÇANTA",
        ground = "YER ENVANTERİ",
        trunk = "ARAÇ BAGAJI",
        glovebox = "TORPİDO",
        stash = "ÖZEL DEPO",
        vending_machine = "Otomat",
        crafting_bench = "Üretim Masası",
        attachment_bench = "Silah Eklenti Masası",
        inspect_title = "EŞYA İNCELEME",
        evidence_tag = "POLİS DELİL TORBASI",
        written_note = "YAZILI BELGE",
        id_card = "KİMLİK KARTI",
        weight = "Ağırlık",
        durability = "Dayanıklılık",
        quality = "Kalite",
        serial = "Seri No",
        ammo = "Mühimmat",
        frisk_found_weapons = "Şahsın üzerinde %{count} adet ateşli silah veya ağır cisim hissedildi!",
        frisk_clean = "Şahsın üzerinde herhangi bir ateşli silah hissedilmedi.",
        being_searched = "Üzeriniz %{player} tarafından aranıyor!",
        being_frisked = "Üzeriniz %{player} tarafından yoklanıyor!"
    },
    progress = {
        crafting = "Eşya üretiliyor...",
        crafting_attachment = "Eklenti monte ediliyor...",
        opening_bag = "Çanta açılıyor...",
        searching = "Envanter aranıyor...",
        inspecting = "Belge inceleniyor...",
        frisking = "Üst yoklanıyor...",
        inserting_plate = "Zırh plakası yerleştiriliyor..."
    },
    ui = {
        body = "VÜCUT",
        accessories = "AKSESUARLAR",
        pockets = "CEPLER",
        backpack = "ÇANTA",
        no_backpack = "ÇANTA YOK",
        ground = "YER ENVANTERİ",
        search = "ARA...",
        use = "Kullan",
        give = "Ver",
        drop = "Yere At",
        split = "Böl",
        attachments = "Eklentiler",
        insert_plate = "Plaka Tak",
        drag_hint = "[SOL TIK] TAŞI",
        use_hint = "[SAĞ TIK] KULLAN / MENÜ",
        shift_hint = "[SHIFT + SOL TIK] HIZLI TAŞI",
        close_hint = "[ESC / TAB] KAPAT",
        weapon_workbench = "SİLAH MODİFİYE TEZGAHI",
        evidence_inspect = "DELİL VE BELGE İNCELEME",
        settings = "ENVANTER AYARLARI",
        language = "Dil Seçimi"
    }
}

if not Locale then
    Locale = {}
    Locale.__index = Locale
    function Locale:new(data)
        local self = setmetatable({}, Locale)
        self.phrases = data.phrases or {}
        return self
    end
    function Locale:t(phrase, subs)
        local current = self.phrases
        for key in string.gmatch(phrase, "[^.]+") do
            if type(current) == "table" and current[key] ~= nil then
                current = current[key]
            else
                return phrase
            end
        end
        if type(current) == "string" and subs then
            for k, v in pairs(subs) do
                current = string.gsub(current, "%%{" .. k .. "}", tostring(v))
            end
        end
        return current
    end
end

local currentLocale = (Config and (Config.Locale or Config.Language)) or GetConvar('qb_locale', 'en')

if currentLocale == 'tr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
