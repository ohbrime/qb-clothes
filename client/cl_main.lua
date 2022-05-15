local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local PlayerJob = {}
local PlayerGang = {}
local CurrentAction = false

-- Events

AddEventHandler('onResourceStart', function(Resource)
    if Resource == GetCurrentResourceName() then
        Wait(200)
        PlayerData = QBCore.Functions.GetPlayerData()
		PlayerGang = PlayerData.gang
		PlayerJob = PlayerData.job
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('qb-clothes:getPlayerSkin', function(appearance)
		exports['qb-clothes']:setPlayerAppearance(appearance)
		PlayerData = QBCore.Functions.GetPlayerData()
		PlayerGang = PlayerData.gang
		PlayerJob = PlayerData.job
		if Config.Debug then 
			Wait(10000)
			if GetEntityModel(PlayerPedId()) == `player_zero` then
				TriggerEvent('qb-clothes:client:CreateFirstCharacter')
			end
		end
	end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(InfoGang)
    PlayerGang = InfoGang
end)

-- Threads

CreateThread(function()
	for k, v in pairs(Config.Locations["clothing"]) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite (blip, 366)
		SetBlipScale (blip, 0.6)
		SetBlipColour (blip, 47)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Clothing Store')
		EndTextCommandSetBlipName(blip)
	end

	for k,v in ipairs(Config.Locations["barber"]) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite (blip, 71)
		SetBlipColour (blip, 62)
		SetBlipScale (blip, 0.6)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Barber Shop')
		EndTextCommandSetBlipName(blip)
	end
end)

CreateThread(function()
	for k,v in ipairs(Config.Locations["clothing"]) do
		local boxZone = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 5, 5, {
            name = "clothing"..k,
            debugPoly = Config.PolyDebug,
			heading = v.w,
            minZ = v.z - 2,
            maxZ = v.z + 2,
        })
        boxZone:onPlayerInOut(function(isPointInside)
            if isPointInside then
				CurrentAction = 'clothingMenu'
                exports['qb-base']:DrawText('[E] Clothing', 'left')
            else
				CurrentAction = nil
                exports['qb-base']:HideText()
            end
			isClothingZone = isPointInside
        end)
    end
end)

CreateThread(function()
	for k,v in ipairs(Config.Locations["barber"]) do
		local boxZone = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 4, 4, {
            name="barber"..k,
            debugPoly = Config.PolyDebug,
			heading = v.w,
            minZ = v.z - 2,
            maxZ = v.z + 2,
        })
        boxZone:onPlayerInOut(function(isPointInside)
            if isPointInside then
				CurrentAction = 'barberMenu'
                exports['qb-base']:DrawText('[E] Barber ($'..Config.Money..')', 'left')
            else
				CurrentAction = nil
                exports['qb-base']:HideText()
            end
        end)
    end
end)

CreateThread(function()
	for k,v in ipairs(Config.Locations["wardobe"]) do
		local boxZone = BoxZone:Create(vector3(vector3(v.x, v.y, v.z)), 4, 4, {
            name="wardobe"..k,
            debugPoly = Config.PolyDebug,
			heading = v.w,
            minZ = v.z - 2,
            maxZ = v.z + 2,
        })
        boxZone:onPlayerInOut(function(isPointInside)
			print(isPointInside)
            if isPointInside and PlayerJob.name == Config.Wardobe[k].name and Config.Wardobe[k].coords then
				CurrentAction = 'wardobeJobMenu'
                exports['qb-base']:DrawText('[E] Wardrobe', 'left')
			elseif isPointInside and PlayerGang.name == Config.Wardobe[k].name and Config.Wardobe[k].coords then
				CurrentAction = 'wardobeGangMenu'
                exports['qb-base']:DrawText('[E] Wardrobe', 'left')
            else
				CurrentAction = nil
                exports['qb-base']:HideText()
            end
        end)
    end
end)

CreateThread(function()
	while true do
		Wait(0)
		if CurrentAction ~= nil then
			if IsControlPressed(1, 38) then
				Wait(500)

				if CurrentAction == 'clothingMenu' then
					TriggerEvent("qb-clothes:clothingShop")
				end
				
				if CurrentAction == 'barberMenu' then
					TriggerEvent("qb-clothes:barberMenu")
				end

				if CurrentAction == 'wardobeJobMenu' then
					gender = "male"
					if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then 
						gender = "female" 
					end
					TriggerEvent("qb-clothing:client:openWardrobe", Config.Outfits[PlayerJob.name][gender])
				end

				if CurrentAction == 'wardobeGangMenu' then
					gender = "male"
					if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then 
						gender = "female" 
					end
					TriggerEvent("qb-clothing:client:openWardrobe", Config.Outfits[PlayerGang.name][gender])
				end
			end
		end
	end
end)
