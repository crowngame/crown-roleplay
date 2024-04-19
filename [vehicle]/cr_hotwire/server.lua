local hotwire = {}

randomWords = {
    [1] = "wrong",
    [2] = "castle",
    [3] = "fire",
    [4] = "celery",
    [5] = "vintage",
    [6] = "upon",
    [7] = "kingdom",
    [8] = "visa",
    [9] = "swamp",
    [10] = "daughter",
    [11] = "hurdle",
    [12] = "practice",
    [13] = "complication",
    [14] = "crosswalk",
    [15] = "dictate",
    [16] = "laborer",
    [17] = "chalk",
    [18] = "exclude",
    [19] = "transaction",
    [20] = "insist",
    [21] = "enlarge",
    [22] = "archive",
    [23] = "exit",
    [24] = "redeem",
    [25] = "frighten",
    [26] = "plane",
    [27] = "grain",
    [28] = "wording",
    [29] = "doubt",
    [30] = "approval",
    [31] = "donkey",
}

addCommandHandler("duzkontak", function(thePlayer, commandName)
    if isPedInVehicle(thePlayer) then
        local theVehicle = getPedOccupiedVehicle(thePlayer)
        local owner = getElementData(theVehicle, "owner") or 0
        
		if owner <= 0 then
			outputChatBox("[!]#FFFFFF Devlet aracına düz kontak uygulayamazsınız.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
			return
		end

        local engine = getVehicleEngineState(theVehicle)
        if engine then 
            outputChatBox("[!]#FFFFFF Çalışan bir araca düz kontak uygulayamazsınız.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
			return
		end

        if hotwire[thePlayer] then 
            outputChatBox("[!]#FFFFFF Zaten bir araca düz kontak işlemi uyguluyorsunuz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
			return
		end
		
		if not exports.cr_items:hasItem(thePlayer, 44) then 
			outputChatBox("[!]#FFFFFF Düz kontak işlemi için 'Maymuncuk' eşyasına sahip olmalısınız.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
			return
		end

        hotwire[thePlayer] = {}
        hotwire[thePlayer].word = randomWords[math.random(1, #randomWords)]
        outputChatBox("[!]#FFFFFF Ekrana çıkan kelimeleri doğru girerek işlemi gerçekleştir! [/dk kelime]", thePlayer, 0, 0, 255, true)
        exports.cr_global:sendLocalMeAction(thePlayer, "sigorta kutusunun kapağını açar, kablolarla uğraşmaya başlar.")
        triggerClientEvent(thePlayer, "hotwire.drawText", thePlayer, hotwire[thePlayer].word)
        setElementData(thePlayer, "hotwire.attempt", 1)

		for _, player in ipairs(getElementsByType("player")) do 
			if (getElementData(player, "faction")) == 1 or (getElementData(player, "faction") == 3) then 
				local x, y, z = getElementPosition(thePlayer)
				local zone = getZoneName(x, y, z)
			    outputChatBox("[HQ] " .. zone .. " bölgesinde " .. getVehicleName(theVehicle) .. " model (" .. getVehiclePlateText(theVehicle) .. ") plakalı araç hırsızlığı ihbarı var.", player, 48, 128, 255)
			end
		end

        hotwire[thePlayer].timer = setTimer(function(thePlayer)
            if isElement(thePlayer) then
                if hotwire[thePlayer] then
                    outputChatBox("[!]#FFFFFF İşlemi başaramadın, iptal edildi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
                    hotwire[thePlayer] = nil
                    triggerClientEvent(thePlayer, "hotwire.removeText", thePlayer)
                    exports.cr_items:takeItem(thePlayer, 44)
                    exports.cr_global:sendLocalDoAction(thePlayer, "Kablo bağlama işlemi başarısız olmuştur.")
                end
            end
        end, 30 * 1000, 1, thePlayer)
    end
end, false, false)

addCommandHandler("dk", function(thePlayer, commandName, word)
    if isPedInVehicle(thePlayer) then
        local theVehicle = getPedOccupiedVehicle(thePlayer)
        if hotwire[thePlayer] then
            if tostring(word) ~= nil then
                if hotwire[thePlayer].word == tostring(word) then
                    local attempt = getElementData(thePlayer, "hotwire.attempt") or 1
                    if attempt ~= 10 then
                        outputChatBox("[!]#FFFFFF Tebrikler bir sonraki aşamaya geçildi, yeni kelimeniz ekranda belirdi.", thePlayer, 0, 0, 255, true)
                        setElementData(thePlayer, "hotwire.attempt", attempt + 1)
                        hotwire[thePlayer].word = randomWords[math.random(1, #randomWords)]
                        triggerClientEvent(thePlayer, "hotwire.drawText", thePlayer, hotwire[thePlayer].word)
                    else
                        toggleControl(thePlayer, "brake_reverse", true)
                        setVehicleEngineState(theVehicle, true)
                        setElementData(theVehicle, "engine", 1)
                        setElementData(theVehicle, "vehicle:radio", tonumber(getElementData(theVehicle, "vehicle:radio:old")))
                        outputChatBox("[!]#FFFFFF Aracı başarıyla çalıştırdınız.", thePlayer, 0, 255, 0, true)
                        triggerClientEvent(thePlayer, "hotwire.removeText", thePlayer)
                        hotwire[thePlayer] = nil
                        exports.cr_global:sendLocalDoAction(thePlayer, "Kablo bağlama işlemi başarılı olmuştur.")
                    end
                end
            end
        end
    end
end, false, false)

function removeHelmetOnExit(thePlayer, seat, jacked)
    if hotwire[thePlayer] then 
        outputChatBox("[!]#FFFFFF Araçtan indiğiniz için işlem iptal edildi.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
        hotwire[thePlayer] = nil
        triggerClientEvent(thePlayer, "hotwire.removeText", thePlayer)
    end
end
addEventHandler("onVehicleExit", root, removeHelmetOnExit)

function removeHelmetOnExit()
    if hotwire[source] then 
        outputChatBox("[!]#FFFFFF Bayıldığınız için işlem iptal edildi.", source, 255, 0, 0, true)
		playSoundFrontEnd(source, 4)
        hotwire[source] = nil
        triggerClientEvent(source, "hotwire.removeText", source)
    end
end
addEventHandler("onPlayerWasted", root, removeHelmetOnExit)