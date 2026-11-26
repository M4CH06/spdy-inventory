--#region Variables

local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local inInventory = false
local currentWeapon = nil
local currentOtherInventory = nil
local Drops = {}
local CurrentDrop = nil
local DropsNear = {}
local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local isHotbar = false
local WeaponAttachments = {}
local showBlur = true

isCrafting = false

local MaxBuff = 500000
function MaxWeight(amount)
    if amount > MaxBuff then
        MaxBuff = amount
    end
    QBCore.Config.Player.MaxWeight = amount
end
exports("MaxWeight", MaxWeight)
RegisterNetEvent(("%s:MaxWeight"):format(GetCurrentResourceName()), MaxWeight)

RegisterNUICallback('showBlur', function()
    Wait(50)
    TriggerEvent("qb-inventory:client:showBlur")
end) 
RegisterNetEvent("qb-inventory:client:showBlur", function()
    Wait(50)
    showBlur = not showBlur
end)


--#endregion Variables

--#region Functions

---Checks if you have an item or not
---@param items string | string[] | table<string, number> The items to check, either a string, array of strings or a key-value table of a string and number with the string representing the name of the item and the number representing the amount
---@param amount? number The amount of the item to check for, this will only have effect when items is a string or an array of strings
---@return boolean success Returns true if the player has the item
local function HasItem(items, amount)
    local isTable = type(items) == 'table'
    local isArray = isTable and table.type(items) == 'array' or false
    local totalItems = #items
    local count = 0
    local kvIndex = 2
	if isTable and not isArray then
        totalItems = 0
        for _ in pairs(items) do totalItems += 1 end
        kvIndex = 1
    end
    for _, itemData in pairs(PlayerData.items) do
        if isTable then
            for k, v in pairs(items) do
                local itemKV = {k, v}
                if itemData and itemData.name == itemKV[kvIndex] and ((amount and itemData.amount >= amount) or (not isArray and itemData.amount >= v) or (not amount and isArray)) then
                    count += 1
                end
            end
            if count == totalItems then
                return true
            end
        else -- Single item as string
            if itemData and itemData.name == items and (not amount or (itemData and amount and itemData.amount >= amount)) then
                return true
            end
        end
    end
    return false
end

exports("HasItem", HasItem)

---Opens the vending machine shop
local function OpenFoodsVending()
    local ShopItems = {}
    ShopItems.label = "Vending Machine"
    ShopItems.items = Config.VendingFoods
    ShopItems.slots = #Config.VendingFoods
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Vendingshop_"..math.random(1, 99), ShopItems)
end

---Opens the vending machine shop
local function OpenDrinksVending()
    local ShopItems = {}
    ShopItems.label = "Vending Machine"
    ShopItems.items = Config.VendingDrinks
    ShopItems.slots = #Config.VendingDrinks
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Vendingshop_"..math.random(1, 99), ShopItems)
end

---Opens the vending machine shop
local function OpenCoffeeVending()
    local ShopItems = {}
    ShopItems.label = "Vending Machine"
    ShopItems.items = Config.VendingCoffee
    ShopItems.slots = #Config.VendingCoffee
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Vendingshop_"..math.random(1, 99), ShopItems)
end

---Draws 3d text in the world on the given position
---@param x number The x coord of the text to draw
---@param y number The y coord of the text to draw
---@param z number The z coord of the text to draw
---@param text string The text to display
local function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = string.len(text) / 370
    DrawRect(0.0, 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

---Load an animation dictionary before playing an animation from it
---@param dict string Animation dictionary to load
local function LoadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

---Returns a formatted attachments table from item data
---@param itemdata table Data of an item
---@return table attachments
local function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for _, v in pairs(itemdata.info.attachments) do
            attachments[#attachments+1] = {
                attachment = v.item,
                label = v.label,
                image = QBCore.Shared.Items[v.item].image,
                component = v.component
            }
        end
    end
    return attachments
end

---Checks if the vehicle's engine is at the back or not
---@param vehModel integer The model hash of the vehicle
---@return boolean isBackEngine
local function IsBackEngine(vehModel)
    return BackEngineVehicles[vehModel]
end

local curTrunkVehicle = nil
local curGloveboxVehicle = nil

---Opens the trunk of the vehicle with realistic animation, door sync, and audio
local function OpenTrunk(vehicle)
    curTrunkVehicle = vehicle or QBCore.Functions.GetClosestVehicle()
    if curTrunkVehicle and DoesEntityExist(curTrunkVehicle) then
        local ped = PlayerPedId()
        LoadAnimDict("amb@prop_human_bum_bin@idle_b")
        TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 49, 0, false, false, false)
        local isBack = IsBackEngine(GetEntityModel(curTrunkVehicle))
        SetVehicleDoorOpen(curTrunkVehicle, isBack and 4 or 5, false, false)
        PlaySoundFrontend(-1, "Trunk_Open", "DLC_EXEC_HEIST_VEHICLE_SOUNDS", true)
        SendNUIMessage({ action = "playSound", sound = "trunk_open" })
    end
end

---Closes the trunk with door shutting and latch slam audio
local function CloseTrunk()
    if curTrunkVehicle and DoesEntityExist(curTrunkVehicle) then
        local ped = PlayerPedId()
        LoadAnimDict("amb@prop_human_bum_bin@idle_b")
        TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, 1000, 49, 0, false, false, false)
        local isBack = IsBackEngine(GetEntityModel(curTrunkVehicle))
        SetVehicleDoorShut(curTrunkVehicle, isBack and 4 or 5, false)
        PlaySoundFrontend(-1, "Trunk_Close", "DLC_EXEC_HEIST_VEHICLE_SOUNDS", true)
        SendNUIMessage({ action = "playSound", sound = "trunk_close" })
        SetTimeout(900, function()
            StopAnimTask(ped, "amb@prop_human_bum_bin@idle_b", "exit", 1.0)
        end)
        curTrunkVehicle = nil
    end
end

---Opens glovebox with in-car dashboard reaching animation and latch audio
local function OpenGlovebox(vehicle)
    curGloveboxVehicle = vehicle
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        LoadAnimDict("anim@mp_player_intmenu@key_fob@")
        TaskPlayAnim(ped, "anim@mp_player_intmenu@key_fob@", "fob_click", 3.0, 3.0, 1200, 49, 0, false, false, false)
        SendNUIMessage({ action = "playSound", sound = "glovebox_open" })
    end
end

---Closes glovebox with snap shut audio
local function CloseGlovebox()
    if curGloveboxVehicle then
        SendNUIMessage({ action = "playSound", sound = "glovebox_close" })
        curGloveboxVehicle = nil
    end
end

---Closes the inventory NUI
local function closeInventory()
    SendNUIMessage({
        action = "close",
    })
end

---Toggles the hotbar of the inventory
---@param toggle boolean If this is true, the hotbar will open
local function ToggleHotbar(toggle)
    local HotbarItems = {
        [1] = PlayerData.items[1],
        [2] = PlayerData.items[2],
        [3] = PlayerData.items[3],
        [4] = PlayerData.items[4],
    }

    SendNUIMessage({
        action = "toggleHotbar",
        open = toggle,
        items = HotbarItems
    })
end

---Plays the opening animation of the inventory
local function openAnim()
    local ped = PlayerPedId()
    LoadAnimDict('pickup_object')
    TaskPlayAnim(ped,'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    SetTimeout(500, function()
        StopAnimTask(ped, 'pickup_object', 'putdown_low', 1.0)
    end)
end

local function ItemsToItemInfo()
	itemInfos = {
		[1] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 22x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 32x."},
		[2] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 42x."},
		[3] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 45x, "..QBCore.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[4] = {costs = QBCore.Shared.Items["electronickit"]["label"] .. ": 2x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 52x, "..QBCore.Shared.Items["steel"]["label"] .. ": 40x."},
		[5] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 10x, " ..QBCore.Shared.Items["plastic"]["label"] .. ": 50x, "..QBCore.Shared.Items["aluminum"]["label"] .. ": 30x, "..QBCore.Shared.Items["iron"]["label"] .. ": 17x, "..QBCore.Shared.Items["electronickit"]["label"] .. ": 1x."},
		[6] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 36x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 24x, "..QBCore.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[7] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 32x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 43x, "..QBCore.Shared.Items["plastic"]["label"] .. ": 61x."},
		[8] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 50x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 37x, "..QBCore.Shared.Items["copper"]["label"] .. ": 26x."},
		[9] = {costs = QBCore.Shared.Items["iron"]["label"] .. ": 60x, " ..QBCore.Shared.Items["glass"]["label"] .. ": 30x."},
		[10] = {costs = QBCore.Shared.Items["aluminum"]["label"] .. ": 60x, " ..QBCore.Shared.Items["glass"]["label"] .. ": 30x."},
		[11] = {costs = QBCore.Shared.Items["iron"]["label"] .. ": 33x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 44x, "..QBCore.Shared.Items["plastic"]["label"] .. ": 55x, "..QBCore.Shared.Items["aluminum"]["label"] .. ": 22x."},
		[12] = {costs = QBCore.Shared.Items["iron"]["label"] .. ": 50x, " ..QBCore.Shared.Items["steel"]["label"] .. ": 50x, "..QBCore.Shared.Items["screwdriverset"]["label"] .. ": 3x, "..QBCore.Shared.Items["advancedlockpick"]["label"] .. ": 2x."},
	}

	local items = {}
	for _, item in pairs(Config.CraftingItems) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingItems = items
end

local function SetupAttachmentItemsInfo()
	itemInfos = {
		[1] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 140x, " .. QBCore.Shared.Items["steel"]["label"] .. ": 250x, " .. QBCore.Shared.Items["rubber"]["label"] .. ": 60x"},
		[2] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 165x, " .. QBCore.Shared.Items["steel"]["label"] .. ": 285x, " .. QBCore.Shared.Items["rubber"]["label"] .. ": 75x"},
		[3] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 190x, " .. QBCore.Shared.Items["steel"]["label"] .. ": 305x, " .. QBCore.Shared.Items["rubber"]["label"] .. ": 85x, " .. QBCore.Shared.Items["smg_extendedclip"]["label"] .. ": 1x"},
		[4] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 205x, " .. QBCore.Shared.Items["steel"]["label"] .. ": 340x, " .. QBCore.Shared.Items["rubber"]["label"] .. ": 110x, " .. QBCore.Shared.Items["smg_extendedclip"]["label"] .. ": 2x"},
		[5] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 230x, " .. QBCore.Shared.Items["steel"]["label"] .. ": 365x, " .. QBCore.Shared.Items["rubber"]["label"] .. ": 130x"},
		[6] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 255x, " .. QBCore.Shared.Items["steel"]["label"] .. ": 390x, " .. QBCore.Shared.Items["rubber"]["label"] .. ": 145x"},
		[7] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 270x, " .. QBCore.Shared.Items["steel"]["label"] .. ": 435x, " .. QBCore.Shared.Items["rubber"]["label"] .. ": 155x"},
		[8] = {costs = QBCore.Shared.Items["metalscrap"]["label"] .. ": 300x, " .. QBCore.Shared.Items["steel"]["label"] .. ": 469x, " .. QBCore.Shared.Items["rubber"]["label"] .. ": 170x"},
	}

	local items = {}
	for _, item in pairs(Config.AttachmentCrafting["items"]) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.AttachmentCrafting["items"] = items
end

local function GetThresholdItems()
	ItemsToItemInfo()
	local items = {}
	for k in pairs(Config.CraftingItems) do
		if PlayerData.metadata["craftingrep"] >= Config.CraftingItems[k].threshold then
			items[k] = Config.CraftingItems[k]
		end
	end
	return items
end

local function GetAttachmentThresholdItems()
	SetupAttachmentItemsInfo()
	local items = {}
	for k in pairs(Config.AttachmentCrafting["items"]) do
		if PlayerData.metadata["attachmentcraftingrep"] >= Config.AttachmentCrafting["items"][k].threshold then
			items[k] = Config.AttachmentCrafting["items"][k]
		end
	end
	return items
end

---Removes drops in the area of the client
---@param index integer The drop id to remove
local function RemoveNearbyDrop(index)
    if not DropsNear[index] then return end

    local dropItem = DropsNear[index].object
    if DoesEntityExist(dropItem) then
        DeleteEntity(dropItem)
    end

    DropsNear[index] = nil

    if not Drops[index] then return end

    Drops[index].object = nil
    Drops[index].isDropShowing = nil
end

---Removes all drops in the area of the client
local function RemoveAllNearbyDrops()
    for k in pairs(DropsNear) do
        RemoveNearbyDrop(k)
    end
end

---Creates a new item drop object on the ground
---@param index integer The drop id to save the object in
local function CreateItemDrop(index)
    local dropItem = CreateObject(Config.ItemDropObject, DropsNear[index].coords.x, DropsNear[index].coords.y, DropsNear[index].coords.z, false, false, false)
    DropsNear[index].object = dropItem
    DropsNear[index].isDropShowing = true
    PlaceObjectOnGroundProperly(dropItem)
    FreezeEntityPosition(dropItem, true)
    exports['qb-target']:AddTargetEntity(dropItem, {
        options = {
            {
                icon = 'fas fa-backpack',
                label = "Open Bag",
                action = function()
                    TriggerServerEvent("inventory:server:OpenInventory", "drop", index)
                end,
            }
        },
        distance = 2.5,
    })
end

local function toggleItem(give, item, amount, info)
    return TriggerServerEvent("inventory:server:toggleItem", give, item, amount, info)
end

exports("toggleItem", toggleItem)

RegisterNetEvent('Inventory:Client:OnPlayerLoaded', function()
    LocalPlayer.state:set("inv_busy", false, true)
    PlayerData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.TriggerCallback("inventory:server:GetCurrentDrops", function(theDrops)
		Drops = theDrops
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    LocalPlayer.state:set("inv_busy", true, true)
    PlayerData = {}
    RemoveAllNearbyDrops()
end)

RegisterNetEvent('QBCore:Client:UpdateObject', function()
    QBCore = exports['qb-core']:GetCoreObject()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
    SendNUIMessage({
        action = 'UpdateCash',
        cash = PlayerData.money['cash']
    })
end)

AddEventHandler('onResourceStop', function(name)
    if name ~= GetCurrentResourceName() then return end
    if Config.UseItemDrop then RemoveAllNearbyDrops() end
end)

RegisterNetEvent("qb-inventory:client:closeinv", function()
    closeInventory()
end)

RegisterNetEvent('inventory:client:CheckOpenState', function(type, id, label)
    local name = QBCore.Shared.SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "drop" then
        if name ~= CurrentDrop or CurrentDrop == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent('inventory:client:ItemBox', function(itemData, type, amount)
    amount = amount or 1
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type,
        itemAmount = amount
    })
end)

RegisterNetEvent('inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k in pairs(items) do
            itemTable[#itemTable+1] = {
                item = items[k].name,
                label = QBCore.Shared.Items[items[k].name]["label"],
                image = items[k].image,
            }
        end
    end

    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)

RegisterNetEvent('inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)

RegisterNetEvent('qb-inventory:client:giveAnim', function()
    LoadAnimDict('mp_common')
	TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_b', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
end)

RegisterNUICallback("GiveItem", function(data, cb)
    local player, distance = QBCore.Functions.GetClosestPlayer(GetEntityCoords(PlayerPedId()))
    if player ~= -1 and distance < 3 then
        if data.inventory == 'player' then
            local playerId = GetPlayerServerId(player)
            SetCurrentPedWeapon(PlayerPedId(),'WEAPON_UNARMED',true)
            TriggerServerEvent("inventory:server:GiveItem", playerId, data.item.name, data.amount, data.item.slot)
        else
            QBCore.Functions.Notify(Lang:t('error.item_not_owned'), "error")
        end
    else
        QBCore.Functions.Notify(Lang:t('error.nobody_nearby'), "error")
    end
    cb('ok')
end)

RegisterNetEvent('inventory:client:OpenInventory', function(PlayerAmmo, inventory, other)
    if not IsEntityDead(PlayerPedId()) then
        ToggleHotbar(false)
        if showBlur == true then
            TriggerScreenblurFadeIn(400)
        end
        SetNuiFocus(true, true)
        if other then
            currentOtherInventory = other.name
        end
        SendNUIMessage({
            action = "open",
            inventory = inventory,
            slots = Config.MaxInventorySlots,
            other = other,
            maxweight = Config.MaxInventoryWeight,
            Ammo = PlayerAmmo,
            maxammo = Config.MaximumAmmoValues,
            cash = PlayerData.money['cash'],
            locale = Config.Locale or 'tr',
            translations = (Lang and Lang.phrases and Lang.phrases.ui) or {}
        })
        inInventory = true
    end
end)

RegisterNetEvent('inventory:client:UpdatePlayerInventory', function(isError)
    SendNUIMessage({
        action = "update",
        inventory = PlayerData.items,
        maxweight = Config.MaxInventoryWeight,
        slots = Config.MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent('inventory:client:CraftItems', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    QBCore.Functions.Progressbar("repair_vehicle", "Crafting...", (2000 * amount), false, true, {
	    disableMovement = true,
	    disableCarMovement = true,
	    disableMouse = false,
	    disableCombat = true,
	}, {
	    animDict = "mini@repair",
	    anim = "fixing_a_player",
	    flags = 16,
	}, {}, {}, function() -- Done
	    StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftItems", itemName, itemCosts, amount, toSlot, points)
        isCrafting = false
	end, function() -- Cancel
	    StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        QBCore.Functions.Notify(Lang:t('error.action_failed'), "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('inventory:client:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    QBCore.Functions.Progressbar("repair_vehicle", Lang:t('progress.crafting_attachment'), (2000 * amount), false, true, {
	    disableMovement = true,
	    disableCarMovement = true,
	    disableMouse = false,
	    disableCombat = true,
	}, {
	    animDict = "mini@repair",
	    anim = "fixing_a_player",
	    flags = 16,
	}, {}, {}, function() -- Done
	    StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftAttachment", itemName, itemCosts, amount, toSlot, points)
        isCrafting = false
	end, function() -- Cancel
	    StopAnimTask(ped, "mini@repair", "fixing_a_player", 1.0)
        QBCore.Functions.Notify(Lang:t('error.action_failed'), "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('inventory:client:PickupSnowballs', function()
    local ped = PlayerPedId()
    LoadAnimDict('anim@mp_snowball')
    TaskPlayAnim(ped, 'anim@mp_snowball', 'pickup_snowball', 3.0, 3.0, -1, 0, 1, 0, 0, 0)
    QBCore.Functions.Progressbar("pickupsnowball", "Collecting snowballs..", 1500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        StopAnimTask(ped, 'anim@mp_snowball', 'pickup_snowball', -1)
	    TriggerServerEvent('inventory:server:snowball', 'add')
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["snowball"], "add")
    end, function() -- Cancel
        StopAnimTask(ped, 'anim@mp_snowball', 'pickup_snowball', -1)
        QBCore.Functions.Notify(Lang:t('error.action_canceled'), "error")
    end)
end)

RegisterNetEvent('inventory:client:UseWeapon', function(weaponData, shootbool)
    local ped = PlayerPedId()
    local weaponName = tostring(weaponData.name)
    local weaponHash = joaat(weaponData.name)
    local weaponinhand = GetCurrentPedWeapon(PlayerPedId())
    if currentWeapon == weaponName and weaponinhand then
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        if QBCore.Functions.GetPlayerData().job.name == 'police' then
            Wait(1000)
        else
            Wait(1100)
        end
        RemoveAllPedWeapons(ped, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" or weaponName == "weapon_pipebomb" or weaponName == "weapon_smokegrenade" or weaponName == "weapon_flare" or weaponName == "weapon_proxmine" or weaponName == "weapon_ball"  or weaponName == "weapon_molotov" or weaponName == "weapon_grenade" or weaponName == "weapon_bzgas" or weaponName == "weapon_book" or weaponName == "weapon_cash" or weaponName == "weapon_shoe" or weaponName == "weapon_brick" then
        GiveWeaponToPed(ped, weaponHash, 1, false, false)
        SetPedAmmo(ped, weaponHash, 1)
        SetCurrentPedWeapon(ped, weaponHash, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_snowball" then
        GiveWeaponToPed(ped, weaponHash, 10, false, false)
        SetPedAmmo(ped, weaponHash, 10)
        SetCurrentPedWeapon(ped, weaponHash, true)
        TriggerServerEvent('inventory:server:snowball', 'remove')
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    else
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        local ammo = tonumber(weaponData.info.ammo) or 0
        if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then
            ammo = 4000
        end

        GiveWeaponToPed(ped, weaponHash, ammo, false, false)
        SetPedAmmo(ped, weaponHash, ammo)
        SetCurrentPedWeapon(ped, weaponHash, true)

        if weaponData.info.attachments then
            for _, attachment in pairs(weaponData.info.attachments) do
                GiveWeaponComponentToPed(ped, weaponHash, joaat(attachment.component))
            end
        end

        currentWeapon = weaponName
    end
end)

RegisterNetEvent('inventory:client:CheckWeapon', function(weaponName)
    if currentWeapon ~= weaponName:lower() then return end
    local ped = PlayerPedId()
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    RemoveAllPedWeapons(ped, true)
    currentWeapon = nil
end)

-- This needs to be changed to do a raycast so items arent placed in walls
RegisterNetEvent('inventory:client:AddDropItem', function(dropId, player, coords)
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
    local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent('inventory:client:RemoveDropItem', function(dropId)
    Drops[dropId] = nil
    if Config.UseItemDrop then
        RemoveNearbyDrop(dropId)
    else
        DropsNear[dropId] = nil
    end
end)

RegisterNetEvent('inventory:client:DropItemAnim', function()
    local ped = PlayerPedId()
    SendNUIMessage({
        action = "close",
    })
    LoadAnimDict("pickup_object")
    TaskPlayAnim(ped, "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    SetTimeout(1700, function()
        StopAnimTask(ped, 'pickup_object', 'pickup_low', -1)
    end)
end)

RegisterNetEvent('inventory:client:SetCurrentStash', function(stash)
    CurrentStash = stash
end)

--#endregion Events

--#region Commands

RegisterCommand('closeinv', function()
    closeInventory()
end, false)

RegisterCommand('inventory', function()
    if not isCrafting and not inInventory then
        if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
            local ped = PlayerPedId()
            local curVeh = nil

            if IsPedInAnyVehicle(ped, false) then -- Is Player In Vehicle
                local vehicle = GetVehiclePedIsIn(ped, false)
                CurrentGlovebox = QBCore.Functions.GetPlate(vehicle)
                curVeh = vehicle
                CurrentVehicle = nil
            else
                local vehicle = QBCore.Functions.GetClosestVehicle()
                if vehicle ~= 0 and vehicle ~= nil then
                    local pos = GetEntityCoords(ped)
                    local minimum, maximum = GetModelDimensions(GetEntityModel(vehicle))
                    local ratio = math.abs(minimum.y/maximum.y)
                    local offset = minimum.y - (maximum.y + minimum.y)*ratio
                    local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, offset, 0)
                    if IsBackEngine(GetEntityModel(vehicle)) then
                        trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, math.abs(offset), 0)
                    end
                    if #(pos - trunkpos) < 1.5 and not IsPedInAnyVehicle(ped) then
                        if GetVehicleDoorLockStatus(vehicle) < 2 then
                            if GetVehicleEngineHealth(vehicle) <= 100.0 then
                                return QBCore.Functions.Notify(Lang:t('error.vehicle_broken'), "error")
                            else
                                CurrentVehicle = QBCore.Functions.GetPlate(vehicle)
                                curVeh = vehicle
                                CurrentGlovebox = nil
                            end
                        else
                            QBCore.Functions.Notify(Lang:t('error.vehicle_locked'), "error")
                            return
                        end
                    else
                        CurrentVehicle = nil
                    end
                else 
                    CurrentVehicle = nil
                end
            end

            if CurrentVehicle then -- Trunk
                local vehicleClass = GetVehicleClass(curVeh)
                local classConfig = (Config.TrunkClasses and (Config.TrunkClasses[vehicleClass] or Config.TrunkClasses.default)) or { maxweight = 60000, slots = 35 }
                local other = {
                    maxweight = classConfig.maxweight,
                    slots = classConfig.slots,
                }
                TriggerServerEvent("inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                OpenTrunk(curVeh)
            elseif CurrentGlovebox then
                local vehicleClass = GetVehicleClass(curVeh)
                local classConfig = (Config.GloveboxClasses and (Config.GloveboxClasses[vehicleClass] or Config.GloveboxClasses.default)) or { maxweight = 50000, slots = 5 }
                local other = {
                    maxweight = classConfig.maxweight,
                    slots = classConfig.slots,
                }
                TriggerServerEvent("inventory:server:OpenInventory", "glovebox", CurrentGlovebox, other)
                OpenGlovebox(curVeh)
            elseif CurrentDrop ~= 0 then
                TriggerServerEvent("inventory:server:OpenInventory", "drop", CurrentDrop)
            else
                openAnim()
                TriggerServerEvent("inventory:server:OpenInventory")
            end
        end
    end
end, false)

RegisterKeyMapping('inventory', 'Open Inventory', 'keyboard', 'F2')

RegisterCommand('hotbar', function()
    isHotbar = not isHotbar
    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
        ToggleHotbar(isHotbar)
    end
end, false)

RegisterKeyMapping('hotbar', 'Toggles keybind slots', 'keyboard', 'z')

for i = 1, 5 do
    RegisterCommand('slot' .. i,function()
        if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
            if i == 6 then
                i = Config.MaxInventorySlots
            end
            TriggerServerEvent("inventory:server:UseItemSlot", i)
        end
    end, false)
    RegisterKeyMapping('slot' .. i, 'Uses the item in slot ' .. i, 'keyboard', i)
end

--#endregion Commands

--#region NUI

RegisterNUICallback('RobMoney', function(data, cb)
    TriggerServerEvent("police:server:RobPlayer", data.TargetId)
    cb('ok')
end)

RegisterNUICallback('Notify', function(data, cb)
    QBCore.Functions.Notify(data.message, data.type)
    cb('ok')
end)

RegisterNUICallback('GetWeaponData', function(cData, cb)
    local data = {
        WeaponData = QBCore.Shared.Items[cData.weapon],
        AttachmentData = FormatWeaponAttachments(cData.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('openJewelry', function(cData, cb)
    local Player = QBCore.Functions.GetPlayerData()
    closeInventory()
    Wait(100)
    openAnim()
    TriggerEvent("inventory:client:SetCurrentStash", "Jewelry_"..Player.citizenid)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "Jewelry_"..Player.citizenid, {
    maxweight = 30000, slots = 5,})
    cb('ok')
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local ped = PlayerPedId()
    local WeaponData = QBCore.Shared.Items[data.WeaponData.name]
    data.AttachmentData.attachment = data.AttachmentData.attachment:gsub("(.*).*_",'')
    QBCore.Functions.TriggerCallback('weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local attachments = {}
            RemoveWeaponComponentFromPed(ped, joaat(data.WeaponData.name), joaat(data.AttachmentData.component))
            for _, v in pairs(NewAttachments) do
                attachments[#attachments+1] = {
                    attachment = v.item,
                    label = v.label,
                    image = QBCore.Shared.Items[v.item].image
                }
            end
            local DJATA = {
                Attachments = attachments,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(ped, joaat(data.WeaponData.name), joaat(data.AttachmentData.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(QBCore.Shared.Items[data.item])
end)

RegisterNUICallback("CloseInventory", function(_, cb)
    if currentOtherInventory == "none-inv" then
        CurrentDrop = nil
        if CurrentVehicle ~= nil then CloseTrunk() end
        if CurrentGlovebox ~= nil then CloseGlovebox() end
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        inInventory = false
        TriggerScreenblurFadeOut(400)
        ClearPedTasks(PlayerPedId())
        return
    end
    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("inventory:server:SaveInventory", "trunk", CurrentVehicle)
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        CloseGlovebox()
        TriggerServerEvent("inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "stash", CurrentStash)
        CurrentStash = nil
    else
        TriggerServerEvent("inventory:server:SaveInventory", "drop", CurrentDrop)
        CurrentDrop = nil
    end
    Wait(50)
    TriggerScreenblurFadeOut(1000)
    SetNuiFocus(false, false)
    inInventory = false
    cb('ok')
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("inventory:server:UseItem", data.inventory, data.item)
    cb('ok')
end)

RegisterNUICallback("combineItem", function(data, cb)
    Wait(150)
    TriggerServerEvent('inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
    cb('ok')
end)

RegisterNUICallback('combineWithAnim', function(data, cb)
    local ped = PlayerPedId()
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut
    QBCore.Functions.Progressbar("combine_anim", animText, animTimeout, false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = aDict,
        anim = aLib,
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(ped, aDict, aLib, 1.0)
        TriggerServerEvent('inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem)
    end, function() -- Cancel
        StopAnimTask(ped, aDict, aLib, 1.0)
        QBCore.Functions.Notify("Failed!", "error")
    end)
    cb('ok')
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    TriggerServerEvent("inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
    cb('ok')
end)

RegisterNUICallback("PlayDropSound", function(_, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    cb('ok')
end)

RegisterNUICallback("PlayDropFail", function(_, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    cb('ok')
end)

-- Live Clothing & Accessory Sync (NoPixel 5.0)
RegisterNUICallback("SyncClothing", function(data, cb)
    local slot = data.slot
    local action = data.action -- "equip" or "unequip"
    local item = data.item
    local ped = PlayerPedId()

    if slot == "mask" then
        if action == "unequip" then
            SetPedComponentVariation(ped, 1, 0, 0, 0)
        else
            local drawable = (item and item.info and item.info.drawable) or 36
            local texture = (item and item.info and item.info.texture) or 0
            SetPedComponentVariation(ped, 1, drawable, texture, 0)
        end
    elseif slot == "hat" then
        if action == "unequip" then
            ClearPedProp(ped, 0)
        else
            local prop = (item and item.info and item.info.prop) or 0
            local texture = (item and item.info and item.info.texture) or 0
            SetPedPropIndex(ped, 0, prop, texture, true)
        end
    elseif slot == "glasses" then
        if action == "unequip" then
            ClearPedProp(ped, 1)
        else
            local prop = (item and item.info and item.info.prop) or 1
            local texture = (item and item.info and item.info.texture) or 0
            SetPedPropIndex(ped, 1, prop, texture, true)
        end
    elseif slot == "armor" then
        if action == "unequip" then
            SetPedComponentVariation(ped, 9, 0, 0, 0)
            SetPedArmour(ped, 0)
        else
            SetPedComponentVariation(ped, 9, 10, 1, 0)
            SetPedArmour(ped, 100)
        end
    elseif slot == "radio" then
        if action == "unequip" then
            TriggerEvent('Radio.Set', false)
            if exports['pma-voice'] then exports['pma-voice']:setRadioChannel(0) end
        end
    end
    cb('ok')
end)

-- Tactical Weapon Stripper & Modding Callbacks (NoPixel 5.0)
RegisterNUICallback("DetachAttachment", function(data, cb)
    TriggerServerEvent("inventory:server:DetachAttachment", data.weaponSlot, data.attachmentItem)
    cb('ok')
end)

RegisterNUICallback("AttachAttachment", function(data, cb)
    TriggerServerEvent("inventory:server:AttachAttachment", data.weaponSlot, data.attachmentSlot)
    cb('ok')
end)

-- Real Inception Backpack Container Opener
RegisterNetEvent("inventory:client:OpenBagStash", function(bagId, bagConfig)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "bag_" .. bagId, {
        maxweight = bagConfig.maxweight,
        slots = bagConfig.slots,
        label = bagConfig.label .. " [" .. bagId .. "]"
    })
end)

--#endregion NUI

--#region Threads

CreateThread(function()
    while true do
        local sleep = 500
        if DropsNear ~= nil and next(DropsNear) ~= nil then
            local ped = PlayerPedId()
            local pCoords = GetEntityCoords(ped)
            local closestDrop = nil
            local closestDistance = nil
            for k, v in pairs(DropsNear) do
                if v ~= nil then
                    local coords = (v.object ~= nil and DoesEntityExist(v.object) and GetEntityCoords(v.object)) or vector3(v.coords.x, v.coords.y, v.coords.z)
                    local distance = #(pCoords - coords)
                    if distance < 12.0 then
                        if Config.UseItemDrop then
                            if not v.isDropShowing then
                                CreateItemDrop(k)
                            end
                        else
                            sleep = 0
                            DrawMarker(2, v.coords.x, v.coords.y, v.coords.z - 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 255, 255, 255, 155, false, false, false, false, false, false, false)
                        end
                        if distance < 2.0 and (not closestDistance or distance < closestDistance) then
                            closestDrop = k
                            closestDistance = distance
                        end
                    end
                end
            end
            CurrentDrop = closestDrop or 0
        else
            CurrentDrop = 0
            sleep = 1000
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if Drops ~= nil and next(Drops) ~= nil then
            local pos = GetEntityCoords(PlayerPedId(), true)
            for k, v in pairs(Drops) do
                if Drops[k] ~= nil then
                    local dist = #(pos - vector3(v.coords.x, v.coords.y, v.coords.z))
                    if dist < Config.MaxDropViewDistance then
                        DropsNear[k] = v
                    else
                        if Config.UseItemDrop and DropsNear[k] then
                            RemoveNearbyDrop(k)
                        else
                            DropsNear[k] = nil
                        end
                    end
                end
            end
        else
            DropsNear = {}
        end
        Wait(500)
    end
end)

RegisterNetEvent("inventory:client:Crafting", function(dropId)
    local crafting = {}
    crafting.label = "Crafting"
    crafting.items = GetThresholdItems()
    TriggerServerEvent("inventory:server:OpenInventory", "crafting", math.random(1, 99), crafting)
end)

RegisterNetEvent("inventory:client:WeaponAttachmentCrafting", function(dropId)
        local crafting = {}
        crafting.label = "Attachment Crafting"
        crafting.items = GetAttachmentThresholdItems()
        TriggerServerEvent("inventory:server:OpenInventory", "attachment_crafting", math.random(1, 99), crafting)
end)

local toolBoxModels = {
    `prop_toolchest_05`,
    `prop_tool_bench02_ld`,
    `prop_tool_bench02`,
    `prop_toolchest_02`,
    `prop_toolchest_03`,
    `prop_toolchest_03_l2`,
    `prop_toolchest_05`,
    `prop_toolchest_04`,
}
exports['qb-target']:AddTargetModel(toolBoxModels, {
        options = {
            {
                event = "inventory:client:WeaponAttachmentCrafting",
                icon = "fas fa-wrench",
                label = "Weapon Attachment Crafting", 
            },
            {
                event = "inventory:client:Crafting",
                icon = "fas fa-wrench",
                label = "Item Crafting", 
            },
        },
    distance = 1.0
})

-- =========================================================================
-- NOPIXEL 5.0 FRISK & TACTICAL PAT-DOWN SYSTEM
-- =========================================================================
RegisterCommand('frisk', function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then
        local player, distance = QBCore.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 2.5 then
            targetId = GetPlayerServerId(player)
        else
            return QBCore.Functions.Notify(Lang:t('error.nobody_nearby'), "error")
        end
    end

    local ped = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    if DoesEntityExist(targetPed) then
        TaskTurnPedToFaceEntity(ped, targetPed, 800)
        Wait(400)
    end

    QBCore.Functions.Progressbar("frisk_player", Lang:t('progress.frisking'), 3000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "random@train_tracks",
        anim = "idle_e",
        flags = 49,
    }, {}, {}, function()
        StopAnimTask(ped, "random@train_tracks", "idle_e", 1.0)
        TriggerServerEvent("inventory:server:FriskPlayer", targetId)
    end, function()
        StopAnimTask(ped, "random@train_tracks", "idle_e", 1.0)
        QBCore.Functions.Notify(Lang:t('error.action_canceled'), "error")
    end)
end)

RegisterCommand('yokla', function(source, args)
    ExecuteCommand('frisk ' .. (args[1] or ''))
end)

-- =========================================================================
-- NOPIXEL 5.0 ARMOR PLATE INSERTION & REPAIR SYSTEM
-- =========================================================================
RegisterNetEvent('inventory:client:UseArmorPlate', function(slot)
    local ped = PlayerPedId()
    local currentArmour = GetPedArmour(ped)
    if currentArmour >= 100 then
        return QBCore.Functions.Notify(Lang:t('error.plates_full'), "error")
    end

    if inInventory then
        closeInventory()
    end

    LoadAnimDict("clothingtie")
    TaskPlayAnim(ped, "clothingtie", "try_tie_positive_a", 3.0, 3.0, 4500, 49, 0, false, false, false)
    SendNUIMessage({ action = "playSound", sound = "armor_insert" })

    QBCore.Functions.Progressbar("insert_plate", Lang:t('progress.inserting_plate'), 4500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        StopAnimTask(ped, "clothingtie", "try_tie_positive_a", 1.0)
        TriggerServerEvent("inventory:server:FinishArmorPlate", slot)
    end, function()
        StopAnimTask(ped, "clothingtie", "try_tie_positive_a", 1.0)
        QBCore.Functions.Notify(Lang:t('error.action_canceled'), "error")
    end)
end)

RegisterNUICallback('InsertArmorPlate', function(data, cb)
    TriggerEvent('inventory:client:UseArmorPlate', data and data.slot)
    cb('ok')
end)






