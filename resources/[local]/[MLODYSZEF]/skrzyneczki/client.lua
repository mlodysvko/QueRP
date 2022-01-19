local script_active = true
ESX = nil
local draw = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end	
end)

-- MORE AVAILABLE ON 5MSCRIPTS.COM

RegisterNUICallback('mkbuss:NUIoff', function(data, cb)
	SetNuiFocus(false,false)
    SendNUIMessage({
        type = "off"
    })
end)

-- MORE AVAILABLE ON 5MSCRIPTS.COM

RegisterNetEvent("mkbuss:open5mscriptscom")
AddEventHandler("mkbuss:open5mscriptscom", function(data)
    if Config.CloseInventoryHudTrigger ~= '' and Config.CloseInventoryHudTrigger ~= nil then
        TriggerEvent(Config.CloseInventoryHudTrigger)
    end
    
	local sum = 0
	draw = {}
	for k, v in pairs(Config["5mscriptscom"][data].list) do
		local rate = Config["chance"][v.tier].rate * 100
		for i=1,rate do 
			if v.item then
				if v.amount then
					table.insert(draw, {item = v.item ,amount = v.amount, tier = v.tier})
				else
					table.insert(draw, {item = v.item ,amount = 1, tier = v.tier})
				end
			elseif v.weapon then
				table.insert(draw, {weapon = v.weapon , tier = v.tier})
			elseif v.vehicle then
				table.insert(draw, {vehicle = v.vehicle, tier = v.tier})
			elseif v.money then
				table.insert(draw, {money = v.money, tier = v.tier})
			elseif v.black_money then
				table.insert(draw, {black_money = v.black_money, tier = v.tier})
			end
			i = i + 1
		end
		sum = sum + rate
	end
	local random = math.random(1,sum)
	SetNuiFocus(true,true)
	SendNUIMessage({
        type = "ui",
		data = Config["5mscriptscom"][data].list,
		img = Config["image_source"],
		win = draw[random]
    })
	Wait(9000)
	if draw[random].item then
		TriggerServerEvent('mkbuss:giveReward', 'item',draw[random].item,draw[random].amount)
	elseif draw[random].weapon then
		TriggerServerEvent('mkbuss:giveReward', 'weapon',draw[random].weapon)
	elseif draw[random].vehicle then
		TriggerEvent('mkbuss:RewardVehicle', draw[random].vehicle)
	elseif draw[random].money then
		TriggerServerEvent('mkbuss:giveReward', 'money',draw[random].money)
	elseif draw[random].black_money then
		TriggerServerEvent('mkbuss:giveReward', 'black_money',draw[random].black_money)
	end

    if Config["broadcast"] then
        TriggerServerEvent("mkbuss:boradcast", draw[random].tier)
    end
end)

-- MORE AVAILABLE ON 5MSCRIPTS.COM

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
    local generatedPlate
    local doBreak = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())

        generatedPlate = string.upper(GetRandomLetter(3) .. ' ' .. GetRandomNumber(3))
        
        ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function (isPlateTaken)
            if not isPlateTaken then
                doBreak = true
            end
        end, generatedPlate)

        if doBreak then
            break
        end
    end

    return generatedPlate
end

-- MORE AVAILABLE ON 5MSCRIPTS.COM
function IsPlateTaken(plate)
    local callback = 'waiting'

    ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
        callback = isPlateTaken
    end, plate)

    while type(callback) == 'string' do
        Citizen.Wait(0)
    end

    return callback
end

function GetRandomNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end

function GetRandomLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end

-- MORE AVAILABLE ON 5MSCRIPTS.COM

RegisterNetEvent('mkbuss:RewardVehicle')
AddEventHandler('mkbuss:RewardVehicle', function(model)
        -- local playerPed  = GetPlayerPed(-1)
        -- local coords     = GetEntityCoords(playerPed)
        -- local Px, Py, Pz = table.unpack(coords)

        ESX.Game.SpawnVehicle(model, { x = 0, y = 0, z = 0 }, 180, function (vehicle)
            -- TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

            local newPlate     = GeneratePlate()
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            vehicleProps.plate = newPlate
            SetVehicleNumberPlateText(vehicle, newPlate)
            TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps)
                                           
        end)
end)