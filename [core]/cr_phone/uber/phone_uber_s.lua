
CallingDriverClients = {}
DriverDatas = {}

addEvent("uber:CallingDriver" , true)
addEventHandler("uber:CallingDriver" , root , function()
	if CallingDriverClients[source] ~= nil then
		outputChatBox("[!]#FFFFFF Bir taksi talebin var zaten!",source,255,0,0,true)
	return end
	CallingDriverClients[source] = false
	for k , v in ipairs(getElementsByType("player")) do 
		if v.vehicle and v:getData("job") == 2 and v.vehicleSeat == 0 and (getElementModel(v.vehicle) == 438 or getElementModel(v.vehicle) == 420) then 
			outputChatBox("[!]#FFFFFF " .. source.name .. " adlı kişi taksi talep ediyor! ID : " .. source:getData("playerid"), v,0,153,255,true) -- Sürücülere duyuru!
		end
	end
	outputChatBox("[!]#FFFFFF Taksi talebin yollandı!",source,0,153,255,true)
end)

addEvent("uber:CallingClient" , true)
addEventHandler("uber:CallingClient" , root , function(target)

	if DriverDatas[source] then
		outputChatBox("[!]#FFFFFF Bir müşteri talebini kabul etmişsin zaten!",source,255,0,0,true)
	return end

	local target , targetName = exports.cr_global:findPlayerByPartialNick(source , target)
	if not target then 
		outputChatBox("[!]#FFFFFF Bu ID'de veya bu isimde birisi yok!",source,255,0,0,true)
	return end
	
	if CallingDriverClients[target] == nil then
		outputChatBox("[!]#FFFFFF Bu kişinin bir taksi talebi yok!",source,255,0,0,true)
	return end
	
	if CallingDriverClients[target] then
		outputChatBox("[!]#FFFFFF Bu kişinin bir taksi talebi kabul edilmiş!",source,255,0,0,true)
	return end
	
	CallingDriverClients[target] = true
	local pos = target.position
	DriverDatas[source] = {}
	DriverDatas[source].marker = createMarker (pos , "checkpoint", 3.0, 0, 0, 255, 255, source)
	DriverDatas[source].blip   = createBlipAttachedTo(DriverDatas[source].marker , 41)
	DriverDatas[source].client = target
	DriverDatas[source].timer  = setTimer(function()
	
		outputChatBox("[!]#FFFFFF Alana varamadığın için talep iptal edildi!",player,255,0,0,true)	
		
		DriverDatas[source].timer = nil
		
		for k , v in pairs(DriverDatas) do 
		
			if k == source then
			
				destroyElement(v.marker)
				destroyElement(v.blip)
				CallingDriverClients[v.client] = nil
				DriverDatas[source] = nil
			
			end
		end
	
	end , 1000*60 , 1) -- Timer süresi, 1 DK ayarlı
	
	addEventHandler("onMarkerHit" , DriverDatas[source].marker , onMarkerGir)

	local target = DriverDatas[source].client
	outputChatBox("[!]#FFFFFF Taksi talebini bir şöför kabul etti, talep ettiğin alandan ayrılma!",target,0,153,255,true)	
	outputChatBox("[!]#FFFFFF Bir taksi talep ettin bir varış noktası oluşturuldu F11'e bakarak görebilirsin!",source,0,153,255,true)	
	
end)

function onMarkerGir(player)
	if player and getElementType(player) == "player" then -- Marker girince chat veriyor ayarları siliyor
	
		for k , v in pairs(DriverDatas) do 
		
			if k == player then
				
				killTimer(v.timer)
				destroyElement(v.marker)
				destroyElement(v.blip)
				CallingDriverClients[v.client] = nil
				DriverDatas[source] = nil
				
				outputChatBox("[!]#FFFFFF Alana başarıyla gittin!",player,255,0,0,true)	

				local target = DriverDatas[player].client
				outputChatBox("[!]#FFFFFF Taksi talebini kabul eden şöför, talep ettiğin alana gelmiş bulunmakta!",target,0,153,255,true)	
			
			end
		end
	end
end

addEventHandler("onVehicleStartExit" , root , function(plr , seat)
	
	if seat == 0 then
	
		if DriverDatas[plr] then
		
			outputChatBox("[!]#FFFFFF Araçtan indiğin için müşteri talebi otomatik iptal edildi!",plr,255,0,0,true)	
			
			local target = DriverDatas[plr].client
			outputChatBox("[!]#FFFFFF Taksi talebini kabul eden sürücü aracından indiği için talebin tekrar gönderildi!",target,255,0,0,true)
			
			for k , v in ipairs(getElementsByType("player")) do 
				if v.vehicle and v:getData("job") == 2 and (getElementModel(v.vehicle) == 438 or getElementModel(v.vehicle) == 420) then 
					outputChatBox("[!]#FFFFFF " .. target.name .. " adlı kişi taksi talep ediyor! ID : " .. target:getData("playerid"), v,0,153,255,true) -- Sürücülere duyuru!
				end
			end
			
			CallingDriverClients[target] = false
			
			for k , v in pairs(DriverDatas) do 
		
				if k == plr then

					if v.timer then 

						killTimer(v.timer)

					end

					destroyElement(v.marker)	
					destroyElement(v.blip)

				end
			end
			
			DriverDatas[plr] = nil
		end
		
	
	end

end)