local mysql = exports.cr_mysql

addEvent("duty-ui:equipOutfit", true)
addEventHandler("duty-ui:equipOutfit", getRootElement(), function(thePlayer, skinID)
	if isElement(thePlayer) and tonumber(skinID) then 
		if setElementModel(thePlayer, skinID) then
			outputChatBox("[!]#FFFFFF Başarıyla [#" .. skinID .. "] barkodlu kıyafeti kuşandınız.", thePlayer, 0, 255, 0, true)
			setElementData(thePlayer, "duty", 1)
		else
			if getElementModel(thePlayer) == skinID then
				outputChatBox("[!]#FFFFFF Üstünüzde olan kıyafeti tekrar kuşanamazsınız.", thePlayer, 255, 0, 0, true)
			else
				outputChatBox("[!]#FFFFFF Bir hata oluştu. Bu hatayı lütfen yöneticiye bildirin. (#" .. skinID .. ")", thePlayer, 255, 0, 0, true)
			end
		end
	end
end)

addEvent("duty-ui:giveItem", true)
addEventHandler("duty-ui:giveItem", getRootElement(), function(thePlayer, itemID, itemName, itemValue)
	if isElement(thePlayer) and tonumber(itemID) and itemName then
		if itemID == 115 then
			local characterid = tonumber(getElementData(thePlayer, "account:character:id"))
			local weaponSerial = exports["cr_global"]:createWeaponSerial(2, characterid)
			if exports["cr_items"]:giveItem(thePlayer, 115, itemValue  .. ":" ..  weaponSerial  .. ":"  ..  getWeaponNameFromID (itemValue)  ..  " (D)") then
				outputChatBox("[!]#FFFFFF Başarıyla " .. getWeaponNameFromID(itemValue) .. " adlı görev silahını kuşandınız.", thePlayer, 0, 255, 0, true)
			else
				outputChatBox("[!]#FFFFFF Bu görev silahını kuşanmak için envanterinizde yeterli alana sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			end
		else
			if exports["cr_items"]:giveItem(thePlayer, itemID, 1) then
				outputChatBox("[!]#FFFFFF Başarıyla [" .. itemName .. "] isimli teçhizat ekipmanını kuşandınız.", thePlayer, 0, 255, 0, true)
				setElementData(thePlayer, "duty", 1)
			else
				outputChatBox("[!]#FFFFFF Bu teçhizat ekipmanını kuşanmak için yeterli alana sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end)


addEvent("customduty:offduty", true)
addEventHandler("customduty:offduty", getRootElement(), function(thePlayer)
	if isElement(thePlayer) then
		setPedArmor(thePlayer, 0)
		local countGun, countAmmo, countItem = 0, 0, 0
		local items = exports['cr_items']:getItems( thePlayer ) -- [] [1] = itemID [2] = itemValue
		for itemSlot, itemCheck in ipairs(items) do
			if (itemCheck[1] == 115) then -- Weapon
				local itemCheckExplode = exports.cr_global:explode(":", itemCheck[2])
				local serialNumberCheck = exports.cr_global:retrieveWeaponDetails(itemCheckExplode[2])
				if (tonumber(serialNumberCheck[2]) == 2) then -- /duty spawned
					exports['cr_items']:takeItem(thePlayer, itemCheck[1], itemCheck[2], false)
					countGun = countGun + 1
				end
			elseif (itemCheck[1] == 116) then
				local checkString = string.sub(itemCheck[2], -4)
				if checkString == " (D)" then -- duty given weapon
					exports['cr_items']:takeItem(thePlayer, itemCheck[1], itemCheck[2], false)
					countAmmo = countAmmo + 1
				end
			elseif (itemCheck[1] == 45) or (itemCheck[1] == 126) or (itemCheck[1] == 26) or (itemCheck[1] == 29) then
				exports['cr_items']:takeItem(thePlayer, itemCheck[1], itemCheck[2], false)
				countItem = countItem + 1
			end
		end

		setElementData(thePlayer, "duty", 0)
		if countGun > 0 or countAmmo > 0 or countItem > 0 then
			outputChatBox("[!]#FFFFFF Görevden ayrıldınız. " .. countGun .. " adet görev silahınız, " .. countAmmo .. " adet görev silahı merminiz ve " .. countItem .. " adet görev eşyanız envanterden silindi.", thePlayer, 255, 0, 0, true)
		end
	end
end)

addEvent("duty-ui:giveWeapon", true)
addEventHandler("duty-ui:giveWeapon", getRootElement(), function(thePlayer, weaponID, weaponName)
	if isElement(thePlayer) and tonumber(weaponID) and weaponName then
		local characterid = tonumber(getElementData(thePlayer, "account:character:id"))
		local weaponSerial = exports["cr_global"]:createWeaponSerial(2, characterid)
		local dutyLevel = getElementData(thePlayer, "custom_duty") or 0
		local valid = checkValid(dutyLevel, weaponID)
		if valid then
			if exports["cr_items"]:giveItem(thePlayer, 115, weaponID  .. ":" ..  weaponSerial  .. ":"  ..  getWeaponNameFromID (weaponID)  ..  " (D)") then
				outputChatBox("[!]#FFFFFF Başarıyla " .. weaponName .. " adlı görev silahını kuşandınız.", thePlayer, 0, 255, 0, true)
			else
				outputChatBox("[!]#FFFFFF Bu görev silahını kuşanmak için envanterinizde yeterli alana sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			end

			if weaponName == "Deagle" then 
				for i = 1, 15 do
					exports["cr_items"]:giveItem(thePlayer, 116, weaponID .. ":10:Ammo for " .. getWeaponNameFromID(weaponID) .. " (D)")
				end
			elseif weaponName == "MP5" then 
				for i = 1, 8 do
					exports["cr_items"]:giveItem(thePlayer, 116, weaponID .. ":25:Ammo for " .. getWeaponNameFromID(weaponID) .. " (D)")
				end
			elseif weaponName == "Shotgun" then 
				for i = 1, 10 do
					exports["cr_items"]:giveItem(thePlayer, 116, weaponID .. ":5:Ammo for " .. getWeaponNameFromID(weaponID) .. " (D)")
				end
			elseif weaponName == "M4" then 
				for i = 1, 12 do
					exports["cr_items"]:giveItem(thePlayer, 116, weaponID .. ":25:Ammo for " .. getWeaponNameFromID(weaponID) .. " (D)")
				end
			elseif weaponName == "Sniper" then 
				for i = 1, 12 do
					exports["cr_items"]:giveItem(thePlayer, 116, weaponID .. ":10:Ammo for " .. getWeaponNameFromID(weaponID) .. " (D)")
				end
			end

			setElementData(thePlayer, "duty", 1)
		else
			outputChatBox("[!]#FFFFFF Bu görev silahını kuşanmak için yeterli görev seviyesine sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		end
	end
end)

function checkValid(dutylevel, value)
	local weapons = dutyWeapons[dutylevel].weapons or {}
	for i, v in ipairs(weapons) do 
		if v == value then
			return true
		end
	end
end

dutyWeapons = {
	[0] = {
        weapons = {}, -- deagle
    },

    [1] = {
        weapons = {24}, -- deagle
    },

    [2] = {
        weapons = {24, 25}, -- deagle, shotgun
    },

    [3] = {
        weapons = {24, 25, 29}, -- deagle, shotgun, mp5
    },

    [4] = {
        weapons = {24, 25, 29, 31}, -- deagle, shotgun, mp5, mp4
    },

    [5] = {
        weapons = {17, 24, 25, 27, 29, 31, 34}, -- deagle, shotgun, mp5, m4, sniper
    },
}

function dutyVer(thePlayer, commandName, targetPlayer, dutyPerk)
	local faction = (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 2) or (getElementData(thePlayer, "faction") == 3)
	local leader = getElementData(thePlayer, "factionleader")
	if faction and (leader == 1) then
		if (not tonumber(dutyPerk)) then
			outputChatBox("KULLANIM: /"  ..  commandName  ..  " [Karakter Adı / ID] [1-5]", thePlayer, 255, 194, 14)
		else
			dutyPerk = tonumber(dutyPerk)
			local targetPlayer, targetPlayerName = exports["cr_global"]:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "faction") == 1 or getElementData(targetPlayer, "faction") == 2 or getElementData(targetPlayer, "faction") == 3 then
					if dutyPerk >= 1 and dutyPerk <= 5 then
						local dbid = getElementData(targetPlayer, "dbid")
						outputChatBox("[!]#FFFFFF " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun duty seviyesi [" .. tonumber(dutyPerk) .. "] olarak düzenlendi.", thePlayer, 0, 255, 0, true)
						setElementData(targetPlayer, "custom_duty", tonumber(dutyPerk))
						dbExec(mysql:getConnection(), "UPDATE characters SET custom_duty = "  .. tonumber(dutyPerk) ..  " WHERE id = '"  ..  (dbid)  ..  "'")
					else 
						outputChatBox("KULLANIM: /"  ..  commandName  ..  " [Karakter Adı / ID] [1-5]", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("[!]#FFFFFF Hedef oyuncu polis biriminde bulunmuyor.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Sadece birlik yöneticileri yapabilir.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("dutyver", dutyVer)

function dutySil(thePlayer, commandName, targetPlayer, dutyPerk)
	local faction = (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 2) or (getElementData(thePlayer, "faction") == 3)
	local leader = getElementData(thePlayer, "factionleader")
	if faction and (leader == 1) then
		dutyPerk = tonumber(dutyPerk)
		local targetPlayer, targetPlayerName = exports["cr_global"]:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then 
			local dbid = getElementData(targetPlayer, "dbid")
			outputChatBox("[!]#FFFFFF " .. getPlayerName(targetPlayer):gsub("_", "_") .. " isimli oyuncunun duty seviyesi [0] olarak düzenlendi.", thePlayer, 0, 255, 0, true)
			setElementData(targetPlayer, "custom_duty", 0)
			dbExec(mysql:getConnection(), "UPDATE characters SET custom_duty = 0  WHERE id = '"  ..  (dbid)  ..  "'")
		end
	else
		outputChatBox("[!]#FFFFFF Sadece birlik yöneticileri yapabilir.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("dutyal", dutySil)