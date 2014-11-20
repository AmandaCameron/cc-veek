--- Text Input Widget.
-- @parent veek-widget
-- @widget veek-input

-- lint-mode: veek-widget

_parent = "veek-widget"

--------
-- Input Changed.
-- @event gui.input.changed
-- @int id The widget ID.
-- @string value The new value.

--- Initialise an veek-input
-- @int x The X position to be in.
-- @int y The Y position to be in.
-- @int width The widget's width
function Widget:init(x, y, width)
	self.veek_widget:init(x, y, width, 1)

	self.placeholder = nil
	self.value = ''

	self.veek_widget.bg = 'input--bg'
	self.veek_widget.fg = 'input--fg'

	self.veek_widget:add_flag('active')
end

function Widget:focus()
	self.veek_widget:focus()
end

function Widget:blur()
	self.veek_widget:blur()
end

function Widget:notify()
	--fire_event('value_changed', self.veek_widget.id, self.value)
	--event.trigger("gui.input.changed", self.veek_widget.id, self.value)
	self.veek_widget:trigger('gui.input.changed', self.value)
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

	if #str > self.veek_widget.width - 1 - #prefix then
		str = string.sub(str, #str - self.veek_widget.width + 1 + #prefix)
	end

	c:move(1, 1)

	c:write(prefix .. str)
	c:write(string.rep(' ', self.veek_widget.width - #str - #prefix))

 	c:set_cursor(#str + #prefix + 1, 1, true)
end
