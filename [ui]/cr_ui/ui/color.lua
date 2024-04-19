local colors = {
	rgb = tocolor(116, 192, 252, 255),
	hex = "#74C0FC",
	rgba = "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF"
}
local colorsState = {}

function getServerColor(type, alpha)
	if type == 1 then
		if alpha and tonumber(alpha) then
			return tocolor(bitExtract(colors.rgb, 16, 8), bitExtract(colors.rgb, 8, 8), bitExtract(colors.rgb, 0, 8), alpha)
		end
		return colors.rgb
	elseif type == 2 then
		return colors.hex
	elseif type == 3 then
		return colors.rgba
	end
end

function rgbaUnpack(hex, _alpha)
    if not tostring(hex) then
        return hex
    end

    local alpha = _alpha or 1

    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)
    local a = tonumber(hex:sub(8, 9), 16) or (alpha * 255)

    return r, g, b, a
end

function rgba(hex, _alpha)
    if not tostring(hex) then
        return hex
    end

    local alpha = _alpha or 1
    local colorKey = tostring(hex) .. tostring(alpha)
    if colorsState[colorKey] then
        return colorsState[colorKey]
    end

    local r, g, b, a = rgbaUnpack(hex, alpha)

    colorsState[colorKey] = tocolor(r, g, b, a)
    return colorsState[colorKey]
end
