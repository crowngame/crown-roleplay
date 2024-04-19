local function sortTable(a, b)
	if b[2] < a[2] then
		return true
	end

	return false
end

function showStaff(thePlayer, commandName)
	local info = {}

	if getElementData(thePlayer, "loggedin") == 1 then
		local managers = {}

		table.insert(info, {"üst yönetim kurulu", 255, 255, 255, 255, 1, "title"})
		table.insert(info, {""})

		for _, player in ipairs(getElementsByType("player")) do
			if (getElementData(player, "loggedin") == 1) and (getElementData(player, "admin_level") >= 6) then
				managers[#managers + 1] = {player, getElementData(player, "admin_level")}
			end
		end

		table.sort(managers, sortTable)

		for _, value in ipairs(managers) do
			local player = value[1]
			
			if (getElementData(player, "hiddenadmin") ~= 1) or (exports.cr_integration:isPlayerManagement(thePlayer)) or (player == thePlayer) then
				if (getElementData(player, "duty_admin") == 1) then
					table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 87, 255, 111, 200, 1, "default"})
				else
					table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 88, 88, 88, 200, 1, "default"})
				end
			end
		end
		
		if #managers == 0 then
			table.insert(info, {" Aktif üst yönetim yok.", 88, 88, 88, 200, 1, "default"})
		end
	end
	
	table.insert(info, {""})

	if getElementData(thePlayer, "loggedin") == 1 then
		local admins = {}

		table.insert(info, {"yetkili takımı", 255, 255, 255, 255, 1, "title"})
		table.insert(info, {""})

		for _, player in ipairs(getElementsByType("player")) do
			if (getElementData(player, "loggedin") == 1) and (getElementData(player, "admin_level") >= 1 and getElementData(player, "admin_level") <= 5) then
				admins[#admins + 1] = {player, getElementData(player, "admin_level")}
			end
		end

		table.sort(admins, sortTable)

		for _, value in ipairs(admins) do
			local player = value[1]
			
			if (getElementData(player, "hiddenadmin") ~= 1) or (exports.cr_integration:isPlayerManagement(thePlayer)) or (player == thePlayer) then
				if (getElementData(player, "duty_admin") == 1) then
					table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 87, 255, 111, 200, 1, "default"})
				else
					table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 88, 88, 88, 200, 1, "default"})
				end
			end
		end
		
		if #admins == 0 then
			table.insert(info, {" Aktif yetkili yok.", 88, 88, 88, 200, 1, "default"})
		end
	end

	table.insert(info, {""})

	if getElementData(thePlayer, "loggedin") == 1 then
		local helpers = {}

		table.insert(info, {"rehber takımı", 255, 255, 255, 255, 1, "title"})
		table.insert(info, {""})

		for _, player in ipairs(getElementsByType("player")) do
			if (getElementData(player, "loggedin") == 1) and (exports.cr_integration:isPlayerHelper(player)) then
				helpers[#helpers + 1] = {player, getElementData(player, "supporter_level"), getElementData(player, "duty_supporter")}
			end
		end

		table.sort(helpers, sortTable)

		for _, value in ipairs(helpers) do
			local player = value[1]
			
			if (getElementData(player, "hiddenadmin") ~= 1) or (exports.cr_integration:isPlayerManagement(thePlayer)) or (player == thePlayer) then
				if (getElementData(player, "duty_admin") == 1) then
					table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 87, 255, 111, 200, 1, "default"})
				else
					table.insert(info, {" " .. exports.cr_global:getPlayerAdminTitle(player) .. " " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "account:username") .. ")", 88, 88, 88, 200, 1, "default"})
				end
			end
		end
		
		if #helpers == 0 then
			table.insert(info, {" Aktif rehber yok.", 88, 88, 88, 200, 1, "default"})
		end
	end
	
	table.insert(info, {""})

	if getElementData(thePlayer, "loggedin") == 1 then
		exports.cr_hud:sendTopRightNotification(thePlayer, info, 350)
	end
end
addCommandHandler("admin", showStaff, false, false)
addCommandHandler("admins", showStaff, false, false)