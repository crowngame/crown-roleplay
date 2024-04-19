function sendTopRightNotification(contentArray, thePlayer, widthNew, posXOffset, posYOffset, cooldown) --Client-side
	triggerEvent("hudOverlay:drawOverlayTopRight", thePlayer, contentArray, widthNew, posXOffset, posYOffset, cooldown)
end

local moneyFloat = {}
local toggleMoneyUpdate = false

function moneyUpdateFX(state, amount, toEachother)
	if not toggleMoneyUpdate then
		if amount and tonumber(amount) and tonumber(amount) > 0  then
			local info = {{"finans güncellemesi"},{""}}
			local money = localPlayer:getData("money") or 0
			local textType = "kullanıcı bilgileri güncellemesi"
			local bankmoney = localPlayer:getData("bankmoney") or 0
			if state then
				setSoundVolume(playSound("sounds/collectMoney.mp3"), 0.2)
				moneyFloat["mR"] = 20
				moneyFloat["mG"] = 255
				moneyFloat["mB"] = 20
				moneyFloat["mAlpha"] = 255
				moneyFloat["direction"] = 1
				moneyFloat["moneyYOffset"] = 60
				moneyFloat["text"] = "+$" .. exports.cr_global:formatMoney(amount)

				table.insert(info, {" Cüzdan: $" .. exports.cr_global:formatMoney(money) .. " (" .. moneyFloat["text"] .. ")"})
				if toEachother then
					table.insert(info, {" Bankadaki Para: $" .. exports.cr_global:formatMoney(bankmoney-amount)})
				else
					table.insert(info, {" Bankadaki Para: $" .. exports.cr_global:formatMoney(bankmoney)})
				end
			else
				setSoundVolume(playSound("sounds/payMoney.mp3"), 0.2)
				moneyFloat["mR"] = 255
				moneyFloat["mG"] = 20
				moneyFloat["mB"] = 20
				moneyFloat["mAlpha"] = 255
				moneyFloat["direction"] = -1
				moneyFloat["moneyYOffset"] = 180
				moneyFloat["text"] = "-$" .. exports.cr_global:formatMoney(amount)

				table.insert(info, {" Cüzdan: $" .. exports.cr_global:formatMoney(money) .. " (" .. moneyFloat["text"] .. ")"})
				if toEachother then
					table.insert(info, {" Bankadaki Para: $" .. exports.cr_global:formatMoney(bankmoney+amount)})
				else
					table.insert(info, {" Bankadaki Para: $" .. exports.cr_global:formatMoney(bankmoney)})
				end
			end
			table.insert(info, {""})
			triggerEvent("hudOverlay:drawOverlayTopRight", localPlayer, info, textType)
		end
	end
end
addEvent("moneyUpdateFX", true)
addEventHandler("moneyUpdateFX", root, moneyUpdateFX)

addCommandHandler("finans", function()
	outputChatBox("[!]#FFFFFF Finans güncellemesi arayüzü başarıyla " .. (false == toggleMoneyUpdate and "kapatıldı" or "açıldı") .. ", " .. (true == toggleMoneyUpdate and "kapatmak" or "açmak") .. " için tekrardan /finans yazınız.", 0, 255, 0, true)
	toggleMoneyUpdate = false == toggleMoneyUpdate and true or false
end)