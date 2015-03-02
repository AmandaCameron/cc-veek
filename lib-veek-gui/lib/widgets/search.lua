--- Search + Results Widget.
-- This shows a combination of an veek-input and an veek-list for displaying
-- a search field in a consistant way.
-- @widget veek-search

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
-- @tparam veek-list-item selection The selected item.

-- lint-mode: veek-widget

_parent = 'veek-container'

--- Initalise the veek-search widget.
-- @int w Search widget's width.
-- @int h Search widget's height.
function Widget:init(w, h)
	self.veek_container:init(1, 1, w, h)

	self.input_box = new("veek-input", 1, 1, w)
	self.results = new("veek-list", 1, 2, w, h - 1)

	self.results.veek_widget.y = 2

	self.veek_container:add(self.input_box)
	self.veek_container:add(self.results)

	self.veek_container:select(self.input_box)
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
		self.veek_widget:trigger("gui.search.selected", self.results:get_current())

		return true
	elseif k == keys.backspace then
		self.input_box:key(k)

		self.results:clear()

		self.veek_widget:trigger('gui.search.input', self.input_box.value)

		return true
	else
		return self.results:key(k)
	end

end

function Widget:clicked(x, y, btn)
	self.veek_container:clicked(x, y, btn)
	
	self:focus()
end

function Widget:char(c)
	self.input_box:char(c)

	self.results:clear()

	self.veek_widget:trigger('gui.search.input', self.input_box.value)

	return true
end

function Widget:resize(w, h)
	self.veek_widget:resize(w, h)

	self.input_box:resize(w, 1)
	self.results:resize(w, h - 1)
end
