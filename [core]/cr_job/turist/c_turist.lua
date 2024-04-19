-- ROTA --
local turistMarker = 0
local turistCreatedMarkers = {}
local turistBlip = nil  -- Turist blipini saklamak için bir değişken ekleyin
local turistRota = {
{ 1004.7158203125, -1870.994140625, 12.118531227112, false },
{ 1002.2333984375, -1855.9990234375, 12.294834136963, false },
{ 972.6611328125, -1856.07421875, 11.56165599823, false },
{ 895.0224609375, -1856.80859375, 8.811224937439, false },
{ 799.888671875, -1843.69921875, 7.8452754020691, false },
{ 709.5947265625, -1842.5029296875, 7.8891143798828, false, false }, 
{ 683.3720703125, -1842.7529296875, 5.86407995224, false },
{ 669.2763671875, -1833.404296875, 5.5445895195007, false },
{ 643.5634765625, -1822.1044921875, 5.5435070991516, false },
{ 612.0048828125, -1822.0126953125, 5.5443329811096, false },
{ 598.216796875, -1810.455078125, 5.5397896766663, false },
{ 580.6630859375, -1800.7197265625, 5.5398240089417, false }, 
{ 497.1533203125, -1800.806640625, 5.5433282852173, false },
{ 482.513671875, -1796.1748046875, 5.5428147315979, false },
{ 462.3740234375, -1778.744140625, 5.0275120735168, false },
{ 367.76953125, -1779.4716796875, 4.9812932014465, false },
{ 309.3740234375, -1772.2666015625, 4.0682730674744, false },
{ 258.0791015625, -1770.822265625, 3.8108868598938, false }, 
{ 177.2373046875, -1770.927734375, 3.8337941169739, false },
{ 152.9794921875, -1791.287109375, 3.4271399974823, false },
{ 152.859375, -1833.8525390625, 3.2444763183594, false },
{ 152.626953125, -1870.041015625, 3.2512722015381, false },
{ 152.8447265625, -1921.84765625, 3.2510182857513, false },
{ 145.6376953125, -1945.455078125, 3.2546300888062, false },
{ 154.6025390625, -1961.7939453125, 3.2545793056488, true, false },
{ 162.2607421875, -1948.103515625, 3.2549350261688, false },
{ 156.8955078125, -1917.9326171875, 3.2542991638184, false },
{ 156.763671875, -1862.673828125, 3.2544963359833, false },
{ 157.4580078125, -1794.3759765625, 3.3425440788269, false },
{ 185.724609375, -1774.513671875, 3.3676426410675, false },
{ 260.6767578125, -1773.943359375, 3.6740639209747, false },
{ 334.7294921875, -1779.17578125, 4.540816783905, false },
{ 444.2509765625, -1783.2099609375, 5.0281219482422, false },
{ 473.966796875, -1785.2060546875, 5.5377230644226, false },
{ 487.43359375, -1804.28515625, 5.5432600975037, false }, 
{ 508.9765625, -1811.158203125, 5.3655290603638, false },
{ 517.87890625, -1824.3466796875, 5.5438957214355, false },
{ 540.2861328125, -1836.380859375, 5.1150999069214, false },
{ 578.3916015625, -1832.689453125, 5.1142535209656, false },
{ 632.4580078125, -1849.8427734375, 5.1138291358948, false },
{ 659.212890625, -1855.38671875, 4.9424829483032, false }, 
{ 695.8720703125, -1856.4462890625, 6.2290759086609, false },
{ 753.33203125, -1857.0634765625, 6.1364169120789, false },
{ 832.0234375, -1856.552734375, 7.8192429542542, false },
{ 894.8154296875, -1857.529296875, 8.8122158050537, false },
{ 945.65234375, -1857.384765625, 10.352289199829, false }, 
{ 996.0322265625, -1852.958984375, 12.299102783203, false },
{ 1004.154296875, -1861.048828125, 12.301067352295, false },
{ 999.3212890625, -1865.6513671875, 12.299570083618, true, true } 
}

function turistBasla(cmd)
    if not getElementData(getLocalPlayer(), "turistSoforlugu") then
        local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
        local oyuncuAracModel = getElementModel(oyuncuArac)
        local kacakciAracModel = 471
        if not getVehicleOccupant(oyuncuArac, 1) then
            if oyuncuAracModel == kacakciAracModel then
                setElementData(getLocalPlayer(), "turistSoforlugu", true)
                updateturistRota()
                addEventHandler("onClientMarkerHit", resourceRoot, turistRotaMarkerHit)
            end
        else
            outputChatBox("[!]#FFFFFF Sürücünün yanındaki koltuk boş olmalı.", 255, 0, 0, true)
        end
    else
        outputChatBox("[!]#FFFFFF Zaten mesleğe başladınız!", 255, 0, 0, true)
    end
end
addCommandHandler("turistbasla", turistBasla)

function createTuristBlip(x, y, z)
    if isElement(turistBlip) then
        destroyElement(turistBlip)  -- Önceki turist blipini sil
    end
    turistBlip = createBlip(x, y, z, 0, 2, 255, 0, 0, 255, 0, 99999.0)
end

function updateturistRota()
    turistMarker = turistMarker + 1
    for i, v in ipairs(turistRota) do
        if i == turistMarker then
            if not v[4] == true then
                local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
                createTuristBlip(v[1], v[2], v[3])  -- Her marker için blip oluşturun ve önceki blip'i silin
                table.insert(turistCreatedMarkers, {rotaMarker, false})
            elseif v[4] == true and v[5] == true then
                local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
                createTuristBlip(v[1], v[2], v[3])  -- Her marker için blip oluşturun ve önceki blip'i silin
                table.insert(turistCreatedMarkers, {bitMarker, true, true})
            elseif v[4] == true then
                local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
                createTuristBlip(v[1], v[2], v[3])  -- Her marker için blip oluşturun ve önceki blip'i silin
                table.insert(turistCreatedMarkers, {malMarker, true, false})
            end
        end
    end
end

function turistRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 471 then
				for _, marker in ipairs(turistCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updateturistRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							turistMarker = 0
							triggerServerEvent("turistParaVer", hitPlayer, hitPlayer)
							outputChatBox("[!]#FFFFFF Mesleği Tamamladınız. Eğer devam etmek istemiyorsanız, /turistbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateturistRota()
								end, 100, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("[!]#FFFFFF Biraz Bekle, Turistler denize doğru fotoraf çekiniyor.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateturistRota()
								end, 100, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function turistBitir()
    local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
    local pedVehModel = getElementModel(pedVeh)
    local turistSoforlugu = getElementData(getLocalPlayer(), "turistSoforlugu")
    if pedVeh then
        if pedVehModel == 471 then
            if turistSoforlugu then
                exports.cr_global:fadeToBlack()
                setElementData(getLocalPlayer(), "turistSoforlugu", false)
                for i, v in ipairs(turistCreatedMarkers) do
                    destroyElement(v[1])
                end
                turistCreatedMarkers = {}
                turistMarker = 0
                triggerServerEvent("turistBitir", getLocalPlayer(), getLocalPlayer())
                removeEventHandler("onClientMarkerHit", resourceRoot, turistRotaMarkerHit)
                removeEventHandler("onClientVehicleStartEnter", getRootElement(), turistAntiYabanci)
                if isElement(turistBlip) then
                    destroyElement(turistBlip)  -- Turist blipini temizle
                end
                setTimer(function() exports.cr_global:fadeFromBlack() end, 2000, 1)
            end
        end
    end
end
addCommandHandler("turistbitir", turistBitir)


function turistAntiYabanci(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	
	if vehicleModel == 471 and vehicleJob == 8 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("[!]#FFFFFF Meslek aracına binemezsiniz.", 255, 0, 0, true)
		elseif thePlayer == getLocalPlayer() and playerJob ~= 19 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			--outputChatBox("[!]#FFFFFF Bu araca binmek için Turist mesleğinde olmanız gerekmektedir.", 255, 0, 0, true)
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), turistAntiYabanci)

function turistAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			turistBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), turistAntiAracTerketme)