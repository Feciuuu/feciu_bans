local hasBan = false
ESX          = exports['es_extended']:getSharedObject()
local time   = 0


RegisterNetEvent("dostalBana", function(unixTime, tempTime, isSolo)
    CreateThread(function()
        hasBan = true
        time = unixTime
        SetEntityInvincible(PlayerPedId(), true)
        while (time - tempTime > 0) and (hasBan) do
            Wait(1000)
            if #(vector3(Config.Coords["ban"]) - GetEntityCoords(PlayerPedId())) > 30.0 then
                SetEntityCoords(PlayerPedId(), vector3(Config.Coords["ban"]))
            end
            time = time - 1
            SendNUIMessage({ unixTime = time, updateTime = true, tempTime = tempTime })
        end
        SendNUIMessage({ hide = true })
        SetEntityInvincible(PlayerPedId(), false)
        TriggerServerEvent("usunBana")
    end)
end)

RegisterNetEvent("updateTime", function(unixTime)
    time = unixTime
    SendNUIMessage({ unixTime = time, updateTime = true })
end)

CreateThread(function()
    while true do
        Wait(30000)
        if hasBan then
            TriggerServerEvent("updateTime", time)
        end
    end
end)


RegisterNetEvent("unbanikxpp", function()
    hasBan = false
end)

CreateThread(function()
    while true do
        Wait(0)
        while not hasBan do Wait(4000) end
        for k, coords in pairs(Config.Coords["work"]) do
            if #(coords - GetEntityCoords(PlayerPedId())) < 6.0 then
                DrawMarker(1, coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 4.0, 4.0, 0.3, 88, 150, 209, 175, false, true, 2, true, false,
                false, false)
                if #(coords - GetEntityCoords(PlayerPedId())) < 3.0 then
                    ESX.ShowHelpNotification("Naciśnij ~INPUT_CONTEXT~ aby Pracować")
                    if IsControlJustPressed(0, 38) then
                        StartRandomGame()
                    end
                end
            end
        end
    end
end)

function StartRandomGame()
    local randomObject = math.random(1, #Config.Games)
    local gameName = Config.Games[randomObject]["name"]
    local gameProperties = Config.Games[randomObject]
    if gameName == "CodeGame" then
        gameProperties["correctCode"] = tostring(math.random(10000, 99999))
    end
    local res = exports["feciu_minigames"]:StartGame(gameName, gameProperties)
    if res then
        ESX.ShowNotification("Usunięto 5 minut Bana")
        time = time - 300
    else
        time = time + 60
        ESX.ShowNotification("Dodano 1 minutę do Czasu Bana")
    end
end
