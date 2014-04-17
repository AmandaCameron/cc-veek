-- A simple tab-bar container.
-- Right now it's hard-coded to use a single-line tab bar,
-- that may change in the future.


-- This is a kinda special widget. It should probably decend
-- from container, but I'm not sure yet about that.
_parent = 'agui-widget'

function Widget:init(x, y, w, h)
  self.agui_widget:init(x, y, w, h)

  self.agui_widget:add_flag('active')

  self.tabs = {}
  self.selected = 0

  self.show_options = false
  self.style = 'horiz'

  if pocket then
    self.style = 'drop-down'
  end
end

function Widget:add_tab(label, contents)
  table.insert(self.tabs, {
    label=label,
    contents=contents,
  })

  if self.selected == 0 then
    self:select_tab(#self.tabs)
  end
end

function Widget:select_tab(name)
  self.selected = name

  self.agui_widget.dirty = true
end

-- Utilities.

function Widget:get_contents()
  local c = self:_get_contents()

  if c then
    c.agui_widget.main = self.agui_widget.main
  end

  return c
end

function Widget:_get_contents()
  return self.tabs[self.selected].contents
end

-- Events

function Widget:focus()
  self.agui_widget:focus()

  self:get_contents():focus()
end

function Widget:blur()
  self.agui_widget:blur()

  return self:get_contents():blur()
end

function Widget:draw(canvas, theme)
  if self.selected > 0 then
    local c = canvas:sub(1, 2, canvas.width, canvas.height - 1)

    local contents = self:get_contents()

    contents.agui_widget.x = 1
    contents.agui_widget.y = 1
    contents.agui_widget.width = c.width
    contents.agui_widget.height = c.height

    self:draw_raw(contents, c, theme)
  end

  if self.style == 'horiz' then
    self:draw_horiz(canvas)
  elseif self.style == 'drop-down' then
    self:draw_drop_down(canvas)
  end
end

function Widget:draw_drop_down(canvas)
  if self.show_options or self.selected == 0 then
    for n, tab in ipairs(self.tabs) do
      local label = tab.label

      if #label > canvas.width then
        label = label:sub(0, canvas.width - 3) .. "..."
      end

      if self.agui_widget.focused then
        if n == self.selected then
          canvas:set_bg("tab-focused-active-bg")
          canvas:set_fg("tab-focused-active-fg")
        else
          canvas:set_bg("tab-focused-inactive-bg")
          canvas:set_fg("tab-foucsed-inactive-fg")
        end
      else
        if n == self.selected then
          canvas:set_bg("tab-active-bg")
          canvas:set_fg("tab-active-fg")
        else
          canvas:set_bg("tab-inactive-bg")
          canvas:set_fg("tab-inactive-fg")
        end
      end

      canvas:move(1, n)
      canvas:write(label)
      canvas:write(string.rep(' ', canvas.width - #label))
    end
  else
    local tab = self.tabs[self.selected]
    local label = tab.label

    if #label > canvas.width then
      label = label:sub(0, canvas.width - 3) .. "..."
    end

    if self.agui_widget.focused then
      canvas:set_bg("tab-focused-active-bg")
      canvas:set_fg("tab-focused-active-fg")
    else
      canvas:set_bg("tab-active-bg")
      canvas:set_fg("tab-active-fg")
    end
    canvas:set_fg()

    canvas:move(1, 1)

    canvas:write(label)
    canvas:write(string.rep(' ', canvas.width - #label))
  end

  return canvas:sub(1, 2, canvas.width, canvas.height - 1)
end

function Widget:draw_horiz(canvas)
  local lblWidth = self:get_tab_width()

  for name, tab in ipairs(self.tabs) do
    local label = tab.label
    
    if #label > lblWidth then
      label = label:sub(0, lblWidth-3) .. "..."
    end

    if #label < lblWidth then
      local padding = math.floor((lblWidth - #label) / 2)
      label = string.rep(" ", padding) .. label .. string.rep(" ", padding)
    end

    if self.agui_widget.focused then
      if name == self.selected then
        canvas:set_bg("tab-focused-active-bg")
        canvas:set_fg("tab-focused-active-fg")
      else
        canvas:set_bg("tab-focused-inactive-bg")
        canvas:set_fg("tab-foucsed-inactive-fg")
      end
    else
      if name == self.selected then
        canvas:set_bg("tab-active-bg")
        canvas:set_fg("tab-active-fg")
      else
        canvas:set_bg("tab-inactive-bg")
        canvas:set_fg("tab-inactive-fg")
      end
    end

    canvas:write(label)
  end

  canvas:write(string.rep(" ", canvas.width - canvas.x + 1))

  return canvas:sub(1, 2, canvas.width, canvas.height - 1)
end

function Widget:clicked(x, y, button)
  if self.style == 'horiz' then
    if y == 1 then
      self:select_tab(math.floor(x / self:get_tab_width()) + 1)
    elseif self.selected > 0 then
      self:get_contents():clicked(x, y - 1, button)
    end
  elseif self.style == 'drop-down' then
    if self.show_options then
      self:select_tab(y)

      self.show_options = false
    elseif y == 1 then
      self.show_options = true
    else
      self:get_contents():clicked(x, y - 1, button)
    end
  end
end

function Widget:key(key)
  if self.selected > 0 and self:get_contents():key(key) then
    return true
  elseif key == keys.pageDown then
    self.selected = self.selected + 1
    if self.selected > #self.tabs then
      self.selected = 1
    end
  elseif key == keys.pageUp then
    self.selected = self.selected - 1
    if self.selected <= 0 then
      self.selected = #self.tabs
    end
  else
    return false
  end
end

-- Utilities.

function Widget:get_tab_width()
  local lblWidth = 10

  if (lblWidth * #self.tabs) > self.agui_widget.width then
    lblWidth = math.floor(self.agui_widget.width / #self.tabs)
  else
    lblWidth = math.floor(self.agui_widget.width / #self.tabs)
  end

  return lblWidth
end
