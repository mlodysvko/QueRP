ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterCommand("odznaka", function(source, args, rawcmd)
    local xPlayer = ESX.GetPlayerFromId(source)
    local jobname = xPlayer.job.name
    if jobname == 'police' then
        local odznaka = GetOdznaka(xPlayer.identifier)
        local grade = xPlayer.job.grade_label
        local dane = GetCharName(xPlayer.identifier)
        TriggerClientEvent("odznaka:pokaodznake", -1, source, {odznaka=odznaka, ranga=grade, dane=dane})
    end
end)

RegisterCommand("nadajodznake", function(source, args, rawcmd)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'police' and xPlayer.job.grade_name == 'boss' then
        if tonumber(args[1]) and args[2] and args[3] then
            local tPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
            if tPlayer ~= nil then
                NadajOdznake(tPlayer.identifier, args[2], args[3])
            end
        end
    end
end)

function GetOdznaka(identifier)
    local a = MySQL.Sync.fetchAll("SELECT callsign, odznaka FROM pixel_odznaka WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    });
    local a = a[1]
    if a ~= nil then
        return a.callsign.." - "..a.odznaka
    else
        return "N/A"
    end
end

function GetCharName(identifier)
    local d = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    });
    d = d[1]
    return d.firstname.." "..d.lastname
end

function NadajOdznake(identifier, callsign, odznaka)
    local a = MySQL.Sync.fetchAll("SELECT * FROM pixel_odznaka WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    });
    a = a[1]
    if a == nil then
        MySQL.Async.execute("INSERT INTO pixel_odznaka (identifier, callsign, odznaka) VALUES (@identifier, @callsign, @odznaka)", {
            ['@identifier'] = identifier,
            ['@callsign'] = callsign,
            ['@odznaka'] = odznaka
        });
    else
        MySQL.Async.execute("UPDATE pixel_odznaka SET callsign=@callsign, odznaka=@odznaka WHERE identifier = @identifier", {
            ['@identifier'] = identifier,
            ['@callsign'] = callsign,
            ['@odznaka'] = odznaka
        });
    end
end