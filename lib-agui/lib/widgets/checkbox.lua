-- lint-mode: veek-widget

_parent = 'agui-input'

function Widget:init(x, y, text, width)
	self.agui_input:init(x, y, width or (#text + 4))

	self.label = text

	self.agui_input.value = false
end

function Widget:set_value(new_value)
	self.agui_input.value = new_value

	self.agui_input:notify()
end

function Widget:toggle()
	self:set_value(not self.agui_input.value)
end

function Widget:draw(canvas, theme)
	local ind = '[ ]'

	if self.agui_input.value then
		ind = '[X]'
	end

	local lbl = self.label

	if #lbl > self.agui_widget.width - 4 then
		lbl = string.sub(lbl, self.agui_widget.width - 7) .. "..."
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
