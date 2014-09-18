if not os.loadAPI('/lib/agui/agui') then
	print("Press any key to reboot.")

	os.pullEvent("key")

	os.reboot()
end


agui.log_file(fs.combine('/log', fs.getName(shell.getRunningProgram())))
agui.init()

local win = agui.new('window', 'Cheese Demo', 25, 7)

win.widget.fg = 'black'
win.widget.bg = 'green'


local lbl = agui.new('label', 2, 2, 'Label Test')
local btn = agui.new('button', 2, 3, 'Button Test')

local width, height = term.getSize()

local textbox = agui.new('textbox', 1, 1, width, height)

textbox.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vel tellus vitae mi dictum  \
accumsan. Suspendisse faucibus, sapien ut auctor venenatis, lectus dolor suscipit lorem, id \
ultricies mi lorem ut velit. Etiam sed euismod sem. Ut vitae orci dui, ut vulputate sem. \
Sed ligula justo, interdum quis fringilla ullamcorper, consectetur ac metus. Integer ut urna vel \
diam vehicula varius id lacinia ante. Pellentesque habitant morbi tristique senectus et netus et \
malesuada fames ac turpis egestas. Donec dignissim adipiscing diam ut blandit. Aliquam ac nibh in \
orci ornare facilisis.\
\
Vestibulum adipiscing porta est, non rutrum dui porttitor ut. Duis venenatis dolor sit amet diam auctor \
eu vestibulum quam commodo. In et tortor libero. Aliquam ornare volutpat arcu, at varius dui dapibus eu.\
Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In feugiat, elit sed\
iaculis porttitor, lacus turpis facilisis lorem, in faucibus dui metus eget neque. Suspendisse varius \
vestibulum aliquam. Curabitur malesuada bibendum tincidunt. Nulla lobortis, diam sed adipiscing rutrum,\
risus libero scelerisque mi, vitae mollis ligula nibh vel dui.\
\
Nam imperdiet nibh vel justo vestibulum gravida. Donec turpis lectus, laoreet at tincidunt et, pharetra nec odio. \
Nam lobortis dignissim libero, at vulputate purus luctus fermentum. Sed ligula est, condimentum vitae pellentesque\
adipiscing, viverra quis ipsum. Morbi luctus cursus nulla, vitae rutrum eros fringilla quis. Cras \
pretium venenatis varius. Sed sollicitudin tellus ut neque vestibulum aliquam. Pellentesque fringilla, est\
vitae bibendum tincidunt, dui nisl tincidunt eros, vel placerat risus ipsum non dui. Praesent feugiat \
vestibulum malesuada. Integer interdum sapien nec dolor tincidunt vitae dignissim magna ultrices.\
\
Pellentesque et felis nibh, vel tempor tellus. Suspendisse quis vehicula leo. Pellentesque eget viverra\
libero. Nulla nec nulla velit. Morbi sem erat, hendrerit a euismod rutrum, scelerisque quis mi.\
Mauris sed nulla sem, a tristique purus. Ut molestie nisl eget risus imperdiet varius.\
\
Phasellus volutpat ultricies mauris, quis euismod dolor gravida eget. Aliquam erat volutpat.\
In a ipsum mi. Vestibulum posuere lorem ac nisi mattis lobortis. Nulla facilisi. Integer \
pharetra ullamcorper ullamcorper. Proin lacus nulla, fringilla ut scelerisque ut, sagittis non felis.\
Sed luctus sapien quis leo consectetur at interdum sem fermentum.\
"

win:add(lbl)
win:add(btn)

agui.add(textbox)
agui.add(win)

agui.hook_event('button_pressed', function(id)
		if id == btn.widget.id then
		agui.quit()
	end
end)

agui.main()