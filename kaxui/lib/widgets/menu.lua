_parent = 'agui-container'

function Widget:init()
  self.agui_container:init(1, 1, 10, 1)
end

function Widget:add_option(label)
  local btn = new('kaxui-menu-button', #self.agui_container.children + 1, label)

  self.agui_container:add(btn)

  if #self.agui_container.children == 1 then
    self.agui_container:focus_next()
  end

  self.agui_widget.height = #self.agui_container.children

  return btn
end

function Widget:key(key)
  if key == keys.up then
    self:focus_prev()
    return true
  elseif key == keys.down then
    self:focus_next()
    return true
  else
    return self.agui_container:key(key)
  end
end

function Widget:draw(c, theme)
  for _, child in ipairs(self.agui_container.children) do
    child.agui_widget.width = self.agui_widget.width
  end

  self.agui_container:draw(c, theme)
end

-- TODO: Make this work bettar


function Widget:focus_prev()
  if self:get_focus() then
    self:get_focus():blur()
  end
  
  self.agui_widget.dirty = true

  local found = 0

  while found < 2 do
    self.agui_container.cur_focus = self.agui_container.cur_focus - 1

    if self.agui_container.cur_focus < 1 then
      self.agui_container.cur_focus = #self.agui_container.children

      found = 1 + found
    end

    if self:get_focus().agui_widget:has_flag('active') 
      and self:get_focus().agui_widget.enabled then
      break
    end
  end

  if found > 1 then
    return false
  end

  self:get_focus():focus()

  --self.children[self.cur_focus]:focus()
  return true
end
