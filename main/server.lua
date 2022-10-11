ESX = nil
QBCore = nil

Citizen.CreateThread(function()
    if Config.FrameWork == 'ESX' then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    elseif Config.FrameWork == 'QBCore' then
        QBCore = exports[Config.CoreResource]:GetCoreObject()
    end
    print('^2'..GetCurrentResourceName()..' is ^2online^0')
    print('^4Made by ^1KonaN#8557^0')
    print('Loaded '..Config.FrameWork..' Framework')
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Items) do
        if ESX then
            ESX.RegisterUsableItem(v.name, function(source)
                local xPlayer = ESX.GetPlayerFromId(source)
                for k, v in pairs(v.jobs) do
                    if xPlayer.job.name == v then
                        return
                    end
                    LogMeDaddy(source, '`Item Name :` '..v.Name..'\n`Job :` '..Player.PlayerData.job.name..'', Config.webhook, 16777215)
                end
            end)
        elseif QBCore then
            QBCore.Functions.CreateUseableItem(v.name, function(source)
                local Player = QBCore.Functions.GetPlayer(source)
                for k, v in pairs(v.jobs) do
                    if Player.PlayerData.job.name == v then
                        return
                    end
                    LogMeDaddy(source, '`Item Name :` '..v.Name..'\n`Job :` '..Player.PlayerData.job.name..'', Config.webhook, 16777215)
                end
            end)
        end
    end
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "Not-Found",
        ip = "Not-Found",
        discord = "Not-Found",
        license = "Not-Found",
        xbl = "Not-Found",
        live = "Not-Found",
        fivem = "Not-Found"
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license:") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        elseif string.find(id, "fivem") then
            identifiers.fivem = id
        end
    end
    return identifiers
end

function LogMeDaddy(source, message, webhook_inamo, color)

    local ids = ExtractIdentifiers(source)
    local player = GetPlayerName(source)
    local ip = GetPlayerEndpoint(source)
    local discord = ids.discord
    local steamhex = ids.steam
    local gameLicense = ids.license
    local xbl = ids.xbl
    local live = ids.live
    local fivem = ids.fivem
    if ip == nil then return end

    local embed = {
        {
            ["color"] = color,
            ["fields"] = {
                { ["name"] = "User Information", ["value"] = "**`Name:`** "..player.."\n**`Server ID:`** "..source.."\n**`IP:`** "..ip.."\n**`Steam:`** "..steamhex.."\n**`License:`** "..gameLicense.."\n**`Discord:`** "..discord.."\n**`XBL:`** "..xbl.."\n**`Live:`** "..live.."\n**`FiveM ID:`** "..fivem, ["inline"] = true },
                { ["name"] = "Log Information", ["value"] = message, ["inline"] = true }
            },
            ["author"] = {
                ["name"] = "Perdition Collective LTD",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/847909683716554782/1008712749762748427/Untitled-56461.png",
                ["url"] = "https://discord.gg/pca"
            },
            ["footer"] = {
                ["text"] = "Perdition Collective LTD .gg/psu",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/847909683716554782/1008712749762748427/Untitled-56461.png"
            },
        }
    }
    PerformHttpRequest(webhook_inamo, function(err, text, headers) end, "POST", json.encode({embeds = embed}), { ["Content-Type"] = "application/json" })
end

