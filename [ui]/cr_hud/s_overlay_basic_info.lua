function showStats(thePlayer, commandName, targetPlayerName)
	local showPlayer = thePlayer
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "loggedin") == 1 then
				thePlayer = targetPlayer
			else
				outputChatBox("Kullanici oyunda degil.", showPlayer, 255, 0, 0)
				return
			end
		else
			return
		end
	end
	
	local isOverlayDisabled = getElementData(showPlayer, "hud:isOverlayDisabled")

	local carlicense = getElementData(thePlayer, "license.car")
	local bikelicense = getElementData(thePlayer, "license.bike")
	local boatlicense = getElementData(thePlayer, "license.boat")
	local fishlicense = getElementData(thePlayer, "license.fish")
	local gunlicense = getElementData(thePlayer, "license.gun")
	local gun2license = getElementData(thePlayer, "license.gun2")
	
	if (carlicense==1) then
		carlicense = "Var"
	elseif (carlicense==3) then
		carlicense = "Sürüş testine girmedi."
	else
		carlicense = "Yok"
	end
	
	if (bikelicense==1) then
		bikelicense = "Var"
	elseif (bikelicense==3) then
		bikelicense = "Sürüş testine girmedi."
	else
		bikelicense = "Yok"
	end
	
	if (boatlicense==1) then
		boatlicense = "Var"
	else
		boatlicense = "Yok"
	end
	
	local pilotLicenses = {}
	local pilotlicense = ""
	local maxShow = 5
	local numAdded = 0
	local numOverflow = 0
	local typeratings = 0
	
	for k, v in ipairs(pilotLicenses) do
		local licenseID = v[1]
		local licenseValue = v[2]
		local licenseName = v[3]
		if licenseID == 7 then --if typerating
			if licenseValue then
				typeratings = typeratings + 1
			end
		else
			if numAdded >= maxShow then
				numOverflow = numOverflow + 1
			else
				if numAdded == 0 then
					pilotlicense = pilotlicense..tostring(licenseName)
				else
					pilotlicense = pilotlicense .. ", " .. tostring(licenseName)
				end
				numAdded = numAdded + 1
			end
		end
	end
	
	if (numAdded == 0) then
		pilotlicense = "Yok"
	else
		if numOverflow > 0 then
			pilotlicense = pilotlicense .. " (+" .. tostring(numOverflow+typeratings) .. ")"
		else
			if typeratings > 0 then
				pilotlicense = pilotlicense .. " (+" .. tostring(typeratings) .. ")"
			else
				pilotlicense = pilotlicense .. "."
			end
		end
	end
	
	if (fishlicense==1) then
		fishlicense = "Var"
	else
		fishlicense = "Yok"
	end
	
	if (gunlicense==1) then
		gunlicense = "Var"
	else
		gunlicense = "Yok"
	end
	
	if (gun2license==1) then
		gun2license = "Var"
	else
		gun2license = "Yok"
	end
	
	local dbid = tonumber(getElementData(thePlayer, "dbid"))
	local carids = ""
	local numcars = 0
	local printCar = ""
	for key, value in ipairs(exports.cr_pool:getPoolElementsByType("vehicle")) do
		local owner = tonumber(getElementData(value, "owner"))
		if (owner) and (owner == dbid) then
			local id = getElementData(value, "dbid")
			carids = carids .. id .. ", "
			numcars = numcars + 1
			setElementData(value, "owner_last_login", exports.cr_datetime:now(), true)
		end
	end
	printCar = numcars .. "/" .. getElementData(thePlayer, "maxvehicles")

	local properties = ""
	local numproperties = 0
	for key, value in ipairs(getElementsByType("interior")) do
		local interiorStatus = getElementData(value, "status")
		
		if interiorStatus[4] and interiorStatus[4] == dbid and getElementData(value, "name") then
			local id = getElementData(value, "dbid")
			properties = properties .. id .. ", "
			numproperties = numproperties + 1
			setElementData(value, "owner_last_login", exports.cr_datetime:now(), true)
		end
	end

	if (properties=="") then properties = "Yok  " end
	if (carids=="") then carids = "Yok  " end
	local hoursplayed = getElementData(thePlayer, "hoursplayed")
	local minutesPlayed = getElementData(thePlayer, "minutesPlayed") or 0
	minutesPlayed2 = 60 - minutesPlayed
	local info = {}
	info = {
		{"kullanıcı bilgileri"},
		{""},
		{" Araba Ehliyeti: " .. carlicense},
		{" Motor Ehliyeti: " .. bikelicense},
		{" Araçlar (" .. printCar .. "): \n " .. string.sub(carids, 1, string.len(carids)-2)},
		{""},
		{""},
		{" Mülkler (" .. numproperties .. "/" .. (getElementData(thePlayer, "maxinteriors") or 10) .. "): \n " .. string.sub(properties, 1, string.len(properties)-2)},
		{""},
		{""},
		{" Bu karakterinizde: " .. hoursplayed .. " saat " .. minutesPlayed .. " dakika geçirdiniz."},
	
	}
	
	local job = getElementData(thePlayer, "job") or 0

	table.insert(info, {""})
	local bakiye = getElementData(thePlayer, "balance") or 0
	local bankmoney = getElementData(thePlayer, "bankmoney") or 0
	local money = getElementData(thePlayer, "money") or 0
	local chip = getElementData(thePlayer, "casinochip") or 0

	table.insert(info, {" Meslek: " .. exports["cr_job"]:getJobTitleFromID(job) .. ""})
	table.insert(info, {" Cüzdan: $" .. exports.cr_global:formatMoney(money)})
	table.insert(info, {" Bankadaki Para: $" .. exports.cr_global:formatMoney(bankmoney)})
	table.insert(info, {" Bakiye: " .. exports.cr_global:formatMoney(bakiye) .. " TL"})
	table.insert(info, {" "})
	table.insert(info, {" Taşınan Ağırlık: " .. ("%.2f/%.2f"):format(exports["cr_items"]:getCarriedWeight(thePlayer), exports["cr_items"]:getMaxWeight(thePlayer)) .. " kg"})
	table.insert(info, {" "})
	
	if not isOverlayDisabled then
		triggerClientEvent(showPlayer, "hudOverlay:drawOverlayTopRight", showPlayer, info) 
	end
end
addCommandHandler("stats", showStats, false, false)
addEvent("showStats", true)
addEventHandler("showStats", root, showStats)