function giveDuplicatedKey(thePlayer, itemID, value, cost)
	if thePlayer and itemID and value and cost then
		exports.cr_global:giveItem(thePlayer, tonumber(itemID), tonumber(value))
		exports.cr_global:takeMoney(thePlayer, cost)
	end
end
addEvent("locksmithNPC:givekey", true)
addEventHandler("locksmithNPC:givekey", resourceRoot, giveDuplicatedKey)