-- lint-mode: veek-widget

_parent = 'veek-list-item'

function Widget:init(pkg)
  self.veek_list_item:init(pkg.name)
  self.veek_widget.height = 2

  self.pkg = pkg
end

function Widget:draw(c, theme)
  c:clear()

  c:move(1, 1)
  c:write(self.veek_list_item.label)

  c:move(1, 2)
  c:write("v"..self.pkg.version)
end
