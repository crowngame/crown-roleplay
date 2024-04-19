local blip = {}
local marker = {}

addCommandHandler("konumat", function(thePlayer, commandName, targetPlayer)
    if targetPlayer then
		local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			targetPlayer:setData("konumistek", thePlayer:getData("dbid"))
			thePlayer:outputChat("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya konum isteği yolladınız.", 0, 255, 0, true)
			targetPlayer:outputChat("[!]#FFFFFF " .. thePlayer:getName():gsub("_", " ") .. " isimli oyuncu size konum atmak istiyor.", 0, 0, 255, true)
		end
	else
		thePlayer:outputChat("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", 255, 194, 14)
	end
end)

addCommandHandler("konumkabul", function(thePlayer, commandName, targetPlayer)
    if targetPlayer then
		local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			if thePlayer:getData("konumistek") == targetPlayer:getData("dbid") then
				local x, y, z = getElementPosition(targetPlayer)
				blip[thePlayer:getData("dbid")] = createBlip(x, y, z, 19, 2, 255, 0, 0, 255, 0, 99999.0, thePlayer)
				marker[thePlayer:getData("dbid")] = createMarker(x, y, z, "checkpoint", 3, 255, 0, 0, 255, thePlayer)
				attachElements(marker[thePlayer:getData("dbid")], targetPlayer)
				attachElements(blip[thePlayer:getData("dbid")], targetPlayer)
				thePlayer:setData("konumistek", 0)
				
				thePlayer:outputChat("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun konum teklifini kabul ettiniz.", 0, 255, 0, true)
				targetPlayer:outputChat("[!]#FFFFFF " .. thePlayer:getName():gsub("_", " ") .. " isimli oyuncu teklifinizi kabul etti, konumunuz gösteriliyor.", 0, 255, 0, true)
			else
				thePlayer:outputChat("[!]#FFFFFF Bu kişi size konum isteği yollamamış.", 0, 255, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end
	else
		thePlayer:outputChat("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", 255, 194, 14)
	end
end)

addCommandHandler("konumkapat", function(thePlayer)
    local playerID = thePlayer:getData("dbid")
    if blip[playerID] then
        marker[playerID]:destroy()
        marker[playerID] = false
        blip[playerID]:destroy()
        blip[playerID] = false
        thePlayer:outputChat("[!]#FFFFFF Başarıyla konumu kapattınız.", 0, 255, 0, true)
    end
end)