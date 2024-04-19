addEvent("setDrunkness", true)
addEventHandler("setDrunkness", getRootElement(),
	function(level)
		setElementData(source, "alcohollevel", level or 0, false)
	end
)