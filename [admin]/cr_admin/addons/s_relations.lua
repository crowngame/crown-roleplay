function marry(thePlayer, commandName, player1, player2)
	if exports.cr_integration:isPlayerGameAdmin(thePlayer) then
		if not player1 or not player2 then
			outputChatBox("KULLANIM: /" .. commandName .. " [player] [player]", thePlayer, 255, 194, 14)
		else
			local player1, player1name = exports.cr_global:findPlayerByPartialNick(thePlayer, player1)
			if player1 then
				local player2, player2name = exports.cr_global:findPlayerByPartialNick(thePlayer, player2)
				if player2 then
					-- check if one of the players is already married
					local p1r = mysql:query_fetch_assoc("SELECT COUNT(*) as numbr FROM characters WHERE marriedto = " .. mysql:escape_string(getElementData(player1, "dbid")))
					if p1r then
						if tonumber(p1r["numbr"]) == 0 then
							local p2r = mysql:query_fetch_assoc("SELECT COUNT(*) as numbr FROM characters WHERE marriedto = " .. mysql:escape_string(getElementData(player2, "dbid")))
							if p2r then
								if tonumber(p2r["numbr"]) == 0 then
									dbExec(mysql:getConnection(),"UPDATE characters SET marriedto = " .. mysql:escape_string(getElementData(player1, "dbid")) .. " WHERE id = " .. mysql:escape_string(getElementData(player2, "dbid")))
									dbExec(mysql:getConnection(),"UPDATE characters SET marriedto = " .. mysql:escape_string(getElementData(player2, "dbid")) .. " WHERE id = " .. mysql:escape_string(getElementData(player1, "dbid"))) 
									
									outputChatBox("[!]#FFFFFF " .. player2name .. " adlı kişiyle evlendirildiniz.", player1, 255, 0, 0, true)
									outputChatBox("[!]#FFFFFF " .. player1name .. " adlı kişiyle evlendirildiniz.", player2, 255, 0, 0, true)
									
									exports['cr_cache']:clearCharacterName(getElementData(player1, "dbid"))
									exports['cr_cache']:clearCharacterName(getElementData(player2, "dbid"))
									
									outputChatBox("[!]#FFFFFF " .. player1name .. " ve " .. player2name .. " şunanda evlendirildi.", thePlayer, 255, 0, 0, true)
								else
									outputChatBox("[!]#FFFFFF " .. player2name .. " zaten evli.", thePlayer, 255, 0, 0, true)
								end
							end
						else
							outputChatBox("[!]#FFFFFF " .. player1name .. " zaten evli.", thePlayer, 255, 0, 0, true)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("marry", marry)

function divorce(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerGameAdmin(thePlayer) then
		if not targetPlayer then
			outputChatBox("KULLANIM: /" .. commandName .. " [player]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local marriedto = mysql:query_fetch_assoc("SELECT marriedto FROM characters WHERE id = " .. mysql:escape_string(getElementData(targetPlayer, "dbid")))
				if marriedto then
					local to = tonumber(marriedto["marriedto"])
					if to > 0 then
						dbExec(mysql:getConnection(),"UPDATE characters SET marriedto = 0 WHERE id = " .. mysql:escape_string(getElementData(targetPlayer, "dbid")))
						dbExec(mysql:getConnection(),"UPDATE characters SET marriedto = 0 WHERE marriedto = " .. mysql:escape_string(getElementData(targetPlayer, "dbid")))
						
						exports['cr_cache']:clearCharacterName(getElementData(targetPlayer, "dbid"))
						exports['cr_cache']:clearCharacterName(to)
						
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " boşandılar.", thePlayer, 255, 0, 0, true)
					else
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " kimseyle evli değil.", thePlayer, 255, 0, 0, true)
					end
				end
			end
		end
	end
end
addCommandHandler("divorce", divorce)