function addBox(element, type, message)
    if client ~= source then return end
	triggerClientEvent(element, "infobox.addBox", element, type, message, 10000)
end