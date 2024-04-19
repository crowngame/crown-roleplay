__exports = exports
__createObject = createObject
__addEventHandler = addEventHandler

__ = {
	obje_olustur = createObject,
	event = addEvent,
	eventhandler = addEventHandler,
	
}

timer = {
    render = setTimer,
    close = killTimer,
}

get = {
    model = getElementModel,
	type = getElementType,
	cursorpos = getCursorPosition(),
	screensize = guiGetScreenSize(),
}

show = {
    cursor = showCursor,
    chat = showChat,
}

dx = {
    rectangle = dxDrawRectangle,
    circle = dxDrawCircle,
    text = dxDrawText,
}