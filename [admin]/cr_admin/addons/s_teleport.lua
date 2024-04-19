function gotoPlayer(thePlayer, commandName, target)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer) or exports.cr_integration:isPlayerScripter(thePlayer) or exports.cr_integration:isPlayerVCTMember(thePlayer) then
		if commandName:lower() == "goto" then
			if not (target) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
			else
				local username = getPlayerName(thePlayer)
				local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, target)
				
				if targetPlayer then
					local logged = getElementData(targetPlayer, "loggedin")
					
					if (logged == 0) then
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					else
						detachElements(thePlayer)
						local x, y, z = getElementPosition(targetPlayer)
						local interior = getElementInterior(targetPlayer)
						local dimension = getElementDimension(targetPlayer)
						local r = getPedRotation(targetPlayer)
						
						x = x + ((math.cos(math.rad(r))) * 2)
						y = y + ((math.sin(math.rad(r))) * 2)
						
						setCameraInterior(thePlayer, interior)
						
						if (isPedInVehicle(thePlayer)) then
							local veh = getPedOccupiedVehicle(thePlayer)
							setElementAngularVelocity(veh, 0, 0, 0)
							setElementInterior(thePlayer, interior)
							setElementDimension(thePlayer, dimension)
							setElementInterior(veh, interior)
							setElementDimension(veh, dimension)
							setElementPosition(veh, x, y, z + 1)
							warpPedIntoVehicle(thePlayer, veh)
							setTimer(setElementAngularVelocity, 50, 20, veh, 0, 0, 0)
						else
							setElementPosition(thePlayer, x, y, z)
							setElementInterior(thePlayer, interior)
							setElementDimension(thePlayer, dimension)
						end
						
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya ışınladınız.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size ışınlandı.", targetPlayer, 0, 0, 255, true)
						
						exports.cr_discord:sendMessage("goto-log","**[GOTO]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuya ışınlandı.")
						
						triggerEvent("frames:loadInteriorTextures", thePlayer, dimension)
					end
				end
			end
		else
			local username = getPlayerName(thePlayer)
			local logged = getElementData(target, "loggedin")	
			if (logged == 0) then
				outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			else
				detachElements(thePlayer)
				local x, y, z = getElementPosition(target)
				local interior = getElementInterior(target)
				local dimension = getElementDimension(target)
				local r = getPedRotation(target)
				
				x = x + ((math.cos(math.rad(r))) * 2)
				y = y + ((math.sin(math.rad(r))) * 2)
				
				setCameraInterior(thePlayer, interior)
				
				if (isPedInVehicle(thePlayer)) then
					local veh = getPedOccupiedVehicle(thePlayer)
					setElementAngularVelocity(veh, 0, 0, 0)
					setElementInterior(thePlayer, interior)
					setElementDimension(thePlayer, dimension)
					setElementInterior(veh, interior)
					setElementDimension(veh, dimension)
					setElementPosition(veh, x, y, z + 1)
					warpPedIntoVehicle(thePlayer, veh)
					setTimer(setElementAngularVelocity, 50, 20, veh, 0, 0, 0)
				else
					setElementPosition(thePlayer, x, y, z)
					setElementInterior(thePlayer, interior)
					setElementDimension(thePlayer, dimension)
				end
				
				outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya ışınladınız.", thePlayer, 0, 255, 0, true)
				outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size ışınlandı.", targetPlayer, 0, 0, 255, true)
				
				exports.cr_discord:sendMessage("goto-log","**[GOTO]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuya ışınlandı.")
				
				triggerEvent("frames:loadInteriorTextures", thePlayer, dimension)
			end
		end
	end
end
addCommandHandler("goto", gotoPlayer, false, false)

function getPlayer(thePlayer, commandName, target)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer) or exports.cr_integration:isPlayerScripter(thePlayer) then
		if not target then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged == 0) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				else
					local playerAdmLvl = getElementData(thePlayer, "admin_level")or 0
					local targetAdmLvl = getElementData(targetPlayer, "admin_level")or 0
					if (playerAdmLvl < targetAdmLvl) then
						outputChatBox("[!]#FFFFFF Davet " .. targetPlayerName .. " isimli oyuncuya gönderildi.", thePlayer, 255, 0, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili seni yanına çekmek istiyor eğerki gitmek istersen '/atp' reddetmek istersen '/dtp' yazabilirsin.", targetPlayer, 255, 0, 0, true)
						setElementData(targetPlayer, "teleport:targetPlayer", thePlayer)
						return
					end
					
					detachElements(targetPlayer)
					local x, y, z = getElementPosition(thePlayer)
					local interior = getElementInterior(thePlayer)
					local dimension = getElementDimension(thePlayer)
					local r = getPedRotation(thePlayer)
					setCameraInterior(targetPlayer, interior)
					
					x = x + ((math.cos(math.rad(r))) * 2)
					y = y + ((math.sin(math.rad(r))) * 2)
					
					if (isPedInVehicle(targetPlayer)) then
						local veh = getPedOccupiedVehicle(targetPlayer)
						setElementAngularVelocity(veh, 0, 0, 0)
						setElementPosition(veh, x, y, z + 1)
						setTimer(setElementAngularVelocity, 50, 20, veh, 0, 0, 0)
						setElementInterior(veh, interior)
						setElementDimension(veh, dimension)
					else
						setElementPosition(targetPlayer, x, y, z)
						setElementInterior(targetPlayer, interior)
						setElementDimension(targetPlayer, dimension)
					end
					
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuyu yanınıza çektiniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili seni yanına çekti.", targetPlayer, 0, 0, 255, true)
					
					exports.cr_discord:sendMessage("gethere-log", "**[GETHERE]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuyu yanına çekti.")
					
					triggerEvent("frames:loadInteriorTextures", targetPlayer, dimension)
				end
			end
		end
	end
end
addCommandHandler("gethere", getPlayer, false, false)

function acceptTeleport(thePlayer)
	local targetPlayer = false
	targetPlayer = getElementData(thePlayer, "teleport:targetPlayer")
	if not targetPlayer then
		outputChatBox("[!]#FFFFFF Şuanda aktif bir davetin yok!", thePlayer, 255, 0, 0, true)
	else
		gotoPlayer(thePlayer, "LOL", targetPlayer)
		removeElementData(thePlayer, "teleport:targetPlayer")
	end
end
addCommandHandler("atp", acceptTeleport, false, false)

function denyTeleport(thePlayer)
	local targetPlayer = false
	targetPlayer = getElementData(thePlayer, "teleport:targetPlayer")
	if not targetPlayer then
		outputChatBox("[!]#FFFFFF Şuanda aktif bir davetin yok!", thePlayer, 255, 0, 0, true)
	else
		outputChatBox("[!]#FFFFFF Dabetini reddettiğin kişi:  " .. getPlayerName(targetPlayer):gsub("_", " ").. ".", thePlayer, 255, 0, 0, true)
		outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi senin davetini reddetti.", targetPlayer, 255, 0, 0, true)
		removeElementData(thePlayer, "teleport:targetPlayer")
	end
end
addCommandHandler("dtp", denyTeleport, false, false)

local teleportLocations = {
	-- 			x					y					z			int dim	rot
	ls = { 1479.9873046875, -1710.9453125, 13.36874961853, 	0, 	0,	0	},
	sf = { -1988.5693359375, 507.0029296875, 35.171875,	0, 	0,	90	},
	sfia = { -1689.0689697266, 	-536.7919921875, 	14.254997, 	0, 	0,	252	},
	lv = { 1691.6801757813, 	1449.1293945313, 	10.765375,	0, 	0,	268	},
	pc = { 2253.66796875, 		-85.0478515625, 	28.086093,	0, 	0,	180	},
	--bank = { 596.82421875, -1245.7109375, 18.19867515564, 0, 0, 24 }, old bank
	bank = { 1570.4228515625, -1337.3984375, 16.484375, 0, 0, 180 },
	cityhall = { 1481.578125, -1768.6279296875, 18.795755386353, 0, 0, 3 },
	crusher = { 2438.7314453125, -2092.6240234375, 13.546875, 0, 0, 267 },
	--dmv = {  -1978.2578125, 440.484375, 35.171875,  0,  0,  90 },
	bayside = {  -2620.103515625, 2271.232421875, 8.1442451477051, 0, 0, 360 },
	sfpd = {  -1607.71875, 722.9853515625, 12.368106842041, 0, 0, 360 },
	igs = {  1968.3681640625, -1764.0224609375, 13.546875, 0, 0, 120 },
	lsia = { 1967.7998046875, -2180.470703125, 13.546875, 0, 0, 165 },
	ash = { 1178.9794921875, -1324.212890625, 14.146828651428, 0, 0, 268 },
	dmv = { 1094.306640625, -1791.857421875, 13.617427825928, 0, 0, 255 },
	lstr = {  2668.1298828125, -2554.9990234375, 13.614336013794, 0, 0, 180 },
	vgs = { 996.34375, -920.4052734375, 42.1796875, 0, 0, 6 },
}

function teleportToPresetPoint(thePlayer, commandName, target, optionalPlayer)
	if (exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer) or exports.cr_integration:isPlayerScripter(thePlayer) or exports.cr_integration:isPlayerVehicleConsultant(thePlayer)) then
		if not (target) then
			outputChatBox("KULLANIM: /" .. commandName .. " [place] [Player to teleport (optional)]", thePlayer, 255, 194, 14)
			showValidTeleportLocations(thePlayer, "places")
		elseif not optionalPlayer and target then
			local target = string.lower(tostring(target))
			
			if (teleportLocations[target] ~= nil) then
				if (isPedInVehicle(thePlayer)) then
					local veh = getPedOccupiedVehicle(thePlayer)
					setElementAngularVelocity(veh, 0, 0, 0)
					setElementPosition(veh, teleportLocations[target][1], teleportLocations[target][2], teleportLocations[target][3])
					setVehicleRotation(veh, 0, 0, teleportLocations[target][6])
					setTimer(setElementAngularVelocity, 50, 20, veh, 0, 0, 0)
					
					setElementDimension(veh, teleportLocations[target][5])
					setElementInterior(veh, teleportLocations[target][4])

					setElementDimension(thePlayer, teleportLocations[target][5])
					setElementInterior(thePlayer, teleportLocations[target][4])
					setCameraInterior(thePlayer, teleportLocations[target][4])
				else
					detachElements(thePlayer)
					setElementPosition(thePlayer, teleportLocations[target][1], teleportLocations[target][2], teleportLocations[target][3])
					setPedRotation(thePlayer, teleportLocations[target][6])
					setElementDimension(thePlayer, teleportLocations[target][5])
					setCameraInterior(thePlayer, teleportLocations[target][4])
					setElementInterior(thePlayer, teleportLocations[target][4])
				end
				triggerEvent("frames:loadInteriorTextures", thePlayer, teleportLocations[target][5])-- Adams
			else
				outputChatBox("[!]#FFFFFF Geçersiz yer ismi girdiniz.", thePlayer, 255, 0, 0, true)
			end
		elseif optionalPlayer and target then
			local target = string.lower(tostring(target))
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, optionalPlayer)
				
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
					
				if (logged==0) then
					outputChatBox("[!]#FFFFFF Geçersiz oyuncu id'si.", thePlayer, 255, 0, 0, true)

				elseif (teleportLocations[target] ~= nil) then
					outputChatBox("[!]#FFFFFF Işınlandığın yer: " .. tostring(target) .. " ışınlayan: " .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. ".", targetPlayer, 255, 0, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. " isimli oyuncuyu " .. tostring(target) .. " isimli mekana ışınladın.", thePlayer, 255, 0, 0, true)
					exports.cr_discord:sendMessage("gotoplace-log","**[GOTOPLACE]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuyu **(" .. tostring(target) .. ")** isimli mekana ışınladı.")
					if (isPedInVehicle(targetPlayer)) then
						local veh = getPedOccupiedVehicle(targetPlayer)
						setElementAngularVelocity(veh, 0, 0, 0)
						setElementPosition(veh, teleportLocations[target][1], teleportLocations[target][2], teleportLocations[target][3])
						setVehicleRotation(veh, 0, 0, teleportLocations[target][6])
						setTimer(setElementAngularVelocity, 50, 20, veh, 0, 0, 0)
						
						setElementDimension(veh, teleportLocations[target][5])
						setElementInterior(veh, teleportLocations[target][4])

						setElementDimension(targetPlayer, teleportLocations[target][5])
						setElementInterior(targetPlayer, teleportLocations[target][4])
						setCameraInterior(targetPlayer, teleportLocations[target][4])
					else
						detachElements(targetPlayer)
						setElementPosition(targetPlayer, teleportLocations[target][1], teleportLocations[target][2], teleportLocations[target][3])
						setPedRotation(targetPlayer, teleportLocations[target][6])
						setElementDimension(targetPlayer, teleportLocations[target][5])
						setCameraInterior(targetPlayer, teleportLocations[target][4])
						setElementInterior(targetPlayer, teleportLocations[target][4])
					end
					triggerEvent("frames:loadInteriorTextures", targetPlayer, teleportLocations[target][5])-- Adams
				else
					outputChatBox("[!]#FFFFFF Geçersiz yer ismi girdiniz.", thePlayer, 255, 0, 0, true)
				end
			end
		else
		--	outputChatBox("ERROR: Contact a scripter with code #T97sA", thePlayer, 255)
		end
	end
end
addCommandHandler("gotoplace", teleportToPresetPoint, false, false)

function AdminLoungeTeleport(sourcePlayer)
	if (exports.cr_integration:isPlayerTrialAdmin(sourcePlayer) or exports.cr_integration:isPlayerHelper(sourcePlayer)) then
		setElementPosition(sourcePlayer, 275.761475, -2052.245605, 3085.291962)
		setPedGravity(sourcePlayer, 0.008)
		setElementDimension(sourcePlayer, 0)
		setElementInterior(sourcePlayer, 0)
		triggerEvent("texture-system:loadCustomTextures", sourcePlayer)
	end
end
addCommandHandler("adminlounge", AdminLoungeTeleport)
addCommandHandler("gmlounge", AdminLoungeTeleport)

function setX(sourcePlayer, commandName, newX)
	if (exports.cr_integration:isPlayerTrialAdmin(sourcePlayer) or exports.cr_integration:isPlayerScripter(sourcePlayer)) then
		if not (newX) then
			outputChatBox("KULLANIM: /" .. commandName .. " [X]", sourcePlayer, 255, 194, 14)
		else
			x, y, z = getElementPosition(sourcePlayer)
			setElementPosition(sourcePlayer, newX, y, z)
			x, y, z = nil
		end
	end
end
addCommandHandler("setx", setX)

function setY(sourcePlayer, commandName, newY)
	if (exports.cr_integration:isPlayerTrialAdmin(sourcePlayer) or exports.cr_integration:isPlayerScripter(sourcePlayer)) then
		if not (newY) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Y]", sourcePlayer, 255, 194, 14)
		else
			x, y, z = getElementPosition(sourcePlayer)
			setElementPosition(sourcePlayer, x, newY, z)
			x, y, z = nil
		end
	end
end
addCommandHandler("sety", setY)

function setZ(sourcePlayer, commandName, newZ)
	if (exports.cr_integration:isPlayerTrialAdmin(sourcePlayer) or exports.cr_integration:isPlayerScripter(sourcePlayer)) then
		if not (newZ) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Z]", sourcePlayer, 255, 194, 14)
		else
			x, y, z = getElementPosition(sourcePlayer)
			setElementPosition(sourcePlayer, x, y, newZ)
			x, y, z = nil
		end
	end
end
addCommandHandler("setz", setZ)

function setXYZ(sourcePlayer, commandName, newX, newY, newZ)
	if (exports.cr_integration:isPlayerTrialAdmin(sourcePlayer) or exports.cr_integration:isPlayerScripter(sourcePlayer)) then
		if (newX) and (newY) and (newZ) then
			setElementPosition(sourcePlayer, newX, newY, newZ)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [X] [Y] [Z]", sourcePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("setxyz", setXYZ)