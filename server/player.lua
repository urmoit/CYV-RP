-- Server-side player management

-- Load shared functions
if not Player then
    Player = {}
end

-- Player data per source
local playerData = {}

-- Load player data
function Player.Load(source)
    local steam_id = Player.GetIdentifier(source)
    local license = Player.GetLicense(source)

    if not steam_id then
        print('^1[CYV RP] No Steam ID found for player ' .. source .. '^0')
        return false
    end

    playerData[source] = {
        id = nil,
        steam_id = steam_id,
        characters = {},
        current_character = nil
    }

    MySQL.Async.fetchAll('SELECT * FROM users WHERE steam_id = @steam_id', {
        ['@steam_id'] = steam_id
    }, function(user)
        if user[1] then
            -- User exists, load characters
            playerData[source].id = user[1].id
            playerData[source].steam_id = steam_id
            Player.LoadCharacters(source)
        else
            -- New user, create account
            MySQL.Async.execute('INSERT INTO users (steam_id, license, name, ip, last_login) VALUES (@steam_id, @license, @name, @ip, NOW())', {
                ['@steam_id'] = steam_id,
                ['@license'] = license,
                ['@name'] = GetPlayerName(source),
                ['@ip'] = GetPlayerEndpoint(source)
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    playerData[source].id = MySQL.Sync.fetchScalar('SELECT id FROM users WHERE steam_id = @steam_id', {
                        ['@steam_id'] = steam_id
                    })
                    playerData[source].steam_id = steam_id
                    TriggerClientEvent('cyv_rp:showCharacterSelection', source)
                end
            end)
        end
    end)

    return true
end

-- Load characters for player
function Player.LoadCharacters(source)
    if not playerData[source] or not playerData[source].id then return end

    MySQL.Async.fetchAll('SELECT * FROM characters WHERE user_id = @user_id', {
        ['@user_id'] = playerData[source].id
    }, function(characters)
        playerData[source].characters = characters
        if #characters > 0 then
            TriggerClientEvent('cyv_rp:showCharacterSelection', source, characters)
        else
            TriggerClientEvent('cyv_rp:showCharacterCreation', source)
        end
    end)
end

-- Create new character
function Player.CreateCharacter(source, data)
    if not playerData[source] or not playerData[source].id then return false end

    MySQL.Async.execute('INSERT INTO characters (user_id, firstname, lastname, dateofbirth, gender, height, model, money, bank) VALUES (@user_id, @firstname, @lastname, @dateofbirth, @gender, @height, @model, @money, @bank)', {
        ['@user_id'] = playerData[source].id,
        ['@firstname'] = data.firstname,
        ['@lastname'] = data.lastname,
        ['@dateofbirth'] = data.dateofbirth,
        ['@gender'] = data.gender,
        ['@height'] = data.height or 180,
        ['@model'] = data.model or (data.gender == 'male' and 'mp_m_freemode_01' or 'mp_f_freemode_01'),
        ['@money'] = Config.Framework.defaultMoney,
        ['@bank'] = Config.Framework.defaultBank
    }, function(rowsChanged)
        if rowsChanged > 0 then
            Player.LoadCharacters(source)
        end
    end)
end

-- Select character
function Player.SelectCharacter(source, characterId)
    if not playerData[source] or not playerData[source].characters then return end

    for _, char in ipairs(playerData[source].characters) do
        if char.id == characterId then
            playerData[source].current_character = char
            TriggerClientEvent('cyv_rp:characterSelected', source, char)
            -- Set player position, model, etc.
            TriggerClientEvent('cyv_rp:spawnPlayer', source, char.position, char.model)
            break
        end
    end
end

-- Save character data
function Player.SaveCharacter(source)
    if not playerData[source] or not playerData[source].current_character then return end

    local char = playerData[source].current_character
    local pos = GetEntityCoords(GetPlayerPed(source))

    MySQL.Async.execute('UPDATE characters SET position = @position, money = @money, bank = @bank, job = @job, job_grade = @job_grade, inventory = @inventory WHERE id = @id', {
        ['@position'] = json.encode({x = pos.x, y = pos.y, z = pos.z}),
        ['@money'] = char.money,
        ['@bank'] = char.bank,
        ['@job'] = char.job,
        ['@job_grade'] = char.job_grade,
        ['@inventory'] = json.encode(char.inventory or {}),
        ['@id'] = char.id
    })
end

-- Player connecting
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()
    deferrals.update('Loading CYV RP...')

    Citizen.Wait(1000)
    deferrals.done()
end)

-- Player joined
AddEventHandler('playerJoined', function()
    local source = source
    print('^2[CYV RP] Player ' .. GetPlayerName(source) .. ' joined.^0')

    -- Load player data
    Player.Load(source)
end)

-- Player dropped
AddEventHandler('playerDropped', function(reason)
    local source = source
    print('^1[CYV RP] Player ' .. GetPlayerName(source) .. ' dropped: ' .. reason .. '^0')

    -- Save character data
    Player.SaveCharacter(source)
end)

-- Register events
RegisterNetEvent('cyv_rp:createCharacter')
AddEventHandler('cyv_rp:createCharacter', function(data)
    local source = source
    Player.CreateCharacter(source, data)
end)

RegisterNetEvent('cyv_rp:selectCharacter')
AddEventHandler('cyv_rp:selectCharacter', function(characterId)
    local source = source
    Player.SelectCharacter(source, characterId)
end)

RegisterNetEvent('cyv_rp:savePlayer')
AddEventHandler('cyv_rp:savePlayer', function()
    local source = source
    Player.SaveCharacter(source)
end)

-- Get player data
RegisterNetEvent('cyv_rp:getPlayerData')
AddEventHandler('cyv_rp:getPlayerData', function()
    local source = source
    if Player.Data.current_character then
        TriggerClientEvent('cyv_rp:receivePlayerData', source, Player.Data.current_character)
    end
end)

-- Update player money
function Player.UpdateMoney(source, amount, type)
    if not playerData[source] or not playerData[source].current_character then return false end

    if type == 'add' then
        playerData[source].current_character.money = playerData[source].current_character.money + amount
    elseif type == 'remove' then
        if playerData[source].current_character.money >= amount then
            playerData[source].current_character.money = playerData[source].current_character.money - amount
            return true
        end
        return false
    elseif type == 'set' then
        playerData[source].current_character.money = amount
    end

    TriggerClientEvent('cyv_rp:updateMoney', source, playerData[source].current_character.money)
    return true
end

-- Update player bank
function Player.UpdateBank(source, amount, type)
    if not playerData[source] or not playerData[source].current_character then return false end

    if type == 'add' then
        playerData[source].current_character.bank = playerData[source].current_character.bank + amount
    elseif type == 'remove' then
        if playerData[source].current_character.bank >= amount then
            playerData[source].current_character.bank = playerData[source].current_character.bank - amount
            return true
        end
        return false
    elseif type == 'set' then
        playerData[source].current_character.bank = amount
    end

    TriggerClientEvent('cyv_rp:updateBank', source, playerData[source].current_character.bank)
    return true
end

-- Set player job
function Player.SetJob(source, job, grade)
    if not playerData[source] or not playerData[source].current_character then return false end

    playerData[source].current_character.job = job
    playerData[source].current_character.job_grade = grade or 0

    TriggerClientEvent('cyv_rp:updateJob', source, job, grade)
    return true
end

-- Get player by source
function Player.GetBySource(source)
    if playerData[source] then
        return playerData[source].current_character
    end
    return nil
end

-- Get player by character ID
function Player.GetById(id)
    local result = MySQL.Sync.fetchAll('SELECT * FROM characters WHERE id = @id', {
        ['@id'] = id
    })
    return result[1]
end

-- Cleanup on player drop
AddEventHandler('playerDropped', function(reason)
    local source = source
    print('^1[CYV RP] Player ' .. GetPlayerName(source) .. ' dropped: ' .. reason .. '^0')

    -- Save character data
    Player.SaveCharacter(source)

    -- Clean up data
    playerData[source] = nil
end)