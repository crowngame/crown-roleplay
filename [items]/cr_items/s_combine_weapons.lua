Async:setDebug(false)

addEventHandler("onPlayerWeaponFire", root, function(weapon)
	useAmmo(source, weapon, 0)
end)

function getPedWeapons(ped)
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=2,9 do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end

function updateLocalGuns(thePlayer, items)
	if source then
		thePlayer = source
	end
	
	if not thePlayer or getElementData(thePlayer, "loggedin") ~= 1 then
		return
	end
	
	if not items then
		items = getItems(thePlayer)
	end

	local countedBullets = 0
	local firstClip = 0
	local weaponsUpdated = { }
	for _, itemCheck in ipairs(items) do
		if (itemCheck[1] == 115) then -- Weapon
			local gunDetails = explode(':', itemCheck[2])
			local totalBullets = 0
			local firstClipBullets = 0
			if tostring(gunDetails[3]) then
				for _, bulletCheck in ipairs(items) do
					if (bulletCheck[1] == 116) then 
						local bulletDetails = explode(':', bulletCheck[2])
						if (bulletDetails[3]) then
							if tonumber(bulletDetails[1]) == tonumber(gunDetails[1]) then
								if tonumber(bulletDetails[2]) > 0 then
									totalBullets = totalBullets + tonumber(bulletDetails[2])
									if firstClipBullets == 0 then
										firstClipBullets = tonumber(bulletDetails[2])
									end
								end
							end
						end
					end	
				end
			end
			
			if (gunDetails[1] == "46") then
				totalBullets = 18
				firstClipBullets = 3
			elseif (gunDetails[1] == "2" or  gunDetails[1] == "3" or gunDetails[1] == "4" or gunDetails[1] == "5" or gunDetails[1] == "6" or gunDetails[1] == "7" or gunDetails[1] == "9" or gunDetails[1] == "15") then -- Golfclub, nightstick, knife, baseball bat, shovel, pool cue, chainsaw, cane -- katana:  or gunDetails[1] == "8"
				totalBullets = 18
				firstClipBullets = 3
			elseif (string.lower(tostring(gunDetails[3])) == "spraycan" or string.lower(tostring(gunDetails[3])) == "fire extinguisher" or string.lower(tostring(gunDetails[3])) == "camera") then
				totalBullets = 5000
				firstClipBullets = 500
			end
			
			if (gunDetails[1] == "8") then -- Katana
				totalBullets = 0
				firstClipBullets = 0
			end
			
			if firstClipBullets == 0 then
				firstClipBullets = 1
				totalBullets = 1
				if not (getElementData(thePlayer,  "cf:" .. gunDetails[1])) then
					setElementData(thePlayer, "cf:" .. gunDetails[1], true)
				end
			else
				if (getElementData(thePlayer,  "cf:" .. gunDetails[1])) then
					setElementData(thePlayer, "cf:" .. gunDetails[1], false)
				end
			end
			
			giveWeapon(thePlayer, gunDetails[1], 1, false)
			setWeaponAmmo (thePlayer, gunDetails[1], totalBullets, firstClipBullets)
			table.insert(weaponsUpdated, gunDetails[1], gunDetails[1])
		end
	end
	
	local weaponsToScan = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 22, 23, 24, 25, 26, 27, 28, 29, 32, 30, 31, 33, 34, 35, 36, 37, 38, 16, 17, 18, 39, 41, 42, 43, 10, 11, 12, 14, 15, 44, 45, 46, 40 }
	
	for weaponSlot = 1, 12 do
		found = false
		for _, weaponID in ipairs(weaponsToScan) do
			if getSlotFromWeapon(weaponID) == weaponSlot and  weaponsUpdated[weaponID] then
				found = true
			end
		end
		if not found then
			for i, weaponID in ipairs(weaponsToScan) do
				if getSlotFromWeapon(weaponID) == weaponSlot then
					if getPedWeapon (thePlayer, weaponSlot) ~= 0 and getPedTotalAmmo(thePlayer, weaponSlot) ~= 0 then
						takeWeapon(thePlayer, weaponID)
						triggerEvent("createWepObject", thePlayer, thePlayer, weaponID, 0, getSlotFromWeapon(weaponID)) -- Adams
					end
				end
			end	
		end
	end
	
	for i, wepID in ipairs(getPedWeapons(thePlayer)) do
		if (getElementData(thePlayer, "account:id") == 1 or getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 59 or getElementData(thePlayer, "faction") == 50 or getElementData(thePlayer, "faction") == 3 or getElementData(thePlayer, "faction") == 47) and getElementData(thePlayer, "enableGunAttach") then
			if getPedWeapon(thePlayer) ~= wepID then
				triggerEvent("createWepObject", thePlayer, thePlayer, wepID, 1, getSlotFromWeapon(wepID))
			end
		end
	end
end
addEvent("updateLocalGuns", true)
addEventHandler("updateLocalGuns", getRootElement(), updateLocalGuns)

function reloadA(thePlayer,weapon,ammocalc)
	setElementData(thePlayer, "reloading", true)
	setTimer(checkFalling, 100, 10, thePlayer)
	setElementData(thePlayer, "cf:" .. weapon, false)
	if not (isPedDucked(thePlayer)) and not isPedInVehicle(thePlayer) then
		triggerClientEvent(thePlayer, "onClientPlayerWeaponCheck", thePlayer)
	end
	setTimer(giveReload, 1001, 1, thePlayer, weapon, ammocalc)
	triggerClientEvent(thePlayer, "cleanupUI", thePlayer, true)
end

function useAmmo(client, weapon,wasted)
	if not client or getElementData(client, "loggedin") ~= 1 then
		return
	end
	
	local wep = getPedWeapon(client)
	local ammo = getPedTotalAmmo(client)
	local ammoinclip = getPedAmmoInClip(client)

	local items = getItems(client)
	weapon = tonumber(weapon)
	local nogun = false

	playerAmmos = {}
	local total = 0
	for slot, itemCheck in ipairs(items) do
		if (itemCheck[1] == 116) then
			local weaponBulletDetails = explode(':', itemCheck[2])
			if tonumber(weaponBulletDetails[1]) == weapon and tonumber(weaponBulletDetails[2]) > 0 then
				table.insert(playerAmmos,{slot, itemCheck})
				total = total + tonumber(weaponBulletDetails[2])
			end
		end
	end
	
	table.sort(playerAmmos, function(a, b)
		local weaponBulletDetails = explode(':', a[2][2])
		local weaponBulletDetails1 = explode(':', b[2][2])
		return tonumber(weaponBulletDetails[2]) < tonumber(weaponBulletDetails1[2])
	end)
	
	local taken = 0
	local ammocalc = ammo - ammoinclip

	if not playerAmmos or type(playerAmmos) ~= 'table' or #playerAmmos == 0 then return end
	Async:foreach(playerAmmos, function(v, i)
		if not v then
			return
		end
		slot = v[1]
		--print(slot)
		itemCheck = v[2]
		if (itemCheck[1] == 116) then
			local weaponBulletDetails = explode(':', itemCheck[2])
			if weaponBulletDetails and tonumber(weaponBulletDetails[1]) and tonumber(weaponBulletDetails[1]) == weapon and taken < wasted then				
				local bullets = tonumber(weaponBulletDetails[2])
				local left = wasted - taken
				--print("Mermi alüyürk")
				if bullets > (left) then
					--outputChatBox("AŞAMA 1 KALAN:" .. left .. " HARCANAN:" .. wasted .. " SAHİP: " .. bullets .. " ALINMAMIŞ: " .. left)
					takeItemFromSlot(client, slot, firstClipSlot)
					giveItem(client, 116, weaponBulletDetails[1] .. ":" .. tostring(bullets - left) .. ":" .. weaponBulletDetails[3])
					taken = wasted
					if tonumber(bullets - left) == 0 then
						--triggerEvent("i:s:w:r:do", client, client)
						reloadA(client,weapon,ammocalc)
					end
					updateLocalGuns(client, items)					
					
				elseif bullets == left then
					--outputChatBox("AŞAMA 2 KALAN:" .. left .. " HARCANAN:" .. wasted)
					takeItemFromSlot(client, slot, firstClipSlot)
					giveItem(client, 116, weaponBulletDetails[1] .. ":" .. "0" .. ":" .. weaponBulletDetails[3])
					taken = wasted
					--triggerEvent("i:s:w:r:do", client, client)
					reloadA(client,weapon,ammocalc)
					updateLocalGuns(client, items)					
					
				else
					--outputChatBox("AŞAMA 3 KALAN:" .. left .. " HARCANAN:" .. wasted)
					takeItemFromSlot(client, slot, firstClipSlot)
					giveItem(client, 116, weaponBulletDetails[1] .. ":" .. "0" .. ":" .. weaponBulletDetails[3])
					taken = taken + bullets
					--triggerEvent("i:s:w:r:do", client, client)
					reloadA(client,weapon,ammocalc)
				end

				updateLocalGuns(client, items)
			end
		end
	end)
end
addEvent("items.useAmmo",true)
addEventHandler("items.useAmmo",root,useAmmo)

function updateRemoteAmmo(ammoTable)
	if not client or getElementData(client,"loggedin") ~= 1 then
		return
	end
	local items = getItems(client)
	local weaponCheck = { }
	for _, itemCheck in ipairs(items) do
		if (itemCheck[1] == 115) then -- Weapon item
			local weaponItemDetails = explode(':', itemCheck[2])
			local weaponAmmoCountValid = 0
			local firstClip = 0
			local firstClipInventorySlot = 0
			local firstClipArr = nil
			
			-- Calculate the amount of bullets serverside
			for itemCheckBulletsSlot, itemCheckBullets in ipairs(items) do
				if (itemCheckBullets[1] == 116) then 
					local weaponBulletDetails = explode(':', itemCheckBullets[2])
					if tonumber(weaponBulletDetails[1]) == tonumber(weaponItemDetails[1]) then
						if (firstClip == 0 and tonumber(weaponBulletDetails[2]) > 0) then
							firstClip =  tonumber(weaponBulletDetails[2])
							firstClipInventorySlot = itemCheckBulletsSlot
							firstClipArr = weaponBulletDetails
						end
					
						weaponAmmoCountValid = weaponAmmoCountValid + weaponBulletDetails[2]
					end
				end
			end
			
			-- Get the weapon sync for this gun
			local weaponSyncPacket = false
			for _, tableValue in ipairs(ammoTable) do
				--outputDebugString("Server: " .. tableValue[1]  .. "loop " .. weaponItemDetails[1])
				if tonumber(tableValue[1]) == tonumber(weaponItemDetails[1]) then
					--outputDebugString("Server: " .. weaponItemDetails[1]  .. " is in the sync table")
					weaponSyncPacket = tableValue
				end
			end
			
			if not weaponSyncPacket then
				--outputDebugString("item-system\s_combine_weapons.lua:updateRemoteAmmo: Not all the guns are in the syncpacket. Missing " .. weaponItemDetails[1]  .. " for " .. getPlayerName(client))
				return
			end
			
			
			local fakebullet = false
			if (getElementData(client, "cf:" .. weaponItemDetails[1])) then
				fakebullet = true
				weaponAmmoCountValid = weaponAmmoCountValid + 1
			end
			
			-- Minus the shot bullets..
			if (weaponAmmoCountValid > weaponSyncPacket[2]) then -- There has been shot with this gun
				-- Deduct from magazine
				local totalBulletsShot = weaponAmmoCountValid - weaponSyncPacket[2]
				--outputChatBox("item-system\s_combine_weapons.lua:updateRemoteAmmo: [" .. getPlayerName(client) .. "] Processing " .. totalBulletsShot .. " shot bullets for gun " ..  weaponItemDetails[1]  .. " in slot " .. firstClipInventorySlot .. "!")
				local update
				if type(firstClipArr) == "table" then
					update = updateItemValue(client, firstClipInventorySlot,firstClipArr[1]  .. ":" .. weaponSyncPacket[3]   .. ":" ..   firstClipArr[3])
				end
				--outputChatBox("attempting update on " .. getPlayerName(client) .. ":" .. firstClipInventorySlot .. " new value " .. firstClipArr[1]  .. ":" .. weaponSyncPacket[3]  .. ":" ..   firstClipArr[3])
				if not update then
					outputDebugString("fail")
				end
				weaponAmmoCountValid = weaponAmmoCountValid - totalBulletsShot
			end
			
			table.insert(weaponCheck, {weaponItemDetails[1], weaponAmmoCountValid, fakebullet})
		end
	end
end
addEvent("i:s:w", true)
addEventHandler("i:s:w", getRootElement(), updateRemoteAmmo)

-- RELOADING
local noReloadGuns = { [25]=true, [33]=true, [34]=true, [35]=true, [36]=true, [37]=true }
local clipSize = { [22]=17, [23]=17, [24]=7, [26]=2, [27]=7, [28]=50, [29]=30, [30]=30, [31]=50, [32]=50 }

function reloadWeapon(cl)
	local thePlayer = client
	if cl then
		thePlayer = cl
	end
	local weapon = getPedWeapon(thePlayer) -- lastKnownGun[thePlayer] --
	local ammo = getPedTotalAmmo(thePlayer)
	local ammoinclip = getPedAmmoInClip(thePlayer)

	local reloading = getElementData(thePlayer, "reloading")
	local jammed = getElementData(thePlayer, "jammed")

	local ammocalc = ammo - ammoinclip -- destroy the contents of their old clip
	
	if (not reloading) and not (isPedInVehicle(thePlayer)) and ((jammed==0) or not jammed) then
		if (weapon) and (ammo) and (ammocalc > 0) then -- safety measure: cant reload your last clip
		local clipSizeCalc = clipSize[weapon] or 60
		
			if not (ammoinclip >= clipSizeCalc) then -- Not reload if their clip is full
				if not getElementData(thePlayer, "deagle:reload") and not getElementData(thePlayer, "scoreboard:reload") then
					-- Reload our gun
					triggerClientEvent("i:s:w:r", thePlayer)
					local items = getItems(thePlayer)
					local noClips = 0
					local firstClip, firstClipInventorySlot, firstClipArr  = 0, 0, { }
					local secondClip, secondClipInventorySlot, secondClipArr = 0, 0, { }
					for itemCheckBulletsSlot, itemCheckBullets in ipairs(items) do
						if (itemCheckBullets[1] == 116) then 
							--outputChatBox("Bullet item found")
							local weaponBulletDetails = explode(':', itemCheckBullets[2])
							if tonumber(weaponBulletDetails[1]) == tonumber(weapon) then
								--outputChatBox("Matches the gun!")
								if (firstClip == 0 and tonumber(weaponBulletDetails[2]) > 0) then
									--outputChatBox("First clip found!")
									firstClip =  tonumber(weaponBulletDetails[2])
									firstClipInventorySlot = itemCheckBulletsSlot
									firstClipArr = weaponBulletDetails
								elseif (secondClip == 0 and tonumber(weaponBulletDetails[2]) > 0) then
									--outputChatBox("Second clip found!")
									secondClip =  tonumber(weaponBulletDetails[2])
									secondClipInventorySlot = itemCheckBulletsSlot
									secondClipArr = weaponBulletDetails
								end
								
								if  tonumber(weaponBulletDetails[2]) > 0 then
									noClips = noClips + 1
								end
							end
						end
					end
					
					if secondClip then
						takeItemFromSlot(thePlayer, firstClipInventorySlot, firstClipSlot)
						giveItem(thePlayer, 116, firstClipArr[1] .. ":" .. firstClipArr[2] .. ":" .. firstClipArr[3])
						updateLocalGuns(thePlayer, items)
						
						setElementData(thePlayer, "reloading", true)
						setTimer(checkFalling, 100, 10, thePlayer)
						setElementData(thePlayer, "cf:" .. weapon, false)
						if not (isPedDucked(thePlayer)) and not isPedInVehicle(thePlayer) then
							triggerClientEvent(thePlayer, "onClientPlayerWeaponCheck", thePlayer)
						end
						
						setTimer(giveReload, 1001, 1, thePlayer, weapon, ammocalc)
						triggerClientEvent(thePlayer, "cleanupUI", thePlayer, true)
					else
						outputChatBox(">> Merminiz yok!", thePlayer, 255, 0, 0)
					end
				end				
			end
		end
	end
end
addEvent("i:s:w:r:do", true)
addEventHandler("i:s:w:r:do", getRootElement(), reloadWeapon)

function checkFalling(thePlayer)
	local reloading = getElementData(thePlayer, "reloading")
	if not (isPedOnGround(thePlayer)) and (reloading) then
		-- reset state
		setElementData(thePlayer, "reloading.timer", false, false)
		exports.cr_global:removeAnimation(thePlayer)
		setElementData(thePlayer, "reloading", false, false)
	end
end

function giveReload(thePlayer, weapon, ammo)
	local clipsizee = 0
	setElementData(thePlayer, "reloading.timer", false, false)
	exports.cr_global:removeAnimation(thePlayer)
	
	local calcClipSize = clipSize[weapon] or 30
	if (ammo < calcClipSize) then
		clipsizee = ammo
	else
		clipsizee = clipSize[weapon]
	end
	
	updateRemoteAmmo(ammoTable)
	setElementData(thePlayer, "reloading", false, false)
	triggerClientEvent(thePlayer, "checkReload", thePlayer)
end