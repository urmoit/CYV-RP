-- Shared player functions and data structures

Player = {}

-- Player data structure
Player.Data = {
    id = nil,
    steam_id = nil,
    characters = {},
    current_character = nil
}

-- Character data structure
Player.Character = {
    id = nil,
    firstname = '',
    lastname = '',
    dateofbirth = '',
    gender = 'male',
    height = 180,
    model = 'mp_m_freemode_01',
    position = {x = 0, y = 0, z = 0},
    money = 0,
    bank = 0,
    job = 'unemployed',
    job_grade = 0,
    inventory = {},
    skin = {},
    tattoos = {}
}

-- Utility functions
function Player.GetIdentifier(player)
    for i = 0, GetNumPlayerIdentifiers(player) - 1 do
        local id = GetPlayerIdentifier(player, i)
        if string.find(id, 'steam:') then
            return string.sub(id, 7)
        end
    end
    return nil
end

function Player.GetLicense(player)
    for i = 0, GetNumPlayerIdentifiers(player) - 1 do
        local id = GetPlayerIdentifier(player, i)
        if string.find(id, 'license:') then
            return string.sub(id, 9)
        end
    end
    return nil
end

-- Check if player is logged in (client-side)
function Player.IsLoggedIn()
    return isLoggedIn or false
end

-- Get current character (client-side)
function Player.GetCurrentCharacter()
    return currentCharacter
end