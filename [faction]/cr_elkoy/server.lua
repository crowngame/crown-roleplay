local mysql = exports.cr_mysql

function takeGun(thePlayer, targetPlayer, weaponSerial)
    if not targetPlayer then
        outputChatBox("[!]#FFFFFF Karşı oyuncu bulunamadı.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
		return
    end
	
    local itemSlot =  exports.cr_items:getItems(targetPlayer)
    for i, v in ipairs(itemSlot) do         
        if explode(":", v[2])[2] and (explode(":", v[2])[2] == weaponSerial) then
			local silahHak = #tostring(explode(":", v[2])[6]) > 0 and tonumber(explode(":", v[2])[6]) or 3
			exports.cr_items:takeItem(targetPlayer, 115, v[2])
			if tonumber(silahHak) > 1 then
				local silahHak = #tostring(explode(":", v[2])[6]) > 0 and explode(":", v[2])[6] or 3
				exports.cr_items:giveItem(targetPlayer, 115, tonumber(explode(":", v[2])[1]) .. ":" .. tostring(explode(":", v[2])[2]) .. ":" .. tostring(explode(":", v[2])[3]) .. ":" .. tostring(explode(":", v[2])[4]) .. ":" .. tostring(explode(":", v[2])[5]) .. ":" .. tostring(silahHak-1))
				outputChatBox("[!]#FFFFFF " .. getPlayerName(targetPlayer) .. " adlı kişinin, " .. exports.cr_items:getItemName(v[1],v[2]) .. " silahına el koydunuz. Kalan silah hakkı: " .. silahHak - 1, thePlayer, 0, 255, 0, true)
				outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer) .. " adlı yetkili " .. exports.cr_items:getItemName(v[1],v[2]) .. " silahınıza el koydu. Kalan hak: " .. silahHak - 1, targetPlayer, 255, 0, 0, true)
			else
				outputChatBox("[!]#FFFFFF " .. getPlayerName(targetPlayer) .. " adlı kişinin, " .. exports.cr_items:getItemName(v[1],v[2]) .. " silahına el koydunuz. Silah silindi.", thePlayer, 0, 255, 0, true)
				outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer) .. " adlı yetkili " .. exports.cr_items:getItemName(v[1],v[2]) .. " silahına el koydu. Silah silindi.", targetPlayer, 255, 0, 0, true)
			end
		end
    end
end
addEvent(getResourceName(getThisResource()) .. " >> takeGun", true)
addEventHandler(getResourceName(getThisResource()) .. " >> takeGun", root, takeGun)

function takeLicense(thePlayer, targetPlayer, license)
    dbExec(mysql:getConnection(), "UPDATE characters SET " .. (license) .. "_license='0' WHERE id = " .. (getElementData(targetPlayer, "dbid")) .. " LIMIT 1")
    setElementData(targetPlayer, "license." .. license, 0)
    if license == "car" then
        license = "Araç"
    elseif license == "bike" then
        license = "Motor"
    end
    outputChatBox("[!]#FFFFFF " .. (thePlayer.name:gsub("_"," ")) .. " tarafından " .. license .. " ehliyetinize el konuldu.", targetPlayer, 255, 0, 0, true) 
    outputChatBox("[!]#FFFFFF " .. (targetPlayer.name:gsub("_"," ")) .. " isimli oyuncunun " .. license .. " ehliyetine el koydunuz.", thePlayer, 0, 255, 0, true)  
end
addEvent(getResourceName(getThisResource()) .. " >> takeLicense", true)
addEventHandler(getResourceName(getThisResource()) .. " >> takeLicense", root, takeLicense)

function elKoy(thePlayer, commandName, targetPlayer)
    if not authorizedFactions[(getElementData(thePlayer, "faction") or -1)] then
        outputChatBox("[!]#FFFFFF Bu komutu kullanmak için LSPD üyesi olmalısın.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
        return false
    end

    local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(targetPlayer, targetPlayer)
    if not targetPlayer then
        outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        return false
    end
    
	if getDistanceBetweenPoints3D(thePlayer.position,targetPlayer.position) > 10 then
        outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncudan çok uzaktasın", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
        return false
    end
	
	triggerClientEvent(thePlayer, getResourceName(getThisResource()) .. " >> loadedWeapon", thePlayer, targetPlayer, exports.cr_items:getItems(targetPlayer))
end
addCommandHandler("elkoy", elKoy, false, false)