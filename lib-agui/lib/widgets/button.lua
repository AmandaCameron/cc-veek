-- Simple Button for aGUI

_parent = 'agui-label'

function Widget:init(x, y, text, width)
	self.agui_label:init(x, y, text, width)

	self.text = text

	self.agui_widget.fg = 'button--fg'
	self.agui_widget.bg = 'button--bg'

	self.agui_widget:add_flag('active')
end

-- Maybe this should be handled by the toolkit?

function Widget:key(k)
	if k == keys.enter then
		--event.trigger("gui.button.pressed", self.agui_widget.id)
		self.agui_widget:trigger('gui.button.pressed')
	end

	return k == keys.enter
end

function Widget:clicked(x, y, btn)
	--event.trigger("gui.button.pressed", self.agui_widget.id)
	self.agui_widget:trigger('gui.button.pressed')
end
