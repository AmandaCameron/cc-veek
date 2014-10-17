--- Label Widget.
-- This displays some short text, ellipsiing it if it's too long.
-- @classmod veek-label

-- lint-mode: veek-widget

_parent = 'veek-widget'

--- Initalise an veek-label
-- @int x The X position for the widget.
-- @int y The Y position for the widget.
-- @tparam ?|veek-attrib-string|string text The label's text.
-- @tparam ?|int width The label's width.
function Widget:init(x, y, text, width)
	local text = veek.attrib_string(text)

	self.veek_widget:init(x, y, width or text:length(), 1)

	self.text = text

	self.veek_widget.fg = 'label--fg'
	self.veek_widget.bg = 'label--bg'
end

function Widget:draw(canvas)
	canvas:clear()

	local val = self.text

	if val:length() > canvas.width - 3 then
		val = val:substring(1, canvas.width - 3):append("...")
	end

	val:render(canvas)
end
