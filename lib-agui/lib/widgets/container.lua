_parent = 'agui-widget'

local function in_widget(x, y, widget)
	local x2, y2 = widget.x + widget.width, widget.y + widget.height

	x2, y2 = x2 - 1, y2 - 1

	return (x >= widget.x and y >= widget.y and x <= x2 and y <= y2)
end


function Widget:init(x, y, width, height)
	self.agui_widget:init(x, y, width, height)

	self.children = {}

	self.cur_focus = 0

	self.agui_widget.fg = 'container-fg'
	self.agui_widget.bg = 'container-bg'

	self.agui_widget:add_flag('active')
end

function Widget:add(child)
	if not child:is_a('agui-widget') then
		error('Invalid Widget', 2)
	end

	child:cast('agui-widget').main = self.agui_widget.main

	table.insert(self.children, child)
end

function Widget:remove(child)
	if type(child) == "number" then
		table.remove(self.children, child)
		return
	end

	for c, wid in ipairs(self.children) do
		if wid.agui_widget.id == child.agui_widget.id then
			table.remove(self.children, c)
			return
		end
	end
end

function Widget:select(child)
	if self:get_focus() then
		if self:get_focus().agui_widget.id == child.agui_widget.id then
			-- Shortcut to avoid bluring an already-selected widget.
			return
		end

		self:get_focus():blur()
	end

	-- for i, c in ipairs(self.children) do
	-- 	if c.agui_widget.id == child.agui_widget.id then
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
	pc:set_bg(self.agui_widget.bg)
	pc:set_fg(self.agui_widget.fg)
	pc:clear()

	self:draw_children(pc, theme)
end

function Widget:draw_children(canvas, theme)
	for i, widget in ipairs(self.children) do
		if i ~= self.cur_focus then
			self.agui_widget:draw_raw(widget, canvas, theme)
		end
	end

	if self:get_focus() then
		self.agui_widget:draw_raw(self:get_focus(), canvas, theme)
	end
end

-- This is a massive hack, but I don't particularly care! :D

function Widget:blur()
	if self:get_focus() then
		self:get_focus():blur()
	end
end

function Widget:focus_next()
	if #self.children == 0 then
		return false
	end

	if self:get_focus() then
		self:get_focus():blur()
	end

	self.agui_widget.dirty = true

	local found = 0

	local start = self.cur_focus

	while found < 2 do
		self.cur_focus = self.cur_focus + 1

		if self.cur_focus > #self.children then
			self.cur_focus = 1

			found = 1 + found
		end

		if self:get_focus():cast('agui-widget'):has_flag('active') 
			and self:get_focus():cast('agui-widget').enabled 
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
		self:_get_focus():cast('agui-widget').main = self.agui_widget.main

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
	if self:get_focus() and in_widget(x, y, self:get_focus().agui_widget) then
		local child = self:get_focus()

		if child:has_flag("active") then
			self:get_focus():clicked(x - child:cast('agui-widget').x + 1, y - child:cast('agui-widget').y + 1, button)

			return
		end
	end

	for _, child in ipairs(self.children) do
		if in_widget(x, y, child.agui_widget) then
			if child:has_flag("active") then
				self:select(child)

				child:clicked(x - child.agui_widget.x + 1, y - child.agui_widget.y + 1, button)
			end
		end
	end
end

function Widget:scroll(x, y, dir)
	if self:get_focus() and in_widget(x, y, self:get_focus().agui_widget) then
		local child = self:get_focus()

		if child:has_flag("active") then
			self:get_focus():scroll(x - child.agui_widget.x + 1, y - child.agui_widget.y + 1, dir)

			return
		end
	end

	for _, child in ipairs(self.children) do
		if in_widget(x, y, child.agui_widget) then
			if child:has_flag("active") then
				self:select(child)

				child:scroll(x - child.agui_widget.x + 1, y - child.agui_widget.y + 1, dir)
			end
		end
	end
end

function Widget:dragged(x_del, y_del, button)
	if self:get_focus() then
		self:get_focus():dragged(x_del, y_del, button)
	end
end
