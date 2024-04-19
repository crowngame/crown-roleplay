dxDrawCircle = dxDrawCircle
dxDrawRectangle = dxDrawRectangle
dxDrawText = dxDrawText
localPlayer = getLocalPlayer()
exports = exports
getKeyState = getKeyState
skinshop = {}
skinshop.__index = skinshop
skinshop.screen = Vector2(guiGetScreenSize())
skinshop.width, skinshop.height = 800, 550
skinshop.sizeX, skinshop.sizeY = (skinshop.screen.x - skinshop.width), (skinshop.screen.y - skinshop.height)
skinshop.robotoB = exports.cr_fonts:getFont("sf-bold", 25)
skinshop.roboto = exports.cr_fonts:getFont("sf-regular", 9)
skinshop.roboto2 = exports.cr_fonts:getFont("sf-regular", 10)
skinshop.awesome = exports.cr_fonts:getFont("FontAwesome", 17)
skinshop.icon = exports.cr_fonts:getFont("FontAwesome", 120)

function skinshop:create()
    local instance = {}
    setmetatable(instance, skinshop)
    if instance:constructor() then
        return instance
    end
    return false
end

function skinshop:constructor()
    self = skinshop;
    self.active = false

    self.npc = createPed(243, 161.2919921875,  - 81.1904296875, 1001.8046875, 179.34631347656)
    self.npc.interior = 18
    self.npc.dimension = 11
    self.npc:setData("name", "Jeniffer Rockstar")
    self.npc.frozen = true

    self.manSkins = {
        -- model, kıyafet, fiyat
		{3, "Oxford Mezunu Zenci", 50}, 
		{6, "Kabadayının yandan yemişi yaşlı", 50}, 
		{15, "Büyük bereli, northface yelekli", 50}, 
		{16, "Küçük badboy zenci", 50}, 
		{17, "Kenzo takılan şişko zenci", 50}, 
        {18, "Esrarkeş Kapüşonlu Zenci", 50}, 
		{19, "Atletle Yapışık Zenci" , 50}, 
		{20, "Polo kapüşonlu zenci" , 50}, 
		{24, "Lacoste polo yaka, saçlar rasta", 50}, 
		{25, "Rasta gndiano", 50}, 
		{26, "Kırmızı Montlu Digger Nigga", 50}, 
		{29, "Gold diggerların göz bebeği", 50}, 
        {31, "NIKE şapkalı küçük zenci", 50}, 
        {32, "Şapkalı gangsta", 50}, 
        {34, "Şöhret zencisi", 50}, 
		{35, "US Polo ama Kasıntı Olan", 50}, 
        {44, "Crips özentisi", 50}, 
		{45, "Sokak yetmesi", 50}, 
        {49, "Jordan gndiano", 50}, 
		{51, "Sarı botlu zenci", 50}, 
        {52, "İkonik zenci", 50}, 
        {53, "Hippi zencisi", 50}, 
        {55, "Tehlikeli Adam", 50}, 
        {56, "Hangover Zenci", 50}, 
		{57, "Rasta saçlı madde bağımlısı", 50}, 
		{58, "Küpeli zenci", 50}, 
		{61, "Tommy Hilfiger Şapkalı Zenci", 50}, 
		{63, "Beyaz içlikli, yeşil kargo pantolonlu", 50}, 
        {67, "Victor Osimhenin yandan yemişi", 50}, 
		{66, "North Face şapkalı beyaz", 50}, 
		{68, "Kırmızı şişme montlu zenci", 50},
		{69, "Rasta saçlı, mahallesinde tehlikelisi", 50}, 
        {70, "Esrarkeş Aptal Zenci", 50}, 
		{71, "Bulls, Beyaz Zenci", 50}, 
		{72, "Nike çantalı, baba parası yiyen ibne", 50}, 
        {76, "Almanya genci", 50}, 
		{78, "İş adamı", 50}, 
        {79, "Meksikalı chapo", 50}, 
        {80, "Old School yetme", 50}, 
		{83, "Elit gizemli zenci", 50}, 
		{84, "Yürüyen kokoşun abisi", 50}, 
        {93, "İtalyan genç", 50}, 
        {94, "Lozy yüz dövmeli", 50}, 
        {95, "San Andreas MC", 50}, 
        {96, "Baltacı mafya", 50}, 
        {97, "Zengin, parayla işi olmayan", 50}, 
        {99, "Salaş Club herifi", 50}, 
		{113, "Çakma OG Loc!", 50}, 
		{117, "Kızların görünce ağzı sulandığı o meşhur eleman", 50}, 
		{118, "Mor Northface, etkileyici oğlan", 50}, 
        {120, "Parti adamı, sarı saç", 50}, 
        {127, "Kulüp başı, MC!", 50}, 
        {132, "Gamer çocuk kombini", 50}, 
		{133, "49Ers -  Beyaz Zenci", 50}, 
        {134, "MC Üyesi", 50}, 
        {135, "Fitness Çıkış kombini", 50}, 
        {136, "Redsox -  Beyaz Zenci", 50}, 
        {137, "Loser El Corona, kolları dövmeli", 50}, 
		{142, "Yandan yemiş Stephan Curry.", 50}, 
        {156, "Golden State Fan", 50}, 
        {157, "Etekli estetik güzeli", 50}, 
        {158, "Mor gömlekli mafya elemanı", 50}, 
        {159, "İtalyan patron", 50}, 
        {160, "İş bitirici, mafya elemanı", 50}, 
        {161, "Dodgers fan, gece adamı", 50}, 
        {162, "Sünepe, okul çocuğu", 50}, 
        {168, "Prison, ters şapkalı", 50}, 
		{174, "Şehrin gözdesi, starboy eleman", 50}, 
		{179, "23 numara, yakışıklı çocuk", 50}, 
        {200, "Alman, kaplı dövme", 50}, 
        {202, "Beach kombini", 50}, 
		{206, "Siyah takım elbiseli resmi siyahi", 50}, 
        {209, "Soyguncu mafya", 50}, 
        {210, "Etik olmayan, El Corona", 50}, 
        {212, "Şişko, atletli", 50}, 
        {213, "Adidas eşofman, kafes dövüşcüsü", 50}, 
        {220, "Latin, sakin çocuk", 50},
		{289, "Dikkat çeken adam", 50}, 
		{293, "Dövmeci zenci", 50}, 
		{300, "Çetenin direği olan zenci", 50}, 
		{305, "Tommy Vercetti'in kuzeni", 50}, 
		{310, "Göbeği açık şişman zenci", 50}, 
		{312, "Galatasaraylı cool yakışıklı genç", 50}, 
        --Default--
        {97, "İtalyan mafyası", 50}, 
        {240, "Mafya üyesi", 50}, 
        {19, "Litica Gang", 50}, 
        --Ballas--
        {102, "Ballas sokak genci #1", 25}, 
        {103, "Ballas sokak genci #2", 25}, 
        {104, "Ballas sokak genci #3", 25}, 
        {100, "Ballas sokak genci #4", 25}, 
        --Groove--
        {105, "Groove sokak genci #1", 25}, 
        {106, "Groove sokak genci #1", 25}, 
        {107, "Groove sokak genci #1", 25}, 
        {269, "Groove sokak genci #1", 25}, 
        {270, "Groove sokak genci #1", 25}, 
        {271, "Groove sokak genci #1", 25}, 
        --Vagos--
        {108, "Vagos sokak genci #1", 25}, 
        {109, "Vagos sokak genci #2", 25}, 
        {110, "Vagos sokak genci #3", 25}, 
        --Çete--
        {114, "Venturas sokak genci #1", 25}, 
        {115, "Venturas sokak genci #2", 25}, 
        {116, "Venturas sokak genci #3", 25}, 
    }

    self.womanSkins = {
        -- model, kıyafet, fiyat
		{1, "Deniz Kızı", 50}, 
		{2, "Asyalı Kız", 50}, 
		{4, "Öğretmen gibi Milf", 50}, 
		{5, "Russian Alaturka BEBEK!", 50}, 
		{7, "Üstü Minare Altı Kerhane", 50}, 
		{8, "Güzel fizikli mavi body...", 50}, 
        {10, "Supermodel kalçalı kız", 50}, 
        {11, "Asi ceketli kız", 50}, 
		{14, "Deri ceketli Dolgun kalçalı", 50}, 
		{23, "Parti avcısı gold digger", 50}, 
        {27, "Yeni motor almış kız", 50}, 
		{36, "Gecelik Ayrıntılı Hoş.", 50}, 
		{37, "Göğüs dekolteli avukat.", 50}, 
		{39, "Ailesini maaşıyla geçindiren hanım kız.", 50}, 
		{41, "Metal Konserlerinde ki Body Kız", 50}, 
		{30, "Full Nike Body", 50}, 
		{64, "Ganton varoşlarından, siyahi kadın", 50}, 
	    {73, "Kızıl Tutku", 50}, 
		{75, "Dekolte iç çamaşırlı, MC kızı", 50}, 
		{77, "Cafe işletmecisi Narin Kız", 50}, 
		{82, "Mahallenin sert siyahi kızı", 50}, 
        {87, "Kapuşonlu kız", 50}, 
        {88, "Crop eşofmanlı kız", 50}, 
        {89, "Tokyocu hıkıkomorı", 50}, 
        {54, "Sokak serserisi matrix kız", 50}, 
        {90, "Metalic kız", 50}, 
        {92, "Şımarık kolej kızı", 50}, 
		{101, "Façalı Pantolon üstü Siyah croplu", 50}, 
        {150, "Pembe croplu, botlu kız", 50}, 
		{157, "On numara, bir yıldız.", 50}, 
		{169, "Dünya güzeli işte o kız", 50}, 
		{173, "İş kadını ama Sportif!", 50}, 
        {224, "Kıvırcık, sürtük zenci", 50}, 
        {219, "Belinde hırkalı kız", 50}, 
        {218, "Kamuflaj elbiseli seksi kız", 50}, 
        {214, "Pantolonu defolu kız", 50}, 
        {215, "Aşk tanrıçası tatlı kız", 50}, 
        {225, "Basketbolcu kız", 50}, 
        {226, "Fahişe kız", 50}, 
        {231, "Torbacı Grove kızı", 50}, 
        {232, "Poly Candy kız", 50}, 
        {233, "Boğazlı kazak, mafya siyahisi", 50}, 
        {237, "Rasta saçlı kızıl", 50}, 
        {238, "Crips sürtüğü", 50}, 
        {243, "Lacoste, marka kız", 50}, 
        {244, "Balenciaga, güzellik", 50}, 
        {246, "Frikik seven", 50}, 
        {251, "Sincap T-Shirt", 50}, 
        {256, "Kolej ceketli kız", 50},
        {257, "Bu ne amına...", 50},
        {309, "Zencilerin aşık olduğu kız", 50},
        {311, "Piercing'li siyahi güzellik", 50}, 
    }

    addEvent("skinshop.render", true)
    addEventHandler("skinshop.render", root, self.open)
    bindKey("mouse_wheel_up", "down", self.up)
    bindKey("mouse_wheel_down", "down", self.down)
end

function skinshop:render()
    self = skinshop;
    dxDrawRectangle(self.sizeX / 2, self.sizeY / 2, self.width, self.height + 15, tocolor(15, 15, 15, 225))
    dxDrawText("Giyim Mağazası", self.sizeX / 2 + 20, self.sizeY / 2 + 20, 25, 25, tocolor(225, 225, 225, 235), 0.67, self.robotoB)

    if self.selectedTable == self.manSkins then
        genderIcon = ""
        genderX = 20
    elseif self.selectedTable == self.womanSkins then
        genderIcon = ""
        genderX = 0
    end

    if exports.cr_ui:isInBox(self.sizeX / 2 + 15, self.sizeY / 2 + 65, self.width / 5, self.height / 19) then
        dxDrawRectangle(self.sizeX / 2 + 15, self.sizeY / 2 + 65, self.width / 5, self.height / 19, self.selectedTable == self.manSkins and exports.cr_ui:getServerColor(1, 200) or tocolor(125, 125, 125, 255))
        dxDrawText("Erkek Kıyafetleri", self.sizeX / 2 + 40, self.sizeY / 2 + 70, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto2)
        if getKeyState("mouse1") and self.click + 800 <= getTickCount() then
            self.click = getTickCount()
            self.scroll = 0
            self.selectedChoice = nil
            self.selectedTable = self.manSkins
			triggerEvent("setPlayerCustomAnimation", root, self.ped, "custom_9")
        end
    else
        dxDrawRectangle(self.sizeX / 2 + 15, self.sizeY / 2 + 65, self.width / 5, self.height / 19, self.selectedTable == self.manSkins and exports.cr_ui:getServerColor(1, 255) or tocolor(20, 20, 20, 255))
        dxDrawText("Erkek Kıyafetleri", self.sizeX / 2 + 40, self.sizeY / 2 + 70, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto2)
    end

    if exports.cr_ui:isInBox(self.sizeX / 2 + 190, self.sizeY / 2 + 65, self.width / 5, self.height / 19) then
        dxDrawRectangle(self.sizeX / 2 + 190, self.sizeY / 2 + 65, self.width / 5, self.height / 19, self.selectedTable == self.womanSkins and exports.cr_ui:getServerColor(1, 200) or tocolor(125, 125, 125, 255))
        dxDrawText("Kadın Kıyafetleri", self.sizeX / 2 + 217, self.sizeY / 2 + 70, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto2)
        if getKeyState("mouse1") and self.click + 800 <= getTickCount() then
            self.click = getTickCount()
            self.scroll = 0
            self.selectedChoice = nil
            self.selectedTable = self.womanSkins
			triggerEvent("setPlayerCustomAnimation", self.ped, self.ped, "custom_7")
        end
    else
        dxDrawRectangle(self.sizeX / 2 + 190, self.sizeY / 2 + 65, self.width / 5, self.height / 19, self.selectedTable == self.womanSkins and exports.cr_ui:getServerColor(1, 255) or tocolor(20, 20, 20, 255))
        dxDrawText("Kadın Kıyafetleri", self.sizeX / 2 + 217, self.sizeY / 2 + 70, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto2)
    end

    if self.selectedChoice then
        self.table = self.selectedTable[self.selectedChoice]
        dxDrawText("Önizleme: " .. self.table[2], self.sizeX / 2 + 410, self.sizeY / 2 + 80, 25, 25, tocolor(225, 225, 225, 235), 0.50, self.robotoB)
    else
        dxDrawText("Önizleme", self.sizeX / 2 + 410, self.sizeY / 2 + 80, 25, 25, tocolor(225, 225, 225, 235), 0.50, self.robotoB)
    end
    dxDrawRectangle(self.sizeX / 2 + 410, self.sizeY / 2 + 115, self.width / 2 - 25, self.height / 2 + 143, tocolor(15, 15, 15, 215))
    dxDrawText(genderIcon, self.sizeX / 2 + 520 - genderX, self.sizeY / 2 + 210, 40, 40, tocolor(100, 100, 100, 150), 1, self.icon)

    dxDrawRectangle(self.sizeX / 2 + 15, self.sizeY / 2 + 115, self.width / 2 - 25, self.height / 2 + 143, tocolor(15, 15, 15, 215))
    dxDrawText("Model", self.sizeX / 2 + 30, self.sizeY / 2 + 123, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)
    dxDrawText("Kıyafet", self.sizeX / 2 + 95, self.sizeY / 2 + 123, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)
    dxDrawText("Fiyat", self.sizeX / 2 + 320, self.sizeY / 2 + 123, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)

    self.counter = 0
    self.counterY = 0
    for index, value in ipairs(self.selectedTable) do
        if index > self.scroll and self.counter < 15 then
            if index == self.selectedChoice then
                dxDrawRectangle(self.sizeX / 2 + 23, self.sizeY / 2 + 150 + self.counterY, self.width / 2 - 40, 23, tocolor(21, 21, 21, 215))
                dxDrawText(value[1], self.sizeX / 2 + 30, self.sizeY / 2 + 154 + self.counterY, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)
                dxDrawText(value[2], self.sizeX / 2 + 95, self.sizeY / 2 + 154 + self.counterY, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)
                dxDrawText(value[3] .. "$", self.sizeX / 2 + 320, self.sizeY / 2 + 154 + self.counterY, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)
                if exports.cr_ui:isInBox(self.sizeX / 2 + 23, self.sizeY / 2 + 150 + self.counterY, self.width / 2 - 40, 23) then
                    if getKeyState("mouse1") and self.click + 800 <= getTickCount() then
                        self.click = getTickCount()
                        self.selectedChoice = nil
                    end
                end
            else
                if exports.cr_ui:isInBox(self.sizeX / 2 + 23, self.sizeY / 2 + 150 + self.counterY, self.width / 2 - 40, 23) then
                    dxDrawRectangle(self.sizeX / 2 + 23, self.sizeY / 2 + 150 + self.counterY, self.width / 2 - 40, 23, tocolor(21, 21, 21, 215))
                    dxDrawText(value[1], self.sizeX / 2 + 30, self.sizeY / 2 + 154 + self.counterY, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)
                    dxDrawText(value[2], self.sizeX / 2 + 95, self.sizeY / 2 + 154 + self.counterY, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)
                    dxDrawText(value[3] .. "$", self.sizeX / 2 + 320, self.sizeY / 2 + 154 + self.counterY, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)
                    if getKeyState("mouse1") and self.click + 800 <= getTickCount() then
                        self.click = getTickCount()
                        self.selectedChoice = index
                    end
                else
                    dxDrawRectangle(self.sizeX / 2 + 23, self.sizeY / 2 + 150 + self.counterY, self.width / 2 - 40, 23, tocolor(25, 25, 25, 215))
                    dxDrawText(value[1], self.sizeX / 2 + 30, self.sizeY / 2 + 154 + self.counterY, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)
                    dxDrawText(value[2], self.sizeX / 2 + 95, self.sizeY / 2 + 154 + self.counterY, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)
                    dxDrawText(value[3] .. "$", self.sizeX / 2 + 320, self.sizeY / 2 + 154 + self.counterY, 25, 25, tocolor(225, 225, 225, 235), 1, self.roboto)
                end
            end
            self.counter = self.counter + 1
            self.counterY = self.counterY + 25
        end
    end

    if self.selectedChoice then
        self.table = self.selectedTable[self.selectedChoice]
        self.ped.model = self.table[1]
        exports["cr_object-preview"]:setAlpha(self.prevPed, 255)
        if exports.cr_ui:isInBox(self.sizeX / 2 + 730, self.sizeY / 2 + 480, 40, 40) then
            dxDrawRectangle(self.sizeX / 2 + 730, self.sizeY / 2 + 480, 40, 40, tocolor(80, 120, 70, 245))
            dxDrawText("$", self.sizeX / 2 + 742, self.sizeY / 2 + 485, 25, 25, tocolor(15, 15, 15, 235), 0.70, self.robotoB)
            if getKeyState("mouse1") and self.click + 800 <= getTickCount() then
                self.click = getTickCount()
                triggerServerEvent("skinshop.buy", localPlayer, self.table[3], self.table[1])
                self:open()
            end
        else
            dxDrawRectangle(self.sizeX / 2 + 730, self.sizeY / 2 + 480, 40, 40, tocolor(90, 130, 80, 245))
            dxDrawText("$", self.sizeX / 2 + 742, self.sizeY / 2 + 485, 25, 25, tocolor(15, 15, 15, 235), 0.70, self.robotoB)
        end
    else
        exports["cr_object-preview"]:setAlpha(self.prevPed, 0)
    end
	
	dxDrawText("", self.sizeX / 2 + self.width - 40, self.sizeY / 2 + 20, nil, nil, exports.cr_ui:isInBox(self.sizeX / 2 + self.width - 40, self.sizeY / 2 + 20, dxGetTextWidth("", 1, self.awesome), dxGetFontHeight(1, self.awesome)) and tocolor(255, 255, 255, 200) or tocolor(255, 255, 255, 250), 1, self.awesome)
	if exports.cr_ui:isInBox(self.sizeX / 2 + self.width - 40, self.sizeY / 2 + 20, dxGetTextWidth("", 1, self.awesome), dxGetFontHeight(1, self.awesome)) and getKeyState("mouse1") and self.click + 500 <= getTickCount() then
		self.click = getTickCount()
        self:open()
	end
end

function skinshop:open()
    self = skinshop;
    if localPlayer:getData("loggedin") == 1 then
        if self.active then
            self.active = false
            self.ped:destroy()
	        exports["cr_object-preview"]:destroyObjectPreview(self.prevPed)
            showCursor(false)
            removeEventHandler("onClientRender", getRootElement(), self.render)
        else
            self.active = true
            self.selectedChoice = nil
            self.click = 0
            self.scroll = 0
            self.selectedTable = self.manSkins
            self.ped = createPed(1, 0, 0, 0)
            self.ped:setData("alpha", 255)
            self.ped.interior = 18
            self.ped.dimension = 10
			triggerEvent("setPlayerCustomAnimation", self.ped, self.ped, "custom_9")
            self.prevPed = exports["cr_object-preview"]:createObjectPreview(self.ped, 0, 0, 180, self.sizeX / 2 + 390, self.sizeY / 2 + 100, 420, 420, false, true)
            exports["cr_object-preview"]:setRotation(self.prevPed, 0, 0, 180)
            showCursor(true)
            addEventHandler("onClientRender", root, self.render, true, "low-10")
        end
    end
end

function skinshop:up()
    self = skinshop;
    if self.active then
        if self.scroll > 0 then
            self.scroll = self.scroll - 1
        end
    end
end

function skinshop:down()
    self = skinshop;
    if self.active then
        if self.scroll < #self.selectedTable - 15 then
            self.scroll = self.scroll + 1
        end
    end
end

function skinshop:roundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x + radius, y + radius, width - (radius * 2), height - (radius * 2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x + radius, y + radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x + radius, (y + height) - radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x + width) - radius, (y + height) - radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x + width) - radius, y + radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y + radius, radius, height - (radius * 2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x + radius, y + height - radius, width - (radius * 2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x + width - radius, y + radius, radius, height - (radius * 2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x + radius, y, width - (radius * 2), radius, color, postGUI, subPixelPositioning)
end

function skinshop:isInBox(xS, yS, wS, hS)
    self = skinshop;
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        cursorX, cursorY = cursorX * self.screen.x, cursorY * self.screen.y
        if(cursorX >= xS and cursorX <= xS + wS and cursorY >= yS and cursorY <= yS + hS) then
            return true
        else
            return false
        end
    end
end

skinshop:create()