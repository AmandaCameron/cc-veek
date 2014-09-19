if not os.loadAPI('/lib/veek/veek') then
	print("Press any key to reboot.")

	os.pullEvent("key")

	os.reboot()
end

veek.log_file(fs.combine('/log', fs.getName(shell.getRunningProgram())))
veek.init()

local lbl = veek.new('label', 2, 2, 'Testificate!')
local inp = veek.new('input', 2, 3, 20)
local cb = veek.new('checkbox', 22, 3, 'Enable')
cb.input.value = true

local lbl2 = veek.new('label', 2, 4, 'Type to change me!')

local btn = veek.new('button', 48, 19, 'Exit')
btn.widget.fg = 'exit-button--fg'
btn.widget.bg = 'exit-button--bg'


veek.add(lbl)
veek.add(inp)
veek.add(cb)
veek.add(btn)
veek.add(lbl2)

veek.hook_event('button_pressed', function(id)
		if id == btn.widget.id then
		veek.quit()
	end
end)

veek.hook_event('value_changed', function(id, value)
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

veek.main()
