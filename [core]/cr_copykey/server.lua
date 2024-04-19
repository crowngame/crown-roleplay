local mysql = exports.cr_mysql
local colSphere = createColSphere(-2033.4345703125, -117.6171875, 1035.171875, 3)

addCommandHandler("anahtarcikart", function(thePlayer, commandName, argument, id)
	if isElementWithinColShape(thePlayer, colSphere) then
		if not argument or not tonumber(id) then 
			outputChatBox("KULLANIM: /" .. commandName .. " [ev / arac] [ID]", thePlayer, 255, 194, 14) 
			return
		end
		
		if argument == "ev" then
			for _, value in ipairs(getElementsByType("interior")) do
				local owner = tonumber(getElementData(value, "status")[4])
				if tonumber(id)  == tonumber(value:getData("dbid")) then
					if (owner) and owner == tonumber(thePlayer:getData("dbid")) then
						local name = getElementData(value, "name")
						if not exports.cr_global:hasSpaceForItem(thePlayer, 4, 1) then
							outputChatBox("[!]#FFFFFF Envanterinizde anahtar için yeterli colSphere bulunmamaktadır!", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							return
						end	
						
						if not exports.cr_global:takeMoney(thePlayer, 500) then
							outputChatBox("[!]#FFFFFF Yeterli miktarda paranız yok.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							return
						end
						
						exports.cr_global:giveItem(thePlayer, 4, id)
						outputChatBox("[!]#FFFFFF [" .. name .. "] adlı mülkünüzün anahtarını kopyaladınız.", thePlayer, 100, 100, 255, true)
					else
						outputChatBox("[!]#FFFFFF Bu mülkün sahibi değilsiniz.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			end
		elseif argument == "arac" then
			for _, value in ipairs(getElementsByType("vehicle")) do
				if tonumber(id) == tonumber(value:getData("dbid")) then
					if thePlayer:getData("dbid") == value:getData("owner") then
						if not exports.cr_global:hasSpaceForItem(thePlayer, 3, 1) then
							outputChatBox("[!]#FFFFFF Envanterinizde anahtar için yeterli colSphere bulunmamaktadır!", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							return
						end	
						
						if not exports.cr_global:takeMoney(thePlayer, 500) then
							outputChatBox("[!]#FFFFFF Yeterli miktarda paranız yok.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							return
						end
						
						exports.cr_global:giveItem(thePlayer, 3, id)
						outputChatBox("[!]#FFFFFF [" .. tonumber(id) .. "] ID'li aracın anahtarını kopyaladınız.", thePlayer, 100, 100, 255, true)
					else
						outputChatBox("[!]#FFFFFF Bu aracın sahibi değilsiniz.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			end
		end
	end
end)