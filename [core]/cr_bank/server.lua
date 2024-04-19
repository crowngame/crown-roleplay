connection = exports.cr_mysql

addEvent("bank.deposit", true)
addEventHandler("bank.deposit", root, function(amount)
	amount = tonumber(amount)
	if amount then
		if amount > 0 then
			if exports.cr_global:hasMoney(source, amount) then
				exports.cr_global:takeMoney(source, amount)
				setElementData(source, "bankmoney", getElementData(source, "bankmoney") + amount)
				outputChatBox("[!]#FFFFFF Banka hesabınıza $" .. exports.cr_global:formatMoney(amount) .. " para yatırdınız.", source, 0, 255, 0, true)
				dbExec(connection:getConnection(), "UPDATE `characters` SET `bankmoney`=? WHERE `id`=?", getElementData(source, "bankmoney"), getElementData(source, "dbid"))
			else
                triggerClientEvent(source, "atm:error", source, "Yeterli miktarda paranız bulunmuyor.")
			end
		else
            triggerClientEvent(source, "atm:error", source, "Bir şeyler ters gitti!")
		end
	else
        triggerClientEvent(source, "atm:error", source, "Lütfen geçerli bir miktar girin.")
	end
end)

addEvent("bank.withdraw", true)
addEventHandler("bank.withdraw", root, function(amount)
	amount = tonumber(amount)
	if amount then
		if amount > 0 then
			if getElementData(source, "bankmoney") >= amount then
				setElementData(source, "bankmoney", getElementData(source, "bankmoney") - amount)
				exports.cr_global:giveMoney(source, amount)
				outputChatBox("[!]#FFFFFF Banka hesabınızdan $" .. exports.cr_global:formatMoney(amount) .. " para çektiniz.", source, 0, 255, 0, true)
				dbExec(connection:getConnection(), "UPDATE `characters` SET `bankmoney`=? WHERE `id`=?", getElementData(source, "bankmoney"), getElementData(source, "dbid"))
			else
                triggerClientEvent(source, "atm:error", source, "Yeterli miktarda paranız bulunmuyor.")
			end
		else
            triggerClientEvent(source, "atm:error", source, "Bir şeyler ters gitti!")
		end
	else
        triggerClientEvent(source, "atm:error", source, "Lütfen geçerli bir miktar girin.")
	end
end)

addEventHandler('onResourceStart', resourceRoot, function()
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				local id = tonumber(row["id"])
				local x = tonumber(row["x"])
				local y = tonumber(row["y"])
				local z = tonumber(row["z"])

				local rotation = tonumber(row["rotation"])
				local dimension = tonumber(row["dimension"])
				local interior = tonumber(row["interior"])
				local deposit = tonumber(row["deposit"])
				local limit = tonumber(row["limit"])
				
				local object = createObject(2942, x, y, z, 0, 0, rotation-180)
				exports.cr_pool:allocateElement(object)
				setElementDimension(object, dimension)
				setElementInterior(object, interior)
				setElementData(object, "depositable", deposit)
				setElementData(object, "limit", limit)
				setElementData(object, "bank-operation", true)
				
				local px = x + math.sin(math.rad(-rotation)) * 0.8
				local py = y + math.cos(math.rad(-rotation)) * 0.8
				local pz = z
				
				setElementData(object, "dbid", id, true)
			end
		end
	end, connection:getConnection(), "SELECT id, x, y, z, rotation, dimension, interior, deposit, `limit` FROM atms")
end)