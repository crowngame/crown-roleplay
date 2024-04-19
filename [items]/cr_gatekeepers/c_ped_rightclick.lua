wPedRightClick = nil
bTalkToPed, bClosePedMenu = nil
ax, ay = nil
closing = nil
sent = false

function pedDamage()
	cancelEvent()
end
addEventHandler("onClientPedDamage", root, pedDamage)

function konus(element)
	local ped = getElementData(element, "name")
	local isFuelped = getElementData(element,"ped:fuelped")
	local isTollped = getElementData(element,"ped:tollped")
	local isShopKeeper = getElementData(element,"shopkeeper") or false

	if (ped=="Steven Pullman") then
		triggerServerEvent("startStevieConvo", localPlayer)
		if (getElementData(element, "activeConvo")~=1) then
			triggerEvent ("stevieIntroEvent", localPlayer) -- Trigger Client side function to create GUI.
		end
	elseif (ped=="Hunter") then
		triggerServerEvent("startHunterConvo", localPlayer)
	elseif (ped== "Edison Pickford") then -- 
			triggerEvent("onWearableShop", localPlayer)
	elseif (ped=="Zehra Yildiz") then -- 
		triggerEvent("onLicense", localPlayer)
	elseif (ped=="Emma Brewles") then -- Emma Brewles
		triggerEvent("onLicense", localPlayer)
	elseif (ped=="David Parks") then -- 
		triggerEvent("reklamGUI", localPlayer)
	elseif (ped=="Rook") then
		triggerServerEvent("startRookConvo", localPlayer)
	elseif (ped=="Victoria Greene") then
		triggerEvent("cPhotoOption", localPlayer, ax, ay)
	elseif (ped=="[CEZA-NPC]") then
		triggerEvent("ceza:npc", localPlayer)
	elseif (ped=="Melina Dupont") then
		exports.cr_clothes:openClothesWizard(element)
	elseif (ped=="[VERGİ-NPC]") then
		triggerServerEvent("vergi:sVergiGUI", localPlayer)
	elseif (ped=="[VERGİ-BİRLİK]") then
		triggerServerEvent("vergi:sVergiGUIf", localPlayer)
	elseif (ped=="Jusif_Lepoar") then              
		triggerEvent("kiyafet:panel", localPlayer)
	elseif (ped=="Igor Garrix") then
		triggerEvent("hapis:panel", localPlayer)
	elseif (ped=="Jessica Roberts") then
		triggerEvent("reklamGUI", localPlayer)
	elseif (ped=="Mike Manson") then
		triggerEvent("reklamlarTablo", localPlayer)
	elseif (ped=="Jeniffer Rockstar") then
		triggerEvent("skinshop.render", localPlayer)
	elseif (ped=="Marvel Rockstar") then
		triggerEvent("pdskinshop.render", localPlayer)
	elseif (ped=="Jessie Smith") then
		triggerEvent("cityhall:jesped", localPlayer)
	elseif (ped=="Carla Cooper") then
		triggerEvent("onLicense", localPlayer)
	elseif (ped=="Dominick Hollingsworth") then
		triggerEvent("showRecoverLicenseWindow", localPlayer)
	elseif (ped=="Mr. Clown") then
		triggerServerEvent("electionWantVote", localPlayer)
	elseif (ped=="Greer Reid") then
		triggerServerEvent("onTowMisterTalk", localPlayer)
	elseif (ped=="Guard Jenkins") then
		triggerServerEvent("gateCityHall", localPlayer)
	elseif (ped == "Guand Landre") then
		triggerEvent("locksmithGUI", localPlayer, localPlayer)
	elseif (ped=="Airman Connor") then
		triggerServerEvent("gateAngBase", localPlayer)
	elseif (ped=="Rosie Jenkins") then
		triggerEvent("lses:popupPedMenu", localPlayer)
	elseif (ped=="Winston Fleming") then
	    triggerEvent("onPaymentShop", localPlayer)
	elseif (ped=="Gabrielle McCoy") then
		triggerEvent("cBeginPlate", localPlayer)
	elseif (isFuelped == true) then
		triggerServerEvent("fuel:startConvo", element)
	elseif (ped=="Samuel Grey") then
		triggerEvent("korna:panel", localPlayer)
	elseif (isTollped == true) then
		triggerServerEvent("toll:startConvo", element)
	elseif (ped=="Novella Iadanza") then
		triggerServerEvent("onSpeedyTowMisterTalk", localPlayer)
	elseif isShopKeeper then -- blackstock
		triggerServerEvent("shop:keeper", element)
	elseif (ped=="blackstock Du Trieux") then --Banker ATM Service, blackstock
		triggerEvent("bank-system:bankerInteraction", localPlayer)
	elseif (ped=="Jonathan Smith") then --Banker General Service, blackstock
		triggerServerEvent("bank:showGeneralServiceGUI", localPlayer, localPlayer)
	elseif getElementData(element,"carshop") then
		triggerServerEvent("vehlib:sendLibraryToClient", localPlayer, element)
	elseif (ped=="Julie Dupont") then
		triggerServerEvent('clothing:list', getResourceRootElement (getResourceFromName("cr_clothing-system")))
	elseif (ped=="Evelyn Branson") then
		triggerEvent("airport:ped:receptionistFAA", localPlayer, element)
	elseif (ped=="John G. Fox") then
		triggerServerEvent("startPrisonGUI", root, localPlayer)
	elseif (ped=="Georgio Dupont") then
    	triggerEvent("locksmithGUI", localPlayer, localPlayer)
    elseif (ped=="Corey Byrd") then
		triggerEvent('ha:treatment', localPlayer)
	elseif (ped=="Justin Borunda") then --PD impounder / blackstock 
		triggerServerEvent("tow:openImpGui", localPlayer, ped)
	elseif (ped=="Sergeant K. Johnson") then --PD release / blackstock
		triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)
	elseif (ped=="Bobby Jones") then --HP impounder / blackstock 
		triggerServerEvent("tow:openImpGui", localPlayer, ped)
	elseif (ped=="Robert Dunston") then --HP release / blackstock
		triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)
	elseif (ped=="test") then --Banker ATM Service, blackstock
		triggerEvent("shop.open", localPlayer)
	elseif (ped=="Varonda Lona") then --HP release / blackstock
	triggerEvent("otopark:araclarGUİ",localPlayer)
	elseif (ped=="Lincon Vilina") then --HP release / blackstock
	triggerServerEvent("gosterkumar", localPlayer, localPlayer)
	elseif (ped=="[Ajans-NPC]") then --HP release / blackstock
	triggerServerEvent("ajans:npc:tiklama",localPlayer,localPlayer)
	elseif (ped=="[Ajans-Oluşturma]") then --HP release / blackstock
	triggerEvent("ajans:npc:olusturma",localPlayer)
	elseif (ped=="Stone Sweard") then --HP release / blackstock
	triggerEvent("market:ode",localPlayer)
	elseif (ped=="Steven Pullman") then
		triggerServerEvent("startStevieConvo", localPlayer)
		if (getElementData(element, "activeConvo")~=1) then
			triggerEvent ("stevieIntroEvent", localPlayer) -- Trigger Client side function to create GUI.
		end
	elseif (ped=="Hunter") then
		triggerServerEvent("startHunterConvo", localPlayer)
	elseif (ped=="Rook") then
		triggerServerEvent("startRookConvo", localPlayer)
	elseif (ped=="Victoria Greene") then
		triggerEvent("cPhotoOption", localPlayer, ax, ay)
	elseif (ped=="Jessie Smith") then
		triggerEvent("cityhall:jesped", localPlayer)
	elseif (ped=="Carla Cooper") then
		triggerEvent("onLicense", localPlayer)
	elseif (ped=="Dominick Hollingsworth") then
		triggerEvent("showRecoverLicenseWindow", localPlayer)
	elseif (ped=="Mr. Clown") then
		triggerServerEvent("electionWantVote", localPlayer)
	elseif (ped=="Greer Reid") then
		triggerServerEvent("onTowMisterTalk", localPlayer)
	elseif (ped=="Hakki Dayi") then
		triggerEvent("market:ode", localPlayer)
	elseif (ped=="Aaron Thompson") then
		triggerServerEvent("openMarriageMenu", localPlayer)
	elseif (ped=="Guard Jenkins") then
		triggerServerEvent("gateCityHall", localPlayer)
	elseif (ped=="Airman Connor") then
		triggerServerEvent("gateAngBase", localPlayer)
	elseif (ped=="Rosie Jenkins") then
		triggerEvent("lses:popupPedMenu", localPlayer)
	elseif (ped=="Ahmet Edim") then
		triggerEvent("elections:votegui", localPlayer)
	elseif (ped=="Gabrielle McCoy") then
		triggerEvent("cBeginPlate", localPlayer)
	elseif (isFuelped == true) then
		triggerServerEvent("fuel:startConvo", element)
	elseif (isTollped == true) then
		triggerServerEvent("toll:startConvo", element)
	elseif (ped=="Novella Iadanza") then
		triggerServerEvent("onSpeedyTowMisterTalk", localPlayer)
	elseif isShopKeeper then -- Farid
		triggerServerEvent("shop:keeper", element)
	elseif (ped=="Farid Du Trieux") then --Banker ATM Service, Farid
		triggerEvent("bank-system:bankerInteraction", localPlayer)
	elseif (ped=="Jonathan Smith") then --Banker General Service, Farid
		triggerServerEvent("bank:showGeneralServiceGUI", localPlayer, localPlayer)
	elseif getElementData(element,"carshop") then
		triggerServerEvent("vehlib:sendLibraryToClient", localPlayer, element)
	elseif (ped=="Julie Dupont") then
		triggerServerEvent('clothing:list', getResourceRootElement (getResourceFromName("cr_mabako-clothingstore")))
	elseif (ped=="Evelyn Branson") then
		triggerEvent("airport:ped:receptionistFAA", localPlayer, element)
	elseif (ped=="Albert Henry") then
		triggerEvent("AracSatma:PanelAc", localPlayer)							
	elseif (ped=="John G. Fox") then
		triggerServerEvent("startPrisonGUI", root, localPlayer)
	elseif (ped=="Georgio Dupont") then
		triggerEvent("locksmithGUI", localPlayer, localPlayer)
	elseif (ped=="Corey Byrd") then
		triggerEvent('ha:treatment', localPlayer)
	elseif (ped=="Justin Borunda") then --PD impounder / Farid 
		triggerServerEvent("tow:openImpGui", localPlayer, ped)
	elseif (ped=="Sergeant K. Johnson") then --PD release / Farid
		triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)
	elseif (ped=="Bobby Jones") then --HP impounder / Farid 
		triggerServerEvent("tow:openImpGui", localPlayer, ped)
	elseif (ped=="Robert Dunston") then --HP release / Farid
		triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)
	elseif (ped=="Mike Johnson") then
		triggerEvent("kiralamaGoster", localPlayer)
	elseif (ped=="Reginald Watson") then
		triggerEvent("sigaraGUI", localPlayer, localPlayer)
	elseif (ped=="Joffrey Yount") then
		triggerEvent("ickiGUI", localPlayer, localPlayer)
	elseif (ped=="Melike Hanim") then
		triggerEvent("reklamGUI", localPlayer)
	elseif (ped=="Matthaeus Jurgen") then
		triggerEvent("sea:displayJob", localPlayer, localPlayer)
	elseif (ped=="Mike Manson") then
		triggerEvent("reklamlarTablo", localPlayer)
	elseif (ped=="Ramiz Can") then
		triggerServerEvent("vergi:sVergiGUI", localPlayer)
	elseif (ped=="Antonio Worley") then
		triggerServerEvent("modifiye:pedStartConvo", localPlayer)
	elseif (ped=="Tyler Winslow") then
		triggerEvent("k9:K9Panel", localPlayer)
	elseif (ped=="Hunter") then
		triggerServerEvent("startHunterConvo", localPlayer)
	elseif (ped=="Rook") then
		triggerServerEvent("startRookConvo", localPlayer)
	elseif (ped=="Victoria Greene") then
		triggerEvent("cPhotoOption", localPlayer, ax, ay)
	elseif (ped=="Jessie Smith") then
		triggerEvent("cityhall:jesped", localPlayer)
	elseif (ped=="Amanda Lisse") then
		triggerEvent("onLicense", localPlayer)
	elseif (ped=="Zeki Durmus") then
		triggerEvent("showRecoverLicenseWindow", localPlayer)
	elseif (ped=="Rifki Toksun") then
		triggerEvent("truck1:displayJob", localPlayer)							
	elseif (ped=="Berkcan Soylu") then
		triggerServerEvent("electionWantVote", localPlayer)
	elseif (ped=="Greer Reid") then
		triggerServerEvent("onTowMisterTalk", localPlayer)
	elseif (ped=="Aaron Thompson") then
		triggerServerEvent("openMarriageMenu", localPlayer)
	elseif (ped=="Nihat Durak") then
		triggerServerEvent("gosterotopark", localPlayer)
	elseif (ped == "Erdal Celebi") then
		triggerEvent("Cilingir:PanelAc", localPlayer)
	elseif (ped=="Cemal Toprak") then
		triggerEvent("kazikazan:panel", localPlayer)							
	elseif (ped=="Guard Jenkins") then
		triggerServerEvent("gateCityHall", localPlayer)
	elseif (ped=="Airman Connor") then
		triggerServerEvent("gateAngBase", localPlayer)
	elseif (ped=="Rosie Jenkins") then
		triggerEvent("lses:popupPedMenu", localPlayer)
	elseif (ped=="Malik Yemen") then
		triggerEvent("stone:displayJob", localPlayer, localPlayer)
	elseif (ped=="Gabrielle McCoy") then
		triggerEvent("cBeginPlate", localPlayer)
	elseif (isFuelped == true) then
		triggerServerEvent("fuel:startConvo", element)
	elseif (isTollped == true) then
		triggerServerEvent("toll:startConvo", element)
	elseif (ped=="Novella Iadanza") then
		triggerServerEvent("onSpeedyTowMisterTalk", localPlayer)
	elseif isShopKeeper then -- Farid
		triggerServerEvent("shop:keeper", element)
	elseif (ped=="Albert Dame") then --Banker ATM Service, Farid
		triggerEvent("bank-system:bankerInteraction", localPlayer)
	elseif (ped=="Hasan Hüseyin Varlı") then --LordArsen İNCİ
		triggerEvent("Incisistemi:InciNPC", localPlayer)
	elseif (ped=="Kevin Alonso") then --Banker General Service, Farid
		triggerServerEvent("bank:showGeneralServiceGUI", localPlayer, localPlayer)
	elseif getElementData(element,"carshop") then
		triggerServerEvent("vehlib:sendLibraryToClient", localPlayer, element)
	elseif (ped=="Julie Dupont") then
		triggerServerEvent('clothing:list', getResourceRootElement (getResourceFromName("cr_mabako-clothingstore")))
	elseif (ped=="Evelyn Branson") then
		triggerEvent("airport:ped:receptionistFAA", localPlayer, element)
	elseif (ped=="Albert Henry") then
		triggerEvent("AracSatma:PanelAc", localPlayer)							
	elseif (ped=="John G. Fox") then
		triggerServerEvent("startPrisonGUI", root, localPlayer)
	elseif (ped=="Georgio Dupont") then
		triggerEvent("locksmithGUI", localPlayer, localPlayer)
	elseif (ped=="Corey Byrd") then
		triggerEvent('ha:treatment', localPlayer)
	elseif (ped=="Justin Borunda") then --PD impounder / Farid 
		triggerServerEvent("tow:openImpGui", localPlayer, ped)
	elseif (ped=="Sergeant K. Johnson") then --PD release / Farid
		triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)
	elseif (ped=="Bobby Jones") then --HP impounder / Farid 
		triggerServerEvent("tow:openImpGui", localPlayer, ped)
	elseif (ped=="Robert Dunston") then --HP release / Farid
		triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)
	elseif (ped=="Kursat Laleli") then
		triggerEvent("alkol:displayJob", localPlayer, localPlayer)							
	elseif (ped=="Mike Johnson") then
		triggerEvent("kiralamaGoster", localPlayer)
	elseif (ped=="Ekrem Dogan") then
		triggerEvent("cigar:displayJob", localPlayer, localPlayer)
	elseif (ped=="Joffrey Yount") then
		triggerEvent("ickiGUI", localPlayer, localPlayer)
	elseif (ped=="Derya Yılmaz") then
		triggerEvent("reklamGUI", localPlayer)
	elseif (ped=="Emrah Kara") then
		triggerEvent("reklamlarTablo", localPlayer)
	elseif (ped=="Pete Robinson") then
		triggerServerEvent("vergi:sVergiGUI", localPlayer)
	elseif (ped=="Hakki Dayi") then  -- craxeN
		triggerEvent("market:panel", localPlayer)							
	elseif (ped=="Niyazi Yerebakan") then
		triggerEvent("cop:displayJob", localPlayer, localPlayer)
	elseif (ped=="James Caviezel") then
		triggerEvent("trucker:displayJob", localPlayer)							
	elseif (ped=="Ahmet Laleli") then
		triggerEvent("bus:displayJob", localPlayer)	
	elseif (ped=="Martin Brewles") then
		triggerEvent("kazikazan:panel", localPlayer)
	elseif (ped=="Ahmet_Akkuzu") then  -- okarosa
		triggerEvent("dovizz:panel", localPlayer)							
	elseif (ped=="Haydar Pekmezci") then
		triggerEvent("taxi:displayJob", localPlayer)
	elseif (ped=="Verdon Mila") then
		triggerServerEvent("modifiye:pedStartConvo", localPlayer)		
	elseif (ped=="Ahmet Eleli") then
		triggerEvent("korna:panel", localPlayer)								
	elseif (ped=="Thamson Very") then
		triggerEvent("reklamGUI", localPlayer)								
	elseif (ped=="Aaron Thompson") then
		triggerServerEvent("papazAmca", localPlayer)
	elseif (ped=="Alonso Parker") then --HP release / Farid
		triggerEvent("otopark:araclarGUİ",localPlayer)
	elseif (ped=="Julie Dupont") then
		triggerServerEvent('clothing:list', getResourceRootElement (getResourceFromName("cr_mabako-clothingstore")))
	elseif (ped=="Murat Kaya") then
		triggerEvent("pizzaci:pizzaciGUI", localPlayer, localPlayer)
	elseif (ped=="Murat Kaya2") then
		triggerEvent("temizlik:temizlikGUI", localPlayer, localPlayer)
	elseif (ped=="Hakki Dayi") then --HP release / Farid
	  triggerEvent("market:ode",localPlayer)	
	elseif (ped=="Çifçi Tahir") then --HP release / Farid
		triggerEvent("tarlaMenuAc",localPlayer)
	elseif (ped=="Silah Saticisi") then --HP release / Farid
		triggerEvent("materyalMenuAc",localPlayer)	
	elseif (ped=="Caner İssiz") then --HP release / Farid
		triggerEvent("skinshop:buySkin",localPlayer , "Caner İssiz" , {0,0})
	elseif (ped=="Hunter") then
		triggerServerEvent("startHunterConvo", localPlayer)
	elseif (ped=="Rook") then
		triggerServerEvent("startRookConvo", localPlayer)
	elseif (ped=="Victoria Greene") then
		triggerEvent("cPhotoOption", localPlayer, ax, ay)
	elseif (ped=="Jessie Smith") then
		triggerEvent("cityhall:jesped", localPlayer)
	elseif (ped=="Zehra Yildiz") then
		triggerEvent("onLicense", localPlayer)
	elseif (ped=="Zeki Durmus") then
		triggerEvent("showRecoverLicenseWindow", localPlayer)
	elseif (ped=="Anthony Lucifer") then
		triggerEvent("truck1:displayJob", localPlayer)							
	elseif (ped=="Berkcan Soylu") then
		triggerServerEvent("electionWantVote", localPlayer)
	elseif (ped=="Greer Reid") then
		triggerServerEvent("onTowMisterTalk", localPlayer)
	elseif (ped=="Aaron Thompson") then
        triggerServerEvent("openMarriageMenu", localPlayer)
	elseif (ped=="Nihat Durak") then
        triggerServerEvent("gosterotopark", localPlayer)
	elseif (ped == "Erdal Celebi") then
		triggerEvent("Cilingir:PanelAc", localPlayer)
    elseif (ped=="Cemal Toprak") then
        triggerEvent("kazikazan:panel", localPlayer)							
	elseif (ped=="Guard Jenkins") then
		triggerServerEvent("gateCityHall", localPlayer)
	elseif (ped=="Airman Connor") then
		triggerServerEvent("gateAngBase", localPlayer)
	elseif (ped=="Rosie Jenkins") then
		triggerEvent("lses:popupPedMenu", localPlayer)
	elseif (ped=="Ron Perlman") then
		triggerEvent("stone:displayJob", localPlayer, localPlayer)
	elseif (ped=="Gabrielle McCoy") then
		triggerEvent("cBeginPlate", localPlayer)
	elseif (isFuelped == true) then
		triggerServerEvent("fuel:startConvo", element)
	elseif (isTollped == true) then
		triggerServerEvent("toll:startConvo", element)
	elseif (ped=="Novella Iadanza") then
		triggerServerEvent("onSpeedyTowMisterTalk", localPlayer)
	elseif isShopKeeper then -- Farid
		triggerServerEvent("shop:keeper", element)
	elseif (ped=="Mehmet Yuksel") then --Banker ATM Service, Farid
		triggerEvent("bank-system:bankerInteraction", localPlayer)
	elseif (ped=="Hasan Hüseyin Varlı") then --LordArsen İNCİ
		triggerEvent("Incisistemi:InciNPC", localPlayer)
	elseif (ped=="Ahmet Demirtas") then --Banker General Service, Farid
		triggerServerEvent("bank:showGeneralServiceGUI", localPlayer, localPlayer)
	elseif getElementData(element,"carshop") then
		triggerServerEvent("vehlib:sendLibraryToClient", localPlayer, element)
	elseif (ped=="Julie Dupont") then
		triggerServerEvent('clothing:list', getResourceRootElement (getResourceFromName("cr_mabako-clothingstore")))
	elseif (ped=="Evelyn Branson") then
		triggerEvent("airport:ped:receptionistFAA", localPlayer, element)
	elseif (ped=="Albert Henry") then
		triggerEvent("AracSatma:PanelAc", localPlayer)							
	elseif (ped=="John G. Fox") then
		triggerServerEvent("startPrisonGUI", root, localPlayer)
	elseif (ped=="Georgio Dupont") then
    	triggerEvent("locksmithGUI", localPlayer, localPlayer)
    elseif (ped=="Corey Byrd") then
		triggerEvent('ha:treatment', localPlayer)
	elseif (ped=="Justin Borunda") then --PD impounder / Farid 
		triggerServerEvent("tow:openImpGui", localPlayer, ped)
	elseif (ped=="Sergeant K. Johnson") then --PD release / Farid
		triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)
	elseif (ped=="Bobby Jones") then --HP impounder / Farid 
		triggerServerEvent("tow:openImpGui", localPlayer, ped)
	elseif (ped=="Robert Dunston") then --HP release / Farid
		triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)
	elseif (ped=="Antonio Banderas") then
		triggerEvent("alkol:displayJob", localPlayer, localPlayer)							
	elseif (ped=="Mike Johnson") then
		triggerEvent("kiralamaGoster", localPlayer)
	elseif (ped=="Ricardo Diablo") then
		triggerEvent("cigar:displayJob", localPlayer, localPlayer)
	elseif (ped=="Joffrey Yount") then
		triggerEvent("ickiGUI", localPlayer, localPlayer)
	elseif (ped=="Derya Yılmaz") then
		triggerEvent("reklamGUI", localPlayer)
	elseif (ped=="Emrah Kara") then
		triggerEvent("reklamlarTablo", localPlayer)
	elseif (ped=="Pete Robinson") then
		triggerServerEvent("vergi:sVergiGUI", localPlayer)
	elseif (ped=="Johan_Layer") then  -- craxeN
		triggerEvent("market:panel", localPlayer)							
	elseif (ped=="Antonio Worley") then
		triggerServerEvent("modifiye:pedStartConvo", localPlayer)
	elseif (ped=="Mark Banderas") then
		triggerEvent("cop:displayJob", localPlayer, localPlayer)
	elseif (ped=="James Caviezel") then
		triggerEvent("trucker:displayJob", localPlayer)							
	elseif (ped=="Serdar Kara") then
		triggerEvent("bus:displayJob", localPlayer)	
	elseif (ped=="Ahmet_Akkuzu") then  -- okarosa
        triggerEvent("dovizz:panel", localPlayer)							
	elseif (ped=="Jack Sparrow") then
		triggerEvent("taxi:displayJob", localPlayer)								
	elseif (ped=="Aaron Thompson") then
		triggerServerEvent("papazAmca", localPlayer)
	else
		triggerEvent("shop.open", localPlayer, element)
	end
end
addEvent("npc:konus",true)
addEventHandler("npc:konus", root, konus)

function hidePedMenu()
	if (isElement(bTalkToPed)) then
		destroyElement(bTalkToPed)
	end
	bTalkToPed = nil

	if (isElement(bClosePedMenu)) then
		destroyElement(bClosePedMenu)
	end
	bClosePedMenu = nil

	if (isElement(wPedRightClick)) then
		destroyElement(wPedRightClick)
	end
	wPedRightClick = nil

	ax = nil
	ay = nil
	sent=false
	showCursor(false)
end

local xx = 0
local fonts = {
	font1 = exports.cr_fonts:getFont("sf-bold", 15),
	font2 = exports.cr_fonts:getFont("sf-regular", 8),
}

setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		for _, ped in ipairs(getElementsByType("ped")) do
			if getElementData(ped, "name") and getElementData(ped, "talk") == 1 then
				local lx, ly, lz = getPedBonePosition(localPlayer, 8)
				local px, py, pz = getPedBonePosition(ped, 1)
				if getDistanceBetweenPoints3D(lx, ly, lz, px, py, pz) < 1.1 then
					local x, y = getScreenFromWorldPosition(px, py, pz + 0.3)
					if x and y then             
						dxDrawRectangle(x-50/2, y+20, 35, 35, tocolor(10, 10, 10, 250))
						dxDrawRectangle(x-50/2, y+34-2+20, xx, 3, exports.cr_ui:getServerColor(1, 250))
						dxDrawText("E", x-78/2, y+26, x-50/2+50, y+50, exports.cr_ui:getServerColor(1, 250), 1, fonts.font1, "center", "center")
						dxDrawText(getElementData(ped, "name"):gsub("_", " "), x-78/2, y+80, x-50/2+50, y+50, tocolor(255, 255, 255, 250), 1, fonts.font2, "center", "center")
						dxDrawText("Konuşmak için tuşa basılı tutun.", x-78/2, y+110, x-50/2+50, y+50, tocolor(255, 255, 255, 250), 1, fonts.font2, "center", "center")
						
						if not isCursorShowing() then
							if getKeyState("E") then
								if xx ~= 35 then
									xx = xx + 1
								else
									triggerEvent("npc:konus", localPlayer, ped)
									xx = 0
								end
							else
								xx = 0
							end
						end
					end
				end
			end
		end
	end
end, 0, 0)