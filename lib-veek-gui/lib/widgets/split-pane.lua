--- Split-Pane widget.
-- This shows two veek-widgets side-by-side, allowing the user to
-- resize the left one. This also supports making the left veek-widget invisible
-- until the user drags right from the left-most position.
-- @parent veek-widget
-- @classmod veek-split-pane

-- lint-mode: veek-widget

_parent = 'veek-widget'

--- Initalises an veek-split-pane widget.
-- @tparam veek-widget side_bar The left-side pane.
-- @tparam veek-widget main_view The right-side pane.
function Widget:init(side_bar, main_view)
  self.veek_widget:init(1, 1, 1, 1)

  self.veek_widget:add_flag('active')

  self.veek_widget.fg = 'seperator-fg'
  self.veek_widget.bg = 'seperator-bg'

  self.min_pos = 1
  self.max_pos = 10

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
    self.side_bar:resize(self.position - 1, self.veek_widget.height)
  end

  if pocket then
    self.main_view:resize(self.veek_widget.width - self.min_pos, self.agui_widget.height)
    self.main_view:move(self.min_pos + 1, 1)
  else
    self.main_view:move(self.position + 1, 1)
    self.main_view:resize(self.veek_widget.width - self.position, self.agui_widget.height)
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
  self.main_view:cast('veek-widget').main = self.agui_widget.main
  self.side_bar:cast('veek-widget').main = self.agui_widget.main

  self.veek_widget:resize(w, h)

  self:update_sizes()
end

function Widget:clicked(x, y, button)
  self.main_view:cast('veek-widget').main = self.agui_widget.main
  self.side_bar:cast('veek-widget').main = self.agui_widget.main

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
  self.main_view:cast('veek-widget').main = self.agui_widget.main
  self.side_bar:cast('veek-widget').main = self.agui_widget.main

  self.mouse_x = self.mouse_x + x_del
  self.mouse_y = self.mouse_y + y_del

  if self.moving then
    self.position = self.position + x_del

    if self.position == 1 and pocket then
      self.position = 0
    elseif self.position > self.max_pos then
      self.position = self.max_pos

      self.moving = false
    elseif self.position < self.min_pos then
      self.position = self.min_pos

      self.moving = false
    end

    self:update_sizes()
  elseif self.mouse_x > self.position then
    self.main_view:dragged(x_del, y_del, button)
  else
    self.side_bar:dragged(x_del, y_del, button)
  end
end

function Widget:scroll(x, y, dir)
  self.main_view:cast('veek-widget').main = self.agui_widget.main
  self.side_bar:cast('veek-widget').main = self.agui_widget.main

  self.mouse_x = x
  self.mouse_y = y

  if x > self.position then
    self.main_view:scroll(x - self.position, y, dir)
  elseif x < self.position then
    self.side_bar:scroll(x, y, dir)
  end
end

function Widget:focus()
  self.veek_widget:focus()

  self.main_view:cast('veek-widget').main = self.agui_widget.main
  self.side_bar:cast('veek-widget').main = self.agui_widget.main

  if self.active == 1 then
    self.main_view:focus()
  else
    self.side_bar:focus()
  end
end

function Widget:blur()
  self.main_view:cast('veek-widget').main = self.agui_widget.main
  self.side_bar:cast('veek-widget').main = self.agui_widget.main

  self.veek_widget:blur()

  self.main_view:blur()
  self.side_bar:blur()
end

function Widget:key(k)
  self.main_view:cast('veek-widget').main = self.agui_widget.main
  self.side_bar:cast('veek-widget').main = self.agui_widget.main

  if self.active == 1 and self.main_view:key(k) then
    return true
  elseif self.active == 2 and self.side_bar:key(k) then
    return true
  elseif k == keys.tab or k == keys.leftCtrl or k == keys.rightCtrl then

    if self.active == 1 then
      self.active = 2
    else
      self.active = 1
    end

    self:update_active()

    return true
  end

  return false
end

function Widget:char(c)
  self.main_view:cast('veek-widget').main = self.agui_widget.main
  self.side_bar:cast('veek-widget').main = self.agui_widget.main

  if self.active == 1 then
    self.main_view:char(c)
  else
    self.side_bar:char(c)
  end
end

function Widget:draw(c)
  self.main_view:cast('veek-widget').main = self.agui_widget.main
  self.side_bar:cast('veek-widget').main = self.agui_widget.main

  if self.min_pos == 0 then
    self:draw_raw(self.main_view, c)
  end

  if self.position > 1 then
    self:draw_raw(self.side_bar, c)
  end

  if self.position > 0 then
    local sub = c:sub(self.position, 1, 1, c.height)

    sub:set_fg('seperator-fg')
    sub:set_bg('seperator-bg')

    for y=1,sub.height do
      sub:move(1, y)

      sub:write("|")
    end
  end

  if self.min_pos > 0 then
    self:draw_raw(self.main_view, c)
  end
end
