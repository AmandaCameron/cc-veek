_parent = 'agui-widget'

function Widget:init(x, y, width, height, text)
	self.agui_widget:init(x, y, width, height)

	self.agui_widget.fg = 'textbox-fg'
	self.agui_widget.bg = 'textbox-bg'

	self.text = text or ""

	self.agui_widget:add_flag('buffered')
end

function Widget:set_text(new)
	self.text = new

	self.agui_widget.dirty = true
end

function Widget:draw(canvas, theme)
	local text = self.text

	local c = canvas

	c:clear()
	c:move(1, 1)

	for word in text:gmatch("[^%s]*[ \t\n]?") do
			if c.x + #word > c.width then
				if c.y + 1 > c.height then
					break
				end

				c.x = 1
				c.y = c.y + 1
		end

		c:write(word:gsub("\n", ""))

		if word:sub(#word) == "\n" then
			if c.y + 1 > c.height then
				break
			end

			c.x = 1
			c.y = c.y + 1
		end
	end
end
