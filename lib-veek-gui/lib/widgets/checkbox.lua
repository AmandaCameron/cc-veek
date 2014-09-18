--- Checkbox input widget.
-- @parent veek-widget
-- @classmod veek-checkbox

-- lint-mode: veek-widget

_parent = 'veek-input'

----------
-- Input Changed
-- @event gui.input.changed
-- @bool value The new value.

--- Intialise the widget.
-- @int x The X Position of the widget.
-- @int y The Y position of the widget.
-- @string text The label for the widget.
-- @tparam ?|int width The width of the label.
function Widget:init(x, y, text, width)
	self.veek_input:init(x, y, width or (#text + 4))

	self.label = text

	self.veek_input.value = false
end

--- Sets the value for the widget.
-- This triggers the @{gui.input.changed} event.
-- @bool new_value The new value to set.
function Widget:set_value(new_value)
	self.veek_input.value = new_value

	self.veek_input:notify()
end

--- Toggles the value.
function Widget:toggle()
	self:set_value(not self.veek_input.value)
end

function Widget:draw(canvas, theme)
	local ind = '[ ]'

	if self.veek_input.value then
		ind = '[X]'
	end

	local lbl = self.label

	if #lbl > self.veek_widget.width - 4 then
		lbl = string.sub(lbl, self.veek_widget.width - 7) .. "..."
	end

	-- TODO: Colours!

	canvas:move(1, 1)

	canvas:write(ind)
	canvas:write(' ')
	canvas:write(lbl)
end

function Widget:clicked(x, y, btn)
	if x == 2 and y == 1 then
		self:toggle()
	end
end

function Widget:key(k)
	if k == keys.enter then
		self:toggle()
	end
end

function Widget:char(ch)
	-- Do Nothing.
end
