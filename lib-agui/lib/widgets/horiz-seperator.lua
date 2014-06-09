--- Horizontal Seperator Widget.
-- @parent agui-widget
-- @classmod agui-horiz-seperator

-- lint-mode: veek-widget

_parent = 'agui-widget'

--- Initialise an agui-horiz-seperator
-- @int x The X position of the seperator.
-- @int y The Y position of the seperator.
-- @int w The Width of the seperator.
function Widget:init(x, y, w)
  self.agui_widget:init(x, y, w, 1)

  self.agui_widget.fg = "seperator-fg"
  self.agui_widget.bg = "seperator-bg"

  self.agui_widget:add_flag('buffered')
end

function Widget:draw(canvas, theme)
  canvas:move(1,1)
  canvas:write(string.rep("-", self.agui_widget.width))
end
