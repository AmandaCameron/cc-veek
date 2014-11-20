--- TextBox widget.
-- This is a wraping text display widget. It can also scroll it's contents.
-- @parent veek-scroll-view
-- @widget veek-textbox

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

	self.text = veek.attrib_string(text or "")
end

function Widget:set_text(new)
	self.text = veek.attrib_string(new)

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

	for word in text:split("[ \t\n]") do
		if x + word:length() > self.veek_widget.width then
			x = 1
			lines = lines + 1
		end

		x = x + word:length() + 1

		if word:string() == "" then
			lines = lines + 1

			x = 1
		end
	end

	return self.veek_widget.width, lines
end

function Widget:draw_contents(c, theme)
	local text = self.text

	for word in text:split("[ \t\n]") do
		if c.x + word:length() > c.width then
			c.x = 1
			c.y = c.y + 1
		end

		word:render(c)
		c:write(" ")

		if word:string() == "" then
			c.x = 1
			c.y = c.y + 1

			sleep(0.05)
		end
	end
end
