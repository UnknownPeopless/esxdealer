ESX = exports["es_extended"]:getSharedObject()
local Categories, Vehicles = {}, {}



TriggerEvent('esx_phone:registerNumber', 'cardealer', _U('dealer_customers'), false, false)
TriggerEvent('esx_society:registerSociety', 'cardealer', _U('car_dealer'), 'society_cardealer', 'society_cardealer', 'society_cardealer', {type = 'private'})

--[[Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('vehicleshop: ^1WARNING^7 plate character count reached, %s/8 characters.'):format(char))
	end
end)]]

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	Categories     = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles')

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end

		table.insert(Vehicles, vehicle)
	end

	-- send information after db has loaded, making sure everyone gets vehicle information
	TriggerClientEvent('vehicleshop:sendCategories', -1, Categories)
	TriggerClientEvent('vehicleshop:sendVehicles', -1, Vehicles)
end)

RegisterServerEvent('vehicleshop:setVehicleOwned')
AddEventHandler('vehicleshop:setVehicleOwned', function(vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)


	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, stored, garage, vehicle) VALUES (@owner, @plate, @stored, @garage, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@stored'] = 1,
		['@garage'] = 'A',
		['@vehicle'] = json.encode(vehicleProps)
	}, function(rowsChanged)
		xPlayer.showNotification(_U('vehicle_belongs', vehicleProps.plate))

		local logs2 = "WEBHOOKDISINI"
		local logsgivesu = {
			{
				["color"] = "1942002",
					["title"] = "Telah membeli kendaraan",
					["description"] = "Nama pembeli: **"..xPlayer.getName().."\nPlat: **"..vehicleProps.plate,
				["footer"] = {
					["text"] = "ethnicrp",
					["icon_url"] = communtiylogo,
				},
			}
		}
		PerformHttpRequest(logs2, function(err, text, headers) end, 'POST', json.encode({username = "ETHNIC LOGS", embeds = logsgivesu}), { ['Content-Type'] = 'application/json' })
	end)
end)

RegisterServerEvent('vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('vehicleshop:setVehicleOwnedPlayerId', function(playerId, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, stored, garage, vehicle) VALUES (@owner, @plate, @stored, @garage, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@stored'] = 1,
		['@garage'] = 'A',
		['@vehicle'] = json.encode(vehicleProps)
	}, function(rowsChanged)
		xPlayer.showNotification(_U('vehicle_belongs', vehicleProps.plate))
	end)
end)

RegisterServerEvent('vehicleshop:setVehicleOwnedSociety')
AddEventHandler('vehicleshop:setVehicleOwnedSociety', function(society, vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
		['@owner']   = 'society:' .. society,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
	}, function(rowsChanged) end)
end)

RegisterServerEvent('vehicleshop:sellVehicle')
AddEventHandler('vehicleshop:sellVehicle', function(vehicle)
	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicle
	}, function(result)
		local id = result[1].id

		MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
			['@id'] = id
		})
	end)
end)

RegisterServerEvent('vehicleshop:addToList')
AddEventHandler('vehicleshop:addToList', function(target, model, plate)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
	local dateNow = os.date('%Y-%m-%d %H:%M')

	if xPlayer.job.name == 'cardealer' then
		MySQL.Async.execute('INSERT INTO vehicle_sold (client, model, plate, soldby, date) VALUES (@client, @model, @plate, @soldby, @date)', {
			['@client'] = xTarget.getName(),
			['@model'] = model,
			['@plate'] = plate,
			['@soldby'] = xPlayer.getName(),
			['@date'] = dateNow
		})
	else
		print(('vehicleshop: %s attempted to add a sold vehicle to list!'):format(xPlayer.identifier))
	end
end)

ESX.RegisterServerCallback('vehicleshop:getSoldVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM vehicle_sold', {}, function(result)
		cb(result)
	end)
end)

RegisterServerEvent('ox-vehicleshop:setVehicleOwnedJob')
AddEventHandler('ox-vehicleshop:setVehicleOwnedJob', function (vehicleProps, vehname)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps)
	}, function (rowsChanged)

		local metadata = {}
		metadata.type = vehname
		metadata.description = vehicleProps.plate

		
	end)
end)


RegisterServerEvent('vehicleshop:rentVehicle')
AddEventHandler('vehicleshop:rentVehicle', function(vehicle, plate, playerName, basePrice, rentPrice, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicle
	}, function(result)
		local id    = result[1].id
		local price = result[1].price
		local owner = xPlayer.identifier

		MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
			['@id'] = id
		})

		MySQL.Async.execute('INSERT INTO rented_vehicles (vehicle, plate, player_name, base_price, rent_price, owner) VALUES (@vehicle, @plate, @player_name, @base_price, @rent_price, @owner)', {
			['@vehicle']     = vehicle,
			['@plate']       = plate,
			['@player_name'] = playerName,
			['@base_price']  = basePrice,
			['@rent_price']  = rentPrice,
			['@owner']       = owner
		})
	end)
end)

RegisterServerEvent('vehicleshop:getStockItem')
AddEventHandler('vehicleshop:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification(_U('have_withdrawn', count, item.label))
			else
				xPlayer.showNotification(_U('player_cannot_hold'))
			end
		else
			xPlayer.showNotification(_U('not_enough_in_society'))
		end
	end)
end)

RegisterServerEvent('vehicleshop:putStockItems')
AddEventHandler('vehicleshop:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, item.label))
		else
			xPlayer.showNotification(_U('invalid_amount'))
		end
	end)
end)

ESX.RegisterServerCallback('vehicleshop:getCategories', function(source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('vehicleshop:getVehicles', function(source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('vehicleshop:buyVehicle', function(source, cb, vehicleModel)
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehicleData

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	if vehicleData and xPlayer.getMoney() >= vehicleData.price then
		xPlayer.removeMoney(vehicleData.price)
		xPlayer.showNotification('Membeli kendaraan dengan harga: '..vehicleData.price)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('vehicleshop:buyVehicleSociety', function(source, cb, society, vehicleModel)
	local vehicleData

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. society, function(account)
		if account.money >= vehicleData.price then
			account.removeMoney(vehicleData.price)

			MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
				['@vehicle'] = vehicleData.model,
				['@price']   = vehicleData.price
			}, function(rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('vehicleshop:getCommercialVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles ORDER BY vehicle ASC', {}, function(result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name  = result[i].vehicle,
				price = result[i].price
			})
		end

		cb(vehicles)
	end)
end)


RegisterServerEvent('vehicleshop:returnProvider')
AddEventHandler('vehicleshop:returnProvider', function(vehicleModel)
	local _source = source

	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicleModel
	}, function(result)
		if result[1] then
			local id = result[1].id
			local price = ESX.Math.Round(result[1].price * 0.75)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
				account.addMoney(price)
			end)

			MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
				['@id'] = id
			})

			xPlayer.showNotification(_U('vehicle_sold_for', vehicleModel, ESX.Math.GroupDigits(price)))
		else
			print(('vehicleshop: %s attempted selling an invalid vehicle!'):format(GetPlayerIdentifiers(_source)[1]))
		end
	end)
end)

ESX.RegisterServerCallback('vehicleshop:getRentedVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles ORDER BY player_name ASC', {}, function(result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name = result[i].vehicle,
				plate = result[i].plate,
				playerName = result[i].player_name
			})
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('vehicleshop:giveBackVehicle', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] then
			local vehicle = result[1].vehicle
			local basePrice = result[1].base_price

			MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
				['@vehicle'] = vehicle,
				['@price']   = basePrice
			})

			MySQL.Async.execute('DELETE FROM rented_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			})

			RemoveOwnedVehicle(plate)
			cb(true)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('vehicleshop:resellVehicle', function(source, cb, plate, model)
	local resellPrice = 0

	-- calculate the resell price
	for i=1, #Vehicles, 1 do
		if GetHashKey(Vehicles[i].model) == model then
			resellPrice = ESX.Math.Round(Vehicles[i].price / 100 * Config.ResellPercentage)
			break
		end
	end

	if resellPrice == 0 then
		print(('vehicleshop: %s attempted to sell an unknown vehicle!'):format(GetPlayerIdentifiers(source)[1]))
		cb(false)
	else
		MySQL.Async.fetchAll('SELECT * FROM rented_vehicles WHERE plate = @plate', {
			['@plate'] = plate
		}, function(result)
			if result[1] then -- is it a rented vehicle?
				cb(false) -- it is, don't let the player sell it since he doesn't own it
			else
				local xPlayer = ESX.GetPlayerFromId(source)

				MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
					['@owner'] = xPlayer.identifier,
					['@plate'] = plate
				}, function(result)
					if result[1] then -- does the owner match?
						local vehicle = json.decode(result[1].vehicle)

						if vehicle.model == model then
							if vehicle.plate == plate then
								xPlayer.addMoney(resellPrice)
								RemoveOwnedVehicle(plate)
								cb(true)
							else
								print(('vehicleshop: %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
								cb(false)
							end
						else
							print(('vehicleshop: %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
							cb(false)
						end
					else
						if xPlayer.job.grade_name == 'boss' then
							MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
								['@owner'] = 'society:' .. xPlayer.job.name,
								['@plate'] = plate
							}, function(result)
								if result[1] then
									local vehicle = json.decode(result[1].vehicle)

									if vehicle.model == model then
										if vehicle.plate == plate then
											xPlayer.addMoney(resellPrice)
											RemoveOwnedVehicle(plate)
											cb(true)
										else
											print(('vehicleshop: %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
											cb(false)
										end
									else
										print(('vehicleshop: %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
										cb(false)
									end
								else
									cb(false)
								end
							end)
						else
							cb(false)
						end
					end
				end)
			end
		end)
	end
end)

ESX.RegisterServerCallback('vehicleshop:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('vehicleshop:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('vehicleshop:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('vehicleshop:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.identifier,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)

RegisterServerEvent('vehicleshop:setJobVehicleState')
AddEventHandler('vehicleshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('vehicleshop: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)

ESX.RegisterServerCallback('vehicleshop:buyVehicle', function (source, cb, vehicleModel)
	local xPlayer     = ESX.GetPlayerFromId(source)
	local vehicleData = nil
	local finalprice = nil
	-- local isVip = false
	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end
	finalprice = vehicleData.price
	print(1,finalprice)
	for i=1, #Config.steamVIP, 1 do
		print(Config.steamVIP[i],xPlayer.identifier)
		if Config.steamVIP[i] == xPlayer.identifier then
			-- isVip = true
			finalprice = vehicleData.price - vehicleData.price / 100 * 20
		end
	end
	print(2,finalprice)
	if xPlayer.getMoney() >= finalprice  then
		xPlayer.removeMoney(finalprice)
		cb(true)
	else
		cb(false)
	end
end)

function PayRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles', {}, function(result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].owner)

			if xPlayer then -- message player if connected
				xPlayer.removeAccountMoney('bank', result[i].rent_price)
				xPlayer.showNotification(_U('paid_rental', ESX.Math.GroupDigits(result[i].rent_price)))
			else -- pay rent by updating SQL
				MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier', {
					['@bank'] = result[i].rent_price,
					['@identifier'] = result[i].owner
				})
			end

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
				account.addMoney(result[i].rent_price)
			end)
		end
	end)
end

TriggerEvent('cron:runAt', 22, 00, PayRent)

local RoutingBuckets = { --nyalain npc
    "0",
    "1",
}

CreateThread(function()
    for i = 1, #RoutingBuckets, 1 do
        SetRoutingBucketPopulationEnabled(tonumber(RoutingBuckets[i]), false)
    end
end)