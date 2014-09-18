os.loadAPI("__LIB__/agui/agui")

local app = kidven.new('agui-app')

local window = kidven.new('agui-window', 'Login', 12, 6)

local w, h = term.getSize()

window:move(w / 2 - 6, h / 2 - 3)

window:add(kidven.new('agui-label', 2, 1, 'Username'))
window:add(kidven.new('agui-label', 2, 3, 'Password'))

local usr_name = kidven.new('agui-input', 2, 2, 10)
local passwd = kidven.new('agui-input', 2, 4, 10)
passwd.placeholder = '*'

window:add(usr_name)
window:add(passwd)

local login = kidven.new('agui-button', 5, 6, 'Login')

window:add(login)

app:subscribe('gui.button.pressed', function(_, id)
  if usr_name.value == "user" and passwd.value == "password" then
    app:quit()
  end
end)

app:add(window)

app:main()