local splittableItems = {[30]=" gram(s)", [31]=" gram(s)", [32]=" gram(s)", [33]=" gram(s)", [34]=" gram(s)", [35]=" ml(s)", [36]=" tablet(s)", [37]=" gram(s)", [38]=" gram(s)", [39]=" gram(s)", [40]=" ml(s)", [41]=" tab(s)", [42]=" shroom(s)", [43]=" tablet(s)", [134] = " money"}

function resetFrame(player, itemID, itemValue)
	if exports.cr_global:takeItem(player, itemID, itemValue) and exports.cr_global:giveItem(player, 147, 1) then
		outputChatBox("[!]#FFFFFF Texture bilgileri biçimlendirildi.", player, 0, 255, 0, true)
	end
end
addEvent("resetFrame", true)
addEventHandler("resetFrame", getRootElement(), resetFrame)

function splitItem(player, cmd, itemID, amount)
	local itemID = tonumber(itemID)
	local amount = tonumber(amount)
	if itemID and amount then
		if (itemID%1 ~= 0) or (amount%1 ~= 0) then
			outputChatBox("[!]#FFFFFF Item ID ve Miktar tam sayı olmalıdır.", player, 255, 0, 0, true)
			return false
		end
		if itemID > 0 and splittableItems[itemID] then
			local isPlayerHasItem, itemSlot, itemValue, noIdeaWhatItis = exports.cr_global:hasItem(player, itemID)
			if isPlayerHasItem then
				local itemValue2 = tonumber((tostring(itemValue):match("%d+")))
				if not itemValue2 then
					outputChatBox("[!]#FFFFFF Bir sorun oluştu.", player, 255, 0, 0, true)
					return false
				end
				if amount > 0 then
					if amount <= itemValue2 then
						if amount == itemValue2 then
							return false
						end
						local itemRemaining = itemValue2 - amount
						
						if exports.cr_global:takeItem(player, itemID, itemValue) and giveItem(player, itemID, amount, false , true) and giveItem(player, itemID, itemRemaining,false ,true) then
							return true
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", player, 255, 0, 0, true)
							return false
						end
					else
						outputChatBox("[!]#FFFFFF Tutar, envanterinizde bulunandan daha yüksek olamaz.", player, 255, 0, 0, true)
					end
				else
					outputChatBox("[!]#FFFFFF Tutar sıfırın üzerinde olmalıdır.", player, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Envanterinizde böyle bir item yok.", player, 255, 0, 0, true)
			end
		else
			outputChatBox("[!]#FFFFFF ID '" .. itemID .. "' ayrılabilir bir item değil.", player, 255, 0, 0, true)
		end
	else
		outputChatBox("KULLANIM: /" .. cmd .. " [Item ID] [Miktar]", player, 255, 194, 14)
		outputChatBox("[!]#FFFFFF Bölünebilir öğelerin listesi için '/splits' yazın.", player, 0, 0, 255, true)
	end
end
addCommandHandler("split", splitItem, false, false)
addEvent("drugsystem:splitItem", true)
addEventHandler("drugsystem:splitItem", getRootElement(), splitItem)

function listSplittable(thePlayer, commandName)
	outputChatBox("[!]#FFFFFF Ayrılabilir itemler:", thePlayer, 0, 0, 255, true)
	for itemID = 1, 150 do
		local itemName = false
		itemName = getItemName(itemID)
		if itemName and splittableItems[itemID] then
			outputChatBox(">>#FFFFFF ID " .. tostring(itemID) .. " - " .. itemName .. ".", thePlayer, 0, 255, 0, true)
		end
	end
end
addCommandHandler("splits", listSplittable, false, false)