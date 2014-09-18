--- Label Widget.
-- This displays some short text, ellipsiing it if it's too long.
-- @classmod veek-label

-- lint-mode: veek-widget

_parent = 'veek-widget'

--- Initalise an veek-label
-- @int x The X position for the widget.
-- @int y The Y position for the widget.
-- @tparam ?|string text The label's text.
-- @tparam ?|int width The label's width.
function Widget:init(x, y, text, width)
	local text = text or ''

	self.veek_widget:init(x, y, width or #text, 1)

	self.text = text

	self.veek_widget.fg = 'label--fg'
	self.veek_widget.bg = 'label--bg'
end

function Widget:draw(canvas)
	local val = self.text

	if #val > self.veek_widget.width then
		val = string.sub(val, 1, self.veek_widget.width - 3) .. "..."
	else
		val = val .. string.rep(' ', self.veek_widget.width - #val)
	end

	canvas:write(val)
end

function Widget:clicked(x, y, button) end
function Widget:key(key) end
