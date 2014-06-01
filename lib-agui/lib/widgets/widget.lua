-- Base Widget for aGUI

-- lint-mode: veek-widget

_parent = 'object'

local _wid_ids = 1

function Widget:init(x, y, width, height)
	self.x = math.floor(x)
	self.y = math.floor(y)
	self.width = math.floor(width)
	self.height = math.floor(height)

	self.main = nil

	self.id = _wid_ids
	_wid_ids = _wid_ids + 1

	self.fg = 'white'
	self.bg = 'black'

	self.dirty = false
	self._canvas = nil

	self.enabled = true

	self.flags = {}
end

function Widget:add_flag(flag)
	table.insert(self.flags, flag)
end

function Widget:has_flag(flag)
	for _,f in pairs(self.flags) do
		if f == flag then
			return true
		end
	end

	return false
end

function Widget:trigger(evt, ...)
	if self.main then
		self.main:cast('event-loop'):trigger(evt, self.id, ...)
	end
end

function Widget:set_enabled(enabled)
	self.enabled = enabled

	self.dirty = true
end

function Widget:focus()
	self.focused = true

	self.dirty = true
end

function Widget:blur()
	self.focused = false

	self.dirty = true
end

function Widget:move(x, y)
	self.x = math.floor(x)
	self.y = math.floor(y)

	self.dirty = true
end

function Widget:resize(width, height)
	self.width = math.floor(width)
	self.height = math.floor(height)

	self.dirty = true
end


function Widget:draw(canvas)
	-- Do Nothing
end

function Widget:clicked(x, y, button)
	-- Do Nothing
end

function Widget:dragged(x_del, y_del, button)
	-- Do Nothing.
end

function Widget:scroll(x, y, direction)
	-- Do Nothing.
end

function Widget:key(key)
	return false
end

function Widget:char(ch)
	-- Do Nothing.
end

-- Helper functions for draw_raw

function Widget:resolve_colours()
	local fg = self.fg or 'transparent'
	local bg = self.bg or 'transparent'

	if self.focused then
		fg = fg:gsub('([-][-])', '-focused-', 1)
		bg = bg:gsub('([-][-])', '-focused-', 1)
	elseif not self.enabled then
		fg = fg:gsub('([-][-])', '-disabled-', 1)
		bg = bg:gsub('([-][-])', '-disabled-', 1)
	else
		fg = fg:gsub('([-][-])', '-', 1)
		bg = bg:gsub('([-][-])', '-', 1)
	end

	return fg, bg
end

function Widget:prep_canvas(widget, c)
	local w_fg, w_bg = widget:resolve_colours()
	local p_fg, p_bg = self:resolve_colours()

	if w_fg ~= 'transparent' then
		c:set_fg(w_fg)
	else
		c:set_fg(p_fg)
	end

	if w_bg ~= 'transparent' then
		c:set_bg(w_bg)
	else
		c:set_bg(p_bg)
	end
end

-- This should NOT be over-written

function Widget:draw_raw(widget, pc, theme)
	pc:push()

	if widget:cast('agui-widget'):has_flag('buffered') then
		if not widget:cast('agui-widget').canvas or widget:cast('agui-widget').dirty then
			widget:cast('agui-widget').canvas = canvas.new(
				pc.ctx,
				pc.lookup,
				widget:cast('agui-widget').width,
				widget:cast('agui-widget').height,
				true)

			widget:cast('agui-widget').dirty = true
		end

		if widget:cast('agui-widget').dirty then
			self:prep_canvas(widget, widget:cast('agui-widget').canvas)

			widget:draw(widget:cast('agui-widget').canvas, theme)
		end

		widget:cast('agui-widget').canvas:blit(1, 1,
			nil, nil,
			pc:as_redirect(widget:cast('agui-widget').x, widget:cast('agui-widget').y, widget:cast('agui-widget').width, widget:cast('agui-widget').height))
	else
		local c = pc:sub(widget:cast('agui-widget').x, widget:cast('agui-widget').y, widget:cast('agui-widget').width, widget:cast('agui-widget').height)

		c:set_cursor(1, 1, false)

		self:prep_canvas(widget, c)

		widget:draw(c, theme)
	end

	pc:pop()
end
