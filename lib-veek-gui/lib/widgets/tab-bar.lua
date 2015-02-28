--- Tab Bar Widget.
-- This displays a set of containers in a way that only one of them is visible
-- at a time.
-- @parent veek-widget
-- @widget veek-tab-bar

-- lint-mode: veek-widget

_parent = 'veek-widget'

--- Initialise an veek-tab-bar
-- @int x The X position to begin at.
-- @int y The Y position to begin at.
-- @int w The widget's width.
-- @int h The widget's height.
function Widget:init(x, y, w, h)
  self.veek_widget:init(x, y, w, h)

  self.veek_widget:add_flag('active')

  self.tabs = {}
  self.selected = 0

  self.show_options = false
  self.style = 'horiz'

  if pocket then
    self.style = 'drop-down'
  end
end


--- Adds a tab to the controller.
-- @string label The label for the tab.
-- @tparam veek-widget contents The thing to show.
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

  self.veek_widget.dirty = true
end

-- Utilities.

function Widget:get_contents()
  local c = self:_get_contents()

  if c then
    c.veek_widget.main = self.veek_widget.main
  end

  return c
end

function Widget:_get_contents()
  return self.tabs[self.selected].contents
end

-- Events

function Widget:focus()
  self.veek_widget:focus()

  self:get_contents():focus()
end

function Widget:blur()
  self.veek_widget:blur()

  return self:get_contents():blur()
end

function Widget:draw(canvas, theme)
  if self.selected > 0 then
    local contents = self:get_contents()

    contents.veek_widget.x = 1
    contents.veek_widget.y = 2
    contents.veek_widget.width = canvas.width
    contents.veek_widget.height = canvas.height - 1

    self:draw_raw(contents, canvas, theme)
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

      if self.veek_widget.focused then
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

    if self.veek_widget.focused then
      canvas:set_bg("tab-focused-active-bg")
      canvas:set_fg("tab-focused-active-fg")
    else
      canvas:set_bg("tab-active-bg")
      canvas:set_fg("tab-active-fg")
    end

    canvas:move(1, 1)

    canvas:write(label)
    canvas:write(string.rep(' ', canvas.width - #label))
  end

  return canvas:sub(1, 2, canvas.width, canvas.height - 1)
end

function Widget:draw_horiz(canvas)
  local lblWidth = self:get_tab_width()

  canvas:move(1, 1)

  for name, tab in ipairs(self.tabs) do
    local label = tab.label

    if #label > lblWidth - 2 then
      label = label:sub(0, lblWidth-5) .. "..."
    end

    if self.show_options and name == self.selected then
      label = "{" .. label .. "}"
    end

    if #label < lblWidth then
      local padding = math.floor((lblWidth - #label) / 2)
      label = string.rep(" ", padding) .. label .. string.rep(" ", padding)
    end

    if self.veek_widget.focused then
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
      if y <= #self.tabs then
        self:select_tab(y)
      end

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
  elseif key == keys.pageDown or ((key == keys.right or key == keys.down) and self.show_options) then
    self.selected = self.selected + 1
    if self.selected > #self.tabs then
      self.selected = 1
    end

    return true
  elseif key == keys.pageUp  or ((key == keys.left or key == keys.up) and self.show_options)then
    self.selected = self.selected - 1
    if self.selected <= 0 then
      self.selected = #self.tabs
    end

    return true
  elseif key == keys.enter and self.show_options then
    self.show_options = false

    return true
  elseif key == keys.leftCtrl or key == keys.rightCtrl then
    self.show_options = true

    return true
  else
    return false
  end
end

-- Utilities.

function Widget:get_tab_width()
  local lblWidth = 10

  if (lblWidth * #self.tabs) > self.veek_widget.width then
    lblWidth = math.floor(self.veek_widget.width / #self.tabs)
  else
    lblWidth = math.floor(self.veek_widget.width / #self.tabs)
  end

  return lblWidth
end
