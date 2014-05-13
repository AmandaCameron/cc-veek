_parent = 'agui-widget'

function Widget:init(side_bar, main_view)
  self.agui_widget:init(1, 1, 1, 1)

  self.agui_widget:add_flag('active')

  self.min_pos = 1
  self.max_pos = 8

  self.position = self.max_pos
  
  self.active = 1

  self.moving = false

  if pocket then
    self.min_pos = 0
    self.max_pos = 15

    self.position = 0
  end

  self.side_bar = side_bar
  self.main_view = main_view

  self.mouse_x = 0
  self.mouse_y = 0

  self:update_active()
  self:update_sizes()
end

-- Updates the child widget's sizes

function Widget:update_sizes()
  if self.position > 1 then
    self.side_bar:resize(self.position - 1, self.agui_widget.height)
  end

  if pocket then
    self.main_view:resize(self.agui_widget.width - self.min_pos + 1, self.agui_widget.height)
    self.main_view:move(self.min_pos + 1, 1)
  else
    self.main_view:move(self.position + 2, 1)
    self.main_view:resize(self.agui_widget.width - self.position - 1, self.agui_widget.height)
  end
end

function Widget:update_active()
  if self.active == 2 then
    self.position = self.max_pos

    self.side_bar:focus()
    self.main_view:blur()
  else
    self.side_bar:blur()
    self.main_view:focus()

    self.position = self.min_pos
  end

  self:update_sizes()
end

-- Widget function overrides

function Widget:resize(w, h)
  self.agui_widget:resize(w, h)

  self:update_sizes()
end

function Widget:clicked(x, y, button)
  self.mouse_x = x
  self.mouse_y = y

  if x == self.position then
    self.moving = true
  elseif x == 1 and self.position == 0 then
    self.moving = true
  else
    -- Make sure the right view gets it's prority

    if x > self.position then
      self.main_view:clicked(x - self.position, y, button)

      self.active = 1

      self:update_active()
    elseif x < self.position then
      self.side_bar:clicked(x, y, button)

      self.active = 2

      self:update_active()
    end

    self.moving = false
  end
end

function Widget:dragged(x_del, y_del, button)
  self.mouse_x = self.mouse_x + x_del
  self.mouse_y = self.mouse_y + y_del

  if self.moving then
    self.position = self.position + x_del

    self:update_sizes()

    if self.position == 1 and pocket then
      self.position = 0
    elseif self.position > self.max_pos then
      self.position = self.max_pos

      self.moving = false
    elseif self.position < self.min_pos then
      self.position = self.min_pos

      self.moving = false
    end
  elseif self.mouse_x > self.position then
    self.main_view:dragged(x_del, y_del, button)
  else
    self.side_bar:dragged(x_del, y_del, button)
  end
end

function Widget:scroll(x, y, dir)
  self.mouse_x = x
  self.mouse_y = y

  if x > self.position then
    self.main_view:scroll(x - self.position, y, dir)
  elseif x < self.position then
    self.side_bar:scroll(x, y, dir)
  end
end

function Widget:focus()
  self.agui_widget:focus()

  if self.active == 1 then
    self.main_view:focus()
  else
    self.side_bar:focus()
  end
end

function Widget:blur()
  self.agui_widget:blur()

  self.main_view:blur()
  self.side_bar:blur()
end

function Widget:key(k)
  if k == keys.leftCtrl or k == keys.rightCtrl then
    self.active = self.active + 1

    if self.active > 2 then
      self.active = 1
    end

    self:update_active()

    return true
  else
    if self.active == 1 then
      return self.main_view:key(k)
    else
      return self.side_bar:key(k)
    end
  end
end

function Widget:char(c)
  if self.active == 1 then
    self.main_view:char(c)
  else
    self.side_bar:char(c)
  end
end

function Widget:draw(c)
  self:draw_raw(self.main_view, c)

  if self.position > 1 then
    self:draw_raw(self.side_bar, c)
  end

  if self.position > 0 then
    c:set_fg('white')
    c:set_bg('grey')

    for y=1,c.height do
      c:move(self.position, y)

      c:write("|")
    end
  end
end