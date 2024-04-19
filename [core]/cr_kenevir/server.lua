local kenevirBolge = createColSphere(1953.57421875, 206.6494140625, 30.77165222168, 28, 3, 81)
local islemeBolge = createColSphere(2201.27734375, -1970.216796875, 13.78413105011, 2)

function kenevirSystem(thePlayer, commandName, argument)
	if not argument then
		outputChatBox("KULLANIM: /" .. commandName .. " [topla / isle]", thePlayer, 255, 194, 14)
	else
		if argument == "topla" then
		    if getElementData(thePlayer, "kenevir:toplaniyor") then
				outputChatBox("[!]#FFFFFF Henüz kenevir toplama işlemini tamamlamadınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end

			if getPedOccupiedVehicle(thePlayer) then
				outputChatBox("[!]#FFFFFF Taşıtın içerisinden kenevir toplayamazsınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end

			if not isElementWithinColShape(thePlayer, kenevirBolge) then
				outputChatBox("[!]#FFFFFF Kenevir toplama bölgesinde değilsiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			else
				setElementData(thePlayer, "kenevir:toplaniyor", true)
				outputChatBox("[!]#FFFFFF Kenevir toplamaya başladınız.", thePlayer, 0, 0, 255, true)
				setElementFrozen(thePlayer, true)
				exports.cr_global:applyAnimation(thePlayer, "bomber", "bom_plant_loop", -1, true, false, false)
				setTimer(function()
					outputChatBox("[!]#FFFFFF Başarıyla 1 adet kenevir topladınız.", thePlayer, 0, 255, 0, true)
					exports.cr_global:applyAnimation(thePlayer)
					setElementFrozen(thePlayer, false)
					setElementData(thePlayer, "kenevir:toplaniyor", false)
					exports.cr_items:giveItem(thePlayer, 401, 1)
				end, 15000, 1)
			end
		elseif argument == "isle" then
			if getElementData(thePlayer, "kenevir:isleniyor") then
				outputChatBox("[!]#FFFFFF Henüz kenevir işleme işlemini tamamlamadınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end

			if getPedOccupiedVehicle(thePlayer) then
				outputChatBox("[!]#FFFFFF Taşıtın içerisinden kenevir işleyemezsiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end

			if not exports.cr_global:hasItem(thePlayer, 401) then 
				outputChatBox("[!]#FFFFFF Üzerinizde işlenecek kenevir bulunmamaktadır.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end

			if not isElementWithinColShape(thePlayer, islemeBolge) then
				outputChatBox("[!]#FFFFFF Kenevir işleme bölgesinde değilsiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			else
				setElementData(thePlayer, "kenevir:isleniyor", true)
				outputChatBox("[!]#FFFFFF Kenevir işlemeye başladınız.", thePlayer, 0, 0, 255, true)
				setElementFrozen(thePlayer, true)
				exports.cr_global:applyAnimation(thePlayer, "bomber", "bom_plant_loop", -1, true, false, false)
				exports.cr_items:takeItem(thePlayer,401,1)
				setTimer(function()					
					exports.cr_global:applyAnimation(thePlayer)
					setElementFrozen(thePlayer, false)
					setElementData(thePlayer, "kenevir:isleniyor", false)
					
					if getElementData(thePlayer, "vip") == 5 then
						exports.cr_global:giveMoney(thePlayer, 250)
						outputChatBox("[!]#FFFFFF Başarıyla 1 adet kenevir işlediniz ve VIP [5] olduğunuz için 250$ kazandınız.", thePlayer, 0, 255, 0, true)
					elseif getElementData(thePlayer, "vip") == 4 then
						exports.cr_global:giveMoney(thePlayer, 200)
						outputChatBox("[!]#FFFFFF Başarıyla 1 adet kenevir işlediniz ve VIP [4] olduğunuz için 200$ kazandınız.", thePlayer, 0, 255, 0, true)
					elseif getElementData(thePlayer, "vip") == 3 then
						exports.cr_global:giveMoney(thePlayer, 150)
						outputChatBox("[!]#FFFFFF Başarıyla 1 adet kenevir işlediniz ve VIP [3] olduğunuz için 150$ kazandınız.", thePlayer, 0, 255, 0, true)
					elseif getElementData(thePlayer, "vip") == 2 then
						exports.cr_global:giveMoney(thePlayer, 100)
						outputChatBox("[!]#FFFFFF Başarıyla 1 adet kenevir işlediniz ve VIP [2] olduğunuz için 100$ kazandınız.", thePlayer, 0, 255, 0, true)
					elseif getElementData(thePlayer, "vip") == 1 then
						exports.cr_global:giveMoney(thePlayer, 75)
						outputChatBox("[!]#FFFFFF Başarıyla 1 adet kenevir işlediniz ve VIP [1] olduğunuz için 75$ kazandınız.", thePlayer, 0, 255, 0, true)
					else
						exports.cr_global:giveMoney(thePlayer, 50)
						outputChatBox("[!]#FFFFFF Başarıyla 1 adet kenevir işlediniz ve 50$ kazandınız.", thePlayer, 0, 255, 0, true)
					end
				end, 10000, 1)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [topla / isle]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("kenevir", kenevirSystem, false, false)