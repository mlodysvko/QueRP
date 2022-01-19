ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Island:GetJobsDuty')
AddEventHandler('Island:GetJobsDuty', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local grade = xPlayer.job.grade
    if xPlayer.job.name == 'police' then
        xPlayer.setJob('offpolice', grade)
    elseif xPlayer.job.name == 'ambulance' then
        xPlayer.setJob('offambulance', grade)
    --elseif xPlayer.job.name == 'mecano' then
    --    xPlayer.setJob('offmecano', grade)
    end
end)

RegisterServerEvent('Island:GetJobsLicense')
AddEventHandler('Island:GetJobsLicense', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchAll(
        'SELECT type, owner FROM user_licenses WHERE owner = @owner AND type = @type',
        {
          ['@type'] = 'weapon',
          ['@owner'] = xPlayer.identifier,
        })
    if result[1] == nil and xPlayer.job.name == 'police' then
        MySQL.Async.execute(
        'INSERT INTO user_licenses (type, owner, label) VALUES (@type, @owner, @label)',
        {
        ['@type'] = 'weapon',
        ['@owner']   = xPlayer.identifier,
        ['@label'] = 'Licencja Broń',
        },
        function (rowsChanged)
        
        end)
    end
end)

RegisterServerEvent('IslandGetJobsInsuraceEMS')
AddEventHandler('IslandGetJobsInsuraceEMS', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchAll(
        'SELECT type, owner FROM user_licenses WHERE owner = @owner AND type = @type',
        {
          ['@type'] = 'ems_insurance',
          ['@owner'] = xPlayer.identifier,
        })
        if result[1] == nil and xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'mecano' then
        MySQL.Async.execute(
        'INSERT INTO user_licenses (type, owner, label, time) VALUES (@type, @owner, @label, @time)',
        {
        ['@type'] = 'ems_insurance',
        ['@owner']   = xPlayer.identifier,
        ['@label'] = 'Ubezpieczenie NW',
        ['@time'] = '-1',
        },
        function (rowsChanged)
        
        end)
    end
end)

RegisterServerEvent('IslandGetJobsInsuraceLSC')
AddEventHandler('IslandGetJobsInsuraceLSC', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchAll(
        'SELECT type, owner FROM user_licenses WHERE owner = @owner AND type = @type',
        {
          ['@type'] = 'oc_insurance',
          ['@owner'] = xPlayer.identifier,
        })
    if result[1] == nil and xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'mecano' then
        MySQL.Async.execute(
        'INSERT INTO user_licenses (type, owner, label, time) VALUES (@type, @owner, @label, @time)',
        {
        ['@type'] = 'oc_insurance',
        ['@owner']   = xPlayer.identifier,
        ['@label'] = 'Ubezpieczenie OC',
        ['@time'] = '-1',
        },
        function (rowsChanged)
        
        end)
    end
end)