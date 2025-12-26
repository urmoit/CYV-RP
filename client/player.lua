-- Client-side player management

local isLoggedIn = false
local currentCharacter = nil
local availableCharacters = {}

-- Character selection UI (placeholder)
RegisterNetEvent('cyv_rp:showCharacterSelection')
AddEventHandler('cyv_rp:showCharacterSelection', function(characters)
    availableCharacters = characters or {}

    if #availableCharacters == 0 then
        TriggerEvent('cyv_rp:showCharacterCreation')
        return
    end

    -- Placeholder: Display character list in chat
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {'CYV RP', 'Select a character:'}
    })

    for i, char in ipairs(availableCharacters) do
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            args = {'CYV RP', i .. '. ' .. char.firstname .. ' ' .. char.lastname .. ' (ID: ' .. char.id .. ')'}
        })
    end

    TriggerEvent('chat:addMessage', {
        color = {255, 255, 0},
        args = {'CYV RP', 'Use /selectchar [number] to select'}
    })
end)

-- Character creation UI (placeholder)
RegisterNetEvent('cyv_rp:showCharacterCreation')
AddEventHandler('cyv_rp:showCharacterCreation', function()
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {'CYV RP', 'Create a new character:'}
    })

    TriggerEvent('chat:addMessage', {
        color = {255, 255, 0},
        args = {'CYV RP', 'Use /createchar [firstname] [lastname] [dob] [gender]'}
    })
end)

-- Character selected
RegisterNetEvent('cyv_rp:characterSelected')
AddEventHandler('cyv_rp:characterSelected', function(character)
    currentCharacter = character
    isLoggedIn = true

    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        args = {'CYV RP', 'Welcome, ' .. character.firstname .. ' ' .. character.lastname}
    })

    -- Update HUD or something
    TriggerEvent('cyv_rp:updateHUD', character)
end)

-- Spawn player
RegisterNetEvent('cyv_rp:spawnPlayer')
AddEventHandler('cyv_rp:spawnPlayer', function(position, model)
    local pos = position or {x = -1037.5, y = -2737.5, z = 20.0} -- Default spawn (airport)

    if type(pos) == 'string' then
        pos = json.decode(pos)
    end

    -- Set player model
    if model then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(100)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(PlayerPedId())
    end

    -- Set position
    SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z, false, false, false, true)

    -- Freeze player until ready
    FreezeEntityPosition(PlayerPedId(), false)

    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        args = {'CYV RP', 'Spawned successfully!'}
    })
end)

-- Update money
RegisterNetEvent('cyv_rp:updateMoney')
AddEventHandler('cyv_rp:updateMoney', function(amount)
    if currentCharacter then
        currentCharacter.money = amount
        TriggerEvent('cyv_rp:updateHUD', currentCharacter)
    end
end)

-- Update bank
RegisterNetEvent('cyv_rp:updateBank')
AddEventHandler('cyv_rp:updateBank', function(amount)
    if currentCharacter then
        currentCharacter.bank = amount
        TriggerEvent('cyv_rp:updateHUD', currentCharacter)
    end
end)

-- Update job
RegisterNetEvent('cyv_rp:updateJob')
AddEventHandler('cyv_rp:updateJob', function(job, grade)
    if currentCharacter then
        currentCharacter.job = job
        currentCharacter.job_grade = grade
        TriggerEvent('cyv_rp:updateHUD', currentCharacter)
    end
end)

-- Receive player data
RegisterNetEvent('cyv_rp:receivePlayerData')
AddEventHandler('cyv_rp:receivePlayerData', function(data)
    currentCharacter = data
end)

-- Commands
RegisterCommand('createchar', function(source, args, raw)
    if #args < 4 then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'CYV RP', 'Usage: /createchar [firstname] [lastname] [dob YYYY-MM-DD] [gender male/female]'}
        })
        return
    end

    local firstname = args[1]
    local lastname = args[2]
    local dob = args[3]
    local gender = args[4]

    if gender ~= 'male' and gender ~= 'female' then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'CYV RP', 'Gender must be male or female'}
        })
        return
    end

    TriggerServerEvent('cyv_rp:createCharacter', {
        firstname = firstname,
        lastname = lastname,
        dateofbirth = dob,
        gender = gender
    })
end, false)

RegisterCommand('selectchar', function(source, args, raw)
    if #args < 1 then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'CYV RP', 'Usage: /selectchar [number]'}
        })
        return
    end

    local charNum = tonumber(args[1])
    if not charNum or charNum < 1 or charNum > #availableCharacters then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'CYV RP', 'Invalid character number'}
        })
        return
    end

    local selectedChar = availableCharacters[charNum]
    if selectedChar then
        TriggerServerEvent('cyv_rp:selectCharacter', selectedChar.id)
    end
end, false)

RegisterCommand('save', function()
    TriggerServerEvent('cyv_rp:savePlayer')
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        args = {'CYV RP', 'Player data saved'}
    })
end, false)

-- HUD update (placeholder)
RegisterNetEvent('cyv_rp:updateHUD')
AddEventHandler('cyv_rp:updateHUD', function(character)
    -- Placeholder: Display in chat
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 255},
        args = {'HUD', 'Money: $' .. character.money .. ' | Bank: $' .. character.bank .. ' | Job: ' .. character.job}
    })
end)

-- Thread to save player data periodically
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000) -- 5 minutes
        if isLoggedIn then
            TriggerServerEvent('cyv_rp:savePlayer')
        end
    end
end)