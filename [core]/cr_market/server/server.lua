local mysql = exports.cr_mysql

addEvent("market.buyCharacterNameChange", true)
addEventHandler("market.buyCharacterNameChange", root, function(name, price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			local status, error = checkValidCharacterName(name)
			if status then
				name = string.gsub(tostring(name), " ", "_")
				dbQuery(function(qh, source)
					local res, rows, err = dbPoll(qh, 0)
					if (rows > 0) and (res[1] ~= nil) then
						exports.cr_infobox:addBox(source, "error", "Böyle bir karakter ismi bulunuyor.")
					else
						setElementData(source, "legitnamechange", 1)
						if setPlayerName(source, name) then
							local dbid = getElementData(source, "dbid")
							exports.cr_cache:clearCharacterName(dbid)
							dbExec(mysql:getConnection(), "UPDATE characters SET charactername = ? WHERE id = ?", name, dbid)
							takeBalance(source, price)
							exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında İsim Değişikliği satın aldınız.")
							exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında İsim Değişikliği satın aldı.")
							exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında İsim Değişikliği satın aldı.")
						else
							exports.cr_infobox:addBox(source, "error", "Bir sorun oluştu.")
						end
						setElementData(source, "legitnamechange", 0)
					end
				end, {source}, mysql:getConnection(), "SELECT charactername FROM characters WHERE charactername = ?", name)
			else
				exports.cr_infobox:addBox(source, "error", error)
			end
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyAccountNameChange", true)
addEventHandler("market.buyAccountNameChange", root, function(username, price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			local status, error = checkValidUsername(username)
			if status then
				dbQuery(function(qh, source)
					local res, rows, err = dbPoll(qh, 0)
					if (rows > 0) and (res[1] ~= nil) then
						exports.cr_infobox:addBox(source, "error", "Böyle bir kullanıcı adı bulunuyor.")
					else
						setElementData(source, "account:username", username)
						dbExec(mysql:getConnection(), "UPDATE accounts SET username = ? WHERE id = ?", username, getElementData(source, "account:id"))
						takeBalance(source, price)
						exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Kullanıcı Adı Değiştirme satın aldınız.")
						exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Kullanıcı Adı Değişikliği satın aldı.")
						exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Kullanıcı Adı Değişikliği satın aldı.")
					end
				end, {source}, mysql:getConnection(), "SELECT username FROM accounts WHERE username = ?", username)
			else
				exports.cr_infobox:addBox(source, "error", error)
			end
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVIP", true)
addEventHandler("market.buyVIP", root, function(vip, day, price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			if not (getElementData(source, "vip") > 0) then
				exports.cr_vip:addVIP(source, vip, day)
				takeBalance(source, price)
				exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında " .. day .. " günlük VIP " .. vip .. " satın aldınız.")
				exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında " .. day .. " günlük VIP " .. vip .. " satın aldı.")
				exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında " .. day .. " günlük VIP " .. vip .. " satın aldı.")
			else
				exports.cr_infobox:addBox(source, "error", "Zaten VIP üyeliğiniz var.")
			end
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyCharacterSlot", true)
addEventHandler("market.buyCharacterSlot", root, function(price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			setElementData(source, "charlimit", getElementData(source, "charlimit") + 1)
			dbExec(mysql:getConnection(), "UPDATE accounts SET charlimit = charlimit + 1 WHERE id = ?", getElementData(source, "account:id"))
			takeBalance(source, price)
			exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Karakter Slotu satın aldınız.")
			exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Karakter Slotu satın aldı.")
			exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Karakter Slotu satın aldı.")
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVehicleSlot", true)
addEventHandler("market.buyVehicleSlot", root, function(price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			setElementData(source, "maxvehicles", getElementData(source, "maxvehicles") + 1)
			dbExec(mysql:getConnection(), "UPDATE characters SET maxvehicles = maxvehicles + 1 WHERE id = ?", getElementData(source, "dbid"))
			takeBalance(source, price)
			exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Araç Slotu satın aldınız.")
			exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Araç Slotu satın aldı.")
			exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Araç Slotu satın aldı.")
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyPropertySlot", true)
addEventHandler("market.buyPropertySlot", root, function(price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			setElementData(source, "maxinteriors", getElementData(source, "maxinteriors") + 1)
			dbExec(mysql:getConnection(), "UPDATE characters SET maxinteriors = maxinteriors + 1 WHERE id = ?", getElementData(source, "dbid"))
			takeBalance(source, price)
			exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Mülk Slotu satın aldınız.")
			exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Mülk Slotu satın aldı.")
			exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Mülk Slotu satın aldı.")
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyRemoveHistory", true)
addEventHandler("market.buyRemoveHistory", root, function(price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			dbQuery(function(qh, source)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						dbExec(mysql:getConnection(), "DELETE FROM adminhistory WHERE id = ?", value.id)
						takeBalance(source, price)
						exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında History Sildirme satın aldınız.")
						exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında History Sildirme satın aldı.")
						exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında History Sildirme satın aldı.")
					end
				else
					exports.cr_infobox:addBox(source, "error", "Herhangi bir historyiniz yok.")
				end
			end, {source}, mysql:getConnection(), "SELECT id, action FROM adminhistory WHERE user = ? ORDER BY date DESC LIMIT 1", getElementData(source, "account:id"))
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVehiclePlate", true)
addEventHandler("market.buyVehiclePlate", root, function(id, plate, price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			local theVehicle = exports.cr_pool:getElement("vehicle", id)
			if theVehicle then
				if getElementData(source, "dbid") == getElementData(theVehicle, "owner") then
					dbQuery(function(qh, source)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 and res[1].no == 0 then
							if (exports["cr_vehicle-plate"]:checkPlate(plate)) and getVehiclePlateText(theVehicle) ~= plate then
								dbExec(mysql:getConnection(), "UPDATE vehicles SET plate = ? WHERE id = ?", plate, id)
								setElementData(theVehicle, "plate", plate)
								setVehiclePlateText(theVehicle, plate)
								takeBalance(source, price)
								exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Özel Plaka satın aldınız.")
								exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Özel Plaka satın aldı.")
								exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Özel Plaka satın aldı.")
							else
								exports.cr_infobox:addBox(source, "error", "Plakanızda uygunsuz karakter olmamalıdır.")
							end
						else
							exports.cr_infobox:addBox(source, "error", "Böyle bir plaka bulunuyor.")
						end
					end, {source}, mysql:getConnection(), "SELECT COUNT(*) as no FROM vehicles WHERE plate = ?", plate)
				else
					exports.cr_infobox:addBox(source, "error", "Bu araç size ait değil.")
				end
			else
				exports.cr_infobox:addBox(source, "error", "Böyle bir araç bulunamadı.")
			end
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVehicleTintWindows", true)
addEventHandler("market.buyVehicleTintWindows", root, function(id, price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			local theVehicle = exports.cr_pool:getElement("vehicle", id)
			if theVehicle then
				if getElementData(source, "dbid") == getElementData(theVehicle, "owner") then
					dbExec(mysql:getConnection(), "UPDATE vehicles SET tintedwindows = 1 WHERE id = ?", getElementData(theVehicle, "dbid"))
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerEvent("setTintName", theVehicle, player)
						end
					end
					
					setElementData(theVehicle, "tinted", true)
					triggerClientEvent("tintWindows", theVehicle)
					takeBalance(source, price)
					exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Cam Filmi satın aldınız.")
					exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Cam Filmi satın aldı.")
					exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Cam Filmi satın aldı.")
				else
					exports.cr_infobox:addBox(source, "error", "Bu araç size ait değil.")
				end
			else
				exports.cr_infobox:addBox(source, "error", "Böyle bir araç bulunamadı.")
			end
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVehicleNeon", true)
addEventHandler("market.buyVehicleNeon", root, function(id, neonIndex, price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			local theVehicle = exports.cr_pool:getElement("vehicle", id)
			if theVehicle then
				if getElementData(source, "dbid") == getElementData(theVehicle, "owner") then
					dbQuery(function(qh, source)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							dbExec(mysql:getConnection(), "UPDATE vehicles SET neon = ? WHERE id = ?", neonIndex, id)
							setElementData(theVehicle, "tuning.neon", neonIndex)
							takeBalance(source, price)
							exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Neon Sistemi satın aldınız.")
							exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Neon Sistemi satın aldı.")
							exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Neon Sistemi satın aldı.")
						end
					end, {source}, mysql:getConnection(), "SELECT id FROM vehicles WHERE id = ?", id)
				else
					exports.cr_infobox:addBox(source, "error", "Bu araç size ait değil.")
				end
			else
				exports.cr_infobox:addBox(source, "error", "Böyle bir araç bulunamadı.")
			end
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVehicleButterflyDoor", true)
addEventHandler("market.buyVehicleButterflyDoor", root, function(id, price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			local theVehicle = exports.cr_pool:getElement("vehicle", id)
			if theVehicle then
				if getElementData(source, "dbid") == getElementData(theVehicle, "owner") then
					dbQuery(function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							dbExec(mysql:getConnection(), "UPDATE vehicles_custom SET doortype = 2 WHERE id = ?", getElementData(theVehicle, "dbid"))
							setTimer(function() exports["cr_vehicle-manager"]:loadCustomVehProperties(tonumber(id), theVehicle) end, 5000, 1)
						else
							dbQuery(function(qh)
								local res, rows, err = dbPoll(qh, 0)
								if rows > 0 then
									row = res[1]
									dbExec(mysql:getConnection(), "INSERT INTO vehicles_custom SET id = ?, doortype = 2, brand = ?, model = ?, year = ?", getElementData(theVehicle, "dbid"), row.vehbrand, row.vehmodel, row.vehyear)
									setTimer(function() exports["cr_vehicle-manager"]:loadCustomVehProperties(tonumber(id), theVehicle) end, 5000, 1)
								end
							end, mysql:getConnection(), "SELECT * FROM vehicles_shop WHERE id = ?", getElementData(theVehicle, "vehicle_shop_id"))
						end
					end, mysql:getConnection(), "SELECT id FROM vehicles_custom WHERE id = ?", getElementData(theVehicle, "dbid"))
					
					takeBalance(source, price)
					exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Kelebek Kapı satın aldınız.")
					exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Kelebek Kapı satın aldı.")
					exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Kelebek Kapı satın aldı.")
				else
					exports.cr_infobox:addBox(source, "error", "Bu araç size ait değil.")
				end
			else
				exports.cr_infobox:addBox(source, "error", "Böyle bir araç bulunamadı.")
			end
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyVehicleDesignPlate", true)
addEventHandler("market.buyVehicleDesignPlate", root, function(id, plateDesignIndex, price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			local theVehicle = exports.cr_pool:getElement("vehicle", id)
			if theVehicle then
				if getElementData(source, "dbid") == getElementData(theVehicle, "owner") then
					dbQuery(function(qh, source)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							dbExec(mysql:getConnection(), "UPDATE vehicles SET plate_design = ? WHERE id = ?", plateDesignIndex, id)
							setElementData(theVehicle, "plate_design", plateDesignIndex)
							takeBalance(source, price)
							exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Plaka Tasarımı satın aldınız.")
							exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Plaka Tasarımı satın aldı.")
							exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında Plaka Tasarımı satın aldı.")
						end
					end, {source}, mysql:getConnection(), "SELECT id FROM vehicles WHERE id = ?", id)
				else
					exports.cr_infobox:addBox(source, "error", "Bu araç size ait değil.")
				end
			else
				exports.cr_infobox:addBox(source, "error", "Böyle bir araç bulunamadı.")
			end
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyPrivateVehicle", true)
addEventHandler("market.buyPrivateVehicle", root, function(model, id, name, price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			local dbid = getElementData(source, "dbid")
			local rotation = getPedRotation(source)
			local x, y, z = getElementPosition(source)
			x = x + ((math.cos(math.rad(rotation))) * 5)
			y = y + ((math.sin(math.rad(rotation))) * 5)
			
			local theVehicle = createVehicle(model, x, y, z)
			setVehicleColor(theVehicle, 255, 255, 255)
			
			local rx, ry, rz = getElementRotation(theVehicle)
			local var1, var2 = exports.cr_vehicle:getRandomVariant(model)
			local letter1 = string.char(math.random(65, 90))
			local letter2 = string.char(math.random(65, 90))
			local plate = letter1 .. letter2 .. " " .. math.random(1000, 9999)
			local color1 = toJSON({255, 255, 255})
			local color2 = toJSON({0, 0, 0})
			local color3 = toJSON({0, 0, 0})
			local color4 = toJSON({0, 0, 0})
			local interior, dimension = getElementInterior(source), getElementDimension(source)
			local tint = 0
			local factionVehicle = -1
			
			local smallestID = SmallestID()
			local inserted = dbExec(mysql:getConnection(), "INSERT INTO vehicles SET model='" .. model .. "', x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', rotx='0', roty='0', rotz='" .. rotation .. "', color1='" .. color1 .. "', color2='" .. color2 .. "', color3='" .. color3 .. "', color4='" .. color4 .. "', faction='" .. factionVehicle .. "', owner='" .. dbid .. "', plate='" .. plate .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='0', currry='0', currrz='" .. rotation .. "', locked='1', interior='" .. interior .. "', currinterior='" .. interior .. "', dimension='" .. dimension .. "', currdimension='" .. dimension .. "', tintedwindows='" .. tint .. "', variant1='" .. var1 .. "', variant2='" .. var2 .. "', creationDate=NOW(), createdBy='-1', `vehicle_shop_id`='" .. id .. "'")
			if inserted then
				dbQuery(function(qh, source, theVehicle)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						local insertid = res[1].id
						if not insertid then
							giveBalance(source, balance)
							exports.cr_infobox:addBox(source, "warning", "Aldığın araç veritabanına işlenemediği için bakiyeniz iade edildi.")
							exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı ama veritabanına işlenemediği için bakiyesi iade edildi.")
							exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı ama veritabanına işlenemediği için bakiyesi iade edildi.")
							return false
						end
						
						call(getResourceFromName("cr_items"), "deleteAll", 3, insertid)
						exports.cr_global:giveItem(source, 3, insertid)
						destroyElement(theVehicle)
						exports.cr_vehicle:reloadVehicle(insertid)
						
						takeBalance(source, price)
						exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında " .. name .. " markalı araç satın aldınız.")
						exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı.")
						exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında " .. name .. " (" .. model .. ") (" .. id .. ") markalı araç satın aldı.")
					end
				end, {source, theVehicle}, mysql:getConnection(), "SELECT id FROM vehicles WHERE id = LAST_INSERT_ID() LIMIT 1")
			end
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

addEvent("market.buyPrivateWeapon", true)
addEventHandler("market.buyPrivateWeapon", root, function(model, price)
	if client ~= source then return end
	if getElementData(source, "balance") >= price then
		if price > 0 then
			local serial1 = tonumber(getElementData(source, "account:character:id"))
			local serial2 = tonumber(getElementData(source, "account:character:id"))
			local mySerial = exports.cr_global:createWeaponSerial(1, serial1, serial2)
			
			if exports.cr_items:hasSpaceForItem(source, 115, model .. ":" .. mySerial .. ":" .. getWeaponNameFromID(model) .. "::") then
				exports.cr_global:giveItem(source, 115, model .. ":" .. mySerial .. ":" .. getWeaponNameFromID(model) .. "::")
				takeBalance(source, price)
				exports.cr_infobox:addBox(source, "success", "Başarıyla " .. exports.cr_global:formatMoney(price) .. " TL karşılığında " .. getWeaponNameFromID(model) .. " markalı silahı satın aldınız.")
				exports.cr_global:sendMessageToAdmins("[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında " .. getWeaponNameFromID(model) .. " markalı silahı satın aldı.")
				exports.cr_discord:sendMessage("market-log", "[MARKET] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(price) .. " TL karşılığında " .. getWeaponNameFromID(model) .. " markalı silahı satın aldı.")
			else
				exports.cr_infobox:addBox(source, "error", "Envanteriniz dolu.")
			end
		else
			banCheater(source)
		end
	else
		exports.cr_infobox:addBox(source, "error", "Yeterli bakiyeniz yok.")
	end
end)

function bakiyeVer(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerHeadAdministrator(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				if amount > 0 then
					local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if getElementData(targetPlayer, "loggedin") == 1 then
							giveBalance(targetPlayer, amount)
							outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya " .. exports.cr_global:formatMoney(amount) .. " TL bakiye verildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size " .. exports.cr_global:formatMoney(amount) .. " TL bakiye verdi.", targetPlayer, 0, 0, 255, true)
							exports.cr_global:sendMessageToAdmins("[ADM] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya " .. exports.cr_global:formatMoney(amount) .. " TL bakiye verdi.")
							exports.cr_discord:sendMessage("market-log", "**[BAKIYE-VER]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. getPlayerName(targetPlayer):gsub("_", " ") .. "** isimli oyuncuya **" .. exports.cr_global:formatMoney(amount) .. " TL** bakiye verdi.")
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("bakiyever", bakiyeVer, false, false)

function bakiyeAl(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerHeadAdministrator(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				if amount > 0 then
					local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if getElementData(targetPlayer, "loggedin") == 1 then
							takeBalance(targetPlayer, amount)
							outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncudan " .. exports.cr_global:formatMoney(amount) .. " TL bakiye alındı.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizden " .. exports.cr_global:formatMoney(amount) .. " TL bakiye aldı.", targetPlayer, 0, 0, 255, true)
							exports.cr_global:sendMessageToAdmins("[ADM] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncudan " .. exports.cr_global:formatMoney(amount) .. " TL bakiye aldı.")
							exports.cr_discord:sendMessage("market-log", "**[BAKIYE-AL]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. getPlayerName(targetPlayer):gsub("_", " ") .. "** isimli oyuncudan **" .. exports.cr_global:formatMoney(amount) .. " TL** bakiye aldı.")
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("bakiyeal", bakiyeAl, false, false)

function bakiyeAyarla(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerHeadAdministrator(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				if amount >= 0 then
					local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if getElementData(targetPlayer, "loggedin") == 1 then
							setBalance(targetPlayer, amount)
							outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun bakiyesini " .. exports.cr_global:formatMoney(amount) .. " TL olarak değiştirildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili bakiyesini " .. exports.cr_global:formatMoney(amount) .. " TL olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
							exports.cr_global:sendMessageToAdmins("[ADM] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun bakiyesini " .. exports.cr_global:formatMoney(amount) .. " TL olarak değiştirdi.")
							exports.cr_discord:sendMessage("market-log", "**[BAKIYE-AYARLA]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. getPlayerName(targetPlayer):gsub("_", " ") .. "** isimli oyuncunun bakiyesini **" .. exports.cr_global:formatMoney(amount) .. " TL** olarak değiştirdi.")
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setbakiye", bakiyeAyarla, false, false)

function bakiyeTransfer(thePlayer, commandName, targetPlayer, amount)
	if targetPlayer then
		amount = math.floor(tonumber(amount))
		if amount then
			if amount > 0 then
				if getElementData(thePlayer, "balance") >= amount then
					local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if thePlayer ~= targetPlayer then
							if getElementData(targetPlayer, "loggedin") == 1 then
								takeBalance(thePlayer, amount)
								giveBalance(targetPlayer, amount)
								
								outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya " .. exports.cr_global:formatMoney(amount) .. " TL bakiyenizi transfer ettiniz.", thePlayer, 0, 255, 0, true)
								outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu size " .. exports.cr_global:formatMoney(amount) .. " TL bakiyesini transfer etti.", targetPlayer, 0, 0, 255, true)
								
								exports.cr_global:sendMessageToAdmins("[BAKİYE-TRANSFER] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya " .. exports.cr_global:formatMoney(amount) .. " TL bakiyesini transfer etti.")
								exports.cr_discord:sendMessage("market-log", "**[BAKİYE-TRANSFER]** **" .. getPlayerName(thePlayer):gsub("_", " ") .. "** isimli oyuncu **" .. getPlayerName(targetPlayer):gsub("_", " ") .. "** isimli oyuncuya **" .. exports.cr_global:formatMoney(amount) .. " TL** bakiyesini transfer etti.")
							else
								outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						else
							outputChatBox("[!]#FFFFFF Kendinize bakiye transfer edemezsiniz.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("[!]#FFFFFF Yeterli bakiyeniz yok.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("bakiyetransfer", bakiyeTransfer, false, false)

function giveBalance(thePlayer, amount)
	setElementData(thePlayer, "balance", math.floor(getElementData(thePlayer, "balance") + amount))
	dbExec(mysql:getConnection(), "UPDATE accounts SET balance = ? WHERE id = ?", getElementData(thePlayer, "balance"), getElementData(thePlayer, "account:id"))
end

function takeBalance(thePlayer, amount)
	setElementData(thePlayer, "balance", math.floor(getElementData(thePlayer, "balance") - amount))
	dbExec(mysql:getConnection(), "UPDATE accounts SET balance = ? WHERE id = ?", getElementData(thePlayer, "balance"), getElementData(thePlayer, "account:id"))
end

function setBalance(thePlayer, amount)
	setElementData(thePlayer, "balance", math.floor(amount))
	dbExec(mysql:getConnection(), "UPDATE accounts SET balance = ? WHERE id = ?", getElementData(thePlayer, "balance"), getElementData(thePlayer, "account:id"))
end

function SmallestID()
	local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

function banCheater(thePlayer)
	exports.cr_global:sendMessageToAdmins("[SAC #7] " .. getPlayerName(thePlayer):gsub("_", " ") .. " (" .. getElementData(thePlayer, "playerid") .. ") isimli oyuncu market hilesi kullandığı için sunucudan yasaklandı.", true)
	exports.cr_global:sendMessageToAdmins(">> IP: " .. getPlayerIP(thePlayer), true)
	exports.cr_global:sendMessageToAdmins(">> Serial: " .. getPlayerSerial(thePlayer), true)
	
	exports.cr_discord:sendMessage("sac-log", "[SAC #7] " .. getPlayerName(thePlayer):gsub("_", " ") .. " (" .. getElementData(thePlayer, "playerid") .. ") isimli oyuncu market hilesi kullandığı için sunucudan yasaklandı.")
	exports.cr_discord:sendMessage("sac-log", ">> IP: " .. getPlayerIP(thePlayer))
	exports.cr_discord:sendMessage("sac-log", ">> Serial: " .. getPlayerSerial(thePlayer))
	
	banPlayer(thePlayer, true, false, true, "Shine Anti-Cheat", "SAC #7")
end