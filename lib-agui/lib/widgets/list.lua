--- List Widget.
-- This shows a collection of agui-list-item's, and allows the user to scroll through them.
-- @parent agui-scroll-view
-- @classmod agui-list

-- lint-mode: veek-widget

_parent = 'agui-scroll-view'

--- Initalises the list view.
-- @int x The X position to draw in.
-- @int y The Y position to draw in.
-- @int width The list's width.
-- @int height The list's height.
function Widget:init(x, y, width, height)
	self.agui_scroll_view:init(width, height)

	self.items = {}
	self.current_item = 0

	self.agui_widget.fg = 'list--fg'
	self.agui_widget.bg = 'list--bg'

	self.agui_scroll_view.draw_contents = function(c)
		self:draw_contents(c)
	end

	self.agui_scroll_view.get_size = function()
		return self:get_size()
	end
end

-- Scrollable stuff.

function Widget:get_size()
	local height = 0

	for _, item in ipairs(self.items) do
		height = height + item:cast('agui-widget').height
	end

	return self.agui_widget.width, height
end

-- Helpers.

function Widget:mark_dirty()
	self.agui_widget.dirty = true

	for _, item in ipairs(self.items) do
		item.agui_widget.dirty = true
	end
end

-- List Manupulation

--- Clear the list's items.
function Widget:clear()
	self.current_item = 0
	self.items = {}

	self:reflow()
end

--- Add a list item.
-- @tparam agui-list-item item The `agui-list-item` to add.
-- @tparam int|nil pos The position in the list to add the item.
function Widget:add(item, pos)
	if item._type ~= 'agui-list-item' and not item.agui_list_item then
		error('Invalid List Item.', 2)
	end

	if pos ~= nil then
		table.insert(self.items, pos, item)
	else
		table.insert(self.items, item)
	end

	if self.current_item == 0 then
		self.current_item = #self.items
		self:get_current():focus()
	end

	self:reflow()
end

--- Remove a list item
-- @tparam int item The item to remove.
function Widget:remove(item)
	table.remove(self.items, item)

	self:reflow()
end

-- Manupulation of state

function Widget:move_up()
	if #self.items == 0 then
		return
	end

	if self:get_current() then
		self:get_current():blur()
	end

	self.current_item = self.current_item - 1

	if self.current_item < 1 then
		self.current_item = #self.items
	end

	self:scroll_into_view(0, self:get_current():cast('agui-widget').y - 1)

	self:get_current():focus()

	self.agui_widget:trigger('gui.list.changed', self.current_item, self:get_current())
end

function Widget:move_down()
	if #self.items == 0 then
		return
	end

	if self:get_current() then
		self:get_current():blur()
	end

	self.current_item = self.current_item + 1

	if self.current_item > #self.items then
		self.current_item = 1
	end

	self:scroll_into_view(0, self:get_current():cast('agui-widget').y - 1)

	self:get_current():focus()

	self.agui_widget:trigger('gui.list.changed', self.current_item, self:get_current())
end


-- Lookup of State

--- Gets the currently-selected item.
-- @treturn agui-list-item|nil The item that is currently selected, or nil
function Widget:get_current()
	return self.items[self.current_item]
end

-- Main Loop Callbacks.

function Widget:focus()
	self.agui_widget:focus()

	self:mark_dirty()

	if self:get_current() then
		self:get_current():focus()
	end
end

function Widget:blur()
	self.agui_widget:blur()

	self:mark_dirty()
end

function Widget:key(k)
	if k == keys.up then
		self:move_up()

		return true
	elseif k == keys.down then
		self:move_down()

		return true
	elseif self.agui_scroll_view:key(k) then

		return true
	elseif self:get_current() then

		return self:get_current():key(k)
	end

	return false
end

function Widget:reflow()
	local y = 1

	for _, item in ipairs(self.items) do
		item.agui_widget.width = self.agui_widget.width
		item.agui_widget.x = 1
		item.agui_widget.y = y

		y = y + item.agui_widget.height
	end

	self.agui_scroll_view:reflow()
end

function Widget:resize(w, h)
	self.agui_widget:resize(w, h)

	self:reflow()
end

function Widget:draw_contents(c)
	for n, item in ipairs(self.items) do
		if n ~= self.current_item then
			self:draw_raw(item, c)
		end
	end

	if self:get_current() then
		self:draw_raw(self:get_current(), c)
	end
end
