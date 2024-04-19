local ekran = Vector2(guiGetScreenSize())
local w,h = 420, 460
local wx,wy = (ekran.x-w)/2, (ekran.y-h)/2

list = {
    {"Para Çek",1},
    {"Para Yatır",2},
}

function atm_render()
    dxDrawRectangle(wx, wy, w, h, tocolor(15,15,15))
    dxDrawText("Bank of Los Santos",wx+20,wy+20,nil,nil,tocolor(200,200,200),1,f.roboto_b)
    local xw,xh = dxGetTextWidth("",1,f.awesome),dxGetFontHeight(1,f.awesome)
    dxDrawText("",wx+w-45,wy+20,nil,nil,exports.cr_ui:isInBox(wx+w-45,wy+20,xw,xh) and tocolor(190,59,59) or tocolor(200,200,200),1,f.awesome)
    if exports.cr_ui:isInBox(wx+w-45,wy+20,xw,xh) and getKeyState("mouse1") and click+400 < getTickCount() then
        c_render_close()
        click = getTickCount()
    end
    dxDrawRectangle(wx+20, wy+65, w-40, 54, tocolor(25,61,143,250))
    dxDrawText("Hoş geldin, " .. getPlayerName(localPlayer):gsub("_"," ") .. "!",wx+30,wy+73,nil,nil,tocolor(183,218,252),1,f.roboto_bs)
    dxDrawText("Güncel bakiyeniz: $" .. exports.cr_global:formatMoney(getElementData(localPlayer,"bankmoney")),wx+30,wy+93,nil,nil,tocolor(183,218,252,200),1,f.roboto)
    dxDrawRectangle(wx+20, wy+135, w-40, 300, tocolor(25,25,25))
    dxDrawRectangle(wx+20, wy+135, w-40, 50, tocolor(28,28,28))
    newX = 0
    for k,v in pairs(list) do
        local tw = dxGetTextWidth(v[1],1,f.roboto_k)
        dxDrawRectangle(wx+32+newX-5,wy+139,tw+15,40,selected == k and tocolor(20,20,20) or tocolor(0,0,0,0))
        dxDrawText(v[1],wx+40+newX-5,wy+147,nil,nil,tocolor(200,200,200),1,f.roboto_k)
        if exports.cr_ui:isInBox(wx+32+newX-5,wy+139,tw+15,40) and getKeyState("mouse1") and click+400 < getTickCount() then
            selected = k
            click = getTickCount()
        end
        newX = newX + tw + 20
    end 
    if exports.cr_ui:isInBox(wx+39, wy+232, w-78, 37) and getKeyState("mouse1") and click+400 < getTickCount() then
        if selected == 1 then
            if aktif == 0 then
                aktif = 1
                addEventHandler("onClientCharacter", root, write,true,"low-10")
            end
            miktar = ""
        else
            if aktif == 0 then
                aktif = 1
                addEventHandler("onClientCharacter", root, write,true,"low-10")
            end
            miktar = ""
        end
        click = getTickCount()
    end
    dxDrawText("Tutar",wx+41,wy+205,nil,nil,tocolor(200,200,200),1,f.roboto)
    if string.len(errorText) > 0 then
        dxDrawText(errorText,wx+41,wy+275,nil,nil,tocolor(255,20,20),1,f.roboto)
    end
    dxDrawRectangle(wx+39, wy+232, w-78, 37, tocolor(200,200,200))
    dxDrawRectangle(wx+40, wy+233, w-80, 35, tocolor(20,20,20))
    dxDrawText(miktar,wx+50,wy+241,nil,nil,tocolor(175,175,175,175),1,f.robotoX,"left")
    if exports.cr_ui:isInBox(wx+39, wy+380, w-78, 42) and getKeyState("mouse1") and click+400 < getTickCount() then
        if exports.cr_network:getNetworkStatus() then
            outputChatBox("[!]#FFFFFF Internet bağlantınızı kontrol edin.", 255, 0, 0, true)
            return false
        end
		
		if selected == 1 then
            triggerServerEvent("bank.withdraw",localPlayer,miktar)
            miktar = ""
        elseif selected == 2 then
            triggerServerEvent("bank.deposit",localPlayer,miktar)
            miktar = ""
        end
        click = getTickCount()
    end
    if selected == 1 then text = "Para Çek" elseif selected == 2 then text = "Para Yatır" end
    dxDrawRectangle(wx+39, wy+380, w-78, 42, tocolor(6,97,60))
    dxDrawText(text,wx,wy+391,wx+w,nil,tocolor(230,230,230),1,f.roboto_bs,"center")
    if getKeyState('backspace') and click+120 <= getTickCount() then
        click = getTickCount()
        miktar = string.sub(miktar,1,string.len(miktar)-1)
    end
end    

addEventHandler('onClientClick', root, function(button,state, _,_,_,_,_, element)
    if button == 'right' and state == 'down' then 
        if element then
            if get.type(element) == 'object' and get.model(element) == 2942 then
                c_render_open()
				__.eventhandler("onClientRender",root,atm_render,true,"low-10")
            end
        end
    end
end)

function write(character)
    if string.len(miktar) <= 7 then
        miktar = "" .. miktar .. "" .. tonumber(character)
    end
end

function err(result)
    local result = result or ""
    errorText = result
end
addEvent("atm:error", true)
addEventHandler("atm:error", root, err)