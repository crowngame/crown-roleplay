function tryLuck(thePlayer, commandName , pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 == nil and pa2 == nil and pa3 == nil then
		exports.cr_global:sendLocalText(thePlayer, "((OOC Şans)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi 1 ile 100 arasında şansını dener ve " .. math.random(100) .. " rakamı gelir.", 255, 51, 102, 30, {}, true)
	elseif pa1 ~= nil and p1 ~= nil and pa2 == nil then
		exports.cr_global:sendLocalText(thePlayer, "((OOC Şans)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi 1 ile " .. p1 .. " arasında şansını dener ve " .. math.random(p1) .. " rakamı gelir.", 255, 51, 102, 30, {}, true)
	else
		outputChatBox("KULLANIM: /" .. commandName .. "                  - 1 ile 100 arasında sayı çek", thePlayer, 255, 194, 14)
		outputChatBox("KULLANIM: /" .. commandName .. " [maksimum]         - 1 ile [maksimum] arasında sayı çek", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("sans", tryLuck)

function tryChance(thePlayer, commandName , pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 ~= nil then 
		if pa2 == nil and p1 ~= nil then
			if p1 <= 100 and p1 >=0 then
				if math.random(100) >= p1 then
					exports.cr_global:sendLocalText(thePlayer, "((OOC Şans - %" .. p1 .. ")) " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişinin denemesi başarısız oldu.", 255, 51, 102, 30, {}, true)
				else
					exports.cr_global:sendLocalText(thePlayer, "((OOC Şans - %" .. p1 .. ")) " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişinin denemesi başarılı oldu.", 255, 51, 102, 30, {}, true)
				end
			else
				outputChatBox("İhtimaller 0 ile 100% arasında olmalıdır.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [0-100%]                 - [0-100%] ihtimalle başarabilme şansınız", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [0-100%]                 - [0-100%] ihtimalle başarabilme şansınız", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("chance", tryChance)
addCommandHandler("sans2", tryChance)

function oocCoin(thePlayer)
	if  math.random(1, 2) == 2 then
		exports.cr_global:sendLocalText(thePlayer, " ((OOC Yazı Tura)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " bir madeni para fırlatır, para yazıdır.", 255, 51, 102)
	else
		exports.cr_global:sendLocalText(thePlayer, " ((OOC Yazı Tura)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " bir madeni para fırlatır, para turadır.", 255, 51, 102)
	end
end
addCommandHandler("flipcoin", oocCoin)
addCommandHandler("yazitura", oocCoin)