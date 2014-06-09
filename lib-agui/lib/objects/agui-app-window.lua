--- Represents a logical "window" in agui.
-- @parent object
-- @classmod agui-app-window

-- Window Object!

-- lint-mode: veek-object

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


--- Requests this window be drawed.
function Object:draw()
    canvas:set_bg(self.gooey.agui_widget.bg)
    canvas:set_fg(self.gooey.agui_widget.fg)

    canvas:clear()

    self.gooey:draw(self.canvas)

    canvas:blit(1, 1)
end

-- Gooey constructs.

--- Add a widget to the GUI.
-- @tparam agui-widget widget The widget to add.
function Object:add(widget)
	widget.agui_widget.main = self.app

	self.gooey:add(widget)
end

--- Remove the given widget from the window.
-- @tparam agui-widget widget The widget to remove
function Object:remove(widget)
	self.gooey:remove(widget)
end

--- Select the given widget in the GUI.
-- @tparam agui-widget widget The widget to select.
function Object:select(widget)
	self.gooey:select(widget)
end

-- Methods for manupulating state.

--- Resize the window.
-- @int w The requested content width.
-- @int h The requseted content height.
function Object:resize(w, h)
	if self.display.setSize then
		self.display.setSize(w, h)
		self.gooey:resize(w, h)
	end
end

--- Sets the window's title.
-- @string new The new title.
function Object:set_title(new)
	if self.display.setTitle then
		self.display.setTitle(new)
	end
end


--- Shows the window from a hidden state.
function Object:show()
	if self.display.show then
		self.display.show()
	end
end

--- Hides the window from a shown state.
function Object:hide()
	if self.display.hide then
		self.display.hide()
	end
end

--- Adds the given flag.
-- @string flag The term.newWindow flag to use.
function Object:add_flag(flag)
	if self.display.setFlags and self.display.getFlags then
		local flags = self.display.getFlags()

		table.insert(flags, flag)

		self.display.setFlags(flags)
	end
end

--- Removes the given flag.
-- @string flag The term.newWindow spec flag to remove.
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

--- Gets the active flags.
-- @treturn table The currently-active flags.
function Object:get_flags()
	if self.display.getFlags then
		return self.display.getFlags()
	end

	return {}
end
