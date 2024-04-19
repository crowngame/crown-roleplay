Spinner = {}
Spinner.alias = 'spinner'
Spinner.initialOptions = {
    position = { x = 0, y = 0 },
    size = 64,

    speed = 2,

    label = '',
	font = exports.cr_fonts:getFont("UbuntuRegular", 9),
	
    postGUI = false
}
Spinner.rotation = 0
Spinner.tickCount = getTickCount()

Spinner.svgPath = svgCreate(128, 128, [[
<svg xmlns="http://www.w3.org/2000/svg" width="38" height="38" viewBox="0 0 38 38"><script xmlns=""/><script xmlns=""/>
    <defs>
        <linearGradient x1="8.042%" y1="0%" x2="65.682%" y2="23.865%" id="a">
            <stop stop-color="#fff" stop-opacity="0" offset="0%"/>
            <stop stop-color="#fff" stop-opacity=".631" offset="63.146%"/>
            <stop stop-color="#fff" offset="100%"/>
        </linearGradient>
    </defs>
    <g fill="none" fill-rule="evenodd">
        <g transform="translate(1 1)">
            <path d="M36 18c0-9.94-8.06-18-18-18" id="Oval-2" stroke="url(#a)" stroke-width="2">
                <animateTransform attributeName="transform" type="rotate" from="0 18 18" to="360 18 18" dur="0.9s" repeatCount="indefinite"/>
            </path>
            <circle fill="#fff" cx="36" cy="18" r="1">
                <animateTransform attributeName="transform" type="rotate" from="0 18 18" to="360 18 18" dur="0.9s" repeatCount="indefinite"/>
            </circle>
        </g>
    </g>
</svg>
]])

function drawSpinner(options)
    local position = options.position or Spinner.initialOptions.position
    local size = options.size or Spinner.initialOptions.size

    local speed = options.speed or Spinner.initialOptions.speed

    local label = options.label or Spinner.initialOptions.label
	
	local postGUI = options.postGUI or Spinner.initialOptions.postGUI

    if Spinner.tickCount + speed < getTickCount() then
        Spinner.tickCount = getTickCount()
        Spinner.rotation = Spinner.rotation + 5
        if Spinner.rotation > 360 then
            Spinner.rotation = 0
        end
    end

    dxDrawImage(position.x, position.y, size, size, Spinner.svgPath, Spinner.rotation, 0, 0, tocolor(255, 255, 255, 255), postGUI)
    if label then
        dxDrawText(label, position.x, position.y + size + 10, position.x + size, position.y + size + 10, rgba("#f0f0f5", 0.7), 1, Spinner.initialOptions.font, 'center', 'top', false, false, postGUI)
    end
end