--------------------------------------------------------------------
-------------------------Converted by ex#1515-----------------------
--------------------------------------------------------------------

ESX = exports["es_extended"]:getSharedObject()
discord = {
    ['webhook'] = 'WEBHOOKDISINI',
    ['name'] = 'CAR DEALER',
    ['image'] = ''
}



RegisterServerEvent('irp-pdm:requestInfo')
AddEventHandler('irp-pdm:requestInfo', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local rows    

    TriggerClientEvent('irp-pdm:receiveInfo', src, xPlayer.getMoney())
    TriggerClientEvent("irp-pdm:notify", src, 'error', 'Use A and D To Rotate')
end)

ESX.RegisterServerCallback('irp-pdm:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
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


-- Double checking on the money, if you do not have it in the inventory, look at the bank -- CREDIT (Sr.Zek)
RegisterServerEvent('irp-pdm:CheckMoneyForVeh')
AddEventHandler('irp-pdm:CheckMoneyForVeh', function(veh, price, name, vehicleProps)
	local _source = source
	local src = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() >= tonumber(price) then
		xPlayer.removeMoney(tonumber(price))
		if Config.SpawnVehicle then
			stateVehicle = 0
		else
			stateVehicle = 1
		end

		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, stored, garage, vehicle) VALUES (@owner, @plate, @stored, @garage, @vehicle)',
		{
			['@owner']   = xPlayer.identifier,
			['@plate']   = vehicleProps.plate,
			['@stored'] = 1,
			['@garage'] = 'A',
			['@vehicle'] = json.encode(vehicleProps)
		}, function (rowsChanged)
			
			TriggerClientEvent("irp-pdm:successfulbuy", _source, name, vehicleProps.plate, price)
			TriggerClientEvent('irp-pdm:receiveInfo', _source, xPlayer.getMoney())   
			TriggerClientEvent('irp-pdm:spawnVehicle', _source, veh, vehicleProps.plate)
			discordLog("TELAH MEMBELI KENDARAAN DENGAN UANG\n\nHarga: " .. price ..  '\nModel Kendaraan: '.. veh .. '\nPlat: ' .. vehicleProps.plate,  'Nama IC: ' .. xPlayer.getName())
		end)
	elseif xPlayer.getAccount('bank').money >= tonumber(price) then
		xPlayer.removeAccountMoney('bank',tonumber(price))
		if Config.SpawnVehicle then
			stateVehicle = 0
		else
			stateVehicle = 1
		end

		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, stored, garage, vehicle) VALUES (@owner, @plate, @stored, @garage, @vehicle)',
		{
			['@owner']   = xPlayer.identifier,
			['@plate']   = vehicleProps.plate,
			['@stored'] = 1,
			['@garage'] = 'A',
			['@vehicle'] = json.encode(vehicleProps)
		}, function (rowsChanged)
			
			TriggerClientEvent("irp-pdm:successfulbuy", _source, name, vehicleProps.plate, price)
			TriggerClientEvent('irp-pdm:receiveInfo', _source, xPlayer.getMoney())   
			TriggerClientEvent('irp-pdm:spawnVehicle', _source, veh, vehicleProps.plate)
			discordLog("TELAH MEMBELI KENDARAAN DENGAN BANK\n\nHarga: " .. price ..  '\nModel Kendaraan: '.. veh .. '\nPlat: ' .. vehicleProps.plate,  'Nama IC: ' .. xPlayer.getName())
		end)
	else
		 TriggerClientEvent('rds_module:client:SendAlert', _source, { type = 'inform', text = 'Not Enough Money'})
	end
end)

RegisterServerEvent('ox-vehicleshop:setVehicleOwnedJob')
AddEventHandler('ox-vehicleshop:setVehicleOwnedJob', function (vehicleProps, vehname)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, stored, garage, vehicle) VALUES (@owner, @plate, @stored, @garage, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@stored'] = 1,
		['@garage'] = 'A',
		['@vehicle'] = json.encode(vehicleProps)
	}, function (rowsChanged)

		local metadata = {}
		metadata.type = vehname
		metadata.description = vehicleProps.plate

		
	end)
end)


function discordLog(name, message)
	
    local data = {
        {
			["title"]= "**".. name .."**",
            ["description"]= message,
            ["type"]= "rich",
            ["color"] = 16711680,
        }
    }
	
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end