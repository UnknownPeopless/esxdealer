

Config.PlateLetters  = 4
Config.PlateNumbers  = 4
Config.PlateUseSpace = false
Config.EnablePed = true -- Enable Ped
Config.SpawnVehicle = false  -- TRUE if you want spawn vehicle when buy

Config.TestDrive = false     -- TRUE if you want enable test drive
Config.TestDriveTime = 30   -- TIME in SEC
Config.Target = 'qtarget' -- Change to what target eye using it needs //AddCircleZone\\ Function -- I recommend qtarget : https://github.com/overextended/qtarget
Config.Ped = {
	{ x = -42.74109,   y = -1091.816, z = 25.422344, h = 173.79647 }
}

Config.Blip = {
    vector3(-42.74109, -1091.816, 26.422344) -- Main Car Dealer Blip
}

Config.Shops = {
    [1] = {
        category = 'pdm', 
        coords = vector3(-54.66, -1096.82, 26.42)
    }
    
}