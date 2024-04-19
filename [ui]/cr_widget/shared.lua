categories = {
	{"Hud Görünüşü"},
	{"Speedo Görünüşü"},
	{"Radar Görünüşü"}
}

huds = {
	{"Definitive Hud"},
	{"GTA Hud"},
	{"Gradyan Hud"},
	{"Rectangle Hud"},
	{"Crown Hud"},
	{"Gizle"}
}

speedos = {
	{"SA:MP Speedo"},
	{"Klasik Speedo"},
	{"Modern Speedo"},
	{"Gizle"}
}

radars = {
	{"Modern Radar"},
	{"GTA Radar"},
	{"Gizle"}
}

moneySuff = {"K", "M", "B", "T", "Q"}

bulletWeapons = {
	[22] = true,
	[23] = true,
	[24] = true,
	[25] = true,
	[26] = true,
	[27] = true,
	[28] = true,
	[29] = true,
	[32] = true,
	[30] = true,
	[31] = true,
	[33] = true,
	[34] = true,
	[35] = true,
	[36] = true,
	[37] = true,
	[38] = true,
	[16] = true,
	[17] = true,
	[18] = true,
	[39] = true,
	[41] = true,
	[42] = true,
	[43] = true,
}

function getElementSpeed(element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100)
        else
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100 * 1.609344)
        end
    else
        return false
    end
end

function getFormatSpeed(unit)
    if unit < 10 then
        unit = "#aaaaaa00#ffffff" .. unit
    elseif unit < 100 then
        unit = "#aaaaaa0#ffffff" .. unit
    elseif unit >= 1000 then
        unit = "999"
    end
    return unit
end

function convertMoney(cMoney)
	didConvert = 0
	if not cMoney then
		return "?"
	end
	while cMoney / 1000 >= 1 do
		cMoney = cMoney / 1000
		didConvert = didConvert + 1
	end
	if didConvert > 0 then
		return "$" .. string.format("%.2f", cMoney) .. moneySuff[didConvert]
	else
		return "$" .. cMoney
	end
end