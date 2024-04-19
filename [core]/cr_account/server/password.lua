local mysql = exports.cr_mysql
local passwordTimer = {}

function sifreDegistir(thePlayer, commandName, password, passwordAgain)
	if password and passwordAgain then
		if (string.len(password) >= 6) and (string.len(passwordAgain) >= 6) then
			if password == passwordAgain then
				if not isTimer(passwordTimer[thePlayer]) then
					local id = getElementData(thePlayer, "account:id")
					local encryptedPassword = string.upper(md5(password))
					dbExec(mysql:getConnection(), "UPDATE accounts SET password = ? WHERE id = ?", encryptedPassword, id)
					
					outputChatBox("[!]#FFFFFF Hesabınızın şifresi başarıya değiştirilmiştir.", thePlayer, 0, 255, 0, true)
					triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
					
					passwordTimer[thePlayer] = setTimer(function() end, 1000 * 60, 1)
				else
					local timer = getTimerDetails(passwordTimer[thePlayer])
					outputChatBox("[!]#FFFFFF Şifrenizi değişmek için " .. math.floor(timer / 1000)  .. " saniye beklemeniz gerekiyor.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Şifreler uyuşmuyor.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Şifreniz minimum 6 karakter olmalıdır.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Yeni Şifreniz] [Yeni Şifreniz 2x]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("sifredegistir", sifreDegistir, false, false)