--------------------------------------------------------------------
-------------------------Converted by ex#1515-----------------------
--------------------------------------------------------------------

local lastSelectedVehicleEntity
local startCountDown
local testDriveEntity
local lastPlayerCoords
local hashListLoadedOnMemory = {}
local vehcategory = "pdm"
local inTheShop = true
local profileName
local profileMoney
local vehiclesTable = {}
local provisoryObject = {}
local rgbColorSelected = {255,255,255,}
local rgbSecondaryColorSelected = {255,255,255,}

ESX = exports["es_extended"]:getSharedObject()



Citizen.CreateThread(function()
exports.qtarget:AddCircleZone("vehshop", vector3(-46.9369, -1104.1760, 26.4223), 1.35, {
    name="vehsop",
    debugPoly=false,
    useZ=true,
    }, {
        options = {
            {
                event = "dl-vshop:openmenu",
				icon = "fas fa-car",
				label = "Car Dealer",
            },
            -- {
            --     event = "irp-pdm:enterExperience",
			-- 	icon = "fas fa-car",
			-- 	label = "PDM",
            -- },
        },
        distance = 4.0
    })
end)



local blip 

-- Create Blips
Citizen.CreateThread(function ()

    for i = 1, #Config.Blip do    
        local actualShop = Config.Blip[i]
        blip = AddBlipForCoord(actualShop.x, actualShop.y, actualShop.z)

        SetBlipSprite (blip, 326)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.8)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Local Dealer')
        EndTextCommandSetBlipName(blip)
    end
end)



function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(5)
    SetTextFont(8)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end