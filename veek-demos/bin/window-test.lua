-- This is a simple test window thingy for lib-veek

os.loadAPI("__LIB__/veek/veek")

local app = kidven.new('veek-app')

local main_label = kidven.new('veek-label', 1, 1, "I'm the main window!");

app:add(main_label)

local window = app:new_window("Hullo", 15, 3)

window:add(kidven.new('veek-label', 2, 2, "ADORE ME!"))
window:add_flag('closable')

app:subscribe('window.closed', function(_, id)
	if id == window.id then
		app:quit()
	end
end)

app:main()
