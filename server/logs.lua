-- =========================================================================
-- NoPixel 5.0 Style In-Resource Discord Logging System
-- =========================================================================

local QBCore = exports['qb-core']:GetCoreObject()

---Sends a structured embed log to Discord and/or Server Console
---@param channel string The log category ('drop', 'stash', 'trunk', 'glovebox', 'give', 'rob', 'shop', 'craft', 'weapons', 'exploit', 'default')
---@param title string Title of the embed
---@param description string Markdown formatted message description
---@param colorKey? string Color category key from Config.Logs.Colors
---@param fields? table Array of { name = string, value = string, inline = boolean }
local function SendInventoryLog(channel, title, description, colorKey, fields)
    if not Config.Logs or not Config.Logs.Enabled then return end

    channel = channel or 'default'
    local webhook = Config.Logs.Webhooks[channel]
    if not webhook or webhook == "" then
        webhook = Config.Logs.Webhooks['default']
    end

    local color = Config.Logs.Colors[colorKey or channel] or Config.Logs.Colors['default'] or 16777215

    if Config.Logs.ConsoleLogs then
        print(string.format("[INVENTORY-LOG][%s] %s: %s", channel:upper(), title, description:gsub("%*%*", "")))
    end

    if not webhook or webhook == "" then return end

    local embed = {
        {
            ["title"] = title,
            ["description"] = description,
            ["color"] = color,
            ["footer"] = {
                ["text"] = "NoPixel 5.0 Inventory Logs • " .. os.date("%d/%m/%Y %H:%M:%S"),
            },
            ["fields"] = fields or {}
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers)
        if err ~= 200 and err ~= 204 then
            -- Silent or debug only
        end
    end, 'POST', json.encode({
        username = Config.Logs.BotName or "Inventory Logs",
        avatar_url = Config.Logs.BotAvatar or "",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

exports('SendInventoryLog', SendInventoryLog)

RegisterNetEvent('qb-inventory:server:Log', function(channel, title, description, colorKey, fields)
    -- Internal / server only or safe call
    SendInventoryLog(channel, title, description, colorKey, fields)
end)

-- Backward compatibility with qb-log
AddEventHandler('qb-log:server:CreateLog', function(name, title, color, message, tagEveryone)
    if Config.Logs and Config.Logs.Enabled then
        local channelMap = {
            ['default'] = 'default',
            ['drop'] = 'drop',
            ['stash'] = 'stash',
            ['trunk'] = 'trunk',
            ['glovebox'] = 'glovebox',
            ['give'] = 'give',
            ['robbing'] = 'rob',
            ['shops'] = 'shop',
            ['crafting'] = 'craft',
            ['weapons'] = 'weapons',
            ['dealers'] = 'shop'
        }
        local channel = channelMap[name] or 'default'
        SendInventoryLog(channel, title, message, channel)
    end
end)
