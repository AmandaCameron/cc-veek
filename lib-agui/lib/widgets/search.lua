--- Search + Results Widget.
-- This shows a combination of an agui-input and an agui-list for displaying
-- a search field in a consistant way.
-- @classmod agui-search

--------
-- Input Changed.
-- This is triggered when the user adds or removes text from the widget.
-- Note that before this event is fired, the results list is emptied.
-- @event gui.search.input
-- @int id The search widget ID.
-- @string input The current input of the search widget.

--------
-- Result Selected.
-- This is fired when a result is selected by the user.
-- @event gui.search.selected
-- @int id The search widget ID.
-- @tparam agui-list-item selection The selected item.

-- lint-mode: veek-widget

_parent = 'agui-container'

--- Initalise the agui-search widget.
-- @int w Search widget's width.
-- @int h Search widget's height.
function Widget:init(w, h)
	self.agui_container:init(1, 1, w, h)

	self.input_box = new("agui-input", 1, 1, w)
	self.results = new("agui-list", 1, 2, w, h - 1)

	self.results.agui_widget.y = 2

	self.agui_container:add(self.input_box)
	self.agui_container:add(self.results)

	self.agui_container:select(self.input_box)
end

function Widget:focus()
	self.input_box:focus()
	self.results:focus()
end

function Widget:blur()
	self.input_box:blur()
	self.results:blur()
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
