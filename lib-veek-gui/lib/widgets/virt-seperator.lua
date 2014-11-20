--- Vertical Seperatpr.
-- @parent veek-widget
-- @widget veek-virt-seperator

-- lint-mode: veek-widget

_parent = 'veek-widget'

--- Initialise an veek-vert-seperator
-- @int x The X position of the seperator.
-- @int y The Y position of the seperator.
-- @int h The Height of the seperator.
function Widget:init(x, y, h)
  self.veek_widget:init(x, y, 1, h)

  self.veek_widget.fg = "seperator-fg"
  self.veek_widget.bg = "seperator-bg"

  self.veek_widget:add_flag('buffered')
end

function Widget:draw(canvas, theme)
  for y = 1, self.veek_widget.height do
    canvas:move(1, y)
    canvas:write("|")
  end
end
