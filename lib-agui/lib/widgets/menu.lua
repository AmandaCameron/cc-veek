_parent = "agui-widget"

function Widget:init(parent, width)
  self.agui_widget:init(1, 1, width or 10, 1)

  self.agui_widget:add_flag('active')

  if parent:is_a("agui-container") then
    self.parent = parent:cast('agui-container')
  elseif parent:is_a("agui-app") then
    self.parent = parent:cast('agui-app').main_window.gooey
  elseif parent:is_a('agui-app-window') then
    self.parent = parent:cast('agui-app-window').gooey
  end

  self.visible = false

  self:clear()
end

-- The API of APIitude

function Widget:clear()
  self.selected = 0
  self.items = {}
end

function Widget:add(label, func)
  if #label > self.agui_widget.width then
    self.agui_widget.width = #label + 2
  end

  table.insert(self.items, { "option", label, func })
end

function Widget:add_seperator()
  table.insert(self.items, { "seperator" })
end

function Widget:show(x, y)
  self.visible = true

  if x > self.parent.agui_widget.width - self.agui_widget.width then
    x = x - self.agui_widget.width
  end

  if y > self.parent.agui_widget.height - #self.items then
    y = y - #self.items
  end

  self.agui_widget.y = y
  self.agui_widget.x = x


  self.agui_widget.height = #self.items

  self.prev = self.parent:get_focus()

  self.parent:add(self)
  self.parent:select(self)
end

function Widget:hide()
  self.visible = false

  self.parent:remove(self)

  self.parent:select(self.prev)
end

-- The Actual impmlementation

function Widget:blur()
  self:hide()
end

function Widget:focus()
  self.selected = 1
end

function Widget:draw(c, t)
  c:clear()

  for i, item in ipairs(self.items) do
    if i == self.selected then
      c:set_fg("menuitem-selected-fg")
      c:set_bg("menuitem-selected-bg")
    else
      c:set_fg("menuitem-fg")
      c:set_bg("menuitem-bg")
    end

    c:move(1, i)

    if item[1] == "option" then
      local text = item[2]

      if i == self.selected then
        text = ">" .. text .. "<"
      end

      if #text < self.agui_widget.width then
        local padding = string.rep(" ", math.floor((self.agui_widget.width - #text) / 2))
        text = padding .. text
      end

      c:write(text)

      c:write(string.rep(" ", self.agui_widget.width - #text))
    elseif item[1] == "seperator" then
      c:write(" " .. string.rep("-", self.agui_widget.width - 2) .. " ")
    else
      error("Invalid menu spec!")
    end
  end
end

function Widget:clicked(x, y, btn)
  if self.items[y] and self.items[y][1] == "option" then
    self.items[y][3]()
  end
end

function Widget:key(key)
  if key == keys.up then
    self.selected = self.selected - 1

    if self.selected <= 0 then
      self.selected = #self.items
    end

    while self.items[self.selected][1] ~= "option" do
      if self.selected < 0 then
        self.selected = #self.items
      end

      self.selected = self.selected - 1
    end

    return true
  elseif key == keys.down then
    self.selected = self.selected + 1

    if self.selected > #self.items then
      self.selected = 1
    end

    while self.items[self.selected][1] ~= "option" do
      if self.selected > #self.items then
        self.selected = 1
      end

      self.selected = self.selected + 1
    end

    return true
  elseif key == keys.enter then
    if self.items[self.selected] then
      self.items[self.selected][3]()
    end

    return true
  end

  return false
end
