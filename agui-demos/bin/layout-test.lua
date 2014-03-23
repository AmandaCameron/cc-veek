-- agui-layout test code.

os.loadAPI("__LIB__/kidven/kidven")
os.loadAPI("__LIB__/agui/agui")

-- Box Widget

local Widget = {}

function Widget:init(...)
  self.agui_widget:init(...)
end

function Widget:draw(c)
  c:clear()
end

kidven.register('example-box', Widget, 'agui-widget')

-- Main Code

local w, h = term.getSize()

local app = kidven.new('agui-app')

local top_middle_lbl = kidven.new('agui-label', 1, 1, 'Top Middle: XX,XX')
local bottom_right_lbl = kidven.new('agui-label', 1, 2, 'Bottom Right: XX,XX')
local bottom_left_lbl = kidven.new('agui-label', 1, 3, 'Bottom Left: XX, XX')
local middle_lbl = kidven.new('agui-label', 1, 4, 'Middle: XX,XX XXxXX')

app:add(top_middle_lbl)
app:add(bottom_right_lbl)
app:add(bottom_left_lbl)
app:add(middle_lbl)

local window = app:new_window('Foo Bar', 10, 5)

window:add_flag('resizable')

local layout = kidven.new('agui-layout', window:cast('agui-app-window').gooey)

local middle = kidven.new('example-box', 2, 2, 8, 3)
middle.agui_widget.fg = 'pink'
middle.agui_widget.bg = 'pink'

layout:add(middle)
layout:add_anchor(middle, 'left', 'left', -1, 1)
layout:add_anchor(middle, 'top', 'top', -1, 1)
layout:add_anchor(middle, 'right', 'right', -1, 1)
layout:add_anchor(middle, 'bottom', 'bottom', -1, 1)

local bottom_right = kidven.new('agui-button', 10, 5, '/')

layout:add(bottom_right)
layout:add_anchor(bottom_right, 'left', 'right', -1, 0)
layout:add_anchor(bottom_right, 'top', 'bottom', -1, 0)

local top_middle = kidven.new('agui-button', 1, 1, ' ^ ')

layout:add(top_middle)
layout:add_anchor(top_middle, 'top', 'top', -1, 0)
layout:add_anchor(top_middle, 'left', 'middle', -1, 0)

local bottom_left = kidven.new('agui-button', 1, 1, '\\')

layout:add(bottom_left)
layout:add_anchor(bottom_left, 'left', 'left', -1, 0)
layout:add_anchor(bottom_left, 'top', 'bottom', -1, 0)


layout:reflow()

top_middle_lbl.text = 'Top Middle: ' .. top_middle:cast('agui-widget').x .. "," .. top_middle:cast('agui-widget').y
bottom_right_lbl.text = 'Bottom Right: ' .. bottom_right.agui_widget.x .. ',' .. bottom_right.agui_widget.y
bottom_left_lbl.text = 'Bottom Left: ' .. bottom_left.agui_widget.x .. ',' .. bottom_left.agui_widget.y
middle_lbl.text = 'Middle: ' .. middle:cast('agui-widget').x .. ',' .. middle:cast('agui-widget').y .. ' ' .. middle:cast('agui-widget').width .. 'x' .. middle:cast('agui-widget').height

app:subscribe('window.resized', function(_, id)
  local ok, err = pcall(function()
    layout:reflow()

    top_middle_lbl.text = 'Top Middle: ' .. top_middle:cast('agui-widget').x .. "," .. top_middle:cast('agui-widget').y
    bottom_right_lbl.text = 'Bottom Right: ' .. bottom_right.agui_widget.x .. ',' .. bottom_right.agui_widget.y
    bottom_left_lbl.text = 'Bottom Left: ' .. bottom_left.agui_widget.x .. ',' .. bottom_left.agui_widget.y
    middle_lbl.text = 'Middle: ' .. middle:cast('agui-widget').x .. ',' .. middle:cast('agui-widget').y .. ' ' .. middle:cast('agui-widget').width .. 'x' .. middle:cast('agui-widget').height
  end)

  if not ok then
    app.main_err = err
    app:quit()
  end
end)

app:main()