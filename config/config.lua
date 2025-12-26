-- CYV RP Framework Configuration
Config = {}

-- Database Configuration
Config.Database = {
    host = 'localhost',
    user = 'root',
    password = '',
    database = 'cyv_rp',
    port = 3306
}

-- Framework Settings
Config.Framework = {
    maxPlayers = 64,
    defaultMoney = 1000,
    defaultBank = 5000,
    maxCharacters = 3,
    enableLogging = true,
    enableAnalytics = true
}

-- Economy Settings
Config.Economy = {
    jobs = {
        unemployed = { label = 'Unemployed', salary = 0 },
        police = { label = 'Police Officer', salary = 1500 },
        mechanic = { label = 'Mechanic', salary = 1200 },
        -- Add more jobs
    },
    taxes = {
        income = 0.05,
        property = 0.02
    }
}

-- Inventory Settings
Config.Inventory = {
    maxWeight = 50.0,
    maxSlots = 30
}

-- Vehicle Settings
Config.Vehicles = {
    maxOwned = 3,
    insuranceCost = 500
}

-- Housing Settings
Config.Housing = {
    maxProperties = 2,
    rentMultiplier = 1.0
}

-- Faction Settings
Config.Factions = {
    maxMembers = 20,
    territorySize = 100.0
}

-- Police Settings
Config.Police = {
    jailTime = 300, -- seconds
    fineAmount = 500
}

-- Admin Settings
Config.Admin = {
    commands = {
        ban = 'admin_ban',
        kick = 'admin_kick',
        -- etc
    }
}