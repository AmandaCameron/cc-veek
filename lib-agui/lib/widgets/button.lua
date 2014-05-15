-- Simple Button for aGUI

_parent = 'agui-widget'

function Widget:init(x, y, text, width)
	local width = width or #text

	self.agui_widget:init(x, y, width, 1)

	self.text = text

	self.agui_widget.fg = 'button--fg'
	self.agui_widget.bg = 'button--bg'

	self.agui_widget:add_flag('active')
end

function Widget:draw(canvas)
	local val = self.text

	if #val > canvas.width - 2 then
		val = string.sub(val, 1, canvas.width - 5) .. "..."
	else
		val = string.rep(' ', math.floor((canvas.width - #val - 2) / 2)) .. val .. string.rep(' ', math.floor((canvas.width - #val - 2) / 2))
	end

	if not canvas.is_colour then
		if self.agui_widget.focused then
			canvas:write("{" .. val .. "}")
		else
			canvas:write("[" .. val .. "]")
		end
	else
		canvas:write(' ' .. val .. ' ')
	end
end

-- Maybe this should be handled by the toolkit?

function Widget:key(k)
	if k == keys.enter then
		self.agui_widget:trigger('gui.button.pressed')
	end

	return k == keys.enter
end

function Widget:clicked(x, y, btn)
	self.agui_widget:trigger('gui.button.pressed')
end
