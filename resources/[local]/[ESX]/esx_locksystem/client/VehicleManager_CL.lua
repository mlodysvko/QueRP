function newVehicle()
    local self = {}

    self.id = nil
    self.plate = nil
    self.lockStatus = nil

    rTable = {}

    rTable.__construct = function(id, plate, lockStatus)
        if(id and type(id) == "number")then
            self.id = id
        end
        if(plate and type(plate) == "string")then
            self.plate = plate
        end
        if(lockStatus and type(lockStatus) == "number")then
            self.lockStatus = lockStatus
        end
    end

    -- Methods

    rTable.update = function(id, lockStatus)
        self.id = id
        self.lockStatus = lockStatus
    end

    -- 0, 1 = unlocked
    -- 2 = locked
    -- 4 = locked and player can't get out
    rTable.lock = function()
        lockStatus = self.lockStatus
        if(lockStatus <= 2)then
            self.lockStatus = 4
            SetVehicleDoorsLocked(self.id, self.lockStatus)
            SetVehicleDoorsLockedForAllPlayers(self.id, 1)
            local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
            if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                TaskPlayAnim(GetPlayerPed(-1), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                TriggerEvent('esx:showAdvancedNotification', 'Pojazd Zamknięty', 'Numer Rej. ~y~' ..plate )
            else
                if not IsPedInAnyVehicle(ped) then
                    TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                end                
                TriggerEvent('esx:showAdvancedNotification', 'Pojazd Zamknięty') 
            end
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'lock', 0.35)
        elseif(lockStatus > 2)then
            self.lockStatus = 1
            SetVehicleDoorsLocked(self.id, self.lockStatus)
            SetVehicleDoorsLockedForAllPlayers(self.id, false)
            local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
            if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                TriggerEvent('esx:showAdvancedNotification', 'Pojazd Otwarty', 'Numer Re. ~y~' ..plate)
            else
                if not IsPedInAnyVehicle(ped) then
                    TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                end
                TriggerEvent('esx:showAdvancedNotification', 'Pojazd Otwarty') 
            end
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'unlock', 0.35)
        end
    end
    RegisterNetEvent('Arivi:Lock')
    AddEventHandler('Arivi:Lock', function()
        lockStatus = self.lockStatus
        if(lockStatus <= 2)then
            self.lockStatus = 4
            SetVehicleDoorsLocked(self.id, self.lockStatus)
            SetVehicleDoorsLockedForAllPlayers(self.id, 1)
            local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
            if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                TriggerEvent('esx:showAdvancedNotification', 'Pojazd Zamknięty', 'Numer Rej. ~y~' ..plate )
            else
                if not IsPedInAnyVehicle(ped) then
                    TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                end
                TriggerEvent('esx:showAdvancedNotification', 'Pojazd Zamknięty') 
            end
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'lock', 0.35)
        elseif(lockStatus > 2)then
            self.lockStatus = 1
            SetVehicleDoorsLocked(self.id, self.lockStatus)
            SetVehicleDoorsLockedForAllPlayers(self.id, false)
            local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)), true)
            if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                TriggerEvent('esx:showAdvancedNotification', 'Pojazd Otwarty', 'Numer Re. ~y~' ..plate)
            else
                if not IsPedInAnyVehicle(ped) then
                    TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                end
                TriggerEvent('esx:showAdvancedNotification', 'Pojazd Otwarty') 
            end
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'unlock', 0.35)
        end
    end)

    -- Setters

    rTable.setId = function(id)
        if(type(id) == "number" and id >= 0)then
            self.id = id
        end
    end

    rTable.setPlate = function(plate)
        if(type(plate) == "string")then
            self.plate = plate
        end
    end

    rTable.setLockStatus = function(lockStatus)
        if(type(lockStatus) == "number" and lockStatus >= 0)then
            self.lockStatus = lockStatus
            SetVehicleDoorsLocked(self.id, lockStatus)
        end
    end

    -- Getters

    rTable.getId = function()
        return self.id
    end

    rTable.getPlate = function()
        return self.plate
    end

    rTable.getLockStatus = function()
        return self.lockStatus
    end

    return rTable
end
