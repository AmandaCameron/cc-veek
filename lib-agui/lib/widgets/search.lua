-- lint-mode: veek-widget

_parent = 'agui-container'

function Widget:init(w, h)
	self.agui_container:init(1, 1, w, h)

	self.input_box = new("agui-input", 1, 1, w)
	self.results = new("agui-list", 1, 2, w, h - 1)

	self.results.agui_widget.y = 2

	self.agui_container:add(self.input_box)
	self.agui_container:add(self.results)
end

function Widget:key(k)
	if k == keys.enter then
		self.agui_widget:trigger("gui.search.selected", self.results:get_current())

		return true
	elseif k == keys.backspace then
		self.input_box:key(k)

		self.results:clear()

		self.agui_widget:trigger('gui.search.input', self.input_box.value)

		return true
	else
		return self.results:key(k)
	end

end

function Widget:char(c)
	self.input_box:char(c)

	self.results:clear()

	self.agui_widget:trigger('gui.search.input', self.input_box.value)

	return true
end

function Widget:resize(w, h)
	self.agui_widget:resize(w, h)

	self.input_box:resize(w, 1)
	self.results:resize(w, h - 1)
end
