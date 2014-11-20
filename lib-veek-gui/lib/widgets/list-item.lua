--- List Item widget.
-- This should only reside inside an veek-list.
-- @widget veek-list-item

-- lint-mode: veek-widget

_parent = 'veek-widget'

-- Main Class

--- Initialise an veek-list-item
-- @string label
function Widget:init(label)
	self.veek_widget:init(1, 1, 1, 1) -- Widget x, y, width are all irrelevent for list items

	self.veek_widget.fg = 'list-item--fg'
	self.veek_widget.bg = 'list-item--bg'

	-- self.veek_widget:add_flag('buffered')

	self.data = {}
	self.label = label
end

function Widget:draw(canvas, theme)
	canvas:clear()

	local lbl = self.label

	if #lbl > self.veek_widget.width then
		lbl = lbl:sub(1, self.veek_widget.width - 3) .. "..."
	end

	canvas:move(1, 1)
	canvas:write(lbl)
end
