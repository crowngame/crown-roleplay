local sudakPara = 120
local denizPara = 100
local derePara = 50
local dagPara = 50
local istPara = 200

local kirmiziPara = 5000
local maviPara = 2500
local beyazPara = 1000

local yemCol = createColSphere(355.09765625, -2027.5849609375, 7.8359375, 5)
local balikCol = createColPolygon(360.2646484375, -2047.708984375, 349.84375, -2047.708984375, 349.8466796875, -2088.7978515625, 409.24609375, -2088.7978515625, 409.25390625, -2047.7099609375, 399.392578125, -2047.7099609375, 399.513671875, -2048.248046875, 408.4306640625, -2048.2607421875, 408.322265625, -2087.6474609375, 350.8984375, -2087.5585937, 350.7744140625, -2048.453125, 360.427734375, -2048.681640625, 360.2431640625, -2047.709960937)

function balikYardim(thePlayer)
	if isElementWithinColShape(thePlayer, yemCol) then
		outputChatBox("================================================================", thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF Balıkçı Mesleği Yardım Menüsüne Hoşgeldiniz!", thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF Komutlar:", thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF /yemal - Yem almanızı sağlar.", thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF /baliktut - Balık tutmanızı sağlar.", thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF /baliksat - Envanterinizdeki balıkları satmanızı sağlar.", thePlayer, 0, 0, 255, true)
		outputChatBox("[!]#FFFFFF /balikDurum - Balık ve Yem için bilgi almanızı sağlar.", thePlayer, 0, 0, 255, true)
		outputChatBox("================================================================", thePlayer, 0, 0, 255, true)
	end
end
addCommandHandler("balikyardim", balikYardim, false, false)

addCommandHandler("baliktut", function(thePlayer, commandName)
	if isElementWithinColShape(thePlayer, balikCol) then
		if (not getElementData(thePlayer, "balikTutuyor")) then
			local toplamyem = getElementData(thePlayer, "toplamyem") or 0
			if toplamyem > 0 then
				triggerEvent("artifacts:toggle", thePlayer, thePlayer, "rod")
				setElementData(thePlayer, "balikTutuyor", true)
				setElementFrozen(thePlayer, true)
				exports.cr_global:applyAnimation(thePlayer, "SWORD", "sword_IDLE", -1, false, true, true, false)
				exports.cr_global:sendLocalMeAction(thePlayer, "oltasını denize doğru sallar.", false, true)
				outputChatBox("[!]#FFFFFF Balık tutuyorsunuz, lütfen bekleyin!", thePlayer, 0, 0, 255, true)
				setElementData(thePlayer, "toplamyem", toplamyem - 1)
				setTimer(function(thePlayer)
					local rastgeleSayi = math.random(1, 2)
					if rastgeleSayi == 1 then
						local balikTipi1 = yuzdelikOran(50)
						local balikTipi2 = yuzdelikOran(50)
						local balikTipi3 = yuzdelikOran(50)
						local balikTipi4 = yuzdelikOran(50)
						if balikTipi3 then
							exports.cr_items:giveItem(thePlayer, 290, 1) 
							outputChatBox("[!]#FFFFFF Tebrikler, bir adet 'Hamsi' tuttunuz!", thePlayer, 0, 255, 0, true)					
						elseif balikTipi2 then
							exports.cr_items:giveItem(thePlayer, 291, 1)
							outputChatBox("[!]#FFFFFF Tebrikler, bir adet 'Dağ Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)
						elseif balikTipi1 then
							exports.cr_items:giveItem(thePlayer, 292, 1)
							outputChatBox("[!]#FFFFFF Tebrikler, bir adet 'Deniz Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)		
						elseif balikTipi4 then
							exports.cr_items:giveItem(thePlayer, 555, 1)
							outputChatBox("[!]#FFFFFF Tebrikler, bir adet 'İstiridye' tuttunuz!", thePlayer, 0, 255, 0, true)		
						else
							exports.cr_items:giveItem(thePlayer, 293, 1)
							outputChatBox("[!]#FFFFFF Tebrikler, bir adet 'Dere Alabalığı' tuttunuz!", thePlayer, 0, 255, 0, true)		
						end
					elseif rastgeleSayi >= 2 then
						outputChatBox("[!]#FFFFFF Malesef, balık tutamadınız.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
					
					exports.cr_global:removeAnimation(thePlayer)
					triggerEvent("artifacts:toggle", thePlayer, thePlayer, "rod")
					setElementData(thePlayer, "balikTutuyor", false)
					setElementFrozen(thePlayer, false)
				end, 10000, 1, thePlayer)
			else
				outputChatBox("[!]#FFFFFF Malesef, üzerinizde yem kalmadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end
	end
end, false, false)

function balikDurum(thePlayer, commandName)
	local yem = getElementData(thePlayer, "toplamyem") or 0
    local toplamBalik = exports.cr_items:countItems(thePlayer, 290, 1) + exports.cr_items:countItems(thePlayer, 291, 1) + exports.cr_items:countItems(thePlayer, 292, 1)  + exports.cr_items:countItems(thePlayer, 293, 1)
    local toplamIstiridye = exports.cr_items:countItems(thePlayer,555,1)
	outputChatBox("=========================================", thePlayer, 0, 0, 255)
    outputChatBox("[!]#FFFFFF Toplam Balık: " .. tostring(toplamBalik), thePlayer, 0, 0, 255, true)
    outputChatBox("[!]#FFFFFF Toplam İstiridye: " .. tostring(toplamIstiridye), thePlayer, 0, 0, 255, true)
	outputChatBox("[!]#FFFFFF Toplam Yem: " .. tostring(yem), thePlayer, 0, 0, 255, true)
	outputChatBox("=========================================", thePlayer, 0, 0, 255)
end
addCommandHandler("balikdurum", balikDurum, false, false)
addCommandHandler("toplambalik", balikDurum, false, false)
addCommandHandler("balik", balikDurum, false, false)

function yemAl(thePlayer, commandName)
	local para = exports.cr_global:getMoney(thePlayer)
	if para >= 50 then
		if isElementWithinColShape(thePlayer, yemCol) then
			local toplamyem = getElementData(thePlayer, "toplamyem") or 0
			if toplamyem >= 20 then
				outputChatBox("[!]#FFFFFF Malesef, daha fazla yem alamazsınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			elseif toplamyem <= 20 then
				exports.cr_global:takeMoney(thePlayer, 5)
				if (toplamyem + 10) <= 20 then
					setElementData(thePlayer, "toplamyem", toplamyem + 10)
					outputChatBox("[!]#FFFFFF 10 adet yem aldınız.", thePlayer, 0, 0, 255, true)
				elseif (toplamyem + 10) >= 20 then
					alinamayanYem = toplamyem + 10 - 20
					alinanYem = 10 - alinamayanYem
					setElementData(thePlayer, "toplamyem", 20)
					outputChatBox("[!]#FFFFFF " .. tostring(alinanYem) .. " adet yem aldınız.", thePlayer, 0, 0, 255, true)
				end
			end
		end
	else
		outputChatBox("[!]#FFFFFF Yem almak için yeterli paranız yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("yemal", yemAl, false, false)

function balikSat(thePlayer, commandName)
	local denizMiktar = exports.cr_items:countItems(thePlayer, 292, 1)
	local dagMiktar = exports.cr_items:countItems(thePlayer, 291, 1)
	local dereMiktar = exports.cr_items:countItems(thePlayer, 293, 1)
    local sudakMiktar = exports.cr_items:countItems(thePlayer, 290, 1)
    local istiridyeMiktar = exports.cr_items:countItems(thePlayer, 555, 1)
    local kirmizi = exports.cr_items:countItems(thePlayer, 556, 1)
    local mavi = exports.cr_items:countItems(thePlayer, 557, 1)
    local beyaz = exports.cr_items:countItems(thePlayer, 559, 1)

	if isElementWithinColShape(thePlayer, yemCol) then
		local toplambalik = denizMiktar + dagMiktar + dereMiktar + sudakMiktar + istiridyeMiktar + kirmizi + mavi + beyaz
		if toplambalik <= 0 then
			outputChatBox("[!]#FFFFFF Satacak balığınız yok!", thePlayer, 255, 0, 0, true)
		else
			verilecekPara = (denizMiktar * denizPara) + (dagMiktar * dagPara) + (dereMiktar * derePara) + (sudakMiktar * sudakPara) + (istiridyeMiktar * istPara) + (kirmizi * kirmiziPara) + (mavi * maviPara) + (beyaz * beyazPara)
			exports.cr_global:giveMoney(thePlayer, verilecekPara)
			for i = 0, denizMiktar do
				exports.cr_items:takeItem(thePlayer, 292, 1)
			end
			for i = 0, dagMiktar do
				exports.cr_items:takeItem(thePlayer, 291, 1)
			end
			for i = 0, dereMiktar do
				exports.cr_items:takeItem(thePlayer, 293, 1)
			end
			for i = 0, sudakMiktar do
				exports.cr_items:takeItem(thePlayer, 290, 1)
            end
            for i = 0, istiridyeMiktar do
				exports.cr_items:takeItem(thePlayer, 555, 1)
            end
            for i = 0, kirmizi do
				exports.cr_items:takeItem(thePlayer, 556, 1)
            end
            for i = 0, mavi do
				exports.cr_items:takeItem(thePlayer, 557, 1)
            end
            for i = 0, beyaz do
				exports.cr_items:takeItem(thePlayer, 559, 1)
			end
			outputChatBox("[!]#FFFFFF " .. tostring(toplambalik) .. " tane balık & istiridyeden toplam $" .. tostring(verilecekPara) .. " kazandınız.", thePlayer, 0, 255, 0, true)
            outputChatBox("[!]#FFFFFF " .. tostring(kirmizi) .. " Kırmızı İnciden $" .. tostring(kirmizi * kirmiziPara) .. " kazandınız.", thePlayer, 0, 255, 0, true)
            outputChatBox("[!]#FFFFFF " .. tostring(mavi) .. " Mavi İnciden $" .. tostring(mavi * maviPara) .. " kazandınız.", thePlayer, 0, 255, 0, true)
            outputChatBox("[!]#FFFFFF " .. tostring(beyaz) .. " Beyaz İnciden '$" .. tostring(beyaz * beyazPara) .. " kazandınız.", thePlayer, 0, 255, 0, true)
		end
	end
end
addCommandHandler("baliksat", balikSat, false, false)

function istiridyeOpen(thePlayer)
	if exports.cr_global:hasItem(thePlayer,555,1) then 
		local rastgeleSayi = math.random(1,2)
		if rastgeleSayi == 1 then
			local istiridye1 = yuzdelikOran(50)
			local istiridye2 = yuzdelikOran(50)
			local istiridye3 = yuzdelikOran(50)
			local istiridye4 = yuzdelikOran(50)
			
			if istiridye3 then
				exports.cr_global:takeItem(thePlayer,555,1)
				exports.cr_global:sendLocalDoAction(thePlayer, "İstiridyesini açtı, içi boş.", false, true)	
				outputChatBox("[!]#FFFFFF Üzgünüm, istiridyenin için boş çıktı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			elseif istiridye2 then
				exports.cr_global:takeItem(thePlayer,555,1)
				exports.cr_global:giveItem(thePlayer,559,1)
				exports.cr_global:sendLocalDoAction(thePlayer, "İstiridyesini açtı, içinden Beyaz İnci çıktı.", false, true)	
				outputChatBox("[!]#FFFFFF Tebrikler, istiridyenin içinden #999999Beyaz #FFFFFFİnci çıktı.", thePlayer, 0, 255, 0, true)
			elseif istiridye1 then
				exports.cr_global:takeItem(thePlayer,555,1)
				exports.cr_global:giveItem(thePlayer,557,1)
				exports.cr_global:sendLocalDoAction(thePlayer, "İstiridyesini açtı, içinden Mavi İnci çıktı.", false, true)	
				outputChatBox("[!]#FFFFFF Tebrikler, istiridyenin içinden #3530c4Mavi #FFFFFFİnci çıktı.", thePlayer, 0, 255, 0, true)
			elseif istiridye4 then
				exports.cr_global:takeItem(thePlayer,555,1)
				exports.cr_global:giveItem(thePlayer,556,1)
				exports.cr_global:sendLocalDoAction(thePlayer, "İstiridyesini açtı, içinden Kırmızı İnci çıktı.", false, true)	
				outputChatBox("[!]#FFFFFF Tebrikler, istiridyenin içinden #FF0000Kırmızı #FFFFFFİnci çıktı.", thePlayer, 0, 255, 0, true)
			else 
				exports.cr_global:takeItem(thePlayer,555,1)
				exports.cr_global:sendLocalDoAction(thePlayer, "İstiridyesini açtı, içi boş.", false, true)
				outputChatBox("[!]#FFFFFF Üzgünüm, istiridyenin için boş çıktı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		elseif rastgeleSayi >= 2 then
			exports.cr_global:takeItem(thePlayer,555,1)
			exports.cr_global:sendLocalDoAction(thePlayer, "İstiridyesini açtı, içi boş.", false, true)
			outputChatBox("[!]#FFFFFF Üzgünüm, istiridyenin için boş çıktı.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("[!]#FFFFFF Üzerinde açabiliceğin bir istiridye yok.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("istiridyeac", istiridyeOpen, false, false)
addCommandHandler("istiridye", istiridyeOpen, false, false)

function yuzdelikOran(percent)
	assert(percent >= 0 and percent <= 100) 
	return percent >= math.random(1, 100)
end