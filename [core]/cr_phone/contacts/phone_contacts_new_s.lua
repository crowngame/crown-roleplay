--Farid

addEvent("phone:addContact", true)
function addPhoneContact(name, number, phoneBookPhone)
	if (client) then
		if not phoneBookPhone then
			triggerClientEvent(client, "phone:addContactResponse", client, false)
			return
		end
		
		if not exports.cr_global:hasItem(client,2, tonumber(phoneBookPhone)) then
			triggerClientEvent(client, "phone:slidePhoneOut", client)
			return
		end
		
		if name and number then
			if tonumber(number) then
				local insertedId = mysql:query_insert_free("INSERT INTO `phone_contacts` (`phone`, `entryName`, `entryNumber`) VALUES ('" ..   (tostring(phoneBookPhone)) .. "', '" ..   (name)  .. "', '" ..   (number)  .. "')") 
				if insertedId then
					triggerClientEvent(client, "phone:addContactResponse", client, insertedId, name, number)
					return
				end
			end
		end

		outputChatBox("Internal Error! Code: RFS45235, please report this on http://bugs.crownroleplay.net.", client, 255,0,0)
		triggerClientEvent(client, "phone:addContactResponse", client, false)
	end
end
addEventHandler("phone:addContact", getRootElement(), addPhoneContact)