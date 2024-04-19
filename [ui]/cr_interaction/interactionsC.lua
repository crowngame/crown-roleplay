Interaction.Interactions = {}

function addInteraction(type, model, name, image, executeFunction)
	if not Interaction.Interactions[type][model] then
		Interaction.Interactions[type][model] = {} 
	end
 
	table.insert(Interaction.Interactions[type][model], {name, image, executeFunction})
end

addCommandHandler("iptal", function()
	if getElementData(localPlayer, "degisdurum") then
		setElementData(localPlayer, "degisdurum", nil)
		outputChatBox("[!]#FFFFFF Başarıyla işlemin iptal edildi.", 0, 255, 0, true)
	else
		outputChatBox("[!]#FFFFFF Şu anda her hangi bir istekte bulunmamışsın.", 255, 0, 0, true)	
	end
end)

function getInteractions(element, durum)
	local interactions = {}
	local type = getElementType(element)
	local model = getElementModel(element)
	
	table.insert(interactions, {"Kapat", "icons/cross_x.png", function()
		Interaction.Close()
	end})
	
	if durum == "home" then
		if getElementData(localPlayer, "loggedin") ~= 1 then return end
			table.insert(interactions, {"OOC Market", "icons/tl.png", function()
				setTimer(function()
					executeCommandHandler("market")
				end, 500, 1)
			end})
			
			return interactions
		end
		
		if type == "ped" then
			table.insert(interactions, {"Konuş", "icons/detector.png", function(player, target)
				triggerEvent("npc:konus", localPlayer, element)
			end})
		elseif type == "player" then
			if getElementData(element, "kelepceli") then ------------------#############
				table.insert(interactions, {"Kelepçe Çıkar", "icons/delete.png",
					function (player, element)
						triggerServerEvent("serverGönderaq", localPlayer, "uncuff", element)
					end
				})
				table.insert(interactions, {"Üst Ara", "icons/eyemask.png",
					function (player, element)
						triggerServerEvent("serverGönderaq", localPlayer, "üstara", element)
					end
				})
			else
				table.insert(interactions, {"Kelepçele", "icons/add.png",
					function (player, element)
						triggerServerEvent("serverGönderaq", localPlayer, "cuff", element)
					end
				})
			end
		elseif type == "vehicle" then
		if getElementData(element, "carshop") then
			table.insert(interactions, {"Satın Al ($" .. exports.cr_global:formatMoney(getElementData(element,"carshop:cost")) .. ")","icons/trunk.png",
			function (player, target)
				triggerServerEvent("carshop:buyCar", element, "cash")
				
			end
		})
		else 

		table.insert(interactions, {"Araç Envanteri", "icons/trunk.png",
			function (player, target)
                    if not exports.cr_global:hasItem(player, 3,getElementData(element,'dbid')) then
                        outputChatBox("#ff0000[!]#FFFFFF Bu aracın envanterini açmak için anahtara ihtiyacınız var.", 255,255,2550,true)
                    else
                        triggerServerEvent("openFreakinInventory",player,element, 500, 500)
                    end
			end
		})

		table.insert(interactions, {"Kapı Kontrolü", "icons/doorcontrol.png",
			function (player, target)
				exports["cr_vehicle"]:fDoorControl(target)	
			end
		})
			

		table.insert(interactions, {"Aracın İçine Gir", "icons/stair1.png",
			function (player, target)
				triggerServerEvent("enterVehicleInterior", player, element)
	
			end
		})
        end


	    if exports['cr_items']:hasItem(element, 117) then
			table.insert(interactions, {"Rampa", "icons/ramp.png",
				function (player, target)
					exports["cr_vehicle"]:toggleRamp(target)
				end
			})
	    end

	    if exports['cr_items']:hasItem(localPlayer, 57) then
			table.insert(interactions, {"Benzin Doldur", "icons/fuel.png",
				function (player, target)
					exports["cr_vehicle"]:fillFuelTank(target)
				end
			})
	    end
        local leader = getElementData(localPlayer, "factionleader")
	    if tonumber(leader)==1 and getElementData(localPlayer, "faction") == 3 then
			table.insert(interactions, {"Aracı Ara", "icons/stretcher.png",
				function (player, target)
						triggerServerEvent("openFreakinInventory",player,element, 500, 500)
				end
			})
	    end

	    if (exports.cr_global:isStaffOnDuty(localPlayer) and exports.cr_integration:isPlayerManagement(localPlayer)) then
			table.insert(interactions, {"ADM: Respawn", "icons/adm.png",
				function (player, target)
						triggerServerEvent("vehicle-manager:respawn", player, element)
				end
			})
	    end

     	if (exports.cr_global:isStaffOnDuty(localPlayer) and exports.cr_integration:isPlayerAdministrator(localPlayer)) then
			table.insert(interactions, {"ADM: Texture", "icons/adm.png",
				function (player, target)
     				triggerEvent("item-texture:vehtex", player, target)
				end
			})
	    end	    


	    if (getElementModel(element) == 416) and getElementData(localPlayer, "faction") == 2 then
			table.insert(interactions, {"Sedye", "icons/stretcher.png",
				function (player, target)
					exports["cr_vehicle"]:fStretcher(target)
				end
			})
	    end

	elseif type == "object" then
		if getElementModel(element) == 2149 or getElementModel(element) == 2421 then
			table.insert(interactions, {"Yarramı Kemir Fatih", "icons/weed_red.png",
				function (player, target)
						Interaction.Close()
				end
			})
		end	
		if getElementData(element, "tohum:obje") then
			if (getElementData(element, "tohum:gram") or 0) <= 0 then
			table.insert(interactions, {"Şuanda Hasat Edilemez", "icons/weed_red.png",
				function (player, target)
						Interaction.Close()
				end
			})
			else
			table.insert(interactions, {"Hasat Et", "icons/weed.png",
				function (player, target)
						triggerServerEvent("tohum:hasat", player, element)
				end
			})
			end
		end
		if getElementData(element, "uyusturucu:obje") then
			local tempActions4 = exports.cr_uyusturucu:getCurrentInteractionList(model)

			for k,v in pairs(tempActions4) do
				table.insert(interactions, v)
			end

			tempActions4 = nil
		end
		if getElementData(element, "isFactoryObject") then
			local tempActions3 = exports.cr_storekeeper:getCurrentInteractionList(model)

			for k,v in pairs(tempActions3) do
				table.insert(interactions, v)
			end

			tempActions3 = nil
		end
		if getElementData(element, "poolTableId") then
			local tempActionsanan = exports.cr_billiard:getCurrentInteractionList()

			for k,v in pairs(tempActionsanan) do
				table.insert(interactions, v)
			end

			tempActionsanan = nil
		
		end
		if getElementData(element, "kenevir:obje") then
			local tempActions5 = exports.cr_hemp:getCurrentInteractionList(model)

			for k,v in pairs(tempActions5) do
				table.insert(interactions, v)
			end

			tempActions5 = nil
		end
		if getElementData(element, "odin:obje") then
			local tempActions5 = exports.cr_bitki:getCurrentInteractionList(model)

			for k,v in pairs(tempActions5) do
				table.insert(interactions, v)
			end

			tempActions5 = nil
		end
		if getElementData(element, "isFuelPump") then
			local tempActions = exports["cr_vehicle-fuel"]:getCurrentInteractionList(model)

			for k,v in pairs(tempActions) do
				table.insert(interactions, v)
			end

			tempActions = nil
		
		end
	end

	return interactions
end


function isFriendOf(accountID)
	for _, data in ipairs({online, offline}) do
		for k, v in ipairs(data) do
			if v.accountID == accountID then
				return true
			end
		end
	end
	return false
end