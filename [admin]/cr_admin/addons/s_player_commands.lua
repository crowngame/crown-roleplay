mysql = exports.cr_mysql

function adminUncuff(thePlayer, commandName, targetPlayer)
	if (exports.cr_integration:isPlayerGameAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged == 0) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				else
					local restrain = getElementData(targetPlayer, "restrain")

					if (restrain == 0) then
						outputChatBox("[!]#FFFFFF Bu oyuncu kelepçeli değil.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					else
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili kelepçenizi çıkardı.", targetPlayer, 0, 255, 0, true)
						else
							outputChatBox("[!]#FFFFFF Gizli Yetkili kelepçenizi çıkardı.", targetPlayer, 0, 255, 0, true)
						end
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun kelepçesi çıkartılmıştır.", thePlayer, 0, 255, 0, true)
						
						toggleControl(targetPlayer, "sprint", true)
						toggleControl(targetPlayer, "fire", true)
						toggleControl(targetPlayer, "jump", true)
						toggleControl(targetPlayer, "next_weapon", true)
						toggleControl(targetPlayer, "previous_weapon", true)
						toggleControl(targetPlayer, "accelerate", true)
						toggleControl(targetPlayer, "brake_reverse", true)
						toggleControl(targetPlayer, "aim_weapon", true)
						setElementData(targetPlayer, "restrain", 0, true)
						setElementData(targetPlayer, "restrainedBy", false, true)
						setElementData(targetPlayer, "restrainedObj", false, true)
						exports.cr_global:removeAnimation(targetPlayer)
						dbExec(mysql:getConnection(), "UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. (getElementData(targetPlayer, "dbid")))
						exports['cr_items']:deleteAll(47, getElementData(targetPlayer, "dbid"))
						exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "UNCUFF")
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("auncuff", adminUncuff, false, false)

function adminUnmask(thePlayer, commandName, targetPlayer)
	if (exports.cr_integration:isPlayerGameAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)

				if (logged==0) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				else
					local any = false
					local masks = exports['cr_items']:getMasks()
					for key, value in pairs(masks) do
						if getElementData(targetPlayer, value[1]) then
							any = true
							setElementData(targetPlayer, value[1], false, true)
						end
					end

					if any then
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							outputChatBox("[*] Maskeniz " .. username.. " isimli yetkili tarafından çıkartılmıştır.", targetPlayer, 255, 0, 0)
						else
							outputChatBox("[*] Maskeniz gizli bir yetkili tarafından çıkartılmıştır.", targetPlayer, 255, 0, 0)
						end
						--outputChatBox("You have removed the mask from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
						--exports["cr_bildirim"]:addNotification(thePlayer, targetPlayerName .. " isimli oyuncunun maskesi çıkartılmıştır.", "info")
						exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "UNMASK")
					else
						outputChatBox("[*] Oyuncu maskeli değil.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("aunmask", adminUnmask, false, false)

function adminUnblindfold(thePlayer, commandName, targetPlayer)
	if (exports.cr_integration:isPlayerGameAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)

				if (logged==0) then
					--outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					----exports["cr_bildirim"]:addNotification(targetPlayer, "Oyuncu henüz giriş yapmadı!", "error")
				else
					local blindfolded = getElementData(targetPlayer, "rblindfold")

					if (blindfolded==0) then
						--outputChatBox("[*] Oyuncunun gözleri kapalı değil.", thePlayer, 255, 0, 0)
					else
						setElementData(targetPlayer, "blindfold", false, false)
						fadeCamera(targetPlayer, true)
						--outputChatBox("You have unblindfolded " .. targetPlayerName .. ".", thePlayer)
						--exports["cr_bildirim"]:addNotification(thePlayer, targetPlayerName .. " isimli oyuncunun göz bandını açtınız.", "info")
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							--outputChatBox("You have been unblindfolded by admin " .. username .. ".", thePlayer)
							--exports["cr_bildirim"]:addNotification(targetPlayer, username .. " isimli yetkili göz bandınızı açtı.", "info")
						else
							--outputChatBox("You have been unblindfolded by Gizli Yetkili.", thePlayer)
							--exports["cr_bildirim"]:addNotification(targetPlayer, "Bir gizli yetkili göz bandınızı açtı.", "info")
						end
						dbExec(mysql:getConnection(), "UPDATE characters SET blindfold = 0 WHERE id = " .. (getElementData(targetPlayer, "dbid")))
						exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "UNBLINDFOLD")
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("aunblindfold", adminUnblindfold, false, false)

function disarmPlayer(thePlayer, commandName, targetPlayer)
	if (exports.cr_integration:isPlayerManagement(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged == 0) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				else
					for i = 115, 116 do
						while exports.cr_items:takeItem(targetPlayer, i) do
						end
					end
					
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)
					
					if (hiddenAdmin == 0) then
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun tüm silahları silindi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili tarafından tüm silahlarınız silindi.", targetPlayer, 255, 0, 0, true)
						exports.cr_global:sendMessageToAdmins("[DISARM] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun tüm silahlarını sildi.")
						exports.cr_discord:sendMessage("disarm-log", "**[DISARM]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncunun tüm silahlarını sildi.")
					else
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun tüm silahları silindi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF Gizli Yetkili tarafından tüm silahlarınız silindi.", targetPlayer, 255, 0, 0, true)
						exports.cr_global:sendMessageToAdmins("[DISARM] Gizli Yetkili " .. targetPlayerName .. " isimli oyuncunun tüm silahlarını sildi.")
						exports.cr_discord:sendMessage("disarm-log", "**[DISARM]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " (Gizli)** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncunun tüm silahlarını sildi.")
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("disarm", disarmPlayer, false, false)

function forceReconnect(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerHeadAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.cr_global:getPlayerFullAdminTitle(thePlayer)
				
				if (hiddenAdmin == 0) then
					exports.cr_global:sendMessageToAdmins("[ADM] " .. adminTitle .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya force reconnect attı.")
				else
					adminTitle = "Gizli Yetkili"
					exports.cr_global:sendMessageToAdmins("[ADM] Gizli Yetkili " .. targetPlayerName .. " isimli oyuncuya force reconnect attı.")
				end
				
				local timer = setTimer(kickPlayer, 1000, 1, targetPlayer, root, adminTitle .. " isimli yetkili tarafından force reconnect atıldınız.")
				addEventHandler("onPlayerQuit", targetPlayer, function() killTimer(timer) end)

				redirectPlayer(targetPlayer, "", 0)

				exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "FRECONNECT")
				exports.cr_discord:sendMessage("freconnect-log", "**[FRECONNECT]** **" .. adminTitle .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuya force reconnect attı.")
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("freconnect", forceReconnect, false, false)
addCommandHandler("frec", forceReconnect, false, false)

function givePlayerGun(thePlayer, commandName, targetPlayer, ...)
	if exports.cr_integration:isPlayerManager(thePlayer) then
		local args = {...}
		if not (targetPlayer) or (#args < 1) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Silah İsmi / ID] [Miktar]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local weaponID = tonumber(args[1])
				local weaponName = args[1]
				local quantity = tonumber(args[2])
				if weaponID == nil then
					local cWeaponName = weaponName:lower()
					if cWeaponName == "colt45" then
						weaponID = 22
					elseif cWeaponName == "rocketlauncher" then
						weaponID = 35
					elseif cWeaponName == "combatshotgun" then
						weaponID = 27
					elseif cWeaponName == "fireextinguisher" then
						weaponID = 42
					else
						if getWeaponIDFromName(cWeaponName) == false then
							outputChatBox("[MAKEGUN] Invalid Silah İsmi / ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
							return
						else
							weaponID = getWeaponIDFromName(cWeaponName)
						end
					end
				end

				if getAmmoPerClip(weaponID) == "disabled" then
					outputChatBox("[MAKEGUN] Invalid Silah İsmi / ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
					return
				end

				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

				if (logged==0) then
					outputChatBox("[MAKEGUN] Oyuncu henüz giriş yapmadı.", thePlayer, 255, 0, 0)
				elseif (logged==1) then

					local adminDBID = tonumber(getElementData(thePlayer, "account:character:id"))
					local playerDBID = tonumber(getElementData(targetPlayer, "account:character:id"))

					if quantity == nil then
						quantity = 1
					end

					local maxAmountOfWeapons = tonumber(get(getResourceName(getThisResource()).. '.maxAmountOfWeapons'))
					if quantity > maxAmountOfWeapons then
						quantity = maxAmountOfWeapons
						outputChatBox("[MAKEGUN] Aynı anda " .. maxAmountOfWeapons .. " silahdan daha fazla silah veremezsiniz. " .. maxAmountOfWeapons .. " silah oluşturulmaya çalışılıyor...", thePlayer, 150, 150, 150)
					end

					local count = 0
					local fails = 0
					local allSerials = ""
					local give, error = ""
					for variable = 1, quantity, 1 do
						local mySerial = exports.cr_global:createWeaponSerial(1, adminDBID, playerDBID)
						give, error = exports.cr_global:giveItem(targetPlayer, 115, weaponID .. ":" .. mySerial .. ":" .. getWeaponNameFromID(weaponID) .. "::")
						if give then
							exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "GIVEWEAPON " .. getWeaponNameFromID(weaponID) .. " " .. tostring(mySerial))
							if count == 0 then
								allSerials = mySerial
							else
								allSerials = allSerials .. "', '" .. mySerial
							end
							count = count + 1
						else
							fails = fails + 1
						end
					end
					if count > 0 then
						local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)
						if (hiddenAdmin==0) then
							--Inform Spawner
							outputChatBox("[MAKEGUN] You have given (x" .. count .. ") " ..  getWeaponNameFromID(weaponID) .. " to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
							--Inform Player
							outputChatBox("You've received (x" .. count .. ") " ..  getWeaponNameFromID(weaponID) .. " from " .. adminTitle .. " " .. getPlayerName(thePlayer) .. ".", targetPlayer, 0, 255, 0)
							--Send adm warning
							exports.cr_global:sendMessageToAdmins("[ADM] " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " (x" .. count .. ") " .. getWeaponNameFromID(weaponID) .. " with serial '" .. allSerials .. "'")
							exports.cr_discord:sendMessage("makegun-log","**[MAKEGUN]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** adlı kişiye **(" .. count .. ")** adet **(" ..  getWeaponNameFromID(weaponID) .. ")** verdi.")
							exports.cr_discord:sendMessage("makegun-log","**[SERIAL]** " .. allSerials .. " ")
						else -- If Gizli Yetkili
							outputChatBox("[MAKEGUN] You have given (x" .. count .. ") " ..  getWeaponNameFromID(weaponID) .. " to " .. targetPlayerName .. " with serials '" .. allSerials, thePlayer, 0, 255, 0)
							exports.cr_discord:sendMessage("makegun-log","**[MAKEGUN]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** adlı kişiye **(" .. count .. ")** adet **(" ..  getWeaponNameFromID(weaponID) .. ")** verdi.")
							exports.cr_discord:sendMessage("makegun-log","**[SERIAL]** (" .. allSerials .. ") ")
                            

							outputChatBox("You've received (x" .. count .. ") " ..  getWeaponNameFromID(weaponID) .. " from Gizli Yetkili.", targetPlayer, 0, 255, 0)
						end
					end
					if fails > 0 then
						outputChatBox("[MAKEGUN] " .. fails .. " weapons couldn't be created. Player's " ..  error  .. ".", thePlayer, 255, 0, 0)
						outputChatBox("[ERROR] " .. fails .. " weapons couldn't be received from Admin. Your " ..  error  .. ".", targetPlayer, 255, 0, 0)
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("makegun", givePlayerGun, false, false)
addEvent("onMakeGun", true)
addEventHandler("onMakeGun", getRootElement(), givePlayerGun)

function givePlayerGunAmmo(thePlayer, commandName, targetPlayer, ...)
	if exports.cr_integration:isPlayerManager(thePlayer) then
		local args = {...}
		if not (targetPlayer) or (#args < 1) then
		    outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Silah İsmi / ID] [Miktar] [Fiyat]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				--local ammo =  tonumber(args[2]) or 1
				local weaponID = tonumber(args[1])
				local weaponName = args[1]
				local ammo = tonumber(args[2]) or -1
				local quantity = tonumber(args[3]) or -1

				if weaponID == nil then
					local cWeaponName = weaponName:lower()
					if cWeaponName == "colt45" then
						weaponID = 22
					elseif cWeaponName == "rocketlauncher" then
						weaponID = 35
					elseif cWeaponName == "combatshotgun" then
						weaponID = 27
					elseif cWeaponName == "fireextinguisher" then
						weaponID = 42
					else
						if getWeaponIDFromName(cWeaponName) == false then
							outputChatBox("[MAKEAMMO] Invalid Silah İsmi / ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
							return
						else
							weaponID = getWeaponIDFromName(cWeaponName)
						end
					end
				end

				if getAmmoPerClip(weaponID) == "disabled" then --If weapon is not allowed
					outputChatBox("[MAKEAMMO] Invalid Silah İsmi / ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
					return
				elseif getAmmoPerClip(weaponID) == tostring(0)  then-- if weapon doesn't need ammo to work
					outputChatBox("[MAKEAMMO] This weapon doesn't use ammo.", thePlayer, 255, 0, 0)
					return
				else
				end

				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

				if (logged==0) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				elseif (logged==1) then
					if ammo == -1 then -- if full ammopack
						ammo = getAmmoPerClip(weaponID)
					end

					if quantity == -1 then
						quantity = 1
					end

					local maxAmountOfAmmopacks = tonumber(get(getResourceName(getThisResource()).. '.maxAmountOfAmmopacks'))
					if quantity > maxAmountOfAmmopacks then
						quantity = maxAmountOfAmmopacks
						outputChatBox("[MAKEAMMO] You can't give more than " .. maxAmountOfAmmopacks .. " magazines at a time. Trying to spawn " .. maxAmountOfAmmopacks .. "...", thePlayer, 150, 150, 150)
					end

					local count = 0
					local fails = 0
					local give, error = ""
					for variable = 1, quantity, 1 do
						give, error = exports.cr_global:giveItem(targetPlayer, 116, weaponID .. ":" .. ammo .. ":" .. getWeaponNameFromID(weaponID) .. " Mermisi")
						if give then
							exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "GIVEBULLETS " .. getWeaponNameFromID(weaponID) .. " " .. tostring(bullets))
							count = count + 1
						else
							fails = fails + 1
						end
					end

					if count > 0 then
						local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)
						if (hiddenAdmin==0) then
							--Inform Spawner
							outputChatBox("[MAKEAMMO] You have given (x" .. count .. ") " .. getWeaponNameFromID(weaponID) .. " ammopacks (" .. ammo .. " bullets each) to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
							--Inform Player
							outputChatBox("You've received (x" .. count .. ") " .. getWeaponNameFromID(weaponID) .. " ammopacks (" .. ammo .. " bullets each) from " .. adminTitle .. " " .. getPlayerName(thePlayer), targetPlayer, 0, 255, 0)
							--Send adm warning
							exports.cr_global:sendMessageToAdmins("[ADM] " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave (x" .. count .. ") " .. getWeaponNameFromID(weaponID) .. " ammopacks (" .. ammo .. " bullets each) to " .. targetPlayerName)
							exports.cr_discord:sendMessage("makeammo-log","**[MAKEAMMO]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** adlı kişiye **(" .. ammo .. ")** jarjör **(" ..  getWeaponNameFromID(weaponID) .. ")** mermisi verdi.")
						else -- If Gizli Yetkili
							exports.cr_discord:sendMessage("makeammo-log","**[MAKEAMMO]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** adlı kişiye **(" .. ammo .. ")** jarjör **(" ..  getWeaponNameFromID(weaponID) .. ")** mermisi verdi.")
							outputChatBox("[MAKEAMMO] You have given (x" .. count .. ") " .. getWeaponNameFromID(weaponID) .. " ammopacks (" .. ammo .. " bullets each) to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
							--Inform Player
							outputChatBox("You've received (x" .. count .. ") " .. getWeaponNameFromID(weaponID) .. " ammopacks (" .. ammo .. " bullets each) from Gizli Yetkili.", targetPlayer, 0, 255, 0)
						end
					end
					if fails > 0 then
						outputChatBox("[MAKEAMMO] " .. fails .. " ammopacks couldn't be created. Player's " ..  error  .. ".", thePlayer, 255, 0, 0)
						outputChatBox("[ERROR] " .. fails .. " ammopacks couldn't be received from Admin. Your " ..  error  .. ".", targetPlayer, 255, 0, 0)
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("makeammo", givePlayerGunAmmo, false, false)
addEvent("onMakeAmmo", true)
addEventHandler("onMakeAmmo", getRootElement(), givePlayerGunAmmo)

function getAmmoPerClip(id)
	if id == 0 then
		return tostring(get(getResourceName(getThisResource()).. '.fist'))
	elseif id == 1 then
		return tostring(get(getResourceName(getThisResource()).. '.brassknuckle'))
	elseif id == 2 then
		return tostring(get(getResourceName(getThisResource()).. '.golfclub'))
	elseif id == 3 then
		return tostring(get(getResourceName(getThisResource()).. '.nightstick'))
	elseif id == 4 then
		return tostring(get(getResourceName(getThisResource()).. '.knife'))
	elseif id == 5 then
		return tostring(get(getResourceName(getThisResource()).. '.bat'))
	elseif id == 6 then
		return tostring(get(getResourceName(getThisResource()).. '.shovel'))
	elseif id == 7 then
		return tostring(get(getResourceName(getThisResource()).. '.poolstick'))
	elseif id == 8 then
		return tostring(get(getResourceName(getThisResource()).. '.katana'))
	elseif id == 9 then
		return tostring(get(getResourceName(getThisResource()).. '.chainsaw'))
	elseif id == 10 then
		return tostring(get(getResourceName(getThisResource()).. '.dildo'))
	elseif id == 11 then
		return tostring(get(getResourceName(getThisResource()).. 'dildo2'))
	elseif id == 12 then
		return tostring(get(getResourceName(getThisResource()).. '.vibrator'))
	elseif id == 13 then
		return tostring(get(getResourceName(getThisResource()).. '.vibrator2'))
	elseif id == 14 then
		return tostring(get(getResourceName(getThisResource()).. '.flower'))
	elseif id == 15 then
		return tostring(get(getResourceName(getThisResource()).. '.cane'))
	elseif id == 16 then
		return tostring(get(getResourceName(getThisResource()).. '.grenade'))
	elseif id == 17 then
		return tostring(get(getResourceName(getThisResource()).. '.teargas'))
	elseif id == 18 then
		return tostring(get(getResourceName(getThisResource()).. '.molotov'))
	elseif id == 22 then
		return tostring(get(getResourceName(getThisResource()).. '.colt45'))
	elseif id == 23 then
		return tostring(get(getResourceName(getThisResource()).. '.silenced'))
	elseif id == 24 then
		return tostring(get(getResourceName(getThisResource()).. '.deagle'))
	elseif id == 25 then
		return tostring(get(getResourceName(getThisResource()).. '.shotgun'))
	elseif id == 26 then
		return tostring(get(getResourceName(getThisResource()).. '.sawed-off'))
	elseif id == 27 then
		return tostring(get(getResourceName(getThisResource()).. '.combatshotgun'))
	elseif id == 28 then
		return tostring(get(getResourceName(getThisResource()).. '.uzi'))
	elseif id == 29 then
		return tostring(get(getResourceName(getThisResource()).. '.mp5'))
	elseif id == 30 then
		return tostring(get(getResourceName(getThisResource()).. '.ak-47'))
	elseif id == 31 then
		return tostring(get(getResourceName(getThisResource()).. '.m4'))
	elseif id == 32 then
		return tostring(get(getResourceName(getThisResource()).. '.tec-9'))
	elseif id == 33 then
		return tostring(get(getResourceName(getThisResource()).. '.rifle'))
	elseif id == 34 then
		return tostring(get(getResourceName(getThisResource()).. '.sniper'))
	elseif id == 35 then
		return tostring(get(getResourceName(getThisResource()).. '.rocketlauncher'))
	elseif id == 41 then
		return tostring(get(getResourceName(getThisResource()).. '.spraycan'))
	elseif id == 42 then
		return tostring(get(getResourceName(getThisResource()).. '.fireextinguisher'))
	elseif id == 43 then
		return tostring(get(getResourceName(getThisResource()).. '.camera'))
	elseif id == 44 then
		return tostring(get(getResourceName(getThisResource()).. '.nightvision'))
	elseif id == 45 then
		return tostring(get(getResourceName(getThisResource()).. '.infrared'))
	elseif id == 46 then -- Parachute
		return tostring(get(getResourceName(getThisResource()).. '.parachute'))	
	else
		return "disabled"
	end
	return "disabled"
end
addEvent("onGetAmmoPerClip", true)
addEventHandler("onGetAmmoPerClip", getRootElement(), getAmmoPerClip)

function givePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if exports.cr_integration:isPlayerAdministrator(thePlayer) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Item ID] [Item Değeri]", thePlayer, 255, 194, 14)
		else
			itemID = tonumber(itemID)

			if (itemID == 169 or itemID == 150) and getElementData(thePlayer, "account:id") ~= 1 then
				outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
				return false
			end

			if (itemID == 74 or itemID == 150 or itemID == 75 or itemID == 78 or itemID == 2) and not exports.cr_integration:isPlayerHeadAdmin(thePlayer) then -- Banned Items
				----exports.cr_hud:sendBottomNotification(thePlayer, "Banned Items", "Only Lead+ Admin can spawn this kind of item.")
				return false
			end
			local itemValue = table.concat({...}, " ")
			itemValue = tonumber(itemValue) or itemValue

			if itemID == 114 and exports['cr_shop-system']:getDisabledUpgrades()[tonumber(itemValue)] then
				outputChatBox("This item is temporarily disabled.", thePlayer, 255, 0, 0)
				return false
			end
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			local preventSpawn = exports["cr_items"]:getItemPreventSpawn(itemID, itemValue)
			if preventSpawn then
				----exports.cr_hud:sendBottomNotification(thePlayer, "Non-Spawnable Item", "This item cannot be spawned. It might be temporarily restricted or only obtainable IC.")
				return false
			end

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (itemID == 84) and not exports.cr_integration:isPlayerGameAdmin(thePlayer) then
				elseif itemID == 114 and not exports.cr_integration:isPlayerHeadAdmin(thePlayer) then
				elseif (itemID == 115 or itemID == 116 or itemID == 68 or itemID == 134 --[[or itemID == 137)]]) then
					outputChatBox("[!] [!]#FFFFFF Üzgünüm, bu eşya için /giveitem kullanamazsınız.", thePlayer, 255, 0, 0, true)
				elseif (logged==0) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				elseif (logged==1) then
					local name = call(getResourceFromName("cr_items"), "getItemName", itemID, itemValue)

					if itemID > 0 and name and name ~= "?" then
						local success, reason = exports.cr_global:giveItem(targetPlayer, itemID, itemValue)
						local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)
						if success then
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli kişiye " .. name .. " adlı eşya " .. itemValue .. " adet verildi.", thePlayer, 0, 255, 0, true)
							exports.cr_discord:sendMessage("giveitem-log","**[GIVEITEM]** **" ..  tostring(adminTitle) .. " " ..  getPlayerName(thePlayer)  .. "** isimli yetkili **" ..  targetPlayerName  .. "** isimli kişiye **(" ..  name  .. " - " .. itemValue .. ")** verdi.")
					
							triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)
							if (hiddenAdmin==0) then
								outputChatBox("[!]#FFFFFF " ..  tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " isimli yetkili sana " .. name .. " adlı eşyayı " .. itemValue .. " adet verdi.", targetPlayer, 0, 255, 0, true)
							else
								outputChatBox("[!]#FFFFFF Gizli yetkili " .. name .. " adlı eşyayı " .. itemValue .. " adet olarak verdi.", targetPlayer, 0, 255, 0, true)
							end
						else
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " adlı kişiye " .. name .. " adlı eşya verilemedi. Sebep: (" .. tostring(reason) .. ")", thePlayer, 255, 0, 0, true)
						end
					else
						outputChatBox("[!]#FFFFFF Geçersiz ID.", thePlayer, 255, 0, 0, true)
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("giveitem", givePlayerItem, false, false)

function givePedItem(thePlayer, commandName, ped, itemID, ...)
	if exports.cr_integration:isPlayerAdministrator(thePlayer) then
		if not (itemID) or not (...) or not (ped) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Ped dbid] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			if ped then
				--local logged = getElementData(targetPlayer, "loggedin")
				local element = exports.cr_pool:getElement("ped", tonumber(ped))
				local pedname = getElementData(element, "rpp.npc.name")
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue
				
				if (itemID == 74 or itemID == 150 or itemID == 75 or itemID == 78 or itemID == 2) and not exports.cr_integration:isPlayerHeadAdmin(thePlayer) then -- Banned Items
					----exports.cr_hud:sendBottomNotification(thePlayer, "Banned Items", "Only Lead+ Admin can spawn this kind of item.")
					return false
				elseif (itemID == 84) and not exports.cr_global:isPlayerGameAdmin(thePlayer) then
				elseif itemID == 114 and not exports.cr_global:isPlayerHeadAdmin(thePlayer) then
				--elseif (itemID == 115 or itemID == 116) then
				--	outputChatBox("Not possible to use this item with /giveitem, sorry.", thePlayer, 255, 0, 0)
				else
					local name = call(getResourceFromName("cr_items"), "getItemName", itemID, itemValue)
					
					if itemID > 0 and name and name ~= "?" then
						local success, reason = exports.cr_global:giveItem(element, itemID, itemValue)
						if success then
							outputChatBox("Ped " .. tostring(pedname) or "" .. " (" ..  tostring(ped)  .. ") now has a " .. name .. " with value " .. itemValue .. ".", thePlayer, 0, 255, 0)
							exports.cr_logs:dbLog(thePlayer, 4, ped, "GIVEITEM " .. name .. " " .. tostring(itemValue))
							if element then
								exports['cr_items']:npcUseItem(element, itemID)
							else
								outputChatBox("Failed to get ped element from dbid.", thePlayer, 255, 255, 255)
							end
						else
							outputChatBox("Couldn't give ped " .. tostring(ped) .. " a " .. name .. ": " .. tostring(reason), thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("givepeditem", givePedItem, false, false)

function makeGenericItem(thePlayer, commandName, price, quantity, ...)
	if exports.cr_integration:isPlayerAdministrator(thePlayer) then
		if not (price) or not (...) or not tonumber(price) or not (tonumber(price) > 0) or not (quantity) or not (tonumber(quantity) > 0) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Price] [Quantity, max=10] [Name:ObjectModel]", thePlayer, 255, 194, 14)
			outputChatBox("This command creates to yourself a generic item after taking away an amount of money as item's value.", thePlayer, 200, 200, 200)
			outputChatBox("Maximum quantity is 10. Will be spawned until you reach maximum weight.", thePlayer, 200, 200, 200)
		else
			if (tonumber(quantity) > 11) then
				outputChatBox("Your quantity was above 10. 10 have been requested.", thePlayer, 255, 0, 0)
				quantity = 10
			end
			local itemValue = table.concat({...}, " ")
			price = tonumber(price) * tonumber(quantity)
			local fPrice = exports.cr_global:formatMoney(price)
			if not exports.cr_global:takeMoney(thePlayer, price) then
				outputChatBox("You could not afford $" .. fPrice .. " for a '" .. itemValue .. "'.", thePlayer, 255, 0, 0)
				return false
			end

			local success, reason = setTimer (function ()
				exports.cr_global:giveItem(thePlayer, 80, itemValue)
			end, 250, quantity)
			if success then
				local playerName = exports.cr_global:getAdminTitle1(thePlayer)
				exports.cr_global:sendWrnToStaff(playerName .. " has created " .. quantity .. " '" .. itemValue .. "' to themselves for $" .. fPrice .. " (total: " .. tonumber(quantity)*tonumber(fPrice) .. "$).", "MAKEGENERIC")

				exports.cr_logs:dbLog(thePlayer, 4, thePlayer, commandName .. " x" .. quantity .. " " .. itemValue .. " for " .. fPrice)
				triggerClientEvent(thePlayer, "item:updateclient", thePlayer)
				return true
			else
				outputChatBox("Failed to created generic item. Reason: " .. tostring(reason), thePlayer, 255, 0, 0)
				return false
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("makegenericitem", makeGenericItem, false, false)
addCommandHandler("makegeneric", makeGenericItem, false, false)

function takePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if exports.cr_integration:isPlayerAdministrator(thePlayer) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue

				if (logged==0) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				elseif (logged==1) then
					if exports.cr_global:hasItem(targetPlayer, itemID, itemValue) then
						outputChatBox("You took item " .. itemID .. " with the value of (" .. itemValue .. ") from " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						exports.cr_global:takeItem(targetPlayer, itemID, itemValue)
						exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "TAKEITEM " .. tostring(itemID) .. " " .. tostring(itemValue))

						triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
					else
						outputChatBox("Player doesn't have that item", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("takeitem", takePlayerItem, false, false)

function setPlayerHealth(thePlayer, commandName, targetPlayer, health)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		if not tonumber(health) or not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Health]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				if tonumber(health) < getElementHealth(targetPlayer) and getElementData(thePlayer, "admin_level") < getElementData(targetPlayer, "admin_level") then
					outputChatBox("Nah.", thePlayer, 255, 0, 0)
				elseif not setElementHealth(targetPlayer, tonumber(health)) then
					outputChatBox("Invalid health value.", thePlayer, 255, 0, 0)
				else
					outputChatBox("Player " .. targetPlayerName .. " has received " .. health .. " Health.", thePlayer, 0, 255, 0)
					triggerEvent("onPlayerHeal", targetPlayer, true)
					exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "SETHP " .. health)
					exports.cr_discord:sendMessage("sethp-log","**[SETHP]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** adlı karakterin sağlık durumunu **(" .. health .. ")** olarak güncelledi.")
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("sethp", setPlayerHealth, false, false)

function adminHeal(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerHelper(thePlayer) or exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		local health = 100
		local targetPlayerName = getPlayerName(thePlayer):gsub("_", " ")
		if not (targetPlayer) then
			targetPlayer = thePlayer
		else
			targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		end

		if targetPlayer then
			setElementHealth(targetPlayer, tonumber(health))
			setElementData(targetPlayer, "hunger", 100)
			setElementData(targetPlayer, "thirst", 100)
			setElementData(targetPlayer, "poop", 100)
			setElementData(targetPlayer, "pee", 100)
			outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun ihtiyaçları fullendi.", thePlayer, 0, 255, 0, true)
			outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin ihtiyaçlarınızı fulledi.", targetPlayer, 0, 0, 255, true)
			triggerEvent("onPlayerHeal", targetPlayer, true)
			exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "AHEAL " .. health)
			exports.cr_discord:sendMessage("aheal-log","**[AHEAL]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** adlı karakterin açlık ve susuzluk ihtiyaçlarını fulledi.")
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("aheal", adminHeal, false, false)

function setPlayerArmour(thePlayer, theCommand, targetPlayer, armor)
	if (exports.cr_integration:isPlayerHeadAdmin(thePlayer)) then
		if not (targetPlayer) or not (armor) then
			outputChatBox("KULLANIM: /" .. theCommand .. " [Karakter Adı / ID] [Armor]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==1) then
					if (tostring(type(tonumber(armor))) == "number") then
						local targetPlayerFaction = getElementData(targetPlayer, "faction")
						if (targetPlayerFaction == 1) or (targetPlayerFaction == 15) or (targetPlayerFaction == 59) then
							local setArmor = setPedArmor(targetPlayer, tonumber(armor))
							outputChatBox("Player " .. targetPlayerName .. " has received " .. armor .. " Armor.", thePlayer, 0, 255, 0)
							exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "SETARMOR " ..tostring(armor))
						elseif (targetPlayerFaction ~= 1) or (targetPlayerFaction ~= 15) or (targetPlayerFaction ~= 59) then
							if (exports.cr_integration:isPlayerGameAdmin(thePlayer)) then
								local setArmor = setPedArmor(targetPlayer, tonumber(armor))
								outputChatBox("Player " .. targetPlayerName .. " has received " .. armor .. " Armor.", thePlayer, 0, 255, 0)
								exports.cr_logs:dbLog(thePlayer, 4, tagetPlayer, "SETARMOR " ..tostring(armor))
								exports.cr_discord:sendMessage("setarmor-log","**[SETARMOR]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** adlı karakterin zırh durumunu **(" .. armor .. ")** olarak güncelledi.")
							else
								outputChatBox("This player is not in a law enforcement faction. Contact a lead+ administrator to set armor.", thePlayer, 255, 0, 0)
							end
						end
					else
						outputChatBox("Invalid armor value.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi", thePlayer, 255, 0, 0)
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setarmor", setPlayerArmour, false, false)

function setPlayerSkinCmd(thePlayer, commandName, targetPlayer, skinID, clothingID)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		if not (skinID) or not (targetPlayer) then -- Clothing ID is a optional argument
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Skin ID] (Clothing ID)", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged == 0) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				elseif tostring(type(tonumber(skinID))) == "number" and tonumber(skinID) ~= 0 then
					local fat = getPedStat(targetPlayer, 21)
					local muscle = getPedStat(targetPlayer, 23)

					setPedStat(targetPlayer, 21, 0)
					setPedStat(targetPlayer, 23, 0)
					local oldSkin = getElementModel(targetPlayer)
					local skin = setElementModel(targetPlayer, tonumber(skinID))

					setPedStat(targetPlayer, 21, fat)
					setPedStat(targetPlayer, 23, muscle)

					if not (skin) and tonumber(oldSkin) ~= tonumber(skin) then
						outputChatBox("[!]#FFFFFF Geçersiz Skin ID.", thePlayer, 255, 0, 0, true)
					else
						if not tonumber(clothingID) then
							clothingID = nil
						end

						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun skinini değiştirdin.", thePlayer, 0, 255, 0, true)
						setElementData(targetPlayer, "skin", tonumber(skinID))
						dbExec(mysql:getConnection(), "UPDATE characters SET skin = " .. (skinID) .. " WHERE id = " .. (getElementData(targetPlayer, "dbid")))
						exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "SETSKIN " .. tostring(skinID) .. " CLOTHING " .. tostring(clothingID))
					end
				else
					outputChatBox("[!]#FFFFFF Geçersiz Skin ID.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setskin", setPlayerSkinCmd, false, false)

function asetPlayerName(thePlayer, commandName, targetPlayer, ...)
	if exports.cr_integration:isPlayerHeadAdmin(thePlayer) then
		if not (...) or not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Player New Nick]", thePlayer, 255, 194, 14)
		else
			local newName = table.concat({...}, "_")
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local hoursPlayed = getElementData(targetPlayer, "hoursplayed")
				if hoursPlayed > 5 and not exports.cr_integration:isPlayerGameAdmin(thePlayer) then
					outputChatBox("Only Regular Admin or higher up can change character name which is older than 5 hours.", thePlayer, 255, 0, 0)
					return false
				end
				if newName == targetPlayerName then
					outputChatBox("The player's name is already that.", thePlayer, 255, 0, 0)
				else
					local dbid = getElementData(targetPlayer, "dbid")
					
					setElementData(targetPlayer, "legitnamechange", 1)
					local name = setPlayerName(targetPlayer, tostring(newName))

					if (name) then
						exports['cr_cache']:clearCharacterName(dbid)
						dbExec(mysql:getConnection(), "UPDATE characters SET charactername='" .. (newName) .. "' WHERE id = " .. (dbid))
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

						local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)
						local processedNewName = string.gsub(tostring(newName), "_", " ")
						if (hiddenAdmin==0) then
							exports.cr_global:sendMessageToAdmins("[ADM] " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " changed " .. targetPlayerName .. "'s Name to " .. newName .. ".")
							outputChatBox("You character's name has been changed from '" .. targetPlayerName .. "' to '" .. tostring(newName) .. "' by " .. adminTitle .. " " .. getPlayerName(thePlayer) .. ".", targetPlayer, 0, 255, 0)
							exports.cr_discord:sendMessage("changename-log","**[CHANGENAME]** **" .. adminTitle .. " " .. getPlayerName(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** ismini **(" .. newName .. ")** olarak güncelledi.")
						else
							outputChatBox("You character's name has been changed from '" .. targetPlayerName .. "' to " .. processedNewName .. "' by Gizli Yetkili.", targetPlayer, 0, 255, 0)
						exports.cr_discord:sendMessage("changename-log","**[CHANGENAME]** **" .. adminTitle .. " " .. getPlayerName(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** ismini **(" .. newName .. ")** olarak güncelledi.")
						end
						outputChatBox("You changed " .. targetPlayerName .. "'s name to '" .. processedNewName .. "'.", thePlayer, 0, 255, 0)

						setElementData(targetPlayer, "legitnamechange", 0)
					else
						outputChatBox("Failed to change name.", thePlayer, 255, 0, 0)
					end
					setElementData(targetPlayer, "legitnamechange", 0)
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("changename", asetPlayerName, false, false)

function hideAdmin(thePlayer, commandName)
	if exports.cr_integration:isPlayerManagement(thePlayer) then
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		local adminTitle = exports.cr_global:getPlayerFullAdminTitle(thePlayer)
	
		if (hiddenAdmin == 0) then
			setElementData(thePlayer, "hiddenadmin", 1, true)
			outputChatBox("[!]#FFFFFF Gizli yetkili görevini başarıyla açıldı.", thePlayer, 0, 255, 0, true)
			exports.cr_global:sendMessageToAdmins("[ADM] " .. adminTitle .. " isimli yetkili gizli yetkili görevini açtı.")
		elseif (hiddenAdmin == 1) then
			setElementData(thePlayer, "hiddenadmin", 0, true)
			outputChatBox("[!]#FFFFFF Gizli yetkili görevini başarıyla kapatıldı.", thePlayer, 255, 0, 0, true)
			exports.cr_global:sendMessageToAdmins("[ADM] " .. adminTitle .. " isimli yetkili gizli yetkili görevini kapattı.")
		end
		
		exports.cr_global:updateNametagColor(thePlayer)
		dbExec(mysql:getConnection(), "UPDATE accounts SET hiddenadmin = " .. (getElementData(thePlayer, "hiddenadmin")) .. " WHERE id = " .. (getElementData(thePlayer, "account:id")))
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("hideadmin", hideAdmin, false, false)

function slapPlayer(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local thePlayerPower = exports.cr_global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.cr_global:getPlayerAdminLevel(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				elseif (targetPlayerPower > thePlayerPower) then
					outputChatBox("You cannot slap this player as they are a higher admin rank then you.", thePlayer, 255, 0, 0)
				else
					local x, y, z = getElementPosition(targetPlayer)

					if (isPedInVehicle(targetPlayer)) then
						setElementData(targetPlayer, "realinvehicle", 0, false)
						removePedFromVehicle(targetPlayer)
					end
					detachElements(targetPlayer)

					setElementPosition(targetPlayer, x, y, z+15)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

					if (hiddenAdmin==0) then
						local adminTitle = exports.cr_global:getPlayerFullAdminTitle(thePlayer)
						exports.cr_global:sendMessageToAdmins("[ADM] " .. tostring(adminTitle) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu slapladı.")
						exports.cr_discord:sendMessage("slap-log","**[SLAP]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuyu slapladı.")
					end
					exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "SLAP")
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("slap", slapPlayer, false, false)

function setMoney(thePlayer, commandName, target, money, ...)
	if exports.cr_integration:isPlayerManagement(thePlayer) then
		if not (target) or not money or not tonumber(money) or not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar] [Açıklama]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				money = tonumber(money) or 0
				if money and money > 100000000 then
					outputChatBox("[!]#FFFFFF Güvenlik nedeniyle, bir oyuncuya tek seferde yalnızca 10,000,000$'ın altında para vermenize izin verilmektedir.", thePlayer, 255, 0, 0, true)
					return false
				end

				if not exports.cr_global:setMoney(targetPlayer, money) then
					outputChatBox("Could not set that amount.", thePlayer, 255, 0, 0)
					return false
				end

				exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "SETMONEY " .. money)


				local amount = exports.cr_global:formatMoney(money)
				reason = table.concat({...}, " ")
				outputChatBox("#f0f0f0(( " .. targetPlayerName .. " isimli oyuncunun parası " .. amount .. "$ olarak ayarlanmıştır. ))", thePlayer, 0, 255, 0, true)
				outputChatBox("#f0f0f0(( " .. username .. " isimli yetkili paranızı " .. amount .. "$ olarak değiştirdi. ))", targetPlayer, 0, 255, 0, true)
				outputChatBox("#f0f0f0(( Gerekçe: " .. reason .. " ))", targetPlayer, 0, 255, 0, true)
				exports.cr_discord:sendMessage("givemoney-log","**[SETMONEY]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli kişinin parasını **(" .. amount .. "$)** olarak güncelledi.")
				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = mysql:escape_string(targetUsername)
				local targetCharacterName = mysql:escape_string(targetPlayerName)


				if tonumber(money) >= 5000 then
					exports.cr_global:sendMessageToAdmins("[SETMONEY] Yetkili " .. username .. " (" .. targetUsername .. ") " .. targetCharacterName .. " isimli oyuncunun parasını " .. amount .. "$ olarak değiştirmiştir. (Gerekçe: " .. reason .. ").")
				else
					exports.cr_global:sendMessageToAdmins("[SETMONEY] Yetkili " .. username .. " (" .. targetUsername .. ") " .. targetCharacterName .. " isimli oyuncunun parasını " .. amount .. "$ olarak değiştirmiştir. (Gerekçe: " .. reason .. ").")
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setmoney", setMoney, false, false)

function giveMoney(thePlayer, commandName, target, money, ...) 
	if exports.cr_integration:isPlayerManagement(thePlayer) then
		if not (target) or not money or not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar] [Açıklama]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				money = tonumber(money) or 0
				if money and money > 100000000 then
					outputChatBox("[!]#FFFFFF Güvenlik nedeniyle, bir oyuncuya tek seferde yalnızca 100,000,000$'ın altında para vermenize izin verilmektedir.", thePlayer, 255, 0, 0, true)
					return false
				end

				if not exports.cr_global:giveMoney(targetPlayer, money) then
					outputChatBox("Could not give player that amount.", thePlayer, 255, 0, 0)
					return false
				end

				exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "GIVEMONEY " ..money)

				local amount = exports.cr_global:formatMoney(money)
				reason = table.concat({...}, " ")
				outputChatBox("You have given " .. targetPlayerName .. " $" .. amount .. ".", thePlayer)
				outputChatBox("Admin " .. username .. " has given you: $" .. amount .. ".", targetPlayer)
				outputChatBox("Reason: " .. reason .. ".", targetPlayer)
				exports.cr_discord:sendMessage("givemoney-log","**[GIVEMONEY]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli kişiye **(" .. amount .. "$)** para oluşturdu.")

				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = mysql:escape_string(targetUsername)
				local targetCharacterName = mysql:escape_string(targetPlayerName)


				if tonumber(money) >= 5000 then
					exports.cr_global:sendMessageToAdmins("[GIVEMONEY] Admin " .. username .. " has given (" .. targetUsername .. ") " .. targetCharacterName .. " $" .. amount .. " (" .. reason .. ")")
				else
					exports.cr_global:sendMessageToAdmins("[GIVEMONEY] Admin " .. username .. " has given (" .. targetUsername .. ") " .. targetCharacterName .. " $" .. amount .. " (" .. reason .. ")")
				end

			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("givemoney", giveMoney, false, false)

function freezePlayer(thePlayer, commandName, target)
	if (exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer)) then
		if not (target) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)
				local veh = getPedOccupiedVehicle(targetPlayer)
				if (veh) then
					setElementFrozen(veh, true)
					toggleAllControls(targetPlayer, false, true, false)
					outputChatBox(" You have been frozen by an " ..  textStr  .. ". Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				else
					detachElements(targetPlayer)
					toggleAllControls(targetPlayer, false, true, false)
					setElementFrozen(targetPlayer, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					setPedWeaponSlot(targetPlayer, 0)
					setElementData(targetPlayer, "freeze", 1, false)
					outputChatBox(" You have been frozen by an " ..  textStr  .. ". Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				end

				local username = getPlayerName(thePlayer)
				exports.cr_global:sendMessageToAdmins("[ADM] " .. tostring(adminTitle) .. " " .. username .. " froze " .. targetPlayerName .. ".")
				exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "FREEZE")
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("freeze", freezePlayer, false, false)
addEvent("remoteFreezePlayer", true)
addEventHandler("remoteFreezePlayer", getRootElement(), freezePlayer)

function unfreezePlayer(thePlayer, commandName, target)
	if (exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer)) then
		if not (target) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)

				local veh = getPedOccupiedVehicle(targetPlayer)
				if (veh) then
					setElementFrozen(veh, false)
					toggleAllControls(targetPlayer, true, true, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					if (isElement(targetPlayer)) then
						outputChatBox(" You have been unfrozen by an " ..  textStr  .. ". Thanks for your co-operation.", targetPlayer)
					end

					if (isElement(thePlayer)) then
						outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
					end
				else
					toggleAllControls(targetPlayer, true, true, true)
					setElementFrozen(targetPlayer, false)
					-- Disable weapon scrolling if restrained
					if getElementData(targetPlayer, "restrain") == 1 then
						setPedWeaponSlot(targetPlayer, 0)
						toggleControl(targetPlayer, "next_weapon", false)
						toggleControl(targetPlayer, "previous_weapon", false)
					end
					setElementData(targetPlayer, "freeze", false, false)
					outputChatBox(" You have been unfrozen by an " ..  textStr  .. ". Thanks for your co-operation.", targetPlayer)
					outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
				end

				local username = getPlayerName(thePlayer)
				exports.cr_global:sendMessageToAdmins("[ADM] " .. tostring(adminTitle) .. " " .. username .. " unfroze " .. targetPlayerName .. ".")
				exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "UNFREEZE")
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("unfreeze", unfreezePlayer, false, false)

function adminDuty(thePlayer)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		local adminduty = getElementData(thePlayer, "duty_admin") or 0
		if adminduty == 1 then
			setElementData(thePlayer, "duty_admin", 0)
			exports.cr_global:updateNametagColor(thePlayer)
			exports.cr_global:sendMessageToAdmins("[ADUTY] " .. getPlayerName(thePlayer):gsub("_", " ") .. " görevden ayrıldı.")
		else
			setElementData(thePlayer, "duty_admin", 1)
			exports.cr_global:updateNametagColor(thePlayer)
			exports.cr_global:sendMessageToAdmins("[ADUTY] " .. getPlayerName(thePlayer):gsub("_", " ") .. " göreve başladı.")
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("adminduty", adminDuty, false, false)
addCommandHandler("aduty", adminDuty, false, false)
addEvent("admin-system:adminduty", true)
addEventHandler("admin-system:adminduty", getRootElement(), adminDuty)

function gmDuty(thePlayer)
	if exports.cr_integration:isPlayerHelper(thePlayer) then
		local gmDuty = getElementData(thePlayer, "duty_supporter") or 0
		if gmDuty == 1 then
			setElementData(thePlayer, "duty_supporter", 0)
			exports.cr_global:updateNametagColor(thePlayer)
			exports.cr_global:sendMessageToAdmins("[GDUTY] " .. getPlayerName(thePlayer):gsub("_", " ") .. " görevden ayrıldı.")
		else
			setElementData(thePlayer, "duty_supporter", 1)
			exports.cr_global:updateNametagColor(thePlayer)
			exports.cr_global:sendMessageToAdmins("[GDUTY] " .. getPlayerName(thePlayer):gsub("_", " ") .. " göreve başladı.")
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("sduty", gmDuty, false, false)
addCommandHandler("gduty", gmDuty, false, false)
addEvent("admin-system:gmduty", true)
addEventHandler("admin-system:gmduty", getRootElement(), gmDuty)

function vehicleLimit(admin, command, player, limit)
	if exports.cr_integration:isPlayerManagement(admin) then
		if (not player and not limit) then
			outputChatBox("KULLANIM: /" .. command .. " [Karakter Adı / ID] [Limit]", admin, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(admin, player)
			if (tplayer) then
				local query = mysql:query_fetch_assoc("SELECT maxvehicles FROM characters WHERE id = " .. (getElementData(tplayer, "dbid")))
				if (query) then
					local oldvl = query["maxvehicles"]
					local newl = tonumber(limit)
					if (newl) then
						if (newl>0) then
							dbExec(mysql:getConnection(), "UPDATE characters SET maxvehicles = " .. (newl) .. " WHERE id = " .. (getElementData(tplayer, "dbid")))

							setElementData(tplayer, "maxvehicles", newl, false)

							outputChatBox("You have set " .. targetPlayerName:gsub("_", " ") .. " vehicle limit to " .. newl .. ".", admin, 255, 194, 14)
							outputChatBox("Admin " .. getPlayerName(admin):gsub("_"," ") .. " has set your vehicle limit to " .. newl .. ".", tplayer, 255, 194, 14)

							exports.cr_logs:dbLog(admin, 4, tplayer, "SETVEHLIMIT " .. oldvl .. " " .. newl)
						else
							outputChatBox("You can not set a level below 0", admin, 255, 194, 14)
						end
					end
				end
			else
				outputChatBox("Something went wrong with picking the player.", admin)
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", admin, 255, 0, 0, true)
		playSoundFrontEnd(admin, 4)
	end
end
addCommandHandler("setvehlimit", vehicleLimit)

function intLimit(admin, command, player, limit)
	if exports.cr_integration:isPlayerManagement(admin) then
		if (not player and not limit) then
			outputChatBox("KULLANIM: /" .. command .. " [Karakter Adı / ID] [Limit]", admin, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(admin, player)
			if (tplayer) then
				local query = mysql:query_fetch_assoc("SELECT `maxinteriors` FROM `characters` WHERE `id` = " .. (getElementData(tplayer, "dbid")))
				if (query) then
					local oldvl = query["maxinteriors"]
					local newl = tonumber(limit)
					if (newl) then
						if (newl>0) then
							dbExec(mysql:getConnection(), "UPDATE `characters` SET `maxinteriors` = " .. (newl) .. " WHERE `id` = " .. (getElementData(tplayer, "dbid")))

							setElementData(tplayer, "maxinteriors", newl, false)

							outputChatBox("You have set " .. targetPlayerName:gsub("_", " ") .. " interior limit to " .. newl .. ".", admin, 255, 194, 14)
							outputChatBox("Admin " .. getPlayerName(admin):gsub("_"," ") .. " has set your interior limit to " .. newl .. ".", tplayer, 255, 194, 14)

							exports.cr_logs:dbLog(thePlayer, 4, tplayer, "SETINTLIMIT " .. oldvl .. " " .. newl)
						else
							outputChatBox("You can not set a level below 0", admin, 255, 194, 14)
						end
					end
				end
			else
				outputChatBox("Something went wrong with picking the player.", admin)
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setintlimit", intLimit)

function nudgePlayer(thePlayer, commandName, targetPlayer)
    if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
        if targetPlayer then
            local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
				if getElementData(targetPlayer, "loggedin") == 1 then
					outputChatBox("[!]#FFFFFF " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncu uyarıldı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi uyardı.", targetPlayer, 0, 0, 255, true)
					triggerClientEvent(targetPlayer, "nudge:sound", targetPlayer)
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
            else
                outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
            end
        else 
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
    else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("nudge", nudgePlayer)

function earthquake(thePlayer, commandName)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		local players = exports.cr_pool:getPoolElementsByType("player")
		for index, arrayPlayer in ipairs(players) do
			triggerClientEvent("doEarthquake", arrayPlayer)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("depremyarat", earthquake, false, false)

function asetPlayerAge(thePlayer, commandName, targetPlayer, age)
	if (exports.cr_integration:isPlayerGameAdmin(thePlayer)) then
		if not (age) or not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Age]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local dbid = getElementData(targetPlayer, "dbid")
			local ageint = tonumber(age)
			if (ageint>150) or (ageint<1) then
				outputChatBox("You cannot set the age to that.", thePlayer, 255, 0, 0)
			else
				dbExec(mysql:getConnection(), "UPDATE characters SET age='" .. (age) .. "' WHERE id = " .. (dbid))
				setElementData(targetPlayer, "age", tonumber(age), true)
				outputChatBox("You changed " .. targetPlayerName .. "'s age to " .. age .. ".", thePlayer, 0, 255, 0)
				outputChatBox("Your age was set to " .. age .. ".", targetPlayer, 0, 255, 0)
				exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, commandName .. " " .. age)
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setage", asetPlayerAge)

function asetPlayerHeight(thePlayer, commandName, targetPlayer, height)
	if (exports.cr_integration:isPlayerGameAdmin(thePlayer)) then
		if not (height) or not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Height (150 - 200)]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local dbid = getElementData(targetPlayer, "dbid")
			local heightint = tonumber(height)
			if (heightint>200) or (heightint<150) then
				outputChatBox("You cannot set the height to that.", thePlayer, 255, 0, 0)
			else
				dbExec(mysql:getConnection(), "UPDATE characters SET height='" .. (height) .. "' WHERE id = " .. (dbid))
				setElementData(targetPlayer, "height", height, true)
				outputChatBox("You changed " .. targetPlayerName .. "'s height to " .. height .. " cm.", thePlayer, 0, 255, 0)
				outputChatBox("Your height was set to " .. height .. " cm.", targetPlayer, 0, 255, 0)
				exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, commandName .. " " .. height)
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setheight", asetPlayerHeight)

function asetPlayerRace(thePlayer, commandName, targetPlayer, race)
	if (exports.cr_integration:isPlayerGameAdmin(thePlayer)) then
		if not (race) or not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [0= Black, 1= White, 2= Asian]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local dbid = getElementData(targetPlayer, "dbid")
			local raceint = tonumber(race)
			if (raceint>2) or (raceint<0) then
				outputChatBox("Error: Please chose either 0 for black, 1 for white, or 2 for asian.", thePlayer, 255, 0, 0)
			else
				dbExec(mysql:getConnection(), "UPDATE characters SET skincolor='" .. (race) .. "' WHERE id = " .. (dbid))
				if (raceint==0) then
					outputChatBox("You changed " .. targetPlayerName .. "'s race to black.", thePlayer, 0, 255, 0)
					outputChatBox("Your race was changed to black.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				elseif (raceint==1) then
					outputChatBox("You changed " .. targetPlayerName .. "'s race to white.", thePlayer, 0, 255, 0)
					outputChatBox("Your race was changed to white.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				elseif (raceint==2) then
					outputChatBox("You changed " .. targetPlayerName .. "'s race to asian.", thePlayer, 0, 255, 0)
					outputChatBox("Your race was changed to asian.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				end
				exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, commandName .. " " .. raceint)
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setrace", asetPlayerRace)

function asetPlayerGender(thePlayer, commandName, targetPlayer, gender)
	if (exports.cr_integration:isPlayerGameAdmin(thePlayer)) then
		if not (gender) or not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [0= Male, 1= Female]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local dbid = getElementData(targetPlayer, "dbid")
			local genderint = tonumber(gender)
			if (genderint>1) or (genderint<0) then
				outputChatBox("Error: Please choose either 0 for male, or 1 for female.", thePlayer, 255, 0, 0)
			else
				dbExec(mysql:getConnection(), "UPDATE characters SET gender='" .. (gender) .. "' WHERE id = " .. (dbid))
				setElementData(targetPlayer, "gender", gender, true)
				if (genderint==0) then
					outputChatBox("You changed " .. targetPlayerName .. "'s gender to Male.", thePlayer, 0, 255, 0)
					outputChatBox("Your gender was set to Male.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				elseif (genderint==1) then
					outputChatBox("You changed " .. targetPlayerName .. "'s gender to Female.", thePlayer, 0, 255, 0)
					outputChatBox("Your gender was set to Female.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				end
				exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, commandName .. " " .. genderint)
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setgender", asetPlayerGender)

function aSetDateOfBirth(thePlayer, commandName, targetPlayer, dob, mob)
	if (exports.cr_integration:isPlayerGameAdmin(thePlayer)) then
		local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if not (targetPlayer) or not dob or not mob then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Date] [Month]", thePlayer, 255, 194, 14)
		else
			if getElementData(targetPlayer, "loggedin") ~= 1 then
				outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				return false
			end

			if not tonumber(dob) or not tonumber(mob) then
				outputChatBox("Date and Month of birth must be numeric.", thePlayer, 255, 194, 14)
				return false
			else
				dob = tonumber(dob)
				mob = tonumber(mob)
			end

			local dbid = getElementData(targetPlayer, "dbid")
			if dbExec(mysql:getConnection(),"UPDATE `characters` SET `day`='" .. mysql:escape_string(dob) .. "', `month`='" .. mysql:escape_string(mob) .. "' WHERE id = '" .. mysql:escape_string(dbid) .. "' ") then
				setElementData(targetPlayer, "day", dob, true)
				setElementData(targetPlayer, "month", mob, true)
				outputDebugString(dob .. " " .. mob)
				outputChatBox("You changed " .. targetPlayerName .. "'s date of birth to " .. exports.cr_global:getPlayerDoB(targetPlayer) .. ".", thePlayer, 0, 255, 0)
				outputChatBox("Your date of birth was set to " .. exports.cr_global:getPlayerDoB(targetPlayer) .. ".", targetPlayer, 0, 255, 0)
				exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, commandName .. " " .. dob .. "/" .. mob)
			else
				outputChatBox("Failed to set DoB, DB error.", thePlayer, 0, 255, 0)
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setdob", aSetDateOfBirth)
addCommandHandler("setdateofbirth", aSetDateOfBirth)

function unRecovery(thePlayer, commandName, targetPlayer)
	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	if exports.cr_integration:isPlayerGameAdmin(thePlayer) or (factionType==4) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local dbid = getElementData(targetPlayer, "dbid")
			setElementFrozen(targetPlayer, false)
			dbExec(mysql:getConnection(),"UPDATE characters SET recovery='0' WHERE id = " .. dbid) -- Allow them to move, and revert back to recovery type set to 0.
			dbExec(mysql:getConnection(),"UPDATE characters SET recoverytime=NULL WHERE id = " .. dbid)
			exports.cr_global:sendMessageToAdmins("AdmWrn: " .. getPlayerName(targetPlayer):gsub("_"," ") .. " was removed from recovery by " .. getPlayerName(thePlayer):gsub("_"," ") .. ".")
			outputChatBox("You are no longer in recovery!", targetPlayer, 0, 255, 0) -- Let them know about it!
			exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "UNRECOVERY")
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("unrecovery", unRecovery)

function setPlayerInterior(thePlayer, commandName, targetPlayer, interiorID)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		local interiorID = tonumber(interiorID)
		if (not targetPlayer) or (not interiorID) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Interior ID]", thePlayer, 255, 194, 14, false)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged == 0) then
					outputChatBox("[*] Oyuncu henüz giriş yapmadı.", thePlayer, 255, 0, 0, false)
				else
					if (interiorID >= 0 and interiorID <= 255) then
						local username = getPlayerName(thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)
						setElementInterior(targetPlayer, interiorID)
						outputChatBox((hiddenAdmin == 0 and adminTitle .. " " .. username or "Gizli Yetkili") .. " has changed your interior ID to " .. tostring(interiorID) .. ".", targetPlayer)
						outputChatBox("You set " .. targetPlayerName .. (string.find(targetPlayerName, "s", -1) and "'" or "'s") .. " interior ID to " .. tostring(interiorID) .. ".", thePlayer)
						exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "PLAYER-SETINTERIOR " .. tostring(interiorID))
					else
						outputChatBox("Invalid interior ID (0-255).", thePlayer, 255, 0, 0, false)
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setint", setPlayerInterior, false, false)
addCommandHandler("setinterior", setPlayerInterior, false, false)

function setPlayerDimension(thePlayer, commandName, targetPlayer, dimensionID)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		local dimensionID = tonumber(dimensionID)
		if (not targetPlayer) or (not dimensionID) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dimension ID]", thePlayer, 255, 194, 14, false)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged == 0) then
					outputChatBox("[*] Oyuncu henüz giriş yapmadı.", thePlayer, 255, 0, 0, false)
				else
					if (dimensionID >= 0 and dimensionID <= 65535) then
						local username = getPlayerName(thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)
						setElementDimension(targetPlayer, dimensionID)
						outputChatBox((hiddenAdmin == 0 and adminTitle .. " " .. username or "Gizli Yetkili") .. " has changed your dimension ID to " .. tostring(dimensionID) .. ".", targetPlayer)
						outputChatBox("You set " .. targetPlayerName .. (string.find(targetPlayerName, "s", -1) and "'" or "'s") .. " dimension ID to " .. tostring(dimensionID) .. ".", thePlayer)
						exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "PLAYER-SETDIMENSION " .. tostring(dimensionID))
					else
						outputChatBox("Invalid dimension ID (0-65535).", thePlayer, 255, 0, 0, false)
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setdim", setPlayerDimension, false, false)
addCommandHandler("setdimension", setPlayerDimension, false, false)

function getPlayerID(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
	else
		local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, target)
		if targetPlayer then
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged == 1) then
				local id = getElementData(targetPlayer, "playerid")
				local level = getElementData(targetPlayer, "level")
				outputChatBox(">>#FFFFFF " .. targetPlayerName .. " isimli oyuncunun ID: " .. id .. " - Seviye: " .. level, thePlayer, 0, 255, 0, true)
			else
				outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("getid", getPlayerID, false, false)
addCommandHandler("id", getPlayerID, false, false)

function giveSuperman(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		if not targetPlayer then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if not targetPlayer then
				outputChatBox("Player not found.",thePlayer, 255,0,0)
				return false
			end
			local logged = getElementData(targetPlayer, "loggedin")
            if (logged==0) then
				outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
				return false
			end
			local dbid = getElementData(targetPlayer, "dbid")
			local canFly = getElementData(targetPlayer, "canFly")

			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)

			if not canFly then
				if setElementData(targetPlayer, "canFly", true) then
					outputChatBox("You have given " .. targetPlayerName .. " temporary ability to fly.", thePlayer, 0, 255, 0)
					if (hiddenAdmin==0) then
						outputChatBox(adminTitle .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " has given you temporary ability to fly.", targetPlayer, 0, 255, 0)
						outputChatBox("TIP: /superman or jump twice to fly.", targetPlayer, 255, 255, 0)
						outputChatBox("TIP: /freecam to enable freecam, /dropme to disable it.", targetPlayer, 255, 255, 0)
						exports.cr_global:sendMessageToAdmins("[ADMWARN] " .. adminTitle .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " has given " .. getPlayerName(targetPlayer):gsub("_"," ") .. " temporary ability to fly.")
					else
						outputChatBox("Gizli Yetkili has given you temporary ability to fly.", targetPlayer, 0, 255, 0)
						outputChatBox("TIP: /superman or jump twice to fly.", targetPlayer, 255, 255, 0)
						outputChatBox("TIP: /freecam to enable freecam, /dropme to disable it.", targetPlayer, 255, 255, 0)
						exports.cr_global:sendMessageToAdmins("[ADMWARN] Gizli Yetkili has given " .. getPlayerName(targetPlayer):gsub("_"," ") .. " temporary ability to fly.")
					end
					exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "GIVESUPERMAN")
				end
			else
				if setElementData(targetPlayer, "canFly", false) then
					outputChatBox("You have revoked from " .. targetPlayerName .. " temporary ability to fly.", thePlayer, 255, 0, 0)
					if (hiddenAdmin==0) then
						outputChatBox(adminTitle .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " has revoked from you temporary ability to fly.", targetPlayer, 255, 0, 0)
						exports.cr_global:sendMessageToAdmins("AdmWrn: " .. adminTitle .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " has revoked from " .. getPlayerName(targetPlayer):gsub("_"," ") .. " temporary ability to fly.")
					else
						outputChatBox("Gizli Yetkili have revoked from you temporary ability to fly.", targetPlayer, 255, 0, 0)
						exports.cr_global:sendMessageToAdmins("AdmWrn: Gizli Yetkili has revoked from " .. getPlayerName(targetPlayer):gsub("_"," ") .. " temporary ability to fly.")
					end
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler ("givesuperman", giveSuperman)

function sendPlayerToCity(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer) then
		if not targetPlayer then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local theVehicle = getPedOccupiedVehicle(targetPlayer)
				if theVehicle then
					setElementPosition(theVehicle, 1537.052734375, -1724.091796875, 13.546875)
					setElementInterior(theVehicle, 0)
					setElementDimension(theVehicle, 0)
				else 
					setElementPosition(targetPlayer, 1537.052734375, -1724.091796875, 13.546875)
					setElementInterior(targetPlayer, 0)
					setElementDimension(targetPlayer, 0)
				end
				
				outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncu şehre gönderildi.", thePlayer, 0, 255, 0, true)
				outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi şehre gönderdi.", targetPlayer, 0, 0, 255, true)
				
				exports.cr_discord:sendMessage("sehre-log", "**[SEHRE]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuyu şehre gönderdi.")
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("sehre", sendPlayerToCity, false, false)

function findCID(thePlayer, commandName, cid)
	if exports.cr_integration:isPlayerGameAdmin(thePlayer) then
		cid = tonumber(cid)
		if cid then
			if cid > 0 then
				dbQuery(function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							outputChatBox("[!]#FFFFFF Sonuç: " .. tostring(row["charactername"]):gsub("_", " ") .. " (" .. tostring(row["account"]) .. ")", thePlayer, 0, 255, 0, true)
						end
					else
						outputChatBox("[!]#FFFFFF Oyuncu bulunamadı.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end, mysql:getConnection(), "SELECT * FROM characters WHERE id = ?", cid)
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [CID]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [CID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("cid", findCID, false, false)

function changeSerial(thePlayer, commandName, accountName, serial)
    if exports.cr_integration:isPlayerCommunityManager(thePlayer) then
        if accountName then
            if serial then
                dbQuery(function(qh)
                    local res, rows, err = dbPoll(qh, 0)
                    if rows > 0 then
                        for index, row in ipairs(res) do
                            dbExec(mysql:getConnection(), "UPDATE accounts SET mtaserial = ? WHERE username = ?", serial, accountName)
                            outputChatBox("[!]#FFFFFF " .. accountName .. " isimli kullanıcının seriali değiştirildi.", thePlayer, 0, 255, 0, true)
                        end
                    else
                        outputChatBox("[!]#FFFFFF Kullanıcı bulunamadı.", thePlayer, 255, 0, 0, true)
                        playSoundFrontEnd(thePlayer, 4)
                    end
                end, mysql:getConnection(), "SELECT * FROM accounts WHERE username = ?", accountName)
            else
                outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı] [Yeni Serial]", thePlayer, 255, 194, 14)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı] [Yeni Serial]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("changeserial", changeSerial, false, false)

function changePassword(thePlayer, commandName, accountName, password, passwordAgain)
    if exports.cr_integration:isPlayerAdministrator(thePlayer) then
        if accountName then
            if password then
                if passwordAgain then
					if (string.len(password) >= 6) and (string.len(passwordAgain) >= 6) then
						if password == passwordAgain then
							dbQuery(function(qh)
								local res, rows, err = dbPoll(qh, 0)
								if rows > 0 then
									for index, row in ipairs(res) do
										local password = string.upper(md5(password))
										dbExec(mysql:getConnection(), "UPDATE accounts SET password = ? WHERE username = ?", password, accountName)
										outputChatBox("[!]#FFFFFF " .. accountName .. " isimli kullanıcının şifresi değiştirildi.", thePlayer, 0, 255, 0, true)
									end
								else
									outputChatBox("[!]#FFFFFF Kullanıcı bulunamadı.", thePlayer, 255, 0, 0, true)
									playSoundFrontEnd(thePlayer, 4)
								end
							end, mysql:getConnection(), "SELECT * FROM accounts WHERE username = ?", accountName)
						else
							outputChatBox("[!]#FFFFFF Şifreler uyuşmuyor.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Şifreniz minimum 6 karakter olmalıdır.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
                else
                    outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı] [Yeni Şifre] [Yeni Şifre 2X]", thePlayer, 255, 194, 14)
                end
            else
                outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı] [Yeni Şifre] [Yeni Şifre 2X]", thePlayer, 255, 194, 14)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı] [Yeni Şifre] [Yeni Şifre 2X]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("changepassword", changePassword, false, false)

function paraDagit(thePlayer, commandName, amount)
    if exports.cr_integration:isPlayerHeadAdministrator(thePlayer) then
		if amount and tonumber(amount) then
			for _, player in ipairs(exports.cr_pool:getPoolElementsByType("player")) do
				if getElementData(player, "loggedin") == 1 then
					exports.cr_global:giveMoney(player, amount)
					exports.cr_infobox:addBox(player, "success", "Crown Roleplay'den herkese " .. exports.cr_global:formatMoney(amount) .. "$ hediye!")
				end
			end
			exports.cr_discord:sendMessage("paradagit-log", "**[PARA-DAĞIT]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. exports.cr_global:formatMoney(amount) .. "$** miktar dağıttı.")
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Miktar]", thePlayer, 255, 194, 14)
		end
    else
        outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("paradagit", paraDagit, false, false)