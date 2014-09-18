if not os.loadAPI('/lib/agui/agui') then
	print("Press any key to reboot.")

	os.pullEvent("key")

	os.reboot()
end

agui.log_file(fs.combine('/log', fs.getName(shell.getRunningProgram())))
agui.init()

local lbl = agui.new('label', 2, 2, 'Testificate!')
local inp = agui.new('input', 2, 3, 20)
local cb = agui.new('checkbox', 22, 3, 'Enable')
cb.input.value = true

local lbl2 = agui.new('label', 2, 4, 'Type to change me!')

local btn = agui.new('button', 48, 19, 'Exit')
btn.widget.fg = 'exit-button--fg'
btn.widget.bg = 'exit-button--bg'


agui.add(lbl)
agui.add(inp)
agui.add(cb)
agui.add(btn)
agui.add(lbl2)

agui.hook_event('button_pressed', function(id)
		if id == btn.widget.id then
		agui.quit()
	end
end)

agui.hook_event('value_changed', function(id, value)
	if id == inp.widget.id then
		lbl2.text = value
	elseif id == cb.widget.id then
		inp:set_enabled(value)
		if value then
			lbl2.text = 'Type to change me!'
			inp.value = ''
		else
			lbl2.text = 'Disabled.'
		end
	end
end)

agui.main()