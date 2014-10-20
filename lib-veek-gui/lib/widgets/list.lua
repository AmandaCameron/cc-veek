--- List Widget.
-- This shows a collection of veek-list-item's, and allows the user to scroll through them.
-- @parent veek-scroll-view
-- @classmod veek-list

--- Selection Changed.
-- This is fired when the user changes the currently-selected item.
-- @event gui.list.changed
-- @int index The index of the now-selected item.
-- @tparam veek-list-item item The item that is now selected.
local sel_changed = {}

-- lint-mode: veek-widget

_parent = 'veek-scroll-view'

--- Initalises the list view.
-- @int x The X position to draw in.
-- @int y The Y position to draw in.
-- @int width The list's width.
-- @int height The list's height.
function Widget:init(x, y, width, height)
	self.veek_scroll_view:init(width, height)

	self.items = {}
	self.current_item = 0

	self.item_pos = {}

	self.veek_widget.fg = 'list--fg'
	self.veek_widget.bg = 'list--bg'

	self.veek_scroll_view.draw_contents = function(c)
		self:draw_contents(c)
	end

	self.veek_scroll_view.get_size = function()
		return self:get_size()
	end
end

-- Scrollable stuff.

function Widget:get_size()
	local height = 0

	for _, item in ipairs(self.items) do
		height = height + item:cast('veek-widget').height
	end

	return self.veek_widget.width, height
end

-- Helpers.

function Widget:mark_dirty()
	self.veek_widget.dirty = true

	for _, item in ipairs(self.items) do
		item.veek_widget.dirty = true
	end
end

-- List Manupulation

--- Clear the list's items.
function Widget:clear()
	self.current_item = 0
	self.items = {}
	self.item_pos = {}

	self:reflow()
end

--- Add a list item.
-- @tparam veek-list-item item The `veek-list-item` to add.
-- @tparam int|nil pos The position in the list to add the item.
function Widget:add(item, pos)
	if not item:is_a('veek-list-item') then
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

	self:scroll_into_view(0, self:get_current():cast('veek-widget').y - 1)

	self:get_current():focus()

	self.veek_widget:trigger('gui.list.changed', self.current_item, self:get_current())
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

	self:scroll_into_view(0, self:get_current():cast('veek-widget').y - 1)

	self:get_current():focus()

	self.veek_widget:trigger('gui.list.changed', self.current_item, self:get_current())
end


-- Lookup of State

--- Gets the currently-selected item.
-- @treturn veek-list-item|nil The item that is currently selected, or nil
function Widget:get_current()
	return self.items[self.current_item]
end

-- Main Loop Callbacks.

function Widget:focus()
	self.veek_widget:focus()

	self:mark_dirty()

	if self:get_current() then
		self:get_current():focus()
	end
end

function Widget:blur()
	self.veek_widget:blur()

	self:mark_dirty()
end

function Widget:key(k)
	if k == keys.up then
		self:move_up()

		return true
	elseif k == keys.down then
		self:move_down()

		return true
	elseif self.veek_scroll_view:key(k) then

		return true
	elseif self:get_current() then

		return self:get_current():key(k)
	end

	return false
end

function Widget:reflow()
	local y = 1

	self.item_pos = {}

	for i, item in ipairs(self.items) do
		item.veek_widget.width = self.veek_widget.width
		item.veek_widget.x = 1
		item.veek_widget.y = y

		item.pos = i

		for pos=y,y+item.veek_widget.height do
			self.item_pos[pos] = item
		end

		y = y + item.veek_widget.height
	end

	self.veek_scroll_view:reflow()
end

function Widget:clicked(x, y, btn)
	local y = y + self.veek_scroll_view.scroll_y

	if self:get_current() then
		self:get_current():blur()
	end

	if self.item_pos[y] then
		self.current_item = self.item_pos[y].pos

		self.item_pos[y]:clicked(x, y - self.item_pos[y]:cast('veek-widget').y, btn)

		self:get_current():focus()

		self.veek_widget:trigger('gui.list.changed', self.current_item, self:get_current())

		self:mark_dirty()
	end
end

function Widget:resize(w, h)
	self.veek_widget:resize(w, h)

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
