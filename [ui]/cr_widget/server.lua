addEventHandler("onElementDataChange", root, function(theKey, oldValue, newValue)
	if getElementData(source, "loggedin") == 1 then
		if theKey == "money" then
			setPlayerMoney(source, (newValue or 0))
		end
	end
end)