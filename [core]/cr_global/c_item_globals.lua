function hasSpaceForItem(...)
	return call(getResourceFromName("cr_items"), "hasSpaceForItem", ...)
end

function hasItem(element, itemID, itemValue)
	return call(getResourceFromName("cr_items"), "hasItem", element, itemID, itemValue)
end

function getItemName(itemID)
	return call(getResourceFromName("cr_items"), "getItemName", itemID)
end
