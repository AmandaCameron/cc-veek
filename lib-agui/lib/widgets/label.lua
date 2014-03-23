-- Label Widget for aGUI

_parent = 'agui-widget'

function Widget:init(x, y, text, width)
	local text = text or ''

	self.agui_widget:init(x, y, width or #text, 1)

	self.text = text
	self.agui_widget.bg = 'transparent'

	-- self.agui_widget:add_flag('buffered')
end

function Widget:draw(canvas)
	local val = self.text

	if #val > self.agui_widget.width then
		val = string.sub(val, 1, self.agui_widget.width - 3) .. "..."
	else
		val = val .. string.rep(' ', self.agui_widget.width - #val)
	end

	canvas:write(val)
end

function Widget:clicked(x, y, button) end
function Widget:key(key) end
