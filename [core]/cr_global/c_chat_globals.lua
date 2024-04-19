function findPlayerByPartialNick(thePlayer, partialNick, fromBankSystem)
	if not partialNick and not isElement(thePlayer) and type(thePlayer) == "string" then
		outputDebugString("Incorrect Parameters in findPlayerByPartialNick")
		partialNick = thePlayer
		thePlayer = nil
	end
	local candidates = {}
	local matchPlayer = nil
	local matchNick = nil
	local matchNickAccuracy = -1
	
	if type(partialNick) == "string" then
		partialNick = string.lower(partialNick)
	elseif isElement(partialNick) and getElementType(partialNick) == "player" then
		return partialNick, getPlayerName(partialNick):gsub("_", " ")
	end

	if thePlayer and partialNick == "*" then
		return thePlayer, getPlayerName(thePlayer):gsub("_", " ")
	elseif type(partialNick) == "string" and getPlayerFromName(partialNick) then
		return getPlayerFromName(partialNick), getPlayerName(getPlayerFromName(partialNick)):gsub("_", " ")
	elseif tonumber(partialNick) then
		matchPlayer = nil
		for i, player in pairs(getElementsByType("player")) do
			if getElementData(player, "playerid") == tonumber(partialNick) then
				matchPlayer = player
				break
			end
		end
		candidates = { matchPlayer }
	else
		local players = getElementsByType("player")
		for playerKey, arrayPlayer in ipairs(players) do
			if isElement(arrayPlayer) then
				local found = false
				local playerName = string.lower(getPlayerName(arrayPlayer))
				local posStart, posEnd = string.find(playerName, tostring(partialNick), 1, true)
				if not posStart and not posEnd then
					posStart, posEnd = string.find(playerName:gsub(" ", "_"), tostring(partialNick), 1, true)
				end

				if posStart and posEnd then
					if posEnd - posStart > matchNickAccuracy then
						matchNickAccuracy = posEnd-posStart
						matchNick = playerName
						matchPlayer = arrayPlayer
						candidates = { arrayPlayer }
					elseif posEnd - posStart == matchNickAccuracy then
						matchNick = nil
						matchPlayer = nil
						table.insert(candidates, arrayPlayer)
					end
				end
			end
		end
	end
	
	if not matchPlayer or not isElement(matchPlayer) then
		if isElement(thePlayer) then
			if #candidates == 0 then
				if not fromBankSystem then
					outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", 255, 0, 0, true)
					playSoundFrontEnd(4)
				end
			else
				outputChatBox("[!]#FFFFFF Toplam " .. #candidates .. " oyuncu eşleşiyor:", 0, 0, 255, true)
				for _, arrayPlayer in ipairs(candidates) do
					outputChatBox(">>#FFFFFF (" .. tostring(getElementData(arrayPlayer, "playerid")) .. ") " .. getPlayerName(arrayPlayer), 0, 255, 0, true)
				end
			end
		end
		return false
	else
		return matchPlayer, getPlayerName(matchPlayer):gsub("_", " ")
	end
end