-- This is an agui-app-window subclass that is backed by a agui-window instance inside of an agui-app's main_window
-- This should only get used by the agui-app instance when the term.newWindow protocol is unavailable.

_parent = 'agui-app-window'

function Object:init(app, title, width, height)
	self.agui_app_window.app = app

	local win = new('agui-window', title, width, height)

	win.agui_widget.x = math.floor(app.main_window.gooey.agui_widget.width / 2 - width / 2)
	win.agui_widget.y = math.floor(app.main_window.gooey.agui_widget.height / 2 - height / 2)

	self.agui_app_window.gooey = win

	app:subscribe('gui.window.closed', function(_, id)
		if id == win.agui_widget.id then
			app:trigger('window.closed', self.id)
		end
	end)

	app:subscribe('gui.window.resize', function(_, id)
		if id == win.agui_widget.id then
			app:trigger('window.resized', self.id)
		end
	end)


	-- Nasty hack. But nessary (for now.)
	local blur_timer = -1

	app:subscribe('gui.window.blur', function(_, id)
		if id == win.agui_widget.id and win.flags.modal then
			blur_timer = os.startTimer(0.02)
		end
	end)

	app:subscribe('event.timer', function(_, timer)
		if timer == blur_timer then
			app:select(win)
		end
	end)

	-- Display ourselves.

	self:show()
end

function Object:set_title(new)
	self.agui_app_window.gooey.title = new
end

function Object:resize(w, h)
	self.agui_app_window.gooey:resize(w, h)
end

function Object:show()
	self.agui_app_window.app:add(self.agui_app_window.gooey)
	self.agui_app_window.app:select(self.agui_app_window.gooey)
end

function Object:hide()
	self.agui_app_window.app:remove(self.agui_app_window.gooey)
end

function Object:add_flag(flag)
	self.agui_app_window.gooey.flags[flag] = true
end

function Object:remove_flag(flag)
	self.agui_app_window.gooey.flags[flag] = nil
end

function Object:get_flags()
	local flags = {}

	for flag, _ in pairs(self.gooey.flags) do
		table.insert(flags, flag)
	end

	return flags
end

function Object:draw()
	-- Do Nothing, the main_window draw pump handles this for us.
end