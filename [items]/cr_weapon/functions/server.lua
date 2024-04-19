--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 Crown Roleplay Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to Crown Roleplay Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

function modifyPlayerItemValues(player, dbid, values, skin_update_localguns)
	local weap, inv_slot = getPlayerWeaponFromDbid(player, dbid, true)
	if weap then
		local finale = nil
		for i, v in pairs(values) do
			finale = modifyWeaponValue(weap[2], i, v)
		end
		if finale then
			local result = exports["cr_items"]:updateItemValue(player, inv_slot, finale)
			if not skin_update_localguns then
				updateLocalGuns(player)
			end
			return result
		end
	end
end

function removeSatchel(targetPlayer, weapon)
	for inv_slot, item in ipairs(exports["cr_items"]:getItems(targetPlayer)) do
		if item[1] == 115 then
			local gunDetails = exports.cr_global:explode(':', item[2])
			if gunDetails[3] == "Satchel" then
				exports["cr_items"]:takeItem(targetPlayer, 115, item[2])
			end
		end
	end
end
addEvent("weapon:removeSatchel", true)
addEventHandler("weapon:removeSatchel", getRootElement(), removeSatchel)