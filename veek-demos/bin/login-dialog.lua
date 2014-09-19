os.loadAPI("__LIB__/veek/veek")

local app = kidven.new('veek-app')

local window = kidven.new('veek-window', 'Login', 12, 6)

local w, h = term.getSize()

window:move(w / 2 - 6, h / 2 - 3)

window:add(kidven.new('veek-label', 2, 1, 'Username'))
window:add(kidven.new('veek-label', 2, 3, 'Password'))

local usr_name = kidven.new('veek-input', 2, 2, 10)
local passwd = kidven.new('veek-input', 2, 4, 10)
passwd.placeholder = '*'

window:add(usr_name)
window:add(passwd)

local login = kidven.new('veek-button', 5, 6, 'Login')

window:add(login)

app:subscribe('gui.button.pressed', function(_, id)
  if usr_name.value == "user" and passwd.value == "password" then
    app:quit()
  end
end)

app:add(window)

app:main()
