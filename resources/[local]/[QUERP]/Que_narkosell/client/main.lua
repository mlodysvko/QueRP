local a={
    ["ESC"]=322,["F1"]=288,["F2"]=289,["F3"]=170,["F5"]=166,["F6"]=167,["F7"]=168,["F8"]=169,["F9"]=56,
    ["F10"]=57,["~"]=243,["1"]=157,["2"]=158,["3"]=160,["4"]=164,["5"]=165,["6"]=159,["7"]=161,["8"]=162,
    ["9"]=163,["-"]=84,["="]=83,["BACKSPACE"]=177,["TAB"]=37,["Q"]=44,["W"]=32,["E"]=38,["R"]=45,["T"]=245,
    ["Y"]=246,["U"]=303,["P"]=199,["["]=39,["]"]=40,["ENTER"]=18,["CAPS"]=137,["A"]=34,["S"]=8,["D"]=9,["F"]=23,
    ["G"]=47,["H"]=74,["K"]=311,["L"]=182,["LEFTSHIFT"]=21,["Z"]=20,["X"]=73,["C"]=26,["V"]=0,["B"]=29,["N"]=249,
    ["M"]=244,[","]=82,["."]=81,["LEFTCTRL"]=36,["LEFTALT"]=19,["SPACE"]=22,["RIGHTCTRL"]=70,["HOME"]=213,["PAGEUP"]=10,
    ["PAGEDOWN"]=11,["DELETE"]=178,["LEFT"]=174,["RIGHT"]=175,["TOP"]=27,["DOWN"]=173,["NENTER"]=201,["N4"]=108,["N5"]=60,
    ["N6"]=107,["N+"]=96,["N-"]=97,["N7"]=117,["N8"]=61,["N9"]=118}
    
    ESX=nil;
    
    Citizen.CreateThread(function()
        while ESX==nil do
             TriggerEvent('esx:getSharedObject',function(b)ESX=b end)Citizen.Wait(0)end;
             while ESX.GetPlayerData().job==nil do 
                Citizen.Wait(10)
            end;
            
            PlayerData=ESX.GetPlayerData()
        end)
        
        RegisterNetEvent('esx:playerLoaded')
        AddEventHandler('esx:playerLoaded',function(c)
            PlayerData=c
         end)
         
         function DrawText3D(x,y,z,d)
            local e,f,g=World3dToScreen2d(x,y,z)
            local h,i,j=table.unpack(GetGameplayCamCoords())
            SetTextScale(0.37,0.37)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextColour(255,255,255,215)
            SetTextEntry("STRING")
            SetTextCentre(1)
            AddTextComponentString(d)
            DrawText(f,g)
            
            local k=string.len(d)/370;
            DrawRect(f,g+0.0125,0.015+k,0.03,33,33,33,133)
        end;
        
        local l;
        local m=-10;
        local n=-10;
        local o=0;
        local b;
        local p;
        local q=200;
        local r='a_m_m_bevhills_01'
        
        RegisterNetEvent('tostdrugs:getcustomer')
        AddEventHandler('tostdrugs:getcustomer',function()
            TaskStartScenarioInPlace(GetPlayerPed(-1),"WORLD_HUMAN_STAND_MOBILE",0,true)
            ESX.ShowNotification('~g~Zamieszczasz w Darknecie informacje o sprzedaży narkotyku, niebawem zjawi się klient.')
            Citizen.Wait(5000)
            print(WAIT)
            ClearPedTasks(GetPlayerPed(-1))
            local s=math.random(1,2)
            if s==1 then
                 RequestModel("a_f_m_bevhills_02")
                 while not HasModelLoaded("a_f_m_bevhills_02")do
                     Wait(10)
                    end;
                    
                    r="a_f_m_bevhills_02"
                else
                     RequestModel("a_m_m_bevhills_01")
                     while not HasModelLoaded("a_m_m_bevhills_01")do
                         Wait(10)end;r="a_m_m_bevhills_01"
                        end;
                        
                        local t=GetEntityCoords(GetPlayerPed(-1))
                        local u=math.random(1,2)
                        local v=math.random(1,2)
                        if u==1 then
                             m=-35
                             else
                                 m=35
                                 end;
                                 if v==1 then
                                     n=-35 else
                                         n=35 end;
                                         Wait(500)
                                         local w,A=GetGroundZFor_3dCoord(t.x+m,t.y+n,t.z,0)
                                         l=CreatePed(26,r,t.x+m,t.y+n,A+0.5,268.9422,true,true)
                                         PlaceObjectOnGroundProperly(l)
                                         SetEntityAsMissionEntity(l)
                                         SetBlockingOfNonTemporaryEvents(l,true)
                                         SetPedKeepTask(l,true)
                                         TaskGoToEntity(l,GetPlayerPed(-1),-1,3.5,2.0,1073741824.0,0)
                                         SetPedKeepTask(l,true)o=0;
                                         local B=true;
                                         while B do 
                                            Citizen.Wait(500)
                                            
                                            local C=GetEntityCoords(l)
                                            local t=GetEntityCoords(GetPlayerPed(-1))
                                            
                                            q=GetEntityHealth(l)
                                            
                                            local D=Vdist(C.x,C.y,C.z,t.x,t.y,t.z)o=o+1;
                                            if D<=1.5 or o>=75 or q<100 then 
                                                B=false end end;if o>=75 
                                                or
                                                 q<1.0 then
                                                     ESX.ShowNotification('~r~Klient w ostatniej chwili zrezygnował z zamówienia, możesz wezwać nowego')
                                                     TriggerServerEvent("tostdrugs:clientpassed")
                                                     TaskWanderStandard(l,10.0,10)
                                                     SetPedAsNoLongerNeeded(l)
                                                    else
                                                         SetEntityHeading(GetPlayerPed(-1),GetEntityHeading(l)-180.0)
                                                         RequestAnimDict("mp_common")
                                                         while not HasAnimDictLoaded("mp_common")do
                                                             Citizen.Wait(0)
                                                            end;
                                                            
                                                            b=CreateObject(GetHashKey('prop_weed_bottle'),0,0,0,true)
                                                            AttachEntityToEntity(b,PlayerPedId(),GetPedBoneIndex(PlayerPedId(),57005),0.13,0.02,0.0,-90.0,0,0,1,1,0,1,0,1)
                                                            p=CreateObject(GetHashKey('hei_prop_heist_cash_pile'),0,0,0,true)
                                                            AttachEntityToEntity(p,l,GetPedBoneIndex(l,57005),0.13,0.02,0.0,-90.0,0,0,1,1,0,1,0,1)
                                                            TaskPlayAnim(GetPlayerPed(-1),"mp_common","givetake1_a",8.0,-8.0,-1,0,0,false,false,false)
                                                            TaskPlayAnim(l,"mp_common","givetake1_a",8.0,-8.0,-1,0,0,false,false,false)
                                                            Wait(1550)
                                                            DeleteEntity(b)
                                                            DeleteEntity(p)
                                                            ClearPedTasks(pid)
                                                            ClearPedTasks(l)
                                                            TaskWanderStandard(l,10.0,10)
                                                            SetPedAsNoLongerNeeded(l)
                                                            
                                                            x,y,z=table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
                                                            playerX=tonumber(string.format("%.2f",x))
                                                            playerY=tonumber(string.format("%.2f",y))
                                                            playerZ=tonumber(string.format("%.2f",z))
                                                            TriggerServerEvent("tostdrugs:udanyzakup",playerX,playerY,playerZ)
                                                            
                                                            Citizen.Wait(500)
                                                        end
                                                     end)
                                                     
                                                     RegisterNetEvent('tostdrugs:infoPolicja')
                                                     AddEventHandler('tostdrugs:infoPolicja',function(x,y,z)
                                                        if PlayerData.job~=nil and PlayerData.job.name=='police'then
                                                             local E=GetStreetNameAtCoord(x,y,z)
                                                             local F=GetStreetNameFromHashKey(E)
                                                             ESX.ShowNotification('~r~Zgłoszono sprzedaż narkotyków w okolicy ~y~'..F..'!')
                                                             PlaySoundFrontend(-1,"Bomb_Disarmed","GTAO_Speed_Convoy_Soundset",0)
                                                             local G=AddBlipForCoord(x,y,z)
                                                             SetBlipSprite(G,161)
                                                             SetBlipScale(G,1.2)
                                                             SetBlipColour(G,25)
                                                             SetBlipAlpha(G,180)
                                                             SetBlipHighDetail(G,true)
                                                             BeginTextCommandSetBlipName("STRING")
                                                             AddTextComponentString('#Sprzedaż narkotyków')
                                                             EndTextCommandSetBlipName(G)Citizen.Wait(60000)RemoveBlip(G)
                                                            end
                                                         end)