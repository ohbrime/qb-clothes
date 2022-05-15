local QBCore = exports['qb-core']:GetCoreObject()

-- Callback

QBCore.Functions.CreateCallback('qb-clothes:getPlayerSkin', function(source, cb)
	local Player = QBCore.Functions.GetPlayer(source)
	local players = MySQL.Sync.fetchAll('SELECT skin FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid})
	local player, appearance = players[1]
	if player.skin then
		appearance = json.decode(player.skin)
	end
	cb(appearance)
end)

-- Events

RegisterNetEvent('qb-clothes:firstSave', function(appearance)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	SetPlayerRoutingBucket(src, 0)
	MySQL.query('UPDATE players SET skin = ? WHERE citizenid = ?', {json.encode(appearance), Player.PlayerData.citizenid})
end)
 
RegisterNetEvent('qb-clothes:save', function(appearance)
	local Player = QBCore.Functions.GetPlayer(source)
	MySQL.query('UPDATE players SET skin = ? WHERE citizenid = ?', {json.encode(appearance), Player.PlayerData.citizenid})
end)

RegisterNetEvent('qb-clothes:saveOutfit', function(name, pedModel, pedComponents, pedProps)
	local Player = QBCore.Functions.GetPlayer(source)
	MySQL.insert('INSERT INTO `player_outfits` (citizenid, name, ped, components, props) VALUES (?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, name, json.encode(pedModel), json.encode(pedComponents), json.encode(pedProps)})
end)

RegisterNetEvent('qb-clothes:getOutfit', function(name)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local outfit = MySQL.Sync.fetchAll('SELECT outfit FROM player_outfits WHERE citizenid = @citizenid AND name = @name', {['@citizenid'] = Player.PlayerData.citizenid, ['@name'] = name})
	local newOutfit = outfit
	if newOutfit then
		newOutfit = json.decode(newOutfit)
		TriggerClientEvent('qb-clothes:setOutfit', src, newOutfit)
	end
end)

RegisterNetEvent('qb-clothes:getOutfits', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local myOutfits = {}
	local result = MySQL.Sync.fetchAll('SELECT id, name, ped, components, props FROM player_outfits WHERE citizenid = ?', {Player.PlayerData.citizenid})
	for i=1, #result, 1 do
		table.insert(myOutfits, {id = result[i].id, name = result[i].name, ped = json.decode(result[i].ped), components = json.decode(result[i].components), props = json.decode(result[i].props)})
	end
	TriggerClientEvent('qb-clothes:sendOutfits', src, myOutfits)
end)

RegisterNetEvent('qb-clothes:deleteOutfit', function(id)
	local Player = QBCore.Functions.GetPlayer(source)
	MySQL.query('DELETE FROM player_outfits WHERE id = ?', {id})
end)

RegisterNetEvent('qb-clothes:pay', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	Player.Functions.RemoveMoney('cash', Config.Money, "clothing-buy")
end)

RegisterNetEvent('qb-clothes:access', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	if Player.PlayerData.money.cash > Config.MinMoney then
		TriggerClientEvent('qb-clothes:HasMoney', src)
	else
		TriggerClientEvent('QBCore:Notify', src, 'You dont have enough money!', 'error')
		TriggerClientEvent('qb-clothes:HasNoMoney', src)
	end
end)

-- ADDON

RegisterNetEvent('qb-clothes:loadPlayerSkin', function()
	local src = source
	TriggerClientEvent('qb-clothes:client:reloadSkin', src)
end)