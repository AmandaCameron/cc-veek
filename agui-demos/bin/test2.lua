if not os.loadAPI('/lib/agui/agui') then
	print("Press any key to reboot.")

	os.pullEvent("key")

	os.reboot()
end


agui.log_file(fs.combine('/log', fs.getName(shell.getRunningProgram())))
agui.init()

local cont = agui.new('container', 12, 5, 20, 5)
cont.widget.fg = 'black'
cont.widget.bg = 'green'


local lbl = agui.new('label', 2, 2, 'Label Test')
local btn = agui.new('button', 17, 5, 'Exit')
btn.widget.bg = 'exit-button--bg'
btn.widget.fg = 'exit-button--fg'

cont:add(lbl)
cont:add(btn)

agui.add(cont)

agui.hook_event('button_pressed', function(id)
		if id == btn.widget.id then
		agui.quit()
	end
end)

agui.main()