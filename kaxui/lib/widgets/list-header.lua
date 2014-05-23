_parent = 'agui-list-item'

function Widget:init(title)
  self.agui_list_item:init("")

  self.title = title

  self.agui_widget.fg = 'kaxui-list-header-fg'
  self.agui_widget.bg = 'kaxui-list-header-bg'
end

function Widget:draw(c)
  c:clear()

  c:move(1, 1)

  c:write((' '):rep(c.width / 2 - #self.title / 2))
  c:write(self.title)
end
