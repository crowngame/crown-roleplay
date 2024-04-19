addEvent("fixRecon", true)
addEventHandler("fixRecon", root, function(element)
	setElementDimension(client, getElementDimension(element))
	setElementInterior(client, getElementInterior(element))
	setCameraInterior(client, getElementInterior(element))
end)

function interiorChanged()
	for key, value in ipairs(exports.cr_pool:getPoolElementsByType("player")) do
		if isElement(value) then
			local cameraTarget = getCameraTarget(value)
			if (cameraTarget) then
				if (cameraTarget==source) then
					local interior = getElementInterior(source)
					local dimension = getElementDimension(source)
					setCameraInterior(value, interior)
					setElementInterior(value, interior)
					setElementDimension(value, dimension)
				end
			end
		end
	end
end
addEventHandler("onPlayerInteriorChange", getRootElement(), interiorChanged)

function removeReconning()
	for key, value in ipairs(exports.cr_pool:getPoolElementsByType("player")) do
		if isElement(value) then
			local cameraTarget = getCameraTarget(value)
			if (cameraTarget) then
				if (cameraTarget==source) then
					reconPlayer(value)
				end
			end
		end
	end
end
addEventHandler("onPlayerQuit", getRootElement(), removeReconning)

function reconPlayer(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			local rx = getElementData(thePlayer, "reconx")
			local ry = getElementData(thePlayer, "recony")
			local rz = getElementData(thePlayer, "reconz")
			local reconrot = getElementData(thePlayer, "reconrot")
			local recondimension = getElementData(thePlayer, "recondimension")
			local reconinterior = getElementData(thePlayer, "reconinterior")
			
			if not (rx) or not (ry) or not (rz) or not (reconrot) or not (recondimension) or not (reconinterior) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
			else
				detachElements(thePlayer)
			
				setElementPosition(thePlayer, rx, ry, rz)
				setPedRotation(thePlayer, reconrot)
				setElementDimension(thePlayer, recondimension)
				setElementInterior(thePlayer, reconinterior)
				setCameraInterior(thePlayer, reconinterior)
				
				setElementData(thePlayer, "reconx", nil, false)
				setElementData(thePlayer, "recony", nil, false)
				setElementData(thePlayer, "reconz", nil, false)
				setElementData(thePlayer, "reconrot", nil, false)
				setCameraTarget(thePlayer, thePlayer)
				setElementAlpha(thePlayer, 255)
				outputChatBox("[!]#FFFFFF Recon'dan çıkıldı.", thePlayer, 255, 0, 0, true)
			end
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local freecamEnabled = exports.cr_freecam:isPlayerFreecamEnabled(thePlayer)
			if freecamEnabled then
				toggleFreecam(thePlayer)
			end
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged == 0) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				else
					setElementAlpha(thePlayer, 0)
					
					if getPedOccupiedVehicle (thePlayer) then
						setElementData(thePlayer, "realinvehicle", 0, false)
						removePedFromVehicle(thePlayer)
					end
					
					if (not getElementData(thePlayer, "reconx") or getElementData(thePlayer, "reconx") == true) and not getElementData(thePlayer, "recony") then
						local x, y, z = getElementPosition(thePlayer)
						local rot = getPedRotation(thePlayer)
						local dimension = getElementDimension(thePlayer)
						local interior = getElementInterior(thePlayer)
						setElementData(thePlayer, "reconx", x, false)
						setElementData(thePlayer, "recony", y, false)
						setElementData(thePlayer, "reconz", z, false)
						setElementData(thePlayer, "reconrot", rot, false)
						setElementData(thePlayer, "recondimension", dimension, false)
						setElementData(thePlayer, "reconinterior", interior, false)
					end
					setPedWeaponSlot(thePlayer, 0)
					
					local playerdimension = getElementDimension(targetPlayer)
					local playerinterior = getElementInterior(targetPlayer)
					
					setElementDimension(thePlayer, playerdimension)
					setElementInterior(thePlayer, playerinterior)
					setCameraInterior(thePlayer, playerinterior)
					
					local x, y, z = getElementPosition(targetPlayer)
					setElementPosition(thePlayer, x - 10, y - 10, z - 5)
					local success = attachElements(thePlayer, targetPlayer, -10, -10, -5)
					if not (success) then
						success = attachElements(thePlayer, targetPlayer, -5, -5, -5)
						if not (success) then
							success = attachElements(thePlayer, targetPlayer, 5, 5, -5)
						end
					end
					
					if not (success) then
						outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer,255, 0, 0, true)
					else
						setCameraTarget(thePlayer, targetPlayer)
						outputChatBox("[!]#FFFFFF İzlediğiniz kişi: " .. targetPlayerName .. ".", thePlayer, 255, 0, 0, true)
						
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.cr_global:getPlayerFullAdminTitle(thePlayer)
						
						if hiddenAdmin == 1 then
							adminTitle = "Gizli Yetkili"
						end
						
						exports.cr_global:sendMessageToAdmins("[ADM] " .. adminTitle .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu izlemeye başladı.")
					end
				end
			end
		end
	end
end
addCommandHandler("recon", reconPlayer, false, false)

function fuckRecon(thePlayer, commandName, targetPlayer)
	if (exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer)) then
		if true then
			return outputChatBox("Just /recon again to turn off", thePlayer)
		end
		local rx = getElementData(thePlayer, "reconx")
		local ry = getElementData(thePlayer, "recony")
		local rz = getElementData(thePlayer, "reconz")
		local reconrot = getElementData(thePlayer, "reconrot")
		local recondimension = getElementData(thePlayer, "recondimension")
		local reconinterior = getElementData(thePlayer, "reconinterior")
		
		detachElements(thePlayer)
		setCameraTarget(thePlayer, thePlayer)
		setElementAlpha(thePlayer, 255)
		
		if rx and ry and rz then
			setElementPosition(thePlayer, rx, ry, rz)
			if reconrot then
				setPedRotation(thePlayer, reconrot)
			end
			
			if recondimension then
				setElementDimension(thePlayer, recondimension)
			end
			
			if reconinterior then
					setElementInterior(thePlayer, reconinterior)
					setCameraInterior(thePlayer, reconinterior)
			end
		end
		
		setElementData(thePlayer, "reconx", false, false)
		setElementData(thePlayer, "recony", false, false)
		setElementData(thePlayer, "reconz", false, false)
		setElementData(thePlayer, "reconrot", false, false)
		outputChatBox("Recon turned off.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("fuckrecon", fuckRecon, false, false)
addCommandHandler("stoprecon", fuckRecon, false, false)

function toggleInvisibility(thePlayer)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerScripter(thePlayer) then
		local enabled = getElementData(thePlayer, "invisible")
		if (enabled == true) then
			setElementAlpha(thePlayer, 255)
			setElementData(thePlayer, "reconx", false, false)
			outputChatBox("[!]#FFFFFF Görünmezlik kapatıldı.", thePlayer, 255, 0, 0, true)
			setElementData(thePlayer, "invisible", false, false)
			exports.cr_logs:dbLog(thePlayer, 4, thePlayer, "DISAPPEAR DISABLED")
			exports.cr_discord:sendMessage("disappear-log","**[DISAPPEAR]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili disappear modunu **(Kapattı)**.")
		elseif (enabled == false or enabled == nil) then
			setElementAlpha(thePlayer, 0)
			setElementData(thePlayer, "reconx", true, false)
			outputChatBox("[!]#FFFFFF Başarıyla görünmezlik modu açıldı.", thePlayer, 255, 0, 0, true)
			setElementData(thePlayer, "invisible", true, false)
			exports.cr_logs:dbLog(thePlayer, 4, thePlayer, "DISAPPEAR ENABLED")
			exports.cr_discord:sendMessage("disappear-log","**[DISAPPEAR]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili disappear modunu **(Açtı)**.")
		else
			outputChatBox("[!]#FFFFFF İlk önce recon'u kapatın.", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("disappear", toggleInvisibility)

					
-- TOGGLE NAMETAG

function toggleMyNametag(thePlayer)
	local visible = getElementData(thePlayer, "reconx")
	local username = getElementData(thePlayer, "account:username")
	if exports.cr_integration:isPlayerHeadAdmin(thePlayer) then
		if (visible == true) then
			setPlayerNametagShowing(thePlayer, false)
			setElementData(thePlayer, "reconx", false, false)
			outputChatBox("[!]#FFFFFF İsminiz artık görünür durumda.", thePlayer, 255, 0, 0, true)
		elseif (visible == false or visible == nil) then
			setPlayerNametagShowing(thePlayer, false)
			setElementData(thePlayer, "reconx", true, false)
			outputChatBox("[!]#FFFFFF İsminiz artık gizlendi.", thePlayer, 255, 0, 0, true)
		else
			outputChatBox("[!]#FFFFFF İlk önce recon'u kapatın.", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("togmytag", toggleMyNametag)

-- RP SUPERVISE

function roleplaySupervise(thePlayer)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer) then
		if exports.cr_global:isStaffOnDuty(thePlayer) then
			local enabled = getElementData(thePlayer, "supervising")
			if (enabled == true) then
				setElementAlpha(thePlayer, 255)
				outputChatBox("[!]#FFFFFF Artık süpervizor modunda değilsin.", thePlayer, 255, 0, 0, true)
				exports.cr_logs:dbLog(thePlayer, 4, thePlayer, "RP SUPERVISOR DISABLED")
				exports.cr_global:sendWrnToStaff("[ADM] " .. getElementData(thePlayer, "account:username") .. " süpervizor modunu kapattı.")

				setElementData(thePlayer, "supervising", false)
			elseif (enabled == false or enabled == nil) then
				setElementAlpha(thePlayer, 100)
				outputChatBox("[!]#FFFFFF Süpervizor modunu başarıyla aktif ettin.", thePlayer, 255, 0, 0, true)
				exports.cr_logs:dbLog(thePlayer, 4, thePlayer, "RP SUPERVISOR ENABLED")
				exports.cr_global:sendWrnToStaff("[ADM] " .. getElementData(thePlayer, "account:username") .. " süpervizor modunu açtı.")

				setElementData(thePlayer, "supervising", true)
			else
				outputChatBox("[!]#FFFFFF İlk önce recon'u kapatın.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("supervise", roleplaySupervise)

function asyncReconActivate(cur)
	if client ~= source then return end
	
	local target = exports.cr_pool:getElement("player", cur.target)
	if not target then
		triggerClientEvent(source, "admin:recon", source)
		return
	end
	removePedFromVehicle(source)
	if exports.cr_freecam:isEnabled(source) then
		triggerEvent("freecam:asyncDeactivateFreecam", source)
	end
	setElementData(source, "reconx", true , false)
	setElementCollisionsEnabled (source, false)
	setElementAlpha(source, 0)
	setPedWeaponSlot(source, 0)
	
	local t_int = getElementInterior(target)
	local t_dim = getElementDimension(target)

	setElementDimension(source, t_dim)
	setElementInterior(source, t_int)
	setCameraInterior(source, t_int)

	local x1, y1, z1 = getElementPosition(target)
	attachElements(source, target, 0, 0, 5)
	setElementPosition(source, x1, y1, z1+5)
	setCameraTarget(source,target)
end
addEvent("admin:recon:async:activate", true)
addEventHandler("admin:recon:async:activate", root, asyncReconActivate)

function asyncReconDeactivate(cur)
	if exports.cr_freecam:isEnabled(source) then
		triggerEvent("freecam:asyncDeactivateFreecam", source)
	end
	removePedFromVehicle(source)
	detachElements(source)
	setElementData(source, "reconx", false, false)

	setElementPosition(source, cur.x, cur.y, cur.z)
	setElementRotation(source, cur.rx, cur.ry, cur.rz)

	setElementDimension(source, cur.dim)
	setElementInterior(source, cur.int)
	setCameraInterior(source,cur.int)
	
	setCameraTarget(source, nil)
	setElementAlpha(source, 255)
	setElementCollisionsEnabled (source, true)
end
addEvent("admin:recon:async:deactivate", true)
addEventHandler("admin:recon:async:deactivate", root, asyncReconDeactivate)
