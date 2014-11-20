--- Container Widget.
-- @parent veek-widget
-- @widget veek-container

-- lint-mode: veek-widget

_parent = 'veek-widget'

local function in_widget(x, y, widget)
  local x2, y2 = widget.x + widget.width, widget.y + widget.height

  x2, y2 = x2 - 1, y2 - 1

  return (x >= widget.x and y >= widget.y and x <= x2 and y <= y2)
end

--- Initalises an veek-container.
-- @int x The X position to be in.
-- @int y The Y Position ot be in.
-- @int width The container's width.
-- @int height The container's height.
function Widget:init(x, y, width, height)
  self.veek_widget:init(x, y, width, height)

  self.children = {}

  self.cur_focus = 0

  self.veek_widget.fg = 'container-fg'
  self.veek_widget.bg = 'container-bg'

  self.veek_widget:add_flag('active')
end

--- Adds a widget to the container.
-- @tparam veek-widget child The widget to add.
-- @raise Invalid Widget
function Widget:add(child)
  if not child:is_a('veek-widget') then
    error('Invalid Widget', 2)
  end

  child:cast('veek-widget').main = self.veek_widget.main

  table.insert(self.children, child)
end


--- Removes the given widget from the container.
-- @tparam veek-widget child The widget to remove.
function Widget:remove(child)
  if type(child) == "number" then
    table.remove(self.children, child)
    return
  end

  for c, wid in ipairs(self.children) do
    if wid:cast('veek-widget').id == child:cast('veek-widget').id then
      table.remove(self.children, c)
      return
    end
  end
end

--- Sets the given widget to be the active one.
-- @tparam veek-widget child The widget to set active-ness.
function Widget:select(child)
  if not child then
    return
  end

  if self:get_focus() then
    if self:get_focus():cast('veek-widget').id == child:cast('veek-widget').id then
      -- Shortcut to avoid bluring an already-selected widget.
      return
    end

    self:get_focus():blur()
  end

  -- for i, c in ipairs(self.children) do
  -- 	if c.veek_widget.id == child.veek_widget.id then
  -- 		self.cur_focus = i
  -- 	end
  -- end

  self:remove(child)
  self:add(child)
  self.cur_focus = #self.children

  if self:get_focus() then
    self:get_focus():focus()
  end
end

function Widget:draw(pc, theme)
  pc:clear()

  self:draw_children(pc, theme)
end

function Widget:draw_children(canvas, theme)
  for i, widget in ipairs(self.children) do
    if i ~= self.cur_focus then
      self.veek_widget:draw_raw(widget, canvas, theme)
    end
  end

  if self:get_focus() then
    self.veek_widget:draw_raw(self:get_focus(), canvas, theme)
  end
end

-- This is a massive hack, but I don't particularly care! :D

function Widget:blur()
  if self:get_focus() then
    self:get_focus():blur()
  end
end

--- Focuses the next widget.
-- @treturn bool true if there was a focus change, false otherwise.
function Widget:focus_next()
  if #self.children == 0 then
    return false
  end

  if self:get_focus() then
    self:get_focus():blur()
  end

  self.veek_widget.dirty = true

  local found = 0

  local start = self.cur_focus

  while found < 2 do
    self.cur_focus = self.cur_focus + 1

    if self.cur_focus > #self.children then
      self.cur_focus = 1

      found = 1 + found
    end

    if self:get_focus():cast('veek-widget'):has_flag('active')
      and self:get_focus():cast('veek-widget').enabled
    and self.cur_focus ~= start then
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

function Widget:get_focus()
  if self:_get_focus() then
    self:_get_focus():cast('veek-widget').main = self.veek_widget.main

    return self:_get_focus()
  end
end

function Widget:_get_focus()
  return self.children[self.cur_focus]
end

function Widget:focus()
  self.cur_focus = 0
  self:focus_next()
end

function Widget:key(k)
  if self:get_focus() and self:get_focus():key(k) then
    return true
  elseif k == keys.tab and self:focus_next() then
    return true
  else
    return false
  end
end

function Widget:char(ch)
  if self:get_focus() then
    self:get_focus():char(ch)
  end
end

function Widget:clicked(x, y, button)
  if self:get_focus() and in_widget(x, y, self:get_focus():cast('veek-widget')) then
    local child = self:get_focus()

    if child:has_flag("active") then
      self:get_focus():clicked(x - child:cast('veek-widget').x + 1, y - child:cast('veek-widget').y + 1, button)

      return
    end
  end

  for _, child in ipairs(self.children) do
    if in_widget(x, y, child:cast('veek-widget')) then
      if child:has_flag("active") then
	self:select(child)

	child:clicked(x - child:cast('veek-widget').x + 1, y - child:cast('veek-widget').y + 1, button)

	return
      end
    end
  end
end

function Widget:scroll(x, y, dir)
  if self:get_focus() and in_widget(x, y, self:get_focus():cast('veek-widget')) then
    local child = self:get_focus()

    if child:has_flag("active") then
      self:get_focus():scroll(x - child.veek_widget.x + 1, y - child.veek_widget.y + 1, dir)

      return
    end
  end

  for _, child in ipairs(self.children) do
    if in_widget(x, y, child:cast('veek-widget')) then
      if child:has_flag("active") then
	self:select(child)

	child:scroll(x - child:cast('veek-widget').x + 1, y - child:cast('veek-widget').y + 1, dir)
      end
    end
  end
end

function Widget:dragged(x_del, y_del, button)
  if self:get_focus() then
    self:get_focus():dragged(x_del, y_del, button)
  end
end
