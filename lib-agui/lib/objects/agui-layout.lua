-- Layout engine for agui.
-- Supports anchors and stuff.

_parent = 'object'

function Object:init(container)
  if container:is_a('agui-app-window') then
    container = container:cast('agui-app-window').gooey
  end
  
  self.container = container

  self.anchors = {}
  self.widgets = {}
  self.deps = {}
end

function Object:remove(widget)
  self.container:remove(widget)

  self.anchors[widget:cast('agui-widget').id] = nil
  self.widgets[widget:cast('agui-widget').id] = nil
  self.deps[widget:cast('agui-widget').id] = nil
end

function Object:add(widget)
  self.anchors[widget:cast('agui-widget').id] = {}
  self.deps[widget:cast('agui-widget').id] = {}
  self.widgets[widget:cast('agui-widget').id] = widget

  self.container:add(widget)
end

function Object:add_anchor(id, side, other_side, other, dist)
  if type(id) == 'table' and id.is_a and id:is_a('agui-widget') then
    id = id:cast('agui-widget').id
  end

  if type(other) == 'table' and other.is_a and other:is_a('agui-widget') then
    other = other:cast('agui-widget').id
  end

  if other == nil or id == nil then
    error('Other and id must not be nil', 2)
  end

  if other ~= -1 then
    table.insert(self.deps[id], other)
  end

  table.insert(self.anchors[id], { side, other_side, other, dist })
end

function Object:reflow()
  self.done = {}

  for id, widget in pairs(self.widgets) do
    self:_reflow_obj(id, widget)
  end
end

function Object:_reflow_obj(id, widget)
  if self.done[id] then
    return
  end

  self.done[id] = true

  for _, dep in ipairs(self.deps[id]) do
    self:_reflow_obj(dep, self.widgets[dep])
  end

  for _, anchor in ipairs(self.anchors[id]) do
    local meth = '_anchor_' .. anchor[1] .. '_' .. anchor[2]

    if self[meth] then
      self[meth](self, widget, anchor[3], anchor[4])
    else
      error("Invalid Anchor: " .. meth, 3)
    end
  end
end

function Object:get(obj, dir)
  if obj == -1 then
    if dir == 'left' then
      return 1
    elseif dir == 'right' or dir == 'width' then
      -- Haaack
      if self.container:is_a('agui-window') then
        return self.container.agui_widget.width - 2
      end

      return self.container.agui_widget.width
    elseif dir == 'top' then
      return 1
    elseif dir == 'bottom' or dir == 'height' then
      -- Haaack
      if self.container:is_a('agui-window') then
        return self.container.agui_widget.height - 2
      end

      return self.container.agui_widget.height
    end
  end

  local widget = self.widgets[obj]

  if dir == 'left' then
    return widget:cast('agui-widget').x
  elseif dir == 'right' then
    return widget:cast('agui-widget').x + widget:cast('agui-widget').width
  elseif dir == 'top' then
    return widget:cast('agui-widget').y
  elseif dir == 'bottom' then
    return widget:cast('agui-widget').y + widget:cast('agui-widget').height
  elseif dir == 'width' then
    return widget:cast('agui-widget').width
  elseif dir == 'height' then
    return widget:cast('agui-widget').height
  end

  return 0
end

-- Top Anchor

function Object:_anchor_top_top(widget, other, dist)
  widget:cast('agui-widget').y = self:get(other, 'top') + dist
end

function Object:_anchor_top_bottom(widget, other, dist)
  widget:cast('agui-widget').y = self:get(other, 'bottom') + dist
end

function Object:_anchor_top_middle(widget, other, dist)
  widget:cast('agui-widget').y = math.floor((self:get(other, 'bottom') - self:get(other, 'top')) / 2) - dist
end

-- Left Anchors

function Object:_anchor_left_left(widget, other, dist)
  widget:cast('agui-widget').x = self:get(other, 'left') + dist
end

function Object:_anchor_left_right(widget, other, dist)
  widget:cast('agui-widget').x = self:get(other, 'right') + dist
end


function Object:_anchor_left_middle(widget, other, dist)
  widget:cast('agui-widget').x = math.floor(self:get(other, 'width') / 2) - math.floor(widget:cast('agui-widget').width / 2) + dist
end

-- Right Anchors

function Object:_anchor_right_right(widget, other, dist)
  widget:cast('agui-widget').width = self:get(other, 'right') - widget:cast('agui-widget').x - dist + 1
end

function Object:_anchor_right_left(widget, other, dist)
  widget:cast('agui-widget').width = widget:cast('agui-widget').x + self:get(other, 'left') + dist
end

function Object:_anchor_right_middle(widget, other, dist)
  widget:cast('agui-widget').width = math.floor((self:get(other, 'right') - self:get(other, 'left')) / 2) - dist
end

-- Bottom Anchors

function Object:_anchor_bottom_top(widget, other, dist)
  widget:cast('agui-widget').height = self:get(other, 'top') - widget:cast('agui-widget').y - dist + 1
end

function Object:_anchor_bottom_bottom(widget, other, dist)
  widget:cast('agui-widget').height = self:get(other, 'bottom') - widget:cast('agui-widget').y + dist
end

function Object:_anchor_bottom_middle(widget, other, dist)
  widget:cast('agui-widget').height = math.floor(self:get(other, 'height') / 2) + dist
end
