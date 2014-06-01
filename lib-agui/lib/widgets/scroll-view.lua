-- lint-mode: veek-widget

-- Scroll-View container for Veek

_parent = "agui-widget"

function Widget:init(w, h)
  self.agui_widget:init(1, 1, w or 1, h or 1)

  self.agui_widget:add_flag('active')

  self.scroll_y = 0
  self.scroll_x = 0

  self.mouse = new('agui-mouse-track')
  self.moving = false

  self:reflow()
end

function Widget:scroll_into_view(x, y)
  if not (x - self.scroll_x > 0 and x - self.scroll_x < self.agui_widget.width) then
    self.scroll_x = math.floor(x)

    if self.scroll_x > self.width - self.agui_widget.width then
      self.scroll_x = self.width - self.agui_widget.width
    end
  end

  if not (y - self.scroll_y > 0 and y - self.scroll_y < self.agui_widget.height) then
    self.scroll_y = math.floor(y)

    if self.scroll_y > self.height - self.agui_widget.height and self.height > self.agui_widget.height then
      self.scroll_y = self.height - self.agui_widget.height
    end
  end
end

function Widget:get_size()
  return 0, 0
end

function Widget:draw_contents(c)
  -- Do Nothing.
end

function Widget:do_scroll(dir)
  self.scroll_y = self.scroll_y + dir

  if self.scroll_y < 0 then
    self.scroll_y = 0
  elseif self.scroll_y > self.height - self.agui_widget.height then
    self.scroll_y = self.height - self.agui_widget.height
  end
end

function Widget:do_side_scroll(dir)
  self.scroll_x = self.scroll_x + dir

  if self.scroll_x < 1 then
    self.scroll_x = 1
  elseif self.scroll_x > self.width - self.agui_widget.height then
    self.scroll_x = self.width - self.agui_widget.height
  end
end

function Widget:key(k)
  if k == keys.pageUp then
    self:do_scroll(0 - (self.agui_widget.height / 3))

    return true
  elseif k == keys.pageDown then
    self:do_scroll(self.agui_widget.height / 3)

    return true
  end

  return false
end

function Widget:clicked(x, y, btn)
  self.mouse:set(x, y)

  if x == self.agui_widget.width then
    self.moving_y = true

    return true
  elseif y == self.agui_widget.height then
    self.moving_x = true

    return true
  end

  return false
end

function Widget:scroll(x, y, dir)
  self.mouse:set(x, y)

  self:do_scroll(dir)

  return true
end

function Widget:dragged(x_delta, y_delta, dir)
  self.mouse:move(x_delta, y_delta)

  if self.moving_y then
    self.scroll_y = self.mouse.y * math.floor(self.height / self.agui_widget.height)

    if self.scroll_y > self.height - self.agui_widget.height then
      self.scroll_y = self.height - self.agui_widget.height
    end

    return true
  elseif self.moving_x then
    self.scroll_x = self.mouse.x * math.floor(self.width / self.agui_widget.width)

    if self.scroll_x > self.width - self.agui_widget.width then
      self.scroll_x = self.width - self.agui_widget.width
    end

    return true
  end

  return false
end

function Widget:draw(c)
  local y_bar_pos = math.floor(self.scroll_y / (self.height - c.height) * c.height)
  local x_bar_pos = math.floor(self.scroll_x / (self.width - c.width) * c.width)

  --y_bar_pos = y_bar_pos - math.floor(self.y_bar_size / 2)

  if y_bar_pos < 1 then
    y_bar_pos = 1
  elseif y_bar_pos > c.height - self.y_bar_size then
    y_bar_pos = c.height - self.y_bar_size
  end

  -- [x_bar_pos = x_bar_pos - math.floor(self.x_bar_size / 2)

  if x_bar_pos < 1 then
    x_bar_pos = 1
  elseif x_bar_pos > c.height - self.x_bar_size then
    x_bar_pos = c.height - self.x_bar_size
  end

  c:clear()
  c:move(1, 1)

  c:push()
  c:translate(0 - self.scroll_x, 0 - self.scroll_y)

  self.draw_contents(c)

  c:pop()

  if self.height > c.height then
    for y=1,c.height - 1 do
      c:move(c.width, y)

      if y == y_bar_pos then
        c:set_fg("scroll-bar-knob-begin-fg")
        c:set_bg("scroll-bar-knob-begin-bg")

        c:write("^")
      elseif y > y_bar_pos and y < y_bar_pos + self.y_bar_size - 1 then
        c:set_fg("scroll-bar-knob-fg")
        c:set_bg("scroll-bar-knob-bg")

        c:write("|")
      elseif y == y_bar_pos + self.y_bar_size - 1 then
        c:set_fg("scroll-bar-knob-end-fg")
        c:set_bg("scroll-bar-knob-end-bg")

        c:write("v")
      end
    end
  end

  if self.width > c.width then
    for x=1,c.width - 1 do
      c:move(x, c.height)

      if x == x_bar_pos then
        c:set_fg("scroll-bar-knob-begin-fg")
        c:set_bg("scroll-bar-knob-begin-bg")

        c:write("<")
      elseif x > x_bar_pos and x < x_bar_pos + self.x_bar_size - 1 then
        c:set_fg("scroll-bar-knob-fg")
        c:set_bg("scroll-bar-knob-bg")

        c:write("=")
      elseif x == x_bar_pos + self.x_bar_size - 1 then
        c:set_fg("scroll-bar-knob-end-fg")
        c:set_bg("scroll-bar-knob-end-bg")

        c:write(">")
      end
    end
  end
end

function Widget:reflow()
  self.width, self.height = self.get_size()

  self.x_bar_size = math.floor(self.agui_widget.width / self.width * self.agui_widget.width)
  self.y_bar_size = math.floor(self.agui_widget.height / self.height * self.agui_widget.height)

  if self.y_bar_size < 3 then
    self.y_bar_size = 3
  end

  if self.x_bar_size < 3 then
    self.x_bar_size = 3
  end

  self.agui_widget.dirty = true
end
