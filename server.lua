local Bans = {}

ESX = exports['es_extended']:getSharedObject()


ESX.RegisterCommand('banid_p',
    { 'best' },
    function(xPlayer, args, showError)
        local bannedPlayer = args.id
        local czasbana = args.czas
        local powod = args.powod
        bannedPlayer.setCoords(Config.Coords["ban"])
        bannedPlayer.showNotification("Otrzymałeś bana na " .. (czasbana == 1 and
            czasbana .. " godzine" or czasbana .. " godzin"))

        local current_time = os.time()
        local new_time = current_time + (3600 * czasbana)
        Bans[args.id.source] = new_time
        TriggerClientEvent("dostalBana", bannedPlayer.source, new_time, current_time)
        local discord = GetPlayerIdentifierByType(bannedPlayer.source, "discord") and GetPlayerIdentifierByType(bannedPlayer.source, "discord"):gsub("discord:", "") or "Brak"
        PerformHttpRequest(Config.Webhooks["ban"], function(err, text, headers) end, 'POST', json.encode({
            username = "Ban System",
            content = "<@" .. discord .. ">",
            embeds = {
                {
                    title = "Gracz został zbanowany.",
                    description = "Informacje\n" .. "```" .. "Zbanowany przez: " .. GetPlayerName(xPlayer.source) .. "\nNick: " .. GetPlayerName(bannedPlayer.source) .. "\nLicencja: " .. bannedPlayer.identifier .. "\nPowód: " .. powod .. "\nDo kiedy: " .. os.date("%d/%m/%Y %H:%M:%S", new_time) .. "```",
                    color = 16711680,
                }
            }
        }),
        { ['Content-Type'] = 'application/json' })
    
    end, true, {
        help = "Zbanuj Gracza",
        validate = true,
        arguments = {
            { name = 'id',   help = "ID Gracza",             type = 'player' },
            { name = 'czas', help = "Czas bana w Godzinach", type = 'number' },
            { name = "powod", help = "Powód Bana", type = "string" },
        }
    })


ESX.RegisterCommand("banlicense_p", { "best" }, function(xPlayer, args, showError)
    local bannedPlayer = args.license
    local czasbana = args.czas
    local current_time = os.time()
    local powod = args.powod
    local new_time = current_time + (3600 * czasbana)
    PerformHttpRequest(Config.Webhooks["ban"], function(err, text, headers) end, 'POST', json.encode({
        username = "Ban System",
        embeds = {
            {
                title = "Gracz został zbanowany offline.",
                description = "Informacje\n" .. "```" .. "Zbanowany przez: " .. GetPlayerName(xPlayer.source) .. "\nLicencja: " .. bannedPlayer .. "\nPowód: " .. powod .. "\nDo kiedy: " .. os.date("%d/%m/%Y %H:%M:%S", new_time) .. "```",
                color = 16711680,
            }
        }
    }),
    { ['Content-Type'] = 'application/json' })
    MySQL.query.await(
        "INSERT INTO feciu_bans (license, time) VALUES (@license, @time)",
        {
            ['@license'] = bannedPlayer,
            ['@time'] = new_time,
        }
    )
end, true, {
    help = "Zbanuj Gracza Offline",
    validate = true,
    arguments = {
        { name = 'license',   help = "Licka Gracza",             type = 'string' },
        { name = 'czas', help = "Czas bana w Godzinach", type = 'number' },
        { name = "powod", help = "Powód Bana", type = "string" },
    }
})

ESX.RegisterCommand("unbanlicense_p", { "best" }, function(xPlayer, args, showError)
    local bannedPlayer = args.license
    PerformHttpRequest(Config.Webhooks["unban"], function(err, text, headers) end, 'POST', json.encode({
        username = "Ban System",
        embeds = {
            {
                title = "Gracz został zbanowany.",
                description = "Informacje\n" .. "```" .. "Odbanowany przez: " .. GetPlayerName(xPlayer.source) .. "\nLicencja: " .. bannedPlayer .. "```",
                color = 16711680,
            }
        }
    }),
    { ['Content-Type'] = 'application/json' })
    MySQL.query.await(
        "DELETE FROM feciu_bans WHERE license = @license",
        {
            ['@license'] = bannedPlayer,
        }
    )
end, true, {
    help = "Odbanuj Gracza Offline",
    validate = true,
    arguments = {
        { name = 'license',   help = "Licka Gracza",             type = 'string' },
    }
})

ESX.RegisterCommand("unbanid_p", { "best" }, function(xPlayer, args, showError)
    local bannedPlayer = args.id
    TriggerClientEvent("unbanikxpp", bannedPlayer.source)
    local discord  = GetPlayerIdentifierByType(bannedPlayer.source, "discord") and GetPlayerIdentifierByType(bannedPlayer.source, "discord"):gsub("discord:", "") or "Brak"

    PerformHttpRequest(Config.Webhooks["unban"], function(err, text, headers) end, 'POST', json.encode({
        username = "Ban System",
        content = "<@" .. discord .. ">",
        embeds = {
            {
                title = "Gracz został zbanowany.",
                description = "Informacje\n" .. "```" .. "Odbanowany przez: " .. GetPlayerName(xPlayer.source) .. "\nNick: " .. GetPlayerName(bannedPlayer.source) .. "```",
                color = 16711680,
            }
        }
    }),
    { ['Content-Type'] = 'application/json' })
end, true, {
    help = "Odbanuj Gracza",
    validate = true,
    arguments = {
        { name = 'id', help = "ID Gracza", type = 'player' }
    }
})

RegisterNetEvent("usunBana", function()
    RemoveBan(source)
end)

RegisterNetEvent("updateTime", function(unixTime)
    Bans[source] = unixTime
end)

function RemoveBan(id)
    Bans[id] = nil
    local id = id
    local player = ESX.GetPlayerFromId(id)

    player.setCoords(Config.Coords["unban"])

    MySQL.query.await(
        "DELETE FROM feciu_bans WHERE license = @license",
        {
            ['@license'] = GetPlayerIdentifierByType(id, "license")
        }
    )

    TriggerClientEvent("unbanikxpp", id)
    player.showNotification("Zakończono Bana")
end

RegisterNetEvent("esx:playerLoaded", function(source)
    local source = source
    Wait(7000)
    local license = GetPlayerIdentifierByType(source, "license")

    local result = MySQL.query.await(
        "SELECT * FROM feciu_bans WHERE license = @license",
        {
            ['@license'] = license
        }
    )

    if result and result[1] then
        Bans[source] = result[1].time
        TriggerClientEvent("dostalBana", source, result[1].time, os.time())
    end
end)

AddEventHandler("playerDropped", function(resourceName)
    local license = GetPlayerIdentifierByType(source, "license")
    local source = source
    if Bans[source] then
        local result = MySQL.query.await(
            "SELECT * FROM feciu_bans WHERE license = @license",
            {
                ['@license'] = license
            }
        )

        if not result or not result[1] then
            MySQL.insert(
                "INSERT INTO feciu_bans (license, time) VALUES (@license, @time)",
                {
                    ['@license'] = license,
                    ['@time'] = Bans[source],
                }
            )
        end
    end
end)
