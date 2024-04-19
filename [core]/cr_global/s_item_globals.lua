function hasSpaceForItem(...)
	return call(getResourceFromName("cr_items"), "hasSpaceForItem", ...)
end

function hasItem(element, itemID, itemValue)
	return call(getResourceFromName("cr_items"), "hasItem", element, itemID, itemValue)
end

function giveItem(element, itemID, itemValue)
	return call(getResourceFromName("cr_items"), "giveItem", element, itemID, itemValue, false, true)
end

function takeItem(element, itemID, itemValue)
	return call(getResourceFromName("cr_items"), "takeItem", element, itemID, itemValue)
end
