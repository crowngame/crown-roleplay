local vehiculars = { }
local viewDistance = 15
local heightOffset = 2.5
local refreshingInterval = 1
local showing = false
local timerRefresh = nil
local BizNoteFont18 = exports.cr_fonts:getFont("sf-bold",8)
local plakaFont = exports.cr_fonts:getFont("license", 15)
local plakaFont2 = exports.cr_fonts:getFont("sf-bold", 9)
local plakaFont3 = exports.cr_fonts:getFont("sf-regular", 9)

local noPlateVehs = {
	[481] = "BMX",
	[509] = "Bike",
	[510] = "Mountain Bike",
}

function bindVD()
	bindKey("ralt", "down", togglePinVD)
	addEventHandler("onClientRender", root, showText)
end
addEventHandler("onClientResourceStart", resourceRoot, bindVD)

function removeVD(key, keyState)
	local enableOverlayDescriptionVehPin = getElementData(localPlayer, "enableOverlayDescriptionVehPin")
	if enableOverlayDescriptionVehPin == "1" then
		return false
	end

	if showing then
		
		showing = false
	end
end

function showNearbyVehicleDescriptions()
	local enableOverlayDescription = getElementData(localPlayer, "enableOverlayDescription")
	local enableOverlayDescriptionVeh = getElementData(localPlayer, "enableOverlayDescriptionVeh")
	if enableOverlayDescription ~= "0" and enableOverlayDescriptionVeh ~= "0" then
		local enableOverlayDescriptionVehPin = getElementData(localPlayer, "enableOverlayDescriptionVehPin")
		if enableOverlayDescriptionVehPin == "1" then
			if showing then
				showing = false
			end
		end
		
		if not showing then
			for index, nearbyVehicle in ipairs(exports.cr_global:getNearbyElements(localPlayer, "vehicle")) do
				if isElement(nearbyVehicle) then
					vehiculars[index] = nearbyVehicle
				end
			end
			
			showing = true
		end
	end
end

function togglePinVD()
	local enableOverlayDescription = getElementData(localPlayer, "enableOverlayDescription")
	local enableOverlayDescriptionVeh = getElementData(localPlayer, "enableOverlayDescriptionVeh")
	if enableOverlayDescription ~= "0" and enableOverlayDescriptionVeh ~= "0" then
		local enableOverlayDescriptionVehPin = getElementData(localPlayer, "enableOverlayDescriptionVehPin")
		if enableOverlayDescriptionVehPin == "1" then
			setElementData(localPlayer, "enableOverlayDescriptionVehPin", "0")
			if isTimer(timerRefresh) then
				killTimer(timerRefresh)
				timerRefresh = nil
			end
			if showing then
				showing = false
			end
		else
			setElementData(localPlayer, "enableOverlayDescriptionVehPin", "1")
			
			timerRefresh = setTimer(refreshNearByVehs, 1000*refreshingInterval, 0)
			
			if not showing then
				for index, nearbyVehicle in ipairs(exports.cr_global:getNearbyElements(localPlayer, "vehicle")) do
					if isElement(nearbyVehicle) and (getElementDimension(nearbyVehicle) == getElementDimension(localPlayer)) then
						vehiculars[index] = nearbyVehicle
					end
				end
				showing = true
			end
		end
	end
end

function showText()
	if not showing then
		if getKeyState('lalt') then
			showNearbyVehicleDescriptions()
		end
		return false
	end
	if not getKeyState('lalt') and getElementData(localPlayer, "enableOverlayDescriptionVehPin") ~= "1" then
		removeVD()
		return
	end
	for i = 1, #vehiculars, 1 do
		local theVehicle = vehiculars[i]
		if isElement(theVehicle) then
			local x, y, z = getElementPosition(theVehicle)
            local cx, cy, cz = getCameraMatrix()
			if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= viewDistance then --Within radius viewDistance
				if getElementDimension(theVehicle) ~= getElementDimension(localPlayer) then return end
				if getElementInterior(theVehicle) ~= getElementInterior(localPlayer) then return end
				local px, py = getScreenFromWorldPosition(x, y, z + heightOffset, 0.05)
				if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then				
					--FETCH FONT IN REAL TIME
					local fontString = getElementData(localPlayer, "cFontVeh") or "default"
					local fontElement = fontString
					if fontElement == "BizNoteFont18" then
						if not BizNoteFont18 then
							BizNoteFont18 = exports.cr_fonts:getFont("sf-bold",8)
						end
						fontElement = BizNoteFont18
					end
					--INITIAL SHIT
					local toBeShowed = ""
					local vehicleBrand = ""
					local fontWidth = 90
					local toBeAdded = ""
					local lines = 0
					local textColor = tocolor(255,255,255,255)
					if getElementData(theVehicle, "carshop") then
						local brand, model, year = false, false, false
						brand = getElementData(theVehicle, "brand") or false
						if brand then
							model = getElementData(theVehicle, "maximemodel") or getVehicleName(theVehicle)
							year = getElementData(theVehicle, "year") or "2010"
							modelID = getElementModel(theVehicle)
							local line = year .. " " .. brand .. " " .. model .. " (" .. getElementData(theVehicle, "vehicle_shop_id") .. ")"
							local len = dxGetTextWidth(line)
							if len > fontWidth then
								fontWidth = len
							end
							vehicleBrand = line
						else
							vehicleBrand = line
						end
						local price = getElementData(theVehicle, "carshop:cost") or 0
						local taxes = getElementData(theVehicle, "carshop:taxcost") or 0
						toBeShowed = toBeShowed .. "Fiyat: " .. exports.cr_global:formatMoney(price) .. "$\n Vergi: " .. exports.cr_global:formatMoney(taxes) .. "$"
						lines = lines + 1
					elseif getElementData(theVehicle, "Satilik") then
						local brand, model, year = false, false, false
						brand = getElementData(theVehicle, "brand") or false
						if brand then
							model = getElementData(theVehicle, "maximemodel") or getVehicleName(theVehicle)
							year = getElementData(theVehicle, "year") or "2010"
							modelID = getElementModel(theVehicle)
							local line = year .. " " .. brand .. " " .. model .. " (" .. getElementData(theVehicle, "vehicle_shop_id") .. ")"
							local len = dxGetTextWidth(line)
							if len > fontWidth then
								fontWidth = len
							end
							vehicleBrand = line
						else
							vehicleBrand = line
						end
						local price = getElementData(theVehicle, "Satilik") or 0
						local vowner = getElementData(theVehicle, "owner") or -1

						local ownerName = 'Yok'
						if vowner > 0 then
							ownerName = exports.cr_cache:getCharacterNameFromID(vowner)
						end
						local owner = "Sahibi: " .. (ownerName or "Bilinmiyor")

						toBeShowed = toBeShowed .. "Fiyat: " .. exports.cr_global:formatMoney(price) .. "$\n" .. owner
					else
						local descToBeShown = ""
						local job = getElementData(theVehicle, "job")
						if job == 13 then
							descToBeShown = "Los Santos Mail - Her yere zamanında."
							lines = lines + 1
						elseif job == 23 then
							descToBeShown = "Los Santos Taxi\nTaksi lazımsa arayın!\nNO: 8294"
							lines = lines + 2
						elseif job == 33 then
							descToBeShown = "Dolmuş\n"
							lines = lines + 1
						elseif job == 83 then
							descToBeShown = "Domino's Pizza\n"						
						elseif job == 153 then
							descToBeShown = "Et Servisi\n"						
						elseif job == 43 then
							descToBeShown = "Los Santos Directorate of Science and Technology\n"
							lines = lines + 1
						else
							for j = 1, 5 do
								local desc = getElementData(theVehicle, "description:" .. j)
								if desc and desc ~= "" and desc ~= "\n" and desc ~= "\t" then
									local len = dxGetTextWidth(desc)
									if len > fontWidth then
										fontWidth = len
									end
									descToBeShown = descToBeShown..desc .. "\n"
									lines = lines + 1
								end				
							end
						end
						
						if descToBeShown ~= "" then
							descToBeShown = "-~-~-~-~-~-~-\n" .. descToBeShown
							lines = lines + 1
						end
					
						--GET BRAND, MODEL, YEAR
						local brand, model, year = false, false, false
						brand = getElementData(theVehicle, "brand") or false
						model = getElementData(theVehicle, "maximemodel")
						year = getElementData(theVehicle, "year")
						modelID = getElementModel(theVehicle)
						if brand and model and year then
							local line = year .. " " .. brand .. " " .. model .. " (" .. getElementData(theVehicle, "vehicle_shop_id") .. ")"
							local len = dxGetTextWidth(line)

							if len > fontWidth then
								fontWidth = len
							end

							vehicleBrand = line
						else 
							local brand = getVehicleName(theVehicle)
							local line = "2018 " ..brand
							local len = dxGetTextWidth(line)

							if len > fontWidth then
								fontWidth = len
							end

							vehicleBrand = line
						end
						
						--GET VIN+PLATE
						local plate = ""
						local vin = getElementData(theVehicle, "dbid") or "#ff0000SISTEM HATASI#FFFFFF"
						if tonumber(vin) then
							if vin < 0 then
								plate = "SIVIL"
							else
								plate = getElementData(theVehicle, "plate")
							end
						end
						if getElementData(theVehicle, "show_plate") == 0 then
							if getElementData(localPlayer, "duty_admin") == 1 then
								toBeShowed = toBeShowed .. "((Plaka: " .. plate .. "))\n"
								lines = lines + 1
							end
						end
						if getElementData(theVehicle, "show_vin") == 0 then
							if getElementData(localPlayer, "duty_admin") == 1 then
								toBeShowed = toBeShowed .. "((ID: " .. vin .. "))"
								lines = lines + 1
							else
								--toBeShowed = toBeShowed .. "* NO VIN *"
							end
						else
							toBeShowed = toBeShowed .. "VIN: " .. vin
							lines = lines + 1
						end

						--GET IMPOUND
						if (exports["cr_vehicle"]:isVehicleImpounded(theVehicle)) then
							local days = getRealTime().yearday-getElementData(theVehicle, "Impounded")
							toBeShowed = toBeShowed .. "\n" .. "LSPD: " .. days .. " gündür LSPD tarafından çekildi."
							lines = lines + 1
						end

						local vowner = getElementData(theVehicle, "owner") or -1
						--if vowner == getElementData(localPlayer, "account:id") or exports.cr_global:isStaffOnDuty(localPlayer) or exports.cr_integration:isPlayerScripter(localPlayer) or exports.cr_integration:isPlayerVCTMember(localPlayer) then
						local vfaction = getElementData(theVehicle, "faction") or -1
					
							--toBeShowed = toBeShowed .. "\nListe ID: " .. (getElementData(theVehicle, "vehicle_shop_id") or "None") .. " (" .. getElementModel(theVehicle) .. ")"
							--lines = lines + 1

							local ownerName = 'Yok'
							if vowner > 0 then
								ownerName = exports.cr_cache:getCharacterNameFromID(vowner)
							elseif vfaction > 0 then
								ownerName = exports.cr_cache:getFactionNameFromId(vfaction)
							end
							local line = "\nSahibi: " .. (ownerName or "Bilinmiyor")
							local len = dxGetTextWidth(line)
							if len > fontWidth then
								fontWidth = len
							end
							toBeShowed = toBeShowed..line
						--end
						toBeShowed = toBeShowed .. "\n" .. descToBeShown
					end
					
					if fontWidth < 90 then
						fontWidth = 90
					end

					-- PLAKA (ENKANET)
					if not noPlateVehs[getElementModel(theVehicle)] then
						if not (getElementData(theVehicle, "show_plate") == 0) then
							local plate = getElementData(theVehicle, "plate") or "SIVIL"
							if getElementData(theVehicle, "carshop") then
								plate = "SATILIK"
							end
							local vehID = getElementData(theVehicle, "dbid")
							local vehFactionID = getElementData(theVehicle, "faction")
							local vehPlateDesign = getElementData(theVehicle, "plate_design") or 1
							local customPlates = exports["cr_plate-design"]:getPlateDesigns()
							
							local plateData = customPlates[vehPlateDesign]
							if plateData then
								dxDrawImage(px - 57, py, 110, 55, ":cr_plate-design/images/" .. vehPlateDesign  .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
								dxDrawText(plate, px-90+12, py+40, px-90+165, py+33, tocolor(plateData.textColor[1], plateData.textColor[2], plateData.textColor[3], 255), 1, plakaFont, "center", "center", false, false, false, false, false)
							else
								dxDrawImage(px - 57, py, 110, 55, ":cr_plate-design/images/1.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
								dxDrawText(plate, px-90+12, py+40, px-90+165, py+33, tocolor(0, 0, 0, 255), 1, plakaFont, "center", "center", false, false, false, false, false)
							end
						end
					end
					
					local marg = 25
					local oneLineHeight = dxGetFontHeight(1, fontElement)
					local fontHeight = oneLineHeight * lines
					fontWidth = fontWidth * 1
					px = px-(fontWidth/2)
					
					dxDrawRectangle(px-marg, py+marg + 38, fontWidth+(marg*2), 63, tocolor(10, 10, 10, 220))
					dxDrawText(vehicleBrand, px, py+marg+46, px + fontWidth, (py + 20), textColor, 1, plakaFont2, "center")
					dxDrawText(toBeShowed, px, py+marg+64, px + fontWidth, (py + fontHeight)+21, textColor, 1, plakaFont3, "center", "top", false ,false, false, true)
				end
			end
		end
	end
end

--Farid
function dxDrawRectangleBorder(x, y, width, height, borderWidth, color, out, postGUI)
	if out then
		--[[Left]]	dxDrawRectangle(x - borderWidth, y, borderWidth, height, color, postGUI)
		--[[Right]]	dxDrawRectangle(x + width, y, borderWidth, height, color, postGUI)
		--[[Top]]	dxDrawRectangle(x - borderWidth, y - borderWidth, width + (borderWidth * 2), borderWidth, color, postGUI)
		--[[Botm]]	dxDrawRectangle(x - borderWidth, y + height, width + (borderWidth * 2), borderWidth, color, postGUI)
	else
		local halfW = width / 2
		local halfH = height / 2
		--[[Left]]	dxDrawRectangle(x, y, math.clip(0, borderWidth, halfW), height, color, postGUI)
		--[[Right]]	dxDrawRectangle(x + width - math.clip(0, borderWidth, halfW), y, math.clip(0, borderWidth, halfW), height, color, postGUI)
		--[[Top]]	dxDrawRectangle(x + math.clip(0, borderWidth, halfW), y, width - (math.clip(0, borderWidth, halfW) * 2), math.clip(0, borderWidth, halfH), color, postGUI)
		--[[Botm]]	dxDrawRectangle(x + math.clip(0, borderWidth, halfW), y + height - math.clip(0, borderWidth, halfH), width - (math.clip(0, borderWidth, halfW) * 2), math.clip(0, borderWidth, halfH), color, postGUI)
	end
end