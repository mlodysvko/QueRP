ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local modifieddmg = {
    {
        weapon = `WEAPON_PISTOL`,
        dmg = 0.55
    },
    {
        weapon = `WEAPON_COMBATPISTOL`,
        dmg = 0.55
    },
    {
        weapon = `WEAPON_SNSPISTOL`,
        dmg = 0.45
    },
    {
        weapon = `WEAPON_PISTOL_MK2`,
        dmg = 0.55
    },
    {
        weapon = `WEAPON_SNSPISTOL_MK2`,
        dmg = 0.435
    },
    {
        weapon = `WEAPON_HEAVYPISTOL`,
        dmg = 0.55
    },
    {
        weapon = `WEAPON_VINTAGEPISTOL`,
        dmg = 0.55
    },
    {
        weapon = `WEAPON_CERAMICPISTOL`,
        dmg = 0.65
    },
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedArmed(PlayerPedId(), 4) then
            local weapon = GetSelectedPedWeapon(PlayerPedId())
            for k,v in pairs(modifieddmg) do
                N_0x4757f00bc6323cfe(v.weapon, v.dmg)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

local helmets = {
    {
        helmet = 116,
        sex = 'male'
    },
    {
        helmet = 117,
        sex = 'male'
    },
    {
        helmet = 118,
        sex = 'male'
    },
    {
        helmet = 119,
        sex = 'male'
    },
    {
        helmet = 115,
        sex = 'female'
    },
    {
        helmet = 116,
        sex = 'female'
    },
    {
        helmet = 117,
        sex = 'female'
    },
    {
        helmet = 118,
        sex = 'female'
    },
}

local iswearinghelmet = false

Citizen.CreateThread(function()
    while true do
        for number, value in pairs(helmets) do
            if IsPedMale(PlayerPedId()) then
                if value.sex == 'male' then
                    if GetPedPropIndex(PlayerPedId(), 0) == value.helmet then
                        iswearinghelmet = true
                    end
                end
            else
                if value.sex == 'female' then
                    if GetPedPropIndex(PlayerPedId(), 0) == value.helmet then
                        iswearinghelmet = true
                    end
                end
            end
        end
        Citizen.Wait(30000)
    end
end)

local death = false

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(100)
            local a = PlayerPedId()
            if not IsEntityDead(a) then
                local b, c = GetPedLastDamageBone(a)
                if c == 31086 then
                    for d, e in pairs(modifieddmg) do
                        if HasEntityBeenDamagedByWeapon(a, e.weapon, 0) then
                            if not iswearinghelmet then
                                ESX.TriggerServerCallback(
                                    "testdmg",
                                    function(f)
                                        Citizen.Wait(110)
                                        if f and f <= 80.0 then
                                            if death == false then
                                                SetEntityHealth(a, 0)
                                                death = true
                                            end
                                            Citizen.Wait(500)
                                            death = false
                                        else
                                            local g = GetEntityHealth(a)
                                            givehealth = g - 25
                                            if givehealth <= 100 then
                                                givehealth = 0
                                            else
                                                ClearEntityLastDamageEntity(a)
                                            end
                                            if death == false then
                                                SetEntityHealth(a, givehealth)
                                            end
                                            Citizen.Wait(500)
                                            death = false
                                        end
                                    end
                                )
                            else
                                local g = GetEntityHealth(a)
                                local h = GetPedArmour(a)
                                if h > 0 then
                                    givearmor = h - 50
                                    if givearmor < 0 then
                                        givearmor = 0
                                    end
                                    SetPedArmour(a, givearmor)
                                    ClearEntityLastDamageEntity(a)
                                else
                                    givehealth = g - 25
                                    if givehealth <= 100 then
                                        givehealth = 0
                                    else
                                        ClearEntityLastDamageEntity(a)
                                    end
                                    SetEntityHealth(a, givehealth)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
)

RegisterNetEvent('adrenalinarp:dokilleffect')
AddEventHandler('adrenalinarp:dokilleffect', function()
    SetTimecycleModifier("hud_def_desat_cold_kill")
    Citizen.Wait(300)
    ClearTimecycleModifier()
end)
