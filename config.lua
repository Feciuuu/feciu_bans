Config = {}

Config.Coords = {
    ["ban"] = vector3(1073.0, -3102.49, -39.0),
    ["unban"] = vector3(1006.57, -2503.58, 28.30),
    ["work"] = { -- kordy gdzie robią minigierki
        vector3(1048.95, -3100.67, -38.99 - 1.0),
    }
}

Config.Games = {
    {
        ["name"] = "WordsGame",
        ["wordsAmount"] = 5,
        ["readyTime"] = 3500,
        ["gameTime"] = 7500
    },
    {
        ["name"] = "CatchGame",
        ["title"] = 'Just put the fries in the Bag',
        ["readyTime"] = 2500,
        ["amount"] = 10,
        ["spawnTime"] = { 1500, 2000 },
        ["hand"] = 'img/fries_pack.png',
        ["handSize"] = 3,
        ["fallTime"] = {
            ["bad"] = { 3000, 3500 },
            ["good"] = { 3500, 4000 }
        },
        ["images"] = {
            ["good"] = { 'fries' },
            ["bad"] = { 'fries_mold' }

        },
    },
    {
        ["name"] = "MathGame",
        ["preset"] = 'easy',
        ["wordsAmount"] = 10,
        ["questionsAmount"] = 20,
        ["maxFails"] = 3,
        ["fallTime"] = 5000
    },
    {
        ["name"] = "BeatGame",
        ["keysAmount"] = 15,
        ["keys"] = { 'A', 'S', 'D', 'F' },
        ["maxFails"] = 3,
        ["readyTime"] = 2500
    },
    {
        ["name"] = "MemorizeGame",
        ["amount"] = 3,
        ["rememberTime"] = 3000,
        ["answerTime"] = 7500,
        ["readyTime"] = 2500
    },
    {
        ["name"] = "CodeGame",
        ["correctCode"] = "12345",
        ["time"] = 12500,
        ["readyTime"] = 2500,
        ["maxFails"] = 3,
    },
    {
        ["name"] = "SkillCheck",
        ["letters"] = { 'W', 'X', 'E', 'Z' },
        ["amount"] = 6,
        ["time"] = 5500,
        ["readyTime"] = 2500,
        ["maxFails"] = 3,
        ["hand"] = 'img/keyboard.png',
        ["handSize"] = 3,
        ["images"] = {
            ["good"] = { 'keyboard' },
            ["bad"] = { 'keyboard_mold' }
        },
    }
}