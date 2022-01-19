local voiceToggled = false
local UIHidden = false
local UIRadar = false

--Cricle Radar
Citizen.CreateThread(
    function()
        RequestStreamedTextureDict("circlemap", false)
        while not HasStreamedTextureDictLoaded("circlemap") do
            Wait(100)
        end

        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

        SetMinimapClipType(1)
        SetMinimapComponentPosition("minimap", "L", "B", 0.025, -0.03, 0.153, Config.MapZoom)
        SetMinimapComponentPosition("minimap_mask", "L", "B", 0.135, 0.12, 0.093, 0.164)
        SetMinimapComponentPosition("minimap_blur", "L", "B", 0.012, 0.022, 0.256, 0.337)

        local minimap = RequestScaleformMovie("minimap")

        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(100)
        SetRadarBigmapEnabled(false, false)

        Citizen.Wait(1000)

        SendNUIMessage(
            {
                type = "Init",
            }
        )

        while true do
            Wait(0)
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
                
           
        end
    end
)

Citizen.CreateThread(
    function()
        while true do

            Citizen.Wait(Config.VitalsUpdateInterval)
            
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped)
            local pauseMenu = IsPauseMenuActive()

           if pauseMenu and not UIHidden then
                 SendNUIMessage(
                        {
                            type = "hideUI"
                        }
                    )
                 UIHidden = true
            elseif UIHidden and not pauseMenu then
                 SendNUIMessage(
                        {
                            type = "showUI"
                        }
                    )
                UIHidden = false
            end

            if not Config.AlwaysDisplayRadar then
                if vehicle ~= 0 and UIRadar then
                    SendNUIMessage(
                        {
                            type = "openMapUI"
                        }
                    )
                    DisplayRadar(true)
                    UIRadar = false
                elseif not UIRadar and vehicle == 0 then
                    SendNUIMessage(
                        {
                            type = "closeMapUI"
                        }
                    )
                    UIRadar = true
                    DisplayRadar(false)
                end
            else
                DisplayRadar(true)
            end

            
        end
    end
)
