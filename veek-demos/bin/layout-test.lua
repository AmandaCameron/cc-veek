-- veek-layout test code.

os.loadAPI("__LIB__/kidven/kidven")
os.loadAPI("__LIB__/veek/veek")

-- Box Widget

local Widget = {}

function Widget:init(...)
  self.veek_widget:init(...)
end

function Widget:draw(c)
  c:clear()
end

kidven.register('example-box', Widget, 'veek-widget')

-- Main Code

local w, h = term.getSize()

local app = kidven.new('veek-app')

local top_middle_lbl = kidven.new('veek-label', 1, 1, 'Top Middle: XX,XX')
local bottom_right_lbl = kidven.new('veek-label', 1, 2, 'Bottom Right: XX,XX')
local bottom_left_lbl = kidven.new('veek-label', 1, 3, 'Bottom Left: XX, XX')
local middle_lbl = kidven.new('veek-label', 1, 4, 'Middle: XX,XX XXxXX')

app:add(top_middle_lbl)
app:add(bottom_right_lbl)
app:add(bottom_left_lbl)
app:add(middle_lbl)

local window = app:new_window('Foo Bar', 10, 5)

window:add_flag('resizable')

local layout = kidven.new('veek-layout', window:cast('veek-app-window').gooey)

local middle = kidven.new('example-box', 2, 2, 8, 3)
middle.veek_widget.fg = 'pink'
middle.veek_widget.bg = 'pink'

layout:add(middle)
layout:add_anchor(middle, 'left', 'left', -1, 1)
layout:add_anchor(middle, 'top', 'top', -1, 1)
layout:add_anchor(middle, 'right', 'right', -1, 1)
layout:add_anchor(middle, 'bottom', 'bottom', -1, 1)

local bottom_right = kidven.new('veek-button', 10, 5, '/')

layout:add(bottom_right)
layout:add_anchor(bottom_right, 'left', 'right', -1, 0)
layout:add_anchor(bottom_right, 'top', 'bottom', -1, 0)

local top_middle = kidven.new('veek-button', 1, 1, ' ^ ')

layout:add(top_middle)
layout:add_anchor(top_middle, 'top', 'top', -1, 0)
layout:add_anchor(top_middle, 'left', 'middle', -1, 0)

local bottom_left = kidven.new('veek-button', 1, 1, '\\')

layout:add(bottom_left)
layout:add_anchor(bottom_left, 'left', 'left', -1, 0)
layout:add_anchor(bottom_left, 'top', 'bottom', -1, 0)


layout:reflow()

top_middle_lbl.text = 'Top Middle: ' .. top_middle:cast('veek-widget').x .. "," .. top_middle:cast('veek-widget').y
bottom_right_lbl.text = 'Bottom Right: ' .. bottom_right.veek_widget.x .. ',' .. bottom_right.veek_widget.y
bottom_left_lbl.text = 'Bottom Left: ' .. bottom_left.veek_widget.x .. ',' .. bottom_left.veek_widget.y
middle_lbl.text = 'Middle: ' .. middle:cast('veek-widget').x .. ',' .. middle:cast('veek-widget').y .. ' ' .. middle:cast('veek-widget').width .. 'x' .. middle:cast('veek-widget').height

app:subscribe('window.resized', function(_, id)
  local ok, err = pcall(function()
    layout:reflow()

    top_middle_lbl.text = 'Top Middle: ' .. top_middle:cast('veek-widget').x .. "," .. top_middle:cast('veek-widget').y
    bottom_right_lbl.text = 'Bottom Right: ' .. bottom_right.veek_widget.x .. ',' .. bottom_right.veek_widget.y
    bottom_left_lbl.text = 'Bottom Left: ' .. bottom_left.veek_widget.x .. ',' .. bottom_left.veek_widget.y
    middle_lbl.text = 'Middle: ' .. middle:cast('veek-widget').x .. ',' .. middle:cast('veek-widget').y .. ' ' .. middle:cast('veek-widget').width .. 'x' .. middle:cast('veek-widget').height
  end)

  if not ok then
    app.main_err = err
    app:quit()
  end
end)

app:main()
