-- lint-mode: veek-widget

_parent = 'agui-widget'

function Widget:init(x, y, width)
	self.agui_widget:init(x, y, width, 1)

	self.placeholder = nil
	self.value = ''

	self.agui_widget.bg = 'input--bg'
	self.agui_widget.fg = 'input--fg'

	self.agui_widget:add_flag('active')
end

function Widget:focus()
	self.agui_widget:focus()
end

function Widget:blur()
	self.agui_widget:blur()
end

function Widget:notify()
	--fire_event('value_changed', self.agui_widget.id, self.value)
	--event.trigger("gui.input.changed", self.agui_widget.id, self.value)
	self.agui_widget:trigger('gui.input.changed', self.value)
end

function Widget:char(c)
	self.value = self.value .. c
	self:notify()
end

function Widget:key(sc)
	if sc == keys.backspace and #self.value then
		self.value = string.sub(self.value, 1, #self.value - 1)

		self:notify()
	end
end

function Widget:draw(c, theme)
	local str = self.value
	local prefix = ''

	if not c.is_colour then
		prefix = '> '
	end

	if self.placeholder then
		str = string.rep(self.placeholder, #str)
	end

	if #str > self.agui_widget.width - 1 - #prefix then
		str = string.sub(str, #str - self.agui_widget.width + 1 + #prefix)
	end

	c:move(1, 1)

	c:write(prefix .. str)
	c:write(string.rep(' ', self.agui_widget.width - #str - #prefix))

 	c:set_cursor(#str + #prefix + 1, 1, true)
end
