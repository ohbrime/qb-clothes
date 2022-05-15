local QBCore = exports['qb-core']:GetCoreObject()
local allMyOutfits = {}
local HasMoney = false

-- Function

local function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end

-- Events

RegisterNetEvent('qb-clothes:client:CreateFirstCharacter', function()  -- Event renamed so you dont need to change anything for this to work... hopefully....
	QBCore.Functions.GetPlayerData(function(PlayerData)
		local skin = 'mp_m_freemode_01'
		if PlayerData.charinfo.gender == 1 then
            skin = "mp_f_freemode_01" 
        end
		exports['qb-clothes']:setPlayerModel(skin)
		local config = {
			ped = true,
			headBlend = true,
			faceFeatures = true,
			headOverlays = true,
			components = true,
			props = true,
		}
		exports['qb-clothes']:setPlayerAppearance(appearance)
		exports['qb-clothes']:startPlayerCustomization(function(appearance)
			if (appearance) then
				TriggerServerEvent('qb-clothes:firstSave', appearance)
				--print('Player Clothing Saved')
			else
                TriggerServerEvent('qb-clothes:firstSave', appearance)
				--print('Canceled')
			end
		end, config)
	end)
end, false)

RegisterNetEvent('qb-clothes:clothingShop', function()
	exports['qb-menu']:openMenu({
        {
            header = "Clothing Store",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "Buy Clothing",
			txt = "Pick from a wide range of items to wear",
            params = {
                event = "qb-clothes:clothingMenu",
            }
        },
		{
            header = "Change Outfit",
			txt = "Pick from any of your currently saved outfits",
            params = {
                event = "qb-clothes:pickNewOutfit",
                args = {
                    number = 1,
                    id = 2
                }
            }
        },
		{
            header = "Save New Outfit",
			txt = "Save a new outfit you can use later on",
            params = {
                event = "qb-clothes:saveOutfit",
            }
        },
		{
            header = "Delete Outfit",
			txt = "Yeah... We didnt like that one either",
            params = {
                event = "qb-clothes:deleteOutfitMenu",
                args = {
                    number = 1,
                    id = 2
                }
            }
        },
    })
end)

RegisterNetEvent('qb-clothes:pickNewOutfit', function(data)
    local id = data.id
    local number = data.number
	TriggerEvent('qb-clothes:getOutfits')
	Wait(150)
	local outfitMenu = {
        {
            header = '< Go Back',
            params = {
                event = 'qb-clothes:clothingShop'
            }
        }
    }
    for i=1, #allMyOutfits, 1 do
        outfitMenu[#outfitMenu + 1] = {
            header = allMyOutfits[i].name,
            params = {
                event = 'qb-clothes:setOutfit',
                args = {
					-- number = (1 + i),
					ped = allMyOutfits[i].pedModel, 
					components = allMyOutfits[i].pedComponents, 
					props = allMyOutfits[i].pedProps
				}
            }
        }
    end
    exports['qb-menu']:openMenu(outfitMenu)
end)

RegisterNetEvent('qb-clothes:getOutfits', function()
	TriggerServerEvent('qb-clothes:getOutfits')
end)

RegisterNetEvent('qb-clothes:sendOutfits', function(myOutfits)
	local Outfits = {}
	for i=1, #myOutfits, 1 do
		table.insert(Outfits, {id = myOutfits[i].id, name = myOutfits[i].name, pedModel = myOutfits[i].ped, pedComponents = myOutfits[i].components, pedProps = myOutfits[i].props})
	end
	allMyOutfits = Outfits
end)

RegisterNetEvent('qb-clothes:setOutfit', function(data)
	local pedModel = data.ped
	local pedComponents = data.components
	local pedProps = data.props
	local playerPed = PlayerPedId()
	local currentPedModel = exports['qb-clothes']:getPedModel(playerPed)
	if currentPedModel ~= pedModel then
    	exports['qb-clothes']:setPlayerModel(pedModel)
		Wait(500)
		playerPed = PlayerPedId()
		exports['qb-clothes']:setPedComponents(playerPed, pedComponents)
		exports['qb-clothes']:setPedProps(playerPed, pedProps)
		local appearance = exports['qb-clothes']:getPedAppearance(playerPed)
		TriggerServerEvent('qb-clothes:save', appearance)
	else
		exports['qb-clothes']:setPedComponents(playerPed, pedComponents)
		exports['qb-clothes']:setPedProps(playerPed, pedProps)
		local appearance = exports['qb-clothes']:getPedAppearance(playerPed)
		TriggerServerEvent('qb-clothes:save', appearance)
	end
	-- TriggerEvent('qb-clothes:clothingShop')
end)

RegisterNetEvent('qb-clothes:saveOutfit', function()
	local keyboard = exports['qb-input']:ShowInput({
        header = "Name your outfit",
        submitText = "Create Outfit",
        inputs = {
            {
                text = "Outfit Name",
                name = "input",
                type = "text",
                isRequired = true
            },
        },
    })

	if keyboard ~= nil then
		local playerPed = PlayerPedId()
		local pedModel = exports['qb-clothes']:getPedModel(playerPed)
		local pedComponents = exports['qb-clothes']:getPedComponents(playerPed)
		local pedProps = exports['qb-clothes']:getPedProps(playerPed)
		Wait(500)
		TriggerServerEvent('qb-clothes:saveOutfit', keyboard.input, pedModel, pedComponents, pedProps)
		QBCore.Functions.Notify('Outfit '..keyboard.input.. ' salvato!', 'success')
	end
end)

RegisterNetEvent('qb-clothes:deleteOutfitMenu', function(data)
    local id = data.id
    local number = data.number
	TriggerEvent('qb-clothes:getOutfits')
	Wait(150)
	local DeleteMenu = {
        {
            header = '< Go Back',
            params = {
                event = 'qb-clothes:clothingShop'
            }
        }
    }
    for i=1, #allMyOutfits, 1 do
        DeleteMenu[#DeleteMenu + 1] = {
            header = 'Delete "'..allMyOutfits[i].name..'"',
			txt = 'You will never be able to get this back!',
            params = {
				event = 'qb-clothes:deleteOutfit',
				args = allMyOutfits[i].id
			}
        }
    end
    exports['qb-menu']:openMenu(DeleteMenu)
end)

RegisterNetEvent('qb-clothes:deleteOutfit', function(id)
	TriggerServerEvent('qb-clothes:deleteOutfit', id)
	-- TriggerEvent('qb-clothes:clothingShop')
	QBCore.Functions.Notify('Outfit Eliminato', 'error')
end)

RegisterNetEvent("qb-clothes:HasMoney", function()
    HasMoney = true
end)

RegisterNetEvent("qb-clothes:HasNoMoney", function()
    HasMoney = false
end)

RegisterNetEvent('qb-clothes:clothingMenu', function()
	TriggerServerEvent('qb-clothes:access')
	Wait(100)
	if HasMoney then
		local config = {
			ped = false,
			headBlend = false,
			faceFeatures = false,
			headOverlays = false,
			components = true,
			props = true
		}
		
		exports['qb-clothes']:startPlayerCustomization(function(appearance)
			if appearance then
				TriggerServerEvent('qb-clothes:save', appearance)
                TriggerServerEvent('qb-clothes:pay')
				--print('Player Clothing Saved')
                Wait(1000) -- Wait is needed to clothing menu dosent overwrite the tattoos
				TriggerServerEvent('Select:Tattoos')
			else
				--print('Canceled')
                Wait(1000) -- Wait is needed to clothing menu dosent overwrite the tattoos
				TriggerServerEvent('Select:Tattoos')
			end
		end, config)
	end
end)

RegisterNetEvent('qb-clothes:barberMenu', function()
    TriggerServerEvent('qb-clothes:access')
	Wait(100)
	if HasMoney then
        local config = {
            ped = false,
            headBlend = false,
            faceFeatures = false,
            headOverlays = true,
            components = false,
            props = false
        }

        exports['qb-clothes']:startPlayerCustomization(function (appearance)
            if appearance then
                TriggerServerEvent('qb-clothes:save', appearance)
                TriggerServerEvent('qb-clothes:pay')
                --print('Player Clothing Saved')
                Wait(1000) -- Wait is needed to clothing menu dosent overwrite the tattoos
                TriggerServerEvent('Select:Tattoos')
            else
                --print('Canceled')
                Wait(1000) -- Wait is needed to clothing menu dosent overwrite the tattoos
                TriggerServerEvent('Select:Tattoos')
            end
        end, config)
    end
end)

-- Backwords Events so you dont need to replace these

RegisterNetEvent('qb-clothing:client:openMenu', function()  -- Admin Menu clothing event
	Wait(500)
	local config = {
		ped = true,
		headBlend = true,
		faceFeatures = true,
		headOverlays = true,
		components = true,
		props = true
	}
	
	exports['qb-clothes']:startPlayerCustomization(function(appearance)
		if appearance then
			TriggerServerEvent('qb-clothes:save', appearance)
			--print('Player Clothing Saved')
            Wait(1000) -- Wait is needed to clothing menu dosent overwrite the tattoos
			TriggerServerEvent('Select:Tattoos')
		else
			--print('Canceled')
            Wait(1000) -- Wait is needed to clothing menu dosent overwrite the tattoos
			TriggerServerEvent('Select:Tattoos')
		end
	end, config)
end)

RegisterNetEvent('qb-clothing:client:openOutfitMenu', function()  -- Name is so that you dont have to replace the event, Used in Appartments, Bossmenu, etc...
	exports['qb-menu']:openMenu({
        {
            header = "Outfit Options",
            isMenuHeader = true,
        },
		{
            header = "Change Outfit",
			txt = "Pick from any of your currently saved outfits",
            params = {
                event = "qb-clothes:pickNewOutfitApp",
                args = {
                    number = 1,
                    id = 2
                }
            }
        },
		{
            header = "Save New Outfit",
			txt = "Save a new outfit you can use later on",
            params = {
                event = "qb-clothes:saveOutfit",
            }
        },
    })
end)

RegisterNetEvent('qb-clothing:client:openWardrobe', function(data)  -- Name is so that you dont have to replace the event, Used in Appartments, Bossmenu, etc...
	exports['qb-menu']:openMenu({
        {
            header = "Outfit Menu",
            isMenuHeader = true,
        },
        {
            header = "Buy Clothing",
			txt = "Pick from a wide range of items to wear",
            params = {
                event = "qb-clothes:clothingMenu",
            }
        },
		{
            header = "Change Outfit",
			txt = "Pick from any of your currently saved outfits",
            params = {
                event = "qb-clothes:pickNewOutfitWork",
                args = data
            }
        },
		{
            header = "Wardrobe",
			txt = "Select a predefined outfit from the wardrobe",
            params = {
                event = "qb-clothes:pickDefOutfitApp",
                args = data,
            }
        },
    })
end)

RegisterNetEvent('qb-clothes:pickDefOutfitApp', function(data)
	Wait(150)
	local outfitDefMenu = {
        {
            header = '< Go Back',
            params = {
                event = 'qb-clothing:client:openWardrobe',
				args = data
            }
        }
    }
    for k, v in pairs(data) do
        outfitDefMenu[#outfitDefMenu + 1] = {
            header = v.outfitLabel,
            params = {
                event = 'qb-clothing:client:loadWorkOutfit',
                args = { cData = v, vData = data }
            }
        }
    end
    exports['qb-menu']:openMenu(outfitDefMenu)
end)

RegisterNetEvent('qb-clothes:pickNewOutfitWork', function(data)
	TriggerEvent('qb-clothes:getOutfits')
	Wait(150)
	local outfitMenu = {
        {
            header = '< Go Back',
            params = {
                event = 'qb-clothing:client:openWardrobe',
				args = data
            }
        }
    }
    for i=1, #allMyOutfits, 1 do
        outfitMenu[#outfitMenu + 1] = {
            header = allMyOutfits[i].name,
            params = {
                event = 'qb-clothes:setOutfit',
                args = {
					ped = allMyOutfits[i].pedModel, 
					components = allMyOutfits[i].pedComponents, 
					props = allMyOutfits[i].pedProps
				}
            }
        }
    end
    exports['qb-menu']:openMenu(outfitMenu)
end)

RegisterNetEvent('qb-clothes:pickNewOutfitApp', function(data)
    local id = data.id
    local number = data.number
	TriggerEvent('qb-clothes:getOutfits')
	Wait(150)
	local outfitMenu = {
        {
            header = '< Go Back',
            params = {
                event = 'qb-clothing:client:openOutfitMenu'
            }
        }
    }
    for i=1, #allMyOutfits, 1 do
        outfitMenu[#outfitMenu + 1] = {
            header = allMyOutfits[i].name,
            params = {
                event = 'qb-clothes:setOutfit',
                args = {
					-- number = (1 + i),
					ped = allMyOutfits[i].pedModel, 
					components = allMyOutfits[i].pedComponents, 
					props = allMyOutfits[i].pedProps
				}
            }
        }
    end
    exports['qb-menu']:openMenu(outfitMenu)
end)

RegisterNetEvent('qb-clothes:deleteOutfitMenuApp', function(data)
    local id = data.id
    local number = data.number
	TriggerEvent('qb-clothes:getOutfits')
	Wait(150)
	local DeleteMenu = {
        {
            header = '< Go Back',
            params = {
                event = 'qb-clothes:clothingShop'
            }
        }
    }
    for i=1, #allMyOutfits, 1 do
        DeleteMenu[#DeleteMenu + 1] = {
            header = 'Delete "'..allMyOutfits[i].name..'"',
			txt = 'You will never be able to get this back!',
            params = {
				event = 'qb-clothes:deleteOutfit',
				args = allMyOutfits[i].id
			}
        }
    end
    exports['qb-menu']:openMenu(DeleteMenu)
end)

-- Command(s)

RegisterCommand('reloadskin', function()
	QBCore.Functions.TriggerCallback('qb-clothes:getPlayerSkin', function(appearance)
		exports['qb-clothes']:setPlayerAppearance(appearance)
	end)
	for k, v in pairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(PlayerPedId(), v) then
            SetEntityAsMissionEntity(v, true, true)
            DeleteObject(v)
            DeleteEntity(v)
        end
    end
end)

-----ADDON

local skinData = {
    ["face"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["pants"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["hair"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["eyebrows"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["beard"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["blush"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["lipstick"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["makeup"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["ageing"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,        
    },
    ["arms"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["t-shirt"] = {
        item = 1,
        texture = 0,
        defaultItem = 1,
        defaultTexture = 0,        
    },
    ["torso2"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["vest"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["bag"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["shoes"] = {
        item = 0,
        texture = 0,
        defaultItem = 1,
        defaultTexture = 0,        
    },
    ["mask"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["hat"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0, 
    },
    ["glass"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,
    },
    ["ear"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,
    },
    ["watch"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,
    },
    ["bracelet"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,
    },
    ["accessory"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["decals"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["eye_color"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,      
    },
    ["moles"] = {
        item = 0,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,      
    },
    ["nose_0"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["nose_1"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["nose_2"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["nose_3"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },

    ["nose_4"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["nose_5"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["cheek_1"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["cheek_2"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["cheek_3"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["eye_opening"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["lips_thickness"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["jaw_bone_width"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["eyebrown_high"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["eyebrown_forward"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["jaw_bone_back_lenght"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["chimp_bone_lowering"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["chimp_bone_lenght"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["chimp_bone_width"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["chimp_hole"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["neck_thikness"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
} 

RegisterNetEvent('qb-clothes:client:reloadSkin', function()
	QBCore.Functions.TriggerCallback('qb-clothes:getPlayerSkin', function(appearance)
		exports['qb-clothes']:setPlayerAppearance(appearance)
	end)
	for k, v in pairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(PlayerPedId(), v) then
            SetEntityAsMissionEntity(v, true, true)
            DeleteObject(v)
            DeleteEntity(v)
        end
    end
end)

RegisterNetEvent('qb-clothing:client:loadOutfit', function(oData)
    local ped = PlayerPedId()

    data = oData.outfitData

    if typeof(data) ~= "table" then data = json.decode(data) end

    for k, v in pairs(data) do
        skinData[k].item = data[k].item
        skinData[k].texture = data[k].texture
    end

    -- Pants
    if data["pants"] ~= nil then
        SetPedComponentVariation(ped, 4, data["pants"].item, data["pants"].texture, 0)
    end

    -- Arms
    if data["arms"] ~= nil then
        SetPedComponentVariation(ped, 3, data["arms"].item, data["arms"].texture, 0)
    end

    -- T-Shirt
    if data["t-shirt"] ~= nil then
        SetPedComponentVariation(ped, 8, data["t-shirt"].item, data["t-shirt"].texture, 0)
    end

    -- Vest
    if data["vest"] ~= nil then
        SetPedComponentVariation(ped, 9, data["vest"].item, data["vest"].texture, 0)
    end

    -- Torso 2
    if data["torso2"] ~= nil then
        SetPedComponentVariation(ped, 11, data["torso2"].item, data["torso2"].texture, 0)
    end

    -- Shoes
    if data["shoes"] ~= nil then
        SetPedComponentVariation(ped, 6, data["shoes"].item, data["shoes"].texture, 0)
    end

    -- Bag
    if data["bag"] ~= nil then
        SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)
    end

    -- Badge
    if data["badge"] ~= nil then
        SetPedComponentVariation(ped, 10, data["decals"].item, data["decals"].texture, 0)
    end

    -- Accessory
    if data["accessory"] ~= nil then
        if QBCore.Functions.GetPlayerData().metadata["tracker"] then
            SetPedComponentVariation(ped, 7, 13, 0, 0)
        else
            SetPedComponentVariation(ped, 7, data["accessory"].item, data["accessory"].texture, 0)
        end
    else
        if QBCore.Functions.GetPlayerData().metadata["tracker"] then
            SetPedComponentVariation(ped, 7, 13, 0, 0)
        else
            SetPedComponentVariation(ped, 7, -1, 0, 2)
        end
    end

    -- Mask
    if data["mask"] ~= nil then
        SetPedComponentVariation(ped, 1, data["mask"].item, data["mask"].texture, 0)
    end

    -- Bag
    if data["bag"] ~= nil then
        SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)
    end

    -- Hat
    if data["hat"] ~= nil then
        if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
            SetPedPropIndex(ped, 0, data["hat"].item, data["hat"].texture, true)
        else
            ClearPedProp(ped, 0)
        end
    end

    -- Glass
    if data["glass"] ~= nil then
        if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
            SetPedPropIndex(ped, 1, data["glass"].item, data["glass"].texture, true)
        else
            ClearPedProp(ped, 1)
        end
    end

    -- Ear
    if data["ear"] ~= nil then
        if data["ear"].item ~= -1 and data["ear"].item ~= 0 then
            SetPedPropIndex(ped, 2, data["ear"].item, data["ear"].texture, true)
        else
            ClearPedProp(ped, 2)
        end
    end
end)

RegisterNetEvent('qb-clothing:client:loadWorkOutfit', function(cData)
    local ped = PlayerPedId()
	local oData = cData.cData
    data = oData.outfitData

    if typeof(data) ~= "table" then data = json.decode(data) end

    for k, v in pairs(data) do
        skinData[k].item = data[k].item
        skinData[k].texture = data[k].texture
    end

    -- Pants
    if data["pants"] ~= nil then
        SetPedComponentVariation(ped, 4, data["pants"].item, data["pants"].texture, 0)
    end

    -- Arms
    if data["arms"] ~= nil then
        SetPedComponentVariation(ped, 3, data["arms"].item, data["arms"].texture, 0)
    end

    -- T-Shirt
    if data["t-shirt"] ~= nil then
        SetPedComponentVariation(ped, 8, data["t-shirt"].item, data["t-shirt"].texture, 0)
    end

    -- Vest
    if data["vest"] ~= nil then
        SetPedComponentVariation(ped, 9, data["vest"].item, data["vest"].texture, 0)
    end

    -- Torso 2
    if data["torso2"] ~= nil then
        SetPedComponentVariation(ped, 11, data["torso2"].item, data["torso2"].texture, 0)
    end

    -- Shoes
    if data["shoes"] ~= nil then
        SetPedComponentVariation(ped, 6, data["shoes"].item, data["shoes"].texture, 0)
    end

    -- Bag
    if data["bag"] ~= nil then
        SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)
    end

    -- Badge
    if data["badge"] ~= nil then
        SetPedComponentVariation(ped, 10, data["decals"].item, data["decals"].texture, 0)
    end

    -- Accessory
    if data["accessory"] ~= nil then
        if QBCore.Functions.GetPlayerData().metadata["tracker"] then
            SetPedComponentVariation(ped, 7, 13, 0, 0)
        else
            SetPedComponentVariation(ped, 7, data["accessory"].item, data["accessory"].texture, 0)
        end
    else
        if QBCore.Functions.GetPlayerData().metadata["tracker"] then
            SetPedComponentVariation(ped, 7, 13, 0, 0)
        else
            SetPedComponentVariation(ped, 7, -1, 0, 2)
        end
    end

    -- Mask
    if data["mask"] ~= nil then
        SetPedComponentVariation(ped, 1, data["mask"].item, data["mask"].texture, 0)
    end

    -- Bag
    if data["bag"] ~= nil then
        SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)
    end

    -- Hat
    if data["hat"] ~= nil then
        if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
            SetPedPropIndex(ped, 0, data["hat"].item, data["hat"].texture, true)
        else
            ClearPedProp(ped, 0)
        end
    end

    -- Glass
    if data["glass"] ~= nil then
        if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
            SetPedPropIndex(ped, 1, data["glass"].item, data["glass"].texture, true)
        else
            ClearPedProp(ped, 1)
        end
    end

    -- Ear
    if data["ear"] ~= nil then
        if data["ear"].item ~= -1 and data["ear"].item ~= 0 then
            SetPedPropIndex(ped, 2, data["ear"].item, data["ear"].texture, true)
        else
            ClearPedProp(ped, 2)
        end
    end
	TriggerEvent("qb-clothes:pickDefOutfitApp", cData.vData)
end)
