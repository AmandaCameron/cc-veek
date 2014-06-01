-- lint-mode: veek-widget

_parent = 'agui-widget'

function Widget:init(x, y, h)
  self.agui_widget:init(x, y, 1, h)

  self.agui_widget.fg = "seperator-fg"
  self.agui_widget.bg = "seperator-bg"

  self.agui_widget:add_flag('buffered')
end

function Widget:draw(canvas, theme)
  for y = 1, self.agui_widget.height do
    canvas:move(1, y)
    canvas:write("|")
  end
end
