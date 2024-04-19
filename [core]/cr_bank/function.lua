function c_render_open()
    show.cursor(true)
    click = 0
    selected = 1
    aktif = 0
    miktar = "0"
    errorText = ""
end

function c_render_close()
    removeEventHandler("onClientRender",root,atm_render)
    show.cursor(false)
    if aktif == 1 then 
        removeEventHandler("onClientCharacter", root, write)
    end
end

function c_rounded(x,y,w,h,color,radius)
    w = w - radius * 2
    h = h - radius * 2
    x = x + radius
    y = y + radius

    if (w >= 0) and (h >= 0) then
        dx.rectangle(x,y,w,h,color)
        dx.rectangle(x,y - radius,w,radius,color)
        dx.rectangle(x,y + h,w,radius,color)
        dx.rectangle(x - radius,y,radius,h,color)
        dx.rectangle(x + w,y,radius,h,color)

        dx.circle(x, y, radius, 180, 270, color, color, 7)
        dx.circle(x + w,y,radius,270,360,color,color,7)
        dx.circle(x + w,y + h,radius,0,90,color,color,7)
        dx.circle(x,y + h,radius,90,180,color,color,7)
    end
end

function c_pos(x,y,w,h)
    if (isCursorShowing()) then
        local cursorX, cursorY = getCursorPosition()
        sX,sY = guiGetScreenSize()
        cursorX, cursorY = cursorX*sX, cursorY*sY
        if(cursorX >= x and cursorX <= x+w and cursorY >= y and cursorY <= y+h) then
            return true
        else
            return false
        end
    end
end