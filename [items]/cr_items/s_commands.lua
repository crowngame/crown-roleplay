local badges = getBadges()
local masks = getMasks()

-- Player Commands to use Items
function breathTest(thePlayer, commandName, targetPlayer)
	if (exports.cr_global:hasItem(thePlayer, 53)) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("[!]#FFFFFF Bu oyuncu hesabına giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				else
					local x, y, z = getElementPosition(targetPlayer)
					if getDistanceBetweenPoints3D(x, y, z, getElementPosition(thePlayer)) > 4 or getElementDimension(thePlayer) ~= getElementDimension(targetPlayer) then
						outputChatBox("You are too far away.", thePlayer, 255, 0, 0)
					else
						local alcohollevel = getElementData(targetPlayer, "alcohollevel")
						
						if not (alcohollevel) then alcohollevel = 0 end
						
						outputChatBox(targetPlayerName .. "'s Alcohol Levels: " .. alcohollevel .. ".", thePlayer, 255, 194, 15)
					end
				end
			end
		end
	end
end
addCommandHandler("breathtest", breathTest, false, false)

function DeleteMoneyItem(thePlayer)
    if exports["cr_items"]:hasItem(thePlayer, 134) then
	    exports["cr_items"]:takeItem(thePlayer, 134)
	end
end
addEvent("item-system:deletemoney", true)
addEventHandler("item-system:deletemoney", getRootElement(), DeleteMoneyItem)

-- /issueBadge Command - A command for faction leaders
function givePlayerBadge(thePlayer, commandName, targetPlayer, ...)
	local badgeNumber = table.concat({ ... }, " ")
	badgeNumber = #badgeNumber > 0 and badgeNumber
	local theTeam = getPlayerTeam(thePlayer)
	local teamID = getElementData(theTeam, "id")
	
	local badge = nil
	local itemID = nil
	local prefix = ""
	for k, v in pairs(badges) do
		for ka, va in pairs(v[3]) do
			if ka == teamID then
				badge = v
				itemID = k
				prefix = type(va) == "string" and (va .. " ") or ""
			end
		end
	end
	if not badge then return end
	
	local leader = getElementData(thePlayer, "factionleader")
	
	if not (tonumber(leader)==1) then -- If the player is not the leader
		outputChatBox("[!]#FFFFFF Bu işlem için birlik lideri olmanız gerekir.", thePlayer, 255, 0, 0, true) -- If they aren't leader they can't give out badges.
	else
		if not targetPlayer or not badgeNumber then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Rozet]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then -- is the player online?
				local targetPlayerName = targetPlayerName:gsub("_", " ")
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then -- Are they logged in?
					outputChatBox("[!]#FFFFFF Oyuncu giriş yapmamış!", thePlayer, 255, 0, 0, true)
				else
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>4) then -- Are they standing next to each other?
						outputChatBox("You are too far away to issue this player a badge.", thePlayer, 255, 0, 0)
					else
						exports.cr_global:sendLocalMeAction(thePlayer, "" .. targetPlayerName .. " adlı kişiye " .. badgeNumber .. " yazılı " .. badge[2] .. " verir.")
						exports.cr_global:giveItem(targetPlayer, itemID, prefix .. badgeNumber)
					end
				end
			end
		end
	end
end
addCommandHandler("issuebadge", givePlayerBadge, false, false)

--[[ALREADY IN admin-system/Player/s_licenses.lua
function issuePilotCertificate(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or getElementData(thePlayer, "faction") == 15 and getElementData(thePlayer, "factionleader") == 1 then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [player]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then -- is the player online?
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then -- Are they logged in?
					outputChatBox("[!]#FFFFFF Bu oyuncu hesabına giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				else
					exports.cr_global:giveItem(targetPlayer, 78, targetPlayerName) -- Give the player the certificate.
					outputChatBox("You have issued a pilot certificate to " .. targetPlayerName .. ".", thePlayer, 0, 158, 0)
					outputChatBox("You have been issued a pilot certificate by " .. getPlayerName(thePlayer):gsub("_", " ") .. ".", targetPlayer, 0, 158, 0)
				end
			end
		end
	end
end
addCommandHandler("issuepilotcertificate", issuePilotCertificate, false, false)
addCommandHandler("issuepc", issuePilotCertificate, false, false)
addCommandHandler("issuepilot", issuePilotCertificate, false, false)
--]]

function writeNote(thePlayer, commandName, ...)
	local tick = getTickCount()
	if not (...) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Text]", thePlayer, 255, 194, 14)
	elseif not hasSpaceForItem(thePlayer, 72, table.concat({...}, " ")) then
		outputChatBox("[!]#FFFFFF Daha fazla not yazamazsınız.", thePlayer, 255, 0, 0, true)
	elseif getElementData(thePlayer, 'note-timeout') and math.abs(getElementData(thePlayer, 'note-timeout') - tick) < 5000 then
		outputChatBox("[!]#FFFFFF Bir sonraki işlem için 5 saniye beklemeniz gerek.", thePlayer, 255, 0, 0, true)
	else
		giveItem(thePlayer, 72, table.concat({...}, " "))
		exports.cr_global:sendLocalMeAction(thePlayer, "sağ cebinden bir not kağıdı çıkartır ve birşeyler yazar.")
		setElementData(thePlayer, 'note-timeout', tick, false)
	end
end
addCommandHandler("writenote", writeNote, false, false)

function changeLock(thePlayer)
	if exports.cr_integration:isPlayerManagement(thePlayer) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			local dbid = getElementData(theVehicle, "dbid")
			if dbid > 0 then
				exports.cr_logs:logMessage("[VEHICLE] " .. getPlayerName(thePlayer) .. " changed the lock for Vehicle #" .. dbid .. " (" .. exports.cr_global:getVehicleName(theVehicle) .. " - " .. getVehicleName(theVehicle) .. ")", 16)

				exports['cr_vehicle-manager']:addVehicleLogs(dbid, 'changelock', thePlayer)

				deleteAll(3, dbid)
				giveItem(thePlayer, 3, dbid)
				outputChatBox("Locks for this vehicle have been changed.", thePlayer, 0, 255,0 )
			else
				outputChatBox("This is only a temporary vehicle.", thePlayer, 255, 0, 0)
			end
		else
			local dbid, entrance, exit, interiortype = exports['cr_interior']:findProperty(thePlayer)
			if dbid > 0 then
				if interiortype == 2 then
					outputChatBox("This is a government property.", thePlayer, 255, 0, 0)
				else
					local itemid = interiortype == 1 and 5 or 4
					exports.cr_logs:logMessage("[HOUSE] " .. getPlayerName(thePlayer) .. " changed the lock for House #" .. dbid .. ")", 16) 

					exports['cr_interior-manager']:addInteriorLogs(dbid, 'changelock', thePlayer)

					deleteAll(4, dbid)
					deleteAll(5, dbid)
					giveItem(thePlayer, itemid, dbid)
					outputChatBox("Locks for this house have been changed.", thePlayer, 0, 255,0 )
				end
			else
				outputChatBox("You need to be in an interior or a vehicle to change locks.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("changelock", changeLock, false, false)

--TEXTURE SYSTEM:
function saveTextureURL(slot, url)
	--outputDebugString("source=" .. tostring(source) .. " slot=" .. tostring(slot) .. " url=" .. tostring(url))
	updateItemValue(source, slot, url)
	outputChatBox("Texture URL set.", source, 0, 255, 0)
end
addEvent("item-system:saveTextureURL", true)
addEventHandler("item-system:saveTextureURL", getRootElement(), saveTextureURL)

function saveTextureReplacement(slot, url, texture)
	outputDebugString("source=" .. tostring(source) .. " slot=" .. tostring(slot) .. " url=" .. tostring(url) .. " texture=" .. tostring(texture))
	if(texture) then
		updateItemValue(source, slot, tostring(url) .. ";" .. tostring(texture))
	else
		updateItemValue(source, slot, tostring(url))
	end
	outputChatBox("Replacement texture saved.", source, 0, 255, 0)
end
addEvent("item-system:saveTextureReplacement", true)
addEventHandler("item-system:saveTextureReplacement", getRootElement(), saveTextureReplacement)