ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)


--blips

Citizen.CreateThread(function()

    local cripsmap = AddBlipForCoord(-112.07, -31.04, 62.19)

    SetBlipSprite(cripsmap, 310)
    SetBlipColour(cripsmap, 38)
    SetBlipScale(cripsmap, 0.80)
    SetBlipAsShortRange(cripsmap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Quartier Crips")
    EndTextCommandSetBlipName(cripsmap)
end)

--fin blips


--- Jobs

Citizen.CreateThread(function()
    
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k,v in pairs(crips.pos) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'crips' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'crips' then 
            if (crips.Type ~= -1 and GetDistanceBetweenCoords(coords, v.position.x, v.position.y, v.position.z, true) < crips.DrawDistance) then
                DrawMarker(crips.Type, v.position.x, v.position.y, v.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, crips.Size.x, crips.Size.y, crips.Size.z, crips.Color.r, crips.Color.g, crips.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

-------garage

RMenu.Add('garagecrips', 'main', RageUI.CreateMenu("Garage", "Garage crips"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('garagecrips', 'main'), true, true, true, function() 
            RageUI.ButtonWithStyle("Ranger la voiture", "Pour ranger une voiture.", {RightLabel = "→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
            if dist4 < 4 then
                ESX.ShowAdvancedNotification("Garagiste karim", "La voiture est de retour merci!", "", "CHAR_BIKESITE", 1)
                DeleteEntity(veh)
            end 
        end
    end) 

            RageUI.ButtonWithStyle("Primo", "Pour sortir une primo.", {RightLabel = "→"},true, function(Hovered, Active, Selected)
            if (Selected) then
            Citizen.Wait(1)  
            spawnuniCar("primo")
            end
        end)

        RageUI.ButtonWithStyle("Manchez", "Pour sortir une manchez.", {RightLabel = "→"},true, function(Hovered, Active, Selected)
            if (Selected) then
            Citizen.Wait(1)  
            spawnuniCar("manchez")
            end
        end)

        RageUI.ButtonWithStyle("Van", "Pour sortir un van.", {RightLabel = "→"},true, function(Hovered, Active, Selected)
            if (Selected) then
            Citizen.Wait(1)  
            spawnuniCar("moonbeam2")
            end
        end)
            

            
        end, function()
        end)
            Citizen.Wait(0)
        end
    end)

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    

    
                local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, crips.pos.garage.position.x, crips.pos.garage.position.y, crips.pos.garage.position.z)
            if dist3 <= 3.0 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'crips' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'crips' then    
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au garage")
                    if IsControlJustPressed(1,51) then           
                        RageUI.Visible(RMenu:Get('garagecrips', 'main'), not RageUI.Visible(RMenu:Get('garagecrips', 'main')))
                    end   
                end
               end 
        end
end)

function spawnuniCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, crips.pos.spawnvoiture.position.x, crips.pos.spawnvoiture.position.y, crips.pos.spawnvoiture.position.z, crips.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "crips"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    SetVehicleCustomPrimaryColour(vehicle, 0, 0, 255)
    SetVehicleCustomSecondaryColour(vehicle, 0, 0, 255)
    SetVehicleMaxMods(vehicle)
end

function SetVehicleMaxMods(vehicle)

    local props = {
      modEngine       = 2,
      modBrakes       = 2,
      modTransmission = 2,
      modSuspension   = 3,
      modTurbo        = true,
    }
  
    ESX.Game.SetVehicleProperties(vehicle, props)
  
  end


--coffre

RMenu.Add('coffrecrips', 'main', RageUI.CreateMenu("Coffre", "Pour déposer/récuperer des choses dans le coffre."))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('coffrecrips', 'main'), true, true, true, function()
            RageUI.ButtonWithStyle("Prendre objet", "Pour prendre un objet.", {RightLabel = "→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            RageUI.CloseAll()
            OpenGetStockscripsMenu()
            end
            end)
            RageUI.ButtonWithStyle("Déposer objet", "Pour déposer un objet.", {RightLabel = "→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            RageUI.CloseAll()
            OpenPutStockscripsMenu()
            end
            end)
                        		--	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'lieutenant' or ESX.PlayerData.job.grade_name == 'sergeant' then 
			RageUI.ButtonWithStyle("Prendre Arme(s)",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
				if Selected then
					OpenGetWeaponMenu()
					RageUI.CloseAll()
				end
			end)
		--	end
			
		--	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'lieutenant' or ESX.PlayerData.job.grade_name == 'sergeant' then 
			RageUI.ButtonWithStyle("Déposer Arme(s)",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
				if Selected then
					OpenPutWeaponMenu()
					RageUI.CloseAll()
				end
			end)
		--end
            end, function()
            end)
            Citizen.Wait(0)
        end
    end)

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
                local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, crips.pos.coffre.position.x, crips.pos.coffre.position.y, crips.pos.coffre.position.z)
            if jobdist <= 1.0 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'crips' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'crips' then  
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au coffre")
                    if IsControlJustPressed(1,51) then
                        RageUI.Visible(RMenu:Get('coffrecrips', 'main'), not RageUI.Visible(RMenu:Get('coffrecrips', 'main')))
                    end   
                end
               end 
        end
end)

function OpenGetStockscripsMenu()
    ESX.TriggerServerCallback('esx_cripsjob:prendreitem', function(items)
        local elements = {}

        for i=1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'crips',
            title    = 'crips stockage',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                css      = 'crips',
                title = 'quantité'
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if not count then
                    ESX.ShowNotification('quantité invalide')
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_cripsjob:prendreitems', itemName, count)

                    Citizen.Wait(300)
                    OpenGetStockscripsMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenPutStockscripsMenu()
    ESX.TriggerServerCallback('esx_cripsjob:inventairejoueur', function(inventory)
        local elements = {}

        for i=1, #inventory.items, 1 do
            local item = inventory.items[i]

            if item.count > 0 then
                table.insert(elements, {
                    label = item.label .. ' x' .. item.count,
                    type = 'item_standard',
                    value = item.name
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'crips',
            title    = 'inventaire',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                css      = 'crips',
                title = 'quantité'
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if not count then
                    ESX.ShowNotification('quantité invalide')
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_cripsjob:stockitem', itemName, count)

                    Citizen.Wait(300)
                    OpenPutStockscripsMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenGetWeaponMenu()

	ESX.TriggerServerCallback('esx_cripsjob:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon',
		{
			title    = 'Armurerie',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			menu.close()

			ESX.TriggerServerCallback('esx_cripsjob:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',
	{
		title    = 'Armurerie',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		menu.close()

		ESX.TriggerServerCallback('esx_cripsjob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)

	end, function(data, menu)
		menu.close()
	end)
end

--menu

local societycripsmoney = nil


RMenu.Add('cripsf6', 'main', RageUI.CreateMenu("crips", "Intéraction"))


Citizen.CreateThread(function()
    while true do
    	

        RageUI.IsVisible(RMenu:Get('cripsf6', 'main'), true, true, true, function()

        	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            RageUI.ButtonWithStyle("Fouiller", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local target, distance = ESX.Game.GetClosestPlayer()
					playerheading = GetEntityHeading(GetPlayerPed(-1))
					playerlocation = GetEntityForwardVector(PlayerPedId())
					playerCoords = GetEntityCoords(GetPlayerPed(-1))
					local target_id = GetPlayerServerId(target)
					if closestPlayer ~= -1 and closestDistance <= 3.0 then  
                    RageUI.CloseAll()
                    OpenBodySearchMenu(closestPlayer)
                    ExecuteCommand("me La personne fouille")
                else
                    ESX.ShowNotification('Peronne autour')
                end
                end
            end)    

        RageUI.ButtonWithStyle("Menotter/démenotter", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if (Selected) then
                local target, distance = ESX.Game.GetClosestPlayer()
                playerheading = GetEntityHeading(GetPlayerPed(-1))
                playerlocation = GetEntityForwardVector(PlayerPedId())
                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                local target_id = GetPlayerServerId(target)
                if closestPlayer ~= -1 and closestDistance <= 3.0 then 
                TriggerServerEvent('esx_cripsjob:handcuff', GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification('Peronne autour')
            end
            end
        end)

            RageUI.ButtonWithStyle("Escorter", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local target, distance = ESX.Game.GetClosestPlayer()
					playerheading = GetEntityHeading(GetPlayerPed(-1))
					playerlocation = GetEntityForwardVector(PlayerPedId())
					playerCoords = GetEntityCoords(GetPlayerPed(-1))
					local target_id = GetPlayerServerId(target)
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('esx_cripsjob:drag', GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification('Peronne autour')
            end
            end
        end)

            RageUI.ButtonWithStyle("Mettre dans un véhicule", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local target, distance = ESX.Game.GetClosestPlayer()
					playerheading = GetEntityHeading(GetPlayerPed(-1))
					playerlocation = GetEntityForwardVector(PlayerPedId())
					playerCoords = GetEntityCoords(GetPlayerPed(-1))
					local target_id = GetPlayerServerId(target)
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('esx_cripsjob:putInVehicle', GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification('Peronne autour')
            end
                end
            end)

            RageUI.ButtonWithStyle("Sortir du véhicule", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local target, distance = ESX.Game.GetClosestPlayer()
					playerheading = GetEntityHeading(GetPlayerPed(-1))
					playerlocation = GetEntityForwardVector(PlayerPedId())
					playerCoords = GetEntityCoords(GetPlayerPed(-1))
					local target_id = GetPlayerServerId(target)
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('esx_cripsjob:OutVehicle', GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification('Peronne autour')
            end
            end
        end)

        end, function()
        end)

            Citizen.Wait(0)
        end
    end)

--- Job 1

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'crips' then  

                    if IsControlJustPressed(0, 167) then
                        RageUI.Visible(RMenu:Get('cripsf6', 'main'), not RageUI.Visible(RMenu:Get('cripsf6', 'main')))
                end   
        end 
    end
end)

---- job 2

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
            
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'crips' then 

                if IsControlJustPressed(0, 168) then
                    RageUI.Visible(RMenu:Get('cripsf6', 'main'), not RageUI.Visible(RMenu:Get('cripsf6', 'main')))
            end
    end 
end
end)


--------- Imput

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)


    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

-------------------------- Intéraction 

RegisterNetEvent('esx_cripsjob:handcuff')
AddEventHandler('esx_cripsjob:handcuff', function()

  IsHandcuffed    = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(100)
        end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      DisableControlAction(2, 37, true)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)
      DisableControlAction(0, 24, true) -- Attack
      DisableControlAction(0, 257, true) -- Attack 2
      DisableControlAction(0, 25, true) -- Aim
      DisableControlAction(0, 263, true) -- Melee Attack 1
      DisableControlAction(0, 37, true) -- Select Weapon
      DisableControlAction(0, 47, true)  -- Disable weapon
      DisplayRadar(false)

    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)
      DisplayRadar(true)

    end

  end)
end)

RegisterNetEvent('esx_cripsjob:drag')
AddEventHandler('esx_cripsjob:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = GetPlayerPed(-1)
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(GetPlayerPed(-1), true, false)
      end
    end
  end
end)

RegisterNetEvent('esx_cripsjob:putInVehicle')
AddEventHandler('esx_cripsjob:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)

RegisterNetEvent('esx_cripsjob:OutVehicle')
AddEventHandler('esx_cripsjob:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

-- Handcuff
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 30,  true) -- MoveLeftRight
      DisableControlAction(0, 31,  true) -- MoveUpDown
    end
  end
end)

----------------------------------------------- Fouiller

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('esx_cripsjob:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = 'argent sale ', ESX.Math.Round(data.accounts[i].money),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end
		end

		table.insert(elements, {label = 'Armes'})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = ESX.GetWeaponLabel(data.weapons[i].name)..' avec '..data.weapons[i].ammo.. ' Munitions',
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = 'Items'})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = data.inventory[i].count..' x'..data.inventory[i].label,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = 'fouille',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				TriggerServerEvent('esx_cripsjob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				OpenBodySearchMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

