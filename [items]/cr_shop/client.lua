local shop = new("DXshop")

function shop.prototype.____constructor(self)
	self.screenSize = Vector2(guiGetScreenSize())
	self.sizeX, self.sizeY = 695, 400
	self.screenX, self.screenY = (self.screenSize.x - self.sizeX) / 2, (self.screenSize.y - self.sizeY) / 2
	
	self.clickTick = 0
	self.maxColumn = 7
	self.maxItem = 21

	self.fonts = {
        regular = exports.cr_fonts:getFont("sf-regular", 11),
        bold = exports.cr_fonts:getFont("sf-bold", 18),
        light = exports.cr_fonts:getFont("sf-light", 9),
        awesome = exports.cr_fonts:getFont("FontAwesome", 16)
	}

	self._function = {
		up = function(...) self:up(...) end,
		down = function(...) self:down(...) end,
		open = function(...) self:open(...) end,
		render = function(...) self:render(...) end,
	}
	
	bindKey("mouse_wheel_up", "down", self._function.up)
	bindKey("mouse_wheel_down", "down", self._function.down)
	
	addEvent("shop.open", true)
	addEventHandler("shop.open", root, self._function.open)
end

function shop.prototype.render(self)
	showCursor(true)
	self.timer = setTimer(function()
		dxDrawRectangle(self.screenX, self.screenY, self.sizeX, self.sizeY, tocolor(10, 10, 10, 245))
		dxDrawText(types[self.show], self.screenX + 20, self.screenY + 20, nil, nil, tocolor(255, 255, 255, 250), 1, self.fonts.bold)
		dxDrawText("istediğiniz ürünü tıklayarak satın alın", self.screenX + 20, self.screenY + 51, nil, nil, tocolor(255, 255, 255, 150), 1, self.fonts.regular)
		
		dxDrawText("", self.screenX + self.sizeX - 40, self.screenY + 20, nil, nil, exports.cr_ui:isInBox(self.screenX + self.sizeX - 40, self.screenY + 20, dxGetTextWidth("", 1, self.fonts.awesome), dxGetFontHeight(1, self.fonts.awesome)) and tocolor(234, 83, 83, 255) or tocolor(255, 255, 255, 255), 1, self.fonts.awesome)
		if exports.cr_ui:isInBox(self.screenX + self.sizeX - 40, self.screenY + 20, dxGetTextWidth("", 1, self.fonts.awesome), dxGetFontHeight(1, self.fonts.awesome)) and getKeyState("mouse1") and self.clickTick + 500 < getTickCount() then
			self.clickTick = getTickCount()
			showCursor(false)
			killTimer(self.timer)
			self.timer = nil
		end
	
		self.newX, self.newY, self.countX, self.countY = 0, 0, 0, 0
		for key, value in pairs(shopItems[self.show]) do
			if key > self.scroll and self.countY < self.maxItem then
				dxDrawRectangle(self.screenX + 20 + self.newX, self.screenY + 20 + self.newY + 75, 85, 85, exports.cr_ui:isInBox(self.screenX + 20 + self.newX, self.screenY + 20 + self.newY + 75, 85, 85) and tocolor(50, 50, 50, 200) or tocolor(25, 25, 25, 200))
				if value[1] == 115 then
					dxDrawImage(self.screenX + 20 + self.newX + 17.5, self.screenY + 15 + self.newY + 75 + 17.5, 50, 50, ":cr_items/images/-" .. value[3] .. ".png")
				else
					dxDrawImage(self.screenX + 20 + self.newX + 17.5, self.screenY + 15 + self.newY + 75 + 17.5, 50, 50, ":cr_items/images/" .. value[1] .. ".png")
				end
				dxDrawText("$" .. value[2], self.screenX + 75 + self.newX, self.screenY + self.newY + 160, self.screenX + 50 + self.newX, nil, tocolor(180, 180, 180, 255), 1, self.fonts.light, "center")
	
				if exports.cr_ui:isInBox(self.screenX + 20 + self.newX, self.screenY + 20 + self.newY + 75, 85, 85) and getKeyState("mouse1") and self.clickTick + 500 < getTickCount() then
					self.clickTick = getTickCount()
					triggerServerEvent("shop.buy", localPlayer, self.show, key)
				end
	
				self.countX = self.countX + 1
				self.countY = self.countY + 1
				self.newX = self.newX + 95
				if self.countX == self.maxColumn then
					self.newX = 0
					self.countX = 0
					self.newY = self.newY + 95
				end
			end
		end
	end, 0, 0)
end

function shop.prototype.open(self, element)
	if not isTimer(self.timer) then
		self.show, self.scroll = false, 0
		self.show = getElementData(element, "shop.type")
		self.timer = setTimer(self._function.render, 500, 1)
	end
end

function shop.prototype.up(self)
    if isTimer(self.timer) then 
        if exports.cr_ui:isInBox(self.screenX, self.screenY, self.sizeX, self.sizeY) then 
            if self.scroll > 0 then 
                self.scroll = self.scroll - self.maxColumn
            end
        end
	end
end

function shop.prototype.down(self)
	if isTimer(self.timer) then 
		if exports.cr_ui:isInBox(self.screenX, self.screenY, self.sizeX, self.sizeY) then 
			if self.scroll < #shopItems[self.show] - self.maxItem then 
				self.scroll = self.scroll + self.maxColumn
			end
		end
	end
end

load(shop)