--- Horizontal Seperator Widget.
-- @parent veek-widget
-- @classmod veek-horiz-seperator

-- lint-mode: veek-widget

_parent = 'veek-widget'

--- Initialise an veek-horiz-seperator
-- @int x The X position of the seperator.
-- @int y The Y position of the seperator.
-- @int w The Width of the seperator.
function Widget:init(x, y, w)
  self.veek_widget:init(x, y, w, 1)

  self.veek_widget.fg = "seperator-fg"
  self.veek_widget.bg = "seperator-bg"

  self.veek_widget:add_flag('buffered')
end

function Widget:draw(canvas, theme)
  canvas:move(1,1)
  canvas:write(string.rep("-", self.veek_widget.width))
end
