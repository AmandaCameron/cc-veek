-- Window Object!

_parent = 'object'

function Object:init(app, display)
	self.app = app

	self.display = display
	self.canvas = canvas.new(display, function(c) return app:lookup(c) end, display.getSize())
	self.canvas.buffered = true
	
	self.gooey = new('agui-container', 1, 1, display.getSize())
	self.gooey.agui_widget.main = app
	self.gooey.agui_widget.fg = 'window-body-fg'
	self.gooey.agui_widget.bg = 'window-body-bg'
end

function Object:draw()
    self.canvas:set_bg(self.gooey.agui_widget.bg)
    self.canvas:set_fg(self.gooey.agui_widget.fg)

    self.canvas:clear()

    self.gooey:draw(self.canvas)

    self.canvas:blit(1, 1)
end

-- Gooey constructs.

function Object:add(widget)
	widget.agui_widget.main = self.app
	
	self.gooey:add(widget)
end

function Object:remove(widget)
	self.gooey:remove(widget)
end

function Object:select(widget)
	self.gooey:select(widget)
end

-- Methods for manupulating state.

function Object:resize(w, h)
	if self.display.setSize then
		self.display.setSize(w, h)
		self.gooey:resize(w, h)
	end
end

function Object:set_title(new)
	if self.display.setTitle then
		self.display.setTitle(new)
	end
end

function Object:show()
	if self.display.show then
		self.display.show()
	end
end

function Object:hide()
	if self.display.hide then
		self.display.hide()
	end
end

function Object:add_flag(flag)
	if self.display.setFlags and self.display.getFlags then
		local flags = self.display.getFlags()

		table.insert(flags, flag)

		self.display.setFlags(flags)
	end
end

function Object:remove_flag(flag)
	if self.display.getFlags and self.display.setFlags then
		local new = {}

		for _, f in ipairs(self.display.getFlags()) do
			if flag ~= f then
				table.insert(new, f)
			end
		end

		self.display.setFlags(new)
	end
end

function Object:get_flags()
	if self.display.getFlags then
		return self.display.getFlags()
	end

	return {}
end