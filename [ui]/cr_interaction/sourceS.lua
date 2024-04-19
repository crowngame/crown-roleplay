addEvent("serverGönderaq", true)
addEventHandler("serverGönderaq", root,
function(type, player)
	if type == "üstara" then
		triggerEvent("subscribeToInventoryChanges", source, player)
		triggerClientEvent(source, "showInventory", source, player)
	else
		triggerEvent("onPlayerCuff", source, type, player)
	end
end)

function lockUnlockInside(vehicle)
	local model = getElementModel(vehicle)
	local owner = getElementData(vehicle, "owner")
	local dbid = getElementData(vehicle, "dbid")
	local seat = getPedOccupiedVehicleSeat(source)
						if  seat > 0 then
							--outputChatBox("#575757" .. exports.cr_odrin:getServerName() .. ":#FFFFFF  Aracın şoför koltuğunda olmanız gerekli",source,255,100,100,true)
						return end
	--if (owner ~= -1) then
		if (getElementData(vehicle, "Impounded") or 0) == 0 then
			if not exports.cr_global:hasItem(source, 3, dbid) then
				if (getElementData(source, "realinvehicle") == 1) then
					local locked = isVehicleLocked(vehicle)
					
					if seat == 0 or exports.cr_global:hasItem(source, 3, dbid) then
						--playCarToglockSoundFxInside(vehicle, not locked)
						if (locked) then
							--setVehicleLocked(vehicle, false)
							--triggerEvent('sendAme', source, "unlocks the vehicle doors.")
							--exports.cr_logs:dbLog(source, 31, {  vehicle }, "UNLOCK FROM INSIDE")
						else
							--setVehicleLocked(vehicle, true)
							--triggerEvent('sendAme', source, "locks the vehicle doors.")
							--exports.cr_logs:dbLog(source, 31, {  vehicle }, "LOCK FROM INSIDE")
						end
					end
				end
			end
		else
			outputChatBox("((You can't lock impounded vehicles.))", source, 255, 195, 14)
		end
	--else
		--outputChatBox("((You can't lock civilian vehicles.))", source, 255, 195, 14)
	--end

end
addEvent("lockUnlockInsideVehicle", true)
addEventHandler("lockUnlockInsideVehicle", getRootElement(), lockUnlockInside)


addEvent("ustara", true)
addEventHandler("ustara",root,function(plr,target)
	triggerClientEvent(target,"pd:ustAramaOnayGUI",target,plr,target)
end)

addEvent("vip:kaydet", true)
addEventHandler("vip:kaydet",root,function(plr)
	exports.cr_vip:vipkaydet(plr,plr)
end)

function karakterDegistirmeEvent()
end
addEvent("karakterDegistirmeStart", true)
addEventHandler("karakterDegistirmeStart", root, karakterDegistirmeEvent)

function karakterDegistirmeEvent()
	exports.cr_global:sendLocalText(source, ">> #FFFFFF" .. getPlayerName(source):gsub("_", " ") .. " adlı oyuncu karakter değiştirme ekranına gitti. (Kendi İsteğiyle)", 0, 0, 255, 10)
end
addEvent("karakterDegistirme", true)
addEventHandler("karakterDegistirme", root, karakterDegistirmeEvent)