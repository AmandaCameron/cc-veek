--- Layout Engine.
-- @classmod veek-layout

-- lint-mode: veek-object

_parent = 'object'

--- Initialises an veek-layout.
-- @tparam veek-app-window|veek-container container The contains this layout acts on.
function Object:init(container)
  if container:is_a('veek-app-window') then
    container = container:cast('veek-app-window').gooey
  end

  self.container = container

  self.anchors = {}
  self.widgets = {}
  self.deps = {}
end

--- Removes the given widget and it's constraints from the veek-layout.
-- @tparam veek-widget widget The widget to remove.
function Object:remove(widget)
  self.container:remove(widget)

  self.anchors[widget:cast('veek-widget').id] = nil
  self.widgets[widget:cast('veek-widget').id] = nil
  self.deps[widget:cast('veek-widget').id] = nil
end

--- Add the given widget to the layout.
-- @tparam veek-widget widget The widget to add.
function Object:add(widget)
  self.anchors[widget:cast('veek-widget').id] = {}
  self.deps[widget:cast('veek-widget').id] = {}
  self.widgets[widget:cast('veek-widget').id] = widget

  self.container:add(widget)
end

--- Adds an anchor to the layout.
-- Anchors are made up of two side paramaters.
-- They can be one of top, bottom, left, right and how they are joined depends
-- on how they are implemented.
-- @tparam veek-widget|int id The widget this constraint will act on.
-- @tparam side side The side this constraint will act on for.
-- @tparam side other_side The side this will anchor to.
-- @tparam veek-widget|int other The widget to anchor to.
-- @tparam int dist The distance to anchor from.
function Object:add_anchor(id, side, other_side, other, dist)
  if type(id) == 'table' and id.is_a and id:is_a('veek-widget') then
    id = id:cast('veek-widget').id
  end

  if type(other) == 'table' and other.is_a and other:is_a('veek-widget') then
    other = other:cast('veek-widget').id
  end

  if other == nil or id == nil then
    error('Other and id must not be nil', 2)
  end

  if other ~= -1 then
    table.insert(self.deps[id], other)
  end

  table.insert(self.anchors[id], { side, other_side, other, dist })
end

--- Reflows the layout of the widget.
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
      if self.container:is_a('veek-window') then
        return self.container.veek_widget.width - 2
      end

      return self.container.veek_widget.width
    elseif dir == 'top' then
      return 1
    elseif dir == 'bottom' or dir == 'height' then
      -- Haaack
      if self.container:is_a('veek-window') then
        return self.container.veek_widget.height - 2
      end

      return self.container.veek_widget.height
    end
  end

  local widget = self.widgets[obj]

  if dir == 'left' then
    return widget:cast('veek-widget').x
  elseif dir == 'right' then
    return widget:cast('veek-widget').x + widget:cast('veek-widget').width
  elseif dir == 'top' then
    return widget:cast('veek-widget').y
  elseif dir == 'bottom' then
    return widget:cast('veek-widget').y + widget:cast('veek-widget').height
  elseif dir == 'width' then
    return widget:cast('veek-widget').width
  elseif dir == 'height' then
    return widget:cast('veek-widget').height
  end

  return 0
end

-- Top Anchor

function Object:_anchor_top_top(widget, other, dist)
  widget:cast('veek-widget').y = self:get(other, 'top') + dist
end

function Object:_anchor_top_bottom(widget, other, dist)
  widget:cast('veek-widget').y = self:get(other, 'bottom') + dist
end

function Object:_anchor_top_middle(widget, other, dist)
  widget:cast('veek-widget').y = math.floor((self:get(other, 'bottom') - self:get(other, 'top')) / 2) - dist
end

-- Left Anchors

function Object:_anchor_left_left(widget, other, dist)
  widget:cast('veek-widget').x = self:get(other, 'left') + dist
end

function Object:_anchor_left_right(widget, other, dist)
  widget:cast('veek-widget').x = self:get(other, 'right') + dist
end


function Object:_anchor_left_middle(widget, other, dist)
  widget:cast('veek-widget').x = math.floor(self:get(other, 'width') / 2) - math.floor(widget:cast('veek-widget').width / 2) + dist
end

-- Right Anchors

function Object:_anchor_right_right(widget, other, dist)
  widget:cast('veek-widget').width = self:get(other, 'right') - widget:cast('veek-widget').x - dist + 1
end

function Object:_anchor_right_left(widget, other, dist)
  widget:cast('veek-widget').width = widget:cast('veek-widget').x + self:get(other, 'left') + dist
end

function Object:_anchor_right_middle(widget, other, dist)
  widget:cast('veek-widget').width = math.floor((self:get(other, 'right') - self:get(other, 'left')) / 2) - dist
end

-- Bottom Anchors

function Object:_anchor_bottom_top(widget, other, dist)
  widget:cast('veek-widget').height = self:get(other, 'top') - widget:cast('veek-widget').y - dist + 1
end

function Object:_anchor_bottom_bottom(widget, other, dist)
  widget:cast('veek-widget').height = self:get(other, 'bottom') - widget:cast('veek-widget').y + dist
end

function Object:_anchor_bottom_middle(widget, other, dist)
  widget:cast('veek-widget').height = math.floor(self:get(other, 'height') / 2) + dist
end
