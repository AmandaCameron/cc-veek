-- lint-mode: veek-widget

_parent = 'veek-list-item'

function Widget:init(title)
  self.veek_list_item:init("")

  self.title = title

  self.veek_widget.fg = 'kaxui-list-header-fg'
  self.veek_widget.bg = 'kaxui-list-header-bg'
end

function Widget:draw(c)
  c:clear()

  c:move(1, 1)

  c:write((' '):rep(c.width / 2 - #self.title / 2))
  c:write(self.title)
end
