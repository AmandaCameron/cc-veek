local s_dir = "__LIB__/veek/"

if not os.loadAPI(s_dir .. "veek") then
	print("Press any key to reboot.")

	os.pullEvent("key")

	os.reboot()
end


local Widget = {}

function Widget:init(x, y, width, height)
	self.widget:init(x, y, width, height)
end

function Widget:draw(canvas, theme)
	canvas:set_bg(2^math.random(1, 15))

	canvas:clear()
end


fs.makeDir('/log')
veek.log_file(fs.combine('/log', fs.getName(shell.getRunningProgram())))
veek.init()

veek.register_class('example', Widget, 'veek-widget')

local w, h = term.getSize()

w, h = w/2, h/2

local example1 = veek.new('example', 1, 1, math.floor(w), math.floor(h))
local example2 = veek.new('example', math.ceil(w), 1, math.floor(w), math.floor(h))
local example3 = veek.new('example', 1, math.ceil(h), math.floor(w), math.floor(h))
local example4 = veek.new('example', math.ceil(w), math.ceil(h), math.floor(w), math.floor(h))

veek.add(example1)
veek.add(example2)
veek.add(example3)
veek.add(example4)


local quit_label = veek.new('button', (w * 2) - 3, h * 2, 'Quit')

veek.add(quit_label)

veek.hook_event('button_pressed', function(id)
	if id == quit_label.widget.id then
		veek.quit()
	end
end)

veek.main()
