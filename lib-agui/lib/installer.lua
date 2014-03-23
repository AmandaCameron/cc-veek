local files = {
	-- Core Objects.
	["base.lua"] = "agui",
	["main.lua"] = "main",
	["logging.lua"] = "logging",
	["canvas.lua"] = "canvas",
	-- Themes
	["themes/no_colour.lua"] = "themes/no_colour",
	["themes/colour.lua"] = "themes/colour",
	-- Basic Building Blocks
	["widgets/widget.lua"] = "widgets/widget",
	["widgets/container.lua"] = "widgets/container",
	-- Input Elements.
	["widgets/input.lua"] = "widgets/input",
	["widgets/checkbox.lua"] = "widgets/checkbox",	
	["widgets/button.lua"] = "widgets/button",
	-- Display-Onlu
	["widgets/textbox.lua"] = "widgets/textbox",
	["widgets/label.lua"] = "widgets/label",
	-- Misc.
	["widgets/window.lua"] = "widgets/window",
	-- Demos
	["demo/cust-widget.lua"] = "demo/cust-widget",
	["demo/login-dialog.lua"] = "demo/login-dialog",
}

local args = {...}

if #args ~= 1 then
	print("Usage: " .. shell.getRunningProgram() .. " <install-dir>")
	return
end

if not http then
	print("This program requires HTTP Access. (How did you even get it?)")
	return
end

local install_dir = '/' .. shell.resolve(args[1])

if not fs.exists(install_dir) then
	fs.makeDir(install_dir)
end

if not fs.isDir(install_dir) then
	print('Install directory must be directory.')
	return
end

fs.makeDir(install_dir .. "/demo")
fs.makeDir(install_dir .. "/widgets")
fs.makeDir(install_dir .. "/themes")

for r_name, l_name in pairs(files) do
	print("Getting " .. r_name)
	local r_file = http.get('http://amanda.darkdna.net/mc/agui/' .. r_name)

	if not r_file then
		error('Unable to get remote file ' .. r_name)
	end

	local l_file = fs.open(install_dir .. "/" .. l_name, "w")

	if not l_file then
		error('Unable to open local file ' .. install_dir .. "/" .. l_name)
	end

	local first_line = r_file.readLine()

	if first_line == 'local s_dir = "/lib/agui/"' then
		l_file.write('s_dir = "' .. install_dir .. '/"\n')
	else
		l_file.write(first_line .. "\n")
	end

	l_file.write(r_file.readAll())

	l_file.close()
	r_file.close()
end

print("Done.")