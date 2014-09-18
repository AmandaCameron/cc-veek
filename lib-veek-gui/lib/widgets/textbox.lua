--- TextBox widget.
-- This is a wraping text display widget. It can also scroll it's contents.
-- @parent veek-scroll-view
-- @classmod veek-textbox

-- lint-mode: veek-widget

_parent = 'veek-scroll-view'

function Widget:init(x, y, width, height, text)
	self.veek_scroll_view:init(width, height)

	self.veek_widget.fg = 'textbox-fg'
	self.veek_widget.bg = 'textbox-bg'

	self.veek_scroll_view.draw_contents = function(c)
		self:draw_contents(c)
	end

	self.veek_scroll_view.get_size = function()
		return self:get_size()
	end

	self.text = text or ""
end

function Widget:set_text(new)
	self.text = new

	self.veek_scroll_view:reflow()
end

function Widget:resize(w, h)
	self.veek_widget:resize(w, h)

	self.veek_scroll_view:reflow()
end

-- Scroll View API

function Widget:get_size()
	local lines = 1

	local text = self.text
	local x = 1

	for word in text:gmatch("[^%s]*[ \t\n]?") do
		if x + #word > self.veek_widget.width then
			x = 1
			lines = lines + 1
		end

		x = x + #word

		if word:sub(#word) == "\n" then
			lines = lines + 1

			x = 1
		end
	end

	return self.veek_widget.width, lines
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