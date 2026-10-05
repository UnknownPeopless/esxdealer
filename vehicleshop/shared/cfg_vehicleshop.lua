
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 120, g = 120, b = 240 }
Config.EnablePlayerManagement     = false -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
Config.EnableOwnedVehicles        = true
Config.EnableSocietyOwnedVehicles = false -- use with EnablePlayerManagement disabled, or else it wont have any effects
Config.ResellPercentage           = 50

Config.Locale                     = 'en'

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.steamVIP = { --DEALER PRIORITAS
	'1100001671ccf6b',
	--'110000108b4537f',
	--'11000015a8a5ba8',
	--'1100001050253f3',
	'11000011725343e',
	--'11000016f55943b',
	--'1100001671c20bd',
	'11000013543e934',
	'110000152b4cc8c',
	'11000010bb301b9',
	'1100001603afc07',
	'110000157e82bc6',
	'110000168533c36',
	'110000152635189',
	'110000135a1a18e',
	'11000014444935c',
	-- '11000010830c49d',
}

Config.Zones = {

	ShopEntering = {
		Pos   = vector3(-45.55, -1103.41, 26.42),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 1
	},

	ShopInside = {
		Pos     = vector3(-45.43, -1099.68, 26.42),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 150.85,
		Type    = -1
	},

	ShopOutside = {
		Pos     = vector3(-44.82, -1078.3, 26.67),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 73.19,
		Type    = -1
	},

	BossActions = {
		Pos   = vector3(-32.0, -1114.2, 25.4),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = -1
	},

	GiveBackVehicle = {
		Pos   = vector3(-18.2, -1078.5, 25.6),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = (Config.EnablePlayerManagement and 1 or -1)
	},

	ResellVehicle = {
		Pos   = vector3(-44.6, -1080.7, 10.6),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = 1
	}

}
