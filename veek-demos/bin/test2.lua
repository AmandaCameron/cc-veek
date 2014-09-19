if not os.loadAPI('/lib/veek/veek') then
	print("Press any key to reboot.")

	os.pullEvent("key")

	os.reboot()
end


veek.log_file(fs.combine('/log', fs.getName(shell.getRunningProgram())))
veek.init()

local cont = veek.new('container', 12, 5, 20, 5)
cont.widget.fg = 'black'
cont.widget.bg = 'green'


local lbl = veek.new('label', 2, 2, 'Label Test')
local btn = veek.new('button', 17, 5, 'Exit')
btn.widget.bg = 'exit-button--bg'
btn.widget.fg = 'exit-button--fg'

cont:add(lbl)
cont:add(btn)

veek.add(cont)

veek.hook_event('button_pressed', function(id)
		if id == btn.widget.id then
		veek.quit()
	end
end)

veek.main()
