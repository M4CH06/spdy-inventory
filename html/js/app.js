// ==========================================================================
// NoPixel 5.0 (NoPixel V) Inventory Controller
// ==========================================================================

if (typeof GetParentResourceName !== "function") {
    window.GetParentResourceName = function () { return "qb-inventory"; };
}

// --------------------------------------------------------------------------
// Sound Effects Engine (Web Audio API - High Fidelity Procedural Audio)
// --------------------------------------------------------------------------
const SoundFX = (function () {
    let audioCtx = null;
    function getContext() {
        if (!audioCtx) {
            const AudioContext = window.AudioContext || window.webkitAudioContext;
            if (AudioContext) audioCtx = new AudioContext();
        }
        if (audioCtx && audioCtx.state === "suspended") {
            audioCtx.resume();
        }
        return audioCtx;
    }

    return {
        play: function (type) {
            try {
                const ctx = getContext();
                if (!ctx) return;
                const now = ctx.currentTime;

                if (type === "click") {
                    const osc = ctx.createOscillator();
                    const gain = ctx.createGain();
                    osc.type = "triangle";
                    osc.frequency.setValueAtTime(1400, now);
                    osc.frequency.exponentialRampToValueAtTime(300, now + 0.04);
                    gain.gain.setValueAtTime(0.18, now);
                    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.04);
                    osc.connect(gain);
                    gain.connect(ctx.destination);
                    osc.start(now);
                    osc.stop(now + 0.04);
                } else if (type === "cloth") {
                    const bufferSize = Math.floor(ctx.sampleRate * 0.12);
                    const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
                    const data = buffer.getChannelData(0);
                    for (let i = 0; i < bufferSize; i++) {
                        data[i] = (Math.random() * 2 - 1) * Math.exp(-i / (ctx.sampleRate * 0.03));
                    }
                    const noise = ctx.createBufferSource();
                    noise.buffer = buffer;
                    const filter = ctx.createBiquadFilter();
                    filter.type = "bandpass";
                    filter.frequency.setValueAtTime(800, now);
                    filter.Q.setValueAtTime(1.5, now);
                    const gain = ctx.createGain();
                    gain.gain.setValueAtTime(0.22, now);
                    noise.connect(filter);
                    filter.connect(gain);
                    gain.connect(ctx.destination);
                    noise.start(now);
                } else if (type === "zipper") {
                    for (let i = 0; i < 7; i++) {
                        const toothTime = now + (i * 0.018);
                        const osc = ctx.createOscillator();
                        const gain = ctx.createGain();
                        osc.type = "sawtooth";
                        osc.frequency.setValueAtTime(2000 + (i * 90), toothTime);
                        gain.gain.setValueAtTime(0.07, toothTime);
                        gain.gain.exponentialRampToValueAtTime(0.001, toothTime + 0.012);
                        osc.connect(gain);
                        gain.connect(ctx.destination);
                        osc.start(toothTime);
                        osc.stop(toothTime + 0.012);
                    }
                } else if (type === "metal") {
                    const osc = ctx.createOscillator();
                    const gain = ctx.createGain();
                    osc.type = "sine";
                    osc.frequency.setValueAtTime(2600, now);
                    osc.frequency.exponentialRampToValueAtTime(500, now + 0.09);
                    gain.gain.setValueAtTime(0.25, now);
                    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.09);
                    osc.connect(gain);
                    gain.connect(ctx.destination);
                    osc.start(now);
                    osc.stop(now + 0.09);
                } else if (type === "paper") {
                    const bufferSize = Math.floor(ctx.sampleRate * 0.16);
                    const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
                    const data = buffer.getChannelData(0);
                    for (let i = 0; i < bufferSize; i++) {
                        data[i] = (Math.random() * 2 - 1) * 0.4;
                    }
                    const noise = ctx.createBufferSource();
                    noise.buffer = buffer;
                    const filter = ctx.createBiquadFilter();
                    filter.type = "highpass";
                    filter.frequency.setValueAtTime(2400, now);
                    const gain = ctx.createGain();
                    gain.gain.setValueAtTime(0.18, now);
                    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.16);
                    noise.connect(filter);
                    filter.connect(gain);
                    gain.connect(ctx.destination);
                    noise.start(now);
                } else if (type === "trunk_open") {
                    const osc = ctx.createOscillator();
                    const gain = ctx.createGain();
                    osc.type = "sine";
                    osc.frequency.setValueAtTime(140, now);
                    osc.frequency.exponentialRampToValueAtTime(45, now + 0.15);
                    gain.gain.setValueAtTime(0.35, now);
                    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.15);
                    osc.connect(gain);
                    gain.connect(ctx.destination);
                    osc.start(now);
                    osc.stop(now + 0.15);
                } else if (type === "trunk_close") {
                    const osc = ctx.createOscillator();
                    const gain = ctx.createGain();
                    osc.type = "triangle";
                    osc.frequency.setValueAtTime(110, now);
                    osc.frequency.exponentialRampToValueAtTime(30, now + 0.22);
                    gain.gain.setValueAtTime(0.45, now);
                    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.22);
                    osc.connect(gain);
                    gain.connect(ctx.destination);
                    osc.start(now);
                    osc.stop(now + 0.22);
                } else if (type === "glovebox_open" || type === "glovebox_close") {
                    const osc = ctx.createOscillator();
                    const gain = ctx.createGain();
                    osc.type = "square";
                    osc.frequency.setValueAtTime(1800, now);
                    osc.frequency.exponentialRampToValueAtTime(400, now + 0.05);
                    gain.gain.setValueAtTime(0.2, now);
                    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.05);
                    osc.connect(gain);
                    gain.connect(ctx.destination);
                    osc.start(now);
                    osc.stop(now + 0.05);
                } else if (type === "armor_insert") {
                    const osc = ctx.createOscillator();
                    const gain = ctx.createGain();
                    osc.type = "sine";
                    osc.frequency.setValueAtTime(320, now);
                    osc.frequency.exponentialRampToValueAtTime(900, now + 0.12);
                    gain.gain.setValueAtTime(0.28, now);
                    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.18);
                    osc.connect(gain);
                    gain.connect(ctx.destination);
                    osc.start(now);
                    osc.stop(now + 0.18);
                }
            } catch (e) { }
        }
    };
})();

let CurrentPlayerData = null;
let CurrentOtherData = null;
let CurrentInventoryMode = "full"; // "full" or "quick"
let ActiveCategoryFilter = "all";
let ActiveSearchQuery = "";
let ContextMenuItem = null;
let ShiftKeyPressed = false;
let ItemBoxTimeout = null;

// User Preferences (Persisted in localStorage)
let UserSettings = {
    viewMode: "auto", // "auto", "quick", "full"
    showBody: true,
    showBlur: true,
    showDurability: true,
    uiScale: "1.0",
    lang: "tr"
};
let hasBackpackEquipped = false;

// --------------------------------------------------------------------------
// Multi-Language Localization System (NoPixel 5.0)
// --------------------------------------------------------------------------
const UILocales = {
    tr: {
        body: "VÜCUT",
        accessories: "AKSESUARLAR",
        pockets: "CEPLER",
        backpack: "ÇANTA",
        noBackpack: "ÇANTA YOK",
        ground: "YER ENVANTERİ",
        searchPlaceholder: "ARA...",
        settingsTitle: "ENVANTER AYARLARI",
        settingsSave: "KAYDET & KAPAT",
        viewMode: "Görünüm Modu",
        viewModeDesc: "Varsayılan envanter yerleşimi",
        showBody: "Vücut Yuvalarını Göster",
        showBodyDesc: "Zırh, çanta ve telsiz yuvalarını aç/kapat",
        showBlur: "Arka Plan Bulanıklığı",
        showBlurDesc: "Açıkken sinematik bulanıklık efekti",
        durabilityBars: "Dayanıklılık Çubukları",
        durabilityBarsDesc: "Eşya yuvalarında kalite çubuklarını göster",
        uiScale: "Arayüz Boyutu",
        uiScaleDesc: "Yuva ve yazı boyutunu ayarla",
        langLabel: "Dil / Language",
        langDesc: "Envanter görüntüleme dili",
        ctxUse: '<i class="fa-solid fa-play"></i> Eşyayı Kullan',
        ctxInspect: '<i class="fa-solid fa-magnifying-glass-arrow-right"></i> İncele',
        ctxModWeapon: '<i class="fa-solid fa-screwdriver-wrench"></i> Modifiye Et',
        ctxInsertPlate: '<i class="fa-solid fa-shield-halved"></i> Plaka Tak',
        ctxGive: '<i class="fa-solid fa-hand-holding-hand"></i> Eşya Ver',
        ctxSplit: '<i class="fa-solid fa-divide"></i> Miktarı Böl',
        ctxDrop: '<i class="fa-solid fa-trash-can"></i> Yere At',
        ctxCancel: '<i class="fa-solid fa-xmark"></i> İptal',
        weaponWorkbench: "SİLAH MODİFİYE TEZGAHI",
        installedAttachments: "TAKILI EKLENTİLER",
        compatibleItems: "UYUMLU ENVANTER EŞYALARI",
        integrity: "DURUM",
        docInspect: "EŞYA İNCELEME",
        hintContext: "SAĞ TIK MENÜ",
        hintUse: "KULLAN",
        hintQuickMove: "HIZLI TAŞI",
        hintClose: "KAPAT"
    },
    en: {
        body: "BODY",
        accessories: "ACCESSORIES",
        pockets: "POCKETS",
        backpack: "BACKPACK",
        noBackpack: "NO BACKPACK",
        ground: "GROUND INVENTORY",
        searchPlaceholder: "SEARCH...",
        settingsTitle: "INVENTORY SETTINGS",
        settingsSave: "SAVE & CLOSE",
        viewMode: "Default View",
        viewModeDesc: "Default layout when opening stash",
        showBody: "Show Body Equipment",
        showBodyDesc: "Toggle armor, bag & radio slots column",
        showBlur: "Background Blur",
        showBlurDesc: "Cinematic blur effect when open",
        durabilityBars: "Durability Bars",
        durabilityBarsDesc: "Show quality bars on item slots",
        uiScale: "UI Scale",
        uiScaleDesc: "Adjust size of slots & text",
        langLabel: "Language / Dil",
        langDesc: "Select inventory language",
        ctxUse: '<i class="fa-solid fa-play"></i> Use Item',
        ctxInspect: '<i class="fa-solid fa-magnifying-glass-arrow-right"></i> Inspect',
        ctxModWeapon: '<i class="fa-solid fa-screwdriver-wrench"></i> Modify',
        ctxInsertPlate: '<i class="fa-solid fa-shield-halved"></i> Insert Plate',
        ctxGive: '<i class="fa-solid fa-hand-holding-hand"></i> Give Item',
        ctxSplit: '<i class="fa-solid fa-divide"></i> Split Stack',
        ctxDrop: '<i class="fa-solid fa-trash-can"></i> Drop Item',
        ctxCancel: '<i class="fa-solid fa-xmark"></i> Cancel',
        weaponWorkbench: "WEAPON MODIFICATION",
        installedAttachments: "INSTALLED ATTACHMENTS",
        compatibleItems: "COMPATIBLE INVENTORY ITEMS",
        integrity: "INTEGRITY",
        docInspect: "DOCUMENT INSPECT",
        hintContext: "CONTEXT MENU",
        hintUse: "USE ITEM",
        hintQuickMove: "QUICK MOVE",
        hintClose: "CLOSE"
    }
};

function ApplyLanguage(lang) {
    const t = UILocales[lang] || UILocales.tr;
    $("#col-body .section-title").text(t.body);
    $(".accessories-slots-grid").closest(".section-card").find(".section-title").text(t.accessories);
    $("#col-pockets .section-card:first-child .section-title").text(t.pockets);
    if (!hasBackpackEquipped) {
        $("#backpack-title").text(t.noBackpack);
    } else {
        $("#backpack-title").text(t.backpack);
    }
    const currentOtherLabel = $("#other-inv-label").text().trim();
    if (currentOtherLabel === "GROUND INVENTORY" || currentOtherLabel === "YER ENVANTERİ") {
        $("#other-inv-label").text(t.ground);
    }
    $("#inventory-search").attr("placeholder", t.searchPlaceholder);

    // Context Menu
    $("#ctx-use").html(t.ctxUse);
    $("#ctx-inspect").html(t.ctxInspect);
    $("#ctx-mod-weapon").html(t.ctxModWeapon);
    $("#ctx-insert-plate").html(t.ctxInsertPlate);
    $("#ctx-give").html(t.ctxGive);
    $("#ctx-split").html(t.ctxSplit);
    $("#ctx-drop").html(t.ctxDrop);
    $("#ctx-close").html(t.ctxCancel);

    // Modal Titles
    $("#weapon-mod-title").text(t.weaponWorkbench);
    $("#inspect-modal-title").text(t.docInspect);
    $("#settings-modal .modal-title").text(t.settingsTitle);
    $("#settings-save").text(t.settingsSave);
    $(".cond-label").text(t.integrity);
    $(".installed-col .mod-column-title").html(`<i class="fa-solid fa-link"></i> ${t.installedAttachments}`);
    $(".available-col .mod-column-title").html(`<i class="fa-solid fa-box-open"></i> ${t.compatibleItems}`);

    // Settings descriptions
    $("#setting-lbl-scale").text(t.uiScale);
    $("#setting-desc-scale").text(t.uiScaleDesc);
    $("#setting-lbl-lang").text(t.langLabel);
    $("#setting-desc-lang").text(t.langDesc);

    // Footer Hints
    const $footerHints = $(".footer-hint-group .hint-text");
    if ($footerHints.length >= 4) {
        $footerHints.eq(0).text(t.hintContext);
        $footerHints.eq(1).text(t.hintUse);
        $footerHints.eq(2).text(t.hintQuickMove);
        $footerHints.eq(3).text(t.hintClose);
    }
}

// Number formatter for quantities (e.g. 499990 -> 499,990)
function formatQuantity(num) {
    if (!num) return "x1";
    return "x" + num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Format weight from grams to kg with 1 decimal place (e.g. 8000 -> 8.0)
function formatWeight(grams) {
    if (!grams || isNaN(grams)) return "0.0";
    return (grams / 1000).toFixed(1);
}

// --------------------------------------------------------------------------
// NoPixel 5.0 Pocket Restrictions (Large Items Cannot Fit In Pockets 1-20)
// --------------------------------------------------------------------------
const LargeItemsList = {
    weapon_assaultrifle: true, weapon_carbinerifle: true, weapon_advancedrifle: true,
    weapon_specialcarbine: true, weapon_bullpuprifle: true, weapon_compactrifle: true,
    weapon_militaryrifle: true, weapon_heavyrifle: true, weapon_tacticalrifle: true,
    weapon_pumpshotgun: true, weapon_sawnoffshotgun: true, weapon_assaultshotgun: true,
    weapon_bullpupshotgun: true, weapon_musket: true, weapon_heavyshotgun: true,
    weapon_dbshotgun: true, weapon_combatshotgun: true, weapon_sniperrifle: true,
    weapon_heavysniper: true, weapon_marksmanrifle: true, weapon_precisionrifle: true,
    weapon_mg: true, weapon_combatmg: true, weapon_gusenberg: true,
    weapon_rpg: true, weapon_grenadelauncher: true, weapon_minigun: true,
    weapon_bat: true, weapon_golfclub: true, weapon_crowbar: true, weapon_poolcue: true,
    drill: true, jerrycan: true, scuba_gear: true, oxygen_tank: true
};

function IsItemLarge(itemName) {
    if (!itemName) return false;
    const name = itemName.toLowerCase();
    if (LargeItemsList[name]) return true;
    if (name.includes("rifle") || name.includes("shotgun") || name.includes("sniper") || name.includes("launcher")) {
        return true;
    }
    return false;
}

// --------------------------------------------------------------------------
// Inventory Initialization & Renderers
// --------------------------------------------------------------------------

function SetupSlots() {
    // Generate Pockets slots (1 to 20)
    const $pockets = $("#player-pockets-grid");
    $pockets.empty();
    for (let i = 1; i <= 20; i++) {
        let hotbarBadge = "";
        if (i <= 5) {
            hotbarBadge = `<div class="hotbar-badge">${i}</div>`;
        }
        $pockets.append(`
            <div class="slot" data-slot="${i}" data-inventory="player">
                ${hotbarBadge}
            </div>
        `);
    }

    // Generate Backpack slots (21 to 40)
    const $backpack = $("#player-backpack-grid");
    $backpack.empty();
    for (let i = 21; i <= 40; i++) {
        $backpack.append(`
            <div class="slot" data-slot="${i}" data-inventory="player"></div>
        `);
    }

    InitDraggableDroppable();
}

function RenderPlayerItems(items) {
    // Clear all existing item contents in pockets and backpack
    $(".column-pockets .slot").each(function () {
        const slotNum = parseInt($(this).attr("data-slot"));
        const hotbarBadge = slotNum <= 5 ? `<div class="hotbar-badge">${slotNum}</div>` : "";
        $(this).removeClass("rarity-contraband rarity-legendary rarity-rare").html(hotbarBadge).removeData("item");
    });

    // Clear equipment slots
    $(".equipment-slot").each(function () {
        const defaultIcon = $(this).attr("data-type");
        const iconClasses = {
            radio: "fa-solid fa-walkie-talkie",
            phone: "fa-solid fa-mobile-screen",
            id: "fa-solid fa-id-card",
            bag: "fa-solid fa-bag-shopping",
            keys: "fa-solid fa-key",
            armor: "fa-solid fa-vest",
            wallet: "fa-solid fa-wallet",
            cash: "fa-solid fa-money-bill-wave",
            mask: "fa-solid fa-mask",
            hat: "fa-solid fa-hat-cowboy",
            glasses: "fa-solid fa-glasses",
            gloves: "fa-solid fa-mitten"
        };
        $(this).removeClass("rarity-contraband rarity-legendary rarity-rare").html(`<i class="watermark-icon ${iconClasses[defaultIcon] || 'fa-solid fa-cube'}"></i>`).removeData("item");
    });

    if (!items) return;

    let totalPlayerWeight = 0;
    let hasBackpackItem = false;

    Object.values(items).forEach(item => {
        if (!item || !item.name) return;

        const slot = parseInt(item.slot);
        const weight = (item.weight || 0) * (item.amount || 1);
        totalPlayerWeight += weight;

        // Check if item is a backpack
        if (item.name.toLowerCase().includes("backpack") || item.name.toLowerCase().includes("bag")) {
            hasBackpackItem = true;
        }

        // Render in player inventory slot
        const $slotElem = $(`.column-pockets .slot[data-slot="${slot}"]`);
        if ($slotElem.length) {
            RenderItemInSlot($slotElem, item);
        }

        // Check equipment slots matching item name
        const itemName = item.name.toLowerCase();
        let targetEquipSlot = null;
        if (itemName === "radio") targetEquipSlot = "radio";
        else if (itemName === "phone") targetEquipSlot = "phone";
        else if (itemName === "id_card" || itemName === "driver_license") targetEquipSlot = "id";
        else if (itemName.includes("bag") || itemName.includes("backpack")) targetEquipSlot = "bag";
        else if (itemName.includes("key")) targetEquipSlot = "keys";
        else if (itemName === "armor" || itemName.includes("vest")) targetEquipSlot = "armor";
        else if (itemName === "wallet") targetEquipSlot = "wallet";
        else if (itemName === "cash" || itemName === "money") targetEquipSlot = "cash";
        else if (itemName.includes("mask")) targetEquipSlot = "mask";
        else if (itemName.includes("hat") || itemName.includes("cap") || itemName.includes("helmet")) targetEquipSlot = "hat";
        else if (itemName.includes("glasses")) targetEquipSlot = "glasses";

        if (targetEquipSlot) {
            const $equipElem = $(`.equipment-slot[data-slot="${targetEquipSlot}"]`);
            if ($equipElem.length && !$equipElem.data("item")) {
                RenderItemInSlot($equipElem, item);
            }
        }
    });

    // Update Weight displays
    $("#player-inv-weight").text(formatWeight(totalPlayerWeight));
    if (CurrentPlayerData && CurrentPlayerData.maxweight) {
        $("#player-inv-maxweight").text(formatWeight(CurrentPlayerData.maxweight));
    }

    // Backpack section update
    hasBackpackEquipped = hasBackpackItem;
    const currentLang = UserSettings.lang || "tr";
    const loc = UILocales[currentLang] || UILocales.tr;
    if (hasBackpackItem) {
        $("#backpack-title").text(loc.backpack);
        $("#backpack-max-weight").text("25.0");
    } else {
        $("#backpack-title").text(loc.noBackpack);
        $("#backpack-max-weight").text("0.0");
    }

    ApplyFilters();
}

function RenderOtherItems(other) {
    const $otherGrid = $("#other-grid");
    $otherGrid.empty();

    if (!other) {
        $("#col-other").hide();
        return;
    }

    $("#col-other").show();

    // Set Header label and weights
    const currentLang = UserSettings.lang || "tr";
    const loc = UILocales[currentLang] || UILocales.tr;
    let rawLabel = (other.label || "GROUND INVENTORY").toUpperCase();
    let label = rawLabel;
    if (rawLabel === "GROUND INVENTORY" || rawLabel === "YER ENVANTERİ") {
        label = loc.ground;
    } else {
        if (label.startsWith("STASH-")) label = label.replace("STASH-", (currentLang === "tr" ? "DEPO " : "STASH "));
        if (label.startsWith("TRUNK-")) label = label.replace("TRUNK-", (currentLang === "tr" ? "BAGAJ " : "TRUNK "));
        if (label.startsWith("GLOVEBOX-")) label = label.replace("GLOVEBOX-", (currentLang === "tr" ? "TORPİDO " : "GLOVEBOX "));
    }
    $("#other-inv-label").text(label);
    if (label.startsWith("GLOVEBOX-")) label = label.replace("GLOVEBOX-", "GLOVEBOX ");
    $("#other-inv-label").text(label);

    const maxSlots = other.slots || 30;
    const maxWeight = other.maxweight || 100000;
    $("#other-inv-maxweight").text(formatWeight(maxWeight));

    // Create other slots
    for (let i = 1; i <= maxSlots; i++) {
        $otherGrid.append(`
            <div class="slot" data-slot="${i}" data-inventory="other"></div>
        `);
    }

    let totalOtherWeight = 0;
    if (other.inventory) {
        Object.values(other.inventory).forEach(item => {
            if (!item || !item.name) return;
            const slot = parseInt(item.slot);
            totalOtherWeight += (item.weight || 0) * (item.amount || 1);
            const $slotElem = $(`#other-grid .slot[data-slot="${slot}"]`);
            if ($slotElem.length) {
                RenderItemInSlot($slotElem, item);
            }
        });
    }

    $("#other-inv-weight").text(formatWeight(totalOtherWeight));

    InitDraggableDroppable();
    ApplyFilters();
}

// --------------------------------------------------------------------------
// NoPixel 5.0 Rarity & Contraband Calculation
// --------------------------------------------------------------------------
const ContrabandList = [
    "weed_brick", "weed_baggy", "coke_brick", "coke_baggy", "meth", "oxy",
    "markedbills", "thermite", "trojan_usb", "security_card_01", "security_card_02",
    "weapon_microsmg", "weapon_smg", "weapon_assaultrifle", "weapon_heavysniper",
    "heavyarmor"
];
const LegendaryList = [
    "goldbar", "diamond", "rolex", "diamond_ring", "weapon_heavypistol"
];
const RareList = [
    "armor", "drill", "electronickit", "lockpick", "advancedlockpick",
    "weapon_combatpistol", "weapon_pistol50", "radio"
];

function GetItemRarity(item) {
    if (!item || !item.name) return null;
    const name = item.name.toLowerCase();
    if (item.rarity) return item.rarity.toLowerCase();
    if (ContrabandList.includes(name)) return "contraband";
    if (LegendaryList.includes(name)) return "legendary";
    if (RareList.includes(name)) return "rare";
    if (item.type === "weapon" || name.startsWith("weapon_")) return "rare";
    return null;
}

function RenderItemInSlot($slot, item) {
    $slot.data("item", item);

    // Rarity & Contraband Calculation
    $slot.removeClass("rarity-contraband rarity-legendary rarity-rare");
    const rarity = GetItemRarity(item);
    if (rarity) {
        $slot.addClass(`rarity-${rarity}`);
    }

    // Image path resolution
    const imageSrc = item.image ? `images/${item.image}` : `images/${item.name}.png`;

    // Amount badge
    let amountHtml = "";
    if (item.amount && item.amount > 1) {
        amountHtml = `<div class="item-count">${formatQuantity(item.amount)}</div>`;
    }

    // Durability bar
    let durabilityHtml = "";
    if (item.info && (item.info.quality !== undefined || item.info.durability !== undefined)) {
        let quality = item.info.quality !== undefined ? item.info.quality : item.info.durability;
        if (Array.isArray(quality)) quality = quality[0];
        quality = Math.max(0, Math.min(100, Math.floor(quality)));
        let qualityClass = "";
        if (quality <= 20) qualityClass = "low";
        else if (quality <= 50) qualityClass = "mid";

        durabilityHtml = `
            <div class="item-durability-bar">
                <div class="item-durability-fill ${qualityClass}" style="width: ${quality}%"></div>
            </div>
        `;
    }

    const slotNum = parseInt($slot.attr("data-slot"));
    const hotbarBadge = (slotNum <= 5 && $slot.parent().attr("id") === "player-pockets-grid")
        ? `<div class="hotbar-badge">${slotNum}</div>`
        : "";

    $slot.html(`
        ${hotbarBadge}
        <img class="item-image" src="${imageSrc}" onerror="this.onerror=null;this.src='images/default.png';">
        ${amountHtml}
        ${durabilityHtml}
    `);
}

// --------------------------------------------------------------------------
// Drag and Drop (jQuery UI)
// --------------------------------------------------------------------------

function InitDraggableDroppable() {
    $(".slot").draggable({
        helper: "clone",
        appendTo: "body",
        scroll: false,
        revertDuration: 0,
        revert: "invalid",
        zIndex: 9999,
        cursorAt: { left: 39, top: 39 },
        start: function (event, ui) {
            const item = $(this).data("item");
            if (!item) return false;
            $(this).addClass("dragging");
            $("#item-tooltip").hide();
            $("#context-menu").hide();
        },
        stop: function () {
            $(this).removeClass("dragging");
        }
    });

    $(".slot").droppable({
        accept: ".slot",
        hoverClass: "drag-hover",
        drop: function (event, ui) {
            const $fromSlot = ui.draggable;
            const $toSlot = $(this);

            const fromInventory = $fromSlot.attr("data-inventory");
            const toInventory = $toSlot.attr("data-inventory");
            const fromSlotNum = parseInt($fromSlot.attr("data-slot"));
            const toSlotNum = parseInt($toSlot.attr("data-slot"));

            const fromItem = $fromSlot.data("item");
            if (!fromItem) return;

            // Same slot drop
            if (fromInventory === toInventory && fromSlotNum === toSlotNum) return;

            // Pocket Restriction: Slots 1-20 are pockets. Large items cannot fit!
            if (toInventory === "player" && toSlotNum <= 20) {
                if (IsItemLarge(fromItem.name)) {
                    ShowItemBox(fromItem, "remove", "Too Large for Pockets!");
                    SoundFX.play("metal");
                    $toSlot.addClass("pocket-restricted");
                    setTimeout(() => { $toSlot.removeClass("pocket-restricted"); }, 600);
                    return;
                }
            }

            // Target amount: full stack by default unless specified
            const toAmount = fromItem.amount || 1;

            ExecuteMove(fromInventory, toInventory, fromSlotNum, toSlotNum, toAmount);
        }
    });
}

function ExecuteMove(fromInv, toInv, fromSlot, toSlot, fromAmount, toAmount) {
    let resolvedFromInv = fromInv === "player" ? "player" : (CurrentOtherData ? CurrentOtherData.name : "other");
    let resolvedToInv = toInv === "player" ? "player" : (CurrentOtherData ? CurrentOtherData.name : "other");

    $.post(`https://${GetParentResourceName()}/SetInventoryData`, JSON.stringify({
        fromInventory: resolvedFromInv,
        toInventory: resolvedToInv,
        fromSlot: fromSlot,
        toSlot: toSlot,
        fromAmount: fromAmount,
        toAmount: toAmount || 0
    }));

    $.post(`https://${GetParentResourceName()}/PlayDropSound`, JSON.stringify({}));
    SoundFX.play("click");
}

// --------------------------------------------------------------------------
// Quick Move (Shift + Left Click)
// --------------------------------------------------------------------------

function QuickMoveItem($slot) {
    const item = $slot.data("item");
    if (!item) return;

    const fromInv = $slot.attr("data-inventory");
    const fromSlotNum = parseInt($slot.attr("data-slot"));

    if (fromInv === "player") {
        // Move from player to other inventory
        if (!CurrentOtherData) {
            // Drop to ground
            ExecuteMove("player", "0", fromSlotNum, 1, item.amount);
            return;
        }

        // Find first empty slot in other
        let targetSlot = null;
        $("#other-grid .slot").each(function () {
            if (!$(this).data("item")) {
                targetSlot = parseInt($(this).attr("data-slot"));
                return false;
            }
        });

        if (targetSlot) {
            ExecuteMove("player", CurrentOtherData.name, fromSlotNum, targetSlot, item.amount);
        }
    } else {
        // Move from other inventory to player pockets/backpack
        let targetSlot = null;
        $(".column-pockets .slot").each(function () {
            if (!$(this).data("item")) {
                targetSlot = parseInt($(this).attr("data-slot"));
                return false;
            }
        });

        if (targetSlot) {
            ExecuteMove(CurrentOtherData ? CurrentOtherData.name : "other", "player", fromSlotNum, targetSlot, item.amount);
        }
    }
}

// --------------------------------------------------------------------------
// Category & Search Filters
// --------------------------------------------------------------------------

function ApplyFilters() {
    $(".slot").each(function () {
        const item = $(this).data("item");
        if (!item) {
            $(this).removeClass("dimmed");
            return;
        }

        let matchesCategory = true;
        let matchesSearch = true;

        // Category Filter
        if (ActiveCategoryFilter !== "all") {
            const itemType = (item.type || "").toLowerCase();
            const itemName = (item.name || "").toLowerCase();

            if (ActiveCategoryFilter === "weapon") {
                matchesCategory = itemType === "weapon" || itemName.startsWith("weapon_");
            } else if (ActiveCategoryFilter === "ammo") {
                matchesCategory = itemName.includes("ammo") || itemType === "ammo";
            } else if (ActiveCategoryFilter === "food") {
                matchesCategory = itemName.includes("food") || itemName.includes("water") || itemName.includes("burger") || itemName.includes("cola") || itemName.includes("coffee") || itemName.includes("sandwich") || itemName.includes("drink");
            } else if (ActiveCategoryFilter === "medical") {
                matchesCategory = itemName.includes("bandage") || itemName.includes("medikit") || itemName.includes("firstaid") || itemName.includes("painkiller");
            } else if (ActiveCategoryFilter === "tools") {
                matchesCategory = !itemName.startsWith("weapon_") && !itemName.includes("ammo") && !itemName.includes("food");
            }
        }

        // Search Filter
        if (ActiveSearchQuery.trim() !== "") {
            const label = (item.label || item.name || "").toLowerCase();
            matchesSearch = label.includes(ActiveSearchQuery.toLowerCase());
        }

        if (matchesCategory && matchesSearch) {
            $(this).removeClass("dimmed");
        } else {
            $(this).addClass("dimmed");
        }
    });
}

// --------------------------------------------------------------------------
// Tooltips & Hover Information
// --------------------------------------------------------------------------

function ShowTooltip($slot, event) {
    const item = $slot.data("item");
    if (!item) {
        $("#item-tooltip").hide();
        return;
    }

    $("#tooltip-title").text(item.label || item.name);
    $("#tooltip-count").text(formatQuantity(item.amount || 1));
    $("#tooltip-description").text(item.description || "No description available.");

    // Meta details (Weight, Serial number, etc.)
    let metaHtml = `
        <div class="tooltip-meta-row"><span>Weight</span><span>${((item.weight || 0) / 1000).toFixed(2)} kg</span></div>
    `;

    if (item.info) {
        if (item.info.serie) {
            metaHtml += `<div class="tooltip-meta-row"><span>Serial #</span><span>${item.info.serie}</span></div>`;
        }
        if (item.info.ammo !== undefined) {
            metaHtml += `<div class="tooltip-meta-row"><span>Ammo</span><span>${item.info.ammo} rounds</span></div>`;
        }
    }

    $("#tooltip-meta").html(metaHtml);

    // Durability in tooltip
    if (item.info && (item.info.quality !== undefined || item.info.durability !== undefined)) {
        let quality = item.info.quality !== undefined ? item.info.quality : item.info.durability;
        if (Array.isArray(quality)) quality = quality[0];
        quality = Math.max(0, Math.min(100, Math.floor(quality)));
        $("#tooltip-durability-text").text(quality + "%");
        $("#tooltip-durability-fill").css("width", quality + "%");
        $("#tooltip-durability-wrapper").show();
    } else {
        $("#tooltip-durability-wrapper").hide();
    }

    // Position tooltip smoothly near cursor
    const tooltipWidth = 240;
    const tooltipHeight = 160;
    let x = event.clientX + 15;
    let y = event.clientY + 15;

    if (x + tooltipWidth > window.innerWidth) x = event.clientX - tooltipWidth - 15;
    if (y + tooltipHeight > window.innerHeight) y = event.clientY - tooltipHeight - 15;

    $("#item-tooltip").css({ top: y + "px", left: x + "px" }).fadeIn(80);
}

// --------------------------------------------------------------------------
// Context Menu & Actions
// --------------------------------------------------------------------------

function ShowContextMenu($slot, event) {
    const item = $slot.data("item");
    if (!item) return;

    ContextMenuItem = {
        slot: parseInt($slot.attr("data-slot")),
        inventory: $slot.attr("data-inventory"),
        item: item
    };

    const isWeapon = item.type === "weapon" || (item.name && item.name.toLowerCase().startsWith("weapon_"));
    if (isWeapon) {
        $("#ctx-mod-weapon").show();
    } else {
        $("#ctx-mod-weapon").hide();
    }

    const itemName = item.name ? item.name.toLowerCase() : "";
    const isVest = itemName === "armor" || itemName === "heavyarmor" || itemName.includes("vest");
    if (isVest) {
        $("#ctx-insert-plate").show();
    } else {
        $("#ctx-insert-plate").hide();
    }

    let x = event.clientX;
    let y = event.clientY;
    const menuWidth = 180;
    const menuHeight = 180;

    if (x + menuWidth > window.innerWidth) x = window.innerWidth - menuWidth - 10;
    if (y + menuHeight > window.innerHeight) y = window.innerHeight - menuHeight - 10;

    $("#context-menu").css({ top: y + "px", left: x + "px" }).fadeIn(100);
}

function UseCurrentItem() {
    if (!ContextMenuItem || !ContextMenuItem.item) return;
    $.post(`https://${GetParentResourceName()}/UseItem`, JSON.stringify({
        inventory: ContextMenuItem.inventory,
        item: ContextMenuItem.item
    }));
    CloseContextMenu();
}

function DropCurrentItem() {
    if (!ContextMenuItem || !ContextMenuItem.item) return;
    const item = ContextMenuItem.item;
    ExecuteMove(ContextMenuItem.inventory, "0", ContextMenuItem.slot, 1, item.amount);
    CloseContextMenu();
}

function CloseContextMenu() {
    $("#context-menu").hide();
    ContextMenuItem = null;
}

// --------------------------------------------------------------------------
// Split Stack Modal
// --------------------------------------------------------------------------

function OpenSplitModal() {
    if (!ContextMenuItem || !ContextMenuItem.item) return;
    const totalAmount = ContextMenuItem.item.amount || 1;
    if (totalAmount <= 1) return;

    $("#split-input").attr("max", totalAmount).val(Math.floor(totalAmount / 2));
    $("#split-modal").fadeIn(120);
    $("#split-input").focus();
}

function ConfirmSplit() {
    if (!ContextMenuItem || !ContextMenuItem.item) return;
    const max = ContextMenuItem.item.amount || 1;
    let splitAmt = parseInt($("#split-input").val()) || 1;
    if (splitAmt <= 0) splitAmt = 1;
    if (splitAmt >= max) splitAmt = max - 1;

    // Find next free slot in player inventory
    let freeSlot = null;
    $(".column-pockets .slot").each(function () {
        if (!$(this).data("item")) {
            freeSlot = parseInt($(this).attr("data-slot"));
            return false;
        }
    });

    if (freeSlot) {
        ExecuteMove(ContextMenuItem.inventory, ContextMenuItem.inventory, ContextMenuItem.slot, freeSlot, splitAmt);
    }

    $("#split-modal").hide();
    CloseContextMenu();
}

// --------------------------------------------------------------------------
// Hotbar HUD (Keybind 'Z')
// --------------------------------------------------------------------------

function ToggleHotbarHud(open, items) {
    const $hud = $("#hotbar-hud");
    const $container = $(".hotbar-slots-container");
    $container.empty();

    if (!open) {
        $hud.fadeOut(150);
        return;
    }

    for (let i = 1; i <= 5; i++) {
        const item = items ? Object.values(items).find(it => it && parseInt(it.slot) === i) : null;
        let content = `<div class="hotbar-badge">${i}</div>`;
        if (item) {
            const imageSrc = item.image ? `images/${item.image}` : `images/${item.name}.png`;
            const amountHtml = item.amount > 1 ? `<div class="item-count">${formatQuantity(item.amount)}</div>` : "";
            content += `<img class="item-image" src="${imageSrc}">${amountHtml}`;
        }
        $container.append(`<div class="slot">${content}</div>`);
    }

    $hud.fadeIn(150);
    clearTimeout(ItemBoxTimeout);
    ItemBoxTimeout = setTimeout(() => {
        $hud.fadeOut(400);
    }, 3000);
}

// --------------------------------------------------------------------------
// ItemBox Notifications
// --------------------------------------------------------------------------

function ShowItemBox(item, type, amount) {
    if (!item) return;
    const typeClass = type || "add";
    const imageSrc = item.image ? `images/${item.image}` : `images/${item.name}.png`;
    const label = item.label || item.name;
    const prefix = typeClass === "add" ? "+" : (typeClass === "remove" ? "-" : "");
    const amountText = prefix + (amount || 1);

    const $box = $(`
        <div class="itembox ${typeClass}">
            <img class="itembox-img" src="${imageSrc}">
            <div class="itembox-info">
                <span class="itembox-label">${label}</span>
                <span class="itembox-amount">${amountText}</span>
            </div>
        </div>
    `);

    $("#itemboxes-container").append($box);
    setTimeout(() => {
        $box.fadeOut(300, function () { $(this).remove(); });
    }, 2500);
}

// --------------------------------------------------------------------------
// Settings Management (NoPixel 5.0 Customization)
// --------------------------------------------------------------------------

function LoadSettings() {
    try {
        const saved = localStorage.getItem("np_inventory_settings");
        if (saved) {
            UserSettings = Object.assign(UserSettings, JSON.parse(saved));
        }
    } catch (e) {}

    $("#setting-view-mode").val(UserSettings.viewMode);
    $("#setting-show-body").prop("checked", UserSettings.showBody);
    $("#setting-show-blur").prop("checked", UserSettings.showBlur);
    $("#setting-show-durability").prop("checked", UserSettings.showDurability);
    $("#setting-ui-scale").val(UserSettings.uiScale);
    $("#setting-ui-lang").val(UserSettings.lang || "tr");

    ApplySettings();
    ApplyLanguage(UserSettings.lang || "tr");
}

function SaveSettings() {
    UserSettings.viewMode = $("#setting-view-mode").val();
    UserSettings.showBody = $("#setting-show-body").is(":checked");
    UserSettings.showBlur = $("#setting-show-blur").is(":checked");
    UserSettings.showDurability = $("#setting-show-durability").is(":checked");
    UserSettings.uiScale = $("#setting-ui-scale").val();
    UserSettings.lang = $("#setting-ui-lang").val() || "tr";

    try {
        localStorage.setItem("np_inventory_settings", JSON.stringify(UserSettings));
    } catch (e) {}

    ApplySettings();
    ApplyLanguage(UserSettings.lang);
    $("#settings-modal").fadeOut(120);
}

function ApplySettings() {
    $("body").css("zoom", UserSettings.uiScale);

    if (!UserSettings.showBody) {
        $("#col-body").hide();
    } else if (CurrentInventoryMode === "full") {
        $("#col-body").show();
    }

    if (!UserSettings.showDurability) {
        $(".item-durability-bar").hide();
    } else {
        $(".item-durability-bar").show();
    }
}

// --------------------------------------------------------------------------
// Event Listeners & NUI Handlers
// --------------------------------------------------------------------------

$(document).ready(function () {
    SetupSlots();
    LoadSettings();

    // Settings Modal Triggers
    $("#btn-inventory-settings").on("click", function () {
        $("#settings-modal").fadeIn(120);
    });

    $("#settings-save").on("click", SaveSettings);

    // Mode Switcher: Full Stash vs Quick Stash
    $("#btn-full-stash").on("click", function () {
        CurrentInventoryMode = "full";
        $("#btn-full-stash").addClass("active");
        $("#btn-quick-stash").removeClass("active");
        $("#inventory-hud").removeClass("quick-stash-mode");
        if (UserSettings.showBody) {
            $("#col-body").show();
        }
    });

    $("#btn-quick-stash").on("click", function () {
        CurrentInventoryMode = "quick";
        $("#btn-quick-stash").addClass("active");
        $("#btn-full-stash").removeClass("active");
        $("#inventory-hud").addClass("quick-stash-mode");
    });

    // Category Filter Buttons
    $(".filter-btn").on("click", function () {
        $(".filter-btn").removeClass("active");
        $(this).addClass("active");
        ActiveCategoryFilter = $(this).attr("data-filter");
        ApplyFilters();
    });

    // Search Input
    $("#inventory-search").on("input", function () {
        ActiveSearchQuery = $(this).val();
        if (ActiveSearchQuery.length > 0) {
            $("#search-clear").show();
        } else {
            $("#search-clear").hide();
        }
        ApplyFilters();
    });

    $("#search-clear").on("click", function () {
        $("#inventory-search").val("");
        ActiveSearchQuery = "";
        $(this).hide();
        ApplyFilters();
    });

    let HoveredSlotData = null;

    // Tooltip & Hover Tracking Events (NoPixel 5.0)
    $(document).on("mouseenter", ".slot", function (e) {
        const $this = $(this);
        const slotNum = parseInt($this.attr("data-slot"), 10);
        const inv = $this.attr("data-inventory");
        const item = $this.data("item");
        HoveredSlotData = { slot: slotNum, inventory: inv, item: item, element: $this };
        ShowTooltip($(this), e);
    });

    $(document).on("mousemove", ".slot", function (e) {
        ShowTooltip($(this), e);
    });

    $(document).on("mouseleave", ".slot", function () {
        HoveredSlotData = null;
        $("#item-tooltip").hide();
    });

    // NoPixel 5.0 Quick Half-Split via Middle Click (Mouse Wheel Click)
    $(document).on("mousedown", ".slot", function (e) {
        if (e.button === 1) { // Mouse Wheel Click
            e.preventDefault();
            const $slot = $(this);
            const slotNum = parseInt($slot.attr("data-slot"), 10);
            const inv = $slot.attr("data-inventory");
            const item = $slot.data("item");
            if (item && item.amount > 1) {
                const splitAmt = Math.floor(item.amount / 2);
                if (splitAmt <= 0) return;

                let freeSlot = null;
                if (inv === "player") {
                    $(".column-pockets .slot, .column-backpack .slot").each(function () {
                        const s = parseInt($(this).attr("data-slot"), 10);
                        if (!freeSlot && !$(this).data("item")) {
                            if (s <= 20 && IsLargeItem(item.name)) return;
                            freeSlot = s;
                        }
                    });
                } else if (inv === "other") {
                    $("#other-grid .slot").each(function () {
                        const s = parseInt($(this).attr("data-slot"), 10);
                        if (!freeSlot && !$(this).data("item")) {
                            freeSlot = s;
                        }
                    });
                }

                if (freeSlot) {
                    SoundFX.play("paper");
                    ExecuteMove(inv, inv, slotNum, freeSlot, splitAmt);
                } else {
                    SoundFX.play("error");
                }
            }
        }
    });

    // Context Menu Trigger (Right Click)
    $(document).on("contextmenu", ".slot", function (e) {
        e.preventDefault();
        ShowContextMenu($(this), e);
    });

    // Context Actions
    $("#ctx-use").on("click", UseCurrentItem);
    $("#ctx-inspect").on("click", function () {
        if (ContextMenuItem && ContextMenuItem.item) {
            InspectItem(ContextMenuItem.item);
        }
        CloseContextMenu();
    });
    $("#ctx-mod-weapon").on("click", function () {
        if (ContextMenuItem && ContextMenuItem.item) {
            OpenWeaponModModal(ContextMenuItem.item, ContextMenuItem.slot);
        }
        CloseContextMenu();
    });
    $("#ctx-insert-plate").on("click", function () {
        if (ContextMenuItem && ContextMenuItem.item) {
            $.post(`https://${GetParentResourceName()}/InsertArmorPlate`, JSON.stringify({
                slot: ContextMenuItem.slot
            }));
        }
        CloseContextMenu();
    });
    $("#ctx-drop").on("click", DropCurrentItem);
    $("#ctx-split").on("click", OpenSplitModal);
    $("#ctx-close").on("click", CloseContextMenu);

    // Close Inspect & Weapon Mod Modals
    $("#inspect-modal-close").on("click", function () {
        $("#inspect-modal").fadeOut(120);
    });
    $("#weapon-mod-close").on("click", function () {
        $("#weapon-mod-modal").fadeOut(120);
        CurrentModWeapon = null;
    });

    // Double Click to Use
    $(document).on("dblclick", ".slot", function () {
        const item = $(this).data("item");
        if (item) {
            $.post(`https://${GetParentResourceName()}/UseItem`, JSON.stringify({
                inventory: $(this).attr("data-inventory"),
                item: item
            }));
            CloseInventory();
        }
    });

    // Quick Move Click (Shift + Left Click)
    $(document).on("click", ".slot", function (e) {
        if (e.shiftKey) {
            e.preventDefault();
            QuickMoveItem($(this));
        }
    });

    // Live Clothing & Equipment Interaction
    $(document).on("click", ".equipment-slot", function (e) {
        if (e.shiftKey) return;
        const slotType = $(this).attr("data-type");
        const item = $(this).data("item");
        const isEquipped = $(this).hasClass("equipped");

        if (isEquipped) {
            $(this).removeClass("equipped");
            $.post(`https://${GetParentResourceName()}/SyncClothing`, JSON.stringify({
                slot: slotType,
                action: "unequip",
                item: item
            }));
        } else {
            $(this).addClass("equipped");
            $.post(`https://${GetParentResourceName()}/SyncClothing`, JSON.stringify({
                slot: slotType,
                action: "equip",
                item: item
            }));
        }
        SoundFX.play("cloth");
    });

    // Split Modal Actions
    $("#split-confirm").on("click", ConfirmSplit);
    $("#split-cancel").on("click", function () {
        $("#split-modal").hide();
    });

    $(".quick-btn").on("click", function () {
        if (!ContextMenuItem || !ContextMenuItem.item) return;
        const total = ContextMenuItem.item.amount || 1;
        const amt = $(this).attr("data-amt");
        if (amt === "half") {
            $("#split-input").val(Math.max(1, Math.floor(total / 2)));
        } else if (amt === "all") {
            $("#split-input").val(total);
        } else {
            $("#split-input").val(Math.min(total, parseInt(amt)));
        }
    });

    // Keyboard Keybinds
    $(document).on("keydown", function (e) {
        if (e.key === "Escape" || e.keyCode === 27 || e.keyCode === 9) { // ESC or TAB
            if ($("#weapon-mod-modal").is(":visible")) {
                $("#weapon-mod-modal").fadeOut(120);
                CurrentModWeapon = null;
                return;
            }
            if ($("#inspect-modal").is(":visible")) {
                $("#inspect-modal").fadeOut(120);
                return;
            }
            CloseInventory();
        }
        if (e.keyCode === 16) { // SHIFT
            ShiftKeyPressed = true;
        }

        // NoPixel 5.0 Instant Hotbar Swap (Keys 1-5 while hovering over a slot)
        if (["1", "2", "3", "4", "5"].includes(e.key)) {
            if (HoveredSlotData && HoveredSlotData.item) {
                if (!$("#inventory-search").is(":focus") && !$("#split-input").is(":focus")) {
                    e.preventDefault();
                    const targetSlot = parseInt(e.key, 10);
                    const fromInv = HoveredSlotData.inventory;
                    const fromSlot = HoveredSlotData.slot;

                    if (fromInv === "player" && fromSlot === targetSlot) return;

                    // Pocket restriction check: large item cannot go into slots 1-20
                    if (IsLargeItem(HoveredSlotData.item.name)) {
                        SoundFX.play("error");
                        ShowItemBox(HoveredSlotData.item, "remove", (UserSettings.lang === "tr" ? "Cebe Sığmayacak Kadar Büyük!" : "Too Large for Pockets!"));
                        return;
                    }

                    SoundFX.play("cloth");
                    ExecuteMove(fromInv, "player", fromSlot, targetSlot, HoveredSlotData.item.amount || 1);
                }
            }
        }
    });

    $(document).on("keyup", function (e) {
        if (e.keyCode === 16) {
            ShiftKeyPressed = false;
        }
    });

    $(document).on("click", function (e) {
        if (!$(e.target).closest("#context-menu").length && !$(e.target).closest(".slot").length) {
            CloseContextMenu();
        }
    });
});

function CloseInventory() {
    $("#inventory-hud").fadeOut(150);
    $("#context-menu").hide();
    $("#item-tooltip").hide();
    $("#split-modal").hide();
    $("#settings-modal").hide();
    $("#inspect-modal").hide();
    $("#weapon-mod-modal").hide();
    CurrentModWeapon = null;
    $.post(`https://${GetParentResourceName()}/CloseInventory`, JSON.stringify({}));
}

// --------------------------------------------------------------------------
// Interactive Item Inspect (Evidence, Notes, Photos, ID Cards, Weapons)
// --------------------------------------------------------------------------

function InspectItem(item) {
    if (!item) return;

    const itemName = (item.name || "").toLowerCase();
    const info = item.info || {};
    const $modal = $("#inspect-modal");
    const $title = $("#inspect-modal-title");
    const $body = $("#inspect-modal-body");

    $body.empty();

    // 1. Evidence Bag (Police evidence, casings, blood swab, narcotics)
    if (itemName.includes("evidence") || itemName === "evidence_bag") {
        $title.text("LSPD FORENSIC EVIDENCE");
        SoundFX.play("paper");

        const tracking = info.tracking || "EV-" + Math.floor(10000 + Math.random() * 90000) + "-PD";
        const caseId = info.caseId || info.case || "LSPD-2026-" + Math.floor(1000 + Math.random() * 9000);
        const officer = info.officer || "Officer J. Miller #402";
        const date = info.date || new Date().toLocaleString();
        const location = info.location || "Mission Row / Legion Square";
        const category = info.type || "Ballistic & DNA Forensic Swab";
        const forensicMatch = info.match || info.dna || info.fingerprint || "Matched: Citizen ID (CWX91823) - Verified";

        $body.html(`
            <div class="evidence-container">
                <div class="evidence-hazard-strip"></div>
                <div class="evidence-head">
                    <div class="evidence-agency">LOS SANTOS POLICE DEPARTMENT</div>
                    <div class="evidence-sub">OFFICIAL CHAIN OF CUSTODY EVIDENCE BAG</div>
                </div>
                <div class="evidence-barcode-wrap">
                    <div class="evidence-barcode">|| | |||| | ||||| || |||</div>
                    <div class="evidence-barcode-sub">*${tracking}*</div>
                </div>
                <div class="evidence-grid">
                    <div class="evidence-field">
                        <span class="evidence-label">CASE FILE #</span>
                        <span class="evidence-val">${caseId}</span>
                    </div>
                    <div class="evidence-field">
                        <span class="evidence-label">RECOVERED BY</span>
                        <span class="evidence-val">${officer}</span>
                    </div>
                    <div class="evidence-field">
                        <span class="evidence-label">DATE & TIME</span>
                        <span class="evidence-val">${date}</span>
                    </div>
                    <div class="evidence-field">
                        <span class="evidence-label">LOCATION</span>
                        <span class="evidence-val">${location}</span>
                    </div>
                    <div class="evidence-field full">
                        <span class="evidence-label">EVIDENCE CATEGORY</span>
                        <span class="evidence-val">${category}</span>
                    </div>
                    <div class="evidence-field full">
                        <span class="evidence-label">FORENSIC LAB ANALYSIS / MATCH</span>
                        <span class="evidence-val" style="color: #c0392b;">${forensicMatch}</span>
                    </div>
                </div>
                <div class="evidence-stamp">TAMPER-PROOF EVIDENCE SEAL INTACT - DO NOT BREAK</div>
            </div>
        `);
    }
    // 2. Written Note / Document / Letter
    else if (itemName.includes("note") || itemName.includes("document") || itemName.includes("letter") || itemName.includes("paper")) {
        $title.text("WRITTEN DOCUMENT");
        SoundFX.play("paper");

        const date = info.date || "OCTOBER 24, 2026";
        const title = info.title || "HANDWRITTEN NOTE";
        const text = info.text || info.note || info.message || item.description || "Meet me at the docks near Terminal 4 tonight at 23:00. Come alone and bring the package. If anyone follows you, the deal is off.";
        const author = info.author || info.sign || "— Unknown";

        $body.html(`
            <div class="note-paper">
                <div class="note-header">
                    <span>${title.toUpperCase()}</span>
                    <span>${date}</span>
                </div>
                <div class="note-body">${text}</div>
                <div class="note-footer">${author}</div>
            </div>
        `);
    }
    // 3. Polaroid / Photo
    else if (itemName.includes("photo") || itemName.includes("polaroid") || itemName.includes("picture")) {
        $title.text("POLAROID PHOTOGRAPH");
        SoundFX.play("paper");

        const photoUrl = info.url || info.image || (item.image ? `images/${item.image}` : `images/${item.name}.png`);
        const caption = info.caption || "Surveillance Snapshot - October 2026";

        $body.html(`
            <div class="polaroid-card">
                <div class="polaroid-photo-frame">
                    <img class="polaroid-img" src="${photoUrl}" onerror="this.onerror=null;this.src='images/default.png';">
                </div>
                <div class="polaroid-caption">${caption}</div>
            </div>
        `);
    }
    // 4. Identification Card / Driver License / Badge
    else if (itemName.includes("id_card") || itemName.includes("driver_license") || itemName.includes("badge")) {
        $title.text("STATE OF SAN ANDREAS IDENTIFICATION");
        SoundFX.play("cloth");

        const citizenId = info.citizenid || "CWX91823";
        const firstName = info.firstname || "John";
        const lastName = info.lastname || "Marston";
        const birthdate = info.birthdate || "1994-06-18";
        const gender = (info.gender === 0 || info.gender === "0" || info.gender === "m") ? "MALE" : "FEMALE";
        const nationality = info.nationality || "American";
        const photoUrl = info.photo || "images/default.png";

        $body.html(`
            <div class="id-card-view">
                <i class="id-seal-bg fa-solid fa-shield-halved"></i>
                <div class="id-card-top">
                    <span class="id-card-state">SAN ANDREAS</span>
                    <span class="id-card-type">DRIVER LICENSE / CITIZEN ID</span>
                </div>
                <div class="id-card-body">
                    <div class="id-photo-box">
                        <img class="id-photo-img" src="${photoUrl}" onerror="this.onerror=null;this.src='images/default.png';">
                    </div>
                    <div class="id-info-grid">
                        <div class="id-info-item full">
                            <span class="id-info-label">FULL NAME</span>
                            <span class="id-info-val">${firstName.toUpperCase()} ${lastName.toUpperCase()}</span>
                        </div>
                        <div class="id-info-item">
                            <span class="id-info-label">CITIZEN ID</span>
                            <span class="id-info-val">${citizenId}</span>
                        </div>
                        <div class="id-info-item">
                            <span class="id-info-label">DOB</span>
                            <span class="id-info-val">${birthdate}</span>
                        </div>
                        <div class="id-info-item">
                            <span class="id-info-label">SEX</span>
                            <span class="id-info-val">${gender}</span>
                        </div>
                        <div class="id-info-item">
                            <span class="id-info-label">EXP</span>
                            <span class="id-info-val">2030-12-31</span>
                        </div>
                    </div>
                </div>
                <div class="id-card-bottom">
                    <span class="id-barcode-line">|||| ||| ||||| || |||||| | ||||</span>
                    <span style="font-size: 8px; color: #f1c40f; font-weight: bold;"><i class="fa-solid fa-star"></i> REAL ID</span>
                </div>
            </div>
        `);
    }
    // 5. Weapon Inspection & Blueprint
    else if (item.type === "weapon" || itemName.startsWith("weapon_")) {
        $title.text("WEAPON SPECIFICATION & FORENSICS");
        SoundFX.play("metal");

        const imageSrc = item.image ? `images/${item.image}` : `images/${item.name}.png`;
        const serie = info.serie || "SERIAL-WPN-UNKNOWN";
        const ammo = info.ammo !== undefined ? info.ammo : "30";
        const quality = info.quality !== undefined ? info.quality : 100;
        let attachmentsText = "None";
        if (info.attachments && Array.isArray(info.attachments) && info.attachments.length > 0) {
            attachmentsText = info.attachments.map(a => a.component || a).join(", ");
        }

        $body.html(`
            <div class="weapon-spec-view">
                <div class="weapon-spec-header">
                    <span class="weapon-spec-name">${item.label || item.name}</span>
                    <span style="color: #2ecc71; font-weight: 700; font-size: 13px;"><i class="fa-solid fa-shield"></i> LICENSED</span>
                </div>
                <img class="weapon-spec-img" src="${imageSrc}" onerror="this.onerror=null;this.src='images/default.png';">
                <div class="weapon-spec-stats">
                    <div class="weapon-stat-row">
                        <div class="weapon-stat-label">SERIAL NUMBER</div>
                        <div class="weapon-stat-val">${serie}</div>
                    </div>
                    <div class="weapon-stat-row">
                        <div class="weapon-stat-label">ROUNDS CHAMBERED</div>
                        <div class="weapon-stat-val">${ammo} RDS</div>
                    </div>
                    <div class="weapon-stat-row">
                        <div class="weapon-stat-label">CONDITION</div>
                        <div class="weapon-stat-val">${quality}%</div>
                    </div>
                    <div class="weapon-stat-row">
                        <div class="weapon-stat-label">ATTACHMENTS</div>
                        <div class="weapon-stat-val" style="font-size: 11px;">${attachmentsText}</div>
                    </div>
                </div>
            </div>
        `);
    }
    // 6. Generic Forensic / Tech Card
    else {
        $title.text("ITEM FORENSICS & SPECIFICATION");
        SoundFX.play("click");

        const imageSrc = item.image ? `images/${item.image}` : `images/${item.name}.png`;
        const quality = info.quality !== undefined ? info.quality : (info.durability !== undefined ? info.durability : 100);

        $body.html(`
            <div class="weapon-spec-view" style="border-color: rgba(255, 255, 255, 0.2);">
                <div class="weapon-spec-header">
                    <span class="weapon-spec-name" style="color: #ffffff;">${item.label || item.name}</span>
                    <span style="color: #3498db; font-size: 12px; font-weight: 600;">COUNT: x${item.amount || 1}</span>
                </div>
                <img class="weapon-spec-img" src="${imageSrc}" style="height: 90px;" onerror="this.onerror=null;this.src='images/default.png';">
                <p style="font-size: 13px; color: rgba(255, 255, 255, 0.7); margin-bottom: 12px;">${item.description || "Standard item documentation."}</p>
                <div class="weapon-spec-stats">
                    <div class="weapon-stat-row">
                        <div class="weapon-stat-label">WEIGHT</div>
                        <div class="weapon-stat-val">${formatWeight(item.weight)} KG</div>
                    </div>
                    <div class="weapon-stat-row">
                        <div class="weapon-stat-label">FRESHNESS / INTEGRITY</div>
                        <div class="weapon-stat-val">${quality}%</div>
                    </div>
                </div>
            </div>
        `);
    }

    $modal.fadeIn(120);
}

// --------------------------------------------------------------------------
// Tactical Weapon Workbench (NoPixel 5.0 Weapon Stripper & Attachment Modding)
// --------------------------------------------------------------------------

let CurrentModWeapon = null;

function OpenWeaponModModal(weaponItem, slot) {
    if (!weaponItem) return;
    CurrentModWeapon = { item: weaponItem, slot: slot };

    const info = weaponItem.info || {};
    const attachments = info.attachments || [];
    const quality = info.quality !== undefined ? info.quality : 100;
    const serie = info.serie || "SERIAL-UNKNOWN";
    const imageSrc = weaponItem.image ? `images/${weaponItem.image}` : `images/${weaponItem.name}.png`;

    $("#weapon-mod-title").text((weaponItem.label || weaponItem.name).toUpperCase() + " BENCH");
    $("#weapon-mod-serial").text("SN: " + serie);
    $("#weapon-mod-image").attr("src", imageSrc);
    $("#weapon-mod-condition-fill").css("width", quality + "%");
    $("#weapon-mod-condition-text").text(quality + "%");

    RenderInstalledAttachments(attachments);
    RenderAvailableAttachments(weaponItem);

    SoundFX.play("metal");
    $("#weapon-mod-modal").fadeIn(120);
}

function RenderInstalledAttachments(attachments) {
    const $list = $("#installed-attachments-list");
    $list.empty();

    if (!attachments || attachments.length === 0) {
        $list.html(`<div class="mod-empty-text">No attachments installed on this weapon.</div>`);
        return;
    }

    attachments.forEach((att) => {
        const attItem = typeof att === "object" ? (att.item || att.name) : att;
        const attLabel = typeof att === "object" ? (att.label || attItem) : attItem;
        const imageSrc = `images/${attItem}.png`;

        const $row = $(`
            <div class="mod-item-row" data-attachment="${attItem}">
                <div class="mod-item-left">
                    <img class="mod-item-icon" src="${imageSrc}" onerror="this.onerror=null;this.src='images/default.png';">
                    <div class="mod-item-info">
                        <span class="mod-item-name">${attLabel}</span>
                        <span class="mod-item-type">INSTALLED COMPONENT</span>
                    </div>
                </div>
                <button type="button" class="btn-mod-action detach" data-att="${attItem}">
                    <i class="fa-solid fa-screwdriver"></i> DETACH
                </button>
            </div>
        `);
        $list.append($row);
    });
}

function RenderAvailableAttachments(weaponItem) {
    const $list = $("#available-attachments-list");
    $list.empty();

    if (!CurrentPlayerData || !CurrentPlayerData.inventory) {
        $list.html(`<div class="mod-empty-text">No compatible attachments in inventory.</div>`);
        return;
    }

    const weaponName = (weaponItem.name || "").toLowerCase();
    const installed = (weaponItem.info && weaponItem.info.attachments) || [];
    const installedNames = installed.map(a => typeof a === "object" ? (a.item || a.name) : a);

    const compatibleItems = [];
    Object.values(CurrentPlayerData.inventory).forEach(invItem => {
        if (!invItem || !invItem.name) return;
        const name = invItem.name.toLowerCase();

        let isCompat = false;
        if (weaponName.includes("pistol") && name.startsWith("pistol_") && !name.includes("ammo")) {
            isCompat = true;
        } else if (weaponName.includes("smg") && (name.startsWith("smg_") || name.startsWith("microsmg_")) && !name.includes("ammo")) {
            isCompat = true;
        } else if (weaponName.includes("rifle") && (name.startsWith("rifle_") || name.startsWith("assaultrifle_")) && !name.includes("ammo")) {
            isCompat = true;
        } else if (weaponName.includes("shotgun") && name.startsWith("shotgun_") && !name.includes("ammo")) {
            isCompat = true;
        } else if (name.includes("suppressor") || name.includes("extendedclip") || name.includes("drum") || name.includes("scope") || name.includes("flashlight")) {
            isCompat = true;
        }

        if (isCompat && !installedNames.includes(invItem.name)) {
            compatibleItems.push(invItem);
        }
    });

    if (compatibleItems.length === 0) {
        $list.html(`<div class="mod-empty-text">No compatible attachments in bag.</div>`);
        return;
    }

    compatibleItems.forEach(item => {
        const imageSrc = item.image ? `images/${item.image}` : `images/${item.name}.png`;
        const $row = $(`
            <div class="mod-item-row" data-item="${item.name}" data-slot="${item.slot}">
                <div class="mod-item-left">
                    <img class="mod-item-icon" src="${imageSrc}" onerror="this.onerror=null;this.src='images/default.png';">
                    <div class="mod-item-info">
                        <span class="mod-item-name">${item.label || item.name}</span>
                        <span class="mod-item-type">AVAILABLE IN BAG (x${item.amount || 1})</span>
                    </div>
                </div>
                <button type="button" class="btn-mod-action attach" data-slot="${item.slot}" data-name="${item.name}">
                    <i class="fa-solid fa-wrench"></i> ATTACH
                </button>
            </div>
        `);
        $list.append($row);
    });
}

$(document).on("click", ".btn-mod-action.detach", function () {
    if (!CurrentModWeapon) return;
    const attName = $(this).attr("data-att");
    SoundFX.play("metal");
    $.post(`https://${GetParentResourceName()}/DetachAttachment`, JSON.stringify({
        weaponSlot: CurrentModWeapon.slot,
        attachmentItem: attName
    }));
    $(this).closest(".mod-item-row").fadeOut(150, function () { $(this).remove(); });
});

$(document).on("click", ".btn-mod-action.attach", function () {
    if (!CurrentModWeapon) return;
    const attSlot = parseInt($(this).attr("data-slot"));
    const attName = $(this).attr("data-name");
    SoundFX.play("metal");
    $.post(`https://${GetParentResourceName()}/AttachAttachment`, JSON.stringify({
        weaponSlot: CurrentModWeapon.slot,
        attachmentSlot: attSlot,
        attachmentItem: attName
    }));
    $(this).closest(".mod-item-row").fadeOut(150, function () { $(this).remove(); });
});

// --------------------------------------------------------------------------
// Window NUI Messages from Client Lua
// --------------------------------------------------------------------------

window.addEventListener("message", function (event) {
    const data = event.data;
    if (!data || !data.action) return;

    switch (data.action) {
        case "open":
            SoundFX.play("zipper");
            if (data.locale) {
                // If user hasn't explicitly set language preference in localStorage, follow server config
                try {
                    const saved = localStorage.getItem("np_inventory_settings");
                    if (!saved || !JSON.parse(saved).lang) {
                        UserSettings.lang = data.locale;
                        $("#setting-ui-lang").val(data.locale);
                    }
                } catch (e) {}
            }
            ApplyLanguage(UserSettings.lang || data.locale || "tr");

            CurrentPlayerData = {
                inventory: data.inventory,
                maxweight: data.maxweight,
                slots: data.slots,
                cash: data.cash
            };
            CurrentOtherData = data.other;

            // Render Player Items
            RenderPlayerItems(data.inventory);

            // Render Other Inventory
            RenderOtherItems(data.other);

            // Switch view based on user setting or presence of other inventory
            if (UserSettings.viewMode === "quick") {
                $("#btn-quick-stash").click();
            } else if (UserSettings.viewMode === "full") {
                $("#btn-full-stash").click();
            } else {
                if (!data.other) {
                    $("#btn-quick-stash").click();
                } else {
                    $("#btn-full-stash").click();
                }
            }

            ApplySettings();

            $("#inventory-hud").fadeIn(150);
            break;

        case "close":
            $("#inventory-hud").fadeOut(150);
            $("#context-menu").hide();
            $("#item-tooltip").hide();
            $("#split-modal").hide();
            $("#settings-modal").hide();
            $("#inspect-modal").hide();
            break;

        case "update":
            if (CurrentPlayerData) {
                CurrentPlayerData.inventory = data.inventory;
                if (data.maxweight) CurrentPlayerData.maxweight = data.maxweight;
            }
            RenderPlayerItems(data.inventory);
            break;

        case "hotbar":
            ToggleHotbarHud(data.open, data.items);
            break;

        case "itemBox":
            ShowItemBox(data.item, data.type, data.amount);
            break;

        case "requiredItem":
            // Optional required item display
            break;

        case "playSound":
            if (data.sound) SoundFX.play(data.sound);
            break;
    }
});
