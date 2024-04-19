local BankGUIs = {}
function toggleLSBank(state)
	if state then
		isBankShowing = true
		createBankMenu()
		guiSetInputEnabled(true)
		addEventHandler("onClientGUIClick", root, clickBankFunctions)
	else
		isBankShowing = false
		guiSetInputEnabled(false)
		for k,v in ipairs(BankGUIs) do
			if isElement(v) then
				destroyElement(v)
			end
		end
		removeEventHandler("onClientGUIClick", root, clickBankFunctions)
	end
end


function createBankMenu()
	BankGUIs[1] = guiCreateButton(20,70,24,24,"",false,wPhoneMenu)
	guiSetAlpha(BankGUIs[1],0)
	addEventHandler("onClientGUIClick", BankGUIs[1], function(state) if state == "left" and source == BankGUIs[1] then toggleOffEverything() togglePhoneHome(true) end end)

	BankGUIs[2] = guiCreateEdit(50,337,200,32.7,"",false,wPhoneMenu)
	guiEditSetMaxLength(BankGUIs[2], 19)

	BankGUIs[3] = guiCreateEdit(50,373,200,32.7,"",false,wPhoneMenu)
	guiEditSetMaxLength(BankGUIs[3] , 5)

	BankGUIs[4] = guiCreateButton(40,435,185,30,"",false,wPhoneMenu)
	guiSetAlpha(BankGUIs[4],0)

end


addEventHandler("onClientGUIClick", getRootElement (), function(btn)
if source == BankGUIs[4] then
triggerServerEvent("Owner:bank", getLocalPlayer(), getLocalPlayer(), guiGetText(BankGUIs[2]), guiGetText(BankGUIs[3]))
end
end)