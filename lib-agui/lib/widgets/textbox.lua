_parent = 'agui-scroll-view'

function Widget:init(x, y, width, height, text)
	self.agui_scroll_view:init(width, height)

	self.agui_widget.fg = 'textbox-fg'
	self.agui_widget.bg = 'textbox-bg'

	self.agui_scroll_view.draw_contents = function(c)
		self:draw_contents(c)
	end

	self.agui_scroll_view.get_size = function()
		return self:get_size()
	end

	self.text = text or ""
end

function Widget:set_text(new)
	self.text = new

	self.agui_scroll_view:reflow()
end

function Widget:resize(w, h)
	self.agui_widget:resize(w, h)

	self.agui_scroll_view:reflow()
end

-- Scroll View API

function Widget:get_size()
	local lines = 1

	local text = self.text
	local x = 1

	for word in text:gmatch("[^%s]*[ \t\n]?") do
		if x + #word > self.agui_widget.width then
			x = 1
			lines = lines + 1
		end

		x = x + #word

		if word:sub(#word) == "\n" then
			lines = lines + 1

			x = 1
		end
	end

	return self.agui_widget.width, lines
end

function Widget:draw_contents(c, theme)
	local text = self.text

	for word in text:gmatch("[^%s]*[ \t\n]?") do
		if c.x + #word > c.width then
			c.x = 1
			c.y = c.y + 1
		end

		c:write(word:gsub("\n", ""))

		if word:sub(#word) == "\n" then
			c.x = 1
			c.y = c.y + 1
		end
	end
end
