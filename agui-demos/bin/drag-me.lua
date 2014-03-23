os.loadAPI("__LIB__/agui/agui")

if not term.isColour() then
  error("This demo requires an advanced computer.")
end

local app = kidven.new("agui-app")

local Widget = {}

function Widget:init()
  self.agui_label:init(1, 1, "Drag Me!")

  self.agui_widget.fg = 'black'
  self.agui_widget.bg = 'white'
end

function Widget:dragged(x_del, y_del, btn)
  self.agui_widget.x = self.agui_widget.x + x_del
  self.agui_widget.y = self.agui_widget.y + y_del

  if self.agui_widget.x < 1 then
    self.agui_widget.x = 1
  end

  if self.agui_widget.y < 1 then
    self.agui_widget.y = 1
  end
end

kidven.register('drag-me', Widget, 'agui-label')

app:add(kidven.new('drag-me'))

app:main()