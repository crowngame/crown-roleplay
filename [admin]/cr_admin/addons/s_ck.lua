
-- /CK
function ckPlayer(thePlayer, commandName, targetPlayer, ...)
	    if exports.cr_integration:isPlayerManagement(thePlayer) then
		if not (targetPlayer) or not (...) then
			outputChatBox("KULLANIM:/" .. commandName .. " [Karakter Adı / ID] [Cause of Death]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					--outputChatBox("[!]#FFFFFF Bu oyuncu hesabına giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				elseif (logged==1) then
					info = table.concat({...}, " ")
					local query = dbExec(mysql:getConnection(),"UPDATE `characters` SET `cked`='1', `ck_info`='" .. mysql:escape_string(tostring(info)) .. "', `death_date`=NOW() WHERE `id` = " .. mysql:escape_string(getElementData(targetPlayer, "dbid"))) --Farid
					
					local x, y, z = getElementPosition(targetPlayer)
					local skin = getPedSkin(targetPlayer)
					local rotation = getPedRotation(targetPlayer)
					local look = getElementData(targetPlayer, "look")
					local desc = look[5]
					call(getResourceFromName("cr_realism"), "addCharacterKillBody", x, y, z, rotation, skin, getElementData(targetPlayer, "dbid"), targetPlayerName, getElementInterior(targetPlayer), getElementDimension(targetPlayer), getElementData(targetPlayer, "age"), getElementData(targetPlayer, "race"), getElementData(targetPlayer, "weight"), getElementData(targetPlayer, "height"), desc, info, getElementData(targetPlayer, "gender"))
					
					local id = getElementData(targetPlayer, "account:id")
					outputChatBox("[!]#FFFFFF Seni ck eden kişi: " .. getPlayerName(thePlayer) .. ".", targetPlayer, 255, 0, 0, true)
					showChat(targetPlayer, false)
					outputChatBox("[!]#FFFFFF Ck ettiğin kişi: " ..  targetPlayerName  .. ".", thePlayer, 255, 0, 0, true)
					exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "CK with reason: " .. mysql:escape_string(tostring(info)))
					triggerClientEvent("showCkWindow", targetPlayer)
				end
			end
		end
	end
end
addCommandHandler("ck", ckPlayer)

-- /UNCK
function unckPlayer(thePlayer, commandName, ...)
	if exports.cr_integration:isPlayerManagement(thePlayer) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Full Player Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = table.concat({...}, "_")
			local result = mysql:query("SELECT id, account FROM characters WHERE charactername='" .. mysql:escape_string(tostring(targetPlayer)) .. "' AND cked > 0")
			
			if (mysql:num_rows(result)>1) then
				outputChatBox("Too many results - Please enter a more exact name.", thePlayer, 255, 0, 0)
			elseif (mysql:num_rows(result)==0) then
				outputChatBox("Player does not exist or is not CK'ed.", thePlayer, 255, 0, 0)
			else
				local row = mysql:fetch_assoc(result)
				local dbid = tonumber(row["id"]) or 0
				local account = tonumber(row["account"])
				dbExec(mysql:getConnection(),"UPDATE characters SET cked='0' WHERE id = " .. dbid .. " LIMIT 1")
				
				-- Delete all peds for him
				for key, value in pairs(getElementsByType("ped")) do
					if isElement(value) and getElementData(value, "ckid") then
						if getElementData(value, "ckid") == dbid then
							destroyElement(value)
						end
					end
				end
				
				outputChatBox(targetPlayer .. " is no longer CK'ed.", thePlayer, 0, 255, 0)
				--exports.cr_logs:logMessage("[/UNCK] " .. getElementData(thePlayer, "account:username") .. "/" ..  getPlayerName(thePlayer)  .. " UNCK'ED " ..  targetPlayer , 4)
				exports.cr_logs:dbLog(thePlayer, 4, "ch" .. row["id"], "UNCK")
			end
			mysql:free_result(result)
		end
	end
end
addCommandHandler("unck", unckPlayer)

-- /BURY
function buryPlayer(thePlayer, commandName, ...)
local theTeam = getPlayerTeam(thePlayer)
local factionType = getElementData(theTeam, "type")
	if (exports.cr_integration:isPlayerHeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Full Player Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = table.concat({...}, "_")
			local result = mysql:query("SELECT id, cked FROM characters WHERE charactername='" .. mysql:escape_string(tostring(targetPlayer)) .. "'")
			
			if (mysql:num_rows(result)>1) then
				outputChatBox("Too many results - Please enter a more exact name.", thePlayer, 255, 0, 0)
			elseif (mysql:num_rows(result)==0) then
				outputChatBox("Player does not exist.", thePlayer, 255, 0, 0)
			else
				local row = mysql:fetch_assoc(result)
				local dbid = tonumber(row["id"]) or 0
				local cked = tonumber(row["cked"]) or 0
				if cked == 0 then
					outputChatBox("Player is not CK'ed.", thePlayer, 255, 0, 0)
				elseif cked == 2 then
					outputChatBox("Player is already buried.", thePlayer, 255, 0, 0)
				else
					dbExec(mysql:getConnection(),"UPDATE `characters` SET `cked`='2' WHERE `id` = " .. dbid .. " LIMIT 1")
					
					-- Delete all peds for him
					for key, value in pairs(getElementsByType("ped")) do
						if isElement(value) and getElementData(value, "ckid") then
							if getElementData(value, "ckid") == dbid then
								destroyElement(value)
							end
						end
					end
					
					outputChatBox(targetPlayer .. " was buried.", thePlayer, 0, 255, 0)
					exports.cr_logs:logMessage("[/BURY] " .. getElementData(thePlayer, "account:username") .. "/" ..  getPlayerName(thePlayer)  .. " buried " ..  targetPlayer , 4)
					exports.cr_logs:dbLog(thePlayer, 4, "ch" .. row["id"], "CK-BURY")
				end
			end
			mysql:free_result(result)
		end
	elseif (factionType==4) and not exports.cr_integration:isPlayerHeadAdmin(thePlayer) then -- LSFD Bury
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Full Player Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = table.concat({...}, "_")
			local result = mysql:query("SELECT id, cked FROM characters WHERE charactername='" .. mysql:escape_string(tostring(targetPlayer)) .. "'")
			
			if (mysql:num_rows(result)>1) then
				outputChatBox("Too many results - Please enter a more exact name.", thePlayer, 255, 0, 0)
			elseif (mysql:num_rows(result)==0) then
				outputChatBox("Player does not exist.", thePlayer, 255, 0, 0)
			else
				local row = mysql:fetch_assoc(result)
				local dbid = tonumber(row["id"]) or 0
				local cked = tonumber(row["cked"]) or 0
				if cked == 0 then
					outputChatBox("Player is not CK'ed.", thePlayer, 255, 0, 0)
				elseif cked == 2 then
					outputChatBox("Player is already buried.", thePlayer, 255, 0, 0)
				else
					dbExec(mysql:getConnection(),"UPDATE characters SET cked='2' WHERE id = " .. dbid .. " LIMIT 1")
					
					-- Delete all peds for him
					for key, value in pairs(getElementsByType("ped")) do
						if isElement(value) and getElementData(value, "ckid") then
							if getElementData(value, "ckid") == dbid then
								destroyElement(value)
							end
						end
					end
					triggerEvent('sendAme', thePlayer, "puts " ..  tostring(targetPlayer)  .. " to rest.")
					outputChatBox(targetPlayer .. " was buried.", thePlayer, 0, 255, 0)
					exports.cr_logs:logMessage("[/BURY] LSES MEMBER " .. getElementData(thePlayer, "account:username") .. "/" ..  getPlayerName(thePlayer)  .. " buried " ..  targetPlayer , 4)
					exports.cr_logs:dbLog(thePlayer, 4, "ch" .. row["id"], "CK-BURY-LSES")
				end
			end
			mysql:free_result(result)
		end	
	end
end
addCommandHandler("bury", buryPlayer)