ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterNetEvent("odznaka:pokaodznake")
AddEventHandler("odznaka:pokaodznake", function(sid, metadata)
    local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sid)), true), GetEntityCoords(PlayerPedId(), true), true)
    if distance <=  5.0 then
        if GetPlayerServerId(PlayerId()) == sid then
            RequestAnimDict("random@atm_robbery@return_wallet_male")
	        while not HasAnimDictLoaded("random@atm_robbery@return_wallet_male") do 
		        Citizen.Wait(0)
	        end
	        local prop = CreateObject(GetHashKey('prop_fib_badge'), GetEntityCoords(PlayerPedId()), true)
	        AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.03, 0.003, -0.045, 90.0, 0.0, 75.0, 1, 0, 0, 0, 0, 1)
	        TaskPlayAnim(PlayerPedId(), "random@atm_robbery@return_wallet_male", "return_wallet_positive_a_player", 8.0, 3.0, 1000, 56, 1, false, false, false)
	        Citizen.Wait(1000)
	        DeleteEntity(prop)
        end
        TriggerEvent('chat:addMessage',  { color = { 242, 159, 252}, multiline = false, args = { "Obywatel ["..sid.."] pokazuje odznakę policjanta: ["..metadata.odznaka.."] "..metadata.dane.." ("..metadata.ranga..")" } })
    end
end)
