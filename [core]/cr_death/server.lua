mysql = exports.cr_mysql

local timers = {}
local seconds = 5

local animations = {
	{"WUZI", "CS_Dead_Guy"},
	{"CRACK", "crckidle1"},
	{"CRACK", "crckidle2"},
	{"CRACK", "crckidle3"},
}

function playerDeath(totalAmmo, killer, killerWeapon)
	if getElementData(source, "dbid") then
		if getElementData(source, "adminjailed") then
			local team = getPlayerTeam(source)
			spawnPlayer(source, 232.3212890625, 160.5693359375, 1003.0234375, 270) --, team)
			
			setElementModel(source,getElementModel(source))
			setPlayerTeam(source, team)
			setElementInterior(source, 9)
			setElementDimension(source, 3)
			
			setCameraInterior(source, 9)
			setCameraTarget(source)
			fadeCamera(source, true)
			
			exports.cr_logs:dbLog(source, 34, source, "died in admin jail")
		elseif getElementData(source, "jailed") then
			exports["cr_prison"]:checkForRelease(source)
		else
			local affected = { }
			table.insert(affected, source)
			local killstr = ' died'
			if isElement(killer) and getElementType (killer) == "player" then
				killstr = ' got killed by ' .. getPlayerName(killer).. ' (' .. getWeaponNameFromID(killerWeapon) .. ')'
				table.insert(affected, killer)
			end
			setElementData(source, "baygin", true)
			-- Remove seatbelt if theres one on
			if (getElementData(source, "seatbelt") == true) then
				setElementData(source, "seatbelt", false, true)
			end
			
			-- Alern
			setElementData(source, "dead", 1)
			local x,y,z = getElementPosition(source)
			local int = getElementInterior(source)
			local dim = getElementDimension(source)
			local team = getPlayerTeam(source)
			local rotx, roty, rotz = getElementRotation(source)
			local skin = getElementModel(source)
			local random = math.random(1, #animations)
			
			spawnPlayer(source, x, y, z, rotz, skin, int, dim, team)
			
			setElementFrozen(source, true)
			setPedHeadless(source, false)
			setCameraInterior(source, int)
			setCameraTarget(source, source) 

			setPlayerTeam(source, team)
			setElementInterior(source, int)
			setElementDimension(source, dim)
			toggleControl(source, "fire", false)
			toggleControl(source, "jump", false)
			setElementHealth(source, 5)
			setTimer(setPedAnimation, 500, 1, source, animations[random][1], animations[random][2], -1, true, false, false)
			
			triggerClientEvent(source, "playerdeath", source)

			setElementData(source, "lastdeath", " [KILL] " .. getPlayerName(source):gsub("_", " ") .. killstr, true)
		end
	end
end
addEventHandler("onPlayerWasted", getRootElement(), playerDeath)

function playerPressedKey(button, press)
    if (press) then 
        if button == "lctrl" or button == "rctrl" or button == "space" then 
            cancelEvent()     
            return true 
        end
    end
end
addEventHandler("onClientKey", root, playerPressedKey)

function changeDeathView(source, victimDropItem)
	if isPedDead(source) then
		local x, y, z = getElementPosition(source)
		local rx, ry, rz = getElementRotation(source)
		setCameraMatrix(source, x+6, y+6, z+3, x, y, z)
		triggerClientEvent(source,"es-system:showRespawnButton",source, victimDropItem)
	end
end
addEvent("changeDeathView", true)
addEventHandler("changeDeathView", getRootElement(), changeDeathView)

function acceptDeath(thePlayer, victimDropItem)
	if getElementData(thePlayer, "dead") == 1 then
		fadeCamera(thePlayer, true)
		setElementData(thePlayer, "baygin", nil)

		setElementHealth(thePlayer, 20)
		setElementData(thePlayer, "poop", 20)
		setElementData(thePlayer, "pee", 20)
		setElementData(thePlayer, "hunger", 20)
		setElementData(thePlayer, "thirst", 20)
		setElementFrozen(thePlayer, false)
		setElementData(thePlayer, "dead", 0)
		exports.cr_global:removeAnimation(thePlayer)
		triggerEvent("updateLocalGuns", thePlayer)
	end
end
addEvent("es-system:acceptDeath", true)
addEventHandler("es-system:acceptDeath", root, acceptDeath)

addEventHandler("onPlayerQuit", root, function()
	if isTimer(timers[source]) then
		killTimer(timers[source]) 
		timers[source] = nil
	end
end)

function logMe(message)
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	exports.cr_global:sendMessageToAdmins(message)
	table.insert(logMeBuffer,"[" .. ("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function logMeNoWrn(message)
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"[" .. ("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function readLog(thePlayer)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "killog") or { }
		outputChatBox("Recent kill list:", thePlayer, 205, 201, 165)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- " .. b, thePlayer, 205, 201, 165, true)
		end
		outputChatBox("  END", thePlayer, 205, 201, 165)
	end
end
addCommandHandler("showkills", readLog)

function respawnPlayer(thePlayer, victimDropItem)
	if (isElement(thePlayer)) then
		
		if (getElementData(thePlayer, "loggedin") == 0) then
			exports.cr_global:sendMessageToAdmins("AC0x0000004: " .. getPlayerName(thePlayer):gsub("_", " ") .. " died while not in character, triggering blackfade.")
			return
		end
		
		setPedHeadless(thePlayer, false)	
		
		local cost = math.random(175, 500)		
		local tax = exports.cr_global:getTaxAmount()
		
		exports.cr_global:giveMoney(getTeamFromName("Los Santos Medical Department"), math.ceil((1-tax)*cost))
		exports.cr_global:takeMoney(getTeamFromName("Türkiye Cumhurbaşkanlığı"), math.ceil((1-tax)*cost))
			
		dbExec(mysql:getConnection(), "UPDATE characters SET deaths = deaths + 1 WHERE charactername='" .. (getPlayerName(thePlayer)) .. "'")

		setCameraInterior(thePlayer, 0)

		setCameraTarget(thePlayer, thePlayer)

		outputChatBox("You have recieved treatment from Los Santos Medical Department.", thePlayer, 255, 255, 0)
		
		-- take all drugs
		local count = 0
		for i = 30, 43 do
			while exports.cr_global:hasItem(thePlayer, i) do
				local number = exports['cr_items']:countItems(thePlayer, i)
				exports.cr_global:takeItem(thePlayer, i)
				exports.cr_logs:logMessage("[SFES Death] " .. getElementData(thePlayer, "account:username") .. "/" .. getPlayerName(thePlayer) .. " lost " .. number .. "x item " .. tostring(i), 28)
				exports.cr_logs:dbLog(thePlayer, 34, thePlayer, "lost " .. number .. "x item " .. tostring(i))
				count = count + 1
			end
		end
		if count > 0 then
			outputChatBox("SFES Employee: We handed your drugs over to the SFPD.", thePlayer, 255, 194, 14)
		end
		
		-- take guns
		local removedWeapons = nil
		if not victimDropItem then
			local gunlicense = tonumber(getElementData(thePlayer, "license.gun"))
			local gunlicense2 = tonumber(getElementData(thePlayer, "license.gun2"))
			local team = getPlayerTeam(thePlayer)
			local factiontype = getElementData(team, "type")
			local items = exports['cr_items']:getItems(thePlayer) -- [] [1] = itemID [2] = itemValue
			
			local formatedWeapons
			local correction = 0
			for itemSlot, itemCheck in ipairs(items) do
				if (itemCheck[1] == 115) or (itemCheck[1] == 116) then -- Weapon
					-- itemCheck[2]: [1] = gta weapon id, [2] = serial number/Amount of bullets, [3] = weapon/ammo name
					local itemCheckExplode = exports.cr_global:explode(":", itemCheck[2])
					local weapon = tonumber(itemCheckExplode[1])
					local ammountOfAmmo
					if (((weapon >= 16 and weapon <= 40 and (gunlicense == 0 and gunlicense2 == 0)) or (weapon == 29 or weapon == 30 or weapon == 32 or weapon ==31 or weapon == 34) and (gunlicense2 == 0)) and factiontype ~= 2) or (weapon >= 35 and weapon <= 38)  then -- (weapon == 4 or weapon == 8)
						exports['cr_items']:takeItemFromSlot(thePlayer, itemSlot - correction)
						correction = correction + 1
						
						if (itemCheck[1] == 115) then
							exports.cr_logs:dbLog(thePlayer, 34, thePlayer, "lost a weapon (" ..  itemCheck[2] .. ")")
							
							for k = 1, 12 do
								triggerEvent("createWepObject", thePlayer, thePlayer, k, 0, getSlotFromWeapon(k))
							end
						else
							exports.cr_logs:dbLog(thePlayer, 34, thePlayer, "lost a magazine of ammo (" ..  itemCheck[2] .. ")")
							local splitArray = split(itemCheck[2], ":")
							ammountOfAmmo = splitArray[2]
						end
						
						if (removedWeapons == nil) then
							if ammountOfAmmo then
								removedWeapons = ammountOfAmmo .. " " .. itemCheckExplode[3]
								formatedWeapons = ammountOfAmmo .. " " .. itemCheckExplode[3]
							else
								removedWeapons = itemCheckExplode[3]
								formatedWeapons = itemCheckExplode[3]
							end
						else
							if ammountOfAmmo then
								removedWeapons = removedWeapons .. ", " .. ammountOfAmmo .. " " .. itemCheckExplode[3]
								formatedWeapons = formatedWeapons .. "\n" .. ammountOfAmmo .. " " .. itemCheckExplode[3]
							else
								removedWeapons = removedWeapons .. ", " .. itemCheckExplode[3]
								formatedWeapons = formatedWeapons .. "\n" .. itemCheckExplode[3]
							end
						end
					end
				end
			end
		end
		if (removedWeapons~=nil) then
			if gunlicense == 0 and factiontype ~= 2 then
				outputChatBox("SFES Employee: We have taken away weapons which you did not have a license for. (" .. removedWeapons .. ").", thePlayer, 255, 194, 14)
			else
				outputChatBox("SFES Employee: We have taken away weapons which you are not allowed to carry. (" .. removedWeapons .. ").", thePlayer, 255, 194, 14)
			end
		end
		
		local death = getElementData(thePlayer, "lastdeath")
		if removedWeapons ~= nil then
			logMe(death)
			exports.cr_global:sendMessageToAdmins("/showkills to view lost weapons.")
			logMeNoWrn("#FF0033 Lost Weapons: " .. removedWeapons)
		else
			logMe(death)
		end
		
		local theSkin = getPedSkin(thePlayer)
		local theTeam = getPlayerTeam(thePlayer)
		
		local fat = getPedStat(thePlayer, 21)
		local muscle = getPedStat(thePlayer, 23)

		setElementData(thePlayer, "dead", 0)
		 
		spawnPlayer(thePlayer, 1176.892578125, -1323.828125, 14.04377746582, 275)--, theTeam)
		setElementModel(thePlayer,theSkin)
		setPlayerTeam(thePlayer, theTeam)
		setElementInterior(thePlayer, 0)
		setElementDimension(thePlayer, 0)
				
		setPedStat(thePlayer, 21, fat)
		setPedStat(thePlayer, 23, muscle)

		fadeCamera(thePlayer, true, 6)
		triggerClientEvent(thePlayer, "fadeCameraOnSpawn", thePlayer)
		triggerEvent("updateLocalGuns", thePlayer)
	end
end

function revivePlayerFromPK(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				if getElementData(targetPlayer, "dead") == 1 then
					triggerClientEvent(targetPlayer,"es-system:closeRespawnButton",targetPlayer)
					
					local x, y, z = getElementPosition(targetPlayer)
					local int = getElementInterior(targetPlayer)
					local dim = getElementDimension(targetPlayer)
					local skin = getElementModel(targetPlayer)
					local team = getPlayerTeam(targetPlayer)
					setElementData(targetPlayer, "baygin", nil)
					
					setPedHeadless(targetPlayer, false)
					setCameraInterior(targetPlayer, int)
					setCameraTarget(targetPlayer, targetPlayer)
					setElementData(targetPlayer, "dead", 0)	 
					setElementData(targetPlayer, "injury", 0) 
					spawnPlayer(targetPlayer, x, y, z, 0)--, team)
					
					setElementModel(targetPlayer,skin)
					setPlayerTeam(targetPlayer, team)
					setElementInterior(targetPlayer, int)
					setElementDimension(targetPlayer, dim)
					acceptDeath(targetPlayer)
					triggerClientEvent(targetPlayer, "bayilmaRevive", targetPlayer)
					triggerEvent("updateLocalGuns", targetPlayer)
					
					local adminTitle = tostring(exports.cr_global:getPlayerAdminTitle(thePlayer))
					exports["cr_infobox"]:addBox(targetPlayer, "success", tostring(exports.cr_global:getPlayerAdminTitle(thePlayer)) .. " " .. tostring(getPlayerName(thePlayer):gsub("_"," ")) .. " tarafından canlandırıldınız.")
					exports["cr_infobox"]:addBox(thePlayer, "success", tostring(getPlayerName(targetPlayer):gsub("_"," ")) .. " isimli oyuncuyu canlandırdınız.")
					exports.cr_global:sendMessageToAdmins("[ADM] " .. tostring(exports.cr_global:getPlayerAdminTitle(thePlayer)) .. " " .. getPlayerName(thePlayer) .. " isimli yetkili " .. tostring(getPlayerName(targetPlayer)) .. " isimli oyuncuyu canlandırdı.")
					exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "REVIVED from PK")
					exports.cr_discord:sendMessage("revive-log","**[REVIVE]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** adlı kişiyi canlandırdı.")
				else
					exports["cr_infobox"]:addBox(thePlayer, "error", tostring(getPlayerName(targetPlayer):gsub("_"," ")) .. " bu oyuncu baygın değil.")
				end
			end
		end
	end
end
addCommandHandler("revive", revivePlayerFromPK, false, false)

addEvent('sync-animation', true)
addEventHandler('sync-animation', root, function(player, progress)
	if tonumber(progress) then
		setPedAnimationProgress(player, "car_crawloutrhs", progress)
	else
		setPedAnimation(player, "ped", "car_crawloutrhs")
	end
end)

local tedaviYeri = createColSphere(1591.8984375, 1798.3076171875, 2083.376953125, 5)
setElementInterior(tedaviYeri, 0)
setElementDimension(tedaviYeri, 3)

function tedaviOl(thePlayer)
	if isElementWithinColShape(thePlayer, tedaviYeri) then
		if getElementData(thePlayer, "injury") == 1 then
			if exports.cr_global:takeMoney(thePlayer, 100) then
				setElementData(thePlayer, "injury", 0)
				setElementHealth(thePlayer, 100)
				outputChatBox("[!]#FFFFFF Başarıyla tedavi oldunuz.", thePlayer, 0, 255, 0, true)
				triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
			else
				outputChatBox("[!]#FFFFFF Tedavi olmak için yeterli paranız bulunmuyor.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("[!]#FFFFFF Tedavi olmak için yaralı olmanız gerekiyor.", thePlayer, 255, 0, 0, true)
		end
	else
		outputChatBox("[!]#FFFFFF Tedavi olma bölgesinde değilsiniz.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("tedaviol", tedaviOl, false, false)

function tedaviEt(thePlayer, commandName, targetPlayer)
	if getElementData(thePlayer, "faction") == 2 or exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") == 1 then
					if getElementData(targetPlayer, "injury") == 1 then
						setElementData(targetPlayer, "injury", 0)
						setElementHealth(targetPlayer, 100)
						
						local adminTitle = tostring(exports.cr_global:getPlayerAdminTitle(thePlayer))
						exports["cr_infobox"]:addBox(targetPlayer, "success", tostring(exports.cr_global:getPlayerAdminTitle(thePlayer)) .. " " .. tostring(getPlayerName(thePlayer):gsub("_"," ")) .. " tarafından tedavi edildiniz.")
						exports["cr_infobox"]:addBox(thePlayer, "success", tostring(getPlayerName(targetPlayer):gsub("_"," ")) .. " isimli oyuncuyu tedavi ettiniz.")
						
						exports.cr_discord:sendMessage("tedaviet-log","**[TEDAVIET]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli kişiyi tedavi etti.")
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu yaralı değil.", thePlayer, 255, 0, 0, true)
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu hesabına giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("tedaviet", tedaviEt, false, false)

function reviveAll(thePlayer, commandName)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		for _, player in ipairs(getElementsByType("player")) do
			if getElementData(player, "dead") == 1 then
				triggerClientEvent(player, "es-system:closeRespawnButton", player)
				
				local x, y, z = getElementPosition(player)
				local int = getElementInterior(player)
				local dim = getElementDimension(player)
				local skin = getElementModel(player)
				local team = getPlayerTeam(player)
				setElementData(player, "baygin", nil)
				
				setPedHeadless(player, false)
				setCameraInterior(player, int)
				setCameraTarget(player, player)
				setElementData(player, "dead", 0)	 
				setElementData(player, "injury", 0) 
				spawnPlayer(player, x, y, z, 0)
				
				setElementModel(player, skin)
				setPlayerTeam(player, team)
				setElementInterior(player, int)
				setElementDimension(player, dim)
				acceptDeath(player)
				triggerClientEvent(player, "bayilmaRevive", player)
				triggerEvent("updateLocalGuns", player)
			end
		end
	end
end
addCommandHandler("reviveall", reviveAll, false, false)