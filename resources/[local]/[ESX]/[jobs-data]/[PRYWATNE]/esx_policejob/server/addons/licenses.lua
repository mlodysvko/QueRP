ESX.RegisterServerCallback('esx_society:getEmployeeslic', function(source, cb, job, society)
	MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job OR job = @job2 ORDER BY job_grade DESC', {
		['@job'] = society,
		['@job2'] = 'off'..society,			
	}, function (results)
		local employees = {}
		local count = 0		
		for i=1,99 do if results[i] ~= nil then count = i else break end end
			
		for i=1, #results, 1 do

			local seu = false
			local heli = false
			local fto = false
			local aiad = false
			local swat = false		
			MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
				['@owner'] = results[i].identifier,	
			}, function (results2)
				for k,v in pairs (results2) do
					if v.type == 'police_seu' then
						seu = true
					elseif v.type == 'police_heli' then
						heli = true
					elseif v.type == 'police_fto' then
						fto = true
					elseif v.type == 'police_aiad' then
						aiad = true
					elseif v.type == 'police_swat' then
						swat = true
					end
				end

				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					licensess = {
						seu = seu,
						heli = heli,
						fto = fto,
						aiad = aiad,
						swat = swat,
					}
				})

				if count == i then
					cb(employees)
				end				
			end)					
		end
	end)
end)

RegisterServerEvent('esx_policejob:addlicense')
AddEventHandler('esx_policejob:addlicense', function (identifier, licka)
    local _source = source
  	MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)',
	{
		['@type'] = licka,
		['@owner']   = identifier
    }, function (rowsChanged)
	end)
end)

RegisterServerEvent('esx_policejob:removelicense')
AddEventHandler('esx_policejob:removelicense', function (identifier, licka)
    local _source = source
  	MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @owner AND type = @type',
    {
		['@type'] = licka,
		['@owner']   = identifier
    }, function (rowsChanged)
	end)
end)