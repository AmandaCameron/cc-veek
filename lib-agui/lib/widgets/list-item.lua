--- List Item widget.
-- This should only reside inside an agui-list.
-- @classmod agui-list-item

-- lint-mode: veek-widget

_parent = 'agui-widget'

-- Main Class

--- Initialise an agui-list-item
-- @string label
function Widget:init(label)
	self.agui_widget:init(1, 1, 1, 1) -- Widget x, y, width are all irrelevent for list items

	self.agui_widget.fg = 'list-item--fg'
	self.agui_widget.bg = 'list-item--bg'

	-- self.agui_widget:add_flag('buffered')

	self.data = {}
	self.label = label
end

function Widget:draw(canvas, theme)
	canvas:clear()

	local lbl = self.label

	if #lbl > self.agui_widget.width then
		lbl = lbl:sub(1, self.agui_widget.width - 3) .. "..."
	end

	canvas:move(1, 1)
	canvas:write(lbl)
end
