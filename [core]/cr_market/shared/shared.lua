categories = {
	{"Kişisel Özellikler"},
	{"Araç Özellikleri"},
	{"Özel Araçlar"},
	{"Silahlar"}
}

personalFeatures = {
	-- icon, name, rgb, price, page/event, server/client
	{"", "İsim Değişikliği", {50, 185, 222}, 30, 1},
	{"", "K. Adı Değişikliği", {234, 163, 83}, 30, 2},
	{"", "VIP", {231, 202, 31}, 0, 3},
	{"", "Karakter Slotu (+1)", {45, 218, 157}, 25, "market.buyCharacterSlot", 1},
	{"", "Araç Slotu (+1)", {45, 218, 157}, 25, "market.buyVehicleSlot", 1},
	{"", "Mülk Slotu (+1)", {45, 218, 157}, 25, "market.buyPropertySlot", 1},
	{"", "History Sildirme (-1)", {232, 113, 114}, 5, "market.buyRemoveHistory", 1}
}

vehicleFeatures = {
	-- icon, name, rgb, price, page/event, server/client
	{"", "Plaka Değişikliği", {255, 212, 59}, 30, 1},
	{"", "Cam Filmi", {255, 212, 59}, 50, 2},
	{"", "Neon Sistemi", {255, 212, 59}, 100, "neon.showList", 2},
	{"", "Kaplama Sistemi", {255, 212, 59}, 100, 3},
	{"", "Kelebek Kapı", {255, 212, 59}, 30, 4},
	{"", "Plaka Tasarımı", {255, 212, 59}, 40, "plateDesign.showList", 2}
}

privateVehicles = {
	-- name, model, id, price
	{"Mercedes Maybach", 516, 1101, 300},
	{"Helikopter", 487, 1036, 300},
	{"Cadillac Esclade", 400, 1102, 250},
	{"Audi A7", 529, 1105, 250},
	{"Mercedes-Benz G63", 479, 1111, 225},
	{"Volkswagen Passat", 540, 1108, 200},
	{"Land Rover Range Rover", 490, 1110, 180},
	{"BMW M4", 412, 1112, 130},
	{"Nissan GTR", 474, 1107, 120},
	{"Mercedes AMG GTR", 602, 1104, 100},
	{"BMW i8", 527, 1106, 100}
}

privateWeapons = {
	-- name, model, id, price
	{"M4", 356, 31, 450},
	{"AK-47", 355, 30, 250},
	{"MP5", 353, 29, 175},
	{"Shotgun", 349, 25, 140},
	{"Tec-9", 372, 32, 140},
	{"Uzi", 352, 28, 120},
	{"Deagle", 348, 24, 90},
	{"Colt-45", 346, 22, 60}
}

vips = {
	-- vip, price
	[1] = 2,
	[2] = 4,
	[3] = 6,
	[4] = 8,
	[5] = 10
}

function checkValidCharacterName(text)
	local foundSpace, valid = false, true
	local lastChar, current = " ", ""
	for i = 1, #text do
		local char = text:sub(i, i)
		if char == " " then
			if i == #text then
				valid = false
				return false, "İsminizde yanlışlık bulundu."
			else
				foundSpace = true
			end
			
			if #current < 2 then
				valid = false
				return false, "İsminiz çok kısa."
			end
			current = ""
		elseif lastChar == " " then
			if char < "A" or char > "Z" then
				valid = false
				return false, "İsminizde sadece baş harfler büyük olmalıdır."
			end
			current = current .. char
		elseif (char >= "a" and char <= "z") or (char >= "A" and char <= "Z") or (char == "'") then
			current = current .. char
		else
			valid = false
			return false, "İsminizde uygunsuz karakter olmamalıdır."
		end
		lastChar = char
	end
	
	if valid and foundSpace and #text < 30 and #current >= 3 then
		return true, "Başarılı!"
	else
		return false, "İsminiz çok uzun veya çok kısa, 3 - 30 karakter olmalıdır."
	end
end

function checkValidUsername(text)
	if string.len(text) < 6 then
		return false, "Kullanıcı adınız minimum 3 karakter olmalıdır."
	elseif string.len(text) >= 20 then
		return false, "Kullanıcı adınız maximum 20 karakter olmalıdır."
	elseif string.match(text,"%W") then
		return false, "Kullanıcı adınızda uygunsuz karakter olmamalıdır."
	else
		return true, "Başarılı!"
	end
end

function isPrivateVehicle(model)
    for _, vehicle in ipairs(privateVehicles) do
        if model == vehicle[2] then
            return true
        end
    end
    return false
end