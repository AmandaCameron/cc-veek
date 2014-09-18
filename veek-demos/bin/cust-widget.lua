local s_dir = "__LIB__/agui/"

if not os.loadAPI(s_dir .. "agui") then
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
agui.log_file(fs.combine('/log', fs.getName(shell.getRunningProgram())))
agui.init()

agui.register_class('example', Widget, 'agui-widget')

local w, h = term.getSize()

w, h = w/2, h/2

local example1 = agui.new('example', 1, 1, math.floor(w), math.floor(h))
local example2 = agui.new('example', math.ceil(w), 1, math.floor(w), math.floor(h))
local example3 = agui.new('example', 1, math.ceil(h), math.floor(w), math.floor(h))
local example4 = agui.new('example', math.ceil(w), math.ceil(h), math.floor(w), math.floor(h))

agui.add(example1)
agui.add(example2)
agui.add(example3)
agui.add(example4)


local quit_label = agui.new('button', (w * 2) - 3, h * 2, 'Quit')

agui.add(quit_label)

agui.hook_event('button_pressed', function(id)
	if id == quit_label.widget.id then
		agui.quit()
	end
end)

agui.main()
