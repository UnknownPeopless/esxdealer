-- ESX = exports["es_extended"]:getSharedObject()

-- local Keys = {
-- 	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
-- 	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
-- 	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
-- 	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
-- 	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
-- 	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
-- 	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
-- 	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
-- 	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
-- }

-- local isRunningWorkaround = false



-- function StartWorkaroundTask()
-- 	if isRunningWorkaround then
-- 		return
-- 	end

-- 	local timer = 0
-- 	local playerPed = PlayerPedId()
-- 	isRunningWorkaround = true

-- 	while timer < 100 do
-- 		Citizen.Wait(0)
-- 		timer = timer + 1

-- 		local vehicle = GetVehiclePedIsTryingToEnter(playerPed)

-- 		if DoesEntityExist(vehicle) then
-- 			local lockStatus = GetVehicleDoorLockStatus(vehicle)

-- 			if lockStatus == 4 then
-- 				ClearPedTasks(playerPed)
-- 			end
-- 		end
-- 	end

-- 	isRunningWorkaround = false
-- end

-- RegisterCommand('kunci', function()
-- 	ToggleVehicleLock()
-- end)

-- RegisterKeyMapping('kunci', 'Lock Car', 'keyboard', "U")

-- AddEventHandler('lockcar', function()
-- 	ToggleVehicleLock()
-- end)

-- RegisterNetEvent('esx_keylocksystem:ToggleLock')
-- AddEventHandler('esx_keylocksystem:ToggleLock', function()
--  ToggleVehicleLock()
-- end)

-- function ToggleVehicleLock()
-- 	local dict = "anim@mp_player_intmenu@key_fob@"
--   	RequestAnimDict(dict)
--   	while not HasAnimDictLoaded(dict) do
--       	Citizen.Wait(0)
--   	end
-- 	local playerPed = PlayerPedId()
-- 	local coords = GetEntityCoords(playerPed)
-- 	local vehicle

-- 	Citizen.CreateThread(function()
-- 		StartWorkaroundTask()
-- 	end)

-- 	if IsPedInAnyVehicle(playerPed, false) then
-- 		vehicle = GetVehiclePedIsIn(playerPed, false)
-- 	else
-- 		vehicle = GetClosestVehicle(coords, 8.0, 0, 71)
-- 	end

-- 	if not DoesEntityExist(vehicle) then
-- 		exports['rds_module']:DoHudText("error", "Tidak ada Kendaraan Di Sekitar")
-- 		return
-- 	end

-- 	ESX.TriggerServerCallback('esx_vehiclelock:requestPlayerCars', function(isOwnedVehicle)

-- 		if isOwnedVehicle then
-- 			local lockStatus = GetVehicleDoorLockStatus(vehicle)

-- 			if lockStatus == 1 then 
-- 				if not IsPedInAnyVehicle(PlayerPedId(), true) then
-- 					vehicleKeys = CreateObject(GetHashKey("prop_cuff_keys_01"), 0, 0, 0, true, true, true) -- creates object
-- 					AttachEntityToEntity(vehicleKeys, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.11, 0.03, -0.03, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
-- 					TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
-- 				end
-- 				SetVehicleDoorsLocked(vehicle, 2)
-- 				SetVehicleLights(vehicle, 2)
-- 				StartVehicleHorn(vehicle, 50, GetHashKey("HELDDOWN") , false)
-- 				Citizen.Wait(150)
-- 				SetVehicleLights(vehicle, 0)
-- 				Citizen.Wait(150)
-- 				SetVehicleLights(vehicle, 2)
-- 				Citizen.Wait(150)
-- 				SetVehicleLights(vehicle, 0)
-- 				exports['rds_module']:DoHudText("success", "Kendaraan Terkunci")
-- 			elseif lockStatus == 2 then 
-- 				if not IsPedInAnyVehicle(PlayerPedId(), true) then
-- 					vehicleKeys = CreateObject(GetHashKey("prop_cuff_keys_01"), 0, 0, 0, true, true, true) -- creates object
-- 					AttachEntityToEntity(vehicleKeys, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.11, 0.03, -0.03, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
-- 					TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
-- 				end
-- 				SetVehicleDoorsLocked(vehicle, 1)
-- 				SetVehicleLights(vehicle, 2)
-- 				StartVehicleHorn(vehicle, 50, GetHashKey("HELDDOWN") , false)
-- 				Citizen.Wait(150)
-- 				SetVehicleLights(vehicle, 0)
-- 				Citizen.Wait(150)
-- 				SetVehicleLights(vehicle, 2)
-- 				StartVehicleHorn(vehicle, 50, GetHashKey("HELDDOWN") , false)
-- 				Citizen.Wait(150)
-- 				SetVehicleLights(vehicle, 0)
-- 				exports['rds_module']:DoHudText("success", "Kendaraan Terbuka")
-- 			end

-- 			if DoesEntityExist(vehicleKeys) then
-- 				Wait(800)
-- 				DeleteEntity(vehicleKeys)
-- 			end
-- 		end

-- 	end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
-- end

ESX = exports["es_extended"]:getSharedObject()

local isRunningWorkaround = false

function StartWorkaroundTask()
    if isRunningWorkaround then return end

    local timer = 0
    local playerPed = PlayerPedId()
    isRunningWorkaround = true

    while timer < 100 do
        Citizen.Wait(0)
        timer = timer + 1

        local vehicle = GetVehiclePedIsTryingToEnter(playerPed)
        if DoesEntityExist(vehicle) then
            local lockStatus = GetVehicleDoorLockStatus(vehicle)
            if lockStatus == 4 then
                ClearPedTasks(playerPed)
            end
        end
    end

    isRunningWorkaround = false
end

RegisterCommand('kunci', function()
    ToggleVehicleLock()
end)

RegisterKeyMapping('kunci', 'Lock Car', 'keyboard', "U")

AddEventHandler('lockcar', function()
    ToggleVehicleLock()
end)

RegisterNetEvent('esx_keylocksystem:ToggleLock')
AddEventHandler('esx_keylocksystem:ToggleLock', function()
    ToggleVehicleLock()
end)

function ToggleVehicleLock()
    local dict = "anim@mp_player_intmenu@key_fob@"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = nil

    Citizen.CreateThread(function()
        StartWorkaroundTask()
    end)

    if IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    else
        -- Mencari kendaraan terdekat (darat & helikopter)
        vehicle = GetClosestVehicle(coords, 8.0, 0, 71)

        if not DoesEntityExist(vehicle) then
            -- Cari helikopter di sekitar dengan filter model yang sesuai
            local vehicles = GetGamePool("CVehicle")
            for _, veh in ipairs(vehicles) do
                if #(GetEntityCoords(veh) - coords) < 8.0 and IsThisModelAHeli(GetEntityModel(veh)) then
                    vehicle = veh
                    break
                end
            end
        end
    end

    if not DoesEntityExist(vehicle) then
        exports['rds_module']:DoHudText("error", "Tidak ada kendaraan di sekitar")
        return
    end

    ESX.TriggerServerCallback('esx_vehiclelock:requestPlayerCars', function(isOwnedVehicle)
        if isOwnedVehicle then
            local lockStatus = GetVehicleDoorLockStatus(vehicle)

            if lockStatus == 1 then -- Kendaraan tidak terkunci
                if not IsPedInAnyVehicle(playerPed, true) then
                    PlayKeyFobAnimation()
                end
                SetVehicleDoorsLocked(vehicle, 2)
                TriggerLockEffects(vehicle)
                exports['rds_module']:DoHudText("success", "Kendaraan terkunci")

            elseif lockStatus == 2 then -- Kendaraan terkunci
                if not IsPedInAnyVehicle(playerPed, true) then
                    PlayKeyFobAnimation()
                end
                SetVehicleDoorsLocked(vehicle, 1)
                TriggerLockEffects(vehicle)
                exports['rds_module']:DoHudText("success", "Kendaraan terbuka")
            end
        end
    end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
end

function PlayKeyFobAnimation()
    local playerPed = PlayerPedId()
    local dict = "anim@mp_player_intmenu@key_fob@"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    local vehicleKeys = CreateObject(GetHashKey("prop_cuff_keys_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(vehicleKeys, playerPed, GetPedBoneIndex(playerPed, 57005), 0.11, 0.03, -0.03, 90.0, 0.0, 0.0, true, true, false, true, 1, true)
    TaskPlayAnim(playerPed, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)

    Citizen.Wait(800)
    DeleteEntity(vehicleKeys)
end

function TriggerLockEffects(vehicle)
    SetVehicleLights(vehicle, 2)
    StartVehicleHorn(vehicle, 50, GetHashKey("HELDDOWN"), false)
    Citizen.Wait(150)
    SetVehicleLights(vehicle, 0)
    Citizen.Wait(150)
    SetVehicleLights(vehicle, 2)
    Citizen.Wait(150)
    SetVehicleLights(vehicle, 0)
end
