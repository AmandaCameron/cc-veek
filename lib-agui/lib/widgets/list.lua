-- List Widget! It's what's for dinner!

-- Previously this inherited from container, but that prooved far too problemattic.
_parent = 'agui-widget'

function Widget:init(x, y, width, height)
	self.agui_widget:init(x, y, width, height)

	self.offset = 0

	self.items = {}
	self.current_item = 0

	self.agui_widget:add_flag('active')

	self.agui_widget.bg = 'list--bg'
	self.agui_widget.fg = 'list--fg'
end

-- Helpers.

function Widget:mark_dirty()
	for _, item in ipairs(self.items) do
		item.agui_widget.dirty = true
	end
end

-- List Manupulation

function Widget:clear()
	self.current_item = 0
	self.items = {}
end

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
end

function Widget:remove(item)
	table.remove(self.items, item)
end

-- Manupulation of state

function Widget:scroll_up()
	self.offset = math.min(0, self.offset - math.floor(self.agui_widget.height / 3))
end

function Widget:scroll_down()
	self.offset = math.max(self.agui_widget.height - math.floor(self.agui_widget.height / 3) - 1,
		self.offset + math.floor(self.agui_widget.height / 3))
end

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

		self.offset = math.max(#self.items - self.agui_widget.height, 0)
	end

	if self.current_item - self.offset <= 0 then
		self:scroll_up()
	end

	self:get_current():focus()
	
	self:trigger('gui.list.changed', self.current_item, self:get_current())
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

		self.offset = 0
	end

	if (self.current_item * self:get_current().agui_widget.height) - self.offset > self.agui_widget.height then
		self:scroll_down()
	end

	self:get_current():focus()

	self:trigger('gui.list.changed', self.current_item, self:get_current())
end


-- Lookup of State

function Widget:get_current()
	return self.items[self.current_item]
end

-- Main Loop Callbacks.

function Widget:focus()
	self.agui_widget:focus()

	self:mark_dirty ()

	if self:get_current() then
		self:get_current():focus()
	end
end

function Widget:blur()
	self.agui_widget:blur()

	self:mark_dirty()
end

function Widget:key(k)
	if k == keys.pageUp then
		self:scroll_up()
	elseif k == keys.pageDown then
		self:scroll_down()
	elseif k == keys.up then
		self:move_up()
	elseif k == keys.down then
		self:move_down()
	elseif self:get_current() then
		self:get_current():key(k)
	end
end

function Widget:draw(c, theme)
	c:clear()

	c:translate(0, 0 - self.offset)

	local y = 1

	for n, item in ipairs(self.items) do
		item.agui_widget.width = self.agui_widget.width
		item.agui_widget.x = 1
		item.agui_widget.y = y

		y = y + item.agui_widget.height

		if n ~= self.current_item then
			self:draw_raw(item, c, theme)
		end
	end

	if self:get_current() then
		self:draw_raw(self:get_current(), c, theme)
	end
end
