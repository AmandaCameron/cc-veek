_parent = 'agui-list-item'

function Widget:init(title)
  self.agui_list_item:init(title)

  self.agui_widget.fg = 'kaxui-list-header-fg'
  self.agui_widget.bg = 'kaxui-list-header-bg'
end