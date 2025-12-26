-- Database integration using oxmysql

-- Load oxmysql
if GetResourceState('oxmysql') ~= 'started' then
    print('^1[CYV RP] oxmysql is not started! Please ensure it is installed and started.^0')
    return
end

MySQL = {}

-- Async query
MySQL.Async = {}

function MySQL.Async.fetchAll(query, parameters, callback)
    exports.oxmysql:execute(query, parameters or {}, function(result)
        callback(result)
    end)
end

function MySQL.Async.fetchScalar(query, parameters, callback)
    exports.oxmysql:scalar(query, parameters or {}, function(result)
        callback(result)
    end)
end

function MySQL.Async.execute(query, parameters, callback)
    exports.oxmysql:execute(query, parameters or {}, function(result)
        if callback then callback(result) end
    end)
end

-- Sync query (use sparingly)
MySQL.Sync = {}

function MySQL.Sync.fetchAll(query, parameters)
    local p = promise.new()
    exports.oxmysql:execute(query, parameters or {}, function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

function MySQL.Sync.fetchScalar(query, parameters)
    local p = promise.new()
    exports.oxmysql:scalar(query, parameters or {}, function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

function MySQL.Sync.execute(query, parameters)
    local p = promise.new()
    exports.oxmysql:execute(query, parameters or {}, function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

-- Ready callback
MySQL.ready = function(callback)
    Citizen.CreateThread(function()
        while GetResourceState('oxmysql') ~= 'started' do
            Citizen.Wait(1000)
        end
        callback()
    end)
end

-- Initialize database tables
MySQL.ready(function()
    print('^2[CYV RP] Database connected. Initializing tables...^0')

    -- Load and execute tables.sql
    local sqlFile = LoadResourceFile(GetCurrentResourceName(), 'sql/tables.sql')
    if sqlFile then
        local queries = string.split(sqlFile, ';')
        for _, query in ipairs(queries) do
            query = string.trim(query)
            if query ~= '' then
                MySQL.Async.execute(query, {}, function()
                    -- Table created or already exists
                end)
            end
        end
        print('^2[CYV RP] Database tables initialized.^0')
    else
        print('^1[CYV RP] Failed to load sql/tables.sql^0')
    end
end)

-- Utility functions
function string.split(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function string.trim(s)
    return s:match'^%s*(.*%S)' or ''
end