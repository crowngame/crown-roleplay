addEvent("outputChatBox", true)
addEventHandler("outputChatBox", root, function(text, visibleTo, r, g, b, colorCoded)
	if client ~= source then return end
	outputChatBox(text, visibleTo, r, g, b, colorCoded)
end)