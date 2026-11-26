local Translations = {
    error = {
        item_not_owned = "You do not own this item!",
        nobody_nearby = "No one nearby!",
        action_failed = "Action failed!",
        action_canceled = "Action canceled!",
        vehicle_broken = "Vehicle is broken, can't open trunk!",
        vehicle_locked = "Vehicle is locked!",
        overweight = "%{item} fell on the ground because you are overweight!",
        trunk_overweight = "%{item} fell on the ground because trunk is overweight!",
        no_item = "You don't have this item!",
        not_enough_rep = "You don't have enough crafting reputation!",
        not_enough_materials = "You don't have enough materials!",
        not_enough_attachment_rep = "You don't have enough attachment crafting reputation!",
        not_accessible = "Inventory not accessible!",
        cant_give_self = "You can't give an item to yourself!",
        player_not_found = "Player not found!",
        too_far_away = "You are too far away to give items!",
        item_not_found = "Item you tried giving was not found!",
        incorrect_item = "Incorrect item found, try again!",
        invalid_amount = "Invalid item amount!",
        inventory_full = "Your inventory is full!",
        other_inventory_full = "The other player's inventory is full!",
        not_enough_item = "You do not have enough of the item!",
        cant_use_item = "You can't use this item right now!",
        item_decayed = "%{item} has expired and spoiled!",
        bag_in_bag = "You cannot put a container inside another container!",
        item_too_large_for_pockets = "This item is too large for your pockets! You must use a backpack or trunk.",
        no_attachments_installed = "No attachments installed on this weapon.",
        attachment_already_installed = "This attachment type is already installed on this weapon!",
        item_does_not_exist = "Item does not exist!",
        not_enough_cash = "You do not have enough cash!",
        wrong_items = "You do not have the required items!",
        invalid_type = "Not a valid inventory type!",
        invalid_arguments = "Command arguments not filled out correctly!",
        cant_give_item = "Could not give item!",
        player_not_online = "Player is not online!",
        player_not_cooperative = "Target player does not have hands up, is not cuffed, and is not restrained!",
        frisk_too_far = "You are too far away to frisk the target!",
        frisk_failed = "Frisk action could not be completed!",
        no_vest_equipped = "You do not have a tactical vest or armor equipped to insert plates!",
        plates_full = "Your armor plates are already at maximum capacity!",
        no_armor_plates = "You do not have any ceramic armor plates (armor_plate) in your inventory!"
    },
    success = {
        item_received = "You received %{amount}x %{item} from %{player}.",
        item_given = "You gave %{player} %{amount}x %{item}.",
        item_crafted = "Successfully crafted %{item}!",
        item_bought = "Successfully purchased %{item}!",
        attachment_detached = "Successfully detached %{attachment} from your weapon.",
        attachment_attached = "Successfully mounted %{attachment} to your weapon.",
        decay_checked = "Item freshness verified.",
        clothing_synced = "Equipped accessories updated.",
        plate_inserted = "Ceramic armor plate successfully inserted and armor restored."
    },
    info = {
        inventory = "INVENTORY",
        pockets = "POCKETS",
        backpack = "BACKPACK",
        ground = "GROUND INVENTORY",
        trunk = "VEHICLE TRUNK",
        glovebox = "GLOVEBOX",
        stash = "STASH",
        vending_machine = "Vending Machine",
        crafting_bench = "Crafting Bench",
        attachment_bench = "Attachment Crafting",
        inspect_title = "ITEM INSPECT",
        evidence_tag = "POLICE EVIDENCE",
        written_note = "WRITTEN DOCUMENT",
        id_card = "IDENTIFICATION CARD",
        weight = "Weight",
        durability = "Durability",
        quality = "Quality",
        serial = "Serial #",
        ammo = "Ammo",
        frisk_found_weapons = "%{count} weapon(s) or heavy objects detected on the target!",
        frisk_clean = "No firearms or dangerous objects detected on the target.",
        being_searched = "Your pockets are being searched by %{player}!",
        being_frisked = "You are being frisked by %{player}!"
    },
    progress = {
        crafting = "Crafting item...",
        crafting_attachment = "Crafting attachment...",
        opening_bag = "Opening container...",
        searching = "Searching inventory...",
        inspecting = "Inspecting item...",
        frisking = "Frisking player...",
        inserting_plate = "Inserting armor plate..."
    },
    ui = {
        body = "BODY",
        accessories = "ACCESSORIES",
        pockets = "POCKETS",
        backpack = "BACKPACK",
        no_backpack = "NO BACKPACK",
        ground = "GROUND INVENTORY",
        search = "SEARCH...",
        use = "Use",
        give = "Give",
        drop = "Drop",
        split = "Split",
        attachments = "Attachments",
        insert_plate = "Insert Plate",
        drag_hint = "[LMB] DRAG",
        use_hint = "[RMB] USE / CONTEXT",
        shift_hint = "[SHIFT + LMB] QUICK MOVE",
        close_hint = "[ESC / TAB] CLOSE",
        weapon_workbench = "WEAPON WORKBENCH",
        evidence_inspect = "EVIDENCE / DOCUMENT VIEWER",
        settings = "INVENTORY SETTINGS",
        language = "Language"
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

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
